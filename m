Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898AF3B61BC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhF1OiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:38:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:55000 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbhF1Of4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:35:56 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lxsKC-0002mF-GH; Mon, 28 Jun 2021 16:33:24 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lxsKB-000XfH-Fo; Mon, 28 Jun 2021 16:33:24 +0200
Subject: Re: [PATCH net v3] xdp, net: fix for construct skb by xdp inside xsk
 zc rx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com, maximmi@nvidia.com
References: <20210628114647.75449-1-xuanzhuo@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0a1614c4-19b7-2665-8eb9-7df776fa4c13@iogearbox.net>
Date:   Mon, 28 Jun 2021 16:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210628114647.75449-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26215/Mon Jun 28 13:09:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xuan,

On 6/28/21 1:46 PM, Xuan Zhuo wrote:
> When each driver supports xsk rx, if the received buff returns XDP_PASS
> after run xdp prog, it must construct skb based on xdp. This patch
> extracts this logic into a public function xdp_construct_skb().
> 
> There is a bug in the original logic. When constructing skb, we should
> copy the meta information to skb and then use __skb_pull() to correct
> the data.
> 
> Fixes: 0a714186d3c0f ("i40e: add AF_XDP zero-copy Rx support")
> Fixes: 2d4238f556972 ("ice: Add support for AF_XDP")
> Fixes: bba2556efad66 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> Fixes: d0bcacd0a1309 ("ixgbe: add AF_XDP zero-copy Rx support")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

There was still an ongoing discussion on the v2 of your patch between
Maciej and Maxim (Cc). Before you submit a v3, please let the discussion
conclude first.

Thanks,
Daniel
