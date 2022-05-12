Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5694E524C68
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353553AbiELMIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351652AbiELMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:08:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E6033E9A;
        Thu, 12 May 2022 05:08:36 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CBuOU2027358;
        Thu, 12 May 2022 12:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UpinVejisDsY3s3pfI6xdVEtuuplzdK+4Ga9n1LdEpw=;
 b=I5hyYD+hL9952MKtiyBfQQdIHpJM4wRw+VJMKoQ4ONnB75gP3FHy8QwzJCWDrrVxXibT
 aG7YOXRwhYHlaXEFYyb2jsZP/oMrns+a35nGTaEdWVmGkNEd2hppJMlaCIKgYavMFJzz
 BQhZc8xMEQIFver8w/QkBDg0YN/MxHSbW7stWpWLcfp66s4ZAZqcnm3KPIioK4qyILZ8
 BRFvgo+gGWzad+ZknbKGpX5zSPdwlh8nhSCTPIwwz8i4+D/e5ize/XvrwYIF+2gGurvV
 rWtHPnxqFQpc28ZqjS3w/0MSNbfoEopCghkhagzNH1/jarStaQQjkKDE6+rDGI616SNx cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11t9087q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:08:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CBxSWc005111;
        Thu, 12 May 2022 12:08:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11t9086r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:08:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CC7QCO009910;
        Thu, 12 May 2022 12:08:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8y08c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 12:08:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CC80gH35193266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 12:08:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE4115204F;
        Thu, 12 May 2022 12:08:21 +0000 (GMT)
Received: from [9.152.222.250] (unknown [9.152.222.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A772452050;
        Thu, 12 May 2022 12:08:21 +0000 (GMT)
Message-ID: <ba81cf0c-08c5-76e9-bfc8-369887454e52@linux.ibm.com>
Date:   Thu, 12 May 2022 14:08:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2 2/2] net/smc: align the connect behaviour with
 TCP
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tonylu@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220512031156.74054-1-guangguan.wang@linux.alibaba.com>
 <20220512031156.74054-3-guangguan.wang@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220512031156.74054-3-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2oaO-gE-6SnHAkJOjUibTWsqLRitPRID
X-Proofpoint-ORIG-GUID: nMgKDzK2wHDukIK4NrGJp_FNDdIxk9g-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120052
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2022 05:11, Guangguan Wang wrote:
> Connect with O_NONBLOCK will not be completed immediately
> and returns -EINPROGRESS. It is possible to use selector/poll
> for completion by selecting the socket for writing. After select
> indicates writability, a second connect function call will return
> 0 to indicate connected successfully as TCP does, but smc returns
> -EISCONN. Use socket state for smc to indicate connect state, which
> can help smc aligning the connect behaviour with TCP.
> 
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> ---

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

Thank you.
