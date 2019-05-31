Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBFD312FF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfEaQt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:49:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36931 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:49:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id a23so6558571pff.4
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=nklwlkZvOx2XNuT8kpyBFGDGH37/DjuKDKVwAfvTUu4=;
        b=UpQ6SoDNAq2re3jlNtZ6bWaCWGUe1byFeuYlPDP0NuKKBFqmT31UBcmshjHC/6dLCC
         YjkWfA3N1opFnQ5cqQsJsg4PFwxiuwKPs9xIsm80+cWWAKPneb42WtOfyEYedxqJdKdP
         25TY//in+ieABx/r2FDEQLvAVrMTVO+sQa5APqhgAprlKn34ibw4PQQUzpamYu4P0ekE
         MIUwef7hUyibqAKYyMsXJixu/KFLEksEonNWHr5QMkZ/DPL025pyda4XPIIS4WYz86L8
         nQiIZFcGiSOZ5Z/Y5BBTWzwXZfzAlGquXRWHgoba3BsHXyb2JaJKkP4jni1+HBPyTMH7
         W/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nklwlkZvOx2XNuT8kpyBFGDGH37/DjuKDKVwAfvTUu4=;
        b=JZcKBaqY5fKHLdXtCGlrqDK41G6V3r34zb/cOpAg5yWaAcW6jYezMmGwsKLFhCvZAR
         muIJqgyfSkofnCyewZoxEdX4yTlCD5qZAKxQ2CgP1MIDiYqGbsekXgT0n335q+jabR5c
         ZM3rwD+MH/vV1rEhYHjgJD5epGdqMbe9F95eAx7TPJdk14NCvw96jhMsfRzfLwdrhqC3
         SK909rDcJcIyz77pDAmoDbswkByia+xuaoHSeoJPXceaeVX0Ik8AFSTjERlqRxZHLyBB
         BjBi28wcE4yOFl0sDJFq5eOteWQ+rxOQLyZ1LEB9EoQ5mMgtrcHxIhN7rhALlTMm+v3X
         +S9A==
X-Gm-Message-State: APjAAAXyhxdjGEZnoTLbBcIgXCtSYR0RXBNtc7Gv58SSgBXLF9d4Svjp
        zWidqOq5esm1kdzXgdMQx9DdSw==
X-Google-Smtp-Source: APXvYqxkd/FzLdrwDNgnu2b81AJEGqJbsE0KA5If/XKvEpnTtsbtbgNbqG5CsSvmNE/oNUg1Z7Opnw==
X-Received: by 2002:a63:d416:: with SMTP id a22mr10430589pgh.218.1559321396066;
        Fri, 31 May 2019 09:49:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id e66sm8696835pfe.50.2019.05.31.09.49.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 09:49:55 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        ahabdels.dev@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH 0/6] seg6: Segment routing fixes
Date:   Fri, 31 May 2019 09:48:34 -0700
Message-Id: <1559321320-9444-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few bug fixes, code clean up, and minor enhancements to segment
routing.

Changes include:
  - Fix SRH TLV and flag definitions (some of them are now obsolete)
  - Implement a TLV parsing loop
  - Add function to parse and return HMAC TLV in an SRH
  - Support to rearrange segment routing header for AH ICV
    calculation

Set as RFC to let experts on segment routing implemenation evaluate
which of the patches are needed.

Tom Herbert (6):
  seg6: Fix TLV definitions
  seg6: Implement a TLV parsing loop
  seg6: Obsolete unused SRH flags
  ah6: Create function __zero_out_mutable_opts
  ah6: Be explicit about which routing types are processed.
  seg6: Add support to rearrange SRH for AH ICV calculation

 include/net/seg6.h        | 16 +++++++++
 include/uapi/linux/seg6.h | 60 +++++++++++++++++++++++++------
 net/ipv6/ah6.c            | 90 +++++++++++++++++++++++++++++++++++------------
 net/ipv6/exthdrs.c        |  2 +-
 net/ipv6/seg6.c           | 68 +++++++++++++++++++++--------------
 net/ipv6/seg6_hmac.c      |  8 ++---
 net/ipv6/seg6_iptunnel.c  |  4 +--
 7 files changed, 181 insertions(+), 67 deletions(-)

-- 
2.7.4

