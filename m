Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50C61BEFCC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgD3Ffj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3Ffj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:35:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA91C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:35:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so2363887pfx.6
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A0r9QSn7vnAN5Sqka1HU8c5yiecK6DY1tg0xwZUaG0A=;
        b=MSMsMpOkyNd7gtK+7mXz6+/5XlqLhvoHYmBKOCYvNKKRdMY33JTS7dI9Es+J8M7oCR
         7EAMRNH6kd16mbQfNC3muTO0KPm7AI07ystxKoPiBt/N5TyCnE92RGWh539oYeVvsTql
         Du+NYUeOJLfbdp4cBVL5CC7lTjMQJPgPe/Tulmt8qyTWR4uVgPQ6bd/JAUdpFmnYiSUj
         aayX+hxdM2lcAqjTP1oBMIMevX9Rd+AcCVrPH9HMgPie1WZTyybfT6lLnNT4j6otkzAd
         kkPke/t5tpPX3LxCLuvO8XtG80JtMqfnB/6VVw4YcLuS7uyKDHZCmXB04lHzjW4oHNMP
         UtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A0r9QSn7vnAN5Sqka1HU8c5yiecK6DY1tg0xwZUaG0A=;
        b=S5vH1ra2skg3InhU2zZVpvw3h7QjkKCSNHw8dKyvThgZ5lBLBxqRExIjcvn1SBX4WB
         2h8KP/5p0GG/JZjU0Yv+0A+Xv2oMVmzGq232uAVj2AV3C3kcolQb7jWoy8xXHdsnjw6N
         2c5Th+LPiWba1KaO3f4YsqwVCgUiJn6uSo2+AYBuoOCi9xS4zuISfcO4BzE23bLntXhB
         m5kmFx2fWtLATG9IUXb2AoFitD8YEZE0l+IjGFxviLkrmmEz1Bqm8NDqUhRjCn6jGj2o
         /fkW2jOnUDvGoBswZpKDDKelyPvbME2qoyeXpdeM81dN3fRgyipjOTRC8e4heX3QYMmH
         pRaA==
X-Gm-Message-State: AGi0PuZFXIZJym09vveBfWKb553ELw60hw0eElUbPUrD73nYNliJIrXT
        lD0cR+G7muiKxRsJ1eFOLZQMXA==
X-Google-Smtp-Source: APiQypID/ps7fsdHk96xxQClCqlfdppa6M8QqLMXw4OMSdm0tqtzufOqBFRs6wUmCX2aCWfb/IEX1A==
X-Received: by 2002:a05:6a00:d:: with SMTP id h13mr1891910pfk.254.1588224937722;
        Wed, 29 Apr 2020 22:35:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n10sm179087pgk.49.2020.04.29.22.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:35:37 -0700 (PDT)
Date:   Wed, 29 Apr 2020 22:35:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 0/7] bridge vlan output fixes
Message-ID: <20200429223534.6f72095c@hermes.lan>
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 08:50:44 +0900
Benjamin Poirier <bpoirier@cumulusnetworks.com> wrote:

> More fixes for `bridge vlan` and `bridge vlan tunnelshow` normal and JSON
> mode output.
> 
> Most of the changes are cosmetic except for changes to JSON format (flag
> names, no empty lists).
> 
> Benjamin Poirier (7):
>   bridge: Use the same flag names in input and output
>   bridge: Use consistent column names in vlan output
>   bridge: Fix typo
>   bridge: Fix output with empty vlan lists
>   json_print: Return number of characters printed
>   bridge: Align output columns
>   Replace open-coded instances of print_nl()
> 
>  bridge/vlan.c                            | 115 +++++++++++++++--------
>  include/json_print.h                     |  24 +++--
>  lib/json_print.c                         |  95 ++++++++++++-------
>  tc/m_action.c                            |  14 +--
>  tc/m_connmark.c                          |   4 +-
>  tc/m_ctinfo.c                            |   4 +-
>  tc/m_ife.c                               |   4 +-
>  tc/m_mpls.c                              |   2 +-
>  tc/m_nat.c                               |   4 +-
>  tc/m_sample.c                            |   4 +-
>  tc/m_skbedit.c                           |   4 +-
>  tc/m_tunnel_key.c                        |  16 ++--
>  tc/q_taprio.c                            |   8 +-
>  tc/tc_util.c                             |   4 +-
>  testsuite/tests/bridge/vlan/show.t       |  30 ++++++
>  testsuite/tests/bridge/vlan/tunnelshow.t |   2 +-
>  16 files changed, 212 insertions(+), 122 deletions(-)
>  create mode 100755 testsuite/tests/bridge/vlan/show.t
> 

Most of these look fine. Resend after the the first patch discussion
has resolved.
