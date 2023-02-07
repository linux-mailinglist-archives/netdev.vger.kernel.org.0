Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36F68E459
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjBGXWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBGXWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:22:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5F33E638;
        Tue,  7 Feb 2023 15:22:31 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317NCBTi002476;
        Tue, 7 Feb 2023 23:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CFvuPczDTIbYFf16TC9kyz0/5qjw+FzvCIfwliyVKQ8=;
 b=kJOvgmmMmw6wmPo5oQvCuDoMRB/YU04NBOCJxcUXmsKtzaxkz70lyXRP6cmDCyoLbW0T
 TtL0RLyxUf9OxUsmy5JFovf+q52MkEsKAYqjiG/sHX7b4ZpfHV2VPjSvZwhkRKtz/FE5
 nQygL6d4jD1GHtOEGmmeHfQbAxogRmw3gncED2KWUuu3HFgc+5Ng6FwZbVrHlsnNAgrQ
 a3KI9ZRu6Pvus37phBLnwcmrz40Qk0tTY7qDWveVv8gsw5ZPqO0zN7HXvJ238jgHwx+i
 b892YbMaxdydhZetT+JlxLu/ukB47cCD7/V3xaDoUlTF6rplcXZgwgeDxeJo2Q0rgWAY og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm03rr725-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:22:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317NCwsc003787;
        Tue, 7 Feb 2023 23:22:28 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm03rr71w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:22:28 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 317JsM24020150;
        Tue, 7 Feb 2023 23:22:27 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3nhf07ac3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:22:26 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317NMPRD28246582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 23:22:25 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2778E58043;
        Tue,  7 Feb 2023 23:22:25 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBFEC58055;
        Tue,  7 Feb 2023 23:22:23 +0000 (GMT)
Received: from [9.211.153.50] (unknown [9.211.153.50])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 23:22:23 +0000 (GMT)
Message-ID: <21ff0148-9410-b399-d027-67c8ebc36c89@linux.ibm.com>
Date:   Wed, 8 Feb 2023 00:22:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next 2/2] net/smc: make SMC_LLC_FLOW_RKEY run concurrently
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
 <1675755374-107598-3-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1675755374-107598-3-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Mjp7rk11P3PkW3co_YD1ocqz_ocwBK-
X-Proofpoint-ORIG-GUID: 4REua-UoPYya3ebPc_3LYGMCRdVOwfKc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_13,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070198
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.23 08:36, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Once confirm/delete rkey response can be multiplex delivered,
> We can allow parallel execution of start (remote) or
> initialization (local) a SMC_LLC_FLOW_RKEY flow.
> 
> This patch will count the flows executed in parallel, and only when
> the count reaches zero will the current flow type be removed.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   net/smc/smc_core.h |  1 +
>   net/smc/smc_llc.c  | 89 ++++++++++++++++++++++++++++++++++++++++++------------
>   net/smc/smc_llc.h  |  6 ++++
>   3 files changed, 77 insertions(+), 19 deletions(-)
> 

[...]
>   /* start a new local llc flow, wait till current flow finished */
> @@ -289,6 +300,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
>   			  enum smc_llc_flowtype type)
>   {
>   	enum smc_llc_flowtype allowed_remote = SMC_LLC_FLOW_NONE;
> +	bool accept = false;
>   	int rc;
>   
>   	/* all flows except confirm_rkey and delete_rkey are exclusive,
> @@ -300,10 +312,39 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
>   	if (list_empty(&lgr->list))
>   		return -ENODEV;
>   	spin_lock_bh(&lgr->llc_flow_lock);
> -	if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE &&
> -	    (lgr->llc_flow_rmt.type == SMC_LLC_FLOW_NONE ||
> -	     lgr->llc_flow_rmt.type == allowed_remote)) {
> -		lgr->llc_flow_lcl.type = type;
> +
> +	/* Flow is initialized only if the following conditions are met:
> +	 * incoming flow	local flow		remote flow
> +	 * exclusive		NONE			NONE
> +	 * SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY
> +	 * SMC_LLC_FLOW_RKEY	NONE			SMC_LLC_FLOW_RKEY
> +	 * SMC_LLC_FLOW_RKEY	SMC_LLC_FLOW_RKEY	NONE
> +	 */
> +	switch (type) {
> +	case SMC_LLC_FLOW_RKEY:
> +		if (!SMC_IS_PARALLEL_FLOW(lgr->llc_flow_lcl.type))
> +			break;
> +		if (!SMC_IS_PARALLEL_FLOW(lgr->llc_flow_rmt.type))
> +			break;
> +		/* accepted */
> +		accept = true;
> +		break;
> +	default:
> +		if (!SMC_IS_NONE_FLOW(lgr->llc_flow_lcl.type))
> +			break;
> +		if (!SMC_IS_NONE_FLOW(lgr->llc_flow_rmt.type))
> +			break;
> +		/* accepted */
> +		accept = true;
> +		break;
> +	}
> +	if (accept) {
> +		if (SMC_IS_NONE_FLOW(lgr->llc_flow_lcl.type)) {
> +			lgr->llc_flow_lcl.type = type;
> +			refcount_set(&lgr->llc_flow_lcl.parallel_refcnt, 1);
> +		} else {
> +			refcount_inc(&lgr->llc_flow_lcl.parallel_refcnt);
> +		}
>   		spin_unlock_bh(&lgr->llc_flow_lock);
>   		return 0;
>   	}

I like this.

[...]
