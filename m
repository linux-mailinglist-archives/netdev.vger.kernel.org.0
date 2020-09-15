Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337FF26B895
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgIPAqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgIOM5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:57:51 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E175C06174A;
        Tue, 15 Sep 2020 05:57:46 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t76so3702755oif.7;
        Tue, 15 Sep 2020 05:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35Z9PuAZiRwx18LnYvv6eAzF83sK8y7ch4iPSlOKCZA=;
        b=NX8CSjdCWjlDutNVdFJW0z8rg7uy0CiJWXtqS68KQPzInoBonp00uWcSIMPJh6qz5m
         tHftra52gCgK5Bs/plRj87DMOm+Tl6tlxcEA9G8fdxrQ0CuYg3N7hSqe8Wbbq2kRLzhW
         gNG/U6PGYaZRcxThB+C3IfmJggp5wO+uJHzidJRlnnvGBdduSXejvM/BJOsjogvfeFZK
         ppwwwUZFQHmiHV8pwgGGf0cdirRDCOZ9eeryQ5Sb88X+7A22JekuzuJH9Aox9L+bqVg/
         wtj4JN54iBgZaDwuIlMfB372/ARvRAYxwOs4OvuGt24AavucTS0XHC9GRhlh27FRijQ2
         IGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35Z9PuAZiRwx18LnYvv6eAzF83sK8y7ch4iPSlOKCZA=;
        b=fAp+bEm16ztFKZir5VH0vlKiI05QkXyRARD3ZJvdIyNGxseV285n78qzB1DRSHnIWE
         IPIngi2/5abjrHgSDiiKvL8Zv1kd4i0ebsvnCukpr+8ksrT/ZHogHUJUduA+QVcZ0tA2
         rVlh+iPMFle0e8rbWJ4UL5wcm1H6CHb9HqvWb5fRKNmvh2ryXMoShAbVypQT9EWV6dM+
         PVYBbn4/BxCM9/42dJMUS/bpxYodAO0bos+m/lpxSVgqI0NghsrDkY8hFRt50TdU1OmZ
         jB1pVCOpO/B1741SF1XpR8vUI/RKYTauow33ExOuBkSCToiFlMXGjxhuVsD3MxsSpCz0
         /R/A==
X-Gm-Message-State: AOAM530ZVof2LkI62jtwRHYib55d8hpEEuHPDhoQgoPWwx9pdJ4R6tZV
        NK8PfqF4utFTmY4A4qAezhGku2rdSWOaAYGIcJA=
X-Google-Smtp-Source: ABdhPJyAtHc3t+qtNtsnPLH4KYrugLtHCuJ9iSg78I9Dt41K4b99e863oFaGNGFnCxy+SC1+pRyyZPCgH8bPABTKSQU=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr3116699oie.130.1600174665656;
 Tue, 15 Sep 2020 05:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910161126.30948-13-oded.gabbay@gmail.com>
 <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
 <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
 <20200910133058.0fe0f5e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AM0PR02MB552316B9A1635C18F8464116B8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
 <20200914095018.21808fae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914095018.21808fae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Tue, 15 Sep 2020 15:57:16 +0300
Message-ID: <CAFCwf12o71waoJ9T5kL=M-re8+LzRk+EuzbJARB22wk6+ypQdw@mail.gmail.com>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 7:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Sep 2020 13:48:14 +0000 Omer Shpigelman wrote:
> > On Thu, Sep 10, 2020 at 11:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 10 Sep 2020 23:17:59 +0300 Oded Gabbay wrote:
> > > > > Doesn't seem like this one shows any more information than can be
> > > > > queried with ethtool, right?
> > > > correct, it just displays it in a format that is much more readable
> > >
> > > You can cat /sys/class/net/$ifc/carrier if you want 0/1.
> > >
> > > > > > nic_mac_loopback
> > > > > > is to set a port to loopback mode and out of it. It's not really
> > > > > > configuration but rather a mode change.
> > > > >
> > > > > What is this loopback for? Testing?
> > > >
> > > > Correct.
> > >
> > > Loopback test is commonly implemented via ethtool -t
> >
> > This debugfs entry is only to set the port to loopback mode, not running a loopback test.
> > Hence IMO adding a private flag is more suitable here and please correct me if I'm wrong.
> > But either way, doing that from ethtool instead of debugfs is not a good practice in our case.
> > Due to HW limitations, when we switch a port to/from loopback mode, we need to reset the device.
> > Since ethtool works on specific interface rather than an entire device, we'll need to reset the device 10 times in order to switch the entire device to loopback mode.
> > Moreover, running this command for one interface affects other interfaces which is not desirable when using ethtool AFAIK.
> > Is there any other acceptable debugfs-like mechanism for that?
>
> What's the use for a networking device which only communicates with
> itself, other than testing?

No use, and we do have a suite of tests that runs from user-space on
the device after we move the interfaces to loopback mode.
The main problem, as Omer said, is that we have two H/W bugs:

1. Where you need to reset the entire SoC in case you want to move a
single interface into (or out of) loopback mode. So doing it via
ethtool will cause a reset to the entire SoC, and if you want to move
all 10 ports to loopback mode, you need to reset the device 10 times
before you can actually use that.

2. Our 10 ports are divided into 5 groups of 2 ports each, from H/W
POV. That means if you move port 0 to loopback mode, it will affect
port 1 (and vice-versa). I don't think we want that behavior.

That's why we need this specific exception to the rule and do it via
debugfs. I understand it is not common practice, but due to H/W bugs
we can't workaround, we ask this exception.

Thanks,
Oded
