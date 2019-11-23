Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28107107BD3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKWABc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:01:32 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42009 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfKWAB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:01:29 -0500
Received: by mail-pg1-f195.google.com with SMTP id q17so4089941pgt.9
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8+yuRo8leBwiMoTIdlspRuC+nuf9tPvJBSaoVlCYcr0=;
        b=ufnbRqcpbY771Xbf6t8odtaI4hw0nxfRj7NahcvgDmBndf0iIb6gSTI8z7gsnj05fk
         v5UzVehJDvYN2ih7BlyB5r/Zz3Oz64RQkfxntUmVNS90S/e55JchNLCh3GU+Qrwl5mTQ
         HM8/zjNj91oRJpozOW59hli4SuOoylfoWqn3qTBbQsg7b0hTGx3+0ufO7nVDKLF43Yv2
         mNIxKYPsv3RJ/7aG4QADxRLAZvC9qoBl03uEN91OUdunLjDOWq0hQAAfatMYsg2r7nbg
         xId2a0ly59seCF082tZgXIwsQj7NdZG+aSSi7sf7YbBrv7CiEKbk1QabJUBGe1GxftKq
         zddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8+yuRo8leBwiMoTIdlspRuC+nuf9tPvJBSaoVlCYcr0=;
        b=srby4PU3fzfN8B2qmXERhhHjNYaUneO89VNY9Sm5ptzxxSL18ZCt3ZJe1h3fAbi9Lz
         JiDjkhP6Ala06VnPpO1CgR0CNno1QVpBJmx9QLJ9S8etTMCS7dAu71aHoSd7uzQDhtYW
         JwW0uYY/E/9Yx9gUvL4DIEs3UOoRNJEcMLWnxa3RNRdy46nd9kUhxDZr7FdWtAKkoqJo
         uAlf1zOVDW5+Ms51Cs+hx8IBPcKH6lV+6z3ghgusIw82PYiOYHcejTaZJLX1HnwfWmWs
         1BPSfFunYI76Ud9jCXTo2MoBJQbipYXWJx9p5ssQAOCpAy8Q66PYdZBYpNAv0dGmcOuz
         RXKw==
X-Gm-Message-State: APjAAAWl9f/VlR91RkofABSH4WOhvSMYoWPhWYrNai+wCFkvwXhTcGRA
        K0rv5tls5aaP1zwnt2+kjhtHYw==
X-Google-Smtp-Source: APXvYqwNwR4l3/DAmp3JaZWSOws1GVis8FdeLU3d6En4/y64kMGC8zx/IeoD93wLolOQGxI5vhfttQ==
X-Received: by 2002:a62:b607:: with SMTP id j7mr20921713pff.39.1574467288498;
        Fri, 22 Nov 2019 16:01:28 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u207sm8940594pfc.127.2019.11.22.16.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:01:27 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:01:27 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v5 bpf-next 11/15] libbpf: don't use cxx to test_libpf
 target
Message-ID: <20191123000127.GC3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-12-ivan.khoronzhuk@linaro.org>
 <20191121214225.GA3145429@mini-arch.hsd1.ca.comcast.net>
 <CAEf4BzZWPwzC8ZBWcBOfQQmxBkDRjogxw2xHZ+dMWOrrMmU0sg@mail.gmail.com>
 <20191122163211.GB3145429@mini-arch.hsd1.ca.comcast.net>
 <20191122234733.GA2474@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122234733.GA2474@khorivan>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23, Ivan Khoronzhuk wrote:
> On Fri, Nov 22, 2019 at 08:32:11AM -0800, Stanislav Fomichev wrote:
> > On 11/21, Andrii Nakryiko wrote:
> > > On Thu, Nov 21, 2019 at 1:42 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 10/11, Ivan Khoronzhuk wrote:
> > > > > No need to use C++ for test_libbpf target when libbpf is on C and it
> > > > > can be tested with C, after this change the CXXFLAGS in makefiles can
> > > > > be avoided, at least in bpf samples, when sysroot is used, passing
> > > > > same C/LDFLAGS as for lib.
> > > > > Add "return 0" in test_libbpf to avoid warn, but also remove spaces at
> > > > > start of the lines to keep same style and avoid warns while apply.
> > > > Hey, just spotted this patch, not sure how it slipped through.
> > > > The c++ test was there to make sure libbpf can be included and
> > > > linked against c++ code (i.e. libbpf headers don't have some c++
> > > > keywords/etc).
> > > >
> > > > Any particular reason you were not happy with it? Can we revert it
> > > > back to c++ and fix your use-case instead? Alternatively, we can just
> > > > remove this test if we don't really care about c++.
> > > >
> > > 
> > > No one seemed to know why we have C++ pieces in pure C library and its
> > > Makefile, so we decide to "fix" this. :)
> > It's surprising, the commit 8c4905b995c6 clearly states the reason
> > for adding it. Looks like it deserved a real comment in the Makefile :-)
> 
> I dislike changing things like this, but I was asked while review and
> it seemed logical enough. The comment could prevent us from doing this.
No worries, I'll add it back with a comment :-)

> > > But I do understand your concern. Would it be possible to instead do
> > > this as a proper selftests test? Do you mind taking a look at that?
> > Ack, will move this test_libbpf.c into selftests and convert back to
> > c++.
> 
> -- 
> Regards,
> Ivan Khoronzhuk
