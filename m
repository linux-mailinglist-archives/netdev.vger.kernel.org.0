Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4156A51E96D
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 21:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354169AbiEGT1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 15:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiEGT1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 15:27:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449B9186E2
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 12:24:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id iq10so9851359pjb.0
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 12:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4JllaSbKzwV4Zb7/di6eagqNbKmEq6iBesM47u3Axck=;
        b=GSWUM4ZFjx2G5Ncct88NOfjRZD5mM/fWtqAsTc/PlaEdugZ+//zSz499WN6nrXFFRa
         bWc5YvDPUAOGyJj9rSrx15F78EKzyYDckhU2ii1LopBOTA62G8qoo6ixBTIw+LMzKtA6
         2fBvAfTChkc4Zz6XcqJ1hWw8octWcje6rAWrkNxtkv0ZKsd0ffQbXfgARjb7a8nYnI5f
         6pHciAGxuenoEW0BB0visKThwO/cE4ONV8T/36N8OXaOiCGc1O4nAklzR5ZOKTjMfE7o
         r+OGtICVJKHl+YIHSwdBs1rbB1a/9GBnDp2Nw28F+3xwuj2T/VbGjGbnvLWrFPvW2cK9
         ChMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4JllaSbKzwV4Zb7/di6eagqNbKmEq6iBesM47u3Axck=;
        b=BApbz62/G1tZracixPJLKeevqxysQXzUXWRFqN+DU/cJjNrSG5yjDTaGEhqMMR7dLn
         +IA2WYLUt4oRdUsTmgbTYQYD5CyS4m7xflo9Sm2iTGyC6YQe/569nyUSGDFQtIJ+b6IV
         S0YAaRI6f5kdN62ZxFFQjfYxDHdMFzQOjvDI/Xli0xkPsMW9kc7tLuF6cQNAnuG8ZEyT
         wObZ3uYIqxxtsrIQrcM/hnV9PhtSSiCwG75enWWsZM+z0Km4qMxvkRP5evoyx6zQGm82
         ucuMO1BJN8sj1K4Gvc1EzH7ZsHHD2kbVq1K7nbvsuiwq/fU//YA2bF2U7P7ZBIkzLSaq
         66NQ==
X-Gm-Message-State: AOAM533uO4rHCTDHQ4a5jF32qtWaryFkUQdIs8X9kwB03TiavkvY/ney
        14SPtgLkWzBU7fO3vSj70OUwaGlgZbsu4Q==
X-Google-Smtp-Source: ABdhPJy23uvpnKx80lYAItcCHf3L9p05kFRq7j1wihNCMJOjfo44iDsCL9fCVGJtZa6kflou7DTSzw==
X-Received: by 2002:a17:903:32d0:b0:15e:8cbc:fd39 with SMTP id i16-20020a17090332d000b0015e8cbcfd39mr9547989plr.95.1651951444488;
        Sat, 07 May 2022 12:24:04 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id fz16-20020a17090b025000b001dbe11be891sm9470278pjb.44.2022.05.07.12.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 12:24:04 -0700 (PDT)
Date:   Sat, 7 May 2022 12:24:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Fw: [Bug 215950] New: bonding: kernel oops due to possible race
 with wifi adapters
Message-ID: <20220507122401.477d6bb5@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 07 May 2022 06:24:29 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215950] New: bonding: kernel oops due to possible race with wifi adapters


https://bugzilla.kernel.org/show_bug.cgi?id=215950

            Bug ID: 215950
           Summary: bonding: kernel oops due to possible race with wifi
                    adapters
           Product: Networking
           Version: 2.5
    Kernel Version: 5.17.5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: smopucilowski@gmail.com
        Regression: No

Created attachment 300899
  --> https://bugzilla.kernel.org/attachment.cgi?id=300899&action=edit  
kernel oops syslog entry

Trying to create a resilient bond with a wired and wireless interface
(https://wiki.archlinux.org/title/systemd-networkd#Bonding_a_wired_and_wireless_interface),
in which the wired interface (ethernet dongle) is spent majority unplugged.
systemd-networkd and iwd are used to manage the interfaces and wireless
connection.

Downstream bug report: https://github.com/systemd/systemd/issues/23255

Kernel oops can be triggered reliably with the systemd-networkd configuration
in the above downstream bug report. On a debug kernel, where kernel timings are
a bit slower, if oops wasn't triggered during boot when systemd-network handles
connections, then restarting iwd and systemd-networkd almost always triggers
it.

The oops appears to be a null deference in bond_slave_state:
include/net/bonding.h:242 return slave->backup;
which suggests a race condition whereby slave interfaces are brought up or down
during bond initialisation.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
