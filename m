Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95398386E44
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbhERAYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:24:38 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.80]:40124 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235539AbhERAYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:24:37 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 5AEC55EFA29
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:23:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id inW3lxL6jMGeEinW3lzmAY; Mon, 17 May 2021 19:23:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=46ceAfOlKNCtdInhOwoc6rqVFSQAE0W1FJ5BWeIJpvc=; b=Y873GH19+6ShMohch0MS2z6QgQ
        9Og4YFjFYOEYAKxN456HOZBKwnewIbcBm7SuDN8RF+U4oe7eFzIV89vo1hPCVj3c3JMRLQwPPjcpq
        1lhit41HgYuq3rNxCHBo1IDTo9UYaAC4frjrnNSlPgOS9a9xIGIKHo//NbyqNDYtWIMVeeYw928yT
        ygvtZvnvwgtHdslHeF1oz/aOGvLtd3vSpW2VwOC1HAwc1DR8NSEVxx0gnsh2DS1ir83RvGy4I4/ZB
        nKBqlhxs2ljAkFqUdAfXtk/nC2Gns6L3Bvd+pp3VZyNTn4SIf/ic8CV7WKISkr+tZ3seYCEZ5SLwb
        Fj1KmFZQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53440 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1linW0-002RhE-Vh; Mon, 17 May 2021 19:23:17 -0500
Subject: Re: [PATCH RESEND][next] bnxt_en: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305095024.GA141398@embeddedor>
 <55348913-84be-5149-e43f-7982ecd73c40@embeddedor.com>
Message-ID: <eae04cb3-cf5e-6508-dccf-574a03254c31@embeddedor.com>
Date:   Mon, 17 May 2021 19:23:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <55348913-84be-5149-e43f-7982ecd73c40@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1linW0-002RhE-Vh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53440
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 27
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:27, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:50, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a break statement instead of just letting the code
>> fall through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> index b53a0d87371a..a34810750058 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -2158,6 +2158,7 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
>>  	case CMPL_BASE_TYPE_HWRM_ASYNC_EVENT:
>>  		bnxt_async_event_process(bp,
>>  					 (struct hwrm_async_event_cmpl *)txcmp);
>> +		break;
>>  
>>  	default:
>>  		break;
>>
