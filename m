Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C923DAD0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 05:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfD2Da5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 23:30:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43751 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfD2Da5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 23:30:57 -0400
Received: by mail-ot1-f67.google.com with SMTP id u15so7376700otq.10;
        Sun, 28 Apr 2019 20:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LQHjdbY/zv/adio9Yzeqc+a7PJdgSY2FiBN6qpuW2fY=;
        b=qyfQZ5wUX2SwXgfM49OSy7Oh4BFCWIY155B2byCZ7UZiH4ypuJCBcJFSvVbuXA3xhN
         mptnnsTm0NU9QHqE1P/g3AalTgcTKYfzzgc6rRc9kLnIMVRUmZfufoNasmVE2aTHUmAs
         gO74mtT35Cl7DKc+PvLQfz5PxFHB9P2OQLkdgYAqo4W5e4ihGObskn9Y1XmLormv2Q9n
         UnxcgdhUxh9DrGHYM1G+CDNNm3tSD5Nv1LZeE2685RdQlAc1Yuxu+Xl8XgnVdFd0gzsp
         5DVW+fonP8pB4unguag8xpSZH2vOKrpXsM+d8yjl6ip0c7It0nIlVU38q67yiiNsvFTJ
         v39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LQHjdbY/zv/adio9Yzeqc+a7PJdgSY2FiBN6qpuW2fY=;
        b=tq0P4WcOfaHd8K20Ud/6t3Y9l8BuF0aBnMc1gpFVqZHi+jW3ArmY9Grw4MRGMv6NXv
         YHPcQnBk8ww1/LNONgLYFmkYqVFx854EnvweRGQ8K5P17tNbEPMH2Jm3ixlgo2Zp3xBj
         FhvQZcLOAtN8xkv5B22NLnGc999TDT2Bj/jd3iZx2rsBbjP3oTN0lKgOLbPOmq9yqG42
         p5Twyzd7CnRLi/hqor05BWxbET/kZ1Y/MCyCZs4htttAqQEbj3z5Aiei+KzIQKNYHUex
         rqrG4GOTJewM5IqFlmigAOwLcf1aOD7k24SH1j27+M3QnXR9q1cdFe2KdEwDK63Pqmqi
         m7Bw==
X-Gm-Message-State: APjAAAX1ya0rGCoE4Aqc21i2HvpoNpAiDArg0aqXQL38BSod9PxRYqzz
        iHHWbgcXHm2IOtQ0ejQqEyLNG5daQnQKrOr/gfg=
X-Google-Smtp-Source: APXvYqw/lBO8wF2Ks0AYwd2A2FZJqfKDNi49mDKWfTxmKBbqYlIcbtvwuKRPsckOmyK0Lxcj9mSKy6ahZ7jvInaMeno=
X-Received: by 2002:a9d:650e:: with SMTP id i14mr16866369otl.128.1556508656402;
 Sun, 28 Apr 2019 20:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+A7VXWss=RAXMYb9FfWi=xPCF4Fg+A5tAbYX594HPX2b151fQ@mail.gmail.com>
 <20190426085635.3363-1-jprvita@endlessm.com> <39A065B6-DA45-497F-9EC4-CA1AD42FCDDA@holtmann.org>
In-Reply-To: <39A065B6-DA45-497F-9EC4-CA1AD42FCDDA@holtmann.org>
From:   =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date:   Mon, 29 Apr 2019 11:30:20 +0800
Message-ID: <CA+A7VXWcJGO7Un-N+8ObKVxUZxqsp+Fz8ySnb9SH5SpvzPvkMw@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: Ignore CC events not matching the last HCI command
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        ytkim@qca.qualcomm.com, "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 27, 2019 at 1:01 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Joao,
>
> > This commit makes the kernel not send the next queued HCI command until
> > a command complete arrives for the last HCI command sent to the
> > controller. This change avoids a problem with some buggy controllers
> > (seen on two SKUs of QCA9377) that send an extra command complete event
> > for the previous command after the kernel had already sent a new HCI
> > command to the controller.
> >
> > The problem was reproduced when starting an active scanning procedure,
> > where an extra command complete event arrives for the LE_SET_RANDOM_ADD=
R
> > command. When this happends the kernel ends up not processing the
> > command complete for the following commmand, LE_SET_SCAN_PARAM, and
> > ultimately behaving as if a passive scanning procedure was being
> > performed, when in fact controller is performing an active scanning
> > procedure. This makes it impossible to discover BLE devices as no devic=
e
> > found events are sent to userspace.
> >
> > This problem is reproducible on 100% of the attempts on the affected
> > controllers. The extra command complete event can be seen at timestamp
> > 27.420131 on the btmon logs bellow.
> >
> > Bluetooth monitor ver 5.50
> > =3D Note: Linux version 5.0.0+ (x86_64)                                =
  0.352340
> > =3D Note: Bluetooth subsystem version 2.22                             =
  0.352343
> > =3D New Index: 80:C5:F2:8F:87:84 (Primary,USB,hci0)               [hci0=
] 0.352344
> > =3D Open Index: 80:C5:F2:8F:87:84                                 [hci0=
] 0.352345
> > =3D Index Info: 80:C5:F2:8F:87:84 (Qualcomm)                      [hci0=
] 0.352346
> > @ MGMT Open: bluetoothd (privileged) version 1.14             {0x0001} =
0.352347
> > @ MGMT Open: btmon (privileged) version 1.14                  {0x0002} =
0.352366
> > @ MGMT Open: btmgmt (privileged) version 1.14                {0x0003} 2=
7.302164
> > @ MGMT Command: Start Discovery (0x0023) plen 1       {0x0003} [hci0] 2=
7.302310
> >        Address type: 0x06
> >          LE Public
> >          LE Random
> > < HCI Command: LE Set Random Address (0x08|0x0005) plen 6   #1 [hci0] 2=
7.302496
> >        Address: 15:60:F2:91:B2:24 (Non-Resolvable)
> >> HCI Event: Command Complete (0x0e) plen 4                 #2 [hci0] 27=
.419117
> >      LE Set Random Address (0x08|0x0005) ncmd 1
> >        Status: Success (0x00)
> > < HCI Command: LE Set Scan Parameters (0x08|0x000b) plen 7  #3 [hci0] 2=
7.419244
> >        Type: Active (0x01)
> >        Interval: 11.250 msec (0x0012)
> >        Window: 11.250 msec (0x0012)
> >        Own address type: Random (0x01)
> >        Filter policy: Accept all advertisement (0x00)
> >> HCI Event: Command Complete (0x0e) plen 4                 #4 [hci0] 27=
.420131
> >      LE Set Random Address (0x08|0x0005) ncmd 1
> >        Status: Success (0x00)
> > < HCI Command: LE Set Scan Enable (0x08|0x000c) plen 2      #5 [hci0] 2=
7.420259
> >        Scanning: Enabled (0x01)
> >        Filter duplicates: Enabled (0x01)
> >> HCI Event: Command Complete (0x0e) plen 4                 #6 [hci0] 27=
.420969
> >      LE Set Scan Parameters (0x08|0x000b) ncmd 1
> >        Status: Success (0x00)
> >> HCI Event: Command Complete (0x0e) plen 4                 #7 [hci0] 27=
.421983
> >      LE Set Scan Enable (0x08|0x000c) ncmd 1
> >        Status: Success (0x00)
> > @ MGMT Event: Command Complete (0x0001) plen 4        {0x0003} [hci0] 2=
7.422059
> >      Start Discovery (0x0023) plen 1
> >        Status: Success (0x00)
> >        Address type: 0x06
> >          LE Public
> >          LE Random
> > @ MGMT Event: Discovering (0x0013) plen 2             {0x0003} [hci0] 2=
7.422067
> >        Address type: 0x06
> >          LE Public
> >          LE Random
> >        Discovery: Enabled (0x01)
> > @ MGMT Event: Discovering (0x0013) plen 2             {0x0002} [hci0] 2=
7.422067
> >        Address type: 0x06
> >          LE Public
> >          LE Random
> >        Discovery: Enabled (0x01)
> > @ MGMT Event: Discovering (0x0013) plen 2             {0x0001} [hci0] 2=
7.422067
> >        Address type: 0x06
> >          LE Public
> >          LE Random
> >        Discovery: Enabled (0x01)
> >
> > Signed-off-by: Jo=C3=A3o Paulo Rechi Vita <jprvita@endlessm.com>
> > ---
> > include/net/bluetooth/hci.h |  2 ++
> > net/bluetooth/hci_core.c    |  5 +++++
> > net/bluetooth/hci_event.c   | 12 ++++++++++++
> > net/bluetooth/hci_request.c |  4 ----
> > net/bluetooth/hci_request.h |  4 ++++
> > 5 files changed, 23 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index fbba43e9bef5..883a8c25ccfb 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -221,6 +221,8 @@ enum {
> >       HCI_RAW,
> >
> >       HCI_RESET,
> > +
> > +     HCI_CMD_PENDING,
> > };
>
> no new flags here please. This is userspace visible use the hdev->dev_fla=
gs.
>

Ok, moved to hdev->dev_flags. Sending new revision now.

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
