Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08D578B2C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiGRTsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiGRTsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C5F2F661;
        Mon, 18 Jul 2022 12:48:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e15so13319106wro.5;
        Mon, 18 Jul 2022 12:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=lxybusPr8as3++Or4hqeKt+qQctDcyDdqxi8AO6k8tY=;
        b=c1tTLuRz7/pM9Cn97bH3J/HqoA+gtUGg6fOoDdz4bBchfzP0JD9XYuUjftDzff9Cvt
         WJSFV5CxMfmPswFByvosGLVcT/gppXWoPxihpSdaII3+fKWugow5pMphHsInjsfIPG6X
         tIBn+sVo9Cy/QpslqYG4rhOmA/BCiUyY2LMw6rfXXKXdbTmwePutZxRgEtcvzgNioPTt
         pmzKOD3k+3Y9Nm1+zXVyDixDsC0qSBSVzP01uy0hcwLVIkMFpmu28sM7FxjDdb+/DoOY
         iFhcGWYZk2rFGWAhfojsOjcjFJ2be7lNWQ4RGIEJ7DqQ75dae6KMxzultSLbGRFKuP2a
         dtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxybusPr8as3++Or4hqeKt+qQctDcyDdqxi8AO6k8tY=;
        b=d6Nukg+LK0YE2/B5wMyLM/2IkgshNq5HCvTxrrfX22rdh7p0FF0iVdy0XC1d+zNg90
         GTMIZpeUysZAlYWJhLZiPSvMExE8g4HLHP3aDlCJRA//ezxRBWuOuWwAQrbVlslsZ/8J
         6cgZuFy2i0/LdV0sr5pzzyPM+SeN1neBQNdfLP4fjQArJmcKgsFDxErZY7O0C+phv7qF
         e+21ZE8Kx5TtY4Lr3bIc4/MhHdQ1ntfaYIL5cd9bkSu3JT/P2qETvlxeTsPTQg4ntRZD
         FcLPCLJEHCrOZDCdPb2EfjoZzxo/BsTHBdOuiqzYpbntyW0cFMBkoG2QcZrb2Z+AZRX7
         Grdg==
X-Gm-Message-State: AJIora+2McL2xVlh0rk2ZFxhRPEQInc3lBVzK/t6sqJT6hELh1Q8KqWT
        U5ZAkQoHCSNqZYRpU+aaHSU=
X-Google-Smtp-Source: AGRyM1tZJsZ9gJ17q/8FZ3m25NkbFvSlKsXzfwYapOE1T+KQa60VOiAn7SN3YgdtoiwEoTGci+mg/w==
X-Received: by 2002:a5d:52cb:0:b0:21a:3cc5:f5f4 with SMTP id r11-20020a5d52cb000000b0021a3cc5f5f4mr24235219wrv.367.1658173685711;
        Mon, 18 Jul 2022 12:48:05 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id v25-20020a1cf719000000b003a2d87aea57sm8205013wmh.10.2022.07.18.12.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:48:05 -0700 (PDT)
Message-ID: <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
X-Google-Original-Message-ID: <YtW08q1HevDPqZQH@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 21:30:58 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718193521.ap3fc7mzkpstw727@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:35:21PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 08:40:14PM +0200, Christian Marangi wrote:
> > > I don't really have a preference, I just want to understand why you want
> > > to call regmap_read(priv->regmap) directly every time as opposed to
> > > qca8k_read(priv) which is shorter to type and allows more stuff to fit
> > > on one line.
> > 
> > The main reason is that it's one less function. qca8k_read calls
> > directly the regmap ops so it seems a good time to drop it.
> 
> This is before applying your patch 1/4, with an armv7 compiler:
> make drivers/net/dsa/qca/qca8k.lst
> 
> I'm looking at the qca8k_read() call from qca8k_pcs_get_state():
> 
> 000009d8 <qca8k_pcs_get_state>:
> {
>      9d8:	e92d4030 	push	{r4, r5, lr}
>      9dc:	e3005000 	movw	r5, #0
> 			9dc: R_ARM_MOVW_ABS_NC	__stack_chk_guard
> 	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
>      9e0:	e590300c 	ldr	r3, [r0, #12]
> {
>      9e4:	e3405000 	movt	r5, #0
> 			9e4: R_ARM_MOVT_ABS	__stack_chk_guard
>      9e8:	e24dd00c 	sub	sp, sp, #12
>      9ec:	e1a04001 	mov	r4, r1
> 	return regmap_read(priv->regmap, reg, val);
>      9f0:	e5900008 	ldr	r0, [r0, #8]
>      9f4:	e1a0200d 	mov	r2, sp
> {
>      9f8:	e595c000 	ldr	ip, [r5]
> 	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
>      9fc:	e283101f 	add	r1, r3, #31
> 	return regmap_read(priv->regmap, reg, val);
>      a00:	e1a01101 	lsl	r1, r1, #2
>      a04:	e5900010 	ldr	r0, [r0, #16]
> {
>      a08:	e58dc004 	str	ip, [sp, #4]
> 	return regmap_read(priv->regmap, reg, val);
>      a0c:	ebfffffe 	bl	0 <regmap_read>
> 			a0c: R_ARM_CALL	regmap_read
> (portions irrelevant to regmap cut out)
> 
> And this is how it looks like after applying your patch 1/4:
> 
> 000009d8 <qca8k_pcs_get_state>:
> {
>      9d8:	e92d4030 	push	{r4, r5, lr}
>      9dc:	e3005000 	movw	r5, #0
> 			9dc: R_ARM_MOVW_ABS_NC	__stack_chk_guard
> 	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
>      9e0:	e590300c 	ldr	r3, [r0, #12]
> {
>      9e4:	e3405000 	movt	r5, #0
> 			9e4: R_ARM_MOVT_ABS	__stack_chk_guard
>      9e8:	e24dd00c 	sub	sp, sp, #12
>      9ec:	e1a04001 	mov	r4, r1
> 	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
>      9f0:	e5900008 	ldr	r0, [r0, #8]
>      9f4:	e1a0200d 	mov	r2, sp
> {
>      9f8:	e595c000 	ldr	ip, [r5]
> 	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
>      9fc:	e283101f 	add	r1, r3, #31
>      a00:	e1a01101 	lsl	r1, r1, #2
>      a04:	e5900010 	ldr	r0, [r0, #16]
> {
>      a08:	e58dc004 	str	ip, [sp, #4]
> 	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
>      a0c:	ebfffffe 	bl	0 <regmap_read>
> 			a0c: R_ARM_CALL	regmap_read
> 
> You don't even need to recognize the instructions or calling conventions
> to figure out that the generated assembly code is identical.
> 
> > > 
> > > I think if you run "make drivers/net/dsa/qca/qca8k.lst" and you look at
> > > the generated code listing before and after, you'll find it is identical
> > > (note, I haven't actually done that).
> > > 
> > > > An alternative is to keep them for qca8k specific code and migrate the
> > > > common function to regmap api.
> > > 
> > > No, that's silly and I can't even find a reason to do that.
> > > It's not like you're trying to create a policy to not call qca8k-common.c
> > > functions from qca8k-8xxx.c, right? That should work just fine (in this
> > > case, qca8k_read etc).
> > 
> > The idea of qca8k-common is to keep them as generilized as possible.
> > Considering ipq4019 will have a different way to write/read regs we can't
> > lock common function to specific implementation.
> 
> Wait a minute, what's the difference between having this in common.c:
> 
> 	qca8k_read(priv)
> 
> vs this:
> 
> 	regmap_read(priv->regmap)
> 
> when qca8k_read is implemented *exactly* as a call to regmap_read(priv->regmap)?
> There's nothing *specific* to a switch in the implementation of qca8k_read().
> But rather, all differences lie in the regmap_config structure and in
> the way the regmap was created. But the common code operates with a
> pointer to a generic regmap structure, regardless of how that was created.
> 
> So no, sorry, there is no technical argument for which you cannot have
> calls to qca8k_read() in common.c. I can work with "that's the way I prefer",
> but let's not try to invent technical arguments when there aren't any.
> 
> > > In fact, while typing this I realized that in your code structure,
> > > you'll have one struct dsa_switch_ops in qca8k-8xxx.c and another one in
> > > qca8k-ipq4019.c. But the vast majority of dsa_switch_ops are common,
> > > with the exception of .setup() which is switch-specific, correct?
> > 
> > Phylink ops will also be different as ipq4019 will have qsgmii and will
> > require some calibration logic.
> 
> Ok, phylink too, the point is that they aren't radically different switches
> for the majority of operations.
> 
> > qca8k_setup will require major investigation and I think it would be
> > better to do do a qca8k_setup generalization when ipq4019 will be
> > proposed.
> 
> Ok, "major investigation" sounds about right, that's what I was looking
> to hear. The alternative would have been to plop a separate ipq4019_setup(),
> leave qca8k_setup() alone, and call it a day. FWIW, that's essentially
> where the microchip ksz set of drivers were, before Arun Ramadoss
> started doing some major cleanup through them. After some point, this
> strategy simply stops scaling.
> 
> > On the other hand I like the idea of putting the qca8k ops in common.c
> > and make the driver adds the relevant specific options.
> > Think I will also move that to common.c. That would permit to keep
> > function static aka even less delta and less bloat in the header file.
> > 
> > (is it a problem if it won't be const?)
> 
> yeah, it's a problem if it won't be const, why wouldn't it?
>

Tell me if I got this wrong.

The suggestion was to move the struct dsa_switch_ops to qca8k.h and add
in the specific code probe the needed ops to add to the generic
struct...

But now that I think about it I was just confused and it can totally be
const so sorry for the stupid question

Anyway to make it clear, these are the option that will be the same for
qca8k and ipq4019

.get_strings		= qca8k_get_strings,
	.get_ethtool_stats	= qca8k_get_ethtool_stats,
	.get_sset_count		= qca8k_get_sset_count,
	.set_ageing_time	= qca8k_set_ageing_time,
	.get_mac_eee		= qca8k_get_mac_eee,
	.set_mac_eee		= qca8k_set_mac_eee,
	.port_enable		= qca8k_port_enable,
	.port_disable		= qca8k_port_disable,
	.port_change_mtu	= qca8k_port_change_mtu,
	.port_max_mtu		= qca8k_port_max_mtu,
	.port_stp_state_set	= qca8k_port_stp_state_set,
	.port_bridge_join	= qca8k_port_bridge_join,
	.port_bridge_leave	= qca8k_port_bridge_leave,
	.port_fast_age		= qca8k_port_fast_age,
	.port_fdb_add		= qca8k_port_fdb_add,
	.port_fdb_del		= qca8k_port_fdb_del,
	.port_fdb_dump		= qca8k_port_fdb_dump,
	.port_mdb_add		= qca8k_port_mdb_add,
	.port_mdb_del		= qca8k_port_mdb_del,
	.port_mirror_add	= qca8k_port_mirror_add,
	.port_mirror_del	= qca8k_port_mirror_del,
	.port_vlan_filtering	= qca8k_port_vlan_filtering,
	.port_vlan_add		= qca8k_port_vlan_add,
	.port_vlan_del		= qca8k_port_vlan_del,
	.port_lag_join		= qca8k_port_lag_join,
	.port_lag_leave		= qca8k_port_lag_leave,

Everything else has to be set by the driver. So yes the amount of shared
function is enough to have a reason to declare a general dsa_switch_ops.

> > > If I were to summarize your reason, it would be "because I prefer it
> > > that way and because now is a good time", right? That's fine with me,
> > > but I honestly didn't understand that while reading the commit message.
> > 
> > I have to be honest... Yes you are right... This is really my opinion
> > and I don't have a particular strong reason on why dropping them.
> > 
> > It's really that I don't like keeping function that are just leftover of
> > an old implementation. But my target here is not argue and find a
> > solution so it's OK for me if I should keep these compat function and
> > migrate them to common.c.
> 
> I know that the revolutionary spirit can be strong, but it's good to keep
> in mind that "older/newer" is not always synonymous with "worse/better" ;)
> 
> Again, I don't have a strong objection against the change and I'm not
> going to argue about it either. My comment was simply because I didn't
> physically UNDERSTAND you. My expectations were also a bit confused,
> because I initially thought it's a necessary change (that's why I
> replied to it last), and I just didn't understand what's so necessary
> about it.

Ok at the end I probably chose the wrong words since this is really a
cleanup and nothing necessary for the function of the code split.

Will send a v2 with RFC removed and a more friendly series hoping it
won't grow too much with the code split.

Again thanks for the all the good review :D

-- 
	Ansuel
