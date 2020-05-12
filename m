Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3FF1D02C0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 01:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgELXBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 19:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 19:01:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BC8C061A0C;
        Tue, 12 May 2020 16:01:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n11so6865249pgl.9;
        Tue, 12 May 2020 16:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lkp9exZ0uzOe9ulySGpCwFGvLvSbRWhZCdrUhtlCelY=;
        b=Uhy6KSbMUIq2krLCXmjhn4rx8FhpDkxiPnHthvjbGl0bO/xtleadW4qlUkLnrNPi2x
         odTP9tLL/Cdl1jh8gsdGNS5Qo15G4Rzx+hd/f4daaYtsmzKakB80VHBE8r1K6oEflPLZ
         wmApeZLYC1Sm8XTmG8GlBvH3/QF5EcSFtkziSsj7jNMEevcD5zRwnRPg7KLNhCi/7V8G
         HlBnSCVmirNJ5cxR9zomMf3FI6GGDVBgZLWZlnLew5EmZhu6El21YTHvciv+X7JLtSfJ
         3X5EM207nPNLsfcndQVPlBWxTANPSvx8kKficr2A3oIpswl3bDGyokiPo08xmtPeSlgW
         1D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lkp9exZ0uzOe9ulySGpCwFGvLvSbRWhZCdrUhtlCelY=;
        b=T65ya+AP5BjqDmuTLCZ7JxNpzhHsi3Aesb2+ptbZvfHzD5z5sTxMvblSNlJKFWfE6O
         E5AcRGZFFi/ERpH7rWSA6gyadF0wi4VAfv2LoQfXk6wHS7WpgYW1aPEEQ+1Lufp7Jvsr
         QVR7+iixnq9zK+HjoNSMd9cO5RaWhCgX/s/SF9rb3mxCKb+LvSFmItNCFY+7y4Lpdfmu
         PeI7lCtHJ3QLgBQZyH11Azj6+JRy51+eR5xtAKs43h8R4YVIJICyJbNqeeVTmyvVW0ma
         pgJ0bKUBwRfPDyVeOGSi7d6I3lrmgDZsimo4r3J6pG2yvnlgca8fs631SvyHL6Nc3y0Y
         PTjw==
X-Gm-Message-State: AGi0PubB2YmShexg5Ugkks5hP33zJze3ehP87NeF3Mdy0AaUBuXFl9dk
        6/dyEZBae6SqsWZ9KgzWh4M=
X-Google-Smtp-Source: APiQypL6sC2EeqdTezP31wEP87GDKMOvl0zUN9UdDX5R5ZyktmQnU/cfe8WZIACklOupws2p4X0cpQ==
X-Received: by 2002:a63:4f0f:: with SMTP id d15mr21472347pgb.339.1589324474036;
        Tue, 12 May 2020 16:01:14 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:68dc])
        by smtp.gmail.com with ESMTPSA id w125sm11446409pgw.22.2020.05.12.16.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 16:01:13 -0700 (PDT)
Date:   Tue, 12 May 2020 16:01:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512230111.xvuenymehvzhhmot@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <311508c5-b80f-498e-2d0a-b98fe751ead9@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311508c5-b80f-498e-2d0a-b98fe751ead9@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:27:33PM +0200, Daniel Borkmann wrote:
> On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
> [...]
> > @@ -2880,8 +2933,6 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
> >   	struct bpf_prog *prog;
> >   	int ret = -ENOTSUPP;
> > -	if (!capable(CAP_SYS_ADMIN))
> > -		return -EPERM;
> 
> Should above be under bpf_capable() as well or is the intention to really let
> (fully) unpriv users run sk_filter test progs here? I would assume only progs
> that have prior been loaded under bpf_capable() should suffice, so no need to
> lower the bar for now, no?

Unpriv can load sk_filter and attach to a socket. Then send data through
the socket to trigger execution.
bpf_prog_test_run is doing the same prog execution without creating a socket.
What is the concern?

> >   	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
> >   		return -EINVAL;
> > @@ -3163,7 +3214,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
> >   	info.run_time_ns = stats.nsecs;
> >   	info.run_cnt = stats.cnt;
> > -	if (!capable(CAP_SYS_ADMIN)) {
> > +	if (!bpf_capable()) {
> 
> Given the JIT dump this also exposes addresses when bpf_dump_raw_ok() passes.
> I presume okay, but should probably be documented given CAP_SYS_ADMIN isn't
> required anymore?

Exactly. dump_raw_ok() is there. I'm not even sure why this cap_sys_admin
check is there. It looks like it can be completely removed, but I didn't
want to go that far in this set.
