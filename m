Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478809D88E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfHZVeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:48210 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfHZVeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Mcw-0003JB-Am; Mon, 26 Aug 2019 23:34:14 +0200
Received: from [178.197.249.36] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i2Mcw-000BMQ-3A; Mon, 26 Aug 2019 23:34:14 +0200
Subject: Re: [PATCH] bpf: handle 32-bit zext during constant blinding
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190821192358.31922-1-naveen.n.rao@linux.vnet.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <776c3058-ebd4-f30d-7392-03a4a94c2483@iogearbox.net>
Date:   Mon, 26 Aug 2019 23:34:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190821192358.31922-1-naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25553/Mon Aug 26 10:32:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 9:23 PM, Naveen N. Rao wrote:
> Since BPF constant blinding is performed after the verifier pass, the
> ALU32 instructions inserted for doubleword immediate loads don't have a
> corresponding zext instruction. This is causing a kernel oops on powerpc
> and can be reproduced by running 'test_cgroup_storage' with
> bpf_jit_harden=2.
> 
> Fix this by emitting BPF_ZEXT during constant blinding if
> prog->aux->verifier_zext is set.
> 
> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

LGTM, applied to bpf, thanks!
