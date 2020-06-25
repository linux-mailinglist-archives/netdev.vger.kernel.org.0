Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC520A8D4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407826AbgFYX0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:26:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57436 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407818AbgFYX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:26:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05PNPE7b001179
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xHvaJCjS5W4fLW1ZiRlnErBKkcBhTdM0kQ+/ka3syqk=;
 b=pWUBgyv7wm4Ohp+VHcsxsYe3oNI5eBPMRdp+U4Do7/lNXAQy3VMbtSeZPW8JRihUp46J
 /nk5lzsi6J7JEDi2KHeFNGLLoEWs6xXWeY9wSsaO1VeNq21XinIcuD/7Q3NE2rJGExkI
 B+riKRfLNdlrPZWwH0yk1KMMBghgsSncjQM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31ux0ntp74-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:45 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 16:26:43 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7EDA72EC3954; Thu, 25 Jun 2020 16:26:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] Support disabling auto-loading of BPF programs
Date:   Thu, 25 Jun 2020 16:26:27 -0700
Message-ID: <20200625232629.3444003-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=8
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to turn off default auto-loading of each BPF program by libbp=
f on
BPF object load. This is the feature that allows BPF applications to have
optional functionality, which is only excercised on kernel that support
necessary features, while falling back to reduced/less performant
functionality, if kernel is outdated.

Andrii Nakryiko (2):
  libbpf: support disabling auto-loading BPF programs
  selftests/bpf: test auto-load disabling logic for BPF programs

 tools/lib/bpf/libbpf.c                        | 48 +++++++++++++++----
 tools/lib/bpf/libbpf.h                        |  2 +
 tools/lib/bpf/libbpf.map                      |  2 +
 .../selftests/bpf/prog_tests/autoload.c       | 41 ++++++++++++++++
 .../selftests/bpf/progs/test_autoload.c       | 40 ++++++++++++++++
 5 files changed, 125 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/autoload.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoload.c

--=20
2.24.1

