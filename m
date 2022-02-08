Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE184ACF57
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346331AbiBHDAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiBHC75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:59:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24088C0401C9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:59:57 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2180V88w016682
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 02:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=rZKRGWlMHfIKq6PH/w4wZSlefwUx47QvCgzNHiptu30=;
 b=d1CgQBy+W9QDuXGCbWBIejVmK/wcQq3m5Dyd1B/iD0S0OpiBG2uBAtVCihXFcczv9YK/
 GqiK17CUc3d2WqR06wPxMgXXLmsknmEsryD61ZvbHLBvUgyyO+B6Mvw7bS86VJu0mbsl
 kOzS2c4ydRLLgnyStjC5Qf2NaCkTKIoMDyVTJnt4ji/AaQb5KZiEmEH96LZf+VHlfVBK
 dJhjGIeBY5a8yBPVCZKAflcOl9KKvH0YlUzw9IekamU+ch7F/wBRrFLWI5zRwzeOUN8Q
 kT+W2K+limEJ1w5O57Z3c8vWBkAQcS1b3xaUyNLJUqasEtq7JGow0H+xnT1rMtzJJw71 ag== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3e1tan5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 02:59:56 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2182boR3025999
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 02:59:55 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3e2f8mwh11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 02:59:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2182xpYK33358098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 02:59:51 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EC3378067;
        Tue,  8 Feb 2022 02:59:51 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD1C578060;
        Tue,  8 Feb 2022 02:59:50 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 02:59:50 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 07 Feb 2022 18:59:50 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        vaish123@in.ibm.com, Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: Re: [PATCH net 1/1] ibmvnic: don't release napi in __ibmvnic_open()
In-Reply-To: <20220208001918.900602-1-sukadev@linux.ibm.com>
References: <20220208001918.900602-1-sukadev@linux.ibm.com>
Message-ID: <e775f63a0e8883b3f450866161034470@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: knSGIu1TVK_Rac4GORUBa4a2fD_qAAT6
X-Proofpoint-ORIG-GUID: knSGIu1TVK_Rac4GORUBa4a2fD_qAAT6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=987 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080012
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-07 16:19, Sukadev Bhattiprolu wrote:
> If __ibmvnic_open() encounters an error such as when setting link 
> state,
> it calls release_resources() which frees the napi structures 
> needlessly.
> Instead, have __ibmvnic_open() only clean up the work it did so far 
> (i.e.
> disable napi and irqs) and leave the rest to the callers.
> 
> If caller of __ibmvnic_open() is ibmvnic_open(), it should release the
> resources immediately. If the caller is do_reset() or do_hard_reset(),
> they will release the resources on the next reset.
> 
> This fixes following crash that occured when running the drmgr command
> several times to add/remove a vnic interface:
> 
> 	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
> 	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
> 	[102056] ibmvnic 30000003 env3: Replenished 8 pools
> 	Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
> 	BUG: Kernel NULL pointer dereference on read at 0x00000010
> 	Faulting instruction address: 0xc000000000a3c840
> 	Oops: Kernel access of bad area, sig: 11 [#1]
> 	LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
> 	...
> 	CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted
> 5.16.0-rc5-autotest-g6441998e2e37 #1
> 	Workqueue: events_long __ibmvnic_reset [ibmvnic]
> 	NIP:  c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
> 	REGS: c0000000548e37e0 TRAP: 0300   Not tainted
> (5.16.0-rc5-autotest-g6441998e2e37)
> 	MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28248484  XER: 
> 00000004
> 	CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 
> 0
> 	GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 
> 0000000000000000
> 	...
> 	NIP [c000000000a3c840] napi_enable+0x20/0xc0
> 	LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
> 	Call Trace:
> 	[c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
> 	[c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 
> [ibmvnic]
> 	[c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 
> [ibmvnic]
> 	[c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
> 	[c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
> 	[c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
> 	[c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
> 	Instruction dump:
> 	7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 
> 39430010
> 	38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 
> e9210020
> 	---[ end trace 5f8033b08fd27706 ]---
> 
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling)
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index f5d1ba9bea48..50d2e48274eb 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -110,6 +110,7 @@ static void ibmvnic_tx_scrq_clean_buffer(struct
> ibmvnic_adapter *adapter,
>  					 struct ibmvnic_sub_crq_queue *tx_scrq);
>  static void free_long_term_buff(struct ibmvnic_adapter *adapter,
>  				struct ibmvnic_long_term_buff *ltb);
> +static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
> 
>  struct ibmvnic_stat {
>  	char name[ETH_GSTRING_LEN];
> @@ -1424,7 +1425,7 @@ static int __ibmvnic_open(struct net_device 
> *netdev)
>  	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
>  	if (rc) {
>  		ibmvnic_napi_disable(adapter);
> -		release_resources(adapter);
> +		ibmvnic_disable_irqs(adapter);
>  		return rc;
>  	}
> 
> @@ -1474,9 +1475,6 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  		rc = init_resources(adapter);
>  		if (rc) {
>  			netdev_err(netdev, "failed to initialize resources\n");
> -			release_resources(adapter);
> -			release_rx_pools(adapter);
> -			release_tx_pools(adapter);
>  			goto out;
>  		}
>  	}
> @@ -1493,6 +1491,13 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  		adapter->state = VNIC_OPEN;
>  		rc = 0;
>  	}
> +
> +	if (rc) {
> +		release_resources(adapter);
> +		release_rx_pools(adapter);
> +		release_tx_pools(adapter);
> +	}
> +
>  	return rc;
>  }
