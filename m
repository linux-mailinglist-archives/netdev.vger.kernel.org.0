Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09CE2A76B7
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKEEyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 23:54:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgKEEyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:54:50 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54X92L128072;
        Wed, 4 Nov 2020 23:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=PBwK4ULtQlU6aULedhiEm8NNcSZZ8RYES1telsVQ6+A=;
 b=PMyWUC9v9y/UZ/zyp6Fn/mPzFjzjZryIHfm8nn1QLyIQY1Ef5uETufjRiyFdtOj/YO4K
 Vuq8iiboUcXceGKcPQvyd+lPxvD2vZwKt5lzHo5YyFND2E4bNocFIZkPVNpbY4reP9s5
 aQKtb1ttdtYJf+5aPw3S70PrE8CNu0qSCpgYzTbvzO8FjSXxdFGpKD9sqqnOO3DHtl4X
 Pb5Kg4cTxW2etB5QuckWZ6AD25m0ioaw53rlJCEg4Hzu/f/tTRUB5MD6w2eatbNRokln
 epedFpkq7Tjqd80OmLGq5JSsafCKoech4/St7jstvprGC6kU26vaHHTgPTlxHZHMFgRl aQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m7rdby91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 23:54:47 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A54qBbp016295;
        Thu, 5 Nov 2020 04:54:46 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 34h0ewc0af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 04:54:46 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A54sjg946596504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 04:54:45 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E2B4136053;
        Thu,  5 Nov 2020 04:54:45 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C980136051;
        Thu,  5 Nov 2020 04:54:45 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  5 Nov 2020 04:54:45 +0000 (GMT)
MIME-Version: 1.0
Date:   Wed, 04 Nov 2020 20:54:45 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Subject: Re: [PATCH net 1/2] ibmvnic: notify peers when failover and migration
 happen
In-Reply-To: <20201030132703.03fa6d4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201028055742.74941-1-ljp@linux.ibm.com>
 <20201028055742.74941-2-ljp@linux.ibm.com>
 <20201030132703.03fa6d4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <fa5cc2294bd078144c93144fd2a9d3d1@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050032
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-30 13:27, Jakub Kicinski wrote:
> On Wed, 28 Oct 2020 00:57:41 -0500 Lijun Pan wrote:
>> We need to notify peers only when failover and migration happen.
>> It is unnecessary to call that in other events like
>> FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
>> since in those scenarios the MAC address and ip address mapping
>> does not change. Originally all the resets except CHANGE_PARAM
>> are processed by do_reset such that we need to find out
>> failover and migration cases in do_reset and call notifier functions.
>> We only need to notify peers in do_reset and do_hard_reset.
>> We don't need notify peers in do_change_param_reset since it is
>> a CHANGE_PARAM reset. In a nested reset case, it will finally
>> call into do_hard_reset with reasons other than failvoer and
>> migration. So, we don't need to check the reset reason in
>> do_hard_reset and just call notifier functions anyway.
> 
> You're completely undoing the commit you linked to:

Testing is underway. We will clarify the description in the next 
version.

Thank you for your review and feedback.
Dany
> 
> commit 61d3e1d9bc2a1910d773cbf4ed6f587a7a6166b5
> Author: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Date:   Mon Jun 12 20:47:45 2017 -0400
> 
>     ibmvnic: Remove netdev notify for failover resets
> 
>     When handling a driver reset due to a failover of the backing
>     server on the vios, doing the netdev_notify_peers() can cause
>     network traffic to stall or halt. Remove the netdev notify call
>     for failover resets.
> 
>     Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index fd3ef3005fb0..59ea7a5ae776 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1364,7 +1364,9 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>         for (i = 0; i < adapter->req_rx_queues; i++)
>                 napi_schedule(&adapter->napi[i]);
> 
> -       netdev_notify_peers(netdev);
> +       if (adapter->reset_reason != VNIC_RESET_FAILOVER)
> +               netdev_notify_peers(netdev);
> +
>         return 0;
>  }
> 
> But you don't seem to address why this change was unnecessary.
> 
> AFAIK you're saying "we only need this event for FAILOVER and MOBILITY"
> but the previous commit _excluded_ FAILOVER for some vague reason.
> 
> If the previous commit was incorrect you need to explain that in the
> commit message.
> 
>> netdev_notify_peers calls below two functions with rtnl lock().
>> 	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
>> 	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
>> When netdev_notify_peers was substituted in
>> commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device 
>> reset"),
>> call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.
> 
> That should be a separate patch.
> 
>> Fixes: 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover 
>> resets")
>> Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device
>> reset")
> 
> Please don't line-wrap fixes tags.
> 
>> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
>> Suggested-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
>> Signed-off-by: Dany Madden <drt@linux.ibm.com>
>> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
>> ---
>>  drivers/net/ethernet/ibm/ibmvnic.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c 
>> b/drivers/net/ethernet/ibm/ibmvnic.c
>> index 1b702a43a5d0..718da39f5ae4 100644
>> --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> @@ -2067,8 +2067,11 @@ static int do_reset(struct ibmvnic_adapter 
>> *adapter,
>>  	for (i = 0; i < adapter->req_rx_queues; i++)
>>  		napi_schedule(&adapter->napi[i]);
>> 
>> -	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
>> +	if (adapter->reset_reason == VNIC_RESET_FAILOVER ||
>> +	    adapter->reset_reason == VNIC_RESET_MOBILITY) {
>>  		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
>> +		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
>> +	}
>> 
>>  	rc = 0;
>> 
>> @@ -2138,6 +2141,9 @@ static int do_hard_reset(struct ibmvnic_adapter 
>> *adapter,
>>  	if (rc)
>>  		return IBMVNIC_OPEN_FAILED;
>> 
>> +	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
>> +	call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
>> +
>>  	return 0;
>>  }
>> 
