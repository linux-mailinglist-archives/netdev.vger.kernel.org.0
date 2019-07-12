Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD18266F8A
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGLNFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:05:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:50372 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfGLNFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:05:46 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvFA-0005Wn-9v; Fri, 12 Jul 2019 15:05:44 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvFA-000NNO-3I; Fri, 12 Jul 2019 15:05:44 +0200
Subject: Re: [PATCH bpf-next] bpf: fix precision bit propagation for BPF_ST
 instructions
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        ast@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@fb.com
References: <20190709033244.1596200-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3d59300-6e94-0d91-e943-02b8ec22c1b4@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:05:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190709033244.1596200-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09/2019 05:32 AM, Andrii Nakryiko wrote:
> When backtracking instructions to propagate precision bit for registers
> and stack slots, one class of instructions (BPF_ST) weren't handled
> causing extra stack slots to be propagated into parent state. Parent
> state might not have that much stack allocated, though, which causes
> warning on invalid stack slot usage.
> 
> This patch adds handling of BPF_ST instructions:
> 
> BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32
> 
> Reported-by: syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com
> Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
> Cc: Alexei Starovoitov <ast@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
