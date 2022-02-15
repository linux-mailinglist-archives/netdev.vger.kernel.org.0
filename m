Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5424B7B27
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbiBOXWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:22:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiBOXWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:22:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382EF9E9DF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:22:37 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so746837pjm.2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=iXMJMLf8Lj2ZbSgpQjmpfd9PHiK1C5t09Xb+ZEaiUQ0=;
        b=NrLBzErf9CdS3i0EYctuPOHPwUMgwHkdj9CvxFrgunJsmMKGD51hF/XWAo15S0MWZH
         WL0OMF24LJNGhoFtsNatGfjBIIm5ymp530qPF6GUjErq5TGQsDNUB8i6/D/i9LjCpWMi
         3PP3n7+JvVO0sn6xM4Qfp46lpluqMADeqtr0tzQCqNl7/pOCVZSRX3XTqNqNZUOmFx0h
         YIWroC5kmQETecIXANMpX+iQgW11cemhIzFYafNJVEr0OG/PkuKk6lTibs3aE8Qkqhzv
         zLyMpshBKzasBdgAJtQHdoEg2B+qVmmmK2OqaghQO/LjpXEEUPKMIGPmWYrswHqvX8dV
         wdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=iXMJMLf8Lj2ZbSgpQjmpfd9PHiK1C5t09Xb+ZEaiUQ0=;
        b=N0HQTfaiiyg+EzWsGqqPjkyDAcDruq6krCUknYaOJDBdYS0R96SAYvEahvoMX5k8KM
         0rEjHGg3RE37su/56qA3taYDHFwIUC269wIgyV3rhVQkNlxUkrz2Tuh0lb5P5rk7IKRf
         aozj0cDA6aeAr8aEu2Ze3UO8wdN4N+UmJtgJRr5tDVZ+7aFHmBJ3SAQaL8gqmfFlHL8t
         QOtaSOvRbhg5HA4M9t665P9m7+4k6HAjRY5jFWf+SS/hyIL2DnIUc3DiAu/in2ATJ6Sh
         BKstiF9B2XxLXK8C67HORjTvydWQivt6jg15LbTdEFiLph1bAJ3Q0GXEKgFVKq3XUVAV
         dp0Q==
X-Gm-Message-State: AOAM530Wi9AuHOXHXRJe4M+96tLdBz1mz8IDG2Lw3Q1X+7UDbF/aZC/0
        5buMrkSwEErDh9JafDADLqitwNoxRlNUqaXy
X-Google-Smtp-Source: ABdhPJwUZ3XefpjG+55KHRT+MLYDAmKbGQdSHQn1oR3I7D+tUwJRDwskEzIlunYyEZGCHgAe/mb7yg==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr1302174pjl.5.1644967356452;
        Tue, 15 Feb 2022 15:22:36 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id b14sm41661279pfm.17.2022.02.15.15.22.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 15:22:36 -0800 (PST)
Date:   Tue, 15 Feb 2022 15:22:33 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215610] New: eth0 not working after upgrade from 5.16.8 to
 5.16.9
Message-ID: <20220215152233.2c15de26@hermes.local>
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

Date: Tue, 15 Feb 2022 16:24:06 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215610] New: eth0 not working after upgrade from 5.16.8 to 5.16.9


https://bugzilla.kernel.org/show_bug.cgi?id=215610

            Bug ID: 215610
           Summary: eth0 not working after upgrade from 5.16.8 to 5.16.9
           Product: Networking
           Version: 2.5
    Kernel Version: 5.16.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: joerg.sigle@jsigle.com
        Regression: No

After rebooting with kernel 5.16.9, the eth0 connection did not work any more.

The interface is shown in ifconfig, but ping or other services don't reach any
machines in the LAN or in the internet.

I've not done much research but went back to 5.16.8 which works well again.

In 5.16.8, lspci shows:

00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-LM (rev
04)
        Subsystem: Lenovo Ethernet Connection I217-LM
        Flags: bus master, fast devsel, latency 0, IRQ 33
        Memory at b4a00000 (32-bit, non-prefetchable) [size=128K]
        Memory at b4a3e000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 5080 [size=32]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] PCI Advanced Features
        Kernel driver in use: e1000e

Kind regards, js

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
