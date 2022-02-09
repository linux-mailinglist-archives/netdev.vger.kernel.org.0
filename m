Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373A84AEBA3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbiBIH7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiBIH7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:59:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6670CC0613CA;
        Tue,  8 Feb 2022 23:59:51 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2194Tujv024643;
        Wed, 9 Feb 2022 07:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TM89jeZR3hp5YkmJjCUIZAQfdRAWvUAR7HMXrcvyp9Y=;
 b=naw1uQGpYr2y/XCM+avyaJzHGmHmsc/0ZUNsSqSQVdieNXNTAoUQnbLqLDi6wZI4/YQW
 0jMoQrDifR/bP6SVEcVxSPJh+SV1TizlJ18+TvJx/cFTh+u1R6jCtW9x6dl7raRdtmQK
 8Oc8Q4hPZVq/sxqEgOjn/Lvbf2elBOTe+N/foaDXQtjP6VghGhiVQY9tajCVXPr/k7fo
 1pxYjH2Ih8jtw/xCqTYHk5WkklLsQ5va+7P2r/wzRDqvhdseqr/xwhzK7TldNys0A2QH
 fU3hBGSEsL4xuEXuIpO+LMisLtEwEwjF4+gRZrNvF/pOSfppbjMIQUTFU/+6jMAPd+S7 rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e46mn4gv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:59:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2197rkwN010093;
        Wed, 9 Feb 2022 07:59:49 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e46mn4guq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:59:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2197qgop011881;
        Wed, 9 Feb 2022 07:59:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9mek8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:59:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2197xifv47055158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 07:59:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 502E34C052;
        Wed,  9 Feb 2022 07:59:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA6434C04A;
        Wed,  9 Feb 2022 07:59:43 +0000 (GMT)
Received: from [9.145.24.227] (unknown [9.145.24.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 07:59:43 +0000 (GMT)
Message-ID: <e19f2c6a-0429-7e33-4083-caf58414d453@linux.ibm.com>
Date:   Wed, 9 Feb 2022 08:59:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v5 4/5] net/smc: Dynamic control auto fallback by
 socket options
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <20f504f961e1a803f85d64229ad84260434203bd.1644323503.git.alibuda@linux.alibaba.com>
 <74e9c7fb-073c-cd62-c42a-e57c18de3404@linux.ibm.com>
 <9ba496e1-daf1-57d2-318e-bfcd4f57755c@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <9ba496e1-daf1-57d2-318e-bfcd4f57755c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CLFbqcOMpMq3T5cGntM_iugrjV4weN3e
X-Proofpoint-GUID: hJ9hffZ76Lw4ZhrXFghoxnLXobQ9ayCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxlogscore=842 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 07:41, D. Wythe wrote:
> 
> Some of our servers have different service types on different ports.
> A global switch cannot control different service ports individually in this case。In fact, it has nothing to do with using netlink or not. Socket options is the first solution comes to my mind in that case，I don't know if there is any other better way。
> 

I try to understand why you think it is needed to handle different 
service types differently. As you wrote

> After some trial and thought, I found that the scope of netlink control is too large

please explain what you found out. I don't doubt about netlink or socket option here,
its all about why a global switch for this behavior isn't good enough.
