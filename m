Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670952B2AD7
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgKNCbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:31:02 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:49390 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNCbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:31:01 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0AE2Tshq000464;
        Sat, 14 Nov 2020 03:29:59 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 313E412005F;
        Sat, 14 Nov 2020 03:29:49 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605320990; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nz2NLR1bzF0MfKyYR5/aG6wmtAIw5PPI5RybJ5jIi0=;
        b=QSvj7zSTxoMVu7z+8JtE47kIH33tcERcv/Fx6mB5ZkIcv6kNqrSzZzlblbwIRNCuoTnjaK
        rq9doYnR7OljotAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605320990; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nz2NLR1bzF0MfKyYR5/aG6wmtAIw5PPI5RybJ5jIi0=;
        b=TepR/K0a2H8zHCikg79mWYFeQP3ZvTNrcLwXQBMyfh4J4T7j0RQVSGU2uHZs98JOMe0P1K
        9tcL663VlJSgHH4JKPeue9KB1puG5kn7FQoN5mt//DPhiHPJNpU2mhXH+dp1cs7L0ger6n
        KSV1DF/A9LspjIa2sfiom7nqYxyrmn3qDJb04+V3fbQt5Hvp1khk/GCNn7SPCd5vSuFSHx
        9JJy9NF/YUgzSCq3phNxt9/RRDa+etom0ApGVKVC3RHYi75fRR7+KEsShO5fR/wDiX4kDg
        Nz7P+zNPpbNfvlVvsbZ24eKwJs1LY6H7UMUdSC6te4EMt39h1tkNZVklpc1Nzg==
Date:   Sat, 14 Nov 2020 03:29:48 +0100
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
Message-Id: <20201114032948.895abbf4d9a12758fc702ce6@uniroma2.it>
In-Reply-To: <20201113180126.33bc1045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
        <20201114025058.25ae815024ba77d59666a7ab@uniroma2.it>
        <20201113180126.33bc1045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Fri, 13 Nov 2020 18:01:26 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> > UAPI solution 2
> > 
> > we turn "table" into an optional parameter and we add the "vrftable" optional
> > parameter. DT4 can only be used with the "vrftable" (hence it is a required
> > parameter for DT4).
> > DT6 can be used with "vrftable" (new vrf mode) or with "table" (legacy mode)
> > (hence it is an optional parameter for DT6).
> > 
> > UAPI solution 2 examples:
> > 
> > ip -6 route add 2001:db8::1/128 encap seg6local action End.DT4 vrftable 100 dev eth0
> > ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 vrftable 100 dev eth0
> > ip -6 route add 2001:db8::1/128 encap seg6local action End.DT6 table 100 dev eth0
> > 
> > IMO solution 2 is nicer from UAPI POV because we always have only one 
> > parameter, maybe solution 1 is slightly easier to implement, all in all 
> > we prefer solution 2 but we can go for 1 if you prefer.
> 
> Agreed, 2 looks better to me as well. But let's not conflate uABI with
> iproute2's command line. I'm more concerned about the kernel ABI.

Sorry I was a little imprecise here. I reported only the user command perspective.
From the kernel point of view in solution 2 the vrftable will be a new
[SEG6_LOCAL_VRFTABLE] optional parameter.

> BTW you prefer to operate on tables (and therefore require
> net.vrf.strict_mode=1) because that's closer to the spirit of the RFC,
> correct? As I said from the implementation perspective passing any VRF
> ifindex down from user space to the kernel should be fine?

Yes, I definitely prefer to operate on tables (and so on the table ID) due to
the spirit of the RFC. We have discussed in depth this design choice with
David Ahern when implementing the DT4 patch and we are confident that operating
with VRF strict mode is a sound approach also for DT6. 

Thanks
Andrea,
