Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9636779AD
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjAWK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjAWK6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:58:04 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E0DBC9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:58:01 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so4117849wmq.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GurJgwjoFQNdZqxTjXXtdzYvuIXsPElEsE5t8iRI348=;
        b=g4dvnAt/e720eUN0Hw3mkuPvGH+bA9swS9a77z573C2TdQWW6YccWP0BkoVi78A7fD
         9k0EDsHOFkjnhw2wOEifD+LuTl/asks5WHcBsVRuAWdUJEmWeCb5sfiPEmcBupKXco7L
         GbvFD/7MEwApELk4GAbMkvKPw8jqR4On0BEH3X+b1r7t6TVjEb9KegIn8YBGFz3Vv8fw
         Jh0FiWJzDYchnJxivLRKF4Wflf4aRgMtJaDCLIK/Po9RydhxUm8dX6Qe93tyzuQYH5D1
         Lg/g6wjAGZI6WGgQ22tQbhjn6II6Mckqt+Hjv3IKqVUmi0cBYkGR5LBWB5l5q+psIVBr
         2gFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GurJgwjoFQNdZqxTjXXtdzYvuIXsPElEsE5t8iRI348=;
        b=dbSEFipxMDP3I+YRXuPphc94qUKEg3Guhzk/3IiOCNczmxMCW4W1PRM95FR66b36pg
         0C/rSMRd9gZuFYjQmc44juQOxjHxtqm9yJKcf423SiDXWd9iKLwC8A5cKDBvMf6A8QEF
         HmVpIs1Yy+fCOzlDtlYCKsixB+rtmhO6CptzVjLKyhGnfAMaG1+N1J97xoU5381gmtIc
         NAdBBkWsGP8p6yasW5EwJR2YWe6CbxB93WrWP/ScM7Yoa1rXpTGL6qUsg/KjTE3SoNER
         5dogodA5NzqTQ4mTUL/3L5pIMaf+8YS2XG8/0KHiezUgmI69vWyGkrXSSYLLfkowW47E
         ULVA==
X-Gm-Message-State: AFqh2kq0BIzDVr4IeNBRFOqjFnzD5E6HQZcCfjGl0G8WWWXYKwTdHvk1
        gvxjH+99j4YYjbeeCv4y7JB8Clww8e6AMPXxrvcpjA==
X-Google-Smtp-Source: AMrXdXsPRwYrnaXw9xX4B1eeQb0D5xrFH9eOI3n097aQpLYDHeyfCXKP4eQdFGO4lnW4dO+O4hOv4w==
X-Received: by 2002:a05:600c:3545:b0:3c6:e60f:3f4a with SMTP id i5-20020a05600c354500b003c6e60f3f4amr23649013wmq.1.1674471479963;
        Mon, 23 Jan 2023 02:57:59 -0800 (PST)
Received: from ?IPV6:2a02:8011:e80c:0:c17d:2d7f:4a94:488b? ([2a02:8011:e80c:0:c17d:2d7f:4a94:488b])
        by smtp.gmail.com with ESMTPSA id s5-20020a1cf205000000b003b47b80cec3sm10322397wmc.42.2023.01.23.02.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 02:57:59 -0800 (PST)
Message-ID: <20dbac19-d510-c8f5-fd3d-588cb08a3afa@isovalent.com>
Date:   Mon, 23 Jan 2023 10:57:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Content-Language: en-GB
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tonghao Zhang <tong@infragraf.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <0792068b-9aff-d658-5c7d-086e6d394c6c@csgroup.eu>
 <C811FC00-CE38-4227-B2E8-4CD8989D8B94@infragraf.org>
 <4ab9aafe-6436-b90d-5448-f74da22ddddb@csgroup.eu>
 <376f9737-f9a4-da68-8b7f-26020021613c@isovalent.com>
 <21b09e52-142d-92f5-4f8b-e4190f89383b@csgroup.eu>
 <43e6cd9f-ac54-46da-dba9-d535a2a77207@isovalent.com>
 <26e09ae3-dc7a-858d-c15c-7c2ff080d36d@csgroup.eu>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <26e09ae3-dc7a-858d-c15c-7c2ff080d36d@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-23 07:57 UTC+0000 ~ Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> 
> Le 17/01/2023 à 16:42, Quentin Monnet a écrit :
>>
>> In the meantime, you could disable the use of skeletons in bpftool, by
>> removing "clang-bpf-co-re" from FEATURE_TESTS from the Makefile. You
>> should get a functional binary, which would only miss a few features
>> (namely, printing the pids of programs holding references to BPF
>> programs, and the "bpftool prog profile" command).
> 
> Ok, with "clang-bpf-co-re" removed, bpftool doesn't complain.
> 
> However, does it work at all ?

Yes it does.

> 
> I started a 'tcpdump', I confirmed with ' bpf_jit_enable == 2' that a 
> BPF jitted program is created by tcpdump.
> 
> 'bptool prog show' and 'bpftool prog list' returns no result.

Bpftool works with eBPF, not with the older "classic" BPF (cBPF) used by
tcpdump. You should see programs listed if you load anything eBPF, for
example by using BCC tools, bpftrace, or load an eBPF program any other
way from user space:

	$ echo "int main(void) {return 0;}" | \
		clang -O2 -target bpf -c -o foo.o -x c -
	# bpftool prog load foo.o /sys/fs/bpf/foo type xdp
	# bpftool prog list
	# bpftool prog dump jited name main
	# rm /sys/fs/bpf/foo

I know tcpdump itself can show the cBPF bytecode for its programs, but I
don't know of another way to dump the JIT-ed image for cBPF programs.
Drgn could probably do it, with kernel debug symbols.

Quentin
