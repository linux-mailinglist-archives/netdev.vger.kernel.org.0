Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E23386E70
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbhERAtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:49:01 -0400
Received: from gateway30.websitewelcome.com ([192.185.160.12]:27901 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239874AbhERAtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:49:00 -0400
X-Greylist: delayed 1356 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 20:49:00 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 2F34B7018
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:25:06 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id inXml3go0vAWvinXmlDfCd; Mon, 17 May 2021 19:25:06 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=17jgeobkFVa1lONgCh3PHoiuxiQYySp4r1X7ZA320/I=; b=gCqIuJE/aNf9EAT1kuQWxDSRs6
        8apFAREr2OInbd6d8QRxxv3wk/YF0ewMrfEQcALPiGL9XtWK2wacq4JY/XsWfAjcHxUIgCj+eeWEe
        hcLo1ihouocgkNEIeIUhTo9QT/YENk2OapkB0iXEmhR9VcQ99cV5BHdyi8ynBWyIcsuFzK9Ux/kmA
        iXP2nLVABM7DlCytE+lqQ+oF9i7qR2eAcHC4NsFSaiGk6ak4krf9B6QLkanKORZZJhCk6bhkPXzMv
        wXgNdSBguSC9JJMzG+EqfKq79Y74/qbvWD1TDBnAl/wOxgwRNLReyY5WNhQqqSw/RHLzLWHWShSFm
        m+XBN6aw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53444 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1linXh-002TFl-KX; Mon, 17 May 2021 19:25:01 -0500
Subject: Re: [PATCH RESEND][next] qlcnic: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305091735.GA139591@embeddedor>
 <9502f47c-4e5c-2406-9cc7-708c90899c9d@embeddedor.com>
Message-ID: <fccf5380-7898-8a96-be52-a4f6efc64e76@embeddedor.com>
Date:   Mon, 17 May 2021 19:25:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <9502f47c-4e5c-2406-9cc7-708c90899c9d@embeddedor.com>
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
X-Exim-ID: 1linXh-002TFl-KX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53444
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 36
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
> On 3/5/21 03:17, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
>> warnings by explicitly adding a break and a goto statements instead of
>> just letting the code fall through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c   | 1 +
>>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>> index bdf15d2a6431..af4c516a9e7c 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
>> @@ -1390,6 +1390,7 @@ static int qlcnic_process_rcv_ring(struct qlcnic_host_sds_ring *sds_ring, int ma
>>  			break;
>>  		case QLCNIC_RESPONSE_DESC:
>>  			qlcnic_handle_fw_message(desc_cnt, consumer, sds_ring);
>> +			goto skip;
>>  		default:
>>  			goto skip;
>>  		}
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> index 96b947fde646..8966f1bcda77 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> @@ -3455,6 +3455,7 @@ qlcnic_fwinit_work(struct work_struct *work)
>>  			adapter->fw_wait_cnt = 0;
>>  			return;
>>  		}
>> +		break;
>>  	case QLCNIC_DEV_FAILED:
>>  		break;
>>  	default:
>>
