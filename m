Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F179D12AB60
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 10:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfLZJoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 04:44:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:36112 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfLZJoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 04:44:22 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ikPgp-0007rj-Tf; Thu, 26 Dec 2019 10:44:20 +0100
Received: from [185.105.41.13] (helo=linux-9.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ikPgp-000K40-KG; Thu, 26 Dec 2019 10:44:19 +0100
Subject: Re: [PATCH v2 bpf-next] libbpf: support CO-RE relocations for
 LDX/ST/STX instructions
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>
Cc:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20191223180305.86417-1-andriin@fb.com>
 <c8e07d16-9b7e-5847-b8a8-853f4aaf620f@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a083506e-12e3-e39b-086f-fd03f2cf367e@iogearbox.net>
Date:   Thu, 26 Dec 2019 10:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c8e07d16-9b7e-5847-b8a8-853f4aaf620f@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25674/Wed Dec 25 10:52:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 7:10 PM, Yonghong Song wrote:
> On 12/23/19 10:03 AM, Andrii Nakryiko wrote:
>> Clang patch [0] enables emitting relocatable generic ALU/ALU64 instructions
>> (i.e, shifts and arithmetic operations), as well as generic load/store
>> instructions. The former ones are already supported by libbpf as is. This
>> patch adds further support for load/store instructions. Relocatable field
>> offset is encoded in BPF instruction's 16-bit offset section and are adjusted
>> by libbpf based on target kernel BTF.
>>
>> These Clang changes and corresponding libbpf changes allow for more succinct
>> generated BPF code by encoding relocatable field reads as a single
>> ST/LDX/STX instruction. It also enables relocatable access to BPF context.
>> Previously, if context struct (e.g., __sk_buff) was accessed with CO-RE
>> relocations (e.g., due to preserve_access_index attribute), it would be
>> rejected by BPF verifier due to modified context pointer dereference. With
>> Clang patch, such context accesses are both relocatable and have a fixed
>> offset from the point of view of BPF verifier.
>>
>>     [0] https://reviews.llvm.org/D71790
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
