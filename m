Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713B35B8F7D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiINUJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiINUJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:09:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F949B45;
        Wed, 14 Sep 2022 13:09:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z13so9952608edb.13;
        Wed, 14 Sep 2022 13:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=SyT2bzbmyQ1V98/b547yFFsB89jvoGODy24GfzfZ40M=;
        b=q6EdTuWMmL+eKXk5JdLvmxCCVE9C21T6He/5BDmRjkSkj5oady2lTTqDRP2AkRgxNT
         KEDL2hyDA8bmoIhGBscA81i61z3gIZleS1Jpa0AgiPdULevyz71jHrHTM3NqYkzmE9Z6
         PEdXtOGKJJmdY2+SnjkFwqL6DgTNFHv5S8dyGX9Na/Sp7vV0ODBvDO3TXhDVA5Zh+Cg8
         OwvBId/MRC6ZYhTMEk8Dv7IoC1CuKkySfBnI8n5pbAKyM5PndVYboaSTh2anawbGv8Xu
         Hl6k0ODhhT6G79kpzRjRtoEiADJsuQQWx8iJr9IfxdAQFLHqUH2+6+Gpevxogq7aRgNr
         njZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SyT2bzbmyQ1V98/b547yFFsB89jvoGODy24GfzfZ40M=;
        b=mAODwI7Du03inyLOyS2t9zq+FrBvAWgr41tdRQKryMQDtmpw9WD9zTjgvr9IHrxFNZ
         DInZPnJzbIB5JHDm5QLsI+OJu8AjKDKtvAIETtUtTwOfSv/t5GXiacdZHFQx88CGdd1A
         CF5A6mKt6GxtQDiLbQ1vDoy2FN8eM+UV9x1+Qs3Xu3/VXaJ3dxR/sc/FfyLOJcpy6P5a
         6DaD60GeI32KWDyTgwyahq9zHifFooKIx+i+52PtEWjqV4rsnRzHs/+wPGqlteBOU1Ie
         PSi4konum8WaHBP6c6WRtBuaZlz97DUPvgnYZnElHv/CrdF+4o3MtF4rmJi4vkOpX5P4
         r6jA==
X-Gm-Message-State: ACgBeo3jyK1IDpNoQDoqK64OIjEWKBI0ap/FMXZ3WcUlaJEDWepU3T7j
        mLJ53YJjNsZqHU8njXCaOLg=
X-Google-Smtp-Source: AA6agR4yHGxA0m8B3EuuNoM2peN0mqIgC801k5hbNUMV56gJyZxBnptNiAd48hQPd1EZ/FIbUdMu8w==
X-Received: by 2002:a05:6402:5246:b0:452:76a7:934d with SMTP id t6-20020a056402524600b0045276a7934dmr7525498edd.137.1663186141311;
        Wed, 14 Sep 2022 13:09:01 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id a13-20020a170906190d00b0073de0506745sm8026967eje.197.2022.09.14.13.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 13:09:00 -0700 (PDT)
Date:   Wed, 14 Sep 2022 23:08:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Regression: qca8k_sw_probe crashes (Was: Re: [net-next PATCH v5
 01/14] net: dsa: qca8k: cache match data to speed up access)
Message-ID: <20220914200857.fgkgflzm3nz5odwj@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-2-ansuelsmth@gmail.com>
 <20220914200641.zvib2kpo2t26u6ai@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914200641.zvib2kpo2t26u6ai@pali>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 10:06:41PM +0200, Pali Rohár wrote:
> Hello! This commit is causing kernel crash on powerpc P2020 based board
> with QCA8337N-AL3C switch.
> So function of_device_get_match_data() takes as its argument NULL
> pointer as 'priv' structure is at this stage zeroed, and which cause
> above kernel crash. priv->dev is filled lines below:

Thanks for the report, it was solved in 'net':
https://patchwork.kernel.org/project/netdevbpf/patch/20220904215319.13070-1-ansuelsmth@gmail.com/
