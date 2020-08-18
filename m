Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2D248B77
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHRQYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:24:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49488 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbgHRQYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:24:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IGNP3S032283
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 09:24:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=WNlC6NtHElyUgrXwifo9sCuDjF4s4+LzDLnlnV7krG0=;
 b=ClKmrYRU5n9Moz39kWOneEy9BrD1/lGOEFrTZKeHE4vSKv77Uu8wk4o/U5bK7hooK5nT
 NFNEajRK4pw/nNPl/KuLfGVgkFPNPfi1rsWuSi9vPFtzzWLTUqXTfnUuzSJKmnK+c4DC
 cM+Ktl2/Rw2LCncG0QH764EhaXKj70Pb10s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m2ukxe-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 09:24:14 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 09:24:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 3E28E37036A5; Tue, 18 Aug 2020 09:24:08 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/2] bpf: two fixes for bpf task/task_file iterators
Date:   Tue, 18 Aug 2020 09:24:08 -0700
Message-ID: <20200818162408.836759-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_11:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=630
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=8 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 fixed a rcu stall warning by adding proper cond_resched()
when traversing tasks or files.
Patch #2 calculated tid properly in a namespace in order to avoid
visiting the name task multiple times.

Yonghong Song (2):
  bpf: fix a rcu_sched stall issue with bpf task/task_file iterator
  bpf: avoid visit same object multiple times

 kernel/bpf/task_iter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--=20
2.24.1

