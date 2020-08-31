Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640FB2582A2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgHaUdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:33:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:42542 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbgHaUdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:33:13 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqUJ-0005Tu-Hd; Mon, 31 Aug 2020 22:33:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqUJ-000Tp3-90; Mon, 31 Aug 2020 22:33:11 +0200
Subject: Re: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
To:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     dsahern@gmail.com, alexander.h.duyck@intel.com,
        tom.herbert@intel.com
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0333522d-7b65-e665-f19e-d36d11bd7846@iogearbox.net>
Date:   Mon, 31 Aug 2020 22:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 9:25 PM, Harshitha Ramamurthy wrote:
> This patch adds a helper function called bpf_get_xdp_hash to calculate
> the hash for a packet at the XDP layer. In the helper function, we call
> the kernel flow dissector in non-skb mode by passing the net pointer
> to calculate the hash.

So this commit msg says 'what' the patch does, but says nothing about 'why' it is
needed especially given there's the 1 mio insn limit in place where it should be
easy to write that up in BPF anyway. The commit msg needs to have a clear rationale
which describes the motivation behind this helper.. why it cannot be done in BPF
itself?

> Changes since RFC:
> - accounted for vlans(David Ahern)
> - return the correct hash by not using skb_get_hash(David Ahern)
> - call __skb_flow_dissect in non-skb mode
> 
