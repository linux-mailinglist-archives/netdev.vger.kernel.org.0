Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216C99D1E5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbfHZOrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 10:47:13 -0400
Received: from mail5.windriver.com ([192.103.53.11]:54602 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbfHZOrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 10:47:13 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x7QEhAvv010516
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 26 Aug 2019 07:43:21 -0700
Received: from [128.224.162.221] (128.224.162.221) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Mon, 26 Aug
 2019 07:43:00 -0700
From:   He Zhe <zhe.he@windriver.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <ndesaulniers@google.com>,
        <miguel.ojeda.sandonis@gmail.com>, <luc.vanoostenryck@gmail.com>,
        <schwidefsky@de.ibm.com>, <gregkh@linuxfoundation.org>,
        <mst@redhat.com>, <gor@linux.ibm.com>, <andreyknvl@google.com>,
        <jpoimboe@redhat.com>, <liuxiaozhou@bytedance.com>,
        <yamada.masahiro@socionext.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        He Zhe <Zhe.He@windriver.com>
Subject: kernel/bpf/core.o: warning: objtool: ___bpf_prog_run.cold()+0x7: call
 without frame pointer save/setup
Message-ID: <cf0273fb-c272-72be-50f9-b25bb7c7f183@windriver.com>
Date:   Mon, 26 Aug 2019 22:42:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [128.224.162.221]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Since 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"),
We have got the following warning,
kernel/bpf/core.o: warning: objtool: ___bpf_prog_run.cold()+0x7: call without frame pointer save/setup

If reverting the above commit, we will get the following warning,
kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8b9: sibling call from callable instruction with modified stack frame
if CONFIG_RETPOLINE=n, and no warning if CONFIG_RETPOLINE=y


Zhe
