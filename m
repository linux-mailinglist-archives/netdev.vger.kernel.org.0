Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6110A4B5887
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345282AbiBNRaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:30:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiBNRaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:30:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD86652FF
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:30:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p6so10889607plf.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=tWeBivdFQWK4tciH9zAFPTd1KwaCUjbhdlyIMnERNgk=;
        b=i7sK2qM0nbMfqz06BCEnFNidC5HNdyW+Qk90n4ktUjiSqBQxsqVVTChKaSNzoM5r0M
         h5VLXLwI+YYYTYvk9LhNpYkuD8PWSsgGJ6YJ96jGYNpTJVMwo1N7Wqvlx55Sn3BJRDLA
         CpxgGXULJHK7KU2bL6lFNwCEjVmSHO/kP1QI9/raHr82T301SmEyXNzt9C2X8wbHRcju
         xFgGvHGxtscilYML2YDEX5V2z9Sk7+NyApRuD2jWFhrll3qHAIjqPH5ZplQIYu5VV/sK
         m/WoUoT3+XUr1bac0dHcQU65Txu9NXRGzI/gQf9mMKtP5Q/I9gLsuqhs70Kq2kzYgjIJ
         cDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=tWeBivdFQWK4tciH9zAFPTd1KwaCUjbhdlyIMnERNgk=;
        b=1yNeaWd4v3Ycnrm64sIM12GTWOZWROuqd1IF1B2k6v57yZyzKrJ8bQY/dugB+cqpkj
         gDuWs0+83zq8zt534GJgbywjJVuhsPMJKIVCDQa7Vcj6TDqj7BVRM02iQ3dLayQ4PLHJ
         T5PSbNcnakA1PmKyYTTwPXP2ksuJCLomfIQpJXwk7UU1eqzCPlsWxTQc+I68q7M71UVE
         4LPmZvWUpiUAPNgkYOm0oezkiGlAZYqwh0tZT6qnIrlX9ZuryE3KiZW0V5y2ueO0lBHP
         4ND0wotgvoEJy6Xp+a0wokqxIPFrrp9xyHiUJjxJ+v+OfJ1ccgUUv6wmawFhDP9baLr4
         L5jQ==
X-Gm-Message-State: AOAM530kaIeJaDAvUr63Zd5Oj+Wkm6sApOxYcPDU4JwL/5cZK4OIjtYX
        9t2CeRrTE5ILtiQxWLpBFId70cpOR/36T4/0
X-Google-Smtp-Source: ABdhPJyBmJqJfgv7BWaLR9G4cOcSFBNg7KGyy8zCY+ZmcPuQtO35cgFFU/oPhIZ7tofZa97L26nAQg==
X-Received: by 2002:a17:902:b185:: with SMTP id s5mr18752plr.123.1644859811299;
        Mon, 14 Feb 2022 09:30:11 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id hk13sm1758306pjb.30.2022.02.14.09.30.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:30:10 -0800 (PST)
Date:   Mon, 14 Feb 2022 09:30:08 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215599] New: System freeze after add mirror rule from
 traffic control
Message-ID: <20220214093008.7e8f9cdd@hermes.local>
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

Date: Sat, 12 Feb 2022 21:16:42 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215599] New: System freeze after add mirror rule from traffic control


https://bugzilla.kernel.org/show_bug.cgi?id=215599

            Bug ID: 215599
           Summary: System freeze after add mirror rule from traffic
                    control
           Product: Networking
           Version: 2.5
    Kernel Version: 5.16.5-arch1-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

The rule:
tc qdisc add dev eth1 handle ffff: ingress
tc filter add dev eth1 parent 1: flower src_mac 22:22:22:22:22:22 action mirred
ingress mirror dev gretap-test0

System freezes after creating the rule from container.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
