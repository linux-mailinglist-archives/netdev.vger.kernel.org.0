Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF64569E7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhKSGJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhKSGJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 01:09:46 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50242C061574;
        Thu, 18 Nov 2021 22:06:45 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r23so7704531pgu.13;
        Thu, 18 Nov 2021 22:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=qaXVaZzAguDWPJfZPcq7ba1ebOqsM0g8r3Q7mHCs7Po=;
        b=Iaw8jLd8/ZHSdcQ29Ils1KmRT93l2BTx4EXQjHZCxFwWbOi2FIyqSzV8mRhH7jb+so
         I0F1dxMH8Flqxqwd+Edzn38ryfhk2KtpjQ9c+6HwRdcKW3hvsJ2nY9R7P9kTapU0ml/q
         9qb3go9MMMdciZkuYy/2OO2PuQZ7napkCLRmN7WfsItJmGxCQXKsnVHqq2lJ7SXBuSGf
         FTTpuokOZcqBWasoMV6cw2PjnGL1tbyAR5sYiDAnjEPQhhDthKiHjaGSGwoz0zMVz+rO
         B8DjqWgA0mE2LOsdPBque84Yxq8B1EnbhHGfRrOI7SbbegSYpc5+hkCxMBROBkDV/JR7
         4moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qaXVaZzAguDWPJfZPcq7ba1ebOqsM0g8r3Q7mHCs7Po=;
        b=E5BST9iwYebIRDxqzk1xC48elPwaFkLPwytb3loNpjimaD651Szrp9lkWseqpTSa+d
         548H2HEJeqR2Fh63qPQMsVDNowztWQXZ+5PGrIKou+b/GwlxYswnRlu4pU/a9eaz0Yq9
         xe5LZnaul36EqTPDRuhKL5SUhlgrPLBiRSwC8Z5CrZF9jgsnSFDs/eaxTGwqAGnucBpH
         sw+UP84fstYW3cXLutvb7G0xColA5h6saOrARh5brnLEJLCUgf5MJLYGVKKkflnTKntc
         Q2uX+2G1vW4Ba9y1InCQOv4su+bkNTYSTShrpzx7hrYsNx5eyxp8FaDyZT3qsW/EYIoK
         zmPw==
X-Gm-Message-State: AOAM533l04Z2CQbaX7tQuOOk4TJN5M2072kchzqwhQk8aKcTSwCZZGg8
        jXfw1PNsjBmpO8m6MpB4gEG4n4mZuG/GPw==
X-Google-Smtp-Source: ABdhPJxoVjHlxGHKKHBgrHDIcQKFZdyG+voAaSroFbyzyJr8ZC03MRZrWMao93NanR8NnNbpySY/bw==
X-Received: by 2002:a05:6a00:1a16:b0:49f:ed6d:c48e with SMTP id g22-20020a056a001a1600b0049fed6dc48emr20516458pfv.14.1637302004696;
        Thu, 18 Nov 2021 22:06:44 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id o22sm1622086pfu.45.2021.11.18.22.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 22:06:44 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id C4EC036030C; Fri, 19 Nov 2021 19:06:39 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v12 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Fri, 19 Nov 2021 19:06:29 +1300
Message-Id: <20211119060632.8583-1-schmitzmic@gmail.com>
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

v12 addresses review comments by Geert and Joe Perches (only
patch 3 changed).

Cheers,

   Michael

CC: netdev@vger.kernel.org


