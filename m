Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235144D18CA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbiCHNMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346781AbiCHNMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:13 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3A948888;
        Tue,  8 Mar 2022 05:11:13 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t5so17307999pfg.4;
        Tue, 08 Mar 2022 05:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FWHoEDvTIm7rBvwEUghaQtZQ/73G/plTVtfrSbmEWvI=;
        b=aO8AWuyBW+FGjwJNfokItf5Bd00b1q7qnTiFFonK1BjqfezPqKbnHa/jMJGN6MmxoZ
         dHoZKF4paoTNGOFL2G0ZJ3cuHNIxCQ2vY56aRHxEp2tUEMXLENWUihR/qm0Vt8gpoD/L
         Zzi2dYgMJZU9kvFL0gG3Z2Df9zPsxkJ/1LQSAK4wzqf3aROKmBPWXo/56ouxOei4JSrK
         +Dc82qJYFY8//Xe1JOld+9gyi2x6eynJSFtc6mNvj0Ilnpsmy6Kt9V6KDhOtBSeIS8bW
         sSUajbIxZ8zpTcaqPBqgnoN11yNnIymT5esT4tylEKEa9KOeo+aydJpT3HNI17Dl9cZf
         Tk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FWHoEDvTIm7rBvwEUghaQtZQ/73G/plTVtfrSbmEWvI=;
        b=IkKHETLIV50jFkZaaATISEPxb/dKSNUsyhBh14a4fhb0h5MaLyzjRSuhND6oLV+mLL
         sS43v6M8ymu8MbvkmYaCDFqO6M8+iEq+pbfqzuFIEfd7hlhOSgWFXedOswi59yK+oEdg
         7+CGFYzgZ1QND2UIt2Im5hzx/zpKHc/NyuRrrx/ULBhrRYQdfYfyyjy8PG7rMUs5DM3g
         1UcZeA4a6XQOgbgtrhxTJg6i3PS75QcpecMtA/ytOopKW5VD8hCKB3hRCy7fuTqCe0cJ
         K610VZvqPsw60DE2Io9pLc8NFBOSfJbzj99mbfT6fSlDXce0otrU/VCXkuwLuTAjaZij
         oGkw==
X-Gm-Message-State: AOAM533vfaClyaJdO3gb+/ht6tudcc2QYO1hpfgXokcm2EQx7fVfxat3
        ua5Mr/UUVrC19Xh8Mn7V+VM=
X-Google-Smtp-Source: ABdhPJwyIRTWrPyxTPT7YsRSDCDgLumfxmx4Mzp5VoY99Hl0IQKI/wf0l5ZJBc2Yls/RuUFicBLz2g==
X-Received: by 2002:a63:6942:0:b0:380:153e:63f9 with SMTP id e63-20020a636942000000b00380153e63f9mr11962961pgc.212.1646745073125;
        Tue, 08 Mar 2022 05:11:13 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:12 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 0/9] bpf, mm: recharge bpf memory from offline memcg
Date:   Tue,  8 Mar 2022 13:10:47 +0000
Message-Id: <20220308131056.6732-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we use memcg to limit the containers which load bpf progs and maps,
we find there is an issue that the lifecycle of container and bpf are not
always the same, because we may pin the maps and progs while update the
container only. So once the container which has alreay pinned progs and
maps is restarted, the pinned progs and maps are no longer charged to it
any more. In other words, this kind of container can steal memory from the
host, that is not expected by us. This patchset means to resolve this
issue.

After the container is restarted, the old memcg which is charged by the
pinned progs and maps will be offline but won't be freed until all of the
related maps and progs are freed. If we want to charge these bpf memory to
the new started memcg, we should uncharge them from the offline memcg first
and then charge it to the new one. As we have already known how the bpf
memroy is allocated and freed, we can also know how to charge and uncharge
it. This pathset implements various charge and uncharge methords for these
memory.

Regarding how to do the recharge, we decide to implement new bpf syscalls
to do it. With the new implemented bpf syscall, the agent running in the
container can use it to do the recharge. As of now we only implement it for
the bpf hash maps. Below is a simple example how to do the recharge,

====
int main(int argc, char *argv[])
{
	union bpf_attr attr = {};
	int map_id;
	int pfd;

	if (argc < 2) {
		printf("Pls. give a map id \n");
		exit(-1);
	}

	map_id = atoi(argv[1]);
	attr.map_id = map_id;
	pfd = syscall(SYS_bpf, BPF_MAP_RECHARGE, &attr, sizeof(attr));
	if (pfd < 0)
		perror("BPF_MAP_RECHARGE");

	return 0;
}

====

Patch #1 and #2 is for the observability, with which we can easily check
whether the bpf maps is charged to a memcg and whether the memcg is offline.
Patch #3, #4 and #5 is for the charge and uncharge methord for vmalloc-ed,
kmalloc-ed and percpu memory.
Patch #6~#9 implements the recharge of bpf hash map, which is mostly used
by our bpf services. The other maps hasn't been implemented yet. The bpf progs
hasn't been implemented neither.

This pathset is still a POC now, with limited testing. Any feedback is
welcomed.

Yafang Shao (9):
  bpftool: fix print error when show bpf man
  bpftool: show memcg info of bpf map
  mm: add methord to charge kmalloc-ed address
  mm: add methord to charge vmalloc-ed address
  mm: add methord to charge percpu address
  bpf: add a helper to find map by id
  bpf: add BPF_MAP_RECHARGE syscall
  bpf: make bpf_map_{save, release}_memcg public
  bpf: support recharge for hash map

 include/linux/bpf.h            | 23 +++++++++++++
 include/linux/percpu.h         |  1 +
 include/linux/slab.h           |  2 ++
 include/linux/vmalloc.h        |  1 +
 include/uapi/linux/bpf.h       | 10 ++++++
 kernel/bpf/hashtab.c           | 35 ++++++++++++++++++++
 kernel/bpf/syscall.c           | 73 ++++++++++++++++++++++++++----------------
 mm/percpu.c                    | 50 +++++++++++++++++++++++++++++
 mm/slab.c                      |  6 ++++
 mm/slob.c                      |  6 ++++
 mm/slub.c                      | 32 ++++++++++++++++++
 mm/util.c                      |  9 ++++++
 mm/vmalloc.c                   | 29 +++++++++++++++++
 tools/bpf/bpftool/map.c        |  9 +++---
 tools/include/uapi/linux/bpf.h |  1 +
 15 files changed, 254 insertions(+), 33 deletions(-)

-- 
1.8.3.1

