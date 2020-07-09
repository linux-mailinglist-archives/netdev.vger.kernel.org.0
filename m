Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9815021AA0D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgGIVzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIVzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 17:55:37 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECCCC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 14:55:36 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u25so2055981lfm.1
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 14:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id;
        bh=ogmun8bal6Sg8ieLmA+ufB/uNgG4eBF77U3DnvC9E/8=;
        b=RnMownmfepZ3l675ZWafZz0nfw/AP7mdc77Qt/0ZCk8ikRcyDtBBn+AIuaRk2KJ8qQ
         FuCrpqcutKvG2eHzpGZwauZjA0t3v/CqkAUh1DUQ5o3th3HXqdryXv6PCNK8gz808SdE
         4E6VI9lkhbajJ6tLI4RZtmG/7KKEHgLx/j+bGT6mbRnCcjRAFMFH2H62X5DGsN8yTI1q
         2Vo/TjE5HQLpUGR27m4mui7dFN4b24vUAQHZmgaCKj8SX9laeleAEe+cnjWPBYOTQrWK
         Bqwld/Esn4SuZUCitxJPJo+rSB4i9JXhxnz+l+XPvpgEtDB5OhSHxwKbsWbgVrJx+bZk
         OCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id;
        bh=ogmun8bal6Sg8ieLmA+ufB/uNgG4eBF77U3DnvC9E/8=;
        b=sUR1Ggp1ksWFmq28xQ7qgI2HAKDPW04K6iVOF6Dv5SpzGnhdKmlwDcTNTGUkitodDE
         QioqY8qGhW7oq0g9paOHq72htd2oZbLKdTT38t6yEO/0CM30pldvvpqdXf+NH7Ax0AwN
         7eSOqo5/MROdZQSUfYA80oXUjA4Wc+z/BQjOENmDcfZX5+zYsnFG0SVc1hKTkxAyRouC
         WHLqBXQlv0u2OV+BT9ECfdRt5Olw+MUPT35Sy6Rl2TUzV8zvqHooSGnjpHd8NnVIp+7B
         8S+MYIXUTfI41TwA1gTGoiXb40OjCw4JAZrFDfjSUX6SMZ+nQhD/669lOdD0cXQZsqys
         +qrg==
X-Gm-Message-State: AOAM533N8nNDpPLN+dMuA4nuyV31B4hb+ySX8UBaXeNqG1IU6SMRmaEH
        vz71xoKSg4o2cDm4MkV9UwWhuoyH2lddpA==
X-Google-Smtp-Source: ABdhPJy30aZwj0JOhX1ZfxbX2IzzcEVN1i1n8rJ5iq3B5kfQOHq4Sl0/vrytSoaoojhB7kQOdxSJog==
X-Received: by 2002:ac2:544c:: with SMTP id d12mr40854035lfn.97.1594331734745;
        Thu, 09 Jul 2020 14:55:34 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id d2sm1370496lfq.79.2020.07.09.14.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 14:55:33 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
Subject: MDIO Debug Interface
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     <netdev@vger.kernel.org>
Date:   Thu, 09 Jul 2020 22:47:54 +0200
Message-Id: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

TL;DR: Is something like https://github.com/wkz/mdio-tools a good
idea?

The kernel does not, as far as I know, have a low-level debug
interface to MDIO devices. I.e. something equivalent to i2c-dev or
spi-dev for example. The closest thing I've found are the
SIOCG/SMIIREG ioctls, but they have several drawbacks:

1. "Write register" is not always exactly that. The kernel will try to
   be extra helpful and do things behind the scenes if it detects a
   write to the reset bit of a PHY for example.

2. Only one op per syscall. This means that is impossible to implement
   many operations in a safe manner. Something as simple as a
   read/mask/write cycle can race against an in-kernel driver.

3. Addressing is awkward since you don't address the MDIO bus
   directly, rather "the MDIO bus to which this netdev's PHY is
   connected". This makes it hard to talk to devices on buses to which
   no PHYs are connected, the typical case being Ethernet switches.

The kernel side of mdio-tools, mdio-netlink, tries to address these
problems by adding a GENL interface with which a user can interact
with an MDIO bus directly.

The user sends a program that the mdio-netlink module executes,
possibly emitting data back to the user. I.e. it implements a very
simple VM. Read/mask/write operations could be implemented by
dedicated commands, but when you start looking at more advanced things
like reading out the VLAN database of a switch you need to state and
branching.

FAQ:

- A VM just for MDIO, that seems ridiculous, no?

  It does. But if you want to support the complex kinds of operations
  that I'm looking for, without the kernel module having to be aware
  of every kind of MDIO device in the world, I haven't found an easier
  way.

- Why not use BPF?

  That could absolutely be one way forward, but the GENL approach was
  easy to build out-of-tree to prove the idea. Its not obvious how it
  would work though as BPF programs typically run async on some event
  (probe hit, packet received etc.) whereas this is a single execution
  on behalf of a user. So to what would the program be attached? The
  output path is also not straight forward, but it could be done with
  perf events i suppose.

My question is thus; do you think mdio-netlink, or something like it,
is a candidate for mainline?

Thank you
