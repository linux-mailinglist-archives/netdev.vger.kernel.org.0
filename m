Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD68481EC0
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbhL3Ruq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhL3Rup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:50:45 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E29C061574;
        Thu, 30 Dec 2021 09:50:45 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id b22so21904483pfb.5;
        Thu, 30 Dec 2021 09:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XD1PBLWCU+Wd5wgLSL4PPf6wiHtTvn/c3ckq8ac1Qlo=;
        b=iZcBNzqqZEPdGcPvtFpJW1L763zW4VB2am4IknSlJpiW4SDwYbEGbgyfSVAFiFc+Ij
         Pna+3VXxavyn6t28BGKwHaS62q5ekLcF6zQZVTxSoEK0bJr0+W1Pu4+mNTZ9/BWl80oL
         R/a0Pa2Beobu8zOk/RHvywQBGJf4sG0ZDtbao6iWeT4uyLnR7AfV7ic3TyqtyazRRmeI
         44Nk5XfEWItfDBSef5B6dNeH1UNMA4JRHMOzSO0+PkfLNohqtezZKFrXScvRQoRTRCCk
         dZM6UCdwaiBn7TQOqzzW+6OqesV9WC4YmJ0IgXXQmvQl7WohaGxz32VRbrVV7JsmLAwI
         uj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XD1PBLWCU+Wd5wgLSL4PPf6wiHtTvn/c3ckq8ac1Qlo=;
        b=o0XXgpzgykVHXcAOeCRJYaCy/413CtoPQ21zrkTNcXIFWA+fIne15IJ0kKUJ7SLsfe
         ftC6MlxKPOhkK2Ie1LplxC+ihJV72Kbt0Lua7wL/zxY1XRLiNCXMPQx3Vi0linAzMnF6
         bBuj5BrPXDc6nhYnMwiQ1LwTI9CZZgE6Ni2bNbDaMph1O3gT13mT+8gwk1EEgf7Fe6zb
         I3Z0sC/8EH+dp89EBop9401Mv0IT2h7oVi6XN1MAtiOD+svYXH2P+JG6zyeOWGYQn6w5
         RVyXcjDe3ihEYfCtvDBoFIckUZoMjuS7cSNirDjQ7lRyy55pIxksSYg66EikNmEoshY1
         0nPQ==
X-Gm-Message-State: AOAM532oKIkd8um1m9oCHwBIpbUsZTiiQSjVXYy/HT6z2NwDb+6oQQkD
        KgRbh6DaSl9rHwYulPbVvLk=
X-Google-Smtp-Source: ABdhPJxmUXSCIaytsRADgXQo1VF1eD7leC83pLPvYJ6+CAc5oCVzJZ0wmSppKXiZEO3+vSCpQtUVkA==
X-Received: by 2002:a63:b34c:: with SMTP id x12mr17059473pgt.541.1640886644567;
        Thu, 30 Dec 2021 09:50:44 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:44 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH liburing v1 0/5] liburing: Add sendto(2) and recvfrom(2) support
Date:   Fri, 31 Dec 2021 00:50:14 +0700
Message-Id: <20211230174548.178641-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I submitted an RFC patchset to add sendto(2) and recvfrom(2) support
for io_uring. This RFC patchset adds the support for the liburing.

There are 5 patches in this series. 4 from me. 1 from Nugra.

For PATCH 1/5, it is just a .gitignore clean up.

## Changes Summary
 - Update io_uring.h header (sync with the kernel).

 - Add `io_uring_prep_{sendto,sendto}` functions.

 - Add test program for `IORING_OP_SENDTO` and `IORING_OP_RECVFROM`.

 - Add documentation for `io_uring_prep_{sendto,sendto}` functions.


## How to test

This patchset is based on branch "xattr-getdents64" commit:

  18d71076f6c97e1b25aa0e3b0e12a913ec4717fa ("src/include/liburing.h: style cleanups")


Signed-off-by: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---

Ammar Faizi (4):
  .gitignore: Add `/test/xattr` and `/test/getdents`
  io_uring.h: Add `IORING_OP_SENDTO` and `IORING_OP_RECVFROM`
  liburing.h: Add `io_uring_prep_{sendto,sendto}` helper
  test: Add sendto_recvfrom test program

Nugra (1):
  man: Add `io_uring_prep_{sendto,recvfrom}` docs

 .gitignore                      |   3 +
 man/io_uring_prep_recvfrom.3    |  33 +++
 man/io_uring_prep_sendto.3      |  34 +++
 src/include/liburing.h          |  22 ++
 src/include/liburing/io_uring.h |   2 +
 test/Makefile                   |   2 +
 test/sendto_recvfrom.c          | 384 ++++++++++++++++++++++++++++++++
 7 files changed, 480 insertions(+)
 create mode 100644 man/io_uring_prep_recvfrom.3
 create mode 100644 man/io_uring_prep_sendto.3
 create mode 100644 test/sendto_recvfrom.c


base-commit: 18d71076f6c97e1b25aa0e3b0e12a913ec4717fa
-- 
2.32.0

