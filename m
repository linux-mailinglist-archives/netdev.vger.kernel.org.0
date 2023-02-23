Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5446A0009
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 01:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjBWAWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 19:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbjBWAWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 19:22:36 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12513B841;
        Wed, 22 Feb 2023 16:22:28 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s26so37307173edw.11;
        Wed, 22 Feb 2023 16:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qClGP8GsQ3EelAhVh1jt9Usn+fIKvAtTq6uhN1fGsd4=;
        b=JTjI9wwbCkcg/XkF01Iq+8PR5cfTuSsBiqjDjmpRAQ+58giESPmYBlJtlt7ilNZ8lP
         FJAD33KBUbEvEn3BLCGMZCOFrGN5G/VU8uie40FMXhD4iXfkdJmgFW0e+iT7DymWw8E4
         +BegmrwaW9QA3ENfNSwVHE5SKzdS6NOQJ9G6XSKJQbHQFf9JB4pBNu3AblV0yT9WxyzU
         udL5aRTi5DzKxLGV7eoZREeN0OCGzogMuoP1RcB3efhkyV28I5HX/+KzJ+Wx2e4bBt+k
         nbVVgsh5dk/+OHofyn17qdvmb0iWaH3zbjFltC32P/5so7lF2rhGslDP9XDToMia/J3+
         NsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qClGP8GsQ3EelAhVh1jt9Usn+fIKvAtTq6uhN1fGsd4=;
        b=ynnbNG5Fooa/TJ2SwEwjeiOepFmY/FOX7sWE5nCMl37Kb/sQF33NDYjvEFGq9CJf9s
         Gr7ecjcSr8ZQPJQhwKzi2elDbspp/Jcwd6RyUS1DDXf6uqEH9MMLO/ABa8qW3geZEufS
         f+tIN8cc27FA+Gx+bcmyKgjEKNNgmJW5RhUpjU3SzYuId5HWtgSC8lxiVSck4brcVM9P
         yIc0uK6ot7VP4WgqzRuqG0Rr7mK37znVGqPgRc7e4Hsd0ROetqJn1Ba6lQYDT1IeNQg0
         XWa87SCGNQsArXiBuQIcdTVC48JL4PLc73mkjDgyxTMZkKLr4KRKiBEa7Z6gnOtzgPd1
         LKog==
X-Gm-Message-State: AO0yUKXReK4pEwmtfcHqEp2TGtPbx4e4ObZQjaAtEmkgjCFJflCOovvg
        liuPlinUKxjMYjITzCehzYg=
X-Google-Smtp-Source: AK7set9y9bTmf+MdDMIEQLCcwUguPaTcDb5xFL/x4DZLKKdEPqENYkcrtvUHeWMYwK0UQ7Eu+y4Omw==
X-Received: by 2002:a17:906:4914:b0:8b1:7eaf:4708 with SMTP id b20-20020a170906491400b008b17eaf4708mr21645723ejq.65.1677111747253;
        Wed, 22 Feb 2023 16:22:27 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ch26-20020a170906c2da00b008cce6c5da29sm5116215ejb.70.2023.02.22.16.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 16:22:26 -0800 (PST)
Date:   Thu, 23 Feb 2023 02:22:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <20230223002224.k5odesikjebctouc@skbuf>
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
 <20230222232112.v7gokdmr34ii2lgt@skbuf>
 <35a4df8a-7178-20de-f433-e2c01e5eaaf7@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35a4df8a-7178-20de-f433-e2c01e5eaaf7@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Thu, Feb 23, 2023 at 12:55:08AM +0100, Marek Vasut wrote:
> The old code, removed in:
> c476bede4b0f0 ("net: dsa: microchip: ksz8795: use common xmii function")
> used ksz_write8() (this part is important):
> ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
> where:
> drivers/net/dsa/microchip/ksz8795_reg.h:#define REG_PORT_5_CTRL_6
> 0x56
> 
> The new code, where the relevant part is added in (see Fixes tag)
> 46f80fa8981bc ("net: dsa: microchip: add common gigabit set and get
> function")
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -257,6 +257,7 @@ static const u16 ksz8795_regs[] = {
> +       [P_XMII_CTRL_1]                 = 0x56,
> uses ksz_pwrite8() (with p in the function name, p means PORT):
> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
> which per drivers/net/dsa/microchip/ksz_common.h translates to
> ksz_write8(dev, dev->dev_ops->get_port_addr(port, offset), data);
> and that dev->dev_ops->get_port_addr(port, offset) remapping function is per
> drivers/net/dsa/microchip/ksz8795.c really call to the following macro:
> PORT_CTRL_ADDR(port, offset)
> which in turn from drivers/net/dsa/microchip/ksz8795_reg.h becomes
> #define PORT_CTRL_ADDR(port, addr) ((addr) + REG_PORT_1_CTRL_0 + (port) * (REG_PORT_2_CTRL_0 - REG_PORT_1_CTRL_0))
> 
> That means:
> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
> writes register 0xa6 instead of register 0x56, because it calls the
> PORT_CTRL_ADDR(port, 0x56)=0xa6, but in reality it should call
> PORT_CTRL_ADDR(port, 0x06)=0x56, i.e. the remapping should happen ONCE, the
> value 0x56 is already remapped .

I never had any objection to this part.

> All the call-sites which do
> ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8)
> or
> ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8)
> are affected by this, all six, that means the ksz_[gs]et_xmii() and the
> ksz_[gs]et_gbit().

I'm going to say this with a very calm tone, please tell me where it's wrong
and we can go from there.

 Not for the ksz_switch_chips[] elements which point to ksz8795_regs (which
 had the incorrect value you're fixing), it isn't. You're making an argument
 for code which never executes (5 out of 6 call paths), and basing your commit
 message off of it. Your commit message reads as if you didn't even notice
 that ksz_set_gbit() isn't called for ksz87xx, and that this is a bug in itself.
 Moreover, the problem you're seeing (I may speculate what that is, but
 I don't know) is surely not due to ksz_set_gbit() being called on the
 wrong register, because it's not called at all *for that hardware*.

That gigabit bug was pointed out to you by reviewers, and you refuse to
acknowledge this and keep bringing forth some other stuff which was never
debated by anyone. The lack of acknowledgement plus your continuation to
randomly keep singing another tune in another key completely is irritating
to me on a very personal (non-technical) level. To respond to you, I am
exercising some mental muscles which I wish I wouldn't have needed to,
here, in this context. The same muscles I use when I need to identify
manipulation on tass.com.

[ in case the message above is misinterpreted: I did not say that you
  willingly manipulate. I said that your lack of acknowledgement to what
  is being said to you is giving me the same kind of frustration ]

This is my feedback to the tone in your replies. I want you to give your
feedback to my tone now too. You disregarded that.

> ...
> 
> If all that should be changed in the commit message is "to access the
> P_GMII_1GBIT_M, i.e. Is_1Gbps, bit" to something from the "ksz_set_xmii()"
> function instead, then just say so.
> 
> [...]

No, this is not all that I want.

The gigabit bug changes things in ways in which I'm curious how you're
going to try to defend, with this attitude of responding to anything
except to what was asked. Your commit says it fixes gigabit on KSZ87xx,
but the gigabit bug which *was pointed out to you by others* is still
there. Your patch fixes something else, but *it says* it fixes a gigabit
bug. What I want is for you to describe exactly what it fixes, or if you
just don't know, say you noticed the bug during code review and you
don't know what is its real life impact (considering pin strapping).

I don't want a patch to be merged which says it fixes something it doesn't
fix, while leaving the exact thing it says it fixes unfixed.

I also don't want to entertain this game of "if it's just this small
thing, why didn't you say so". I would be setting myself up for an
endless time waste if I were to micromanage your commit message writing.

I am looking forward to a productive conversation with you, but if your
next reply is going to have the same strategy of avoiding my key message
and focusing on some other random thing, then I'm very sorry, but I'll
just have to focus my attention somewhere else.
