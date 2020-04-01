Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F5719A7FC
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgDAI4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 04:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgDAI4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 04:56:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95AB620784;
        Wed,  1 Apr 2020 08:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585731383;
        bh=pZfkpzV/DA6TJrp3HueXSBW9yxX80ESU1n7+BOkQquc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Os3MhArKMK5pr15JDTv+GuhUZA2z26WCPoNodnEur3UTs7+7Lwh3XVqLAj2qqcLVM
         c8DWL6v+4M5n71Cu9YE1IwMSRlNnXg3oN4ieQ7YbnLJ0xfXJRqvgQDolrPzIqrtQxn
         42lXpvbIaEju92IXHKsXjfPxVlqShCvg+T44u6j0=
Date:   Wed, 1 Apr 2020 10:56:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        john.fastabend@gmail.com, komachi.yoshiki@gmail.com,
        Andrii Nakryiko <andriin@fb.com>, lukenels@cs.washington.edu,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/171] 5.5.14-rc2 review
Message-ID: <20200401085620.GD2026666@kroah.com>
References: <20200331141450.035873853@linuxfoundation.org>
 <CA+G9fYuU-5o5DG1VSQuCPx=TSs61-1jBekdGb5yvMRz4ur3BQg@mail.gmail.com>
 <20200401061131.GA1907105@kroah.com>
 <dc2cee11-84fc-70a7-41d8-2de23942697c@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc2cee11-84fc-70a7-41d8-2de23942697c@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 10:03:16AM +0200, Daniel Borkmann wrote:
> On 4/1/20 8:11 AM, Greg Kroah-Hartman wrote:
> > On Wed, Apr 01, 2020 at 04:18:41AM +0530, Naresh Kamboju wrote:
> > > On Tue, 31 Mar 2020 at 21:02, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > This is the start of the stable review cycle for the 5.5.14 release.
> > > > There are 171 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 02 Apr 2020 14:12:02 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.14-rc2.gz
> > > > or in the git tree and branch at:
> > > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Results from Linaro’s test farm.
> > > Regressions on x86_64 and i386.
> > > 
> > > selftests bpf test_verifier reports as failed.
> > > This test PASSED on v5.5.13
> > > 
> > > #554/p jgt32: range bound deduction, reg op imm FAIL
> > > Failed to load prog 'Success'!
> > > R8 unbounded memory access, make sure to bounds check any array access
> > > into a map
> > > verification time 141 usec
> > > stack depth 8
> > > processed 16 insns (limit 1000000) max_states_per_insn 0 total_states
> > > 1 peak_states 1 mark_read 1
> > > #555/p jgt32: range bound deduction, reg1 op reg2, reg1 unknown FAIL
> > > Failed to load prog 'Success'!
> > > R8 unbounded memory access, make sure to bounds check any array access
> > > into a map
> > > verification time 94 usec
> > > stack depth 8
> > > processed 17 insns (limit 1000000) max_states_per_insn 0 total_states
> > > 1 peak_states 1 mark_read 1
> > > #556/p jle32: range bound deduction, reg1 op reg2, reg2 unknown FAIL
> > > Failed to load prog 'Success'!
> > > R8 unbounded memory access, make sure to bounds check any array access
> > > into a map
> > > verification time 68 usec
> > > stack depth 8
> > > processed 17 insns (limit 1000000) max_states_per_insn 0 total_states
> > > 1 peak_states 1 mark_read 1
> > 
> > Can you run 'git bisect' to find the offending patch?
> 
> No need, I'll send you a patch to update the selftests. It's expected that they
> fail now due to the revert we had to do, so if this is the only issue it shouldn't
> hold up the release. In any case, I'll send them over to you next.

Great, thanks for letting me know this isn't a "real" issue :)

greg k-h
