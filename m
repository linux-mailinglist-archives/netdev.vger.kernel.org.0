Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B3225AE0D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgIBO6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:58:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:38572 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgIBO6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:58:35 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUDY-0001dF-AP; Wed, 02 Sep 2020 16:58:32 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUDY-0008jg-4e; Wed, 02 Sep 2020 16:58:32 +0200
Subject: Re: [PATCH bpf-next] xsk: fix possible segfault at xskmap entry
 insertion
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <1599037569-26690-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0c04fab7-8256-41ba-716c-c073fed03264@iogearbox.net>
Date:   Wed, 2 Sep 2020 16:58:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1599037569-26690-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 11:06 AM, Magnus Karlsson wrote:
> Fix possible segfault when entry is inserted into xskmap. This can
> happen if the socket is in a state where the umem has been set up, the
> Rx ring created but it has yet to be bound to a device. In this case
> the pool has not yet been created and we cannot reference it for the
> existence of the fill ring. Fix this by removing the whole
> xsk_is_setup_for_bpf_map function. Once upon a time, it was used to
> make sure that the Rx and fill rings where set up before the driver
> could call xsk_rcv, since there are no tests for the existence of
> these rings in the data path. But these days, we have a state variable
> that we test instead. When it is XSK_BOUND, everything has been set up
> correctly and the socket has been bound. So no reason to have the
> xsk_is_setup_for_bpf_map function anymore.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+febe51d44243fbc564ee@syzkaller.appspotmail.com
> Fixes: 7361f9c3d719 ("xsk: move fill and completion rings to buffer pool")

Applied & corrected Fixes tag, thanks!
