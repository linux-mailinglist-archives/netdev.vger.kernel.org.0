Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F504487510
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbiAGJyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 04:54:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236845AbiAGJyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 04:54:32 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20788OXF030221;
        Fri, 7 Jan 2022 09:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yn+LZK13t96NQ70dE3DDtgrpMgvTlTKwsCocVjhcrlM=;
 b=kCpJgZ6XWEOg7iDo3ScCRRv1jB3J2D5ZkBfHViPNz/o4l3Sg1Eh6JX7DJGw4hZcntbsn
 YEmCuvM7DPRg5Id0wYr+GbqDkL1qxjIwjqQwMVUvYrOi9tb/JgMrbdoZ6iPybFqM/a6v
 q63FGVWRdWWWvzhe9RwHhSmuUqfFkA19MFj4pWbENmzVa+aOOc8pm6gsFuPwX/2Ci4mn
 9tYxwfZub019ppL/eQEfTdB8cHJP5Hoqo3sSKGBx3CBlLw+fUehQtiMI1ueq/y5Nyd/7
 +s2mYRlS9j/SpLLng5QcmEj6AO4MIb4FpZWknkuC5BS4cOa76Uof/thlIkKGr5smz6t9 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4wkpgm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 09:54:29 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2079lLxe009385;
        Fri, 7 Jan 2022 09:54:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4wkpgkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 09:54:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2079rgH3016632;
        Fri, 7 Jan 2022 09:54:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3de4xgct3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 09:54:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2079sOmP44368218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jan 2022 09:54:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9265B11C04C;
        Fri,  7 Jan 2022 09:54:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 255A111C050;
        Fri,  7 Jan 2022 09:54:24 +0000 (GMT)
Received: from [9.145.27.136] (unknown [9.145.27.136])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jan 2022 09:54:24 +0000 (GMT)
Message-ID: <ed37164f-74b1-de58-8308-4a11ea352faa@linux.ibm.com>
Date:   Fri, 7 Jan 2022 10:54:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net v2 1/2] net/smc: Resolve the race between link
 group access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
 <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
 <0a972bf8-1d7b-a211-2c11-50e86c87700e@linux.alibaba.com>
 <4df6c3c1-7d52-6bfa-9b0d-365de5332c06@linux.ibm.com>
 <095c6e45-dd9e-1809-ae51-224679783241@linux.alibaba.com>
 <1cf77005-1825-0d34-6d34-e1b513c28113@linux.ibm.com>
 <747c3399-4e6f-0353-95bf-6b6f3a0f5f60@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <747c3399-4e6f-0353-95bf-6b6f3a0f5f60@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HGC5T7kzdwfc6PxtRwMDCpgBrMvzg27r
X-Proofpoint-ORIG-GUID: ldC3e0SUjeuOkS4n9fU1amkxicM9Yumk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_03,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 14:02, Wen Gu wrote:
> Thanks for your reply.
> 
> On 2022/1/5 8:03 pm, Karsten Graul wrote:
>> On 05/01/2022 09:27, Wen Gu wrote:
>>> On 2022/1/3 6:36 pm, Karsten Graul wrote:
>>>> On 31/12/2021 10:44, Wen Gu wrote:
>>>>> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>>>>>> On 28/12/2021 16:13, Wen Gu wrote:
>>>>>>> We encountered some crashes caused by the race between the access
>>>>>>> and the termination of link groups.
> So I am trying this way:
> 
> 1) Introduce a new helper smc_conn_lgr_state() to check the three stages mentioned above.
> 
>   enum smc_conn_lgr_state {
>          SMC_CONN_LGR_ORPHAN,    /* conn was never registered in a link group */
>          SMC_CONN_LGR_VALID,     /* conn is registered in a link group now */
>          SMC_CONN_LGR_INVALID,   /* conn was registered in a link group, but now
>                                     is unregistered from it and conn->lgr should
>                                     not be used any more */
>   };
> 
> 2) replace the current conn->lgr check with the new helper.
> 
> These new changes are under testing now.
> 
> What do you think about it? :)

Sounds good, but is it really needed to separate 3 cases, i.e. who is really using them 3?
Doesn't it come down to a more simple smc_conn_lgr_valid() which is easier to implement in
the various places in the code? (i.e.: if (smc_conn_lgr_valid()) ....)
Valid would mean conn->lgr != NULL and conn->alert_token_local != 0. The more special cases
would check what they want by there own.
