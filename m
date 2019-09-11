Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FB3AFA97
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfIKKjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:39:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:53278 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfIKKjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 06:39:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 03:39:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,493,1559545200"; 
   d="scan'208";a="200497189"
Received: from sroessel-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.38.107])
  by fmsmga001.fm.intel.com with ESMTP; 11 Sep 2019 03:39:08 -0700
Subject: Re: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
To:     Yonghong Song <yhs@fb.com>, Sami Tolvanen <samitolvanen@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20190909223236.157099-1-samitolvanen@google.com>
 <4f4136f5-db54-f541-2843-ccb35be25ab4@fb.com>
 <20190910172253.GA164966@google.com>
 <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <fd8b6f04-3902-12e9-eab1-fa85b7e44dd5@intel.com>
Date:   Wed, 11 Sep 2019 12:39:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-09-11 09:42, Yonghong Song wrote:
> I am not an expert in XDP testing. Toke, Björn, could you give some
> suggestions what to test for XDP performance here?

I ran the "xdp_rxq_info" sample with and without Sami's patch:

$ sudo ./xdp_rxq_info --dev enp134s0f0 --action XDP_DROP

Before:

Running XDP on dev:enp134s0f0 (ifindex:6) action:XDP_DROP options:no_touch
XDP stats       CPU     pps         issue-pps
XDP-RX CPU      20      23923874    0
XDP-RX CPU      total   23923874

RXQ stats       RXQ:CPU pps         issue-pps
rx_queue_index   20:20  23923878    0
rx_queue_index   20:sum 23923878

After Sami's patch:

Running XDP on dev:enp134s0f0 (ifindex:6) action:XDP_DROP options:no_touch
XDP stats       CPU     pps         issue-pps
XDP-RX CPU      20      22998700    0
XDP-RX CPU      total   22998700

RXQ stats       RXQ:CPU pps         issue-pps
rx_queue_index   20:20  22998705    0
rx_queue_index   20:sum 22998705


So, roughly ~4% for this somewhat naive scenario.


As for XDP performance tests; I guess some of the XDP selftests could be
used as well!


Björn
