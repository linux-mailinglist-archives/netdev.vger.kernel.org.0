Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC01358D21
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhDHS75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:59:57 -0400
Received: from mout.gmx.net ([212.227.17.22]:59457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbhDHS74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 14:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617908381;
        bh=ACaf7fD1w5/ErWPoxpnmz/5mR26p08KdZl0zdMQuz6E=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=BFA7vtWoBiqtpadtPK2TjCMxcJZ3vDEDTL2QZz9RxzYOy76Z0/CZe07Q4Ir34V/vN
         5jbkEhKJ64n++dJZVUNJUfZGMO8i4kOuUyLKdEKSOu/JYVIlH/7mDemPCNH2Yv2g2U
         GqUU9+clVSFO634ZMFeIZMQxj7YNPA+92rRB3U1E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from esprimo-mx ([84.154.209.189]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZTmY-1l6sd03jio-00WRwc; Thu, 08
 Apr 2021 20:59:40 +0200
Date:   Thu, 8 Apr 2021 20:59:39 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org
Subject: [BUG] Strange vlan handling on e1000e
Message-ID: <20210408185939.GB9960@esprimo-mx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:8yhMepaSnPLrmhqK7AIEi9h+L5VC2ocDXoKg6tEim0BNNqfV88t
 D7woyekJGt5FvW4MV1bnUicwYyRGR0CUyySgrhkjZ7q8g0m2f56Yt5xS2Iqj7lea3K4/bmI
 rdkJVpyb+DOz3QEPPOrD4iAYqfoF9EIXDiaEkEk3Pyyl8xjLbMlOHFoxU4bTUii2rkqMYaQ
 LfJhNOp0oVwi6jJWm3Fdw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:T8pwuucko28=:fD7eDs4zGewVTs81KZkwX/
 UNQRFhEMZFGJe5OGNMBjH3w4cWF/iI5EqEYdTmq3cNFaafGTTidU4zHgEIQemV94HzShzOK2W
 BU2Qqmv1kgIihzSJPpb5+2EXVocqLFn2wrryyx5+/yb+rsTUAL05JOUigSxeXcq9yTiTAcIjb
 Qur/bUes19gLe2PPrhFLdrOlTGM0FTTfBavxaBaSe73ZuAWgaYcHnGTCCRmCNHb8gViHgmG8A
 b/9d4ucf4JI5IAh6lFnrSGLChwcQgYiP+Ah8/8n1i/jI7QCQPhRuowrEIpS9N2KxAZNU2ToF8
 SOr2WqrSYIPClr+EJe5Ydj20UQ0HRjh5qMkkXowWZpa8Qs+9KOSm5YyfSvnG1w9N9ZduZHr8B
 PboBsI/J4tTMaqy93sGDezQaOgYOgd9+olUFyLTrplQypu4jmbfu0IBHLTCerIawu4SUdGqym
 xrgdOHvJq8vicrg+CNDkSEOjpJ7sZE0lRupdU0ept9Un1gjUK/qO8BGKG4/Ge22hjVWmEvj2G
 lV34ab7mOzUgdt1yNXSs5gnzSeIhBglIhEaEtpdTH39ecUI7Ax+z9vDGd+ABkm9hgkOXZXP2B
 DsPh4ZZjUP2jZqJe+aGGiUG4COWvRa/HI5tbE0Fl2sDzL7KRQ6CRHt0ODexS1mALCTh1ydmbC
 nsETGjtt4iPX9hbvKHWz2KFn63RxkWbrPKeYAaNiyjzlBhsD/YHQv0PB+sYhiTJwlvyzWdZw5
 AAx6zmZbbkFbUXeqNXGIcChQ1+rd+/KIseJ3S2mAzjYoyCARbo6T7/YNJQRI+gLkBD9mipcmS
 krg4MIggGR7qDYTeq/13cto701sw8TT8UUs5GUp8P0/vYrMcCsnhVW7+siGZhqxj0HO1mntwp
 WhA+PJBSrE0RUc+nKKkF6T4Zv/N/r7ulJXTaBBiLYntRB7rTyVNuOgDtvdUD25DV0D1Yw6EaE
 SiW2cULzep3hJjGWEGD7US0XyA85WgifJfzMWokbomU7lsdeD/4Hn34t1cErv61MC/KzF5U3s
 0htF7ripO4HIUH3TH3ZryGCx5xSFx0DKCFGU7AyiqCow3zqYNldHfnpRltkUWgzp1pQguvEia
 qHvlHHFL0sgd+t8giMRH3uCX4vYTC53fiK97k8f5y09/55PuEpMCYOXAAIhzeVLFnWQiSdn7J
 QJ5PdCYELqK9jPUEhQyaWjUMCL8KUC6Y7A2s1KqPsDkYtEPorsQS7x1pKShLWgc7lNOyQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a Python script to send max sized vlan packets
on a BCM4401 nic (driver: b44), the Intel I217-V nic (driver: e1000e) only
receives packets with a maximum size of 1514 bytes and reports a
length error for the 1518 bytes sized packet.

When sending the packet from the I217-V and receiving with
the BCM4401 however, both packets are received without errors.

This still happens when both sides are directly connected
thru a single ethernet cable.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212613

hostnamectl | grep "Operating System":
  Operating System: Debian GNU/Linux 10 (buster)

Kernel version I217-V: 5.12.0-rc4 (net-next)
Kernel version BCM4401: 4.19.0-181

Python script:

from scapy.all import *

pkg1 = Ether(dst="FF:FF:FF:FF:FF:FF")/Dot1Q(vlan=100, type=0x8000)/Raw(load=b"\xFF" * 1500)
print("1st lenght: " + str(len(pkg1)) + " Byte + 4 Byte FCS")
sendp(pkg1, iface="eth0.100")

pkg2 = Ether(dst="FF:FF:FF:FF:FF:FF")/Dot1Q(vlan=100, type=0x8000)/Raw(load=b"\xFF" * 1496)
print("2nd lenght: " + str(len(pkg2)) + " Byte + 4 Byte FCS")
sendp(pkg2, iface="eth0.100")
