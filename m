Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A257A053
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiGSOEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiGSOET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:04:19 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C3394927;
        Tue, 19 Jul 2022 06:16:29 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so9893223wmb.3;
        Tue, 19 Jul 2022 06:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=D+VOnNkEOftjCpH+E1Rr3zSGAetG7FPBo0MDoee32c4=;
        b=ZF75Fyrm0vSeelaOr4FodqZRzqXm4UKzBNZKsc+ZHUqj+YCVZEl/UYdPyyDTAazfKG
         KtTJpuipFMkN/0Kt9/+cPd4FP6z2zahhdhRkdSFjxzN29YoU6aQE4Po5W0h9jDW8FC7a
         lz/FTcgUUuwH86HRmyqmAelBI2RMyeFoqDS/rw8AWymlXxAPCWsR4AAmIp5mCq8dcVAq
         DAi8q23u5IwmDvFZyEFREbKF6IItoEslaR6oRFUy0AhOPU5q7PGVPeVMf1+/GrzqFjWd
         S0izY/MZJlPs5MjcmdMHEI8bua0BcN8K4oiDNzHXBoywV314rNxbTbRtk4UhkUva86RH
         Vtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+VOnNkEOftjCpH+E1Rr3zSGAetG7FPBo0MDoee32c4=;
        b=dMN/GAeo+JG+r2dwtcox9cZPTjGJF57Q4ytcABeQBfnR30qcm5prO7LxzLk+8mlTk7
         b2pvcCSjqTV6DRSz9wDXttYEZYjUBQk/qzTiwOF+tAJTHpBPAkGohCsAXBOYxVeka2R+
         StgkZ0MtdctbbzxdMoViIlitdKSWUt32VF3Q0gCgSyFWwDlrofJR3++RXBXnWvWgGbiW
         GqZrHX0uUDGxb6z8fpDec6RNVMmubK4RjskaqByUKMtuf+NLloo/uxHSxoZnJuUpV3zA
         I3DDPysscbykLf+/E8aM1WRUJbsJTC2ir7XwmgMeq71E+vae6vCrm/g2V4k4gaf9YQDk
         ftUw==
X-Gm-Message-State: AJIora+NDy88d3kVwQgEeuK47LiFFo+BveTiRpg+DHb3SBHVJsAZ79c0
        WstWV1z640lTIFWN8IRy/hk=
X-Google-Smtp-Source: AGRyM1uQClZDLvXkLuNLrRKxpOdoFtPMA/k9V8jo6ouBtOYZl2PpzoK1y35TpU/cOcTA3yX/gaBXwA==
X-Received: by 2002:a05:600c:a42:b0:39c:9166:5a55 with SMTP id c2-20020a05600c0a4200b0039c91665a55mr30285106wmq.141.1658236587864;
        Tue, 19 Jul 2022 06:16:27 -0700 (PDT)
Received: from Ansuel-xps. (93-34-208-75.ip51.fastwebnet.it. [93.34.208.75])
        by smtp.gmail.com with ESMTPSA id h4-20020a1c2104000000b00397402ae674sm22585216wmh.11.2022.07.19.06.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:16:27 -0700 (PDT)
Message-ID: <62d6aeab.1c69fb81.5d5ce.23b8@mx.google.com>
X-Google-Original-Message-ID: <YtauqPWNwq186V8Q@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 15:16:24 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719131451.5o2sh3bf55knq3ly@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719131451.5o2sh3bf55knq3ly@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 04:14:51PM +0300, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 02:57:17AM +0200, Christian Marangi wrote:
> > The same logic to disable/enable port, set eee and get ethtool stats is
> > used by drivers based on qca8k family switch.
> > Move it to common code to make it accessible also by other drivers.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

(considering the ethtool function will change, is it OK to keep the
review tag on the next revision?)

-- 
	Ansuel
