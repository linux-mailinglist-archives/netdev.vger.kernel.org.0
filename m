Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8233524C4E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353497AbiELMB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbiELMB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:01:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F5262A37;
        Thu, 12 May 2022 05:01:54 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CBPkbZ013678;
        Thu, 12 May 2022 12:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RUlyg8FDU+wb0XmaG9hw5n80lwl5Wa6K4p4fyelbBgY=;
 b=OqxXcjwDWCS4v3Ty6Cd4eXmWGJWepTNWW9PkXP/rFC68YrmqsRI7trzYOt28qlL4Payv
 BBvdxteGk3VEbW4/uYzPR2/ZhLGDit8I6lPrnBbQdpBjZ1+ZGlqsV8Lj75Um1yUpqpgO
 95TEdQ3WCUeoVM6g5tq3qRbdgchv7mb/oLf4DH2VJyH0I/0lt3udMLg3Y4H+wSAsjxuc
 FU3IKKZIiYIAT6rh/w/rocbby6Trgic6rk0Jj3mMCo1GP5rUjYzz36hrJQMbHeNrW6/X
 6KDidC422NFoy2XEOd+ZOn4Ip4lPmyVBqV9c7N2/WuWGI+1fhP2RvotMiML0hmG+PGd/ fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11bugkhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:01:45 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CBxLFS005313;
        Thu, 12 May 2022 12:01:44 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11bugket-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:01:44 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CBwljZ007877;
        Thu, 12 May 2022 12:01:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8wej5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:01:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CC1Fic33554692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 12:01:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4972552050;
        Thu, 12 May 2022 12:01:36 +0000 (GMT)
Received: from [9.152.222.250] (unknown [9.152.222.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0E12E5204E;
        Thu, 12 May 2022 12:01:36 +0000 (GMT)
Message-ID: <fc6c27ca-5592-8445-7054-76c9b2ec6de8@linux.ibm.com>
Date:   Thu, 12 May 2022 14:01:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net v2] net/smc: non blocking recvmsg() return -EAGAIN
 when no data and signal_pending
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, tonylu@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220512030820.73848-1-guangguan.wang@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220512030820.73848-1-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9mfs52fYt2fw_WmFyVUEzbXusk4f-esO
X-Proofpoint-ORIG-GUID: NJE6ZRCo5JJqsA7vqARbTU2b3RGKeymv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120056
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2022 05:08, Guangguan Wang wrote:
> Non blocking sendmsg will return -EAGAIN when any signal pending
> and no send space left, while non blocking recvmsg return -EINTR
> when signal pending and no data received. This may makes confused.
> As TCP returns -EAGAIN in the conditions described above. Align the
> behavior of smc with TCP.
> 
> Fixes: 846e344eb722 ("net/smc: add receive timeout check")
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> ---

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

Thank you.
