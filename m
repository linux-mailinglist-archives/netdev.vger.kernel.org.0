Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEAC4F41C7
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385387AbiDEUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572954AbiDERZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:25:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142A917049
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 10:23:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso3252017pju.1
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 10:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ubdsl+3Wx0XjW33LpVSFk2qbIEg1vrruDt2RMQvp1A0=;
        b=YxLqhW/G0XfRfDU5OB6qVRbThYHxlsjt5jKh843tAh+opmFAHU1Jgxk24cZdmaof/f
         THwFOkEBSdtnVY8pAAKOiw8zCGzR8tzeRg7uTn5VTX9VlGBVEyaoP4t/6asM5x6D6tCv
         0MObnXaxm1D1g+ltExuiGuYaXPuHU4LzMlxYf+MaBMYJ+XkRyBaT3UMN6fYrfb+jms3u
         UEDItqjOvUgj1f3dDi1ZYLCiigFzzEcRrtkGPKX3z3Ys9nUq8A+8Equgjtp0gw038D02
         8n8R4B+Scu1oOmAmVPVIWH9FeUsm9dQOUyu1myVJw7w4gXphGcqjTj50mEnt4iyv68bN
         XYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ubdsl+3Wx0XjW33LpVSFk2qbIEg1vrruDt2RMQvp1A0=;
        b=vANZ24B4mgQk8uckHl9qntkAngji0mISSFKTNwqZoewI572aWedwEDfaKlvgVe/fBb
         C1gsnrjYVo1M8jCQJhhulnaC5dzpVclmywT85G59ZU783iHYSG4MUKqK/MoCw0e+UR06
         bYB/Hedjq3eus65ElAHIIAmVHt0/lFrg2ba7k3KsWE/5/ytnvBGuMufhVRKMS/gcSmjB
         Twv++PXGFGN5QlHpzdZ6xHJ4WoSEX7u2qur4n6bO3nDTRDPBRCZ4isIxLfGUO8w2iqE5
         5KxPNrCHChF+XAbh2xrBKZZ4RbkizJNygLyC0aAFbYfQspaSMc5qjFk4vUDdIWWW0nOQ
         d/aw==
X-Gm-Message-State: AOAM533DZUJ0+jjlpgNVl3qnUdOck4dU9nB4++3nixRUfP3sCNTwPYyt
        YI0gJP8HJCkwMYrhJ93D5Oti2oXPAexRxQ==
X-Google-Smtp-Source: ABdhPJxBER2qZU3ip+9xoFEiI6bMGH/ZKTcHnI480X9rTu8DppSvuQQgfnyhRwkri9Sm+rUsDzLTiw==
X-Received: by 2002:a17:902:da8f:b0:156:3b3c:b128 with SMTP id j15-20020a170902da8f00b001563b3cb128mr4784674plx.50.1649179434093;
        Tue, 05 Apr 2022 10:23:54 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oc10-20020a17090b1c0a00b001c7510ed0c8sm3431747pjb.49.2022.04.05.10.23.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 10:23:53 -0700 (PDT)
Date:   Tue, 5 Apr 2022 10:23:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215793] New: ip netns del is asynchronous??? -- very
 unexpected and puzzling
Message-ID: <20220405102350.61dce151@hermes.local>
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

Date: Sat, 02 Apr 2022 12:14:36 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215793] New: ip netns del is asynchronous??? -- very unexpected and puzzling


https://bugzilla.kernel.org/show_bug.cgi?id=215793

            Bug ID: 215793
           Summary: ip netns del is asynchronous??? -- very unexpected and
                    puzzling
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.106
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: rm+bko@romanrm.net
        Regression: No

Hello,

I have a script like this:

  ip netns del test-ns
  ip netns add test-ns
  ip link add tun-test type gre local any remote 8.8.8.8
  ip link set tun-test netns test-ns

As is, the script will fail exactly every other time:

---------------
# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

# ./nstest.sh 

# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

# ./nstest.sh 

# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

# ./nstest.sh 

# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

# ./nstest.sh 

# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

# ./nstest.sh 

# ./nstest.sh 
RTNETLINK answers: File exists
Cannot find device "tun-test"

---------------
That's because "ip netns del" seems to return without actually finishing to
fully delete the NS. Adding a "sleep 1" after the first line, makes the script
complete successfully every time. This is a very unexpected behavior. I would
ask for a better workaround than "sleep 1", but I believe there should be no
workaround, and the script should reliably work as posted.

Hope you can consider changing this.

Thanks!

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
