Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEEA52DBB0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbiESRrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243060AbiESRrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:47:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2A1AEE06;
        Thu, 19 May 2022 10:47:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j28so7849821eda.13;
        Thu, 19 May 2022 10:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D4k2Cw/q+uLcOmHvMcwyqwODol2Cgrrywr4+z4BP+Lk=;
        b=NZPGC7mywR1LSs2MSRmrfM4/G/baLwFQDvGchz97c8iZD56lxjV1MSLz6EO9Bmqycp
         +LBcGEilfziTMQbD51XBtzuvuWcNoiEERJVtKWcodvfdzmv1EzpLIkPNk0gBJhHh5NvV
         4gN4DeKnyBMxP7bP8BSjAnBu8r71waxkoH8VzneeN4iMmDwkVfdn8GtqA9hxGJg7tAzD
         9TV2L5UsQ6iO2rZCR9ltcZxgJ5gPzDkSVvgIdIrbphrzFEyNTT0J96t9soeRjz1VoYSN
         YSj2fJEjzDzOI48NriXmUl2Mm2NNG+yPFkFRxy1v9LCSCRzRcLp8uw9ZSQV88pwBdOMA
         8VJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D4k2Cw/q+uLcOmHvMcwyqwODol2Cgrrywr4+z4BP+Lk=;
        b=rCpy/EKe0yfa3yjzzzt2vbSLiwxJPh0w1i8jyrn8kFHRr2YGeAfux2MgchxVyyVQdc
         lcPEB6wj1PLxfzAh1TAyZ6QYitpP5rp/QymLoQs2wwmN0ZEF3CF98z5pNKTyyajGCw2j
         u8YUbYh+dSAX6k/7vwTJW4ecF8/0b9fSFp67ShaLHXb36VU+XnWaOAb6fII2UvIitAr0
         J1lMmVga55jnEbgk0W9uBz+WZX17v3Vwpwthrf01OzdBMLznTeLikZ1cmDqvhgC+ujUt
         yiTPXaJ6M62OsaEK6O3uib+PGYJsDR/VuhCXU+EE6OFfPp3vGQZcd6VKshI5YEagXdSG
         GL+w==
X-Gm-Message-State: AOAM5306jXqS8wFOzcNnzabaFuWtnYA+DQypwFLQig/w3alxP3EIOUMd
        HfL5jh3UKO8Pe7H+534qan0=
X-Google-Smtp-Source: ABdhPJy8cba/ZR+Bc/OsuDsZdhEjG0c3LHE6ylNUPUNaNp+5puwC0FD6yE2qXSimyuSWh4PQ34bkAA==
X-Received: by 2002:a05:6402:3509:b0:427:e7db:1513 with SMTP id b9-20020a056402350900b00427e7db1513mr6598861edd.407.1652982460989;
        Thu, 19 May 2022 10:47:40 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id v2-20020a17090651c200b006f3ef214e20sm2362633ejk.134.2022.05.19.10.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:47:40 -0700 (PDT)
Date:   Thu, 19 May 2022 20:47:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: lantiq_gswip: Fix start index
 in gswip_port_fdb()
Message-ID: <20220519174738.bgsxpzu5fh4yz6ij@skbuf>
References: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
 <20220518220051.1520023-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518220051.1520023-2-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 12:00:50AM +0200, Martin Blumenstingl wrote:
> The first N entries in priv->vlans are reserved for managing ports which
> are not part of a bridge. Use priv->hw_info->max_ports to consistently
> access per-bridge entries at index 7. Starting at
> priv->hw_info->cpu_port (6) is harmless in this case because
> priv->vlan[6].bridge is always NULL so the comparison result is always
> false (which results in this entry being skipped).
> 
> Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
