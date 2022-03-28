Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D9C4E923B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 12:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiC1KEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 06:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiC1KEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 06:04:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E13B3617E;
        Mon, 28 Mar 2022 03:02:28 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S8IlB0012577;
        Mon, 28 Mar 2022 10:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q7DKSfasEVPvSYM40bnl4m17qtlsj/d7/x0iS7yhgVM=;
 b=WIRcp7WXvk7bj1xbyns44rngDNo34KJU0iSr2UMN59exIAeTnXMn6ebSf8KrSRpGYfLr
 A/+hLZc5rldisNsjUHlQ6YIqMSnSHwFhprv1GOaPQ+FDyW91X8Wm+Qv6zAFK2GVtQzYx
 K8UHDWlEUGZ1bne/OQlcZ+VidKPWknEfpfqYbHoc6Nl2+DYxlPbh5dZgDbL0+eFK9Cgj
 WOx95jLC26m3sjteurUhoFMtW2/26OrunyYoifnC6jme5vHWQmYbpPkGWdZZUJwZq1HJ
 +ahSLEn3cERaiwacNPumedfWxdgG+2cA/o/64/dMhWaj6VTxpaobws/m99Ulq6xpa/Y4 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f39d91vmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:02:20 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S8Iuxa012800;
        Mon, 28 Mar 2022 10:02:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f39d91vkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:02:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S9xU56021154;
        Mon, 28 Mar 2022 10:02:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9bnsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 10:02:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SA2Fdx11338116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 10:02:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE2AA4040;
        Mon, 28 Mar 2022 10:02:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C04CA4051;
        Mon, 28 Mar 2022 10:02:15 +0000 (GMT)
Received: from [9.171.53.124] (unknown [9.171.53.124])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 10:02:15 +0000 (GMT)
Message-ID: <81aba614-6f6a-1601-6ed9-a2939696a460@linux.ibm.com>
Date:   Mon, 28 Mar 2022 12:02:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net/smc: Send out the remaining data in sndbuf before
 close
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, dust.li@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1648447836-111521-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1648447836-111521-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LohlJVzBZu0MSkw_ddSDna2PqUUqfvoq
X-Proofpoint-GUID: GB44lFKqKkIBYsWh3ok9JzJk8Xfa8JED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_03,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 spamscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203280059
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2022 08:10, Wen Gu wrote:
> The current autocork algorithms will delay the data transmission
> in BH context to smc_release_cb() when sock_lock is hold by user.
> 
> So there is a possibility that when connection is being actively
> closed (sock_lock is hold by user now), some corked data still
> remains in sndbuf, waiting to be sent by smc_release_cb(). This
> will cause:
> 
> - smc_close_stream_wait(), which is called under the sock_lock,
>   has a high probability of timeout because data transmission is
>   delayed until sock_lock is released.
> 
> - Unexpected data sends may happen after connction closed and use
>   the rtoken which has been deleted by remote peer through
>   LLC_DELETE_RKEY messages.
> 
> So this patch will try to send out the remaining corked data in
> sndbuf before active close process, to ensure data integrity and
> avoid unexpected data transmission after close.
> 
> Reported-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Fixes: 6b88af839d20 ("net/smc: don't send in the BH context if sock_owned_by_user")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---

Thank you,

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
