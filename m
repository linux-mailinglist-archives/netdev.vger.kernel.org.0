Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AB2347988
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhCXNYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhCXNYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:24:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0154EC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:24:05 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l4so32826895ejc.10
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rc56inwkkfB0f+O1lJ3Y86UFuxahIugag5/occy9VQs=;
        b=oGgt46aMDAXXRrPvbv12Cqn2PpVoArvHMG1vDWJ2ap/h6+6+dzjyeutsG5iwLQ88FL
         wjF9r2WQWr78W9LCX4ot/IQhEmrZh76o0sCJaaBd5aaUx46R8zQWUy9YibCz/PsM2/5V
         QxfTtApu7XHMd6gSIEiRMRig85j2ehTLtGimf/GflPdkbDg31AzwdG8cspiSKcSn6wUR
         rJaGPCD1lJ2EBTEKmMgUbJLozXqpsiWq+8/uz5xNK0RxnPP1RbDwUhhx0AFEI6LlsCP2
         Igy6Gkr2dUD86MaHK440c+bMSF9uYnt2553RmrSoLwaVWFmPzOK5XQZjilliY7Eu/i6E
         Ru/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rc56inwkkfB0f+O1lJ3Y86UFuxahIugag5/occy9VQs=;
        b=cRpt8LLyVnL9cJrl1BGgWnsk0m2s2tyx+vjiz9YKIuEStl3f0BjbOqcTd5W2bz8vGZ
         vnN/yheYd8RfTCZcc6cfLFbUY2vTEtqk9I+TyxrmZILb6+YdkzGrfBSnWHAIY54xulL8
         ++EUWzvAvUBSbYuQun3oHOBbep0EfUlqVKtnfxbLavGWSooUcdgVn9YiugdUIphcIDCG
         2syTuzPrNL8gBSeNwXP3XcqVqA1JB/Ol8USWDzb+Zgo1LSC44m8Mn0urcHRVX7HZWlDW
         ZUETsEQojHhhpmfEF1Z8GBkRrQZainlQ/2EZ3P2lsGdugwxZ8WWZuTURp68sHnNv/wKf
         lGGg==
X-Gm-Message-State: AOAM533YRT1cscNYZOIRsLuBrZpeZcTv1jnO1i5CIDpgVNDtzXbWXO4q
        VyIv7WhK4bkurbCoLUYq2m8=
X-Google-Smtp-Source: ABdhPJw/3Hm9hHWVbdAmizQH9h6Wx+1fzGlbbVWO1fRrxfyXYtJh0zJDYDOZIbiAIUjRxmog8W6K/w==
X-Received: by 2002:a17:906:4e17:: with SMTP id z23mr3676733eju.439.1616592243666;
        Wed, 24 Mar 2021 06:24:03 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s13sm1133495edr.86.2021.03.24.06.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:24:02 -0700 (PDT)
Date:   Wed, 24 Mar 2021 15:24:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210324132401.twbjcqw7vgiqscn2@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
 <20210323231508.zt2knmica7ecuswf@skbuf>
 <87y2eclt6m.fsf@waldekranz.com>
 <20210324113403.gtxcdtnsvqriyn26@skbuf>
 <87sg4kln8l.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg4kln8l.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 02:01:14PM +0100, Tobias Waldekranz wrote:
> On Wed, Mar 24, 2021 at 13:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, Mar 24, 2021 at 11:52:49AM +0100, Tobias Waldekranz wrote:
> >> >> This is the tragedy: I know for a fact that a DSA soft parser exists,
> >> >> but because of the aforementioned maze of NDAs and license agreements
> >> >> we, the community, cannot have nice things.
> >> >
> >> > Oh yeah? You can even create your own, if you have nerves of steel and a
> >> > thick enough skin to learn to use the "fmc" (Frame Manager Configuration
> >> > Tool) program, which is fully open source if you search for it on CAF
> >> > (and if you can actually make something out of the source code).
> >> 
> >> Yes, this is what a colleague of mine has done. Which is how I know that
> >> one exists :)
> >> 
> >> > And this PDF (hidden so well behind the maze of NDAs, that I just had to
> >> > google for it, and you don't even need to register to read it):
> >> > https://www.nxp.com/docs/en/user-guide/LSDKUG_Rev20.12.pdf
> >> > is chock full of information on what you can do with it, see chapters 8.2.5 and 8.2.6.
> >> 
> >> Right, but this is where it ends. Using the wealth of information you
> >> have laid out so far you can use DPAA to do amazing things using open
> >> components.
> >> 
> >> ...unless you have to do something so incredibly advanced and exotic as
> >> a masked update of a field. At this point you have two options:
> >> 
> >> 1. Buy the firmware toolchain, which requires signing an NDA.
> >> 2. Buy a single-drop firmware binary for lots of $$$ without any
> >>    possibility of getting further updates because "you should really be
> >>    using DPAA2".
> >
> > Uhm, what?
> > By "firmware" I assume you mean "FMan microcode"?
> >
> > To my knowledge, the standard FMan microcode distributed _freely_ with
> > the LSDK has support for Header Manipulation, you just need to create a
> > Header Manipulation Command Descriptor (HMCD) and pass it to the
> > microcode through an O/H port. I believe that:
> > (a) the Header Manipulation descriptors allow you to perform raw mask
> >     based field updates too, not just for standard protocols
> 
> This is not the story we were told.

Wait, aren't we talking about HdrMan OPCODE 0x19 ("Replace Field in Header")?

> > (b) fmc already has some support for sending Header Manipulation
> >     descriptors to the microcode
> >
> > And by "firmware toolchain" you mean the FMan microcode SDK?
> > https://www.nxp.com/design/software/embedded-software/linux-software-and-development-tools/dpaa-fman-microcode-sdk-source-code-software-kit:DPAA-FMAN-SDK
> >
> > In the description for that product it says:
> >
> >   For MOST of NXP communications customers, the microcode that is freely
> >   accessible via the NXP LSDK or SDK for QorIQ or Layerscape processors
> >   will handle any communications offload task you could throw at the DPAA.
> >
> > So why on earth would you need that? And does it really surprise you
> 
> Because NXP said we needed it.
> 
> > that it costs money, especially considering the fact that you're going
> > to need heaps of support for it anyway?
> 
> No, it surprised me that we had to pay for a solution to a problem that
> we were promised would be solvable using the stock firmware.

Maybe the FMan version of your particular device does not support that
HM command, or maybe you needed a slightly different behavior compared
to what HM opcode 0x19 does, and there was a misunderstanding on either
ends resulting in the impression that what you need could be achievable
through that type of descriptor? Either way, the way you phrased things:
| unless you have to do something so incredibly advanced and exotic as
| a masked update of a field
is very unfair, oversimplifying and misleading.

> > Seriously, what is your point? You're complaining about having the
> > option to write your own microcode for the RISC cores inside the network
> > controller, when the standard one already comes with a lot of features?
> > What would you prefer, not having that option?
> >
> > This is a strawman. None of the features we talked about in this thread,
> > soft parser for DSA tags or masked header manipulation, should require
> > custom microcode.
> 
> I never made that claim. I was describing our experience with DPAA on
> the whole.

I fail to see how we ended up talking about custom FMan microcode then.
I did not bring it up, and it is completely irrelevant to the discussion
about soft parser for DSA.
