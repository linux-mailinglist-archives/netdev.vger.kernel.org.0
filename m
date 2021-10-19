Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EB0432FF0
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhJSHpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234581AbhJSHpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 03:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 385656136F;
        Tue, 19 Oct 2021 07:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634629382;
        bh=hJoet635Vy1bZq8U3J0xmPvh7E+f4HrdZFse3BcIUaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAiYan56EhycFINj4QXIHezUk0hXKMCem+RCbBFZQB0gwQk8FLcLUWWw0CDNtiW1g
         jqrJVPxyn6aZBikDklBi7T7q6JCJHW41tvbaiJlso8PH3H3xHPbfRegZIYizB4gQgu
         nvTQd3Yv4P4rNbGMVp/pZZGUdH+eyxQrPDK82cfzfjddpgSTNthoj/MRvS8IRV/dix
         dHgusBY45kDfnyoIYVOdc9XTDqhrIIy4gCZ54k+73jqNREHjuBVSzEa0XLDFT6RXVB
         PZoe7Lnw9JHN7HklmO7w/plzsLdxl7Tg3Zz8b6kHYXk4AYR3xhdMaRBFun1ts8G3SE
         ljzeut4d9MIkg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mcjlt-001nLk-8V; Tue, 19 Oct 2021 08:42:53 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] scripts: documentation-file-ref-check: fix bpf selftests path
Date:   Tue, 19 Oct 2021 08:42:51 +0100
Message-Id: <49b765cbac6ccd22d627573154806ec9389d60f0.1634629094.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634629094.git.mchehab+huawei@kernel.org>
References: <cover.1634629094.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tools/testing/selftests/bpf/test_bpftool_synctypes.py use
relative patches on the top of BPFTOOL_DIR:

	BPFTOOL_DIR = os.path.join(LINUX_ROOT, 'tools/bpf/bpftool')

Change the script to automatically convert:

	testing/selftests/bpf -> bpf/bpftool

In order to properly check the files used by such script.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---

To mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 0/2] at: https://lore.kernel.org/all/cover.1634629094.git.mchehab+huawei@kernel.org/

 scripts/documentation-file-ref-check | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/documentation-file-ref-check b/scripts/documentation-file-ref-check
index 6865d8e63d5c..68083f2f1122 100755
--- a/scripts/documentation-file-ref-check
+++ b/scripts/documentation-file-ref-check
@@ -147,6 +147,7 @@ while (<IN>) {
 		if ($f =~ m/tools/) {
 			my $path = $f;
 			$path =~ s,(.*)/.*,$1,;
+			$path =~ s,testing/selftests/bpf,bpf/bpftool,;
 			next if (grep -e, glob("$path/$ref $path/../$ref $path/$fulref"));
 		}
 
-- 
2.31.1

