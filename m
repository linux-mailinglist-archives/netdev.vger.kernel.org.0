Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5041A92C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbhI1HAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbhI1HAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:00:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E9C061575;
        Mon, 27 Sep 2021 23:58:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x8so10676140plv.8;
        Mon, 27 Sep 2021 23:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BwYDNkutK0VTKbZJlZC2cc82BEAakFwtmD1VrfQ7VWk=;
        b=cc6Oo/K38bWzcm9WaUUaIgdXmV5qUQp3QDiwWukcZOsgyxPjA4va0lwwHK9MjcsPDT
         kuY+8ZvrZqmQBA6K5s1jpks67PmiloFVcKAuGVQ5Hgz0TmKxy0fOtNUUJh+t50qYkkxH
         ELTUOtff6A/lIBnW0pi4FJ6uZ5LVm984Zl88217xGpn7He5ZJuslQ2Jlvo7WkSW63+Fz
         YTDb7aNctAiSFF5c3X3zkFBKa8vsGHOgtFPdhzvGckAlFvZZpS7kkN9ADSB6HiYy1Wx1
         N9k0TpEP+J/lztE653gHHMSyfKP1SlTowd914iK2n9yGVwZo+6C0/ngbnvXyRp68camq
         zGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BwYDNkutK0VTKbZJlZC2cc82BEAakFwtmD1VrfQ7VWk=;
        b=15R/w8lioRgN3TksLtUs6iH7l4m/4dJ8QQj5f2W+eKhBDpn+RAmAe2TvmZKNJ6Fmrf
         UeikwfsN0FrKTPk75wZ3ghsYo1GytNU+eiZrOg68wy4rhxT9u6itz3zNUftciQj2nCyU
         2D2xNgQGbp61qpS7FTDLt1/ir7EUKJHZ6P9RVgtGTmmB0M2T3+55pb/GUSTf9t81EqfH
         6HVbD5dnRaXKQmpfmzrXPiTcZXntIuSzbfV3gsKIiIGQGy97if6CFeI6aQ15lcBsPFjT
         tB7vtPF1E8M0TLbOFvueNHsx10N0w/uzwLIMWwgez1+P3fdO1HOmztRX2kLHQ5RyoMN+
         i3Hw==
X-Gm-Message-State: AOAM530QmtMRM/w+/YCZnzUkQjPBxxWH8tT6OsZKNruiAR6KL2Jq1A/9
        m1vQ0meugbTQTIfJ4XfKcFJrgakrdac=
X-Google-Smtp-Source: ABdhPJz4tAIy+beLy4Ytkp22JKiNMQj0GWXMhjQr1cRVT0cJXuaKlBFbDbynKqkQADWnQjuVzQa7zw==
X-Received: by 2002:a17:902:7613:b0:13d:c6f0:1ecf with SMTP id k19-20020a170902761300b0013dc6f01ecfmr3678873pll.16.1632812335360;
        Mon, 27 Sep 2021 23:58:55 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-4-20-adsl.sparkbb.co.nz. [222.155.4.20])
        by smtp.gmail.com with ESMTPSA id e11sm15588000pfm.28.2021.09.27.23.58.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Sep 2021 23:58:54 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id DF2BE360424; Tue, 28 Sep 2021 19:58:50 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v8 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Tue, 28 Sep 2021 19:57:43 +1300
Message-Id: <20210928065825.15533-1-schmitzmic@gmail.com>
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


