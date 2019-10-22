Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84F1DFE19
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfJVHU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 03:20:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:34970 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfJVHU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 03:20:26 -0400
Received: from 13.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.13] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iMoSu-0006LP-Cd; Tue, 22 Oct 2019 09:20:24 +0200
Date:   Tue, 22 Oct 2019 09:20:23 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Message-ID: <20191022072023.GA31343@pc-66.home>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
 <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25609/Mon Oct 21 10:57:36 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:07:59PM -0700, John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > kprobes programs on older kernels.
> > 
> > My main concern with this is that this code is born bit-rotten,
> > because selftests are never testing the legacy code path. How did you
> > think about testing this and ensuring that this keeps working going
> > forward?
> 
> Well we use it, but I see your point and actually I even broke the retprobe
> piece hastily fixing merge conflicts in this patch. When I ran tests on it
> I missed running retprobe tests on the set of kernels that would hit that
> code.

If it also gets explicitly exposed as bpf_program__attach_legacy_kprobe() or
such, it should be easy to add BPF selftests for that API to address the test
coverage concern. Generally more selftests for exposed libbpf APIs is good to
have anyway.

Cheers,
Daniel
