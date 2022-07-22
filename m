Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E2057DF8A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiGVKXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGVKXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:23:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D473188E0A;
        Fri, 22 Jul 2022 03:23:13 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M9Hg9K016249;
        Fri, 22 Jul 2022 10:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jmbe9yVZN73eVPSTlgx/fEPoRr+MKRhjGIu3Gec2OhI=;
 b=SWqBHKVG5fhl0mGWjhXIWp70GsYUIXlo1Cx1WZ1nWZnyp6lrCR8GYfmBRvcFzFsepNwo
 SCT5TxVLcn8rwuV7SmDf6Li+BKqwtfD1xHhMSCqEbRO7MqNXEFcOZToUEcaECFmN9CJ1
 tYDTyZRQubabg+JFnf9FaRcqWHpo91W8QDAuvl8dx5Va8XGEk8IdbHJRmxJ+spA4Mly1
 OqdXZ4b5nTNmb01FDpFtZNAp0QDsY41H7I8VXF90Utx6gxeMOqHIi0VOECKi1ReAXaDA
 Ov+/F/PvAwoK/E+iZ4DbTgXn7KaY3Z9iZZUbxix0+uHpjbJTay8+nB8lFqb7nBgInB7M nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfs4t9j2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:23:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M9QIsq018257;
        Fri, 22 Jul 2022 10:23:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfs4t9j1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:23:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26MAL114010294;
        Fri, 22 Jul 2022 10:23:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy903ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:23:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26MALHQ321430688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 10:21:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4305942042;
        Fri, 22 Jul 2022 10:23:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C21364203F;
        Fri, 22 Jul 2022 10:23:06 +0000 (GMT)
Received: from [9.145.79.157] (unknown [9.145.79.157])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 10:23:06 +0000 (GMT)
Message-ID: <434e604c-7fd3-6422-d13b-309a7c1fe0d3@linux.ibm.com>
Date:   Fri, 22 Jul 2022 12:23:06 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] s390/qeth: Fix typo 'the the' in comment
Content-Language: en-US
To:     Slark Xiao <slark_xiao@163.com>, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220722093834.77864-1-slark_xiao@163.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220722093834.77864-1-slark_xiao@163.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aJ2v_J8sNMtmmEFys74vdXWAosgiAsjj
X-Proofpoint-ORIG-GUID: AO4PZTf1Jn4mEHYDGWEdtmGzMboBJDtP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.07.22 11:38, Slark Xiao wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/s390/net/qeth_core_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 9e54fe76a9b2..35d4b398c197 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -3565,7 +3565,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
>  			if (!atomic_read(&queue->set_pci_flags_count)) {
>  				/*
>  				 * there's no outstanding PCI any more, so we
> -				 * have to request a PCI to be sure the the PCI
> +				 * have to request a PCI to be sure the PCI
>  				 * will wake at some time in the future then we
>  				 * can flush packed buffers that might still be
>  				 * hanging around, which can happen if no

This trivial typo has been sent twice already to this mailinglist:
https://lore.kernel.org/netdev/Ytb1%2FuU+jlcI4jXw@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com/T/
https://lore.kernel.org/netdev/7a935730-f3a5-0b1f-2bdc-a629711a3a01@linux.ibm.com/t/
