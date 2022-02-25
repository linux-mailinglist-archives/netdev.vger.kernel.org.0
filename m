Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9914C45E9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbiBYNUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiBYNUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:20:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAD027C224;
        Fri, 25 Feb 2022 05:19:30 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PBMjR4029361;
        Fri, 25 Feb 2022 13:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : date : message-id : mime-version :
 content-type; s=pp1; bh=O0Xj/BZppjXxOPhFAwSiE1XvJJ1R4pVra9+KEFRoASw=;
 b=Bb+YRQU8R3upuPRzTD/K0HDKveVdRoVOz5kTjosFF0juuB8CML+A0Fcq6kbF9DKuAL1q
 4syLg8JJbpQNH7BMIIXt7Cpu36ru8BIoKEDcHqD9xoP6K4IMki0qJvKzWKLDINO6Oxax
 Ejc9tdiertBY5W3+IRjqZqjq6RTWJre324KpUmLPSNVOKuSw/OCE/Tcq/6pL1J7246EE
 nj2MatvpYokE4PfDYbVvMSKOMtkVMA47joK454TBPUD0KuUWIhoYN8REUOpqgm7y3FdL
 fPiGPf49xIBLaHmWse0JUPHoO+9gImKQmkQ9jeYMhnggfUGU0mKugdw89LMQg2P7HEaC Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkfe46p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:19:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21PCu0LD011047;
        Fri, 25 Feb 2022 13:19:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkfe459-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:19:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PD8PQ2025194;
        Fri, 25 Feb 2022 13:19:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69xan9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:19:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PD8MGm50987422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 13:08:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80BEBA4060;
        Fri, 25 Feb 2022 13:19:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EF54A405C;
        Fri, 25 Feb 2022 13:19:06 +0000 (GMT)
Received: from localhost (unknown [9.171.60.182])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 13:19:06 +0000 (GMT)
From:   Alexander Egorenkov <egorenar@linux.ibm.com>
To:     jolsa@redhat.com
Cc:     andrii.nakryiko@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
In-Reply-To: <YY4WfQrExICZ6jI+@krava>
In-Reply-To: 
Date:   Fri, 25 Feb 2022 14:19:06 +0100
Message-ID: <878rtz84ol.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hO5DsCw_CV9bRmbYLBIxBlnVtT46M5h9
X-Proofpoint-ORIG-GUID: M-JtoAGusO7akDLuUd2RjsVppHkAx3kb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_07,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=572 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jiri and Andrii,

we also have discovered this problem recently on Fedora 35 and linux-next.
Is there any status update here ?

@Jiri
Is the increase of total kernel modules size by 20MB really a big deal
on s390x ? We would like to have it enabled on our architecture
again ;-) And 20MB seems okay or am i missing something maybe ?

Another question i have wrt to BTF is why is it necessary to have e.g.
_struct module_ be present within kernel module BTF if it is already
present within vmlinux's one ? Can't the one from vmlinux be reused for
kernel modules as well, they should be identical, right ?

Thanks
Regards
Alex
