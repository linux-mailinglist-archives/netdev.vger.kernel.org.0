Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C3F347779
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCXLe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhCXLeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 07:34:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F6AC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 04:34:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id bf3so27248549edb.6
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 04:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VODb8hE9tm0LryOldcOCHIHaQsNpMpD5+JuB5l/8vgQ=;
        b=eYsRJZPe5rtr9XyxEQx3UPvoDJ+sCxlRbNvCXVNQZ/G+W4pqyhnv4W88x6blflp3gf
         bOPeLS837axGe8X/Pd0nYy/viiOx9pc9VwhgBhOvLXMnXI0O1xtlEx/sxUpCiYpOY9Am
         KBX8TWKAaDEaACWMr9faX6WOi6n1pF3lby2K9wGxyiacAbUZfS7nxAga19M0gsQoA62u
         Yoycyl34msa9ocq7G1oMJyZ2pxMC/ybwqiJwKip+pCS97DmeE6WGyaOe+L8WHRw0Pm1X
         10QLlpgRZ2mk6NHPVrRqXxeQOOaZ7q5CYhYb+M/SnSglI/sLcW+Pp6bvN6dGItyh4tft
         e6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VODb8hE9tm0LryOldcOCHIHaQsNpMpD5+JuB5l/8vgQ=;
        b=g8QcUAojlSZYbmQgF36tBAEGbfTBXaW9bZ/VJxXnq3rb++q29zlx5Ge6Re+5Ws00Sz
         ztT+wejLx8poFEiy5yvT7uzHXSZ2RFIw6d86JiXCSdKisEbWGwLovtDA3ZZaYePCxFWj
         Zyf17eB/V7vBq8hYJ+HzSmcVlSX8+K9BwdXGpT1cwpo2gdmJb4phJlS0aqfjHtAD1ouk
         FdBox96KwzivvaOIHBg5QcmWSDBO4VvBnfRHVc3lmL2XxMqfBuaYm6Bq4/zHisqmh2pP
         Y232C7YZgOx93aEGLTfmp9SW1NYfNwyqqRANchho8gDylLjQCdlRKWS95M5+fJ0AKlMV
         P6XA==
X-Gm-Message-State: AOAM532S1ciW+lqG89MU1J0QrqyIpmcyW7pV5DR0vzn5ocw/ZknX9nrt
        5sq36Zn9esZHEZqBQ/0q5po=
X-Google-Smtp-Source: ABdhPJw97xNwqylejxyqUtskoF+9qOd9vM/G9EjnLDHcN1U0Y4GLJrjgdMQoERZLGDOONl2uzVrHVQ==
X-Received: by 2002:a50:ec0e:: with SMTP id g14mr2971148edr.264.1616585644912;
        Wed, 24 Mar 2021 04:34:04 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a9sm1006901eds.33.2021.03.24.04.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 04:34:04 -0700 (PDT)
Date:   Wed, 24 Mar 2021 13:34:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210324113403.gtxcdtnsvqriyn26@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
 <20210323231508.zt2knmica7ecuswf@skbuf>
 <87y2eclt6m.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2eclt6m.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:52:49AM +0100, Tobias Waldekranz wrote:
> >> This is the tragedy: I know for a fact that a DSA soft parser exists,
> >> but because of the aforementioned maze of NDAs and license agreements
> >> we, the community, cannot have nice things.
> >
> > Oh yeah? You can even create your own, if you have nerves of steel and a
> > thick enough skin to learn to use the "fmc" (Frame Manager Configuration
> > Tool) program, which is fully open source if you search for it on CAF
> > (and if you can actually make something out of the source code).
> 
> Yes, this is what a colleague of mine has done. Which is how I know that
> one exists :)
> 
> > And this PDF (hidden so well behind the maze of NDAs, that I just had to
> > google for it, and you don't even need to register to read it):
> > https://www.nxp.com/docs/en/user-guide/LSDKUG_Rev20.12.pdf
> > is chock full of information on what you can do with it, see chapters 8.2.5 and 8.2.6.
> 
> Right, but this is where it ends. Using the wealth of information you
> have laid out so far you can use DPAA to do amazing things using open
> components.
> 
> ...unless you have to do something so incredibly advanced and exotic as
> a masked update of a field. At this point you have two options:
> 
> 1. Buy the firmware toolchain, which requires signing an NDA.
> 2. Buy a single-drop firmware binary for lots of $$$ without any
>    possibility of getting further updates because "you should really be
>    using DPAA2".

Uhm, what?
By "firmware" I assume you mean "FMan microcode"?

To my knowledge, the standard FMan microcode distributed _freely_ with
the LSDK has support for Header Manipulation, you just need to create a
Header Manipulation Command Descriptor (HMCD) and pass it to the
microcode through an O/H port. I believe that:
(a) the Header Manipulation descriptors allow you to perform raw mask
    based field updates too, not just for standard protocols
(b) fmc already has some support for sending Header Manipulation
    descriptors to the microcode

And by "firmware toolchain" you mean the FMan microcode SDK?
https://www.nxp.com/design/software/embedded-software/linux-software-and-development-tools/dpaa-fman-microcode-sdk-source-code-software-kit:DPAA-FMAN-SDK

In the description for that product it says:

  For MOST of NXP communications customers, the microcode that is freely
  accessible via the NXP LSDK or SDK for QorIQ or Layerscape processors
  will handle any communications offload task you could throw at the DPAA.

So why on earth would you need that? And does it really surprise you
that it costs money, especially considering the fact that you're going
to need heaps of support for it anyway?

Seriously, what is your point? You're complaining about having the
option to write your own microcode for the RISC cores inside the network
controller, when the standard one already comes with a lot of features?
What would you prefer, not having that option?

This is a strawman. None of the features we talked about in this thread,
soft parser for DSA tags or masked header manipulation, should require
custom microcode.
