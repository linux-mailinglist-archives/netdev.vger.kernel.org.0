Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABB64D5430
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiCJWJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240075AbiCJWJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:09:53 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4C65FF0B;
        Thu, 10 Mar 2022 14:08:50 -0800 (PST)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nSQxd-000Ayr-EU; Thu, 10 Mar 2022 23:08:42 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nSQxd-000LZN-0J; Thu, 10 Mar 2022 23:08:41 +0100
Subject: Re: [PATCH v2] selftests/bpf: fix array_size.cocci warning
To:     Guo Zhengkui <guozhengkui@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Christy Lee <christylee@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Delyan Kratunov <delyank@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc:     zhengkui_guo@outlook.com
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
 <20220309033518.1743-1-guozhengkui@vivo.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ba71e22a-cf59-b2bd-50c0-d0c9fb3f4e08@iogearbox.net>
Date:   Thu, 10 Mar 2022 23:08:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220309033518.1743-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26477/Thu Mar 10 10:34:39 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 4:35 AM, Guo Zhengkui wrote:
> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
> 
> Use `ARRAY_SIZE(arr)` in bpf_util.h instead of forms like
> `sizeof(arr)/sizeof(arr[0])`.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>

BPF CI fails with:

https://github.com/kernel-patches/bpf/runs/5498238267?check_suite_focus=true

   pahole: Multithreading requires elfutils >= 0.178. Continuing with a single thread...
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:130:8: error: redefinition of 'bpf_map_def'
   struct bpf_map_def {
          ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:685:8: note: previous definition is here
   struct bpf_map_def {
          ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:138:6: error: redefinition of 'libbpf_pin_type'
   enum libbpf_pin_type {
        ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:191:6: note: previous definition is here
   enum libbpf_pin_type {
        ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:139:2: error: redefinition of enumerator 'LIBBPF_PIN_NONE'
           LIBBPF_PIN_NONE,
           ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:192:2: note: previous definition is here
           LIBBPF_PIN_NONE,
           ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:141:2: error: redefinition of enumerator 'LIBBPF_PIN_BY_NAME'
           LIBBPF_PIN_BY_NAME,
           ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:194:2: note: previous definition is here
           LIBBPF_PIN_BY_NAME,
           ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:144:6: error: redefinition of 'libbpf_tristate'
   enum libbpf_tristate {
        ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:1304:6: note: previous definition is here
   enum libbpf_tristate {
        ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:145:2: error: redefinition of enumerator 'TRI_NO'
           TRI_NO = 0,
           ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:1305:2: note: previous definition is here
           TRI_NO = 0,
           ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:146:2: error: redefinition of enumerator 'TRI_YES'
           TRI_YES = 1,
           ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:1306:2: note: previous definition is here
           TRI_YES = 1,
           ^
   In file included from progs/test_rdonly_maps.c:7:
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:147:2: error: redefinition of enumerator 'TRI_MODULE'
           TRI_MODULE = 2,
           ^
   /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/tools/include/bpf/libbpf.h:1307:2: note: previous definition is here
           TRI_MODULE = 2,
           ^
   8 errors generated.
   make: *** [Makefile:488: /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/test_rdonly_maps.o] Error 1
   make: *** Waiting for unfinished jobs....
   Error: Process completed with exit code 2.
