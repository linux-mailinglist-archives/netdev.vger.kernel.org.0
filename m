Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F552B28F1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgKMXBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:01:44 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:46406 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgKMXBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:01:44 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ADN0U0X031218;
        Sat, 14 Nov 2020 00:00:35 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 894221228D0;
        Sat, 14 Nov 2020 00:00:24 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605308425; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC/sGHYI6UNlSfTzq2TE0JHnhzPIl2+VJNmgyd0p6W0=;
        b=98+ApqLFEqEKJJAuSPJXCvyP/VPj/VyN3VwXFW+93ICqTsomH5I7p/u9J8EuWu6JVxbs7i
        SqcCXvFZwPK9WzDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605308425; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC/sGHYI6UNlSfTzq2TE0JHnhzPIl2+VJNmgyd0p6W0=;
        b=Zc340CPggSMx8MU100dDq31ThDfdOGeIsQszKQq3/mrVmugHUePavLna6Nmbyr5xJ20wdu
        yTT7iWfMsFe7hGu5U7hqEsJsrdIeK2y9hvzF9lOcFPZUg1MiQ63QB7RQ2Fmr4UkVZ3RwGS
        ZEriz3awmG/eJ64/uQAtUfN+FwKX5190kiz0jUG7Ro/WTSW2rmAubzqdAmw2pQsYKc6Ii5
        IN0YSEXcWYQWjQ8zP4E3OTsjwoYVkgzhXrDz06DmSiq6BY5D3IvYS6p/WS1Kw9ItosDOLM
        FapOI6CKtOanTsoWhOxXoNMJ74R34hxbS16d7YVeI9QT2nnkDxEScRsbI4mI0g==
Date:   Sat, 14 Nov 2020 00:00:24 +0100
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
Message-Id: <20201114000024.614c6c097050188abc87a7ff@uniroma2.it>
In-Reply-To: <20201113134010.5eb2a154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Fri, 13 Nov 2020 13:40:10 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 13 Nov 2020 11:40:36 -0800 Jakub Kicinski wrote:
> > > agreed. The v6 variant has existed for a while. The v4 version is
> > > independent.  
> > 
> > Okay, I'm not sure what's the right call so I asked DaveM.
> 
> DaveM raised a concern that unless we implement v6 now we can't be sure
> the interface we create for v4 is going to fit there.
> 
> So Andrea unless it's a major hurdle, could you take a stab at the v6
> version with VRFs as part of this series?

I can tackle the v6 version but how do we face the compatibility issue raised
by Stefano in his message?

if it is ok to implement a uAPI that breaks the existing scripts, it is relatively
easy to replicate the VRF-based approach also in v6.

Waiting for your advice!

Thanks,
Andrea
