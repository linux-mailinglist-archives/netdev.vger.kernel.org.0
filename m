Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A776C04BD
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 21:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCSUQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 16:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCSUQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 16:16:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6FF1B562;
        Sun, 19 Mar 2023 13:16:48 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32JJKeDi017015;
        Sun, 19 Mar 2023 20:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=QsNK0y+OZ5hfzlKGYoDx1EuihX8vnlV+zb8ND0pxAUE=;
 b=ookfmLgj4M4JRTennkxkwEmUbgTjW57FZzK5dl2WnefGGpYktGCroJpEEyLWMGJpD97h
 /q6jP0YAOMvbeBxQ1hc4Yz0KWjQ57DOlQuTkmiLu1JRVVhF8e/mhlEnIK5qRtgLzrZ3Y
 InLV8zFfTmT6k3p4tOacFzcLT89NNHKQksPAgfrM8TxAR8YRf/7YLjJRuZH2hIYSS9pQ
 X9lRV15N4L+uR+c3VMar5Fyo2dvoW2vwvExT3RcYBUVY6se3e3Gb21qq4AYSIZksDTXP
 R3vs4v1h8uWKCTDcHJlh33oGz3uKryVx4I4pTdDRPFzTjgMpIcflvcDAjBRSME6g6VwW Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq3t6fjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Mar 2023 20:16:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32JKDNnm024808;
        Sun, 19 Mar 2023 20:16:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq3t6fj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Mar 2023 20:16:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32JAdZS6017248;
        Sun, 19 Mar 2023 20:16:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6a8c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Mar 2023 20:16:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32JKGX9P26280546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 20:16:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0131D2004B;
        Sun, 19 Mar 2023 20:16:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A69E20040;
        Sun, 19 Mar 2023 20:16:32 +0000 (GMT)
Received: from osiris (unknown [9.179.4.200])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Sun, 19 Mar 2023 20:16:32 +0000 (GMT)
Date:   Sun, 19 Mar 2023 21:16:31 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Lizhe <sensor1010@163.com>
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/iucv: Remove redundant driver match function
Message-ID: <ZBdtn0wFunrkvml9@osiris>
References: <20230319050840.377727-1-sensor1010@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319050840.377727-1-sensor1010@163.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IZBm3U_8tAbuInu_Z0ce4ePC1SQhvhbD
X-Proofpoint-GUID: vjYhpcrARTDgGuTF_PmVJJeUWsnh78qJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-19_10,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0
 mlxlogscore=810 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303150002 definitions=main-2303190172
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 01:08:40PM +0800, Lizhe wrote:
> If there is no driver match function, the driver core assumes that each
> candidate pair (driver, device) matches, see driver_match_device().
> 
> Drop the bus's match function that always returned 1 and so
> implements the same behaviour as when there is no match function
...
> 
> Signed-off-by: Lizhe <sensor1010@163.com>
> ---
>  net/iucv/iucv.c | 6 ------
>  1 file changed, 6 deletions(-)
...
> -static int iucv_bus_match(struct device *dev, struct device_driver *drv)
> -{
> -	return 0;
        ^^^^^^^^

If I'm not wrong then 0 != 1.
