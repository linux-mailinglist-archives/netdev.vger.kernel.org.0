Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE71B69F74A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjBVPCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjBVPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:02:36 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC60D3C78F
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:02:08 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a7so4785270pfx.10
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tm6xG8JfMNlACz3Z4WQaEwpm/LYsVoYoz6gh2ffitb4=;
        b=ClWXH7hQnxvxO+aARaZ+EVeO0qhhaTkKFDSr/R8iIj8013GhGTu6XXFs+blp9k6050
         aSRqm/dgp03G157X6xBcnf1+9T66R6volK9XcqmaaEqW7f1TrQ37zptGeRdipNNFi3JD
         EeSqov7hrQMCKbaONMNz9DwPibfqtoEDvZXVHlLfzuJ2QjtxnCJborx5p4Fgyzu1viC+
         xqLzW1B+yJ+Lb1rQYP7plB1WR97cRAXaXdykj5X+5TTL/mJ360961aOonL2LIOAdn8Cr
         aZPug/wdFctVaA4Bnl8DRz0E3LXwK6nh8EHXX6ewdq7EG+SlXYcsEs3Sur/dBVXijt80
         pc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tm6xG8JfMNlACz3Z4WQaEwpm/LYsVoYoz6gh2ffitb4=;
        b=yX+I41A7M1kSWABTf4hHwn3IL2RkMrxq3JwiFtrc7Nep2vqMXMXYMR/pm/tG1Fzpxv
         blxHAZmO0qzzE99eBYHpsoleNfZzEGztH3DkhURDHaTCOKIv8Hgofr2eQG+bDI/I+2dj
         stqB5eoHiWNhWbTwfXbzdqj84cH7awHQdTd2tv1ALhswtBqBEQqzQKnYJoqPCgOdS137
         ZW3WMl+3s62HcSpKuPPJQaRJbqEblN4EXRe2iaV9XyW/W3tcVZfn4mchZOIQiCBpTCi4
         ScmGqhdPKEdN6j9fLjm5XUIH58dkxlH1ZVc7Kaq/gj9P4eXElAoU+8HZBZF3dIGrmdGZ
         AHWg==
X-Gm-Message-State: AO0yUKVOjGuI2SxKAH3XJIEzRZFovDYZ0Jj/ziesgIgn6Sq+/r3XrnxM
        qH9/OLx2Q2sL0VRA37vBLwADUg==
X-Google-Smtp-Source: AK7set+QA+hD+OeOa6oOjIP5ACGj3vO7RRttoNWs82ys6N2DCOqXbQdZPY02A4b/Xk+oMs5TqvJpoQ==
X-Received: by 2002:aa7:9424:0:b0:5a8:cf20:e35e with SMTP id y4-20020aa79424000000b005a8cf20e35emr9062878pfo.3.1677078126843;
        Wed, 22 Feb 2023 07:02:06 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a5-20020aa78645000000b005d22639b577sm2265651pfo.165.2023.02.22.07.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 07:02:06 -0800 (PST)
Date:   Wed, 22 Feb 2023 07:02:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Fw: [Bug 217069] New: Wake on Lan is broken on r8169
Message-ID: <20230222070204.2548cd99@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 22 Feb 2023 00:51:52 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 217069] New: Wake on Lan is broken on r8169


https://bugzilla.kernel.org/show_bug.cgi?id=217069

            Bug ID: 217069
           Summary: Wake on Lan is broken on r8169
           Product: Networking
           Version: 2.5
    Kernel Version: 6.2
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: iivanich@gmail.com
        Regression: No

After upgrade to 6.2 having issues with wake on lan on 2 systems:
- first is an old lenovo laptop from 2012(Ivy Bridge) with realtek network
adapter
- second is a PC(Haswell refresh) with PCIE realtek network adapter

Both uses r8169 driver for network.

On laptop it's not possible to wake on lan after poweroff
On PC it's not possible to wake on lan up after hibernate but works after
poweroff

In both cases downgrade to 6.1.x kernel fixes the issue.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
