Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4569FF5F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjBVXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjBVXVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:21:19 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EAB1ADCF;
        Wed, 22 Feb 2023 15:21:17 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id f13so36372161edz.6;
        Wed, 22 Feb 2023 15:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XHPHI+0xLvRkFXF0iZRUSEuwZDEST6h327AbGFueKMI=;
        b=mhM0VFmrQbIByN6jvg1EHI7BpjXbRZMKlNf3dq+sbcKbXGh79lsWx113JEdwJKgV6S
         P5oo3oPbTRwyJ9z8X+auz+NEMnyd8Gccd+5hn3jRXXSQ3BhiFPjRbcrP3rnJobHEryr9
         2/euCaDBBZ4bWKku+ApORsQlz+7GOzCZzrqLny4lv5YOMC7GlfdutyfLhPlJxvGSt4hV
         ARoOL7IY4Zj4IcHoI0SDwE6PVKxs2xHo4w66zqYrCwf47mK2cKKBWjrb96ggdU2W4x+h
         V282em93aRCCgQ0gHhVyM+mlhNWGitd97otYpdYFZ4+MjwsgKurN7k0ngDazW4y6+gr1
         DY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHPHI+0xLvRkFXF0iZRUSEuwZDEST6h327AbGFueKMI=;
        b=2gTf/8VP+AwzoglNw0rUUZZhdSJ91SRsV4AZkpBFuwwpgsKTeKnLkTt2OsnTNEF24V
         PkeXXSANT/fm1GZiIZo0BgOMwzJK3gLCAg/r1/JjpTs/PRs2eWVhmUserg+q0O3gbpEk
         camA4tkdL1ZofEXgmETUVswcD/it24RSxFqBbK3wNUCUShcFZWEYmVppvtyYwXfFAQZn
         JKhHiW+oF7G477kncd/YoKG8PB0RRwcsuEnbRDuqOGprIiNQ19uly7U9eyIyQ/XXHzDr
         CS9RnL+ic/KU/I88mYUowGQfrl90nXRKoMcGlPBI14WTEjFmIzGscAfZ9HP4Qm8DoIUi
         gODQ==
X-Gm-Message-State: AO0yUKU76DbBnJJitFcFyzQvb1nKkfLcWbLJjB7YV+jkqXJbbfR7SPD0
        spepnm66mrV8UUXdDxtyYXQ=
X-Google-Smtp-Source: AK7set/TwAJ1JFqF6X7cdhJbP6yC1RHyRyK3ORpJ/U2j+8A6+Y7JVSnSgvw7q/C+5j51dePyYWWgUg==
X-Received: by 2002:a17:907:1612:b0:8b1:2eef:154c with SMTP id hb18-20020a170907161200b008b12eef154cmr19684628ejc.0.1677108075393;
        Wed, 22 Feb 2023 15:21:15 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qh21-20020a170906ecb500b008e772c97db6sm1242989ejb.128.2023.02.22.15.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 15:21:15 -0800 (PST)
Date:   Thu, 23 Feb 2023 01:21:12 +0200
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
Message-ID: <20230222232112.v7gokdmr34ii2lgt@skbuf>
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 11:58:23PM +0100, Marek Vasut wrote:
> On 2/22/23 23:31, Vladimir Oltean wrote:
> > On Wed, Feb 22, 2023 at 11:05:10PM +0100, Marek Vasut wrote:
> > > OK, to make this simple, can you write a commit message which you consider
> > > acceptable, to close this discussion ?
> > 
> > Nope. The thing is, I'm sure you can, too. Maybe you need to take a
> > break and think about this some more.
> 
> Sorry, not like this and not with this feedback tone.
> 
> If Arun wants to send V2 to fix the actual bug, fine by me.

I don't see what is wrong with this feedback tone, but if you could tell me,
I will make an effort to think about it and see what I can do to change it.

On the other hand, I will not write the commit message for you and that's
not negotiable, because from the replies to me and to Russell, I get the
suspicion that there's some sort of hidden intention for this to be used
against me somehow, and I really have nothing else to base my judgement
on, than your hint that there is a bug there, and the code. But the
driver might behave in much more subtle ways which I may be completely
missing, and I may think that I'm fixing something when I'm not. I have
no way to know that except by booting a board, which I do not have (but
you do). For example, I don't even know which KSZ8 boards rely on pin
strapping and which ones do really need the configuration to be done by
Linux. I'm completely blind, and the refusal to tell you what to write
word by word is a self defense mechanism.

It's good that you gave Arun permission to take your patch, test it on a
KSZ8 (which seems like something he wasn't doing that often during
refactoring), give it an accurate description of the problem, and
resubmit it while keeping your authorship. Arun is an active contributor
and reviewer on the KSZ driver and there's a good chance he might actually
even do it. This is good not because you gave up (IMO for an unjustified
reason, but maybe that's just my perspective), but because there still
is a path forward for the actual bug to get fixed.
