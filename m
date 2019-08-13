Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3391B8B5ED
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfHMKwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:52:05 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:32830 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfHMKwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:52:05 -0400
Received: by mail-lf1-f41.google.com with SMTP id x3so76538631lfc.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sentorsecurity.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=HNvDgvMcDmrX2tbK/nIEsSfJzC2i72rPUeGszghmYCU=;
        b=DjV8xxQBILq/S+DnM2IfloYpApSkYeTX6O4aEAOx8mz4dVYe8g4fhpGbjxXDjRkM28
         9I8FwY6vm2b9umSn4om+ed21qURGhQ0/eITHf6idf//L60voRmaQNkD/PFLauAuMQd6S
         xYstMzcM2yE0hFNqbfKGeJCnNn8ROxYwt8HEBps4jRzSG0wMmc4cVJQYldS9BgYiEufR
         1rCeI6B0OJiHx+Q2eU9eveKIMf7L3w0WA4SzNeaYi0lRW8f713xbMEW9wrmn9SjypkJC
         Pv0JsHuGlFrSGdliBZ8gjpiiT3e/GnPyrxJEcIEhEjiwTipjZ3qPVeSPKqSFQGErvh7S
         GMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=HNvDgvMcDmrX2tbK/nIEsSfJzC2i72rPUeGszghmYCU=;
        b=W/5vZ9F7pOpY78xonPzPUxM4VPMIgwwPHkSwNKq1+3prE2pWBop3mSBu0yJ2iep3oT
         hC2hhBvyIwS/JdNochbuvNGpeVa8pGQPIRmImj+RtIx6Zg9Z8LlhrcH55dku+sVXb5ZW
         Rp/oXFGJGQyaH1Jf+Ko8G+AiTUjzGpfA4PAEtt7ZFF6+fTXLgUfSMLjJpLZE1F+LjJHl
         AsNFkPdD/xrewPJJuhgKWt6lN5mxcT2Xtu8NVJ9UUX7Dpv+8as7GxPMILY1PUPBPHbUp
         xkGuQk5VY8AL8MxVUVQRZpd3lIqdByDNNoY0ASMXaNtD0yxk/2dnToanbBDFPc7cl99m
         WN+Q==
X-Gm-Message-State: APjAAAX4fYLgD8trqJ+2X50/Gv/NwiRbbRc06HdEighIz765s9cS0UUv
        od6vy216+J+Xv1UQTkSiD8cA+3I5+gPKSK0AgVVkSyXJjkM=
X-Google-Smtp-Source: APXvYqweWMSvChtmUt1drTiW1h/sUSoEvY4082m2siIUyYi4ZtX5pcN3qvw2s2hURFpz8zEvs1WzbegCJ39e0XAMMz4=
X-Received: by 2002:ac2:442d:: with SMTP id w13mr1359497lfl.184.1565693522815;
 Tue, 13 Aug 2019 03:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
In-Reply-To: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
From:   Martin Olsson <martin.olsson+netdev@sentorsecurity.com>
Date:   Tue, 13 Aug 2019 12:51:51 +0200
Message-ID: <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
Subject: tc - mirred ingress not supported at the moment
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two questions regarding tc-mirred:

1)
The manual ( https://www.linux.org/docs/man8/tc-mirred.html ) states:

  OPTIONS
    ingress
    egress
      Specify the direction in which the packet shall appear on the
destination interface.
      Currently only egress is implemented.

I verify to see if this is still true, and unfortunately it is:

# tc filter add dev eno2 parent ffff: prio 999  protocol all matchall
action mirred ingress redirect dev mon0
mirred ingress not supported at the moment
bad action parsing
parse_action: bad value (5:mirred)!
Illegal "action"

Q1: Why was 'ingress' not implemented at the same time as 'egress'?



2)
Ok, so I have to use 'egress':
# tc filter add dev eno2 parent ffff: prio 999  protocol all matchall
action mirred egress redirect dev mon0

Since the mirred action forces me to use 'egress' as the direction on
the dest interface, all kinds of network statistics tools show
incorrect counters. :-(
eno2 is a pure sniffer interface (it is connected to the SPAN dest
port of a switch).
All packets (matchall) on eno2 are mirrored to mon0.

# ip -s link show dev eno2
    ...
    ...
    RX: bytes  packets  errors  dropped overrun mcast
    13660757   16329    0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    0          0        0       0       0       0
# ip -s link show dev mon0
    ...
    ...
    RX: bytes  packets  errors  dropped overrun mcast
    0          0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    13660757   16329    0       0       0       0

eno2 and mon0 should be identical, but they are inverted.
When I graph all interfaces of the machine, the traffic graph for
'mon0' is incorrect since it shows 100% egress when the traffic really
is ingress.

As a human I can re-enterpret the mon0 graph when looking at it, but
it is harder for automated tools to do the right thing without
explicit node configuration/exceptions in the tool. This is annoying
when you have tools that graph hundreds of different types of nodes
with different kinds of interface types, and want all graphs to be
visually simillar for easy comparison.
Tool output that mon0 has sent 16329 packets is also plain wrong. It
has really *received* these packets.

Q2: So... Can the 'ingress' option please be implemented? (I'm no
programmer, so unfortunetly I can't do it myself).

/Martin
