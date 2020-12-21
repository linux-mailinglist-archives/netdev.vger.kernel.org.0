Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1C2E007D
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgLUSzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgLUSzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:55:01 -0500
Date:   Mon, 21 Dec 2020 10:54:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608576861;
        bh=PbjzodWaCbL5910VM0i/jEdqIPjqR1jx/dOhmiI7uMI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0Ql6bE5mUXlNtXm9mggUp6fRNndfiqm+OnmPp3XxUo681FAcu1TO8i19n4BYp8Z6
         bnFQ64Hb/fHbR9/fXr3jLt5PPBATE7n5kyNgjg9CXU+JVamWL5l3V7zPCPw5qxOjvs
         4RFW5lImjK7ba1Kp7DpVgpNh5HtcDmbLvUJEqQxFP6pQAnylhxESlxJ4MZSPdn84Zf
         Ow71u+8YApgTuM0ZK8K6VpI3BsRpVPgQ0nmf+MfRgTpxctJHSexKhGzAf2CfrWmCgh
         evsyxJi7OaKtKLG8gRWQdB+fVhy9ViqZeSxfdPhAPMFnB1PACRZO/pDy1ukzwgjJ8A
         NPF3HeqZipJQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Rainer Suhm <automat@posteo.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: net: tso: add UDP segmentation support: adds regression for
 ax200 upload
Message-ID: <20201221105419.339e68ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
        <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
        <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
        <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
        <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
        <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
        <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
        <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
        <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
        <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
        <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 19:46:23 +0100 Eric Dumazet wrote:
> So maybe the issue is coming from traffic coming from a VM through a
> tun device or something,
> and our handling of GSO_ROBUST / DODGY never cared about setting
> SKB_GSO_TCPV4 or SKB_GSO_TCPV6 if not already given by user space ?
> 
> Or a plain bug somewhere, possibly overwriting  gso_type with 0 or garbage...

Hm, the Arch Linux forum thread linked from the kernel bugzilla
has the user complaining about NFS performance.
