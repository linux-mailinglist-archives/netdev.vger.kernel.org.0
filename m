Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812CB510109
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347662AbiDZO6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345957AbiDZO6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:58:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E354D64730
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:54:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j8so30429945pll.11
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4pWgIUWm1vfKnCS00ipYgE1UCM7LlZXoPChVAV9K9vY=;
        b=0Wk6YM6v/RR0D2QCWZIQgKAwYwkSNFSv+QC2Vx/n/HS4vhh7DR7kTdOIeA9ZFDRNrV
         HEYXbBuOqM5ywOx20JLN3bqMJNV/V4qtZdO2vsCmZghR8BDoIXoRLzSrPuyCCVSoDJLf
         p4smos+Io7NPYc7Vggbn8k32+jBf1nOTSHU5dxQmkSm16XfrOhag8npe2nFnbLZbbQVG
         JR+PL7oYBv9FaerHvEN9AOv3PNR/1XwMgsqfW59tZj1J/1OQRw8PPgC0fjp5jqYdUuok
         bIpXawKvCe2hUcDKiLBNFourxf3Qx+aDQfSMSL+eoyhrKsi219f7UE9OxfwUI920mENB
         RLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4pWgIUWm1vfKnCS00ipYgE1UCM7LlZXoPChVAV9K9vY=;
        b=oTDzpHlrAc/xyO3e7X7w2bv6rneV93FTVIi2LhEPFso/90obJrj1hNHSKWuM+b8LaS
         9nkNtv1E4yt0OJ/yhA9/woNXRET9BijXJRSmkCP6LSThLikEldoZGHJEAj+pTqJQ5xIw
         araylJSP4/EGNTfXvW1zdUl5ouimdswtDvC9qecurfC+Qc+P2GmfxZAbvkCwZbVeRd3Y
         n9RLVmfFdxAhLAayotE15ypr85J18vQggHlnRDFYdGc9EjBBgb/tUVbwzdbAXOoIE03y
         /Ib4tdmHxDFxslfeAYlj5Yg2UaSeG5dDFcTSD2eZGTKV1OwMT8uqtJ/M3t9QdrnqVkfF
         VW+Q==
X-Gm-Message-State: AOAM532V9Qk6UF3w/6ho0CQ9DE2yvFr4UZRmtxSq4D5E0o6dA1iJF/2W
        WcXK2/3aqAGbzf0tkmMK9o6DyL5kG27bGg==
X-Google-Smtp-Source: ABdhPJyIQathj/0g5cUjqqFJg+FZxvWpVpM8gxDyURWqXHpy/Gj1mK3PM48tWDyDx+KKQZt77rMCUA==
X-Received: by 2002:a17:903:32c8:b0:15d:3359:ca53 with SMTP id i8-20020a17090332c800b0015d3359ca53mr4657772plr.173.1650984892013;
        Tue, 26 Apr 2022 07:54:52 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00088a00b004f7ceff389esm16579491pfj.152.2022.04.26.07.54.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:54:51 -0700 (PDT)
Date:   Tue, 26 Apr 2022 07:54:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215888] New: raw socket test with stress-ng trigger soft
 lockup
Message-ID: <20220426075448.037015eb@hermes.local>
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

Date: Tue, 26 Apr 2022 09:31:50 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215888] New: raw socket test with stress-ng trigger soft lockup


https://bugzilla.kernel.org/show_bug.cgi?id=215888

            Bug ID: 215888
           Summary: raw socket test with stress-ng trigger soft lockup
           Product: Networking
           Version: 2.5
    Kernel Version: 5.17
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: colin.king@canonical.com
        Regression: No

Running stress-ng [1] with the following raw socket stressor triggers a
softlockup on a SMP NUMA x86-64 system:

sudo stress-ng --rawsock 20 -t 60

kernel:watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [stress-ng:49781]

Tested this on 5.17. User has also reported this against the stress-ng project:

https://github.com/ColinIanKing/stress-ng/issues/187

[1] Stress-ng:
https://github.com/ColinIanKing/stress-ng
git clone https://github.com/ColinIanKing/stress-ng
cd stress-ng
make
sudo ./stress-ng --rawsock 0 -t 60

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
