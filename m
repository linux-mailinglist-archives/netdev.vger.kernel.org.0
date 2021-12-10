Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99254700E7
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 13:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241234AbhLJMq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 07:46:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50418 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbhLJMqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 07:46:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7969CE2AB7;
        Fri, 10 Dec 2021 12:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EE1C00446;
        Fri, 10 Dec 2021 12:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639140195;
        bh=A4ChL5ppUoru6F95qxeChFGwc/PORJ8tiZlI5EpfhY8=;
        h=From:To:Cc:Subject:Date:From;
        b=kxW15yDviO53HrXLuueLGBt2hMS1/l0qikBUyYGxZ/Nc/xH4MmEel5774L1LaEYe5
         Cr2j1F9Ews4jCiuPEcH2OC+iv+tmXKm1cLnXozxLbPBrE5UTrZ/O+oxSVP42Jh6hR6
         FW3O6pxhupAVcR6JGaTYarCbAy65rFMpIkgTy0NuHpOrcphPi8m5WKQ+XjwZ5j1bQa
         ELEvtHDJclMLMROG5u2k3erljPT7I4/j3ZZBnlGigKudLO18P+nzwCIr52aqXQqhCR
         jax3+DnFHQt2WsCS8Bvic7PeuGaVuBfugOwVdZl+r9G0bbaBNSRjBaKgoF2mhftzYf
         voybWZtUDZ8Sg==
From:   broonie@kernel.org
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the netdev tree
Date:   Fri, 10 Dec 2021 12:43:08 +0000
Message-Id: <20211210124308.2030434-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/libbpf.c

between commit:

  ba05fd36b8512 ("libbpf: Perform map fd cleanup for gen_loader in case of error")

from the netdev tree and commit:

  fa5e5cc04e443 ("libbpf: Deprecate bpf_object__load_xattr()")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc tools/lib/bpf/libbpf.c
index f6faa33c80fa7,18d95c6a89fe3..0000000000000
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@@ -7263,7 -7475,7 +7475,7 @@@ static int bpf_object_load(struct bpf_o
  	}
  
  	if (obj->gen_loader)
- 		bpf_gen__init(obj->gen_loader, attr->log_level, obj->nr_programs, obj->nr_maps);
 -		bpf_gen__init(obj->gen_loader, extra_log_level);
++		bpf_gen__init(obj->gen_loader, extra_log_level, obj->nr_programs, obj->nr_maps);
  
  	err = bpf_object__probe_loading(obj);
  	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
