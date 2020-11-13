Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659F22B211E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKMQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgKMQzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:55:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 200D0217A0;
        Fri, 13 Nov 2020 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605286549;
        bh=4H30enNVLBKMJxvF1mJLsMBpRJaW//i/7xsd63EXN/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0Ka5X3T+ELCdOBY16R5w33GK1KM6qm18goc2Cpgk4wip9dynJTSddWtiGStMUfAKb
         hOvxfMxVYWVt8ffW1Q06Mu1TkDkV44gZ6PwP5yS8Y77ejF/Jd/Z8/O236eAqnvq8kT
         AcXNDclLMReBHkIJ5fvUDrP8Oj4eFUQEHkSjFdF4=
Date:   Fri, 13 Nov 2020 08:55:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-ID: <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-5-andrea.mayer@uniroma2.it>
        <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
        <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 18:49:17 -0700 David Ahern wrote:
> On 11/12/20 6:28 PM, Andrea Mayer wrote:
> > The implementation of SRv6 End.DT4 differs from the the implementation of SRv6
> > End.DT6 due to the different *route input* lookup functions. For IPv6 is it
> > possible to force the routing lookup specifying a routing table through the
> > ip6_pol_route() function (as it is done in the seg6_lookup_any_nexthop()).  
> 
> It is unfortunate that the IPv6 variant got in without the VRF piece.

Should we make it a requirement for this series to also extend the v6
version to support the preferred VRF-based operation? Given VRF is
better and we require v4 features to be implemented for v6?
