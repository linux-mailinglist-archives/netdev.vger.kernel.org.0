Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33D16872C0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBBBIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjBBBIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:08:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5282CBB94;
        Wed,  1 Feb 2023 17:08:10 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 203so123741pfx.6;
        Wed, 01 Feb 2023 17:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDnbyIH+K21+4fUoPzZzTFO/KLdYrYM0WYvbE1m6t+E=;
        b=RklKD5jPTVVQNr4cEUFoQGplZwSbwqqGN2JwllbhuRv/nnKKgaDb/ruCbsbtIbvJON
         ldCgQrLaki3BzC272ucCaPaAlOQ8j5Gv+EEH0r8aqAk+FzJg6dXVaNSmgoLKER3vMvuz
         F3E2THWL6YjDERz3J+Tgj/9k5KV75Q9yE9kQy0mBxKnmzylk/hnxqgp/1w6E+aqeVEgw
         nFj/ADDeTwfUcZHd34rA+P4S8QllQExDnMg4075AbqYHjVYXP6k6ij4ubcauTniHi9+v
         Z4lXWBIB2EooKuLe28tQXv+7EExU1FxyZ4qMkK0VFdTYoxEsqJO6nglKcsNQmZ2ZQAw5
         6jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDnbyIH+K21+4fUoPzZzTFO/KLdYrYM0WYvbE1m6t+E=;
        b=C0jB8iWTdWsDhKksZz9QbIeojncC92nV7e+czguj0KTcUpQ8MaN4vSOnFWSBoJo9T1
         RBv9SmziHjT+6MQID55mo9MD1I8G7xbCY1jmnjj9R36tduC+iNzCiAj0bcAJpql54f+A
         BgRzBXFhNseyKqZYapk9gEyitCY+BtFYsuO7lr2K1OImHaKYltzYwzHU2FQiBytUEA+o
         77VDBZiqeNdxjxUEtbpsyO+9NKxouCFsKLRdI8u9+++9I0A+cg97qC5qEr9ERzfg0biT
         mkvCCeI7IGW33/POtu6IEz1bUcXeYErBz4V6jBNHNg0QnTbanpkUxw0nIMfUNHHHA9qh
         3Keg==
X-Gm-Message-State: AO0yUKVZpOlTEfpm0Z4WllJfSR57g/zJUI66cQk7DAEtyFTY9/2ozAfm
        r/hnZd46Xe9qBDIW7eJrpH8li+STHrE=
X-Google-Smtp-Source: AK7set86TYvyLa63e/YVBDWW7tnwrJiZc5tME9LJgxhltHgg27JcD0NRQI+5XaA6UeA1p3Oa/tUidA==
X-Received: by 2002:a05:6a00:23d5:b0:58d:be61:4859 with SMTP id g21-20020a056a0023d500b0058dbe614859mr5260179pfc.11.1675300089591;
        Wed, 01 Feb 2023 17:08:09 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:6b75:4990:9ed8:d8dc])
        by smtp.gmail.com with ESMTPSA id i20-20020aa79094000000b0058bc37f3d1csm12086969pfa.44.2023.02.01.17.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 17:08:08 -0800 (PST)
Date:   Wed, 1 Feb 2023 17:08:05 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Bernhard Walle <bernhard@bwalle.de>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: fec: do not double-parse
 'phy-reset-active-high' property
Message-ID: <Y9sM9ZMkvjlaFPdt@google.com>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
 <20230201215320.528319-2-dmitry.torokhov@gmail.com>
 <Y9rtil2/y3ykeQoF@lunn.ch>
 <Y9r0EWOZbiBvkxj0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9r0EWOZbiBvkxj0@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:21:53PM -0800, Dmitry Torokhov wrote:
> On Wed, Feb 01, 2023 at 11:54:02PM +0100, Andrew Lunn wrote:
> > On Wed, Feb 01, 2023 at 01:53:20PM -0800, Dmitry Torokhov wrote:
> > > Conversion to gpiod API done in commit 468ba54bd616 ("fec: convert
> > > to gpio descriptor") clashed with gpiolib applying the same quirk to the
> > > reset GPIO polarity (introduced in commit b02c85c9458c). This results in
> > > the reset line being left active/device being left in reset state when
> > > reset line is "active low".
> > > 
> > > Remove handling of 'phy-reset-active-high' property from the driver and
> > > rely on gpiolib to apply needed adjustments to avoid ending up with the
> > > double inversion/flipped logic.
> > 
> > I searched the in tree DT files from 4.7 to 6.0. None use
> > phy-reset-active-high. I'm don't think it has ever had an in tree
> > user.

FTR I believe this was added in 4.6-rc1 (as 'phy-reset-active-low' in
first iteration by Bernhard Walle (CCed), so maybe he can tell us a bit
more about hardware and where it is still in service and whether this
quirk is still relevant.

> > 
> > This property was marked deprecated Jul 18 2019. So i suggest we
> > completely drop it.
> 
> I'd be happy kill the quirk in gpiolibi-of.c if that is what we want to
> do, although DT people sometimes are pretty touchy about keeping
> backward compatibility.
> 
> I believe this should not stop us from merging this patch though, as the
> code is currently broken when this deprecated property is not present.
> 
> Thanks.
> 
> -- 
> Dmitry

-- 
Dmitry
