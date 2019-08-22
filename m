Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1860998EF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbfHVQN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:13:26 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44479 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHVQNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:13:25 -0400
Received: by mail-ed1-f66.google.com with SMTP id a21so8685289edt.11;
        Thu, 22 Aug 2019 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LExFqvIj1L+lDrOhkqY8R7J2HYM/Yxh/uJYyKhG/Ah0=;
        b=VWr5YElxR1FIc45g10qGJUHBbf3l81WFOmr1Xc6pXNvanaEalwXu1viXjtf6Fw/2I1
         Zp2OgRI+YB8k4L5AiaJFGsriaLfddC7DFfrscgYn9C7P4RwLWBxAXacXgJG3TR0VQ9j0
         q4oKfoDfgoMKaBCl/hojh3Hrw5H2hgdMMIrnI4zChEiAVb1HxVIp/m40dd6ERFSjhcvF
         j7FBbH1ZN7FpCgM2XMHKqJDHV24FBYXHZ0Fzu6Yqi1fb8l07Sneef5xEchUw8riF1QcB
         MR8awG+RQ2lnBKLvLtuuOA80UZzIhAuviAjrPR6Qap/6VoB82Qw4DLc4Y3SfLiSKPcQd
         KuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LExFqvIj1L+lDrOhkqY8R7J2HYM/Yxh/uJYyKhG/Ah0=;
        b=N3z4QUoRSxSbNEi7iXvl6bW3Pl/FD2dhroqD5pIIGTJaWLOH8VD1wJwYZVMAXS1Mu8
         LkB0/skOxySa5+29ADmza5jNRIBlvkaqCxWAjLr9YsB946eP5Qkvw0h72gkoaKCPkT+A
         5aqHmDMP18M9uZyUlQbwJ+zsIn5TIOUFdQqbYmrPJqDIsV5Tip5kYVaEITBRxsTH0GOw
         61m09HluPTV35Y7lzfc8axB9YKkyDYX3tkAC1nqCIwUnXGyEUoj9hOwa9yZ8dCBME05N
         db2COQwPWGGYtFsbOfzY0sS5Lzr+jwuKdfRZ9IztPSLtl2KIra+znKv/1FaElBg3JfUD
         r5mA==
X-Gm-Message-State: APjAAAUKAcPbU4LDVksaRQXJSmqd7gEj5mEQ0MInw8lRYUPtM044FWvk
        HXBNgHIiK98s4GW8MQZYvhXYXkXi9O3111zCXGM=
X-Google-Smtp-Source: APXvYqwySjEhNPsVj2cU8MdMv8/L10CUMmqa9kbGgex13CjHuIYPLbz9Jdg8Dp9V2g+VPgRpFl6kksvfxxwGe/+j+Gw=
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr56211ejr.47.1566490403846;
 Thu, 22 Aug 2019 09:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com> <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost> <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost> <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
 <20190822160521.GC4522@localhost>
In-Reply-To: <20190822160521.GC4522@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 22 Aug 2019 19:13:12 +0300
Message-ID: <CA+h21hrELeUKbfGD3n=BL741QN9m3SaoJJ0y+q_uthdxvSFVRg@mail.gmail.com>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 at 19:05, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, Aug 22, 2019 at 05:58:49PM +0300, Vladimir Oltean wrote:
> > I don't think I understand the problem here.
>
> On the contrary, I do.
>

You do think that I understand the problem? But I don't!

> > You'd have something like this:
> >
> > Master (DSA master port)         Slave (switch CPU port)
> >
> >     |                            |         Tstamps known
> >     |                            |         to slave
> >     |       Local_sync_req       |
> >  t1 |------\                     |         t1
> >     |       \-----\              |
> >     |              \-----\       |
> >     |                     \----->| t2      t1, t2
> >     |                            |
> >     |     Local_sync_resp /------| t3      t1, t2, t3
> >     |              /-----/       |
> >     |       /-----/              |
> >  t4 |<-----/                     |         t1, t2, t3, t4
> >     |                            |
> >     |                            |
> >     v           time             v
>
> And who generates Local_sync_resp?
>

Local_sync_resp is the same as Local_sync_req except maybe with a
custom tag added by the switch. Irrelevant as long as the DSA master
can timestamp it.

> Also, what sort of frame is it?  PTP has no Sync request or response.
>

A frame that can be timestamped on RX and TX by the DSA switch and
master, that is not a PTP frame.

> > But you don't mean a TX timestamp at the egress of swp4 here, do you?
>
> Yes, I do.
>
> > Why would that matter?
>
> Because in order to synchronize to an external GM, you need to measure
> two things:
>
> 1. the (unchanging) delay from MAC to MAC
> 2. the (per-packet) switch residence time
>

But since when are we discussing the synchronization to an external
grandmaster? I don't see the connection.

> Thanks,
> Richard

Regards,
-Vladimir
