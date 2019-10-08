Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A039BCF242
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfJHFx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:53:28 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:44073 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJHFx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 01:53:28 -0400
Received: by mail-lj1-f174.google.com with SMTP id m13so16095444ljj.11
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 22:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=29QOWLpIxYs4qy8ChI29dnolLm4aD63WfXw+ok9IUrg=;
        b=Hw7w6xSbbgZn7OWhnK71TDFwxel8WnZfwwrZy4+o6cGpRxe7BpDT/G/4wRfTrpdZZR
         i0486zKrBmW0yQGHgHzV2t4Qy8QsyJZ0yLCFxi7dvHJlk9fB8FcsDFZi/hn77vmCkFRh
         1G07tV+8Aiukav+7pzidVw7p9ebisifYoSFhn+7lWSf9pEKcUHSHR0LLq0PEIA6U0+/j
         AIybq2Ivl0Koffx1y26jmYbp/5QsxtngmSrCVnmck1JcoVxdong62j9sw6jEzzf/964u
         p4fIJgdDju+n+zYJiyMIi8KNO36PkcWXjK2n5qvocBELr+FD1O6GyaY/LQWm+jE8sTZs
         R8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=29QOWLpIxYs4qy8ChI29dnolLm4aD63WfXw+ok9IUrg=;
        b=R+fRswBVzjBHN6iVdQuVcQU0CnCzBqFjb/9FrswOcTrqqWNM5z7hHxk8mAx/VtSv/z
         6DIZzDWDTlf/2By/KkHfxxc3lp61Co0+Pe+vPO6Gp6GNeDg9gU5lq+KT7jlsjGe7lnwU
         Guw49SiakmqNe8QsjPbERJGftkyH/WYdXACD7kQWSwILnPBXTLdAPUWkiVXFFkMlef5e
         pcRFNOdf2LTWcqF1MEm5JDF8xtJVttbuhhn5nlbI/tFpXhCMb6qlDwfvN1DIk0HXoPeW
         y/gGhZMuF1DHVLn1GTQBPnag2R28vD+vvEiTNFxjy+eneHLBuPeh3dU0TepwqD0AyDcG
         jvXg==
X-Gm-Message-State: APjAAAUBTcibotoJ4CS/kVb3GS7TloZSpQR/U8cM6lo0aXjPke6s6aaM
        8+tSeeFvkOzKxa2OEE7Gnz88aNSByufOe65pC9o=
X-Google-Smtp-Source: APXvYqyfJAnxZjxXkH3+gAaRTGYb+6TDN3ElD9cz9zbFB5YgGq1JIxgyhWbQZLue4un6vwa2fXhYajVPtif+HuuwJS0=
X-Received: by 2002:a2e:1246:: with SMTP id t67mr20009845lje.174.1570514005119;
 Mon, 07 Oct 2019 22:53:25 -0700 (PDT)
MIME-Version: 1.0
From:   yue longguang <yuelongguang@gmail.com>
Date:   Tue, 8 Oct 2019 13:53:13 +0800
Message-ID: <CAPaK2r_T28BqvOkjDSD=SR-5sKeD_HgHu1tvB+b1jR20FuU0WQ@mail.gmail.com>
Subject: ingress bandwidth limitation for ipv6 is inaccurate
To:     kuznet@ms2.inr.ac.ru, stephen@networkplumber.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firstly, thank you  stephen.

Hi, kuznet:

1.  according to my test,  bandwidth limitation is inaccurate for
ingress ipv6 .  The accuracy is affected by burst.   if rate is less
than 100mbit , set burst to 1MB or 2MB, the result is almost
acceptable.  but when rate is bigger , the result is approximately 1/3
of rate.
command:  tc filter add dev qr-869fbdc2-1e parent ffff: protocol ipv6
u32 match ip6 src any police rate 500mbit burst 1M drop
so except for using ifb, what should be done to get a accurate result.

2. can flowid option of  ingess's filter belong to egress's class.
for example    tc filter add dev qr-869fbdc2-1e parent ffff: protocol
ipv6 u32 match ip6 src any police rate 500mbit burst 1M flowid 1:10
 (1:10 classid  is egress's qdisc's class )


thanks
