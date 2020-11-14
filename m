Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41592B2AAA
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKNBwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:52:16 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:48882 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgKNBwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 20:52:15 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0AE1p4m7032763;
        Sat, 14 Nov 2020 02:51:09 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id AB44A12005F;
        Sat, 14 Nov 2020 02:50:58 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605318659; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oK6t0eGA+ruC5HbNeaHODPDeco0lBrxmpa9spNCcLcg=;
        b=tqvIpEcz6oeUL/Z28O+CCT0/e1V05n3VJL4eMFIYRGZtVU2FZGau6YehzX0OeJKn1n9Dnv
        GhRGZXwpr1R5YuBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605318659; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oK6t0eGA+ruC5HbNeaHODPDeco0lBrxmpa9spNCcLcg=;
        b=Z0AsAAdMP1zuLZI9ETRjXGiQsfgXXouUMzWu7ExrnzzjXhvlib7WvXIyo9uzM+UT++Bssw
        nv7LkIQFpDlFh3ZNnZOK4nLKw53WpyZLE63rF69Q9WLRxoxbEieecolA8tOjZShYQVtvTf
        jWl740EJWkr2Egawede+y6xS7ii35dT5OggohBbfQCX9243dfHXyBVEBzdgfs4FI1ah1Ln
        W5JlfBsc0kV6n77cMrrqWd4A6BKROSSmLl4dCGCX/12swmPPE8p5tFg0uqU0IfxeL3GesD
        duamvYAVXXLYX8Kygt514oydB/MaMXL9F53T4Kgv6+MUhjEhQOiWm02GBJU0OA==
Date:   Sat, 14 Nov 2020 02:50:58 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
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
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-Id: <20201114025058.25ae815024ba77d59666a7ab@uniroma2.it>
In-Reply-To: <20201113155437.7d82550b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-5-andrea.mayer@uniroma2.it>
        <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
        <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
        <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
        <09381c96-42a3-91cd-951b-f970cd8e52cb@gmail.com>
        <20201113114036.18e40b32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113134010.5eb2a154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114000024.614c6c097050188abc87a7ff@uniroma2.it>
        <20201113155437.7d82550b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
Please see my responses inline:

On Fri, 13 Nov 2020 15:54:37 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat, 14 Nov 2020 00:00:24 +0100 Andrea Mayer wrote:
> > On Fri, 13 Nov 2020 13:40:10 -0800
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > 
> > I can tackle the v6 version but how do we face the compatibility issue raised
> > by Stefano in his message?
> > 
> > if it is ok to implement a uAPI that breaks the existing scripts, it is relatively
> > easy to replicate the VRF-based approach also in v6.
> 
> We need to keep existing End.DT6 as is, and add a separate
> implementation.

ok

>
> The way to distinguish between the two could be either by

> 1) passing via
> netlink a flag attribute (which would request use of VRF in both
> cases);

yes, feasible... see UAPI solution 1

> 2) using a different attribute than SEG6_LOCAL_TABLE for the
> table id (or perhaps passing VRF's ifindex instead), e.g.
> SEG6_LOCAL_TABLE_VRF;

yes, feasible... see UAPI solution 2

> 3) or adding a new command
> (SEG6_LOCAL_ACTION_END_DT6_VRF) which would behave like End.DT4.

no, we prefer not to add a new command, because it is better to keep a 
semantic one-to-one relationship between these commands and the SRv6 
behaviors defined in the draft.


UAPI solution 1

we add a new parameter "vrfmode". DT4 can only be used with the 
vrfmode parameter (hence it is a required parameter for DT4).
DT6 can be used with "vrfmode" (new vrf based mode) or without "vrfmode" 
(legacy mode)(hence "vrfmode" is an optional parameter for DT6)

UAPI solution 1 examples:

ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrfmode table 100 dev eth0
ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrfmode table 100 dev eth0
ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0

UAPI solution 2

we turn "table" into an optional parameter and we add the "vrftable" optional
parameter. DT4 can only be used with the "vrftable" (hence it is a required
parameter for DT4).
DT6 can be used with "vrftable" (new vrf mode) or with "table" (legacy mode)
(hence it is an optional parameter for DT6).

UAPI solution 2 examples:

ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrftable 100 dev eth0
ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrftable 100 dev eth0
ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0

IMO solution 2 is nicer from UAPI POV because we always have only one 
parameter, maybe solution 1 is slightly easier to implement, all in all 
we prefer solution 2 but we can go for 1 if you prefer.

Waiting for your advice!

Thanks,
Andrea
