Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EBB10EC69
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 16:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLBPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 10:38:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38669 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfLBPiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 10:38:10 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so6217901wrh.5
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 07:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QKV9dnpf6rp/7gDFmeYHF8ufaitXlU/8eSk2SUEebjs=;
        b=ZyvekxJLZtDwVbwOLLgdQNc4s2uE92lbdxbxNobLNUKUv0rn8HRutBpDS4oquS+Qht
         eRvAoInkI1A2tv1aOZrP9H4qPdsQmb52aZIqdXHwBI/ELB8bk3QBuMnVVI6SIIpCeV71
         PwjVnZ/LkHCSgib5zTsyRxjw2/ybKVRsdKkg6nHhrCbsc0uMZwDLlwQWNTkmcfjrPKg1
         /Vmfb1F8IJl/6ENpg7LRe5+HqZobiv+POOr8xL3a3mpbhFx38nUsrIW3q34+94T4xoZp
         jFg+4r+Qx+I5lzArrdMY7ism2O8ZJzERvuFfT9B4Z7qosuW2RyxogLZmT9tik6Ma1njW
         VXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QKV9dnpf6rp/7gDFmeYHF8ufaitXlU/8eSk2SUEebjs=;
        b=jsgykryTTGGnT5RgHhetP8xSHPQnFosUuD7b2dSD91tvEv/TiVRa8pfLo7BzviIahp
         LzOYCWIWC7rVyg0yvhUTljHczWbhFwmMEmtLuOYkP0ke0DtsAfkFymDOT8zqkXu4ptMG
         l/j5x69iwVMHUus8+M91uLF5GabRbcc5h/1j6I5CDMcstQBSlDxSI0nHXDYxgpUHBChj
         59Xj/tc8JSiQwj8XMDDy26IJxhLHLSotjfBuyucjaJypbnIhasw4D1qSCnOsQkqLcGSN
         tkT2wCG0ok/kIpQ5FVvyoZ1zBKvY2/F/a+MocBfcnaKxSCpvvtmUOYsRiLtxPAAQEVqu
         Nhgw==
X-Gm-Message-State: APjAAAXk6TK7ATunpmXkX4VVclfRdqiyLcxEwk65N3+3b5pUXdowYVbr
        H3L5njTUywnK/nZ51I0MQZg5yQ==
X-Google-Smtp-Source: APXvYqxlnGAp6DSIGUHFiagpYBLtt3X/ylwKXsTkltvFZ2yEl6JIrwdsK5Y74yyL6oDAduga8fOvTw==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr32451336wro.234.1575301087685;
        Mon, 02 Dec 2019 07:38:07 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id n3sm16187328wrs.8.2019.12.02.07.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2019 07:38:06 -0800 (PST)
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <20191202131847.30837-7-jolsa@kernel.org>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH 6/6] selftests, bpftool: Add build test for libbpf dynamic
 linking
Message-ID: <091d7dc2-0adb-f907-38d2-1750b1ec008a@netronome.com>
Date:   Mon, 2 Dec 2019 15:38:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191202131847.30837-7-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jiri ! A few comments inline.

2019-12-02 14:18 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
> Adding new test to test_bpftool_build.sh script to
> test the dynamic linkage of libbpf for bpftool:
> 
>   $ ./test_bpftool_build.sh
>   [SNIP]
> 
>   ... with dynamic libbpf
> 
>   $PWD:    /home/jolsa/kernel/linux-perf/tools/bpf/bpftool
>   command: make -s -C ../../build/feature clean >/dev/null
>   command: make -s -C ../../lib/bpf clean >/dev/null
>   command: make -s -C ../../lib/bpf prefix=/tmp/tmp.fG8O2Ps8ER install_lib install_headers >/dev/null
>   Parsed description of 117 helper function(s)
>   command: make -s clean >/dev/null
>   command: make -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/tmp.fG8O2Ps8ER >/dev/null
>   binary:  /home/jolsa/kernel/linux-perf/tools/bpf/bpftool/bpftool
>   binary:  linked with libbpf
> 
> The test installs libbpf into temp directory
> and links bpftool dynamically with it.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/test_bpftool_build.sh       | 53 +++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
> index ac349a5cea7e..e4a6a0520f8e 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_build.sh
> +++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
> @@ -85,6 +85,55 @@ make_with_tmpdir() {
>  	echo
>  }
>  
> +# Assumes current directory is tools/bpf/bpftool
> +make_with_dynamic_libbpf() {
> +	TMPDIR=$(mktemp -d)
> +	echo -e "\$PWD:    $PWD"
> +
> +	# It might be needed to clean build tree first because features
> +	# framework does not detect the change properly
> +	echo -e "command: make -s -C ../../build/feature clean >/dev/null"

(So far I did not echo the "make clean" commands, I printed only the
ones used to build bpftool. But that's your call.)

> +	make $J -s -C ../../build/feature clean >/dev/null
> +	if [ $? -ne 0 ] ; then
> +		ERROR=1
> +	fi
> +	echo -e "command: make -s -C ../../lib/bpf clean >/dev/null"
> +	make $J -s -C ../../lib/bpf clean >/dev/null
> +	if [ $? -ne 0 ] ; then
> +		ERROR=1
> +	fi
> +
> +	# Now install libbpf into TMPDIR
> +	echo -e "command: make -s -C ../../lib/bpf prefix=$TMPDIR install_lib install_headers >/dev/null"
> +	make $J -s -C ../../lib/bpf prefix=$TMPDIR install_lib install_headers >/dev/null
> +	if [ $? -ne 0 ] ; then
> +		ERROR=1
> +	fi
> +
> +	# And final bpftool build (with clean first) with libbpf dynamic link
> +	echo -e "command: make -s clean >/dev/null"
> +	if [ $? -ne 0 ] ; then
> +		ERROR=1
> +	fi

I do not believe you need to "make clean" here, this should have been
done by the previous test in that dir earlier in the script (cd
tools/bpf/bpftool; make_and_clean)

> +	echo -e "command: make -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=$TMPDIR >/dev/null"
> +	make $J -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=$TMPDIR >/dev/null
> +	if [ $? -ne 0 ] ; then
> +		ERROR=1
> +	fi
> +
> +	check .
> +	ldd bpftool | grep -q libbpf.so
> +	if [ $? -ne 0 ] ; then

(Or "if ldd bpftool | grep -q libbpf.so ; then")

> +		printf "FAILURE: Did not find libbpf linked\n"

Please also set $(ERROR) here.

(Also, stick to echo rather than mixing with printf? I can't remember
why I used one over echo in the check() function, that was probably not
on purpose.)

> +	else
> +		echo "binary:  linked with libbpf"
> +	fi
> +	make -s -C ../../lib/bpf clean
> +	make -s clean
> +	rm -rf -- $TMPDIR

We probably want to clean features too? We tried to check that libbpf
was available, but with a very specific $(LIBBPF_DIR), which was
temporary and no longer exist. So better to reset features to a clean state?

> +	echo
> +}
> +
>  echo "Trying to build bpftool"
>  echo -e "... through kbuild\n"
>  
> @@ -145,3 +194,7 @@ make_and_clean
>  make_with_tmpdir OUTPUT
>  
>  make_with_tmpdir O
> +
> +echo -e "... with dynamic libbpf\n"
> +
> +make_with_dynamic_libbpf
> 

Thanks,
Quentin
