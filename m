Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FBF11E939
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfLMRaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:30:21 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33743 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:30:21 -0500
Received: by mail-pl1-f193.google.com with SMTP id c13so1520963pls.0;
        Fri, 13 Dec 2019 09:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dWzMK9rHDFrxcweRiN7KPOsjpCkBjnAFMTgqTFXcoBc=;
        b=Q+Xt2BIq9uE20Mk9j62YRe0FX8yOQm2fTdOlinOykkP1UaSzYWcSsvzJJDNiUIEs3U
         omgFt+B9vV6SM/pfLQ30bvZX/zeAc+K29Q7FYgCpETBxrpHPdSEpwjZJeJ5XaEKNUHiV
         wXUTeRolcZRsxBudtFA/brs0AbLhueyPZYuPFCGTPYenc7suC8XgD008yQ8W8Cu65rGM
         4S7Kw1xldT1rxzKutE9zQO8hKgZ2si5YQNIoJ/HzikT61D6YH9xweSF9x51O6AqjbI8s
         PBNt+iD3pARLzxjZ9ZO/ktaBeJgOyB452GiKRx2YR2zAi2iOQSKdxn89OY4NUUTSWTY2
         +2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dWzMK9rHDFrxcweRiN7KPOsjpCkBjnAFMTgqTFXcoBc=;
        b=cvwSLyLjt5gwMdc4JYd1i9FxWSnnpsMbUHnuHj0LxvjIpUsgd+Jv95O2ezwlnB3+kl
         yLaWcYcIw5nR2hFou+NaR7UX8nLqrwV/06SisUqJyPUhiVeDcxeHySitJax0tFSJdsXJ
         ZJRvF8xAhShq013qZmAG+y52bNyyK51z1D2miC9QEYlOeYlwM0NL7H3ISdmXvbr/scVh
         vyXnM+Ew5WaDR5ztUUHmUl5NnqdIxCyXw4DQLcddbBmwrzi4sGLWVtK913sd06nc724b
         +jCttDMsQuThZVxoqcICftZOX3nAM9a+qBW4Kwm9624VAqEjrbbxMpq1bNyOmxxtSdYj
         aSIg==
X-Gm-Message-State: APjAAAWM7Wr/MUFCReh/jvfet1Xspmi+h7wZeuoRrhLOY5996mtIdaaL
        XytM98JrGHFLk+gcZyFbk3w=
X-Google-Smtp-Source: APXvYqwduBc1e5ajOetKxS6ibzS8+ofjEQOxmBCmhB27vw0PfPcF2vaZ19u+fMDL8pvoCNHhb3BV2w==
X-Received: by 2002:a17:902:d204:: with SMTP id t4mr444067ply.167.1576258220329;
        Fri, 13 Dec 2019 09:30:20 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::de66])
        by smtp.gmail.com with ESMTPSA id a6sm11103655pgg.25.2019.12.13.09.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 09:30:19 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:30:18 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213173016.posmo4pxjwjvv4bh@ast-mbp.dhcp.thefacebook.com>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
 <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
 <20191213121118.236f55b8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213121118.236f55b8@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 12:11:18PM -0500, Steven Rostedt wrote:
> On Fri, 13 Dec 2019 08:51:57 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > It had two choices. Both valid. I don't know why gdb picked this one.
> > So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
> > good. I think renaming ftrace one would be better, since gdb picked perf one
> > for whatever reason.
> 
> Because of the sort algorithm. But from a technical perspective, the
> ring buffer that ftrace uses is generic, where the perf ring buffer can
> only be used for perf. Call it "event_ring_buffer" or whatever, but
> it's not generic and should not have a generic name.

I don't mind whichever way. Just saying it would be good to rename :)
