Return-Path: <netdev+bounces-6556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BC6716E5E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD9BB1C20D09
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A24431EF4;
	Tue, 30 May 2023 20:09:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED17200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:09:05 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA745F3;
	Tue, 30 May 2023 13:09:03 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UIdwJa003875;
	Tue, 30 May 2023 20:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5rWZ2/PgxHy/y5NYiyjQh4DXegRR/1Cb3dzKDHLoPGs=;
 b=TKfM+m5O14f2Y25lpdUqyKZaTU0vyltCCMdzdkdr+WLtlrbx3N6/UD0pbNnmI9WKmIlE
 pxLdBjZuGOEG9qqJ/vvnfYYS25qvTmVEKA0nBMvqEv+AwSEoyRsgaXal2Lik1KROK75V
 3fqcRffZT7k9/A/JlLFc2tfXtOzBeYQDKuCWalJ0DxtQHdA/yCOUOfFeeQhy+tkhKk3u
 aSaSRtEN1RnxhAxFZ1TwJwA9ugjxcbKE+ncYN0o+KejpBDBahueKkpfo7HfYkJe19agV
 I89KD9lcbru5ftcNN2tfwdqFrEUPQuLv6uyNgeJEF9SCXjS8MruMNmFM8STgRRjr2H+4 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvf8huh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:08:58 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UJ03jZ002236;
	Tue, 30 May 2023 20:08:58 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvf8htx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:08:58 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
	by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UHWvad003118;
	Tue, 30 May 2023 20:08:56 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
	by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g5rdq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 20:08:56 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UK8sn634800156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 20:08:54 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B64A258045;
	Tue, 30 May 2023 20:08:54 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3F9E58050;
	Tue, 30 May 2023 20:08:52 +0000 (GMT)
Received: from [9.61.92.222] (unknown [9.61.92.222])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 May 2023 20:08:52 +0000 (GMT)
Message-ID: <4c8f11e5-d97d-5c9a-69b1-ba11c5857799@linux.ibm.com>
Date: Tue, 30 May 2023 22:08:51 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net 1/2] net/smc: Scan from current RMB list when no
 position specified
To: Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
 <1685101741-74826-2-git-send-email-guwen@linux.alibaba.com>
From: Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1685101741-74826-2-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NZw55rljhcxjYUq1xtakSkwQSz7DlSI4
X-Proofpoint-GUID: cmd8PxFCF0pWlGsjsyioEBINrEFIq511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_15,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 26.05.23 13:49, Wen Gu wrote:
> When finding the first RMB of link group, it should start from the
> current RMB list whose index is 0. So fix it.
> 
> Fixes: b4ba4652b3f8 ("net/smc: extend LLC layer for SMC-Rv2")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>   net/smc/smc_llc.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index a0840b8..8423e8e 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -578,7 +578,10 @@ static struct smc_buf_desc *smc_llc_get_next_rmb(struct smc_link_group *lgr,
>   {
>   	struct smc_buf_desc *buf_next;
>   
> -	if (!buf_pos || list_is_last(&buf_pos->list, &lgr->rmbs[*buf_lst])) {
> +	if (!buf_pos)
> +		return _smc_llc_get_next_rmb(lgr, buf_lst);
> +
> +	if (list_is_last(&buf_pos->list, &lgr->rmbs[*buf_lst])) {
>   		(*buf_lst)++;
>   		return _smc_llc_get_next_rmb(lgr, buf_lst);
>   	}
It seems too late, but still, why not? :

-	if (!buf_pos || list_is_last(&buf_pos->list, &lgr->rmbs[*buf_lst])) {
-  		(*buf_lst)++;
+	if (list_is_last(&buf_pos->list, &lgr->rmbs[(*buf_lst])++)) {


Thanks,
Wenjia

