Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34D14B2603
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345778AbiBKMl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:41:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiBKMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:41:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAED1A4;
        Fri, 11 Feb 2022 04:41:24 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BBbgMH008491;
        Fri, 11 Feb 2022 12:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=IQI4jbcVt+/HaAE3h3QXWy2FSICn114AKVLtkz3T/g0=;
 b=Mbw5lsDkifLOfPTXMwkabldpwsDTy8bBn6P35LoKEQZZmuQrR2dBXzD7aJeGC9oWB5KR
 bx8uSQkqjbfSwTiuA2VBhM29OQ60tVZ9ZL1mRlX5+edsR+2x3mVyM4I1F3HG5Oq4azZZ
 RENkjqTZqVk/+BfHxMdOjAYw2ZRKF++zmgd0HobNb+fIKyYIOYK0bonf8EXmSXc6x9sO
 AxlucwF5J6IVre4QI9hW8tEN2lw38/XYJsGRoYY0bsOOXV9xfClXmhqdFV0EJFTTamZZ
 hqkt4tuIUNQjex0ZmzYi/InKkM62NzpLy3W1MZRtdSLIjMs91vBU1UqcET21O0RTtVqR HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5kv9d9tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 12:41:03 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BBofQ6018600;
        Fri, 11 Feb 2022 12:41:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5kv9d9td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 12:41:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BCW7ge030327;
        Fri, 11 Feb 2022 12:41:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggkssxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 12:40:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BCevRg45613520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 12:40:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B453952063;
        Fri, 11 Feb 2022 12:40:57 +0000 (GMT)
Received: from sig-9-65-69-128.ibm.com (unknown [9.65.69.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E914452054;
        Fri, 11 Feb 2022 12:40:55 +0000 (GMT)
Message-ID: <f9ccc9be6cc084e9cab6cd75e87735492d120002.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Calculate digest in ima_inode_hash() if not
 available
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>
Date:   Fri, 11 Feb 2022 07:40:53 -0500
In-Reply-To: <20220211104828.4061334-1-roberto.sassu@huawei.com>
References: <20220211104828.4061334-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TYOclR8mQBqCcCU7NdmU84gax4coSzVM
X-Proofpoint-ORIG-GUID: 0dqSDJD0UBk4RT2prQgBOJMS68YN05J3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_04,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roberto,

On Fri, 2022-02-11 at 11:48 +0100, Roberto Sassu wrote:
> __ima_inode_hash() checks if a digest has been already calculated by
> looking for the integrity_iint_cache structure associated to the passed
> inode.
> 
> Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
> interested in obtaining the information without having to setup an IMA
> policy so that the digest is always available at the time they call one of
> those functions.

Things obviously changed, but the original use case for this interface,
as I recall, was a quick way to determine if a file had been accessed
on the system.

-- 
thanks,

Mimi

