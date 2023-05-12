Return-Path: <netdev+bounces-2082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF97700382
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EB801C21163
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B050BA4D;
	Fri, 12 May 2023 09:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3BC2597;
	Fri, 12 May 2023 09:21:27 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DFFD2DC;
	Fri, 12 May 2023 02:21:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-305ec9ee502so1710477f8f.0;
        Fri, 12 May 2023 02:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883284; x=1686475284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pkYL/syTf0nPUeqpR++4UlEczya8fgRVTB/figVAAso=;
        b=TUOymGDS2ZoT5/n999Em3uwBiThjSJ+NRwb62ebFUtTKqHQQOfGW3uB09urqizLc+4
         a4P05Br93TI50xDnMaQFIWchHXPPaI/JUa5UK6F1fXLqolH4pdOwHDYR63AwEzPokbc9
         1Q7tXvmCP30q2tJHKfpGGXDvAPWyPnS7m93HeSuD9vgxpdsjonGoyof2WACrJ/BSQUMN
         o2eVHFxBiTpf53b4XgK1NYGQfC3TRd9Y/twD09HY7PoOBvw9hQSZuC/HThxwZofBZCwe
         FHFxgvJaOhEtB6fn2hsyIv7km7euwEdhUpz5LyIwg/9RMf8zVnJ+jPjX+MUal4p7TQJX
         +rLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883284; x=1686475284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkYL/syTf0nPUeqpR++4UlEczya8fgRVTB/figVAAso=;
        b=NISjeZODxF7og5ArwjNF5wzk0py+WX3iwNha8PClG98PMXM01hCPPiA9fca82bGckr
         NyVSZbnaQK4dZbbJPbIFOiZXaNYX+0r6/imu4DcRBIRinEKSS/722MBuCHd0tW6j3FIz
         GnPKfq2Pxy7N144ZOQ+r8Wk0K4mTKtH8SvqN0XmtSIxekMcX7HQ7Wj/NcwRRV/98AFwj
         HY2FI5fXYWsvFNYT5H69+Ai/yqxyj7QIwFxyyTjubB+M6YCF0w3OYOJRVMGMiR/8JWrQ
         FBLEAb+thZTVYDMDswyQzup/d4epSfEm9ItaUGO+pLKYp3WiCdDr4rMFo+ZV9niwH+Rr
         H4sA==
X-Gm-Message-State: AC+VfDxKdKM9pi8NcGS/cmwk30pEEbichxG3y1xGoW3MUpqWUgzETItE
	OLQlEH4DSHeoiqPe1SU2GuM=
X-Google-Smtp-Source: ACHHUZ72+kfueQSPm1je5L9zSkZlIsWARVkt9XFdRAQ6Os3mQ7fOmXXieF8dQ4oPEmijR/owTu/riw==
X-Received: by 2002:adf:f84a:0:b0:2fa:b265:a010 with SMTP id d10-20020adff84a000000b002fab265a010mr14488040wrq.7.1683883283653;
        Fri, 12 May 2023 02:21:23 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:23 -0700 (PDT)
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
Subject: [PATCH bpf-next 00/10] seltests/xsk: prepare for AF_XDP multi-buffer testing
Date: Fri, 12 May 2023 11:20:33 +0200
Message-Id: <20230512092043.3028-1-magnus.karlsson@gmail.com>
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


base-commit: 6e61c5fa4d43d4c3f780f74ba6b08dba80bd653a
--
2.34.1

