Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17057563CDD
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 01:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiGAXpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 19:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAXpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 19:45:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F76D34672
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 16:45:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so7890594pjj.3
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 16:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=bSBitXyDccTLwrXztXhaLay1MS75tLZtjq9n/4/voy8=;
        b=3EvQIzhxCSVl0huKsLwS3z+lVsUxpldF2s3Mi3RP4oAkbV9wPFNJbsqDlriVSSvEjR
         thttQJ0FPFTGGqDv0tg/AJh5Tz+8C90Fqk2bA79Bnwv6RzHYOdffGTFArNr6SeM85qvM
         gmsf8qSGwhnEID8F9aZQREIvF56lRMwoxrYoFF+lRfZCYJSZnRhV6pss5+/gMAYrJ2Qt
         rZuaR1LGm1EaajuIQWf0xvO3wJKhMvJSI9OGIecxMDEJWd/2Ca8Pf+yUUuftBOPiiV6t
         /hcSYVfNqtTYTQW2HOSVCbhhjXpR8gGUD+i8wjwccDnikW2OoCupGctVLvj96Ci1buhQ
         cV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=bSBitXyDccTLwrXztXhaLay1MS75tLZtjq9n/4/voy8=;
        b=bT5lJlFgE3pValIODg7AAVvHW/aBzXIcCKImW77zJCAyLsDvH0NNITgJ5In6KbfZsX
         r7991ljChqB5L08hMQnjBDrg0QXHblB6YoMP/uLfGtuWZGeUmOMorSfIC3br4Nvmm8Wo
         yyY8WAEwoMLb6dp8RIfB9V69M8uxJrfKsTcXI9eU3JlHpKjpT+E6voexD0Zh0sCIQzu6
         hSVe6MNPj2NYHfPN3Yz3TZTIkBouCfXVt3VudpawZD5IEElWw1J1AXpfYnGvDB9c0AKa
         QL/f3wCzEAcvSvESED1OJlOlM3SQw3Q4jGbuC6iTc2vlf4ufjXoWalsX7sK20bR8Sdu7
         7m2A==
X-Gm-Message-State: AJIora8qkkf8J0G/GZD8v5A1nq8haQsjy3v2PBC8yNEsiPix96L7jb6J
        845KZd+qu7Y3txhi1AmLnaHcjWdk3rJT2EEc
X-Google-Smtp-Source: AGRyM1tflb2QgzyJRczgkLIqY+0wxUGxFR3T+N4+rPPAIkO+fyUtVo9tiIA3qJFt2Y+m6IdyIOeUsg==
X-Received: by 2002:a17:90b:1986:b0:1ec:71f6:5fd9 with SMTP id mv6-20020a17090b198600b001ec71f65fd9mr20688296pjb.188.1656719109724;
        Fri, 01 Jul 2022 16:45:09 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f15-20020a63e30f000000b0040d376ea100sm15965302pgh.73.2022.07.01.16.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 16:45:09 -0700 (PDT)
Date:   Fri, 1 Jul 2022 16:45:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 216195] New: Maxlinear GPY115 UBSAN: shift-out-of-bounds
Message-ID: <20220701164506.78266ebe@hermes.local>
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

Date: Fri, 01 Jul 2022 08:26:11 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216195] New: Maxlinear GPY115 UBSAN: shift-out-of-bounds


https://bugzilla.kernel.org/show_bug.cgi?id=216195

            Bug ID: 216195
           Summary: Maxlinear GPY115 UBSAN: shift-out-of-bounds
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15-5.17
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: cedric@bytespeed.nl
        Regression: No

This is related to specific (wired) Ethernet IC: Maxlinear Ethernet GPY115B
The network interface does show up in ifconfig but is not functioning, no
ip-address is assigned.

During the bootup process I get the following warning:

    UBSAN: shift-out-of-bounds in 
    /build/linux-WLUive/linux- 
    5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
    Shift exponent 40 is too large for 32-bit type 'unsigned int'

This results in the following error:

    Maxlinear Ethernet GPY115B stmmac-3:01: gpy_config_aneg failed -110

The specific kernel I am running: 5.15.0-40-generic on Ubuntu but also tested
this with Fedora Server 36 running kernel 5.17.
Config: CONFIG_MAXLINEAR_GPHY=m
The module is installed here:
/usr/lib/modules/5.15.0-generic/kernel/drivers/net/phy/mxl-gpy.ko

Additional information:
https://askubuntu.com/questions/1416068/how-to-enable-maxlinear-phy-gpy115-drivers

Datasheet:
https://www.maxlinear.com/product/connectivity/wired/ethernet/ethernet-transceivers-phy/gpy115

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
