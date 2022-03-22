Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12564E3FE6
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiCVN5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiCVN5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:57:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C567517A9A;
        Tue, 22 Mar 2022 06:55:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x34so20593667ede.8;
        Tue, 22 Mar 2022 06:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LbeRwG0S/Pt5LZP0Vg7JRe9n4qoS+94Y4w5zYWdMgTs=;
        b=BFksIoja0l4lbrhfRO5o8HH85XMEmgCueBHG7rXiEg3zTi035UeXCOtacl7+HwY5kY
         zx9r8LGf6/guEPVx5uK8lMhXndaoanqWbSEsPDBXJutNJaNZaB3zLC5v+e3MK+v2nTSj
         UXkubSOnrt4poHvw/9ka7G1d2NwF/SiUSPBf1DmVxPwzw71e+lDTwoFAIBP0cbxrEE9R
         pUoneX+jppKMBgPgyV01PaBeY0S5lgpHN2xFx3LNLkpgD6+EUHpHcPt+KvHOCKEM7It5
         fGLrLF7VlbGf0bNlWfFZfsit2QirC7DdM+6DNLdHwM3Nus4GtuqajNtQduzPnt0XldMx
         I5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LbeRwG0S/Pt5LZP0Vg7JRe9n4qoS+94Y4w5zYWdMgTs=;
        b=heqyW6qE0WmCahAHlP71CsT30z+jKpqZz9H+X54XdTMbp2ldt0tTJzcDpXtvAtJ3sz
         hpaM6IgnhqfWa9VjnHUH8V/3JRCFqnl4DxpHepJcQFMoJyXJTOEKVyNYjIeVVKh1xe7Y
         VY/MrCqQkJj572iCyKw1obWs5JexAIezUAUd3NkB75xPmqiOykHLVBT890l6Fz0VLTEr
         9hZ3cC9DPjuavtGOuW9twZ+M4NCXaXH56IBkDyEYtXiVre0RwssT1rU2H7o1IQ2VP9q3
         Il9YLp6hKyYHeT05qRnOqx7uWZRMKG+pCXDx4HyRW3wG68TvoBfxW6/0UOFgqewD9JeB
         B+2Q==
X-Gm-Message-State: AOAM532MpZ91vK0pdIIpOMLqHRKTqfKeH0Kje4u/l/ZA6atWfIIsyYNx
        QFeANUEe8gtLh68ZMrDya0s=
X-Google-Smtp-Source: ABdhPJx9UgKOhFO1xXGXKFq0pdiUbkTaH6jmTP9H084N9GNJAEjHA6XrrX0rLaSIAIVPaVCWSMsUlA==
X-Received: by 2002:a05:6402:5304:b0:413:8a0c:c54a with SMTP id eo4-20020a056402530400b004138a0cc54amr28401345edb.172.1647957337135;
        Tue, 22 Mar 2022 06:55:37 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u23-20020a17090626d700b006cfcd39645fsm8327076ejc.88.2022.03.22.06.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:55:36 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:55:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <20220322135535.au5d2n7hcu4mfdxr@skbuf>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 02:38:08PM +0100, Ansuel Smith wrote:
> On Tue, Mar 22, 2022 at 01:58:12PM +0200, Vladimir Oltean wrote:
> > On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> > > Drop the MTU array from qca8k_priv and use slave net dev to get the max
> > > MTU across all user port. CPU port can be skipped as DSA already make
> > > sure CPU port are set to the max MTU across all ports.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > 
> > I hardly find this to be an improvement and I would rather not see such
> > unjustified complexity in a device driver. What are the concrete
> > benefits, size wise?
> >
> 
> The main idea here is, if the value is already present and accessible,
> why should we duplicate it? Tracking the MTU in this custom way already
> caused some bugs (check the comment i'm removing). We both use standard
> way to track ports MTU and we save some additional space. At the cost of
> 2 additional checks are are not that much of a problem.

Where is the bug?

> Also from this I discovered that (at least on ipq806x that use stmmac)
> when master needs to change MTU, stmmac complains that the interface is
> up and it must be put down. Wonder if that's common across other drivers
> or it's only specific to stmmac.

I never had the pleasure of dealing with such DSA masters. I wonder why
can't stmmac_change_mtu() check if netif_running(), call dev_close and
set a bool, and at the end, if the bool was set, call dev_open back?
