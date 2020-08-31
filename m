Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04B25832C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 23:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgHaVCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 17:02:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:46236 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaVCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 17:02:42 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqwm-0007RC-Sb; Mon, 31 Aug 2020 23:02:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqwm-0007Bn-NH; Mon, 31 Aug 2020 23:02:36 +0200
Subject: Re: [PATCH bpf-next] samples/bpf: optimize l2fwd performance in
 xdpsock
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <1598619065-1944-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fce5d3bf-0363-f4e1-2bc8-31ef0d2428b0@iogearbox.net>
Date:   Mon, 31 Aug 2020 23:02:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1598619065-1944-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 2:51 PM, Magnus Karlsson wrote:
> Optimize the throughput performance of the l2fwd sub-app in the
> xdpsock sample application by removing a duplicate syscall and
> increasing the size of the fill ring.
> 
> The latter needs some further explanation. We recommend that you set
> the fill ring size >= HW RX ring size + AF_XDP RX ring size. Make sure
> you fill up the fill ring with buffers at regular intervals, and you
> will with this setting avoid allocation failures in the driver. These
> are usually quite expensive since drivers have not been written to
> assume that allocation failures are common. For regular sockets,
> kernel allocated memory is used that only runs out in OOM situations
> that should be rare.
> 
> These two performance optimizations together lead to a 6% percent
> improvement for the l2fwd app on my machine.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!
