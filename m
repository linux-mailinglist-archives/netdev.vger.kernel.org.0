Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F313244FC78
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 00:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhKNXna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 18:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhKNXnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 18:43:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14F7C061746;
        Sun, 14 Nov 2021 15:40:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b68so13428175pfg.11;
        Sun, 14 Nov 2021 15:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=pgmv3M4B238SIiPc46gdEGxPH8W7iZDv8IyHZEGA3xE=;
        b=gg1n9jtsWW8KV4vhHrlSE8/WHzDru8u6PklLrPf4a59nqbhhWB2WGphQuKTmtVyrAi
         fsfjI62pLPSBmphkOnIz7d7Gox1uvMiHKR2IgyHk80joCDapwSnwbZiBxQ0k2uC6a6xQ
         VvOkeh0+tN2fxmyUBRR1pLKx8AbdENDsFTnPaTJcoCuahty3JNYhTBxUVLIT2NuYhXFI
         LxTdbtItNN0cR01WOplqzwtfrmaRhxh9UlNjxiciwownDsDgwMK/23EcQbEExey1BolY
         VSLztkOcjlaPdSlJkMCbtKVTlNDyWQzYFed7Si7PB9SW9710DyosxGdYMgOzueCQOoJu
         TfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pgmv3M4B238SIiPc46gdEGxPH8W7iZDv8IyHZEGA3xE=;
        b=XqUap5CMD7aux7p0PtCDbiSrJGB5r9Cj2fuNsHJ7/AIP5TKbHV8zmFEeGO5GCaNIXR
         C+3WLAnfGgeKbB1Avber2M08kREMjOdEeNv1/LTIvrHOFZP1AAoS2/Bx9YsGbDT0wdlr
         2nmJxjHhm6nc7BGTEULgIFTsyScWsIeQPlgaRuOkdOhD4Jh3sHZxaRT7AAKdx9as9Rin
         vSwGptVZuSmSEHR0dutrdeUYkdYOkOaVFRB21EYT9ZQmOqRfBmrcCZRq5Aqz2Y7rXKZz
         Hyv1xSyvf7iJR+IAdmK6zwT1nj6Q5z2hjCvUh3NDU1X3YShPCORqYSezCYG66qY52VXt
         C5Jg==
X-Gm-Message-State: AOAM5323h7VzQUY2DS/GKTDBvAoiBDNUQQ/hR4+RApAQEuQ72/XrSd5n
        5UPpV4bm0A1julQS1VeTRMj3AA+AcoU=
X-Google-Smtp-Source: ABdhPJwJmR/ScQ0BY5UgLS767TrpZf32Mips6V3+j+7LYkOHmHGHrs/NIUbz4fPhUtuQ9zvEM94JaQ==
X-Received: by 2002:a63:7cc:: with SMTP id 195mr20997729pgh.328.1636933216554;
        Sun, 14 Nov 2021 15:40:16 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id p2sm10444750pja.55.2021.11.14.15.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 15:40:15 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id BF80B360207; Mon, 15 Nov 2021 12:40:11 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v11 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Mon, 15 Nov 2021 12:40:02 +1300
Message-Id: <20211114234005.335-1-schmitzmic@gmail.com>
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

v11 addresses review comments by Geert.

Cheers,

   Michael

CC: netdev@vger.kernel.org


