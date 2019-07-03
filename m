Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62C45E4A4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfGCM4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:56:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:59370 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCM4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:56:51 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hieob-00087T-N4; Wed, 03 Jul 2019 14:56:49 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hieob-0003so-HH; Wed, 03 Jul 2019 14:56:49 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiling loop{1,2,3}.c on
 s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190702153908.41562-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <202efc47-eb0b-20b6-5d08-b743f8651f88@iogearbox.net>
Date:   Wed, 3 Jul 2019 14:56:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190702153908.41562-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 05:39 PM, Ilya Leoshkevich wrote:
> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
> 
> Pass -D__TARGET_ARCH_$(ARCH) to selftests in order to choose a proper
> PT_REGS_RC variant.
> 
> Fix s930 -> s390 typo.
> 
> On s390, provide the forward declaration of struct pt_regs and cast it
> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
> of the full struct pt_regs, s390 exposes only its first field
> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
> (in selftests) and kernel (in samples) headers.
> 
> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390, x86
> provides struct pt_regs to both userspace and kernel, however, with
> different field names.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

This doesn't apply cleanly to bpf-next, please rebase. I also think this
should be ideally split into multiple patches, seems like 4 different
issues which you are addressing in this single patch.

Thanks,
Daniel
