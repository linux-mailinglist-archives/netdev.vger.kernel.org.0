Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1217C3DBECE
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhG3TLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:11:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhG3TL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:11:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UJ4XvQ155898;
        Fri, 30 Jul 2021 15:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aCvQ/zlOFEmWQJR05jB5BMz1wTvrloq8ZnJNoFyxCgA=;
 b=V/SnNDT/aGi/sMiEOokM2ekMamcQy0RLeeIiVZMZFrWO4O48mozPYBmM7QceGF/kMjoF
 DMRH1CMMcD1prddxzZSc2osDyLb2koTOn63pL/bJHCC0NVbvu0GjZucRAbi3VY1jzgiX
 k2U0vlOBcuDq7xKB9HtUvSgt0ZeERnZYsi6MQ2f4pcAiBtvZfadmwm7p9jG4aoLhWf+s
 r61lhWE5Pm+dFsZBkjM2lLXem1NOgsRbAguI2TxxRxHJhsgAE0TBuURSwD9idolC0zj1
 YudaNTxlJCF4XJhOzk7/sNz3XehoVufKcyPnDECxYOXBiam7FZWRehMBo9IHIwCK0wAb Jw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a4pnc953r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 15:11:09 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16UJ7IfF029591;
        Fri, 30 Jul 2021 19:11:08 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 3a235rncgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 19:11:08 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16UJB7a410879584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 19:11:07 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8D352806A;
        Fri, 30 Jul 2021 19:11:06 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5186A28067;
        Fri, 30 Jul 2021 19:11:03 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.21.31])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jul 2021 19:11:03 +0000 (GMT)
Subject: Re: [PATCH 36/64] scsi: ibmvscsi: Avoid multi-field memset() overflow
 by aiming at srp
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Brian King <brking@linux.vnet.ibm.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-37-keescook@chromium.org>
 <yq135rzp79c.fsf@ca-mkp.ca.oracle.com> <202107281152.515A3BA@keescook>
 <yq1k0l9oktw.fsf@ca-mkp.ca.oracle.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <3ffbcf75-166e-5802-1d8e-9c7739961b80@linux.ibm.com>
Date:   Fri, 30 Jul 2021 12:11:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <yq1k0l9oktw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FY4mG5iTa3n7SX9d8VHWXVbFzyl_6wEi
X-Proofpoint-GUID: FY4mG5iTa3n7SX9d8VHWXVbFzyl_6wEi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_11:2021-07-30,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 8:35 PM, Martin K. Petersen wrote:
> 
> Kees,
> 
>> For example, change it to:
>>
>> +	BUILD_BUG_ON(sizeof(evt_struct->iu.srp) != SRP_MAX_IU_LEN);
>> +	memset(&evt_struct->iu.srp, 0x00, sizeof(evt_struct->iu.srp));
>>  	srp_cmd = &evt_struct->iu.srp.cmd;
>> -	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
> 
>> For the moment, I'll leave the patch as-is unless you prefer having
>> the BUILD_BUG_ON(). :)
> 
> I'm OK with the BUILD_BUG_ON(). Hopefully Tyrel or Brian will chime in.
> 

All the other srp structs are at most 64 bytes and the size of the union is
explicitly set to SRP_MAX_IU_LEN by the last field of the union.

union srp_iu {
        struct srp_login_req login_req;
        struct srp_login_rsp login_rsp;
        struct srp_login_rej login_rej;
        struct srp_i_logout i_logout;
        struct srp_t_logout t_logout;
        struct srp_tsk_mgmt tsk_mgmt;
        struct srp_cmd cmd;
        struct srp_rsp rsp;
        u8 reserved[SRP_MAX_IU_LEN];
};

So, in my mind if SRP_MAX_IU_LEN ever changes so does the size of the union
making the BUILD_BUG_ON() superfluous. But it doesn't really hurt anything either.

-Tyrel
