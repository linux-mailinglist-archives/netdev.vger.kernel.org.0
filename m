Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536A83929A8
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhE0Iiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhE0Iit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 04:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4A3613C9;
        Thu, 27 May 2021 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622104635;
        bh=2K3it/1zRuJdf9Q/S7hkVa9M9oXd8HBoB8xGgOHyynI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iJObXCQ9waueP1i0oSTl9W+aHQ9lFQGKPORyJjG95bBHcZ0xLrMx57kwHTpZoY8qt
         uYTHFOylxr4+wkHCx47buXo1ZPzkBmRzmNttRv/bkhumwCONT2geqMUKO5ZvVxWlRs
         8pmM6GWgtyr2pInspEr9FXj0DQ0kWRK6LZ/REiWM=
Date:   Thu, 27 May 2021 10:37:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [QUESTION] BPF kernel selftests failed in the LTS stable kernel
 4.19.x
Message-ID: <YK9aOGGO033adyw1@kroah.com>
References: <2988ff60-2d79-b066-6c02-16e5fe8b69db@loongson.cn>
 <YK8e+iLPjkmuO793@kroah.com>
 <9671b7f4-b827-3c81-f1e5-2836c701495b@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9671b7f4-b827-3c81-f1e5-2836c701495b@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 04:18:15PM +0800, Tiezhu Yang wrote:
> On 05/27/2021 12:24 PM, Greg Kroah-Hartman wrote:
> > On Thu, May 27, 2021 at 10:27:51AM +0800, Tiezhu Yang wrote:
> > > Hi all,
> > > 
> > > When update the following LTS stable kernel 4.19.x,
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y
> > > 
> > > and then run BPF selftests according to
> > > https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-how-to-run-bpf-selftests
> > > 
> > > $ cd tools/testing/selftests/bpf/
> > > $ make
> > > $ sudo ./test_verifier
> > > $ sudo make run_tests
> > > 
> > > there exists many failures include verifier tests and run_tests,
> > > (1) is it necessary to make sure that there are no any failures in the LTS
> > > stable kernel 4.19.x?
> > Yes, it would be nice if that did not happen.
> > 
> > > (2) if yes, how to fix these failures in the LTS stable kernel 4.19.x?
> > Can you find the offending commits by using `git bisect` and find the
> > upstream commits that resolve this and let us know so we can backport
> > them?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I compared the related code in 4.19.y and upstream mainline, some failures
> disappeared after add ".flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,", but
> other failures still exist, and I didn't have enough in-depth knowledge to
> touch things elsewhere.
> 
> The failures can be easily reproduced, I would greatly appreciate it if
> anyone
> is interested to fix them.

Sounds like you are interested, why not work on this instead of waiting
for someone else?  It's not like many people are interested in 4.19 at
this point in time.

good luck!

greg k-h
