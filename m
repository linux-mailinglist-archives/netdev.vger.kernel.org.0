Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C1925B610
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIBVnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:43:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:56340 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBVnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:43:24 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDaXE-0003iS-Rq; Wed, 02 Sep 2020 23:43:16 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDaXE-000OWb-M7; Wed, 02 Sep 2020 23:43:16 +0200
Subject: Re: [PATCH bpf-next] xsk: fix use-after-free in failed shared_umem
 bind
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
References: <1599032164-25684-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0a6ccaa3-3e14-4159-bdee-026923e59474@iogearbox.net>
Date:   Wed, 2 Sep 2020 23:43:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1599032164-25684-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 9:36 AM, Magnus Karlsson wrote:
> Fix use-after-free when a shared umem bind fails. The code incorrectly
> tried to free the allocated buffer pool both in the bind code and then
> later also when the socket was released. Fix this by setting the
> buffer pool pointer to NULL after the bind code has freed the pool, so
> that the socket release code will not try to free the pool. This is
> the same solution as the regular, non-shared umem code path has. This
> was missing from the shared umem path.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: syzbot+5334f62e4d22804e646a@syzkaller.appspotmail.com
> Fixes: b5aea28dca13 ("xsk: Add shared umem support between queue ids")

Lgtm, applied, thanks!
