Return-Path: <netdev+bounces-9266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1198B72854D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20ADF1C21051
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824B2174F7;
	Thu,  8 Jun 2023 16:39:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7678E174DF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:16 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FC73592
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:38:55 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3094910b150so896464f8f.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242332; x=1688834332;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JGgFYG4pTXXEQQu9pOYaZxnZKEc0m4h2k2KonONr7Wo=;
        b=7wooIIWCeGgJJhsnKiLE5SkY2xW4XCFyD+DC2fxuMLfinQfLFC9uyKFhg3Tw2D0WSb
         gWDpm8bq3Q5ho78f6gI+HIJZa1ffQ3YWiJN8Lu6OQPEQG970FkHeD2vvgGDUZ9q0m+MR
         QgAfM+Bk2xpi7WOYhz+KZe2voiECA3PUVHA4ZCMM1RuNHyriaSm/ylGy6KNHEIq2trFB
         /Be7SVvI5IU6QVpA2M1DG/pz8cv5d9ht1unUFcwz1vW+AWnH4NeVMPzHs/+nQODUgsyE
         xCurIfzfmCyFOpLffD5se4UdzqfsVKW600+GbO+emyhBWg+1KFO7dX3V0kfkXCSy9UKc
         xCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242332; x=1688834332;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JGgFYG4pTXXEQQu9pOYaZxnZKEc0m4h2k2KonONr7Wo=;
        b=PcE79HOlq8It/nbEO3u8LtJ9penVzKcLVKVOB5p/LDmZmVYtuCh8BKD2WrhS2USTKz
         gEO/185XNRjY7k5fspREri3xe2OMzCNJBT2Uy+Fp7c4GueOEsILhfvko/LopZmKK7xC5
         A2hTcyLoNQjENFLmexMeAuUysb9h9rcWN9csSx/c+Bh4uS7yC3iJxQwbpJzI5gR6vyWQ
         VNt28Xu5budnamUTx3gLCc0pBppsbRA/P7+Ky/yb7fyJURfFQvR9uLE/pq9AC55F0W3j
         UkBLT6UVADqNO7ib5heGC132CIexVjjnV/uexEK6mVIKdUpdxdRIsbEnxh1+smKW9nZ+
         ObcQ==
X-Gm-Message-State: AC+VfDz8HQKkqLoE/Lh/QY5Z88gHzyjn8lL5GNMqpG8GAcXBVxrTbyvY
	97g5ofaTku6QQdlWrtlCPyOubw==
X-Google-Smtp-Source: ACHHUZ6epwBQynkAq+k63HyqJ3Kc0r0/nDQBYZBDFh0kYhXJ/uYtT7MYYArs1t46Mz31dpKedZeaFw==
X-Received: by 2002:adf:d083:0:b0:30e:46d4:64ee with SMTP id y3-20020adfd083000000b0030e46d464eemr8058706wrh.29.1686242331961;
        Thu, 08 Jun 2023 09:38:51 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:38:51 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 00/14] selftests: mptcp: skip tests not supported by
 old kernels (part 2)
Date: Thu, 08 Jun 2023 18:38:42 +0200
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABIEgmQC/z2OQQ6CMBBFr0K6dpICBoxXMS4K/UgjlMlMMSaEu
 1tYuHxv8d/fjEIC1NyLzQg+QcMSM5SXwvSjiy9Q8JlNZavaNvZGK2sSuJkiEv3tzKlnUkxDgiY
 lXZkXSbRMnt6QiEmJXRYVNajrFuVgr603OdM5BXXiYj8eoTx7WBYM4Xsee5zuue8/X0el2K0AA
 AA=
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Davide Caratti <dcaratti@redhat.com>, 
 Dmytro Shytyi <dmytro@shytyi.net>, Menglong Dong <imagedong@tencent.com>, 
 Geliang Tang <geliang.tang@suse.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5301;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=m2lTbvzBdpE+8eV+owavMq2thTouVcd8Yc3fJnRY1Gw=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQZF01YMhPS8hRbSdmSkS4jEyIE9KiZM5PyF
 SimTTPsA4+JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGQAKCRD2t4JPQmmg
 c1LAD/9DCGzokFCh1orVI7Q/oe4PoaItTHw2275MikLkfafFgBeM9gy7Kal2dnHpTNJMXU3KF2t
 BeTOGJXYKgRzLAJ+NkfDyQtKrFpNLuNzUVQ0PbT3ZSdK7ebIjXJNZwLP4rvXJM69KmuboSb7GGj
 yQZ7BJWVl2SpFFBowvdFcJ3FwMUPsESAttJIHx466poyQi+ib2TCjK1+vdzE/Vj9F8i2IACWzUh
 y3gDRMOsw5Z6TcOZ70DwizSt+fGVpgPTpb6V4JCeWp6Pd55Y4ujPJt4ZSro09w+HGNOLJwqpvaQ
 DViQjNsv5HBJBS9ohh1RfWMwW8OZITNfb0PF3hYR2eKXwUlwx+cIzPoygTbFk74/V8CnXjCjzxS
 7n4Ih6KeeyTjA+O2q8+gkjpJPO+z5Jevto46HJVU4asO9OJXJfubrzbDu+qDWFIw1SoYSqoopcC
 UK3/4pg/4oXydfOazgWKIpFOULrpezg77WmQnaeqOBOi/1x69koGNmKXyRKoKB+JwSZnla3HLvb
 F0Fn7yWqdUtNirLL9c6z65fA6BYF0mS/aMpbFvK3PC8HHnGwX3nwltUhFSCpnmyICFr27uiW9x1
 Oo7nrDWVL6WBc/tRm3BA67ISHlXBguC905eqcGN/TfRZnhAesREJOalNA6o0qQ74Ds4p+MLMDwP
 mLKmkEFsyhxybOg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After a few years of increasing test coverage in the MPTCP selftests, we
realised [1] the last version of the selftests is supposed to run on old
kernels without issues.

Supporting older versions is not that easy for this MPTCP case: these
selftests are often validating the internals by checking packets that
are exchanged, when some MIB counters are incremented after some
actions, how connections are getting opened and closed in some cases,
etc. In other words, it is not limited to the socket interface between
the userspace and the kernelspace.

In addition to that, the current MPTCP selftests run a lot of different
sub-tests but the TAP13 protocol used in the selftests don't support
sub-tests: one failure in sub-tests implies that the whole selftest is
seen as failed at the end because sub-tests are not tracked. It is then
important to skip sub-tests not supported by old kernels.

To minimise the modifications and reduce the complexity to support old
versions, the idea is to look at external signs and skip the whole
selftests or just some sub-tests before starting them. This cannot be
applied in all cases.

This second part focuses on marking different sub-tests as skipped if
some MPTCP features are not supported. A few techniques are used here:

- Before starting some tests:

  - Check if a file (sysctl knob) is present: that's what patch 13/14 is
    doing for the userspace PM feature.

  - Check if a symbol is present in /proc/kallsyms: patch 1/14 adds some
    helpers in mptcp_lib.sh to ease its use. Then these helpers are used
    in patches 2, 3, 4, 10, 11 and 14/14.

  - Set a flag and get the status to check if a feature is supported:
    patch 8/14 is doing that with the 'fullmesh' flag.

- After having launched the tests:

  - Retrieve the counters after a test and check if they are different
    than 0. Similar to the check with the flag, that's not ideal but in
    this case, the counters were already present before the introduction
    of MPTCP but they have been supported by MPTCP sockets only later.
    Patches 5 and 6/14 are using this technique.

Before skipping tests, SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES env var
value is checked: if it is set to 1, the test is marked as "failed"
instead of "skipped". MPTCP public CI expects to have all features
supported and it sets this env var to 1 to catch regressions in these
new checks.

Patches 7/14 and 9/14 are a bit different because they don't skip tests:

- Patch 7/14 retrieves the default values instead of using hardcoded
  ones because these default values have been modified at some points.
  Then the comparisons are done with the default values.

- patch 9/14 relaxes the expected returned size from MPTCP's getsockopt
  because the different structures gathering various info can get new
  fields and get bigger over time. We cannot expect that the userspace
  is using the same structure as the kernel.

Patch 12/14 marks the test as "skipped" instead of "failed" if the "ip"
tool is not available.

In this second part, the "mptcp_join" selftest is not modified yet. This
will come soon after in the third part with quite a few patches.

Link: https://lore.kernel.org/stable/CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com/ [1]
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Matthieu Baerts (14):
      selftests: mptcp: lib: skip if missing symbol
      selftests: mptcp: connect: skip transp tests if not supported
      selftests: mptcp: connect: skip disconnect tests if not supported
      selftests: mptcp: connect: skip TFO tests if not supported
      selftests: mptcp: diag: skip listen tests if not supported
      selftests: mptcp: diag: skip inuse tests if not supported
      selftests: mptcp: pm nl: remove hardcoded default limits
      selftests: mptcp: pm nl: skip fullmesh flag checks if not supported
      selftests: mptcp: sockopt: relax expected returned size
      selftests: mptcp: sockopt: skip getsockopt checks if not supported
      selftests: mptcp: sockopt: skip TCP_INQ checks if not supported
      selftests: mptcp: userspace pm: skip if 'ip' tool is unavailable
      selftests: mptcp: userspace pm: skip if not supported
      selftests: mptcp: userspace pm: skip PM listener events tests if unavailable

 tools/testing/selftests/net/mptcp/config           |  1 +
 tools/testing/selftests/net/mptcp/diag.sh          | 42 +++++++++-------------
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 20 +++++++++++
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     | 38 ++++++++++++++++++++
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  | 18 ++++++----
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 20 +++++++++--
 tools/testing/selftests/net/mptcp/pm_netlink.sh    | 27 ++++++++------
 tools/testing/selftests/net/mptcp/userspace_pm.sh  | 13 ++++++-
 8 files changed, 135 insertions(+), 44 deletions(-)
---
base-commit: 6c0ec7ab5aaff3706657dd4946798aed483b9471
change-id: 20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-6e337e1f047d

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>


