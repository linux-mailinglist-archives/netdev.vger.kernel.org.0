Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EBE13CEBE
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgAOVTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:19:06 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39600 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729950AbgAOVTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:19:05 -0500
Received: by mail-pj1-f68.google.com with SMTP id e11so504404pjt.4;
        Wed, 15 Jan 2020 13:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Sr5D3Vmy2L4zBjOZJ4kwZ5hGeIC3RIyoZkA5ktLyrSY=;
        b=CnNUH7zAw+/bJk6LxlmjXA0sLWhAkxwwNLCsne1NlHcoEkQygRFgZH9U10USJfcOhR
         8T5/jg7Ly270/Aq9oDjdpfz3wA9dMAuzncMMQ+c20kO4AONHvQJq/GiFrXkVXoIlDEab
         ITSwIntxIptfuIf3sXD3Kf+jCx5QIqGDw62NAhl1WX6uzHWEA7EynysNBzzmxNg9Qwe2
         rWlocg/cEOxu5vjpbtyuQbf+k6s92MkR0O7atrXOfgppJMfBqn16k72wtPfvMw1vFCNh
         h4kSp03F4vvF/ymOCVf/u5qNxHUFQ1rRH+hLvIJ9SNmFW0IE8Q5JQtf0vH1StRCRqyru
         Ievg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Sr5D3Vmy2L4zBjOZJ4kwZ5hGeIC3RIyoZkA5ktLyrSY=;
        b=MiNwOi5Fp/TbRIK0vyBF71FU0CK3Gwvzdhj1ZcDdQNwRVi6C4XoJydigZeQRBkuoX+
         fdx2mLbAFm3hz0k5aTa+RTQCW6OQKmjvsvN9jQ0mIi8GCW4EFZnSiIPWeWgmdNoXqtiE
         lqtp6i+nhwo6Quf/MaCaLF/4I/sZyWWgeF/C3Rb/1DfMzsB4d+0h2OilU5yUABZBIwWt
         go7tGqfCQlM6L/VG/QgcqTZuBsnKHL2wl4yq1uoQYK/BPGoTep2Ca/qegIwgvUBW5bso
         o4mWnFYVZzyCY1UzTVwwErdLNU29+0Lq0QyGlBECYEfUDMcuxYv1+d7m42W/KtZVxlkX
         Q/9Q==
X-Gm-Message-State: APjAAAWFi07P7Mtgj/VEc/MXISs/P6e0DJE3PcXdYP6mWeX2G+OaA9WM
        IH3ojD32IW/7byoxr4R6O1I=
X-Google-Smtp-Source: APXvYqzTB/kQWcNCbH6qWL8ALjnNfda6sZfEu5yGyPZ46PNXpF3lLh5Pnl9X61gJaRhkzWLyOUbcvg==
X-Received: by 2002:a17:902:9003:: with SMTP id a3mr28071089plp.224.1579123144650;
        Wed, 15 Jan 2020 13:19:04 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:e760])
        by smtp.gmail.com with ESMTPSA id x65sm24047764pfb.171.2020.01.15.13.19.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 13:19:03 -0800 (PST)
Date:   Wed, 15 Jan 2020 13:19:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next v2 00/10] tools: Use consistent libbpf include
 paths everywhere
Message-ID: <20200115211900.h44pvhe57szzzymc@ast-mbp.dhcp.thefacebook.com>
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 03:12:48PM +0100, Toke Høiland-Jørgensen wrote:
> The recent commit 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are
> taken from selftests dir") broke compilation against libbpf if it is installed
> on the system, and $INCLUDEDIR/bpf is not in the include path.
> 
> Since having the bpf/ subdir of $INCLUDEDIR in the include path has never been a
> requirement for building against libbpf before, this needs to be fixed. One
> option is to just revert the offending commit and figure out a different way to
> achieve what it aims for. However, this series takes a different approach:
> Changing all in-tree users of libbpf to consistently use a bpf/ prefix in
> #include directives for header files from libbpf.

I don't think such approach will work in all cases.
Consider the user installing libbpf headers into /home/somebody/include/bpf/,
passing that path to -I and trying to build bpf progs
that do #include "bpf_helpers.h"...
In the current shape of libbpf everything will compile fine,
but after patch 8 of this series the compiler will not find bpf/bpf_helper_defs.h.
So I think we have no choice, but to revert that part of Andrii's patch.
Note that doing #include "" for additional library headers is a common practice.
There was nothing wrong about #include "bpf_helper_defs.h" in bpf_helpers.h.
