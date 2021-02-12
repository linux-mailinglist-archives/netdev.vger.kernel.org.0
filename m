Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB431A83D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBLXS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:18:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:46770 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhBLXSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:18:23 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lAhgx-0002Zs-7R; Sat, 13 Feb 2021 00:17:39 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lAhgx-000FsS-1k; Sat, 13 Feb 2021 00:17:39 +0100
Subject: Re: [PATCH bpf] devmap: Use GFP_KERNEL for xdp bulk queue allocation
To:     =?UTF-8?B?Tk9NVVJBIEpVTklDSEko6YeO5p2R44CA5rez5LiAKQ==?= 
        <junichi.nomura@nec.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210209082451.GA44021@jeru.linux.bs1.fc.nec.co.jp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0692ede4-1f1e-2a19-db02-024c47f93202@iogearbox.net>
Date:   Sat, 13 Feb 2021 00:17:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210209082451.GA44021@jeru.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26078/Fri Feb 12 13:15:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 9:24 AM, NOMURA JUNICHI(野村　淳一) wrote:
> The devmap bulk queue is allocated with GFP_ATOMIC and the allocation may
> fail if there is no available space in existing percpu pool.
> 
> Since commit 75ccae62cb8d42 ("xdp: Move devmap bulk queue into struct net_device")
> moved the bulk queue allocation to NETDEV_REGISTER callback, whose context
> is allowed to sleep, use GFP_KERNEL instead of GFP_ATOMIC to let percpu
> allocator extend the pool when needed and avoid possible failure of netdev
> registration.
> 
> As the required alignment is natural, we can simply use alloc_percpu().
> 
> Signed-off-by: Jun'ichi Nomura <junichi.nomura@nec.com>

Applied, thanks!
