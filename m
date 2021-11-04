Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3AC444EA8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhKDGOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDGOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:14:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A58EC06127A;
        Wed,  3 Nov 2021 23:11:31 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t7so4532104pgl.9;
        Wed, 03 Nov 2021 23:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BwYDNkutK0VTKbZJlZC2cc82BEAakFwtmD1VrfQ7VWk=;
        b=Kbf1I9cXeNhc2Bd/tX/xXPYzs0CMGOVuJ/djBXL+rWnQ8QhurK47I9fz+Nvqy7tQ5n
         UQVeBkfi3nP3qmmGm/2Xovy9kvX1bYjcVtqiSh0U8tPchEDJEyGr6Sm7jViv40nDJSGP
         leraAYi9wNzjZU44yLRW0Q6g4Qc93FAp5FCZuas5Bk9tsCX9pR0kxLlyU6FWAMIcdfQ9
         ThIT+OA2GUK+2uGrD94o4YR1zEBVWY4tL6+LeyaHn9vrmsfG/Mnt9laYkfFtsKu4WMMx
         33W8omcka+NpuE6ELt3+B3K3oKVO4RTAt5Z8rMEuG/h3uS9awEqpe4l2gAN5aJ5i9+aE
         k04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BwYDNkutK0VTKbZJlZC2cc82BEAakFwtmD1VrfQ7VWk=;
        b=h/oEQKHE6Swu5ry5AT0Nm6vGXD3RtoMcGzyUjSUlyFH+a/iu9pXUCQQZtpDOnSATVy
         4Tr/W5fKdL0p45p4Im0naHFU+9zfXlUxE4zoUYJNAiGi4bm3PkSYbc9Jr2m0wKJgwELX
         09sKLuR5lu8G5UtWmN5q6+gi4qEcIf1olhZWIHn1OP3gtbVwe1xVnUWjPuMNCfBkYMTx
         QqFv6+FeM1nH9pRByhgOvGrf/jNvHNfuHfdS4O4vk3NtD4HjcFBNWnEGBVNQ8Tg6rnfE
         wmqJ/ax2QgkuGfIB7etylmNkOZxnmqfBMtSzLZ8VAkI3pR+xrKMKZcg1j/TtNcigpuRq
         OvmA==
X-Gm-Message-State: AOAM530lqfAeg+LT6X2pgv1o+EkrGWgxJnC+at3S31/dnu//8Snnq1om
        iw9pB8YUcsValg6yTHBKQPQ=
X-Google-Smtp-Source: ABdhPJyUOWdzkoKjR+7VFDjv/asGMHyvmTsB995VyviWSCgs1+il21W1fLD2zNkKfnUl/K1umTr0Dg==
X-Received: by 2002:a05:6a00:15ca:b0:47f:59c4:dcf6 with SMTP id o10-20020a056a0015ca00b0047f59c4dcf6mr41150278pfu.63.1636006291170;
        Wed, 03 Nov 2021 23:11:31 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-4-20-adsl.sparkbb.co.nz. [222.155.4.20])
        by smtp.gmail.com with ESMTPSA id q32sm3202033pja.4.2021.11.03.23.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:11:30 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id D7515360200; Thu,  4 Nov 2021 19:11:25 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v8 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Thu,  4 Nov 2021 19:10:23 +1300
Message-Id: <20211104061102.30899-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch enables the use of core PCMCIA code to parse
config table entries in Amiga drivers. The remaining two patches
add 16 bit IO support to the m68k low-level IO access code, and 
add code to the APNE driver to autoprobe for 16 bit IO on cards
that support it (the 100 Mbit cards). The core PCMCIA config
table parser is utilized for this (may be built as a module).

Tested by Alex on a 100 Mbit card. Not yet tested on 10 Mbit
cards - if any of those also have the 16 bit IO feature set
in their config table, this patch series would break on those
cards. 

Note that only patch 3 has been sent to netdev. Please CC
linux-m68k when providing comments.

Cheers,

   Michael




