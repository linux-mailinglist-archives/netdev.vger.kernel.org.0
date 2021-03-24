Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C9A347929
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhCXNBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCXNBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:01:21 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AC2C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:01:19 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o126so22318706lfa.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0wIq6XFuYrFzUFVZqe1Mc6XSTOKQvIOICnO43R6w4ZQ=;
        b=wM5iwapjE51OfHt0rR9tokY/T7TNglLkBL0hr1qEiUhdIztO2OVEhozsxWP33Ae4jA
         /AGYGEwDhovUDW8yAMUrLfQV9S3EPIS9GNwiFY1eDQ5JrISAJEKoV03ZqJFvP7mKMfz6
         Csjhc4gU5ztr4NP3hPGqS/XbviaiFoidldnvHDr/oytqFB1+bDPb9n8kgI7guxnbZoBJ
         QtNUlOE8MFeQfU/BDTYBmNfpG8VlGUQ8r5//NAp2T9/nQMNidAWVb34kShJJ1FyiCxD+
         82ozSRFga4zYWs+j7kTaMgiRzuY9x1KLbI79ovWJxfp9RgbPExeVZy+31C2K0QGoRXkY
         qrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0wIq6XFuYrFzUFVZqe1Mc6XSTOKQvIOICnO43R6w4ZQ=;
        b=ncxwOxVpijbtp6Fgr8gDZlnLf6GlzPVnl6JTaYAVWTOBgoZAaudBBSSLN0SuFX/+wT
         eM4hT0p7645wXoyb2xy6pSxiK8RlWJoE6goVK4ooxxPvh4qEdxltkh+ZTJzB4JB58WAW
         lFWyQItcvyrWp1Spex8KG2uN7Ra+757OsuqQUSpaO1QfkTqqr1OaR8LDAoP4pu79Yq/f
         fuP995WoMcYGEEmgMhWxN+cseA0Q0g+Ajy8J/3Oog9CB008By6KA6AIaduxNOcydhInZ
         ijf+O1/4/dsQgzH+GyQtvg82uKyFK8m9z/qqs2jctv46Y4JdyDHUdfTl9Ua5fTiE4RVg
         7wFg==
X-Gm-Message-State: AOAM530sv6iPat2D4lM8lIgVEsPuoSACUGLrqx9qDEzqNaztD4Y0jgDp
        PKurFTYr+P4uzDhOz3W23nGJ0iFqORn4zkhg
X-Google-Smtp-Source: ABdhPJyDEugDZhKE3AJ3KaAYp8hhg6dsn7EOujxk8hN6HAVvbVsWYI/1K6kcV2WoFRpv8LWr4Hnquw==
X-Received: by 2002:a19:5e14:: with SMTP id s20mr1965362lfb.110.1616590876671;
        Wed, 24 Mar 2021 06:01:16 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j2sm304952lja.34.2021.03.24.06.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:01:16 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <20210324113403.gtxcdtnsvqriyn26@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com> <20210323190302.2v7ianeuwylxdqjl@skbuf> <8735wlmuxh.fsf@waldekranz.com> <20210323231508.zt2knmica7ecuswf@skbuf> <87y2eclt6m.fsf@waldekranz.com> <20210324113403.gtxcdtnsvqriyn26@skbuf>
Date:   Wed, 24 Mar 2021 14:01:14 +0100
Message-ID: <87sg4kln8l.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 13:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 24, 2021 at 11:52:49AM +0100, Tobias Waldekranz wrote:
>> >> This is the tragedy: I know for a fact that a DSA soft parser exists,
>> >> but because of the aforementioned maze of NDAs and license agreements
>> >> we, the community, cannot have nice things.
>> >
>> > Oh yeah? You can even create your own, if you have nerves of steel and a
>> > thick enough skin to learn to use the "fmc" (Frame Manager Configuration
>> > Tool) program, which is fully open source if you search for it on CAF
>> > (and if you can actually make something out of the source code).
>> 
>> Yes, this is what a colleague of mine has done. Which is how I know that
>> one exists :)
>> 
>> > And this PDF (hidden so well behind the maze of NDAs, that I just had to
>> > google for it, and you don't even need to register to read it):
>> > https://www.nxp.com/docs/en/user-guide/LSDKUG_Rev20.12.pdf
>> > is chock full of information on what you can do with it, see chapters 8.2.5 and 8.2.6.
>> 
>> Right, but this is where it ends. Using the wealth of information you
>> have laid out so far you can use DPAA to do amazing things using open
>> components.
>> 
>> ...unless you have to do something so incredibly advanced and exotic as
>> a masked update of a field. At this point you have two options:
>> 
>> 1. Buy the firmware toolchain, which requires signing an NDA.
>> 2. Buy a single-drop firmware binary for lots of $$$ without any
>>    possibility of getting further updates because "you should really be
>>    using DPAA2".
>
> Uhm, what?
> By "firmware" I assume you mean "FMan microcode"?
>
> To my knowledge, the standard FMan microcode distributed _freely_ with
> the LSDK has support for Header Manipulation, you just need to create a
> Header Manipulation Command Descriptor (HMCD) and pass it to the
> microcode through an O/H port. I believe that:
> (a) the Header Manipulation descriptors allow you to perform raw mask
>     based field updates too, not just for standard protocols

This is not the story we were told.

> (b) fmc already has some support for sending Header Manipulation
>     descriptors to the microcode
>
> And by "firmware toolchain" you mean the FMan microcode SDK?
> https://www.nxp.com/design/software/embedded-software/linux-software-and-development-tools/dpaa-fman-microcode-sdk-source-code-software-kit:DPAA-FMAN-SDK
>
> In the description for that product it says:
>
>   For MOST of NXP communications customers, the microcode that is freely
>   accessible via the NXP LSDK or SDK for QorIQ or Layerscape processors
>   will handle any communications offload task you could throw at the DPAA.
>
> So why on earth would you need that? And does it really surprise you

Because NXP said we needed it.

> that it costs money, especially considering the fact that you're going
> to need heaps of support for it anyway?

No, it surprised me that we had to pay for a solution to a problem that
we were promised would be solvable using the stock firmware.

> Seriously, what is your point? You're complaining about having the
> option to write your own microcode for the RISC cores inside the network
> controller, when the standard one already comes with a lot of features?
> What would you prefer, not having that option?
>
> This is a strawman. None of the features we talked about in this thread,
> soft parser for DSA tags or masked header manipulation, should require
> custom microcode.

I never made that claim. I was describing our experience with DPAA on
the whole.
