Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C1C578FE1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiGSBes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGSBer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:34:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BB8357C4;
        Mon, 18 Jul 2022 18:34:46 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so8310460wmb.5;
        Mon, 18 Jul 2022 18:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=O1Qp3gbD5LCIaZu9EcWuYcZ0RQg9qr+/xzOREzAIUdk=;
        b=KyMJRPN2o0toVPIbJaHZ7QFXJQBQ+IPvsgJXww2yc4epFtUP9VSNv3Ee4/Zx1s+nSA
         x9tL/yEkIHKhHSIVDJNqW7SYDOLlPFd0SbpG3+mKWVrxl7+ovn/wsuHaurdbJLBLR/7d
         8Kiu7bJ+fYBD4X1ze8+QzpqufG9XNSppQwn793khIXiIT0pU/7AY+/Ee6HO3f4NKoSeC
         XHMcQkgVgg2VvGZNHC2DQfmlhhKK9WV6t41nKn4E37OJA9aVoxU3dACxwdZXrJlcEvUP
         VlHc7Zi0MziYhWBFFe0kxsBwclBrfkPYZNZfESVuRML+KMBfJrgYV+cm4y28wrsUCcZO
         L/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=O1Qp3gbD5LCIaZu9EcWuYcZ0RQg9qr+/xzOREzAIUdk=;
        b=qo6bRinupI41irArqQV83W8y6dJiyVnYn2Yhmwwcsyr4zR/SU00U6WACbqMSLh/6Kk
         IYR7CdBGlY4p4HNc9DEHZuVMTmWsrPmjDBQjkI3cgnCADFtGGo71FyWDGYklnisj+rP+
         qQyDaeeYB3Yh/Ep9iNPkpaWZpZKf8+vgvAko1AwsHQbN5YkU8WhUkVvnmgLl8xLcWvN4
         1dMITdLk6K0DotOVF4UJZaLAQJuRHbtejeBSNfrgxvSNipCMyJE3cGtnOF1C3FnMbWaU
         DTU60mfqNQZrPyfculJwmwQvMUYL8gGmETwX7isR//If92Eo/PiGI464cCd8usk8/5Pa
         P87A==
X-Gm-Message-State: AJIora+NGompoQ7v3DjPvt1YwhV6quZGuFnrvOXanj+H+U9ULixIn74y
        ZvLwvd+RUtfN0a+AzE1urZA=
X-Google-Smtp-Source: AGRyM1sLKBMRbud+zEuQOBW42zZpwc5Zl2gl3Qx5A86h4UXLBYH7/o4659clrY0eLaRaLPbkIaUnzw==
X-Received: by 2002:a1c:f208:0:b0:3a2:dc06:f3fe with SMTP id s8-20020a1cf208000000b003a2dc06f3femr34685387wmc.119.1658194485073;
        Mon, 18 Jul 2022 18:34:45 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600c14c300b003a32251c3f0sm845047wmh.33.2022.07.18.18.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:34:44 -0700 (PDT)
Message-ID: <62d60a34.1c69fb81.a0fa0.2186@mx.google.com>
X-Google-Original-Message-ID: <YtYGMd5WijecqaMI@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 03:17:37 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 03/15] net: dsa: qca8k: move
 qca8kread/write/rmw and reg table to common code
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-5-ansuelsmth@gmail.com>
 <62d60620.1c69fb81.42957.a752@mx.google.com>
 <20220718183006.15e16e46@kernel.org>
 <20220718183233.5a53739b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718183233.5a53739b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 06:32:33PM -0700, Jakub Kicinski wrote:
> On Mon, 18 Jul 2022 18:30:06 -0700 Jakub Kicinski wrote:
> > On Tue, 19 Jul 2022 03:00:13 +0200 Christian Marangi wrote:
> > > This slipped and was sent by mistake (and was just a typo fixed in the
> > > title)
> > > 
> > > Please ignore. Sorry.  
> > 
> > Please make sure you wait 24h before reposting, as per
> > 
> > https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches
> 
> Looks like patchwork picked the right one, no? This is the patch we
> need:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220719005726.8739-4-ansuelsmth@gmail.com/
> 
> And this one is to be ignored:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220719005726.8739-5-ansuelsmth@gmail.com/
> 
> Right? If so - no repost needed.

Yes correct. I was lucky.

-- 
	Ansuel
