Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACF248A948
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbiAKIXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:23:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231130AbiAKIXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 03:23:13 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B6M46N006394;
        Tue, 11 Jan 2022 08:23:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZCXiORw8q4kMLigaeWbCEr1ZbPrWij1oIpz06YA8rxA=;
 b=S3f5OetpLok3Be2CnYgiKrtAE1kWYUG+VQ4nMJGvncSWPAdO/DsQXbLQYQ9pCG8WicW/
 Xps6ZA+mN5l2nS0B9ozVqPPJ8fgqA0MkYTCuV51ePXLrfuIcGXGbFhtXU7DaJDUUrtc4
 daI2VRPdeIUduquDVlIoOai9gPPAeVPSBXbfg9DAzp9OJ787VstVx0GvaI9FuU8pplqG
 GXAexwgPXRDJel3i4KS5P/svW2FAcUS8dy/2xUnhFgwNW5qVYbnJZx6yARD+T8IPXLWi
 YdUEi7Y12mb80VYoSSIOrQfI5WKpGLguoxSNFxfd1VN4jBwLEnM0sOMjHBQ1AcGpNyej kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh4jdasgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:23:12 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20B7psTJ030195;
        Tue, 11 Jan 2022 08:23:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh4jdasg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:23:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20B8DgS5025268;
        Tue, 11 Jan 2022 08:23:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhhx62b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:23:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20B8N6v138863202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 08:23:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B499D4C05A;
        Tue, 11 Jan 2022 08:23:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA724C044;
        Tue, 11 Jan 2022 08:23:06 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 08:23:06 +0000 (GMT)
Message-ID: <8b720956-c8fe-0fe2-b019-70518d5c60c8@linux.ibm.com>
Date:   Tue, 11 Jan 2022 09:23:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/3] net/smc: Resolve the race between link group
 access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3-XXLShBQ0Q4E7NQgLXScZgiyhhOrOrK
X-Proofpoint-ORIG-GUID: oMbR3VimQlmhhihOmexF_qD8Y4fVweVl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_03,2022-01-10_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2022 10:26, Wen Gu wrote:
> We encountered some crashes caused by the race between the access
> and the termination of link groups.
> 

>  
> +/* won't be freed until no one accesses to lgr anymore */
> +static void __smc_lgr_free(struct smc_link_group *lgr)
> +{
> +	smc_lgr_free_bufs(lgr);
> +	if (!lgr->is_smcd)
> +		smc_wr_free_lgr_mem(lgr);
> +	kfree(lgr);
> +}
> +
>  /* remove a link group */
>  static void smc_lgr_free(struct smc_link_group *lgr)
>  {
> @@ -1298,7 +1326,6 @@ static void smc_lgr_free(struct smc_link_group *lgr)
>  		smc_llc_lgr_clear(lgr);
>  	}
>  
> -	smc_lgr_free_bufs(lgr);
>  	destroy_workqueue(lgr->tx_wq);
>  	if (lgr->is_smcd) {
>  		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
> @@ -1306,11 +1333,21 @@ static void smc_lgr_free(struct smc_link_group *lgr)
>  		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
>  			wake_up(&lgr->smcd->lgrs_deleted);
>  	} else {
> -		smc_wr_free_lgr_mem(lgr);
>  		if (!atomic_dec_return(&lgr_cnt))
>  			wake_up(&lgrs_deleted);

These waiters (seaparate ones for smcd and smcr) are used to wait for all lgrs 
to be deleted when a module unload or reboot was triggered, so it must only be 
woken up when the lgr is actually freed.
