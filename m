Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4120F5D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfEPTxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:53:38 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:34688 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEPTxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:53:38 -0400
Received: by mail-io1-f51.google.com with SMTP id g84so3625876ioa.1
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 12:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dp78Ngm8ZHs/cemhwNrpTJXKKOXhDXvmWqZmMj1etsk=;
        b=jRjli4nQ7kewt2x9Qr25qkGmvl+O03aIsVJjS7GbXNdtkHpcIpRtqI0O3T3NvGV/n5
         +CEOb5fXrPH+UdQpvOhKxnc/WZTGSvMCyAFaTWPeze3pw6su0jFz6z9e983Po81HMCjX
         4xEtaDoZapWrIiavnd8SC4XNO0yo9vgclmw4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dp78Ngm8ZHs/cemhwNrpTJXKKOXhDXvmWqZmMj1etsk=;
        b=c1p8pZM28hGTvv9+9K5HBjt1gvPNWoG5ZvmB5I0D+JMFyO9wn5/KdTK+Wqi8AF3IEG
         8891WEXD46E9g+ffAXLtWXoPs/oZt0VIYoYS5hyOvktcEoKzhC31xQmQ+4klyYWjA+WD
         rF04UzQjJG4aggn5J4QHk0JMYE0pIudr4dKvkrg0ejJDy5jncVPe00LkRRSVAQluiotR
         vvTbCxCwjVwfGPnay5r5mVDnMofiDDV2a9G8KjkJd8edrKgwhDpjT8bhJFANaZbP/Okk
         Jr51hSLIQVa6CHJSy8N1FDxBM6pSjik+g2nxkWk1IywFkyKc4fuYjAr0uYZtpfz6nRnD
         smoQ==
X-Gm-Message-State: APjAAAU7TEvuvMTJU6aOKxcTzz9ugad2uHQq1YKcLplhJCUe0xKrAUZP
        f4UP7b+OieYtTx5aWZyxwIT2dnQr/z0dsE0oCF5MuP2L8aE=
X-Google-Smtp-Source: APXvYqwOT8vprzQrtwLrWk0C8LJ5BSqSgjcou3Vao+h5RsWc1lPXeJigWi+PMdvwrE1lg1BQ7u8wG3E+0leZsr+BjOI=
X-Received: by 2002:a6b:c0c6:: with SMTP id q189mr31403350iof.283.1558036416516;
 Thu, 16 May 2019 12:53:36 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Stewart <pstew@chromium.org>
Date:   Thu, 16 May 2019 12:53:25 -0700
Message-ID: <CAMcMvsgiebYeAc7csDog=j4cj9h2_QdLm7dO=7hU5BOceN6anw@mail.gmail.com>
Subject: ixgbe device for Intel C3508
To:     netdev@vger.kernel.org
Cc:     andrewx.bowers@intel.com, jeffrey.t.kirsher@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was pleased to fine that the ixgbe driver had good support for the
10GBit interfaces on the Atom C3708 device I was using.  However, the
same is not true of the 2.5GBit interfaces on the Atom C3508.  The PCI
IDs on these interfaces are very similar -- 8086:15cf on the C3508 vs
8086:15ce on the C3708.  Modifying the ixgbe driver to simply treat
8086:15cf almost works -- the 4 Ethernet interfaces are discovered and
*something* happens when I plug in a Gigiabit ethernet cable into the
SFP port:

[  269.233242] ixgbe 0000:0c:00.0 eth1: NIC Link is Up 1 Gbps, Flow Control: RX/
TX
[  269.240733] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  269.337230] ixgbe 0000:0c:00.0 eth1: NIC Link is Down
[  289.682588] ixgbe 0000:0c:00.1 eth2: detected SFP+: 6
[  392.859888] ixgbe 0000:0c:00.0: removed PHC on eth1
[  393.497099] ixgbe 0000:0c:00.1: removed PHC on eth2
[  394./MA257214] ixgbe 0000:0d:00.0: removed PHC on eth3
[  394.867122] ixgbe 0000:0d:00.1 eth4: NIC Link is Up 1 Gbps, Flow
Control: RX/TX
[  394.889384] ixgbe 0000:0d:00.1: removed PHC on eth4

Clearly not all is well, as could be expected -- I'm sure there's a
real reason why these are separate PCI IDs.   Is there someone out
there that can point me at docs I can use to support the device
myself, or does anyone know if support is coming?  Should this device
be considered an X550 or is this a different device fundamentally
(should I not use the Intel X550 docs as a reference, if I were to
hunt down some documentation about the difference between these
parts?)
