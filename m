Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32B2B27AF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgKMWEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgKMV7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:59:25 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620EEC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:25 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q5so8764112pfk.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dag/phVn9xYl++l9ZVWH37ihvmEFGBfDvdy1rG9BZpc=;
        b=QhDNuGJ2gd9ae8ePVzJX4P1uch+nm8jrp4T3DR3dm3b6DtmN+7SMJ78iEfIlwbUBOl
         yZn5dn96k5EdyDhv8fWrm40aeYRRKw7fCLAQKbjt7YHQz2QNI1iKewUrl3z9vbMYU7fD
         CLejhHPE5P1NFIN7y1iVAcuoCwbfpV5pg2Nu4KrumgcWth9GqNAoRo5/ozyhTm0f3Kci
         Q60L7qgWoKqFkGmwoWhXVKSJYdja3u2l/ETDKJx0OGYIAzsEpp3SnyJhJLF5kT85u/HE
         HAK6S8j/f/fhWB0r1IMDzgJ4lNFlNnG2TIsl92/REbRZlb891L/7nJIDF4ZoLxNY32Qu
         i2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dag/phVn9xYl++l9ZVWH37ihvmEFGBfDvdy1rG9BZpc=;
        b=HmTUBPpCALFE5NpNr5lsNOlEWvHT86aBwzVovPQHHAT8mhUvyEMpEEL+JKAmIKBAsQ
         JYn00rCPf72DLl3A7oF4p4rI7mXQ3vYNwNTf/pgbe1L++tgNUS2KmUEEZUyPCEwq9RCy
         kyAw3Yh0BgJr5l2Nb6x9SIEX8M4pbHF0/1OOqJAt8UwiCF1sJSkBFRnPBf/EHvTy1Kl2
         ewq/EhHYKZsL48tfXxcp0D4l9AvIq4KPF/VkMz/gA63lTpfE6FrzcgRbWznNZSsaSOrF
         1N+75qpzL+MtV0IooIyPcJnpbcaEvWij0x+cVwF86rrn0bAdTI5wpYFDV59nWcyaC316
         PLaQ==
X-Gm-Message-State: AOAM531yfLWa5LVX3hWCRppcaRtAijASxk0EHITiGO8MpkJHLyApBN4q
        biE8IFRKvA84lztFsdXbtjM=
X-Google-Smtp-Source: ABdhPJxvDaSDomFWC0NBs5ApbFi/cVZwdieM+LL8L6i6mRRyblDP3UNFeYAbBTUS10KUCmo+TBIs6w==
X-Received: by 2002:aa7:8616:0:b029:18b:421b:9168 with SMTP id p22-20020aa786160000b029018b421b9168mr3752524pfn.33.1605304765004;
        Fri, 13 Nov 2020 13:59:25 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id p15sm11938403pjg.21.2020.11.13.13.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:59:24 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] Add support for sending RFC8335 PROBE
Date:   Fri, 13 Nov 2020 13:59:23 -0800
Message-Id: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific interfaces on a node and requiring
bidirectional connectivity between the probing and the probed
interfaces. RFC8335 attempts to solve these limitations by creating the
new utility PROBE which is a specialized ICMP message that makes use of
the ICMP Extension Struction outlined in RFC4884.

This patchset adds definitions for the probe ICMP message request and
reply types for both IPv4 and IPv6. It also expands the list of
supported ICMP messages to accommodate PROBEs.

Andreas Roeseler (3):
  net: add support for sending probe messages
  icmp: define probe message types
  ICMPv6: define probe message types

 include/uapi/linux/icmp.h   | 4 ++++
 include/uapi/linux/icmpv6.h | 6 ++++++
 net/ipv4/ping.c             | 4 +++-
 3 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.29.2

