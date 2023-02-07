Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA568E44A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBGXPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBGXPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:15:33 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA68A27D;
        Tue,  7 Feb 2023 15:15:31 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317NDAjb016646;
        Tue, 7 Feb 2023 23:15:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QKeI7qV1Kb6hUdU1KHfdH4eYKEy+eMPsNPDnFQISqtM=;
 b=A2EpdkTVxDbwu6kQgsLgVCWGn1MDJj2mBojvx/kB+U55HYNw0BJ+9ZgaoG91EpnEOEAM
 adS5e2EPAnZDdIV51SSrPz5ZDOmA2iF0zkw7URvaTn0S88gcNRK49Y48iXpngcjN63aJ
 upAgiLA4oaqxFhN0QAuGPzVC8U6BxfHUK41IUEcM7lZyFQijYXpeoFzJOyjU2g3vMfKv
 x5T3cBj9vUCMaeewO5BHp2DePkpSYNale13MIkxxVWatrOVd3ajkEpJd6CPKDdf1YD38
 lB0yqR6++DRTmg+LtSbnOCdYl82e312JaocJERGMgNgyBdmSoK5apW+NyNkY45wwx45b 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm04dg1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:15:25 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317NFOIb024597;
        Tue, 7 Feb 2023 23:15:24 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm04dg1jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:15:24 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 317N33Ak017708;
        Tue, 7 Feb 2023 23:15:23 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3nhf07pund-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:15:23 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317NFMLe11469544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 23:15:22 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FE485805E;
        Tue,  7 Feb 2023 23:15:22 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA6858043;
        Tue,  7 Feb 2023 23:15:20 +0000 (GMT)
Received: from [9.211.153.50] (unknown [9.211.153.50])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 23:15:20 +0000 (GMT)
Message-ID: <95e117f1-6f05-1c15-cddd-38be9cf7dd52@linux.ibm.com>
Date:   Wed, 8 Feb 2023 00:15:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next 1/2] net/smc: allow confirm/delete rkey response
 deliver multiplex
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
 <1675755374-107598-2-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1675755374-107598-2-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: drvtC29bdBd_ro8so47Nx2e_7bPeG04y
X-Proofpoint-GUID: hGOskmr-34U1A5d5hj1weVY85Qs37ToP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_13,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070198
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.23 08:36, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> We know that all flows except confirm_rkey and delete_rkey are exclusive,
> confirm/delete rkey flows can run concurrently (local and remote).
> 
> Although the protocol allows, all flows are actually mutually exclusive
> in implementation, dues to waiting for LLC messages is in serial.
> 
> This aggravates the time for establishing or destroying a SMC-R
> connections, connections have to be queued in smc_llc_wait.
> 
> We use rtokens or rkey to correlate a confirm/delete rkey message
> with its response.
> 
> Before sending a message, we put context with rtokens or rkey into
> wait queue. When a response message received, we wakeup the context
> which with the same rtokens or rkey against the response message.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/smc_llc.c | 174 +++++++++++++++++++++++++++++++++++++++++-------------
>   net/smc/smc_wr.c  |  10 ----
>   net/smc/smc_wr.h  |  10 ++++
>   3 files changed, 143 insertions(+), 51 deletions(-)
> 

[...]

> +static int smc_llc_rkey_response_wake_function(struct wait_queue_entry *wq_entry,
> +					       unsigned int mode, int sync, void *key)
> +{
> +	struct smc_llc_qentry *except, *incoming;
> +	u8 except_llc_type;
> +
> +	/* not a rkey response */
> +	if (!key)
> +		return 0;
> +
> +	except = wq_entry->private;
> +	incoming = key;
> +
> +	except_llc_type = except->msg.raw.hdr.common.llc_type;
> +
> +	/* except LLC MSG TYPE mismatch */
> +	if (except_llc_type != incoming->msg.raw.hdr.common.llc_type)
> +		return 0;
> +
> +	switch (except_llc_type) {
> +	case SMC_LLC_CONFIRM_RKEY:
> +		if (memcmp(except->msg.confirm_rkey.rtoken, incoming->msg.confirm_rkey.rtoken,
> +			   sizeof(struct smc_rmb_rtoken) *
> +			   except->msg.confirm_rkey.rtoken[0].num_rkeys))
> +			return 0;
> +		break;
> +	case SMC_LLC_DELETE_RKEY:
> +		if (memcmp(except->msg.delete_rkey.rkey, incoming->msg.delete_rkey.rkey,
> +			   sizeof(__be32) * except->msg.delete_rkey.num_rkeys))
> +			return 0;
> +		break;
> +	default:
> +		pr_warn("smc: invalid except llc msg %d.\n", except_llc_type);
> +		return 0;
> +	}
> +
> +	/* match, save hdr */
> +	memcpy(&except->msg.raw.hdr, &incoming->msg.raw.hdr, sizeof(except->msg.raw.hdr));
> +
> +	wq_entry->private = except->private;
> +	return woken_wake_function(wq_entry, mode, sync, NULL);
> +}
> +

s/except/expect/ ?
Just kind of confusing

[...]
