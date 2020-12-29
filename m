Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC862E753B
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 00:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgL2X3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 18:29:25 -0500
Received: from foss.arm.com ([217.140.110.172]:50358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL2X3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 18:29:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8C9030E;
        Tue, 29 Dec 2020 15:28:38 -0800 (PST)
Received: from e107158-lin (e107158-lin.cambridge.arm.com [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A99CB3F6CF;
        Tue, 29 Dec 2020 15:28:37 -0800 (PST)
Date:   Tue, 29 Dec 2020 23:28:35 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201229173401.GH450923@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri

On 12/29/20 18:34, Jiri Olsa wrote:
> On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > Hi
> > 
> > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > stage
> > 
> > 	FAILED unresolved symbol udp6_sock
> > 
> > I cross compile for arm64. My .config is attached.
> > 
> > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > 
> > Have you seen this before? I couldn't find a specific report about this
> > problem.
> > 
> > Let me know if you need more info.
> 
> hi,
> this looks like symptom of the gcc DWARF bug we were
> dealing with recently:
> 
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
>   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> 
> what pahole/gcc version are you using?

I'm on gcc 9.3.0

	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0

I was on pahole v1.17. I moved to v1.19 but I still see the same problem.

Thanks

--
Qais Yousef

> 
> we fixed pahole (v1.19) to workaround the issue and AFAIK
> there's already gcc fix as well
