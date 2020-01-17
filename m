Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8971403C3
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAQGIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:08:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34086 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgAQGIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 01:08:11 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H65Fh0014424
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=7Dw7HIpmKvtHofKmBr8afkFIByJRi7dgdSnP8XhdMm4=;
 b=rpkz3eON2N0Kbk8S/GnuFbs8L61qvbcbB2iAv8rwH+kjC0aOI0wT3CDI1fqvpg6Unxv6
 0MraDjNRAxpydKXzBjoJCuaAeod2d7H698dytwc2iYxSAhV9NhuxB15k4lToXZ9h4589
 ytZOz/Tgq7aHXqbPvQf4tgFOaFrpo/89mBA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0s5sbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 22:08:10 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 16 Jan 2020 22:08:09 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C2C3B2EC1745; Thu, 16 Jan 2020 22:08:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] Fix few unrelated small bugs and issues
Date:   Thu, 16 Jan 2020 22:07:57 -0800
Message-ID: <20200117060801.1311525-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_06:2020-01-16,2020-01-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0
 malwarescore=0 mlxlogscore=597 suspectscore=8 bulkscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001170047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix few unrelated issues, found by static analysis tools (performed against
libbpf's Github repo). Also fix compilation warning in bpftool polluting
selftests Makefile output.

Andrii Nakryiko (4):
  libbpf: fix error handling bug in btf_dump__new
  libbpf: simplify BTF initialization logic
  libbpf: fix potential multiplication overflow in mmap() size
    calculation
  bpftool: avoid const discard compilation warning

 tools/bpf/bpftool/jit_disasm.c |  2 +-
 tools/lib/bpf/btf_dump.c       |  1 +
 tools/lib/bpf/libbpf.c         | 21 +++++++--------------
 3 files changed, 9 insertions(+), 15 deletions(-)

-- 
2.17.1

