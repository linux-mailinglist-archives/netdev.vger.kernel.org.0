Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED02D1402D4
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgAQEOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:14:37 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43868 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgAQEOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:14:37 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so9294974pli.10;
        Thu, 16 Jan 2020 20:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=twnxve9B2urmxTvx/xi2EnR9KZMdG4EBxb61wIeJtkM=;
        b=BSzmU+mWlBUNhq6SrtaJyXRUEy6MRHfr053SGujImlwUDkuFYAs9H8E6mcQR290vjD
         gTkb0juZP5oxrBfoEOd87+w/svGn/A/inFXreV9mjAhl7aEoGj4eRM59wNO/MLVrgjNJ
         riGtylwTCX/6wfOCQjyKXBIkHP98+yAk0g+vYB0RTWk6vXjOFKbI8eokVzykD1EDPyNZ
         EQTN+CqC9IdV5zXcC4bORRjk1n09BZPrv1uY0+zBGGjWBq19pxkDfeRElNrY1dMG2Euc
         7fW85AtGRAD6b5bzcXDpgN093ZheAyhL70iLvaM6EubxQnHdcQfxRKecy2BCPd/a8z9s
         NJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=twnxve9B2urmxTvx/xi2EnR9KZMdG4EBxb61wIeJtkM=;
        b=TnqRDYhbBnIO5r6UxKMGMT1HEK6ODrgPB7F2XjOMOd/KyYJbocUy/Q5KgnH5xhdHEg
         vTa6gCI3vXuqBf7U4ZdSzAowl52SLjmJ0Ppsc5nmC3KtJiNWx6RhWjCCsuTAV1F40vXB
         TXgGwiKD5cJF81H6urMwWH5a8/69sjr6CVFkdjLQkAHumwPrzkL3gfBCOFkZaAEXQwwi
         eYaBS+x4NvOAuBbDbP93coYtM0lwcBVIPuozXC9zqW5JbO0ZOeJ7FPbVsZ2BAyppCi7t
         DUyRJ0lEAY8ALcqEvjaxyNzOWjruv67o4ZzfLAaIuIYDrcF213FpHKlpTLMsbGfhDZ2z
         NAdA==
X-Gm-Message-State: APjAAAX1VqIvH5MuV05FJElwDegZwDaqUQDhYXOhq7cytliW26TOgCdi
        65ixS/zz96N0LFGx6AFTGiQ=
X-Google-Smtp-Source: APXvYqwWDzxtWtq69PKr0RljRlYADIezN3T1Qi10F9SS3lxibRUtqAla77kK4XulE5yE4gu+WGbLJQ==
X-Received: by 2002:a17:90a:2223:: with SMTP id c32mr3474800pje.15.1579234476283;
        Thu, 16 Jan 2020 20:14:36 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::98ac])
        by smtp.gmail.com with ESMTPSA id h128sm28232584pfe.172.2020.01.16.20.14.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jan 2020 20:14:35 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:14:32 -0800
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
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH bpf-next v3 00/11] tools: Use consistent libbpf include
 paths everywhere
Message-ID: <20200117041431.h7vvc32fungenyhg@ast-mbp.dhcp.thefacebook.com>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 02:22:11PM +0100, Toke Høiland-Jørgensen wrote:
> The recent commit 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are
> taken from selftests dir") broke compilation against libbpf if it is installed
> on the system, and $INCLUDEDIR/bpf is not in the include path.
> 
> Since having the bpf/ subdir of $INCLUDEDIR in the include path has never been a
> requirement for building against libbpf before, this needs to be fixed. One
> option is to just revert the offending commit and figure out a different way to
> achieve what it aims for. 

The offending commit has been in the tree for a week. So I applied Andrii's
revert of that change. It reintroduced the build dependency issue, but we lived
with it for long time, so we can take time to fix it cleanly.
I suggest to focus on that build dependency first.

> However, this series takes a different approach:
> Changing all in-tree users of libbpf to consistently use a bpf/ prefix in
> #include directives for header files from libbpf.

I'm not sure it's a good idea. It feels nice, but think of a message we're
sending to everyone. We will get spamed with question: does bpf community
require all libbpf users to use bpf/ prefix ? What should be our answer?
Require or recommend? If require.. what for? It works as-is. If recommend then
why suddenly we're changing all files in selftests and samples?
There is no good answer here. I think we should leave the things as-is.
And fix build dep differently.

Patches 1-3 are still worth doing.
