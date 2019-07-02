Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B395C994
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfGBGxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:53:20 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:44625 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfGBGxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:53:20 -0400
Received: by mail-lf1-f53.google.com with SMTP id r15so10521910lfm.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 23:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lYoLfJol9XmcSJWRD6WWKz2YJJETKYJWHTap/SLO9ho=;
        b=djx+dHBqqZU7CcNQG1qMG75MQYGljVK1zkEa3aSu2Jx01bBth1joUL1MjMMIzrrL77
         k8tp2Y4Vv4+DlKTg+gKoet9IjVDjiGonzC2RSoxI9mMbcEgNhBIltDj84ZUv+55TNbpW
         KmK/zrWkky6k5dYlOaBof57AS0rLRi6CkU+J/HkfYawC03wsPCojrtbPjKXzlphHxSZf
         AXPKj7sZQ1WyFlAQpJRbF2NIsqwQ5sS4OwecxSak+1JYyH29LpJqmGbNDTK3hvzlOyTx
         DLUbqJICDOpqWqtcs2hLDLMmBjvDToD7S7+JKgoJZ+kWIFXNM8ttArWHlliRb8uLeDfW
         2ewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lYoLfJol9XmcSJWRD6WWKz2YJJETKYJWHTap/SLO9ho=;
        b=NgmUebi8bS0pXsF6ZKfKuYa1NhnIFovMROSdLFfr9UeSz3QoKS2KLVNGkV9+0QdjYS
         /rcpNzlEAUERKnwu+qGwdMagP7fCcXZzmJBxWMqOywymelvpqpgs9dH2BXXotAROAhRJ
         S5mTg/5kIGnS8FX2SHFuNl4Fc+n+RGzC4i1OlcxyHSU+XmdpCOy/7w+1affdB68CZODo
         Fl0QI0cYAsX3qHQVTVIiz2Gojn4k2wRPrlYhRctnXoaNwaoSqcwUVcyTJLBK5pysWNb1
         HPOSGqpF/HECIef4Qo2L9l2xwQQBLvbTe1Y0GLDv3x8eXbrbWRxLuNvuz0JJcMOsQDri
         9nHg==
X-Gm-Message-State: APjAAAWv7GhX04rlOFNZo/KSPg2HXb5wc1VKxldMMm3yCl6HP1r/A+Kk
        u2pBuB/aSMvwDS17kTyjCPvxDEKF2mQpmqDN6xT9y9Ot
X-Google-Smtp-Source: APXvYqxKjKaipDbotRq/7gW4Rfr5oEQfANuKj6p69yjHDYcQ0UWnFc6DpVjLK5pX+E4r76ePo5Rt9oXDzpbmIwmq5FY=
X-Received: by 2002:ac2:4ac5:: with SMTP id m5mr2508116lfp.95.1562050398101;
 Mon, 01 Jul 2019 23:53:18 -0700 (PDT)
MIME-Version: 1.0
From:   Ji Jianwen <jijianwen@gmail.com>
Date:   Tue, 2 Jul 2019 14:53:07 +0800
Message-ID: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
Subject: [iproute2] Can't create ip6 tunnel device
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello  there,

I got error when creating ip6 tunnel device on a rhel-8.0.0 system.

Here are the steps to reproduce the issue.
# # uname -r
4.18.0-80.el8.x86_64
# dnf install -y libcap-devel bison flex git gcc
# git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
# cd iproute2  &&  git log --pretty=oneline --abbrev-commit
d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
libc and kernel headers collision
ee09370a devlink: fix format string warning for 32bit targets
68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
e4448b6c ip address: do not set home option for IPv4 addresses
....

# ./configure && make && make install
# ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
please replace eno1 with the network card name of your system
add tunnel "ip6tnl0" failed: File exists

Please help take a look. Thanks!

Br,
Jianwen
