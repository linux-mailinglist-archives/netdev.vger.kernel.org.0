Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9C069BB53
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBRRum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRRul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:50:41 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2811C14EA3
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:50:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u16so1083447plq.0
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qq27IcDWxYMd2k/IclolrkDcC9+ud3EF7JeSblElt1M=;
        b=WDNve3CyAdTAqwRGUNK6qz2xVNmtv7dNqMtQXO3BROMhz9Jat/35aa5mCDuQMdCgW0
         yL/ulDkeK6QeABE2gRf4tuitJtEGzUahBBLq7Rwa1L3Qo8A63xb4FrYSnmIy7/+njAAG
         jm69WsBv7jMHBWScgYjlQ4ZzKRGiGSnTIps8Ry3Z0bwLzQPTHcKQYhdYFju/DE0V1qzP
         RbHej1+vx9LgUoGdcps98tukFLrZG/pEDSV4WhFDdmjeTP8BJZAhg6mjHoZXP5qAqexD
         y8oEwn1PqB/QWgoUjEPO8DOlwmzfP1fzRKXSnd9BzZQf0nmASXfgiEtmXKMk5Wv/3Vek
         MpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qq27IcDWxYMd2k/IclolrkDcC9+ud3EF7JeSblElt1M=;
        b=4epfbiGfTuWVqB7/Hq6WwaH5G0oZMLMy8uyDBCt5CQEbHbHgHokb5V0D296v6O8yiQ
         28UHSfPgSA5R4erbs50mR4So/lEB3pbnoB0Z5rzQJ2X+R+XW4s9CdFlg0gHvbBlU7hLs
         hCI7HXi5qELkj1RDlLpJtGZnOaGTlgJ72xgOxlPI1YAvf/hTKvQlK32045Ae3ebTUAHJ
         aEciYYZ/TaQmHlTXGz/xr3fVThFxV9r1nCjq6NfVh3Su+eW/qaQ67TS/R/a3ICW0icNN
         +QtKy3nt1ra+7ogXG7hZyfYiLX6/omZFEl0AfUbhwWXxaT3SdOkudUFuD+uvoToKJb9H
         7zmg==
X-Gm-Message-State: AO0yUKXSvjTMgqLAQqhsQrIQS2CiCG6fXrmVuNdtmO88zPO/e5EQVHUy
        YHapdmliQIWFSxf3aHIBm0edUYDjLJFQIpQGh1k=
X-Google-Smtp-Source: AK7set86ySsTtb3UyepZekRtBC0qLgMEON/Z9CVvk8H0I9lI8+L/DxLBo1IpsHDflvv+0bCDtFN89g==
X-Received: by 2002:a05:6a21:3391:b0:b6:a9ad:a07f with SMTP id yy17-20020a056a21339100b000b6a9ada07fmr5178019pzb.27.1676742639321;
        Sat, 18 Feb 2023 09:50:39 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s8-20020aa78288000000b005a83129caeasm4890712pfm.185.2023.02.18.09.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 09:50:39 -0800 (PST)
Date:   Sat, 18 Feb 2023 09:50:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org
Subject: Fw: [Bug 217054] New: wireguard - allowedips.c - warning: the frame
 size of 1032 bytes is larger than 1024 bytes
Message-ID: <20230218095036.7c558146@hermes.local>
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

Date: Sat, 18 Feb 2023 15:49:26 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 217054] New: wireguard - allowedips.c - warning: the frame size of 1032 bytes is larger than 1024 bytes


https://bugzilla.kernel.org/show_bug.cgi?id=217054

            Bug ID: 217054
           Summary: wireguard - allowedips.c - warning: the frame size of
                    1032 bytes is larger than 1024 bytes
           Product: Networking
           Version: 2.5
    Kernel Version: 6.1.12
          Hardware: AMD
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ionut_n2001@yahoo.com
        Regression: No

CC [M]  drivers/memstick/core/memstick.o
drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
drivers/net/wireguard/allowedips.c:80:1: warning: the frame size of 1032 bytes
is larger than 1024 bytes [-Wframe-larger-than=]
   80 | }
      | ^
drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
drivers/net/wireguard/allowedips.c:67:1: warning: the frame size of 1032 bytes
is larger than 1024 bytes [-Wframe-larger-than=]
   67 | }
      | ^
  CC [M]  drivers/net/wireguard/ratelimiter.o
  CC [M]  drivers/memstick/core/ms_block.o

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
