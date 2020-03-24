Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403F6190AED
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgCXK1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:27:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:23377 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727261AbgCXK1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=soBJIaYL9WF/DfBzjtXvp7GEwiX+cpRgaMHhdrZjvxI=;
        b=RaRUJ6HUklMioyisYoYZchBFc7RsrsOEBEQDPUFgV/xQfr9IptjAY5JKmmWDJYkSJ/FwbR
        zj+fw3avmbeLUqoUV2E6M/z7iDnJWA2n53uimMD+atpg4SX1RYPD3EPiHAitpPStSzfHc2
        fpHY69IIlYvmCOJ+HCKwu+GoORjbsz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-FC5Crl91PjiBE_LuhD8-Tw-1; Tue, 24 Mar 2020 06:27:14 -0400
X-MC-Unique: FC5Crl91PjiBE_LuhD8-Tw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D0E7100550D;
        Tue, 24 Mar 2020 10:27:11 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADFD35DA7B;
        Tue, 24 Mar 2020 10:26:51 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:26:48 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5] perf tools: add support for libpfm4
Message-ID: <20200324102648.GP1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
> index 7ac0d8088565..573072d32545 100644
> --- a/tools/build/feature/Makefile
> +++ b/tools/build/feature/Makefile
> @@ -67,7 +67,9 @@ FILES=                                          \
>           test-llvm.bin				\
>           test-llvm-version.bin			\
>           test-libaio.bin			\
> -         test-libzstd.bin
> +         test-libzstd.bin			\
> +         test-libpfm4.bin
> +
>  
>  FILES := $(addprefix $(OUTPUT),$(FILES))
>  
> @@ -321,6 +323,9 @@ $(OUTPUT)test-libaio.bin:
>  $(OUTPUT)test-libzstd.bin:
>  	$(BUILD) -lzstd
>  
> +$(OUTPUT)test-libpfm4.bin:
> +	$(BUILD) -lpfm

also please move the libpfm4 detection into separated patch

thanks,
jirka

