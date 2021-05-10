Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BF23793E7
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhEJQef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhEJQeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:34:10 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7FC061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 09:33:05 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id n7so3466966vkl.2
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=syiuAwwFnY+ZtThB8BYDMUVrrDPE5MLVM56K4WzAWng=;
        b=ZEtfePdLnl5oyadsvib+SpIffEpmNk1uu1y0AQaeuWEqFj2xvvdghtIpugXIBx4EGb
         BsPgOMB43D2SsxUVbrWoXbfdl2q+cGqzbViXpZGzUFO9rWw7Bt8a8MYviAtcM5bZH/As
         djfeYLoYCUujc6RwIx9rBVAQVi/uTSIELBb2PHe9YKOHnub8ztFciCflGutN9bh7Oh5M
         C+jv+7QKko8fk4ZrC2H0YyRYJXSg52I1jcCTPAJUdGuqFqSHDKx8zaO6oPOiPKYryTBE
         ozagLlq9uZDYpqHpjvDesiJVLW2sxjVj6HMBYO/V2QMlzMcPi3BV9CL72vuwNrIk900s
         ZlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=syiuAwwFnY+ZtThB8BYDMUVrrDPE5MLVM56K4WzAWng=;
        b=N4pgZj3gSYNkyycRAUB3ke0/AQ5VV6sOLENs8CetidjzlgWeQ0G94qR3J9oOqk9GZC
         Geb2yKUDpVD02DQhOtQCguMTmi9guFnauj//Zn0cXc2WtIzdWog9KdpYhzb46s8xsiJq
         FL8UGfsWhaa/VizQKtNzllsoCt51LeojmVskXFMbt8MwGrvzBYUZrFmPxcPi2VqadeVJ
         X3rO9xkOLPJEgI+5X6rLSy9nWKdY93VL7ZwRsvcq/x5COOjlr/xviLGoHI3bKhz7M1sw
         DIo2sQHI2rz3IRBQ6wXv4nLPAaR97sRonVLerVtwObePUmpesgkOIsGt6MFpE+BtuzIb
         5Uhw==
X-Gm-Message-State: AOAM5315HVxJwoTJa+CpkIYC+EV/aRm8RfTZWA40Nq+Uv7C/EGeV6LXK
        1bEuBGtoAOm3EFvGFyZ+gu4NUZZ8nCZEsFEg7ufVfEKhCj8=
X-Google-Smtp-Source: ABdhPJxfbbdoTCMC4k/XE06vMqr1Y7LS5xFJMQqGjzLa617izj/yRxlgi75K+3WEHAtn1JSnEz9MmLULVtOW8lO1D0w=
X-Received: by 2002:a1f:df42:: with SMTP id w63mr18176805vkg.17.1620664384136;
 Mon, 10 May 2021 09:33:04 -0700 (PDT)
MIME-Version: 1.0
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Mon, 10 May 2021 22:02:53 +0530
Message-ID: <CAHP4M8Va9TuFycrVZmLwBnuPtDRykX__NOxxF9zq0089JJBACA@mail.gmail.com>
Subject: Packet Sniffing on Intermediate Nodes
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I have been playing around with sniffing packets, using raw sockets.

Following is my setup :

* Machine-1 (Sender), with IP 1.2.3.4
* Machine-2 (Intermediate), with IP 5.6.7.8
* Machine-3 (Receiver), with IP 9.10.11.12

The packet-path is Machine-1 <=> Machine-2 <=> Machine-3.
I have an agent installed, one each on all the 3 machines,
communicating on port 12345.

Following is what I have accomplished so far :

1.
I have been able to do communication over raw-sockets.
Most importantly, Machine-3 (Receiver) is able to receive the packets
from Machine-1, via raw-socket paradigm.

2.
Now, raw sockets in general accept all packets.
So, the next step was to apply socket-flitering, so that only packets
intended for port 12345 are received on Machine-3 agent.

This was accomplished via the help from
https://www.kernel.org/doc/Documentation/networking/filter.txt

3.
Now, I intend to sniff packets on Machine-2 (the intermediate node).

Is there a normal / legal way to do this?
Would be grateful for any pointers.


Thanks and Regards,
Ajay
