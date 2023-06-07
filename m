Return-Path: <netdev+bounces-9081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9076727147
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CED01C20F68
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909A43B8C6;
	Wed,  7 Jun 2023 22:05:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9D3AE79;
	Wed,  7 Jun 2023 22:05:20 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FE81FF5;
	Wed,  7 Jun 2023 15:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=HDQn7GhrKxRvcDjYng03SxeeUrtT/+oJ8ZCHtGzjJMc=; b=UMJsoNU8ABHPloFXguz1LIPLqO
	STm1YbWqe/n5QsGX9y/IICa4hJSy+NvtjnNxbnDhAhtHwnDcKKK+YDh+PanldGwrNaqn/RQZAqRqv
	HQ/Z8VygYMJE/PcahnZUKFma+s0X3jUwfnrwfZLkaResTk8+6RLXFGzuPD3dI1QKoV2mrYJOpttmU
	fmFznN5qmNJzfnTCLdg83oEM8MlUF393pzhv9zmjS7fr6+GHRssLWthivDT6jD7gSPcWhN2NIWHri
	BbDq+Ap9jUs7Nb53AR2kCgItECWyvfhog5eo4h9Kqgm5R/SlNrCEm6lP4sQaRfjWROPg2OYhZKmM0
	wZ5meWNg==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q71HG-0007yn-LV; Thu, 08 Jun 2023 00:05:14 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: davem@davemloft.net
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	daniel@iogearbox.net,
	ast@kernel.org,
	andrii@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: pull-request: bpf 2023-06-07
Date: Thu,  8 Jun 2023 00:05:14 +0200
Message-Id: <20230607220514.29698-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 7 day(s) which contain
a total of 12 files changed, 112 insertions(+), 7 deletions(-).

The main changes are:

1) Fix a use-after-free in BPF's task local storage, from KP Singh.

2) Make struct path handling more robust in bpf_d_path, from Jiri Olsa.

3) Fix a syzbot NULL-pointer dereference in sockmap, from Eric Dumazet.

4) UAPI fix for BPF_NETFILTER before final kernel ships, from Florian Westphal.

5) Fix map-in-map array_map_gen_lookup code generation where elem_size was
   not being set for inner maps, from Rhys Rustad-Elliott.

6) Fix sockopt_sk selftest's NETLINK_LIST_MEMBERSHIPS assertion, from Yonghong Song.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Anastasios Papagiannis, John Fastabend, Kuba Piecuch, Song Liu, 
Stanislav Fomichev, syzbot, Yonghong Song

----------------------------------------------------------------

The following changes since commit be7f8012a513f5099916ee2da28420156cbb8cf3:

  net: ipa: Use correct value for IPA_STATUS_SIZE (2023-06-01 13:29:18 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to f46fab0e36e611a2389d3843f34658c849b6bd60:

  bpf: Add extra path pointer check to d_path helper (2023-06-07 15:03:43 +0200)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Eric Dumazet (1):
      bpf, sockmap: Avoid potential NULL dereference in sk_psock_verdict_data_ready()

Florian Westphal (1):
      bpf: netfilter: Add BPF_NETFILTER bpf_attach_type

Jiri Olsa (1):
      bpf: Add extra path pointer check to d_path helper

KP Singh (1):
      bpf: Fix UAF in task local storage

Martin KaFai Lau (1):
      Merge branch 'Fix elem_size not being set for inner maps'

Rhys Rustad-Elliott (2):
      bpf: Fix elem_size not being set for inner maps
      selftests/bpf: Add access_inner_map selftest

Yonghong Song (1):
      selftests/bpf: Fix sockopt_sk selftest

 include/uapi/linux/bpf.h                           |  1 +
 kernel/bpf/map_in_map.c                            |  8 +++-
 kernel/bpf/syscall.c                               |  9 +++++
 kernel/fork.c                                      |  2 +-
 kernel/trace/bpf_trace.c                           | 12 +++++-
 net/core/skmsg.c                                   |  3 +-
 tools/include/uapi/linux/bpf.h                     |  1 +
 tools/lib/bpf/libbpf.c                             |  3 +-
 tools/lib/bpf/libbpf_probes.c                      |  2 +
 .../selftests/bpf/prog_tests/inner_array_lookup.c  | 31 +++++++++++++++
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |  2 +-
 .../selftests/bpf/progs/inner_array_lookup.c       | 45 ++++++++++++++++++++++
 12 files changed, 112 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/inner_array_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/inner_array_lookup.c

