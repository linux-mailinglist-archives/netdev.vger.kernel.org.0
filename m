Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7822F1DD6FD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgEUTSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:18:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729635AbgEUTSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:18:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04LJHx3N028659
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Cb1UKooagn9zP1mrguDUeh5/m57ACxTgzJRzYxsIky4=;
 b=qo4qhnOpxqNrkGFPqNtJ5HLwuRl0vcnK3K1i8VrPlhoOynXwH13xtCgqmXZlkFtRp0Ru
 wNwTIrOGhkd97e6B+iRUN5pjtJzvWeMeft6AgtefeWp/U7QnQaA2s3U7MdUliH8PDLfZ
 JOYqyVq4xFWKTWHFi9mAaYiy8As56Dcm5fA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 314rt7n5wr-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:06 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 12:17:58 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3C3CA2942F51; Thu, 21 May 2020 12:17:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] bpf: Allow inner map with different max_entries
Date:   Thu, 21 May 2020 12:17:52 -0700
Message-ID: <20200521191752.3448223-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_13:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=13 adultscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 cotscore=-2147483648 bulkscore=0 phishscore=0 mlxlogscore=342
 priorityscore=1501 impostorscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows the outer map to be updated with inner map in differen=
t
size as long as it is safe (meaning the max_entries is not used in the
verification time during prog load).

Please see individual patch for details.

Martin KaFai Lau (3):
  bpf: Clean up inner map type check
  bpf: Relax the max_entries check for inner map
  bpf: selftests: Add test for different inner map size

 include/linux/bpf.h                           | 18 +++++-
 include/linux/bpf_types.h                     | 64 +++++++++++--------
 kernel/bpf/btf.c                              |  2 +-
 kernel/bpf/map_in_map.c                       | 12 ++--
 kernel/bpf/syscall.c                          | 19 +++++-
 kernel/bpf/verifier.c                         |  2 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 12 ++++
 .../selftests/bpf/progs/test_btf_map_in_map.c | 31 +++++++++
 8 files changed, 119 insertions(+), 41 deletions(-)

--=20
2.24.1

