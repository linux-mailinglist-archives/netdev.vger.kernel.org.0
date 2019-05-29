Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B5D2E34B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfE2RgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfE2RgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:21 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THUsrC016360
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=cFdJCDsVELP51hI3OrD+oN9w24KRmvn1saUNINRAcvc=;
 b=rTpaQKOaU/fNczZII70YZxMdjh7DOCHs3NYWl9j8q/Jhe1OfpqSNhFibcwWC355Dno7b
 yunQpo6a5eQNAtSOf6Go7vgNCoHc1kOCSwNf+1J47YcmChCm/c29vQ5tMiyTRYF++Ole
 J5uc+6rWbf3E9pBR3jUZZ8kENTJIgHcNoPw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ssrf51btt-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:20 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 862BB8617AE; Wed, 29 May 2019 10:36:15 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/9] libbpf random fixes
Date:   Wed, 29 May 2019 10:36:02 -0700
Message-ID: <20190529173611.4012579-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a collection of unrelated fixes for libbpf.

Patch #1 fixes detection of corrupted BPF section w/ instructions.
Patch #2 fixes possible errno clobbering.
Patch #3 simplifies endianness check and brings it in line with few other
similar checks in libbpf.
Patch #4 adds check for failed map name retrieval from ELF symbol name.
Patch #5 fixes return error code to be negative.
Patch #6 fixes using valid fd (0) as a marker of missing associated BTF.
Patch #7 removes redundant logic in two places.
Patch #8 fixes typos in comments and debug output, and fixes formatting.
Patch #9 unwraps a bunch of multi-line statements and comments.

v1->v2:
  - patch #1 simplifications (Song);


Andrii Nakryiko (9):
  libbpf: fix detection of corrupted BPF instructions section
  libbpf: preserve errno before calling into user callback
  libbpf: simplify endianness check
  libbpf: check map name retrieved from ELF
  libbpf: fix error code returned on corrupted ELF
  libbpf: use negative fd to specify missing BTF
  libbpf: simplify two pieces of logic
  libbpf: typo and formatting fixes
  libbpf: reduce unnecessary line wrapping

 tools/lib/bpf/libbpf.c | 148 +++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 88 deletions(-)

-- 
2.17.1

