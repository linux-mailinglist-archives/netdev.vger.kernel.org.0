Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8A32C4BF2
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgKZATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:19:10 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:40649 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZATK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:19:10 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0AQ0Hw06001304;
        Thu, 26 Nov 2020 01:18:03 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 9AA07120061;
        Thu, 26 Nov 2020 01:17:53 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1606349874; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qxJTzApCauRHmAmaMhIdC4ArfH2+Q87a2Y+1BiHmwQ=;
        b=DJUquUF7hKq+oGCmbsp3YGHzNC9wbyPsMjxSc738y3rOvHWYhZWooXvAlTFf711Wv+TJ+U
        jzz5smxZtDKq1NDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1606349874; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qxJTzApCauRHmAmaMhIdC4ArfH2+Q87a2Y+1BiHmwQ=;
        b=YrZ+8z+I/p+SJMsZQbSXwkfnYcnqUTgq119p25LYU75iI3U2hwyc+UmvwVHTVIV1Wgsqo0
        UJigkdtPxnzq97lL+m7quIPiEwlsZDK6XSaKKIg2tK54QETxObbmdnmcJGDDukMHhYFK6B
        0Y7azsU6IOavlUzSiQ1xYwfb6fBH5vXImGn0ax7JlGLi3PHMZscY955qa9fyVmw2Q8lDCX
        56BfuSQhYekaNIyk1Bwd+mtC8GvL+iOgAdEYlN+95QxUVD9utFErlyDBoEgi7JlNwQ2nTD
        ME/BfxBZeTrHm0eE+EqBqsmmdNSTZVHoR2KSfYOYDAjM7AYrD2mbr+TeNFTmzA==
Date:   Thu, 26 Nov 2020 01:17:53 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6
 behavior
Message-Id: <20201126011753.e0170a51a4ae7451a6310828@uniroma2.it>
In-Reply-To: <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
        <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Tue, 24 Nov 2020 15:49:04 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> LGTM! Please address the nit and repost without the iproute2 patch.

Thanks for the review of the patchset.

> Mixing the iproute2 patch in has confused patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/list/?series=389667&state=*
> 
> Note how it thinks that the iproute2 patch is part of the kernel
> series. This build bot-y thing is pretty new. I'll add a suggestion 
> to our process documentation not to mix patches.

As discussed, I will resubmit the kernel patches and the iproute2 patch in two
separate patchsets.

Thank you all,
Andrea
