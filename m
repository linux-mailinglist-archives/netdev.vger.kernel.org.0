Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D4D202379
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgFTMDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 08:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgFTMDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 08:03:32 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27172C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 05:03:32 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id x93so9827125ede.9
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 05:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Dgj7xtgghQX2S4oTqz71PRtEqTIg9EgJBqD4lmnSiBY=;
        b=iebmLr7dnPlA27mcGXpTsFqcCKzsVwJSraZEn1h7imHmOoxgXJxlYZUsUW2n+TT1LU
         /9668crEJFuyQRreCuTxmcCiVyWByIGzIA2dtxUJrMdm/zRYttbroC1lkLJnidx+jgp1
         eaSQzNsWZ4t6NpilOgo0oRFjbD/0tpXa4zcn0rFCsh9rDQREOrkOJj9GZfJ+GmnVzwTM
         J7ccndZB90zlMknmkowWyjrKiMkab5aBPKyT64fsLEEbgM0KgyD9QevwH2Sk7Z5AyUbV
         XCuWztpZNIrn4pEIBkM7phOZWy2P34DepW8ic13vWU4SC38+A/uoZgr/hXjgikyLeXun
         c+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Dgj7xtgghQX2S4oTqz71PRtEqTIg9EgJBqD4lmnSiBY=;
        b=uD05y5C9Fby13BxeDuO0c2yqSqeLMjbsLpaK5rUizD3mHlwjb2svuXffIA95vtKiZl
         jJhEudbPk/i+2g3zPQFKAQTSZmzmXCeMK9LxSp8prQrKZz3jjA3mWzw0BzeI/ZHsxcbH
         8v7OrrjuQS4jcDJyyQ7ign01WOJAfDDM0O5BSRM7NuhMP2vth4QyQTi1CTZzYWTA1wfJ
         4JAt23jc8a+rBOjTVB2UuemcklMdAo3oopPnFT2frgAQmrlRvfDjACsAAEzKDf8Qd9JG
         fDyscbX5SDUKjKl3SnvJ5HAHyOKNxut8IGUglZQOoB9TNTyr8Cs2jVfnJrYhppiAnglp
         GgJQ==
X-Gm-Message-State: AOAM532+9X3vdMlGoW5u9GL9MCPgjRKwXgTJsnytLjWAeFXFBNP5zZcr
        8zJHm1unpWQveUSZn/Z6lsqdJ6esjaSA5si1MW4=
X-Google-Smtp-Source: ABdhPJxWoB5lBkWp7DF/CF9gZbQLRxGPGAEX5BLEs8a6/9AS29FiP5R1FnVBsjFG4nr+DGKI805eHsD2UExRIvjzQus=
X-Received: by 2002:aa7:c6c7:: with SMTP id b7mr7828082eds.213.1592654610665;
 Sat, 20 Jun 2020 05:03:30 -0700 (PDT)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 20 Jun 2020 20:02:19 +0800
Message-ID: <CAMDZJNXW-SsgYiw8j1b5Rv8PhfGt=TxZZKjCPzsQWiADjy6zew@mail.gmail.com>
Subject: mlx5e uplink hairpin forwarding
To:     Eli Cohen <eli@mellanox.com>, ozsh@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eli

I review your patches and try to test it.
$ tc filter add dev enp130s0f0  protocol ip prio 1 root flower dst_ip
11.12.13.14 skip_sw action mirred egress redirect dev enp130s0f1
or
$ tc filter add dev enp130s0f0  protocol ip prio 1 parent ffff: flower
dst_ip 11.12.13.14 skip_sw action mirred egress redirect dev
enp130s0f1

TC can't install the rules above. The error message:
mlx5_core: devices are both uplink, can't offload forwarding.

So how can I install hairpin rules between uplink and uplink forwarding ?

The test environment
kernel 5.8.0-rc1+, the last commit id:69119673bd50b176ded34032fadd41530fb5a=
f21
NIC MCX512A-ACA_Ax
FW 16.27.2008
enp130s0f0=E3=80=81enp130s0f1 are uplink rep.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3D249ccc3c95bd1bca17406b5b3d0474fd67220931
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3D613f53fe09a27f928a7d05132e1a74b5136e8f04
--=20
Best regards, Tonghao
