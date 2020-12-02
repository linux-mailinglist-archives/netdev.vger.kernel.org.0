Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5CD2CB61B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 09:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgLBICf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 03:02:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:53606 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726493AbgLBICf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 03:02:35 -0500
IronPort-SDR: HY4d+Q9halu6MD6K2zO01+edsPgn7p1M1w4okN/3A//+Yjx/O5FAeLFjPj8Seu84ZEyeHPRhmB
 /pJsv1BLT54w==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="234576214"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="234576214"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 00:01:51 -0800
IronPort-SDR: vqL1gVAOxeSVUlp+PMU1ohAWnbo5iXiL/BSgbWLYIPa4rMgthWxX7YXsj81Cxwd9NAp8FZeWqW
 oSMaIBo2V/Wg==
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="481447296"
Received: from saenger-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.46.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 00:01:46 -0800
Subject: Re: [PATCH bpf-next] bpf, xdp: add bpf_redirect{,_map}() leaf node
 detection and optimization
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        hawk@kernel.org, kuba@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
References: <20201201172345.264053-1-bjorn.topel@gmail.com>
 <20201202044638.zqqlgabmx2xjsunf@ast-mbp>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1f3efb08-498c-7e77-040d-5551e8237d17@intel.com>
Date:   Wed, 2 Dec 2020 09:01:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202044638.zqqlgabmx2xjsunf@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-02 05:46, Alexei Starovoitov wrote:
[...]
> 
> Sorry I don't like this check at all. It's too fragile.
> It will work for one hard coded program.
> It may work for something more real, but will break with minimal
> changes to the prog or llvm changes.
> How are we going to explain that fragility to users?
>

[...]

> 
> I haven't looked through all possible paths, but it feels very dangerous.
> The stack growth is big. Calling xsk_rcv from preempt_disabled
> and recursively calling into another bpf prog?
> That violates all stack checks we have in the verifier.
>

Fair points, and thanks for pointing them out.

If the robustness (your first point) is improved, say via proper
indirect jump support, the stack usage will still be a concern.


> I see plenty of cons and not a single pro in this patch.
> 5% improvement for micro benchmark? That's hardly a justification.
> 

It's indeed a ubench, and something that is mostly beneficial to AF_XDP.
I'll go back to the drawing board and make sure the cons/pro balance is
improved.

Thanks for the feedback!


Björn
