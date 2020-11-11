Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332AA2AF8F8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKKTYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:24:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35583 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgKKTYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 14:24:00 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kcvin-0005qG-Ux; Wed, 11 Nov 2020 19:23:58 +0000
Subject: Re: [PATCH][next] mptcp: fix a dereference of pointer before msk is
 null checked.
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201109125215.2080172-1-colin.king@canonical.com>
 <cb9fba1-b399-325f-c956-ede9da1b1b7@linux.intel.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <e493452c-4dc1-d2b2-e05b-9bace72af2dc@canonical.com>
Date:   Wed, 11 Nov 2020 19:23:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <cb9fba1-b399-325f-c956-ede9da1b1b7@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2020 18:49, Mat Martineau wrote:
> On Mon, 9 Nov 2020, Colin King wrote:
> 
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the assignment of pointer net from the sock_net(sk) call
>> is potentially dereferencing a null pointer sk. sk points to the
>> same location as pointer msk and msk is being null checked after
>> the sock_net call.  Fix this by calling sock_net after the null
>> check on pointer msk.
>>
>> Addresses-Coverity: ("Dereference before null check")
>> Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>> net/mptcp/pm_netlink.c | 4 +++-
>> 1 file changed, 3 insertions(+), 1 deletion(-)
>>
> 
> Hi Colin and Jakub -
> 
> I noticed that the follow-up discussion on this patch didn't go to the
> netdev list, so patchwork did not get updated.
> 
> This patch is superseded by the following, which already has a
> Reviewed-by tag from Matthieu:
> 
> http://patchwork.ozlabs.org/project/netdev/patch/078a2ef5bdc4e3b2c25ef852461692001f426495.1604976945.git.geliangtang@gmail.com/
> 
> 
OK, thanks for letting me know. Good to see it got fixed!

Colin
> 
> Thanks!
> 
> -- 
> Mat Martineau
> Intel

