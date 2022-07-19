Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAD257A048
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiGSODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGSODi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:03:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BBB422E9;
        Tue, 19 Jul 2022 06:14:56 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j22so27128372ejs.2;
        Tue, 19 Jul 2022 06:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rU9Gd+LZy6v2j/mU5pvuktHhDmWCodM7sD6cX5jBNCw=;
        b=d5zQDKVBZej3ZLh4tGsLyAycllq2KF4dVgPx5ROudERD007uwR8Eq7ODaPgZNX8WnF
         92g6H8uqg+sFXQzHgGYMMfKor8wOAYW8YOBXeow5ziB9XAQxSlv4RBGSErifvhxFKhxK
         fAeo6PFKmftrRF8IK6u0LNw39DA9oiasq8NXKaFurichemdtLMJnKHFKUzuinMXmAB/r
         cV+F3boaMbwIReTzJnLRAFf99ZdebKEsV5Om01MB0tI18HcUPO/tAdNxvl8RY1VblDRX
         mjH9ct33/cGMorQnVyOLmpux9FfnaAMi5DZzIRuYuZD+/LGWcrNJ110Q8P79Go10GTe9
         SgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rU9Gd+LZy6v2j/mU5pvuktHhDmWCodM7sD6cX5jBNCw=;
        b=vLXbkvcyn45k7zmpJwr44Fzh/aWF6Y10LNxzgDp0qOOYUmFL68g7MuncsvzzoZhsD/
         M+R2G0O10H/zDo0NAJJtgdd0yt2TRZiZnFJVaH/dxFpDprXk+T5iCb+UIG3lBoVcGZxr
         iT7ckrAdiSZO32TxtNrTKAKoqQqn+tNfYj196osLjgsSis22WI9JCAQyEjWGjOVHKJ8C
         u/T20F+x3HMMK2ur8FGQY/wpiOQHjW9LK/4fjx6KcwM6Wg42ssDJm+GdfVeeRiu/hILm
         F8mKFA5d102JVBthZETsBivkGYkgyeX6UWmiR3I3gH6eMWM9/GVGWg3Cr58hHvF9zF3j
         1Lmw==
X-Gm-Message-State: AJIora9FNrzYE2ePOs0pjpG4CltYfliXOFbLgutDkH518T/KnUNqhZCl
        fZ03Yt1sP740PljdwtT+e+Y=
X-Google-Smtp-Source: AGRyM1vU793i0O1g76Ys7hGR2uVKk4vtN+af2UpElatDEHCl5x4QU5QqjfxdSRp1Nkmti8wvAePiRQ==
X-Received: by 2002:a17:906:7303:b0:722:f008:2970 with SMTP id di3-20020a170906730300b00722f0082970mr29918993ejc.491.1658236494856;
        Tue, 19 Jul 2022 06:14:54 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id k16-20020a17090632d000b0072b2cb1e22csm6683825ejk.104.2022.07.19.06.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:14:54 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:14:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 06/15] net: dsa: qca8k: move port set
 status/eee/ethtool stats function to common code
Message-ID: <20220719131451.5o2sh3bf55knq3ly@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:17AM +0200, Christian Marangi wrote:
> The same logic to disable/enable port, set eee and get ethtool stats is
> used by drivers based on qca8k family switch.
> Move it to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
