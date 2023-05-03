Return-Path: <netdev+bounces-94-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8E06F5234
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57832280FDD
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EAF4A16;
	Wed,  3 May 2023 07:49:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B201398
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:49:53 +0000 (UTC)
X-Greylist: delayed 29795 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 May 2023 00:49:49 PDT
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A51997;
	Wed,  3 May 2023 00:49:47 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
	id 841A3C023; Wed,  3 May 2023 09:49:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100186; bh=03BZvl9vWUAaps81KZtMrvoUu+Ei0u6JmNiU1A+xCUw=;
	h=From:Subject:Date:To:Cc:From;
	b=Drl5yaP49ve7lFH4girxL1C0YjfGkj9U3efO1MO378YJ5teEqcsmP74L9rlx5UVyT
	 5dba/ZS4Fm5d4TXUsXgF0lv406UMuf3zlYEZ61Rrt+gQHc9D5FxX8Qi+LWVJdiJ/Qz
	 PWMDCehaM3M1TFKxDf35SocpGw8qC8+e8yxdI0KLqOwROQL1neNjrXWFl+UrXj2yQe
	 l7LFRTS0+E2UFXvzBQp5lY6Pv7SD/+XEqndF45GT1cfd2FSCXXHUaB+bc+ybzs+h/k
	 vw0Lau/UKelx0GZr8P5XRhhFvoWbS4dOedpkNqM1d5qpgukCbLeNalDOqCjg5K0H1d
	 zZjQ/MAcjs5eg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 68329C009;
	Wed,  3 May 2023 09:49:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100185; bh=03BZvl9vWUAaps81KZtMrvoUu+Ei0u6JmNiU1A+xCUw=;
	h=From:Subject:Date:To:Cc:From;
	b=U6ss4AB6X/svBcKiMyOB14hiH+SoTYUiBfAqXlBz4lJQ5y723ZeV2W+42TMza6ZaL
	 qCQLGDDoJ9xS4B287H1Ocp/Q9PISIlqhUMhPDW/6dlrUeaPgOZfPgrsEWCVOb8kuYu
	 D8bavk5Db8sgOeZWiL6rcjCeWHS+UahuUrLW9siQ/Nzahdr2NGjV6FS8D0UAlpIBbq
	 RNrYTpKlm7xSvW241U1ZWns8lIm8NuTrgr4YpScK7ZNR1YS1bh+JHbUunFSHqbALEx
	 Amt5636UxLoCB8nKuq8GcbmQUpTX+MayC2k3KIi4jS8EcRgSdZVzh6uHPTJWVPy026
	 x5jvWHP/BBTQw==
Received: from [127.0.0.2] (localhost [::1])
	by odin.codewreck.org (OpenSMTPD) with ESMTP id 97d966d4;
	Wed, 3 May 2023 07:49:37 +0000 (UTC)
From: Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH v2 0/5] Fix scan-build warnings
Date: Wed, 03 May 2023 16:49:24 +0900
Message-Id: <20230427-scan-build-v2-0-bb96a6e6a33b@codewreck.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAQSUmQC/22NwQ6CMBBEf4X0bE2pgOLJ/zAclu0CG7U1W0QN4
 d8tnD2+mbyZWUUSpqjO2ayEJo4cfAK7yxQO4HvS7BIra+zBFPaoI4LX7YvvTrtTXWBedVgXpUp
 CC5F0K+BxWJUHxJFkLZ5CHX+2l2uTeOA4Bvlup1O+pn/3p1wbTR2Y0lUlWQcXDI7eQnjbB+lVs
 yzLD6TnTC/BAAAA
To: Eric Van Hensbergen <ericvh@gmail.com>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, v9fs@lists.linux.dev, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1648;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=afbQdsPMHgU9d5cGBEldN5a+ZUGe/KImHrbQL8lC5/o=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkUhIRCm8c7FkghHBdb67PEXrRMdCgilMZRzUoH
 CF+GQz8mwCJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFISEQAKCRCrTpvsapjm
 cLDlD/4k9GMiCeWg0Jkms1hwipAGnOoHYTXr2Ia6KsuQCZAvgHjokosICR/8NsWawcdTVIwEef7
 6o0hYX5f6uApDA/jGLdQcTU/P0Qe1dskuUPJxqmXyuAXaqapSz92vBQZ3WrdY9RYfbeZY+SuULm
 GAZUlFmHzKHZ8oJm/HpzJCD6JmCUP/PFwVEjvh6gltPAcTIZ0X4y5KjqTlTvX4sWEDnJ5kb62DL
 Ew3dw8N++P4C9mobBi1MtwoLLPYkW5oOeFycZ5xcJvjfpvI4ZUIq3WB7NUrvuvqUtZgAKAQ5w0z
 hLYTmEz1J0YaW5VEJ41FNP0QKbnmzqDO2Qt07Hn/vJPgOLCz9QiBnLI+72CfH1L1LZtnM9tI4NM
 9ds1M0Gk2lRA2WDgK/pzS0fj1BhI8dzBhP7K3hKev7ARQvQEWAlSUxN03H5Y5+L7WoDiI4V19Zj
 b9w+39k3mqDytX4sH9iLh5BGqvh64k/o34/MoKo9RE6EWDi6i8s4pDVuAev7GneeG872uTKVmxa
 Xbe548kc99vDp+56ycZiLnOF4KVG+j+u3m6JxWfsV5DjilfuEwAiwlEYChH58uv9qP1y2kTn5Aw
 idBIUri0ulX3JlcLVjd6NMjKdd7E7wc/+7FlKsFilzYheF/QURdhBoHWxKcIp4X/bGtnwJUI7uO
 37p/3KE5hv+Y1cg==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A

I ran scan-build very crudly on our source files, and there was at least
one real bug so we might as well run it once in a while, in which case
we probably ought to also fix the less important things hence this
series.
In here the first patch is a real fix and the rest is low priority, the
last one is arguably not an improvement and can be discussed (happy to
just move the 0-initializations around to variable declaration which
would also silence scan-build afaict)

Anyway, it can probably all wait until after this merge, sorry for the
timing.

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
Changes in v2:
- Add Fixes tag to first patch (wasn't the one suggested but a very
  recent commit, still in -next)
- Fix typo in commit messages
- Link to v1: https://lore.kernel.org/r/20230427-scan-build-v1-0-efa05d65e2da@codewreck.org

---
Dominique Martinet (5):
      9p: fix ignored return value in v9fs_dir_release
      9p: virtio: fix unlikely null pointer deref in handle_rerror
      9p: virtio: make sure 'offs' is initialized in zc_request
      9p: virtio: skip incrementing unused variable
      9p: remove dead stores (variable set again without being read)

 fs/9p/vfs_dir.c        |  5 +++--
 fs/9p/vfs_inode.c      |  6 ------
 fs/9p/vfs_inode_dotl.c |  1 -
 net/9p/client.c        | 46 ++++++++++++----------------------------------
 net/9p/trans_virtio.c  |  8 ++++----
 5 files changed, 19 insertions(+), 47 deletions(-)
---
base-commit: 21e26d5e54ab7cfe6b488fd27d4d70956d07e03b
change-id: 20230427-scan-build-d894c16fc945

Best regards,
-- 
Dominique Martinet | Asmadeus


