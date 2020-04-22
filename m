Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D946D1B48F2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVPmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgDVPmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:42:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671BEC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:42:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t9so1103104pjw.0
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=TpMT6BEBkzudU+fyGrfR6ecfTgYd/EzbYbaPafE1rTA=;
        b=wPVLVTzUtWy3Q1++5vy2rzh1nSS1nr9MsX34akI8HsFi5OdC3I6YXfBgAfk3D2y1+i
         1HtSKyIZxZEEI926EHhBdxJBZEDmTYJBONdGKeEduXj3McBIoBBu3srH16mdh93soymR
         /LxdHe5X2zd6V0/iWYVkfufjKWrJyaUdK5TJWAsfoy5WFz05BFToM+2Y1Nzrm7umudY0
         a6UUxdpuDJMvv2g9eqvWw23KT/WnAILxcvUU7Xz17z76gRGCGqi4pYT10V/IrdALHkvn
         grl3LyWRuTLP06QJnve4HB+ycSFkMyX8x+J8Puks3eOg2fCPP93oErv0YlGiv6MbXXP0
         EOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=TpMT6BEBkzudU+fyGrfR6ecfTgYd/EzbYbaPafE1rTA=;
        b=Xl6PhXHrHQrQkLPYhK0mrHdk/3+tyk34uP7j3xTCYYrkv6A+OuXJB3BZ146Gs2IAWQ
         85GV8iAK89pAbg6lG0HqqBh30zlzq6UR2LZdiGtz2UBVMcnv4flrF8Pg1y/Xy1dinx+t
         1bBTLXg83d9ZzlpYiiHw+cRKcejfRA64WftCRwk2n7s6i6DsmFmfw7tj7Im4T3LiV9CS
         QBJ5vPi7wVqy7br7Tjn3icFUXAMCYAu9qyByJoLvGZBYsqXRX0e+8D477F0Rn8S++BU9
         WMQMvDfY+kevDEIDIDouOu38MbFbLggw0D2Bbn0iiP2bRu7NZXFIjdpwd0GtaFv53UYy
         Wtcg==
X-Gm-Message-State: AGi0Pub2rgWnXxRe32Uj1wPudWuokEiNBbZvuEavnvNV0yb4NgtKOO70
        NaOacdCA7J2CuZp/lClTySQpaF6L/hI=
X-Google-Smtp-Source: APiQypJG2Jv6uavSRxgmIgdMFNuiQ2upZRwPh4begpnMxtUbw3dZLj703bLGO3xBSqzpn1Ct/81Zew==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr12524305pjs.196.1587570128342;
        Wed, 22 Apr 2020 08:42:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g1sm3585698pjt.25.2020.04.22.08.42.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 08:42:08 -0700 (PDT)
Date:   Wed, 22 Apr 2020 08:42:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 207403] New: Object freed twice in cleanup_net in
 net/core/net_namespace.c
Message-ID: <20200422084200.3b342fce@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 22 Apr 2020 12:47:34 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 207403] New: Object freed twice in cleanup_net in net/core/net_namespace.c


https://bugzilla.kernel.org/show_bug.cgi?id=207403

            Bug ID: 207403
           Summary: Object freed twice in cleanup_net in
                    net/core/net_namespace.c
           Product: Networking
           Version: 2.5
    Kernel Version: At least between 4.14 and 5.4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jmarcet@gmail.com
        Regression: No

Created attachment 288659
  --> https://bugzilla.kernel.org/attachment.cgi?id=288659&action=edit  
dmesg from qemu instance running openwrt

There is an issue regarding network namespaces on OpenWRT.

There is some locking wrong in kernel's netns subsystem. Starting docker with a
bunch of containers is a game of luck, they can start cleanly, but there are
good chances the bug is hit, often crashing the entire system. I attach a dmesg
grabbed from a qemu instance which shows it clearly.

I have built OpenWRT with a vanilla kernel, and the issue still happens. It
might have to do with the special user space tools not used in any other
environment. It has been happening for at least between 4.14 and 5.4, and the
issue is in the kernel.


I hit it with docker. Using docker-compose, with some image building, after
some time I get the oops in the attached dmesg.


I have verified it happens on x86-64 both bare metal and under qemu, with and
without preemption, with 1 or several CPUs.

Since I have not seen it in any other environment and you might want to play
first hands with it, I am sharing a OpenWRT image ready to use, a little more
packed than the official ones, with docker-compose, kgdb, ftrace,... It is for
x86-64 efi systems and runs fine under qemu.
https://openwrt.marcet.info/latest/targets/x86/64/

If there is any more info I can provide, please ask.

-- 
You are receiving this mail because:
You are the assignee for the bug.
