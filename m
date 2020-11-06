Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914642A8F81
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKFGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:38:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25028 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbgKFGiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:38:20 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A66XYWT046761;
        Fri, 6 Nov 2020 01:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jsK5EAPSGPsZyQTaM9TsJQQ208Zq3p9Yfjz6tmEQonA=;
 b=sYaq1swDE4B6MORHhcsx8YSUv2IROnuoCAyHAgKWvbOizCLb+JEcmTovPUxOUffBm3uf
 QCowl1jxze1rZCR7ayJfUtzjbJssLgazGv2Lt2iQnV7YJiaZnUssrc0TrRQl9PFMiCaG
 VGa4cmNcEXoyI8sTzVTUz38KRfsJSxWHmo2MzXNXtIvywgwnUdCQ0RLcHNb9biVyKEHo
 7J7nA+jVVCfxlhKTJBB72a+ixB9118eHLC/tbRSNSDnYKydI7j16a+E/D7K1vRfYRSxK
 sSAIiv2wjVzVZEeh+LCSD6Nw0yuP2bBExx62nLc1ZcIyScd8FsbjdRng7ddQW82vAdPG dg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms004f52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 01:38:15 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A66cDt4017163;
        Fri, 6 Nov 2020 06:38:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34hm6hdf32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 06:38:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A66cAXM26149258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 06:38:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8613F11C064;
        Fri,  6 Nov 2020 06:38:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29DE411C054;
        Fri,  6 Nov 2020 06:38:10 +0000 (GMT)
Received: from [9.171.11.91] (unknown [9.171.11.91])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 06:38:10 +0000 (GMT)
Subject: Re: [PATCH net-next v2 12/15] net/smc: Add support for obtaining SMCD
 device list
To:     Saeed Mahameed <saeed@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com,
        Guevenc Guelce <guvenc@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
 <20201103102531.91710-13-kgraul@linux.ibm.com>
 <eca09b4aee1d4526e1ee772adbfaafab2afa1f20.camel@kernel.org>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <0c656b51-cd05-33a0-9bb7-cdfc21131132@linux.ibm.com>
Date:   Fri, 6 Nov 2020 07:38:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <eca09b4aee1d4526e1ee772adbfaafab2afa1f20.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_02:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2020 02:31, Saeed Mahameed wrote:
> On Tue, 2020-11-03 at 11:25 +0100, Karsten Graul wrote:
>> From: Guvenc Gulce <guvenc@linux.ibm.com>
>>
>> Deliver SMCD device information via netlink based
>> diagnostic interface.
>>
>> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
>> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
>> ---
>>  include/uapi/linux/smc.h      |  2 +
>>  include/uapi/linux/smc_diag.h | 20 +++++++++
>>  net/smc/smc_core.h            | 27 +++++++++++++
>>  net/smc/smc_diag.c            | 76
>> +++++++++++++++++++++++++++++++++++
>>  net/smc/smc_ib.h              |  1 -
>>  5 files changed, 125 insertions(+), 1 deletion(-)
>>
> 
>> +
>> +static int smc_diag_prep_smcd_dev(struct smcd_dev_list *dev_list,
>> +				  struct sk_buff *skb,
>> +				  struct netlink_callback *cb,
>> +				  struct smc_diag_req_v2 *req)
>> +{
>> +	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
>> +	int snum = cb_ctx->pos[0];
>> +	struct smcd_dev *smcd;
>> +	int rc = 0, num = 0;
>> +
>> +	mutex_lock(&dev_list->mutex);
>> +	list_for_each_entry(smcd, &dev_list->list, list) {
>> +		if (num < snum)
>> +			goto next;
>> +		rc = smc_diag_handle_smcd_dev(smcd, skb, cb, req);
>> +		if (rc < 0)
>> +			goto errout;
>> +next:
>> +		num++;
>> +	}
>> +errout:
>> +	mutex_unlock(&dev_list->mutex);
>> +	cb_ctx->pos[0] = num;
>> +	return rc;
>> +}
>> +
> 
> this function pattern repeats at least 4 times in this series and the
> only difference is the diag handler function, just abstract this
> function out and pass a function pointer as handler to reduce code
> repetition. 
> 

Thank you for your review. We will come up with a v3 to address the comments.

We plan to eliminate additional EXPORTs using an ops array that allows smc_diag to 
retrieve the needed information from the smc module.

We discussed the above comment as well, but there is no clean and easy way to change
it because (nearly) all places iterate over different lists that have different types.
It might be not a good idea to loose type safety here by calling different handlers 
with a void pointer as parameter. Additionally some lists require specific locks.

-- 
Karsten

(I'm a dude)
