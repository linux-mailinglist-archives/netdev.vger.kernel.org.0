Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2034742E785
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 06:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhJOEOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 00:14:08 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51966
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhJOEOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 00:14:07 -0400
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0B50040013
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634271120;
        bh=VkQNKanW6J45PUNBM67VvUtIKTUpwQuF1nL5FyFppEE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=c37he0BdOhePTj6VKY5MRr4NWuYcRpEBK1Jh5mzS2QqffuHSNAMwrr9WTX3QG4Jlg
         TOLwjnha18pA/u/lbur2VDejuFQrLAch6GIhvkUkP31WoSyPkg3pEMfcW3xUTwDP3q
         BZ3K/avyMbod+sdQwtpDjzM8aWGb9jJrqvVPjH6TfWyAHOzntBpXXbFHdx2PO0Gyna
         IH73Bxf4tzZKfwwp1FQ8E8h/FpAHKfl91VGd/yU38S7ns1FxkSFzFb+IoGbMyJQsGM
         /jTVuRhTGxp9pRjBtmvkpWlXGmq4bdRu+sJ01wrCesKa3RqgelQyJ4mfUw26hs6wYf
         CehlUdwOuS5aA==
Received: by mail-ot1-f69.google.com with SMTP id z15-20020a9d71cf000000b0055036817463so5001704otj.0
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 21:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VkQNKanW6J45PUNBM67VvUtIKTUpwQuF1nL5FyFppEE=;
        b=KK63noCimBZPMmziIOgsjoms0hkHAm+7A/+gKsDdeOoaye7bbkf7+VtbDv4LVioohK
         7xoElY/3WFQ1Cdtt4cWvsuk3/rgDdJkSuWaUEr0ePkC4Ji3PH1k/1MhoAlvx3D6dEVlG
         E7jSW2QjcJY5Rs/XZIOCmLyXjzTs9ZZ5qeNF+bFjaWlxeCwf/4UxkzxFmGYRfAQkDhhj
         qzOKyZtHzW1icrjbLA70MBD/y3B+LYb2ccZPclOnCz2PRYx7ZMxz4Kq8ByoCnOOH9bNl
         00eLLRUBP5HtpUb06CHyMRmocB7MDEoMGVsTFh30EmtGwJvASxqj+x8RQ6ccjQCGISDh
         afSw==
X-Gm-Message-State: AOAM533WXg8syK/eEZxRYnzQCGxvYR+mP6SMLVGWq5KHfOvVOgSlhAvs
        7NzjEjrQ32Q6X1b9JSAl1g9Xn9LprvJPy9jDMr3ExsBFDX2BWlstTnFvFdciM2HQwNrMwaQkdLx
        7rj8ThlcWZ3NjCEiBl8Dp9jOzlmbNb2XGPs/3OJuQ/EX4G7BFdw==
X-Received: by 2002:a05:6808:10d5:: with SMTP id s21mr16056003ois.98.1634271118912;
        Thu, 14 Oct 2021 21:11:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaiHm2G7XZVZEqFR4bQ7ScvEI4IpC62Z7F9tOh8xzse8b/KH/rrxlb0aJs1f/fExK7bOuM0e6I+M3e6iNUcqE=
X-Received: by 2002:a05:6808:10d5:: with SMTP id s21mr16055983ois.98.1634271118568;
 Thu, 14 Oct 2021 21:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAAd53p4v+CmupCu2+3vY5N64WKkxcNvpk1M7+hhNoposx+aYCg@mail.gmail.com>
 <20211008135821.GA1326355@bhelgaas>
In-Reply-To: <20211008135821.GA1326355@bhelgaas>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 15 Oct 2021 12:11:47 +0800
Message-ID: <CAAd53p5w_tE8URs0R7eog6X-kMSUQAeLiGS-CvDvnfQq+=i3TA@mail.gmail.com>
Subject: Re: [RFC] [PATCH net-next v6 3/3] r8169: Implement dynamic ASPM mechanism
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 8, 2021 at 9:58 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Fri, Oct 08, 2021 at 02:18:55PM +0800, Kai-Heng Feng wrote:
> > On Fri, Oct 8, 2021 at 3:11 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Fri, Oct 08, 2021 at 12:15:52AM +0800, Kai-Heng Feng wrote:
> > > > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > > > Same issue can be observed with older vendor drivers.
> > > >
> > > > The issue is however solved by the latest vendor driver. There's a new
> > > > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > > > more than 10 packets per second, and vice versa. The possible reason for
> > > > this is likely because the buffer on the chip is too small for its ASPM
> > > > exit latency.
> > > > ...
>
> > > I suppose that on the Intel system, if we enable ASPM, the link goes
> > > to L1.2, and the NIC immediately receives 1000 packets in that second
> > > before we can disable ASPM again, we probably drop a few packets?
> > >
> > > Whereas on the AMD system, we probably *never* drop any packets even
> > > with L1.2 enabled all the time?
> >
> > Yes and yes.
>
> The fact that we drop some packets with dynamic ASPM on the Intel
> system means we must be giving up some performance.
>
> And I guess that on the AMD system, we should get full performance but
> we must be using a little more power (probably unmeasurable) because
> ASPM *could* be always enabled but dynamic ASPM disables it some of
> the time.

Yes that's the case here.

>
> > > And if we actually knew the root cause and could set the correct LTR
> > > values or whatever is wrong on the Intel system, we probably wouldn't
> > > need this dynamic scheme?
> >
> > Because Realtek already implemented the dynamic ASPM workaround in
> > their Windows and Linux driver, they never bother to find the root
> > cause.
> > So we'll never know what really happens here.
>
> Looks like it.  Somebody with a PCIe analyzer could probably make
> progress, but I agree, that doesn't seem likely.
>
> Realtek no doubt has the equipment to do this, but apparently they
> don't think it's worthwhile.  In their defense, the Linux ASPM code is
> pretty impenetrable and there could be a problem there that causes or
> contributes to this.

I do hope they can put more effort on their ethernet driver like what
they do on their wireless drivers.

Kai-Heng

>
> Bjorn
