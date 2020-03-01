Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6825E174C38
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCAILS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:11:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgCAILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:11:18 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0218BHoP031446
        for <netdev@vger.kernel.org>; Sun, 1 Mar 2020 00:11:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=gDqq8IiNOxV1qEwKOcVq+A4uVyewA40yjvZXoIJKIXI=;
 b=UP9fN1O8xPKm90V+Oqt2U85kFZDvg27MMnwFfj2PhSriLKhDSnOLqFaVvQs14adK5W5U
 h6s6vfHGAy3iGlRIAuVJjbMku8zpf0ysGqbTh99aN/3pPAhI73C4X1poTzuo4ZDZ/W0e
 7w1yIA0bt/Mteze1cQv2CuUUoA1C3kAmPu4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8du043f-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:11:17 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 00:10:58 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EAEBD2EC2D1F; Sun,  1 Mar 2020 00:10:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] Improve raw tracepoint BTF types preservation
Date:   Sun, 1 Mar 2020 00:10:42 -0800
Message-ID: <20200301081045.3491005-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_02:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=8 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=546 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix issue with not preserving btf_trace_##call structs when compiled under
Clang. Additionally, capture raw tracepoint arguments in raw_tp_##call
structs, directly usable from BPF programs. Convert runqslower to use those
for proof of concept and to simplify code further.

Andrii Nakryiko (3):
  bpf: reliably preserve btf_trace_xxx types
  bpf: generate directly-usable raw_tp_##call structs for raw
    tracepoints
  tools/runqslower: simplify BPF code by using raw_tp_xxx structs

 include/trace/bpf_probe.h             | 37 ++++++++++++++++++++++-----
 tools/bpf/runqslower/runqslower.bpf.c | 22 ++++++----------
 2 files changed, 38 insertions(+), 21 deletions(-)

-- 
2.17.1

