Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9711F197
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLNLf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 06:35:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726636AbfLNLf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 06:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576323326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fnFLoseAIUqVaLCUCqNEVG0PWtrK90uaCn6K4I9qTxs=;
        b=hF+NJEqw8icZC7gJzoYLY0KF+M6SZNK1dF0W4DvSfPz8rd6xV4fW7ChgON+vUhy/xDE1ps
        l4XipFH06X9pde8KDf5euFeVAgPsqSdMRNYqzCapYI2pVFaZtQK1KrNg1/Ewci04dqO8N8
        cpGnwMfVqlE593M0lZwPyeQEvNkNtdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-nKIjVvFUOI-I_KmJ5HcbXg-1; Sat, 14 Dec 2019 06:35:25 -0500
X-MC-Unique: nKIjVvFUOI-I_KmJ5HcbXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6B6B100550E;
        Sat, 14 Dec 2019 11:35:22 +0000 (UTC)
Received: from krava (ovpn-204-62.brq.redhat.com [10.40.204.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE62E61348;
        Sat, 14 Dec 2019 11:35:13 +0000 (UTC)
Date:   Sat, 14 Dec 2019 12:35:10 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
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
Message-ID: <20191214113510.GB12440@krava>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
 <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
 <20191213121118.236f55b8@gandalf.local.home>
 <20191213180223.GE2844@hirez.programming.kicks-ass.net>
 <20191213132941.6fa2d1bd@gandalf.local.home>
 <20191213184621.GG2844@hirez.programming.kicks-ass.net>
 <20191213140349.5a42a8af@gandalf.local.home>
 <20191213140531.116b3200@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213140531.116b3200@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 02:05:31PM -0500, Steven Rostedt wrote:

SNIP

>  	struct trace_array *tr = filp->private_data;
> -	struct ring_buffer *buffer = tr->trace_buffer.buffer;
> +	struct trace_buffer *buffer = tr->trace_buffer.buffer;
>  	unsigned long val;
>  	int ret;
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 63bf60f79398..308fcd673102 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -178,7 +178,7 @@ struct trace_option_dentry;
>  
>  struct trace_buffer {
>  	struct trace_array		*tr;
> -	struct ring_buffer		*buffer;
> +	struct trace_buffer		*buffer;

perf change is fine, but 'trace_buffer' won't work because
we already have 'struct trace_buffer' defined in here

maybe we could change this name to trace_buffer_array?

thanks,
jirka

