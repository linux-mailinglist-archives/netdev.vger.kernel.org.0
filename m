Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3D33C1D91
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhGICur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:50:47 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34675 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhGICur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:50:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uf9vV8Z_1625798875;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Uf9vV8Z_1625798875)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 10:48:02 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v3 0/2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
Date:   Fri,  9 Jul 2021 10:47:51 +0800
Message-Id: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: Add 'btf_custom_path' to 'bpf_obj_open_opts', allow developers 
to use custom btf to perform CO-RE relocation.

Patch 2: Fixed the memory leak problem pointed out by Andrii.

Changelog:
----------

v2: https://lore.kernel.org/bpf/CAEf4Bza_ua+tjxdhyy4nZ8Boeo+scipWmr_1xM1pC6N5wyuhAA@mail.gmail.com/T/#mf9cf86ae0ffa96180ac29e4fd12697eb70eccd0f
v2->v3:
--- Load the BTF specified by btf_custom_path to btf_vmlinux_override 
    instead of btf_bmlinux.
--- Fix the memory leak that may be introduced by the second version 
    of the patch.
--- Add a new patch to fix the possible memory leak caused by 
    obj->kconfig.

v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
v1->v2:
-- Change custom_btf_path to btf_custom_path.
-- If the length of btf_custom_path of bpf_obj_open_opts is too long, 
   return ERR_PTR(-ENAMETOOLONG).
-- Add `custom BTF is in addition to vmlinux BTF`
   with btf_custom_path field.

Shuyi Cheng (2):
  libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
  libbpf: Fix the possible memory leak caused by obj->kconfig

 tools/lib/bpf/libbpf.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.h |  6 +++++-
 2 files changed, 53 insertions(+), 5 deletions(-)

-- 
1.8.3.1

