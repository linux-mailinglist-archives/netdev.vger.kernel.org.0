Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE11F7667
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFLKBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 06:01:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42637 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbgFLKBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 06:01:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CD8785C00C6;
        Fri, 12 Jun 2020 06:01:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 12 Jun 2020 06:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=k9Hc0n0ZZ+r2PM/CxaFyy+acOdU
        13GIRtpmvbo4Scvg=; b=D5L2iCYNJvs1gTEpItjsH85GlZQdEXixFw1xImAjDYh
        KDXQu+rOyhfQ+V7T8pvJk290aZowGukLNGIRDftlZe/eg1g3qjrjagDPPUe9wGs9
        Ikc0VfpF6fWsAJjCwnu5eq7Z3R/t1A3F0rFihxstBLei50s5yrd9h7E917qFuZ4R
        k6Q1P3gX4TsLe1KCrRHwUIlj+WJumV561XjIrwie2sTGzVBuES72LoG2qufr167H
        wppqGhfsyCCiyBbD/A9oTIFISQ1Q99dUTYIUXCHK9wCM7Wc5y8pv1UJrmhXbxeKM
        qj+4kxxt2auxu1EUsFDteF45zY+danP6qp0ZioDUyHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k9Hc0n
        0ZZ+r2PM/CxaFyy+acOdU13GIRtpmvbo4Scvg=; b=SqZY9HAvgKrAzKIwAteYtM
        bHUxJ+E/+SOf+uczdqw8tuPaWBE1vBEzyvLFe0QsaZaR+/78zDIYUD3q0bE/igt9
        x/dNzVBG231z/y9tLosoADDA2cTn5WJ88AQ/I0Iwt5rflDA6ZjoSdYCCVDOECd/E
        vn27Xu6L0m+DJ3oiv6DxDGhWdS03WDQvPMrk+m+nVXOJCKRSKaMrXrFNG2Qs4uLT
        ajKJFgRMGGiiXmr2vrQTFEb8oAQl9UT/yu6tVbOyztwR3IpldGerro2bRFJONJjO
        KB5x54Cz+k4kabCJKsz8biKLFsLEGHdFXx5jJ8RZAacPVBJO2Dwhmk+39I+CEUdg
        ==
X-ME-Sender: <xms:c1LjXjtbUoLQLWh24Xw1PNX9tj9ckKsftBYTgk1LN8IAXyi5hkrp7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeiuddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:c1LjXkf2YQed55oCLiGxpGONoKGwz3_5Bzz7s7W28SwIdqFHt6b5EQ>
    <xmx:c1LjXmz-zbq9KoJJYlstbCUaCmhDHp4u1BrI6iPw1WEYE8IpSNB-MA>
    <xmx:c1LjXiPIvRQsyC1qBv12yXEl1eNsJ7pSkpyr4qc23OlFOkgHJQP_dQ>
    <xmx:d1LjXukvL5SdC2m3M83mE2b74Bu4DICQVt7-6ZeUEMwQp2ukNnU5RA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F3ACE328005E;
        Fri, 12 Jun 2020 06:01:22 -0400 (EDT)
Date:   Fri, 12 Jun 2020 12:01:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Cheng Jian <cj.chengjian@huawei.com>,
        Chen Wandun <chenwandun@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] perf tools: Fix potential memory leaks in perf
 events parser
Message-ID: <20200612100111.GA3157576@kroah.com>
References: <20200611145605.21427-1-chenwandun@huawei.com>
 <20200611145605.21427-2-chenwandun@huawei.com>
 <51efcf82-4c0c-70d3-9700-6969e6decde1@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51efcf82-4c0c-70d3-9700-6969e6decde1@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 08:50:58PM +0200, Markus Elfring wrote:
> > Fix memory leak of in function parse_events_term__sym_hw()
> > and parse_events_term__clone() when error occur.
> 
> How do you think about a wording variant like the following?
> 
>    Release a configuration object after a string duplication failed.
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
