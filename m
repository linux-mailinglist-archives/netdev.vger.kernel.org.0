Return-Path: <netdev+bounces-2944-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B171704A96
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:31:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCC7C2816A0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4E7A923;
	Tue, 16 May 2023 10:31:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9B1EA6D;
	Tue, 16 May 2023 10:31:42 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDE33A8D;
	Tue, 16 May 2023 03:31:19 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f4289f7c1cso15319795e9.0;
        Tue, 16 May 2023 03:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233077; x=1686825077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PyY8nLdMshgu/nIKvOC/QhwDoVecThGCck/NdAtV7tY=;
        b=QiEsM2fiwNRpg+gq6MmcJ3DXba42wk5N5HVN24IvmAAsV20Mfxp5Jd87DO0dpXzy+6
         uOhBqbS1q3AiW7m8+sveW3n/28KxMMyYIBK3Lss6jdA76TWgvKvsj3d2TwT2SCgOV6Iq
         tObbLiAMX8E3OYgvcs60YeavxnbdvPODQZkTYKkkJuCFlPd+c9GwiepxllW3UfPwd4l8
         EDWnyUYCEJZNJQgeILUd3nAeONa9y7pmKPBcEvMEHwSXsGnYs2L88cIu6nNzvPIh7M3S
         E8EP/sclSjgBgpQAIwIUgOCDPN3pSojVWCBDf0YobBWxA+g5em1n5NE6/3D0KDaex5I+
         X7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233077; x=1686825077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyY8nLdMshgu/nIKvOC/QhwDoVecThGCck/NdAtV7tY=;
        b=bFKrcFsnjOt9Kr2L+N0lIaDbPzwOJzZuzDZI5pJw+vFqvOv6PWI4gY6MGAsbGxy6UN
         ywY4R6DNt4CWh+EjY+YqY6T3WzLj47HgmkfngD9yAjwiN7munEmTHTq0vGlPOBA5IcL7
         o3Wqc32I1w+MCUzwsSCd9LhGrIqz/PyoGkBdw/+n9+LMVvtdT8pPINtbxQ4R+7eUhS4c
         b7CEELKUSmU+TV2kKRQswhdnSwQ1qfuASArVGUr2MgCdUTXhhziWiRyIig6M2wGPdS4F
         sEa/w7g9AlQjT7D+qBAFzphTYuLB1FxOdndbT8bc4aZmM/W6KFZI7dcQpXkZ7ng3W+y2
         mOGw==
X-Gm-Message-State: AC+VfDy9xRP8S5V1fTJCFJPKD0/O3XZJI8P+9h4lfkVsg4CsTeLYFCsZ
	kewERf7LwdfPJcdjbyur9mM=
X-Google-Smtp-Source: ACHHUZ6IDGxuwCz6UoHkj+8Iwgm2KoMirXTd5C9mgcSNLCtsmL8j/hoUFAQ1pX0tQkyJoU8FIvAQww==
X-Received: by 2002:a05:600c:3ba1:b0:3f4:f204:4968 with SMTP id n33-20020a05600c3ba100b003f4f2044968mr1882667wms.1.1684233077112;
        Tue, 16 May 2023 03:31:17 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:16 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	bjorn@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com,
	bpf@vger.kernel.org,
	yhs@fb.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tirthendu.sarkar@intel.com
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Subject: [PATCH bpf-next v2 00/10] seltests/xsk: prepare for AF_XDP multi-buffer testing
Date: Tue, 16 May 2023 12:30:59 +0200
Message-Id: <20230516103109.3066-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Prepare the AF_XDP selftests test framework code for the upcoming
multi-buffer support in AF_XDP. This so that the multi-buffer patch
set does not become way too large. In that upcoming patch set, we are
only including the multi-buffer tests together with any framework
code that depends on the new options bit introduced in the AF_XDP
multi-buffer implementation itself.

Currently, the test framework is based on the premise that a packet
consists of a single fragment and thus occupies a single buffer and a
single descriptor. Multi-buffer breaks this assumption, as that is the
whole purpose of it. Now, a packet can consist of multiple buffers and
therefore consume multiple descriptors.

The patch set starts with some clean-ups and simplifications followed
by patches that make sure that the current code works even when a
packet occupies multiple buffers. The actual code for sending and
receiving multi-buffer packets will be included in the AF_XDP
multi-buffer patch set as it depends on a new bit being used in the
options field of the descriptor.

Patch set anatomy:
1: The XDP program was unnecessarily changed many times. Fixes this.

2: There is no reason to generate a full UDP/IPv4 packet as it is
   never used. Simplify the code by just generating a valid Ethernet
   frame.

3: Introduce a more complicated payload pattern that can detect
   fragments out of bounds in a multi-buffer packet and other errors
   found in single-fragment packets.

4: As a convenience, dump the content of the faulty packet at error.

5: To simplify the code, make the usage of the packet stream for Tx
   and Rx more similar.

6: Store the offset of the packet in the buffer in the struct pkt
   definition instead of the address in the umem itself and introduce
   a simple buffer allocator. The address only made sense when all
   packets consumed a single buffer. Now, we do not know beforehand
   how many buffers a packet will consume, so we instead just allocate
   a buffer from the allocator and specify the offset within that
   buffer.

7: Test for huge pages only once instead of before each test that needs it.

8: Populate the fill ring based on how many frags are needed for each
   packet.

9: Change the data generation code so it can generate data for
   multi-buffer packets too.

10: Adjust the packet pacing algorithm so that it can cope with
    multi-buffer packets. The pacing algorithm is present so that Tx
    does not send too many packets/frames to Rx that it starts to drop
    packets. That would ruin the tests.

v1 -> v2:
* Fixed spelling error in patch #6 [Simon]
* Fixed compilation error with llvm in patch #7 [Daniel]

Thanks: Magnus

Magnus Karlsson (10):
  selftests/xsk: do not change XDP program when not necessary
  selftests/xsk: generate simpler packets with variable length
  selftests/xsk: add varying payload pattern within packet
  selftests/xsk: dump packet at error
  selftests/xsk: add packet iterator for tx to packet stream
  selftests/xsk: store offset in pkt instead of addr
  selftests/xsx: test for huge pages only once
  selftests/xsk: populate fill ring based on frags needed
  selftests/xsk: generate data for multi-buffer packets
  selftests/xsk: adjust packet pacing for multi-buffer support

 tools/testing/selftests/bpf/test_xsk.sh  |  10 +-
 tools/testing/selftests/bpf/xsk.h        |   5 +
 tools/testing/selftests/bpf/xskxceiver.c | 771 +++++++++++------------
 tools/testing/selftests/bpf/xskxceiver.h |  31 +-
 4 files changed, 379 insertions(+), 438 deletions(-)


base-commit: 108598c39eefbedc9882273ac0df96127a629220
--
2.34.1

