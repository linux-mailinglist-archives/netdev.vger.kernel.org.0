Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12993170290
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgBZPeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:34:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:39488 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgBZPeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:34:14 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yhM-0000ZO-4z; Wed, 26 Feb 2020 16:34:08 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6yhL-000Hiz-KN; Wed, 26 Feb 2020 16:34:07 +0100
Subject: Re: [PATCH bpf-next v3 5/5] selftests/bpf: Add test for "bpftool
 feature" command
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org
References: <20200225194446.20651-1-mrostecki@opensuse.org>
 <20200225194446.20651-6-mrostecki@opensuse.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d0c40cd0-f9db-c6cb-5b46-79145311050d@iogearbox.net>
Date:   Wed, 26 Feb 2020 16:34:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225194446.20651-6-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 8:44 PM, Michal Rostecki wrote:
> Add Python module with tests for "bpftool feature" command, which mainly
> wheck whether the "full" option is working properly.

nit, typo: wheck

> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>

Ptal, when running the test I'm getting the following error:

root@tank:~/bpf-next/tools/testing/selftests/bpf# ./test_bpftool.sh
test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
test_feature_macros (test_bpftool.TestBpftool) ... ERROR

======================================================================
ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 58, in wrapper
     return f(*args, iface, **kwargs)
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 83, in test_feature_dev_json
     res = bpftool_json(["feature", "probe", "dev", iface])
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 43, in bpftool_json
     res = _bpftool(args)
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
     res = subprocess.run(_args, capture_output=True)
   File "/usr/lib/python3.6/subprocess.py", line 423, in run
     with Popen(*popenargs, **kwargs) as process:
TypeError: __init__() got an unexpected keyword argument 'capture_output'

======================================================================
ERROR: test_feature_kernel (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 94, in test_feature_kernel
     bpftool_json(["feature", "probe", "kernel"]),
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 43, in bpftool_json
     res = _bpftool(args)
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
     res = subprocess.run(_args, capture_output=True)
   File "/usr/lib/python3.6/subprocess.py", line 423, in run
     with Popen(*popenargs, **kwargs) as process:
TypeError: __init__() got an unexpected keyword argument 'capture_output'

======================================================================
ERROR: test_feature_kernel_full (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 122, in test_feature_kernel_full
     bpftool_json(["feature", "probe", "kernel", "full"]),
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 43, in bpftool_json
     res = _bpftool(args)
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
     res = subprocess.run(_args, capture_output=True)
   File "/usr/lib/python3.6/subprocess.py", line 423, in run
     with Popen(*popenargs, **kwargs) as process:
TypeError: __init__() got an unexpected keyword argument 'capture_output'

======================================================================
ERROR: test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 147, in test_feature_kernel_full_vs_not_full
     full_res = bpftool_json(["feature", "probe", "full"])
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 43, in bpftool_json
     res = _bpftool(args)
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
     res = subprocess.run(_args, capture_output=True)
   File "/usr/lib/python3.6/subprocess.py", line 423, in run
     with Popen(*popenargs, **kwargs) as process:
TypeError: __init__() got an unexpected keyword argument 'capture_output'

======================================================================
ERROR: test_feature_macros (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 177, in test_feature_macros
     res = bpftool(["feature", "probe", "macros"])
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 39, in bpftool
     return _bpftool(args, json=False).decode("utf-8")
   File "/root/bpf-next/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
     res = subprocess.run(_args, capture_output=True)
   File "/usr/lib/python3.6/subprocess.py", line 423, in run
     with Popen(*popenargs, **kwargs) as process:
TypeError: __init__() got an unexpected keyword argument 'capture_output'

----------------------------------------------------------------------
Ran 5 tests in 0.001s

FAILED (errors=5)
