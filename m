Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36AC119091
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfLJT2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:28:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:52548 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfLJT2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 14:28:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 11:28:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="363364429"
Received: from unknown (HELO [10.241.228.156]) ([10.241.228.156])
  by orsmga004.jf.intel.com with ESMTP; 10 Dec 2019 11:28:01 -0800
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <0b45793e-6172-9c07-5bdb-2dc99e58e375@intel.com>
Date:   Tue, 10 Dec 2019 11:28:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/2019 5:55 AM, Björn Töpel wrote:
> Overview
> ========
> 
> This is the 4th iteration of the series that introduces the BPF
> dispatcher, which is a mechanism to avoid indirect calls.

Good to see the progress with getting a mechansism to avoid indirect calls
upstream.

[...]


> Performance
> ===========
> 
> The tests were performed using the xdp_rxq_info sample program with
> the following command-line:
> 
> 1. XDP_DRV:
>    # xdp_rxq_info --dev eth0 --action XDP_DROP
> 2. XDP_SKB:
>    # xdp_rxq_info --dev eth0 -S --action XDP_DROP
> 3. xdp-perf, from selftests/bpf:
>    # test_progs -v -t xdp_perf

What is this test_progs? I don't see such ann app under selftests/bpf


> Run with mitigations=auto
> -------------------------
> 
> Baseline:
> 1. 22.0 Mpps
> 2. 3.8 Mpps
> 3. 15 ns
> 
> Dispatcher:
> 1. 29.4 Mpps (+34%)
> 2. 4.0 Mpps  (+5%)
> 3. 5 ns      (+66%)
> 
> Dispatcher (full; walk all entries, and fallback):
> 1. 20.4 Mpps (-7%)
> 2. 3.8 Mpps
> 3. 18 ns     (-20%)

Are these packets received on a single queue? Or multiple queues?
Do you see similar improvements even with xdpsock?

Thanks
Sridhar
