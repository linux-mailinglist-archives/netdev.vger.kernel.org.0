Return-Path: <netdev+bounces-5789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70169712BF9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D761C20FD8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2DB290E0;
	Fri, 26 May 2023 17:42:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFCC1E536
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:42:05 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD110D1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b024e29657so380775ad.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685122904; x=1687714904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iN0bWrlsTbLW3cE9h2whD1OxVhKz4hCXw/N1eir7WkY=;
        b=fEn41M6JwOV1EFrPmGLzk4innvcD9MTC0tUkCpRyfdPbwvRC2fmmtdjU+Le/Qvybo1
         MJs/zdKyf3awdwVVIRuq6QS7gDd5ca/lJSLmp/UaDwabfhOg8mPPAmEyPH0qPUCVgMhe
         ZP0b/DGSTIJN94RzzuU8kop1MUnW8MSw6OI3vISeBt6Bw0av3VThfgY11nEGc/M1Cx2j
         nuidT67tA1O+WARO5bdP/A+jARZhEWKnfqve+q4Tc0Ttwp61oxbcrpVqu+Tuk9Dt7gsU
         FeI3LCK2803wSEe4g/0UdlKXyLEQvmFWqs6eyDclwhy15p2NzdV7khm6TZ23m++APWG+
         kikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122904; x=1687714904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iN0bWrlsTbLW3cE9h2whD1OxVhKz4hCXw/N1eir7WkY=;
        b=HDSUn7iFjyIyeTrTtunt9jTU51cQJylnIbiY2AM97lygXTvxeEsUIZwF0UXFTIkQj3
         w8wSlEOMYA96s6uv3XEI4LLuFIhVGDp3yUtIZX9GLlZBE4fnhy1PyBEelnoxLLpsAmor
         o/a5xzEyJWLbVqR3RRn1vAMVecLNHXjXnMs7ggaDe1RR2R06jXDPzXIZHPf4vTq1Xc+d
         JeMg96js4SsD8xwoWL88fH6hIBvtZDdzRou36xgIzXwLvKcMegD/QBFq/WNaofAXYc+q
         bzMdHyRthat40iYiyyMs4fhSZyuc2Vya7f/q7QBdz3p0ZwrZ5cRtTujnkKxjqp9veKTH
         g63A==
X-Gm-Message-State: AC+VfDysjei4N1dMYXnT4iNdppQ0oO8N0PUd8oQjglAxuMf78HX30bf0
	+ccpgZaRXDlR0MhwT8vy48AuKDgoqrSutr/WZBnv0w==
X-Google-Smtp-Source: ACHHUZ62NmsL7Z3M1U8xVJ3zZ1RxWeJdoPzwq3wYwmKf3PDuXJhWABaRezBknBCpxnovFaJbRibcAA==
X-Received: by 2002:a17:902:d4ca:b0:1ac:6c46:8c80 with SMTP id o10-20020a170902d4ca00b001ac6c468c80mr3988793plg.53.1685122903853;
        Fri, 26 May 2023 10:41:43 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001ab2b4105ddsm3528754plh.60.2023.05.26.10.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:41:43 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v4 0/2] vxlan: option printing
Date: Fri, 26 May 2023 10:41:39 -0700
Message-Id: <20230526174141.5972-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset makes printing of vxlan details more consistent.
It also adds extra verbose output. The boolean options
are now brinted after all the non-boolean options.

Before:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536 

After:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536

To get all settings, use multiple detail flags
$ ip -d -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 nometadata learning noproxy norsc nol2miss nol3miss udp_csum noudp_zero_csum6_tx noudp_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536 

Stephen Hemminger (2):
  vxlan: use print_nll for gbp and gpe
  vxlan: make option printing more consistent

 include/json_print.h |   9 ++++
 ip/iplink_vxlan.c    | 110 +++++++++++++------------------------------
 lib/json_print.c     |  19 ++++++++
 3 files changed, 60 insertions(+), 78 deletions(-)

-- 
2.39.2


