Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D4F46652F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347308AbhLBO0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:26:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhLBO0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:26:38 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2DqeAo028559;
        Thu, 2 Dec 2021 14:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/fE+NAP6ZOOEwYdElF5KkduFs+ahRTjIFStDurcU4ZA=;
 b=bLH21NA/vb1SZNQZl3g7FBzouh8JXLQdJ7sN3KBeceInzeuj+g23gUZ4n4ps33fhpI37
 JIouWETCiTAci+vkSWGIa6RcKPaDtAhhE2wN+Hf2dGegTj3rnXTpWJOBIwtpy+nqDPks
 FP7ts+YAiVCNxPD4IM1pTSxCGWTLV115ZCbCN/9G1R+R722BtWuj8VS40TYJKNqpdyr4
 9fOWwtWoSlPC7+TN++e0XKFNSLrf6NQ5LvYCdf3+NvG5CL84BdWCDhheeHt5PixVdHJ7
 o4G/dMQnzNtOjxOUCVF9GjqAykG+mqa3ykowbgqqoXkYIb65BfMGCqGbdlhu7e+9KWyx 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpydqgpsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 14:23:14 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2DwRLI020243;
        Thu, 2 Dec 2021 14:23:13 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpydqgps9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 14:23:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2EN82L012346;
        Thu, 2 Dec 2021 14:23:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3ckbxkau17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 14:23:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2EN77q28115362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 14:23:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87DFF42049;
        Thu,  2 Dec 2021 14:23:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3933A42054;
        Thu,  2 Dec 2021 14:23:07 +0000 (GMT)
Received: from [9.145.80.134] (unknown [9.145.80.134])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 14:23:07 +0000 (GMT)
Message-ID: <a98a49d9-a7e9-4dbc-8e3d-8ff4d917546b@linux.ibm.com>
Date:   Thu, 2 Dec 2021 15:23:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
 <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaWR6zXoYKrqtznt@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YaWR6zXoYKrqtznt@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zEld_dwgRbg4N8sz-mKxqsHwsTDCY41b
X-Proofpoint-GUID: o_W15OOVA5QAFMOpletIpp8_rONgY8C2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_07,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 03:52, Tony Lu wrote:
> Sorry for the unclear tag. This patch introduces a performance
> improvement. It should be with net-next.
> 
> I will fix it and send v2. Thank you.

Will you now send a v2 to net-next, or should I pick your v1 and 
submit it via our tree?
