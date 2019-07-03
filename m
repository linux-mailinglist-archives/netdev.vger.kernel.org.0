Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1065E163
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGCJu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:50:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:51502 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGCJu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:50:29 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hibuD-0006fs-Se; Wed, 03 Jul 2019 11:50:26 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hibuD-00035D-IW; Wed, 03 Jul 2019 11:50:25 +0200
Subject: Re: [PATCH bpf-next] bpf: fix precision tracking
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190628162409.2513499-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3e2dfbf7-6b44-1a41-bc0f-d2810157ef09@iogearbox.net>
Date:   Wed, 3 Jul 2019 11:50:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190628162409.2513499-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28/2019 06:24 PM, Alexei Starovoitov wrote:
> When equivalent state is found the current state needs to propagate precision marks.
> Otherwise the verifier will prune the search incorrectly.
> 
> There is a price for correctness:
>                       before      before    broken    fixed
>                       cnst spill  precise   precise
> bpf_lb-DLB_L3.o       1923        8128      1863      1898
> bpf_lb-DLB_L4.o       3077        6707      2468      2666
> bpf_lb-DUNKNOWN.o     1062        1062      544       544
> bpf_lxc-DDROP_ALL.o   166729      380712    22629     36823
> bpf_lxc-DUNKNOWN.o    174607      440652    28805     45325
> bpf_netdev.o          8407        31904     6801      7002
> bpf_overlay.o         5420        23569     4754      4858
> bpf_lxc_jit.o         39389       359445    50925     69631
> Overall precision tracking is still very effective.
> 
> Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
> Reported-by: Lawrence Brakmo <brakmo@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
