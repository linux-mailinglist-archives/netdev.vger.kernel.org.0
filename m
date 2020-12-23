Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5730C2E1A07
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgLWIeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWIeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:34:14 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFAFC0613D6
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:33:34 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id m23so14476164ioy.2
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aZf41MxSmOt5HkKMJB/5PJAzo3xzo9r5GX741OJeV5Q=;
        b=dpFbT1IggIpm/oQ/SxcYlWexWQzzUsknd+J95cBzJD6tsIXXpBX5rQ0RqEgmyTjSjk
         7cpDqy7aPu0WhcpI2+WBY2lUuXoDNZXmrc352TlZsCmKAw1PSjMSQcB/37EAocqrKYc1
         i4eptjcsRiRpzZM7pArj68+u9RFy6lQhjKaxeLUU1WgLVt+l19V3JZON6Xya9B2FtYqg
         LP9ULttS1ft9zB2xVbN6xMkvvs3W4nai817fe612oqIQIcaPjpO6FCtxIbENkRfUwfDn
         OdtQRu8NQpg0KcBKze7XkZh4IgehIFPiXgD8+ujakLthxRip+h+quj+SJsGVF4AaCdxh
         y7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aZf41MxSmOt5HkKMJB/5PJAzo3xzo9r5GX741OJeV5Q=;
        b=RfNbvoruMcxwTOmbrJFn9AHCxCooNRsIxrtpjy6dBkMHaQZ2d6Y6oixR/mul3zBeL6
         QHOtLEd2xfEaAz/YXS+V5vxhpvf1e1LLdmQexageWqUavLVzdguy4VSDnIGriTIivp7j
         /DMSrGALPXcexmjR39o4a63mHebZMybBpnbz302dsnih3m9czPgWNd1zfjaXeJ7ABopd
         hzFIcYIT1GvUT44js9dpQN+jiCc6T1CXpJVWa8Nd3DwHRGIMCcEXu/3EVZ8WjgC2EOrV
         pYejD7Fa3kOzaGlV9RQ8q2jMwdw4zuDg0zihC3KRkKh8kw6YGOhM6Cm2BJHHinXIKGmj
         3aew==
X-Gm-Message-State: AOAM531lnV81gKOiEwMVsM6hjwRUvbV9WhghO2Sel3mfynHfYT+CdSok
        EKMAWiaDaIrHxEULviyWNcM+pfwbTdgCnQHbIw8=
X-Google-Smtp-Source: ABdhPJyczfMsVqB+9xsfyHzj7X65F6ZKjbsTQeH8JxAS7snpntdf6RGd5SWKp1F3tL6IzOKi5/uuwONdqv9kb0ffocE=
X-Received: by 2002:a02:8790:: with SMTP id t16mr22293192jai.80.1608712413471;
 Wed, 23 Dec 2020 00:33:33 -0800 (PST)
MIME-Version: 1.0
From:   Bruce Liu <ccieliu@gmail.com>
Date:   Wed, 23 Dec 2020 16:32:59 +0800
Message-ID: <CAHZX3B-g3grHBcD6dRf9P6TBeoHMXWybdSRfi_nU+xNnS9RUAw@mail.gmail.com>
Subject: "ethtool" missing "master-slave" args in "do_sset" function.[TEXT/PLAIN]
To:     mkubecek@suse.cz, netdev@vger.kernel.org
Cc:     shlei@cisco.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal Kubecek and Network dev team,

Good day! Hope you are doing well.
This is Bruce from China, and please allow me to cc Rudy from Cisco
Systems in China team.

We are facing a weird behavior about "master-slave configuration"
function in ethtool.
Please correct me if I am wrong....

As you know, start from ethtool 5.8,  "master/slave configuration
support" added.
https://lwn.net/Articles/828044/

========================================================================
Appeal:
Confirm and discuss workaround

========================================================================
Issue description:
As we test in lab, no "master-slave" option supported.

========================================================================
Issue reproduce:
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

========================================================================
Environment:
debian-live-10.7.0-amd64-standard.iso
Kernel 5.4.79
ethtool 5.10
Source code: https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-5.10.tar.xz

========================================================================
Troubleshooting:
root@raspberrypi:~# ethtool -h
ethtool version 5.10
Usage:
        ethtool [ FLAGS ] DEVNAME       Display standard information
about device
        ethtool [ FLAGS ] -s|--change DEVNAME   Change generic options
                [ speed %d ]
                [ duplex half|full ]
                [ port tp|aui|bnc|mii|fibre|da ]
                [ mdix auto|on|off ]
                [ autoneg on|off ]
                [ advertise %x[/%x] | mode on|off ... [--] ]
                [ phyad %d ]
                [ xcvr internal|external ]
                [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]
                [ sopass %x:%x:%x:%x:%x:%x ]
                [ msglvl %d[/%d] | type on|off ... [--] ]
                [ master-slave
master-preferred|slave-preferred|master-force|slave-force ]

root@raspberrypi:~# ethtool -s eth0 [double tab here]
advertise  autoneg    duplex     mdix       msglvl     phyad      port
      speed      wol        xcvr

========================================
Review 5.10 source code:
ethtool.c line:5616

static const struct option args[] = {
{
.opts = "-s|--change",
.func = do_sset,
.nlfunc = nl_sset,
.help = "Change generic options",
.xhelp = " [ speed %d ]\n"
 " [ duplex half|full ]\n"
 " [ port tp|aui|bnc|mii|fibre|da ]\n"
 " [ mdix auto|on|off ]\n"
 " [ autoneg on|off ]\n"
 " [ advertise %x[/%x] | mode on|off ... [--] ]\n"
 " [ phyad %d ]\n"
 " [ xcvr internal|external ]\n"
 " [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
 " [ sopass %x:%x:%x:%x:%x:%x ]\n"
 " [ msglvl %d[/%d] | type on|off ... [--] ]\n"
 " [ master-slave master-preferred|slave-preferred|master-force|slave-force ]\n"
},

========================================
ethtool.c line:2912  do_sset function
There is NOT an "else if" to catch "master-slave" option, and the
options matched final else, and print an error message   "ethtool: bad
command line argument(s)\n""For more information run ethtool -h\n""

ethtool.c line: 3069

  } else {
exit_bad_args();

========================================
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

Look forward to your reply.

Cheers!
Bruce Liu (UTC +08)
Email: ccieliu@gmail.com


Cheers!

Bruce Liu    (UTC +08)
Email: ccieliu@gmail.com
