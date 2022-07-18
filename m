Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD86578888
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiGRRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGRRfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:35:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19822C64F;
        Mon, 18 Jul 2022 10:35:08 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e15so16325971edj.2;
        Mon, 18 Jul 2022 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+eU1cSyQLxmrfn01q1p7MKhYduUyHmgmYolTfJz8lZE=;
        b=mdfiZmpD7Re99R4yDcPh1sNkfA8y43hAbSf4uix/ViFHNO2f9LqX2bFC6KLD6r64cJ
         MPN7qPuBhOgfLDJvcW8dShdBRNWLlM4D0VDUGqz7RYa7Nfa5TW1zSuf0EouO+ZFLdZQq
         6lnu6gr00+G5+kxREfFge1eB0F6znJF8kBc/WJFaExFZO6IVojH70CI64w0qA9kHZb6k
         1sll1qhUlGI7wUvj0d1TyQwogqr2tepn4Ibwy+I9rHzdtZeZWjXRLuFBjkqBPUNeZN5u
         umOlhFW0Xg1UVlVTfgyzdpRojYb56OQb9wgEVeUXlm/MUIquM3Z/kx9rDtpcafKX0NQb
         bR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+eU1cSyQLxmrfn01q1p7MKhYduUyHmgmYolTfJz8lZE=;
        b=Gn69v8oRRg5mZrRfFptTiV1ZdtUsXKTXM0KziStdOfHY0WeTaMiVazHhYDLVFkP8lg
         gfVh8/VB38OIjlIe0gnWzmjqCcNTEhjTijEu2BFbTWArybKubFxD4Cit+kcehUPsIul0
         elHyd9hchUyhplPVJjNh9+Eu9L7V33K//JSJ8oI+cscPwEeQ96wRxdFr9mwIkaWevrzS
         bvEjlNIDTLR3utr0zbsXCWrc4FCoclx/R8NCkxQTiZGuAdNllofmeGcxPpQp00lfsRxm
         i2Qa7v1wcnaKLduVYRDWA+fEXwdvPLQOLbJP4SZgtg+SxRoJeLjX63QCsvHNF/L4Jrpi
         6faA==
X-Gm-Message-State: AJIora8AbORYMlAXR0PxHQ3G8GY8zToOj9UIJ2Lp0Zi/XvSm2HMFadwu
        q9xXO4GV4zytOBEyp7piJZs=
X-Google-Smtp-Source: AGRyM1un5p89dW4cqDybFAv+d05y+pSl9kUfu2VsS7Rcm3njoTgZDrOaK2gxvL1RoxnBnP9B4fHY4A==
X-Received: by 2002:a05:6402:23a5:b0:43a:a374:344f with SMTP id j37-20020a05640223a500b0043aa374344fmr37950012eda.403.1658165707402;
        Mon, 18 Jul 2022 10:35:07 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id r17-20020a056402035100b0043a6a7048absm8972088edw.95.2022.07.18.10.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:35:06 -0700 (PDT)
Date:   Mon, 18 Jul 2022 20:35:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
Message-ID: <20220718173504.jliiboqbw6bjr2l4@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 04:46:20PM +0200, Christian Marangi wrote:
> On Sat, Jul 16, 2022 at 07:49:54PM +0200, Christian Marangi wrote:
> > This is posted as an RFC as it does contain changes that depends on a
> > regmap patch. The patch is here [1] hoping it will get approved.
> > 
> > If it will be NACKed, I will have to rework this and revert one of the
> > patch that makes use of the new regmap bulk implementation.
> >
> 
> The regmap patch that this series depends on has been accepted but needs
> some time to be put in linux-next. Considering the comments from the
> code move, is it urgent to have the changes done or we can wait for the
> regmap patch to get applied?
> 
> (this was asked from the regmap maintainer so here is the question)

If I understand correctly, what you're saying is that the regmap_bulk_read()
change from patch 2/4 (net: dsa: qca8k: convert to regmap read/write API)
won't work correctly without the regmap dependency, and would introduce
a regression in the driver, right?

If so, I would prefer getting the patches merged linearly and not in
parallel, in other words either Mark provides a branch to pull into
net-next or you wait until the merge window opens and then closes, which
means a couple of weeks.

The fact that in linux-next things would work isn't enough, since on
net-next they would still be broken.

> > Anyway, this is needed ad ipq4019 SoC have an internal switch that is
> > based on qca8k with very minor changes. The general function is equal.
> > 
> > Because of this we split the driver to common and specific code.
> > 
> > As the common function needs to be moved to a different file to be
> > reused, we had to convert every remaining user of qca8k_read/write/rmw
> > to regmap variant.
> > We had also to generilized the special handling for the ethtool_stats
> > function that makes use of the autocast mib. (ipq4019 will have a
> > different tagger and use mmio so it could be quicker to use mmio instead
> > of automib feature)
> > And we had to convert the regmap read/write to bulk implementation to
> > drop the special function that makes use of it. This will be compatible
> > with ipq4019 and at the same time permits normal switch to use the eth
> > mgmt way to send the entire ATU table read/write in one go.
> > 
> > (the bulk implementation could not be done when it was introduced as
> > regmap didn't support at times bulk read/write without a bus)
> > 
> > [1] https://lore.kernel.org/lkml/20220715201032.19507-1-ansuelsmth@gmail.com/
