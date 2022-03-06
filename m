Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574A44CED65
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiCFTZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiCFTZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:25:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3138B5EDCA;
        Sun,  6 Mar 2022 11:24:15 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 226G8jEd026732;
        Sun, 6 Mar 2022 19:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yK6yImf+LY3PKU0v0egUsCHeo9laqIvYgs8qyhpQEag=;
 b=qBPxMEwwJDXewUHGk4MGFzBzU8CBiN36wVRmOfkcttglV8u4o8GvmvMpxYvoAN9yPZBu
 Tu0V34SEI1g2UUp1lIOmMTpoctlVwUfGSfQCxE60+rwh99shJZHdqPIVUmkOPysluyf6
 iceuJlNBtKbAp6l4UOrJWDEEKsvbUuvCOob0Ht56gF4ItjQHtgg/3ZjLH3cLWdATfRtP
 CjZzKavjqc/OH9tw2TyAWYfuFTzHOfKxJh7rUu84je9EweUHGLG+7CsoaF8kAUXZ/UKp
 udH0p/mI9oDkcEfBs8AgbSrpg+7IljMGWVOG8d3XNJQmIaUxKM3/35VQ9bZtYzJ9glI+ tA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3emsrppav0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:23:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 226JMvXJ002565;
        Sun, 6 Mar 2022 19:23:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4hu02w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 19:23:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 226JNjk440763702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Mar 2022 19:23:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B80AA405B;
        Sun,  6 Mar 2022 19:23:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 516B0A4054;
        Sun,  6 Mar 2022 19:23:43 +0000 (GMT)
Received: from sig-9-65-93-47.ibm.com (unknown [9.65.93.47])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  6 Mar 2022 19:23:43 +0000 (GMT)
Message-ID: <9be81980b1849dc60b46ad0672b667b6b5365f2d.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, revest@chromium.org,
        gregkh@linuxfoundation.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 06 Mar 2022 14:23:37 -0500
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P6H_cC6AwowzT6ZB2WlOgHytX7uNbX4F
X-Proofpoint-GUID: P6H_cC6AwowzT6ZB2WlOgHytX7uNbX4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=803 mlxscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203060130
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-02 at 12:13 +0100, Roberto Sassu wrote:
> Extend the interoperability with IMA, to give wider flexibility for the
> implementation of integrity-focused LSMs based on eBPF.
> 
> Patch 1 fixes some style issues.
> 
> Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> measurement capability of IMA without needing to setup a policy in IMA
> (those LSMs might implement the policy capability themselves).
> 
> Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.

The tests seem to only work when neither a builtin IMA policy or a
custom policy is previously loaded.

thanks,

Mimi

