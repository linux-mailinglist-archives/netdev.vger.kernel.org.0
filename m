Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7864840D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLIOrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIOr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:47:28 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07656DEC6;
        Fri,  9 Dec 2022 06:47:28 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n20so12113035ejh.0;
        Fri, 09 Dec 2022 06:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Chp2n3ay18nBkST/OunfW2Lm53v//eawAShT7k/YG4U=;
        b=nnk2q8E3MyYSalH3bsr/ati99hfOgwFx/e9QEnpUthYo8f3xizSWEDDJPTU/+bH55m
         re2rW7lJr9H/MDxUQ5FufYNFzYTrk9xxjwlw3D/b9Mo2kxgxAlfxH4V+guLuwGiB21TG
         nrwJidW7XkkpVIP5i6dmpAJFSd1B8iimn3Al6eikIYLAEEa8Q4ukl0WnfWsVYOeHzols
         5W/G0lqqrSfEhNECPIFMBUr9eHOEqU5aT9CbQEkQxs9gp5K88+H/vZLs+XRjxQ9sN+sZ
         IvO5yUL2dcC8vSQ1ZiW2BQ/QCg/khbgA0yd2etuCT7we4n9ps+JceRyHaSeaisg6mnI1
         xn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chp2n3ay18nBkST/OunfW2Lm53v//eawAShT7k/YG4U=;
        b=hduJkJsfsWAIzB+b0OxRxFKI4wroWTbN5oXpA2YiOjVUDrmPi6P7IFJzYSUt4IhATG
         mAM0fP1qbZLWG8mykhLRkbi6u5CGzNVUGfy8ykbGNLUMyDsY9oQBlvyGIp69FfqfNUGt
         U6t7twLCKZeKynO0cKSYDQVr4R5cYCTxlhTabUMGoZqIiL6258xQx5d+VlCBNJ3ebJ3v
         6fNLc/sW/phhmiqkU6CQcVYPPmRJgZzsBEzZyReMB6/EGr1okDv4BsNX34V4/uQpoKId
         UzxJ4jEhaq3bMoKEjP5ETID/dDbaIW3b74BTSfmoe1gJdeft0C6F8S1d0D9u+qlwvEUn
         zRPw==
X-Gm-Message-State: ANoB5pkjfoTjyAa7bEQA52j7vNhvyhHAJHofwtkI+J4pali60KDl+Q4A
        k8QhnaKKw3vUQjE3UQ2lJts=
X-Google-Smtp-Source: AA0mqf55KYChBAgv9EmwOTzjF3yLijN9xgZnVbMnD6Cc6AAuNXsai7LDzQ7bd5K6eiyGw8bQSnynJA==
X-Received: by 2002:a17:907:a4c1:b0:7c0:a350:9d29 with SMTP id vq1-20020a170907a4c100b007c0a3509d29mr5367908ejc.18.1670597246415;
        Fri, 09 Dec 2022 06:47:26 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906308a00b007ad94fd48dfsm628951ejv.139.2022.12.09.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:47:25 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:47:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209144723.qdbf2wr6vp2dmty7@skbuf>
References: <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
 <20221209144328.m54ksmoeitmcjo5f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209144328.m54ksmoeitmcjo5f@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 04:43:28PM +0200, Vladimir Oltean wrote:
> On Fri, Dec 09, 2022 at 03:20:58PM +0100, Horatiu Vultur wrote:
> > On ocelot, the vcap is enabled at port initialization, while on other
> > platforms(lan966x and sparx5) you have the option to enable or disable.
> 
> Even if that wasn't the case, I'd still consider enabling/disabling VCAP
> lookups privately in the ocelot driver when there are non-tc users of
> traps, instead of requiring users to do anything with tc. It's simply
> too unfriendly for somebody who just wants PTP. You can use devlink
> traps to show which non-tc traps are active.

To put it differently. Why do you even bother to make the driver
auto-install PTP traps, and not let the user do that? It's the same
argument as asking the user enable the VCAP lookups.
