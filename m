Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88514537EF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhKPQpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhKPQpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:45:23 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FAC061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:26 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id o63so7930521qkb.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9z6tFBkilIaxV9Jmaeq7gD/a38IoGg/eCee0g8ti+nY=;
        b=IangSLnazX1MvIVpSmwq6DK+kY/XEsM8FP8SOdUX8m6t2KmF1Kpan6YWt4uVVsDWpa
         E9qFtmkfRWXd6NsWvEb0zJsckaRHn6DXCN+m5nMp1U6xln8ysFm1n9KBTVFjytwf0BGV
         GCQ/UZrAtCQ0uCK8V5vldM1BwU7Cmx65aUaU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9z6tFBkilIaxV9Jmaeq7gD/a38IoGg/eCee0g8ti+nY=;
        b=0gFZ/BgimnLmowHqMHQWeDpqja/bvWtqMb/V3o1vzvCAC5dJ6ZqhFBo8qS+iEmLc4O
         J95lYspSN0M4JxH6mk8xykA9QNWsVDtMkejhYQtpAiGRGpvuXE2yyCNF2cGNOvVxzQ8g
         hfeQQpUec9Dj+OKcdUXWmLvDuZkP/5JvCOinyKU7x/WsW8aaB0ZpFXzb7y2uHWu2Arjw
         S4pLutGrNcP95D4OL+Jn6+f4kYYaNJtbBvwf3WdVkkHyeaqMQrTYxcGkJmupWhEawVAL
         0VtCqSCSCfp1v7n1hH1xVJ+vDd8IRI3QsPuxH2oRhk/pBb6A1hAAYL/kCs3XY2SzqmUr
         1/1Q==
X-Gm-Message-State: AOAM532a2dv0my6Dx91z6OQjkcU6mqHk2yJGqZ0roYyUcySyhk1KUjjO
        SJNDelpDLTHINT+4i96F1MSlciwq7sgQp+1RZsB1mcb+RgOydwtsu6nyWfnOj8duGzqO3MJ0wG/
        WZNbfCMebUjQhmGYHXtfC7v0KTsTqeIVE9McxRNZplfDuK9uCcGnlOpSX/aRALyO+l0nvT5EJ
X-Google-Smtp-Source: ABdhPJw+XogMvo9hNO9/V/eImrEi681sVfk+fFWPz8m7AFzTopv8eKvLoT2R4ETRyS3JquoFHRq7IA==
X-Received: by 2002:a05:620a:d96:: with SMTP id q22mr7457709qkl.219.1637080942689;
        Tue, 16 Nov 2021 08:42:22 -0800 (PST)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id bk18sm7309121qkb.35.2021.11.16.08.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:42:22 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v2 0/4] libbpf: Provide APIs for BTFGen
Date:   Tue, 16 Nov 2021 11:42:04 -0500
Message-Id: <20211116164208.164245-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CO-RE requires to have BTF information describing the types of the
kernel in order to perform the relocations. This is usually provided by
the kernel itself when it's configured with CONFIG_DEBUG_INFO_BTF.
However, this configuration is not enabled in all the distributions and
it's not available on older kernels.

It's possible to use CO-RE in kernels without CONFIG_DEBUG_INFO_BTF
support by providing the BTF information from an external source.
BTFHub[0] contains BTF files to each released kernel not supporting BTF,
for the most popular distributions.

Providing this BTF file for a given kernel has some challenges: 1. Each
BTF file is a few MBs big, then it's not possible to ship the eBPF
program with all the BTF files needed to run in different kernels. (The
BTF files will be in the order of GBs if you want to support a high
number of kernels) 2. Downloading the BTF file for the current kernel at
runtime delays the start of the program and it's not always possible to
reach an external host to download such a file.

Providing the BTF file with the information about all the data types of
the kernel for running an eBPF program is an overkill in many of the
cases. Usually the eBPF programs access only some kernel fields.

This series extends libbpf to provide an API that can be used for this
purpose. The major proposed change is to introduce a new
bpf_object__prepare() method that performs all the preparation steps
without creating the maps nor loading the programs.

This idea was discussed during the "Towards truly portable eBPF"[1]
presentation at Linux Plumbers 2021.

We prepared a BTFGen repository[2] with an example of how this API can
be used. Our plan is to include this support in bpftool once it's merged
in libbpf.

There is also a good example[3] on how to use BTFGen and BTFHub together
to generate multiple BTF files, to each existing/supported kernel,
tailored to one application. For example: a complex bpf object might
support nearly 400 kernels by having BTF files summing only 1.5 MB.

[0]: https://github.com/aquasecurity/btfhub/
[1]: https://www.youtube.com/watch?v=igJLKyP1lFk&t=2418s
[2]: https://github.com/kinvolk/btfgen
[3]: https://github.com/aquasecurity/btfhub/tree/main/tools

Changelog:

v1 > v2:
- introduce bpf_object__prepare() and ‘record_core_relos’ to expose
  CO-RE relocations instead of bpf_object__reloc_info_gen()
- rename btf__save_to_file() to btf__raw_data()

v1: https://lore.kernel.org/bpf/20211027203727.208847-1-mauricio@kinvolk.io/

Mauricio Vásquez (4):
  libbpf: Implement btf__save_raw()
  libbpf: Introduce 'btf_custom' to 'bpf_obj_open_opts'
  libbpf: Introduce 'bpf_object__prepare()'
  libbpf: Expose CO-RE relocation results

 tools/lib/bpf/btf.c       |  30 ++++++
 tools/lib/bpf/btf.h       |   2 +
 tools/lib/bpf/libbpf.c    | 213 +++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h    |  58 ++++++++++-
 tools/lib/bpf/libbpf.map  |   4 +
 tools/lib/bpf/relo_core.c |  28 ++++-
 tools/lib/bpf/relo_core.h |  21 +---
 7 files changed, 294 insertions(+), 62 deletions(-)

-- 
2.25.1

