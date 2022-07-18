Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0833578AF8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiGRTfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiGRTf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:35:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B0F2B26D;
        Mon, 18 Jul 2022 12:35:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id va17so23266924ejb.0;
        Mon, 18 Jul 2022 12:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mTulb7uOr0QL7j9beef5h9ULuuz6/D0H+AXBZ4FpZbw=;
        b=KYE33/QeBszO7ih0Y0RkgHZtNsVka7DHhOWZnLByp65wvda/xjx4ukSOG2L8p3c7Af
         FmIzov9hC+G87GaGDYfqjd4fW2JTi8vUEXfzy8hivEcTaW1XGTg1KhVgfuT5c1Z6M2aj
         0qCnu3A7qkAhqF+rDPJaAs/Xnzg44Zixq2x6522BvwxTb7uWIIocr34CSxqORejW2ZFQ
         CuCiSy+9IejW+jsjDXcIcnKsYJfQiBXgBiqKNzjsdMbyTr6bSrttZCGx1Gr/j9dvA4x+
         TX64+ucf0w8ZvScrnLSfrCjcN9myUQtZw1m2fUa+xnWHS6ndytoNLyP1+Svrrc2w1fCD
         cTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mTulb7uOr0QL7j9beef5h9ULuuz6/D0H+AXBZ4FpZbw=;
        b=6QU2MZd1tl5uROyjpOtmGxcGIdOkxux335IKVmkIQ2vqwEeHM20o8ukZzbFeH9vWO/
         8pqAbWb7SN+yH7JNQtlLWVI2otjy/6GiNqHETfR3R3MUKL0GV7UGatdJmxAzraZugWMF
         4jNcyTZMAlyKBXC0L0Yxht2vgy1K55m2/80lB8SQqacwTrsDUuFtMwi9IqnCF1LoFwrx
         6hLtSOy+6CkiJ7m0f0Z36XYWubEiippdhL9nLSTWKVgD+M66LMBeoRHWNGalsJR/wl1G
         XWWa6cRrNR7D7wh30sdLVs+fUF6sFsUgOeoMWmTniQCSMJq9RsoFiLXot6UR+yMy0ZdQ
         IUWA==
X-Gm-Message-State: AJIora/YgJBtsbGFLkg/oCHaagA5xqwq8h4D1dctRCk1bPdrzHOyxBfz
        spSW4N7lDyrwCNSwwKPglio=
X-Google-Smtp-Source: AGRyM1u76pwbgThPGR5khY+65+4Q6zHqZ0qJm7DJk1J/PCXSUO6u/mCp7VXz6hyhnhWEKE4nTvnpGA==
X-Received: by 2002:a17:907:28c9:b0:72b:6912:5453 with SMTP id en9-20020a17090728c900b0072b69125453mr26174572ejc.419.1658172924298;
        Mon, 18 Jul 2022 12:35:24 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id f23-20020a50fe17000000b0043a734c7393sm9102770edt.31.2022.07.18.12.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:35:23 -0700 (PDT)
Date:   Mon, 18 Jul 2022 22:35:21 +0300
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
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
Message-ID: <20220718193521.ap3fc7mzkpstw727@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:40:14PM +0200, Christian Marangi wrote:
> > I don't really have a preference, I just want to understand why you want
> > to call regmap_read(priv->regmap) directly every time as opposed to
> > qca8k_read(priv) which is shorter to type and allows more stuff to fit
> > on one line.
> 
> The main reason is that it's one less function. qca8k_read calls
> directly the regmap ops so it seems a good time to drop it.

This is before applying your patch 1/4, with an armv7 compiler:
make drivers/net/dsa/qca/qca8k.lst

I'm looking at the qca8k_read() call from qca8k_pcs_get_state():

000009d8 <qca8k_pcs_get_state>:
{
     9d8:	e92d4030 	push	{r4, r5, lr}
     9dc:	e3005000 	movw	r5, #0
			9dc: R_ARM_MOVW_ABS_NC	__stack_chk_guard
	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
     9e0:	e590300c 	ldr	r3, [r0, #12]
{
     9e4:	e3405000 	movt	r5, #0
			9e4: R_ARM_MOVT_ABS	__stack_chk_guard
     9e8:	e24dd00c 	sub	sp, sp, #12
     9ec:	e1a04001 	mov	r4, r1
	return regmap_read(priv->regmap, reg, val);
     9f0:	e5900008 	ldr	r0, [r0, #8]
     9f4:	e1a0200d 	mov	r2, sp
{
     9f8:	e595c000 	ldr	ip, [r5]
	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
     9fc:	e283101f 	add	r1, r3, #31
	return regmap_read(priv->regmap, reg, val);
     a00:	e1a01101 	lsl	r1, r1, #2
     a04:	e5900010 	ldr	r0, [r0, #16]
{
     a08:	e58dc004 	str	ip, [sp, #4]
	return regmap_read(priv->regmap, reg, val);
     a0c:	ebfffffe 	bl	0 <regmap_read>
			a0c: R_ARM_CALL	regmap_read
(portions irrelevant to regmap cut out)

And this is how it looks like after applying your patch 1/4:

000009d8 <qca8k_pcs_get_state>:
{
     9d8:	e92d4030 	push	{r4, r5, lr}
     9dc:	e3005000 	movw	r5, #0
			9dc: R_ARM_MOVW_ABS_NC	__stack_chk_guard
	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
     9e0:	e590300c 	ldr	r3, [r0, #12]
{
     9e4:	e3405000 	movt	r5, #0
			9e4: R_ARM_MOVT_ABS	__stack_chk_guard
     9e8:	e24dd00c 	sub	sp, sp, #12
     9ec:	e1a04001 	mov	r4, r1
	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
     9f0:	e5900008 	ldr	r0, [r0, #8]
     9f4:	e1a0200d 	mov	r2, sp
{
     9f8:	e595c000 	ldr	ip, [r5]
	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
     9fc:	e283101f 	add	r1, r3, #31
     a00:	e1a01101 	lsl	r1, r1, #2
     a04:	e5900010 	ldr	r0, [r0, #16]
{
     a08:	e58dc004 	str	ip, [sp, #4]
	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
     a0c:	ebfffffe 	bl	0 <regmap_read>
			a0c: R_ARM_CALL	regmap_read

You don't even need to recognize the instructions or calling conventions
to figure out that the generated assembly code is identical.

> > 
> > I think if you run "make drivers/net/dsa/qca/qca8k.lst" and you look at
> > the generated code listing before and after, you'll find it is identical
> > (note, I haven't actually done that).
> > 
> > > An alternative is to keep them for qca8k specific code and migrate the
> > > common function to regmap api.
> > 
> > No, that's silly and I can't even find a reason to do that.
> > It's not like you're trying to create a policy to not call qca8k-common.c
> > functions from qca8k-8xxx.c, right? That should work just fine (in this
> > case, qca8k_read etc).
> 
> The idea of qca8k-common is to keep them as generilized as possible.
> Considering ipq4019 will have a different way to write/read regs we can't
> lock common function to specific implementation.

Wait a minute, what's the difference between having this in common.c:

	qca8k_read(priv)

vs this:

	regmap_read(priv->regmap)

when qca8k_read is implemented *exactly* as a call to regmap_read(priv->regmap)?
There's nothing *specific* to a switch in the implementation of qca8k_read().
But rather, all differences lie in the regmap_config structure and in
the way the regmap was created. But the common code operates with a
pointer to a generic regmap structure, regardless of how that was created.

So no, sorry, there is no technical argument for which you cannot have
calls to qca8k_read() in common.c. I can work with "that's the way I prefer",
but let's not try to invent technical arguments when there aren't any.

> > In fact, while typing this I realized that in your code structure,
> > you'll have one struct dsa_switch_ops in qca8k-8xxx.c and another one in
> > qca8k-ipq4019.c. But the vast majority of dsa_switch_ops are common,
> > with the exception of .setup() which is switch-specific, correct?
> 
> Phylink ops will also be different as ipq4019 will have qsgmii and will
> require some calibration logic.

Ok, phylink too, the point is that they aren't radically different switches
for the majority of operations.

> qca8k_setup will require major investigation and I think it would be
> better to do do a qca8k_setup generalization when ipq4019 will be
> proposed.

Ok, "major investigation" sounds about right, that's what I was looking
to hear. The alternative would have been to plop a separate ipq4019_setup(),
leave qca8k_setup() alone, and call it a day. FWIW, that's essentially
where the microchip ksz set of drivers were, before Arun Ramadoss
started doing some major cleanup through them. After some point, this
strategy simply stops scaling.

> On the other hand I like the idea of putting the qca8k ops in common.c
> and make the driver adds the relevant specific options.
> Think I will also move that to common.c. That would permit to keep
> function static aka even less delta and less bloat in the header file.
> 
> (is it a problem if it won't be const?)

yeah, it's a problem if it won't be const, why wouldn't it?

> > If I were to summarize your reason, it would be "because I prefer it
> > that way and because now is a good time", right? That's fine with me,
> > but I honestly didn't understand that while reading the commit message.
> 
> I have to be honest... Yes you are right... This is really my opinion
> and I don't have a particular strong reason on why dropping them.
> 
> It's really that I don't like keeping function that are just leftover of
> an old implementation. But my target here is not argue and find a
> solution so it's OK for me if I should keep these compat function and
> migrate them to common.c.

I know that the revolutionary spirit can be strong, but it's good to keep
in mind that "older/newer" is not always synonymous with "worse/better" ;)

Again, I don't have a strong objection against the change and I'm not
going to argue about it either. My comment was simply because I didn't
physically UNDERSTAND you. My expectations were also a bit confused,
because I initially thought it's a necessary change (that's why I
replied to it last), and I just didn't understand what's so necessary
about it.
