Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB384E65CF
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351201AbiCXPJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbiCXPJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:09:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375863EBBD
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:08:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w8so4976650pll.10
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=KVMloc/kbPOlh+fhcenGG2fkM8L2VPd09yHcL/R62pY=;
        b=P3Ax/+Jl0I/phbXxlX5LA09qVadoXyy9ja9NQbtN5d9Y/jzitCCnKrGqPgBQmd1wUD
         A0eaoLJNF/VIdw4OVLy2RPy/aCU5tQx7/lVbGFbipYDCiQzW0SEp5wFTJ5Y/05evWw/s
         fS2XXrtN2n6q++xtNN60zkbm5UG655jWuUFXrE/VmBqDwQWNaMyw/jog0E86HEwtaGhM
         mH//ElA8VYvsKVTuDoOByWMjRoEM3DdDqyRYrrzviMXOVxli3RhpDF4wKRCGmZL/yLtL
         IhtJc4i0kVYV6Xff3+Dqcs8Oh92POVh8G+S3yLHJkgwLFOf5Ev9X9sne6h5i4SLcHZ76
         IEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=KVMloc/kbPOlh+fhcenGG2fkM8L2VPd09yHcL/R62pY=;
        b=he6ILcq3SMSnG5Fpj0tKpcFj3PqqPwHQF2mXlc0hdrvJI03n5DvmGpxZY6tjYPsUkR
         YvTy2UrmvIyF12jmu/1TJCwDSPz7mdcY5q6lbKUMyxt7yMCgKrBHN4pSfmlc6D36DZ40
         eqOAeWDmMAarkPileK2cGDbEYA/haL3ELZqCswinH5dFrXa2cYbyDYrgkhvWIBP7sntT
         SoTBa5J5RvEiAt1zOTq4/NWoK8z7yxW2B27DdA4ma5tLB03aLqGqtTCRbzF9K+0s04zX
         E98Itt/ADZWJ9L9w42JtiGzHs0QlrYB17xPjHQwJ2yHMdvi/xWXKTXdV+0A/ORkQ0xXu
         3rAQ==
X-Gm-Message-State: AOAM530nfah9n9uTqZs49i/QMRqr5PEIDY84UY8hETrCGJwE8a9D4mF/
        x0mdIFK3EsMMn3dwFVD4brx4rH7zD85OPg==
X-Google-Smtp-Source: ABdhPJzghkzypx/8hXSuCG3pRNtPuES7747UxhGFeOnMVuAj66v1zbLjOvrsZxUoSZSVQJbqORAjag==
X-Received: by 2002:a17:90b:1811:b0:1c7:832a:3388 with SMTP id lw17-20020a17090b181100b001c7832a3388mr6892360pjb.40.1648134491456;
        Thu, 24 Mar 2022 08:08:11 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm4058168pfh.177.2022.03.24.08.08.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 08:08:11 -0700 (PDT)
Date:   Thu, 24 Mar 2022 08:08:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215739] New: /proc/sys/net/ipv4/conf/*/send_redirects
 doesn't work per-interface
Message-ID: <20220324080808.3cddbae4@hermes.local>
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

Date: Thu, 24 Mar 2022 13:10:51 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215739] New: /proc/sys/net/ipv4/conf/*/send_redirects doesn't work per-interface


https://bugzilla.kernel.org/show_bug.cgi?id=215739

            Bug ID: 215739
           Summary: /proc/sys/net/ipv4/conf/*/send_redirects doesn't work
                    per-interface
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.154
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: luke-jr+linuxbugs@utopios.org
        Regression: No

I have some custom routing rules that ICMP redirects interfere with, so I tried
to disable them by writing 0 to /proc/sys/net/ipv4/conf/br-lan/send_redirects,
but this didn't actually work. Neither did it for the bridge sub-interfaces.

To disable redirects, I had to write to
/proc/sys/net/ipv4/conf/lo/send_redirects instead.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
