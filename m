Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A62F488A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbhAMKWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:22:21 -0500
Received: from foss.arm.com ([217.140.110.172]:33734 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbhAMKWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:22:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CA631042;
        Wed, 13 Jan 2021 02:21:35 -0800 (PST)
Received: from e107158-lin (e107158-lin.cambridge.arm.com [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E65913F66E;
        Wed, 13 Jan 2021 02:21:33 -0800 (PST)
Date:   Wed, 13 Jan 2021 10:21:31 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
Message-ID: <20210113102131.mjxpqpoi4n6rhbny@e107158-lin>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
 <20210111182027.1448538-3-qais.yousef@arm.com>
 <CAEf4BzYwOAHGOiZBUx86yZ1ofwJ1WqCDR3dyRMrTeQa2ZU7ftA@mail.gmail.com>
 <20210112192729.q47avnmnzl54nekg@e107158-lin>
 <CAEf4BzZiYv1M04FBmuzMH5cxLUXzLthDfpp4nORMEmvkcfzyRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzZiYv1M04FBmuzMH5cxLUXzLthDfpp4nORMEmvkcfzyRQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/21 12:07, Andrii Nakryiko wrote:
> > > >         $ sudo ./test_progs -v -t module_attach
> > >
> > > use -vv when debugging stuff like that with test_progs, it will output
> > > libbpf detailed logs, that often are very helpful
> >
> > I tried that but it didn't help me. Full output is here
> >
> >         https://paste.debian.net/1180846
> >
> 
> It did help a bit for me to make sure that you have bpf_testmod
> properly loaded and its BTF was found, so the problem is somewhere
> else. Also, given load succeeded and attach failed with OPNOTSUPP, I
> suspect you are missing some of FTRACE configs, which seems to be
> missing from selftests's config as well. Check that you have
> CONFIG_FTRACE=y and CONFIG_DYNAMIC_FTRACE=y, and you might need some
> more. See [0] for a real config we are using to run all tests in
> libbpf CI. If you figure out what you were missing, please also
> contribute a patch to selftests' config.
> 
>   [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/configs/latest.config

Yeah that occurred to me too. I do have all necessary FTRACE options enabled,
including DYNAMIC_FTRACE. I think I did try enabling fault injection too just
in case. I have CONFIG_FAULT_INJECTION=y and CONFIG_FUNCTION_ERROR_INJECTION=y.

I will look at the CI config and see if I can figure it out.

I will likely get a chance to look at all of this and send v2  over the
weekend.

Thanks

--
Qais Yousef
