Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED8F44D02A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhKKC6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbhKKC6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 21:58:49 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE645C061766;
        Wed, 10 Nov 2021 18:56:01 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s136so3926352pgs.4;
        Wed, 10 Nov 2021 18:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=utH4NsRTGI3SXTve3jR0Gx/lRa7o5xgldewRMAF9dOM=;
        b=K7FkTuxv97bMzZk9dm4vosTsFN3Ydx6PSYbd1pkK8/su3jciA3Qef87mI3w3IxczQg
         HpdinVYkz/twV6F2PHcaGB5WGGuhRNc6HZj0WbB4CzJIhezcpuhvx2rDltypxrioaG5c
         xDa+TL+0HEA8jR9p/dRCUENABveB+/ZUwyK68WLu+kogRtlPyvyS6hIF0UVqfCU+6gth
         pUmLgD5tLpKS8RXTqDx6t6I8bP9yPOxONyaz6GOsa1V8h6GcpQMlUpECBudMvy/8gzGl
         OYjsoDN07SNunmLiky+2COPbDnI9TTystCvVHOHX0UjJj/2JsOWz8MwyiGtUedUzjOpx
         4uWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=utH4NsRTGI3SXTve3jR0Gx/lRa7o5xgldewRMAF9dOM=;
        b=j1Bo7CutNs28uKnWzWYMhDMGaOIdT9Ttb5YfYPYFhWiak234H67AMsEP6zrZ11D87j
         tscrddDY6gbVNw0w3YcQ1kW3CpoKYWnDdNAdyUxo1Ij3LbU9P36FNgnzZBpblptt3uO+
         j2G0pv+D7JClxStGs8PjkKfW4x74C2lfvpbsX7mqny9VgYFaARPHN/A5cnwhcVX0jsqO
         rSYUoKaNrOH8vjSBiZiS1DyX4PEpXu4OBWxG+FiMk4p2nb6OT/7qov7OlNK0wqnXMg3h
         wUClBAHh/NgJz7MlFONitfekpopIAM3/Ir4Qy/hqtODBxumtJInZRhElbvklzSOTdDPR
         dbCg==
X-Gm-Message-State: AOAM531qD6Kj85Y6N4MLv/Iz4tj9s7+BQBERDUgkHzrjCWcJXF0LTtu/
        KzeVkp3C/nlsYHNLcMRYcZs=
X-Google-Smtp-Source: ABdhPJyNXug0MWFCgNdfzR5zscba5UsfOmxBP2lwn086vlx2RrrqD9pegc0pB8rFK+29Tjo6tA79oA==
X-Received: by 2002:aa7:81c2:0:b0:47c:1d4:67f5 with SMTP id c2-20020aa781c2000000b0047c01d467f5mr3714854pfn.38.1636599361240;
        Wed, 10 Nov 2021 18:56:01 -0800 (PST)
Received: from xplor.waratah.dyndns.org (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id t8sm727994pgk.66.2021.11.10.18.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 18:56:00 -0800 (PST)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 64C8A36030E; Thu, 11 Nov 2021 15:55:56 +1300 (NZDT)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
Subject: [PATCH v10 0/3] Add APNE PCMCIA 100 Mbit support
Date:   Thu, 11 Nov 2021 15:55:51 +1300
Message-Id: <20211111025554.26768-1-schmitzmic@gmail.com>
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

v10 addresses review comments by Geert and Randy Dunlap.

Cheers,

   Michael

CC: netdev@vger.kernel.org


