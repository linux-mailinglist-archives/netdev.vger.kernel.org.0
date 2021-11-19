Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09D14577B4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhKSU2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhKSU2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 15:28:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73892C061574;
        Fri, 19 Nov 2021 12:25:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so9728169pjb.4;
        Fri, 19 Nov 2021 12:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+kI0hPzDFLJCjp/9CcqqdlPTNZqJ+36W+pg9jRi17lg=;
        b=IMFZJUmcQ1bwOUhZGe6PJdX6v0cmpFGUFMmAhY3Wl6U763B0dh9sZkrHhiFoco0vj3
         J26JcKd8S2eeFwBYhuccXB4b+baMwYpGrE4ySMi1wdA0AlBRB/I7aVSSuaVIzV2gL3fd
         k0MBtnCTeEeUaTE0QaX1SpzAkh1vrlWoRBEuDfjczHfYBCiJUtustRcfb9K4+RllvUP+
         v0i0KIL5iq/xiAE7kCCH4GA+RJ2k6dXR+maQ+Q1JvyQVfjxlsxrajNdXNYHYSLIyR/8k
         ozQDd9di/Ju/8elgbPC0crExvRgNEANx6QmUC6HciDdBojQ5JOPhMXh2LpQ73FBb+fLY
         z2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+kI0hPzDFLJCjp/9CcqqdlPTNZqJ+36W+pg9jRi17lg=;
        b=BV/adExOzeFHdwUjxsWBogwCahhLUkf1ZtpVBJM1BjDA9mhcTjfgKZGmSsYEH0mQuM
         +3snnyd5VzBTL/lTF9ii/LP/aNOl6FbDAkIl0Tv3jXfOyjB7+tVsgoR27uO/ioMvvd57
         Y226HH+CpD1bsicMatdFid+vA3snEV1/7DNpvrFc34ScgGkS6tOVUZGmn5PosQ9uLzBm
         nlZ4IfetVipVVP3Y6OsnTev5zaL3pyyZbeZEOAxd2qlKBNI3vpBoOpw0hGV0A1YHnRSe
         08R2eTbIZCt4yRHqEtqbRIGpBu8n4YTiOx31fEw2ck2XTKyqSocSaI2mLT2cpfCc/Dl5
         26OA==
X-Gm-Message-State: AOAM532Ax3lHCLlCNA6/6gf/yP/pQ+nOMC60m2CiXXUGGEB8LwYvG7XY
        YvNpLP/VfoXfRzeYYR1KeaKrmErIwPUo7w==
X-Google-Smtp-Source: ABdhPJyc71smnBF9pf3KnrlmzcICLVJO2eZdO6ciPoiCOZjnXvdpPHN2eVh73ZQ1MRqoN4z7af9fnA==
X-Received: by 2002:a17:902:8e87:b0:143:759c:6a2d with SMTP id bg7-20020a1709028e8700b00143759c6a2dmr78805399plb.59.1637353507042;
        Fri, 19 Nov 2021 12:25:07 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id o1sm11413805pjs.30.2021.11.19.12.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 12:25:06 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id A45C036030C; Sat, 20 Nov 2021 09:25:02 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v13 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Sat, 20 Nov 2021 09:24:57 +1300
Message-Id: <20211119202500.17850-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch enables the use of core PCMCIA code to parse
config table entries in Amiga drivers. The remaining two patches
add 16 bit IO support to the m68k low-level IO access code, and 
add code to the APNE driver to autoprobe for 16 bit IO on cards
that support it (the 100 Mbit cards). The core PCMCIA config
table parser is utilized for this (may be built as a module;
must be selected manually for build in order to enable autoprobe).

Tested by Alex on a 100 Mbit card. Not yet tested on 10 Mbit
cards - if any of those also have the 16 bit IO feature set
in their config table, this patch series would break on those
cards. 

Note that only patch 3 has been sent to netdev. Please CC
linux-m68k when providing comments.

Only change in v13 is clarifying the Kconfig help text in
patch 3 as suggested by Geert. 

Cheers,

   Michael
CC: netdev@vger.kernel.org


