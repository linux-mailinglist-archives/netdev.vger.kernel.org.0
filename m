Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01E820EE0A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgF3GIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:08:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728928AbgF3GH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:07:58 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U62tPF020627
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:07:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=M5svxqH6uhV+FNE/9Q7eNpbXYlHAwQzJOULDSHajGAE=;
 b=fs2b43lX6vAk+5c2B1905qvRhIaNXjlVpAwHzQr5EH1fpYarTNDQGJMVkVaqgH3ibHWt
 Z0t2sVdYarUKBt+gcTQP0D+2TKyCWMGjQPuah+U0wHn7TFLt4T4tYXhm+8awwiCZhT0g
 ui0AbsC2KLkER9fAWWNa7ojb6BMPYvKFEkw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp398eur-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:07:57 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 23:07:50 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 86D4D2EC2E95; Mon, 29 Jun 2020 23:07:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] Make bpf_endian.h compatible with vmlinux.h
Date:   Mon, 29 Jun 2020 23:07:37 -0700
Message-ID: <20200630060739.1722733-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_01:2020-06-30,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 phishscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=8 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=596 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change libbpf's bpf_endian.h header to be compatible when used with syste=
m
headers and when using just vmlinux.h. This is a frequent request for use=
rs
writing BPF CO-RE applications. Do this by re-implementing byte swap
compile-time macros. Also add simple tests validating correct results bot=
h for
byte-swapping built-ins and macros.

Andrii Nakryiko (2):
  libbpf: make bpf_endian co-exist with vmlinux.h
  selftests/bpf: add byte swapping selftest

 tools/lib/bpf/bpf_endian.h                    | 43 ++++++++++++---
 .../testing/selftests/bpf/prog_tests/endian.c | 53 +++++++++++++++++++
 .../testing/selftests/bpf/progs/test_endian.c | 37 +++++++++++++
 3 files changed, 125 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c

--=20
2.24.1

