Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DFAF74A2
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKNTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:19:40 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44508 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKNTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:19:39 -0500
Received: by mail-ed1-f67.google.com with SMTP id a67so11866521edf.11
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 05:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLKC6yqjtKa2mKAeKRMkr2+KdtbaQ3Wi8fzcplMM//g=;
        b=OVPIWK3th5DTIShIZUzrEPS26TSvF7xoaUviX+824tKUwO9C3umR2X40NjLZYzlNjD
         F+Ayx244kXM30v8j5tDaYL6AE5zo8NT4hCtwD+iLkLo5p/O3KcrQKXBXxohbDFNN1juw
         Np/HdXNbuzoutO2TepvmBZykE1/yPOVNIUKdOjLcsDnswsBS2PWYI+ln3B0sWLsZn776
         lYteZE2himYXtZ7avdQ0CLz9HJvq+cZN0T6BAJkUhwQhcVUpZE6Pl6xo5bzLKX5I4BQN
         iSEFzGQYlnNF/Kv72beWySqxDj/ekhnLkCUPfO/47AzBgl/1wZrs/6qPbZhs8GR2Ss1o
         KTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLKC6yqjtKa2mKAeKRMkr2+KdtbaQ3Wi8fzcplMM//g=;
        b=cmNg4neHVIjhGY2ypa3DP0hBbiGMbgK0yccVqnrMWQI3rS9OzWHX/CtMfhoi1Irm69
         r1gd+IVkYD3P2KelQrEREdQvs+oTf2PLY5CpJMFMgNMZhdd9LEASRV8tNbk6X3LpXuNK
         Qkkat6Z6YNlg8DH0PqALF3c2BTXOznXQ25Cbx2PmzIDKW3IMuC4WYF8MG3Firs0QFgdh
         +aGkbO/JyGkJyPYd3gqokjc8ju4dWnoMvjUpTC2uQmkGD8M0y7oDzqvTSMQK8PH2+F4B
         T61JXDuu89tW12pvRzVjDBCJWwvWPaD7H4Q6ofQbfSQFNJ4K2bEVfwBlRb+1rfQPeUZW
         xeXg==
X-Gm-Message-State: APjAAAVstaoROU0+kDIeqF18HB8E5PXP4iGx6qn3HeICRVp+S8nckwRn
        IeZv5SfbTtqz050Vb7zfJ4ifWV2z7RqNE/QA/uo=
X-Google-Smtp-Source: APXvYqysl02e1N7sVHB1nZWJyp/tIaoJLNq0m80YPeqpjhuCb/KARF0Js2GrCbx7HrBXETcTeiaaaH6E0c7+wGVjlJs=
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr26465858edr.18.1573478377922;
 Mon, 11 Nov 2019 05:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20191109113224.6495-1-olteanv@gmail.com> <20191109151942.GA1537@localhost>
In-Reply-To: <20191109151942.GA1537@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 Nov 2019 15:19:26 +0200
Message-ID: <CA+h21hpaaDbnq9dXWj9sRwgExP304DrbghPTHGttyc=izkMncA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] Unlock new potential in SJA1105 with PTP
 system timestamping
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 at 17:19, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Sat, Nov 09, 2019 at 01:32:21PM +0200, Vladimir Oltean wrote:
> > The SJA1105 being an automotive switch means it is designed to live in a
> > set-and-forget environment, far from the configure-at-runtime nature of
> > Linux. Frequently resetting the switch to change its static config means
> > it loses track of its PTP time, which is not good.
> >
> > This patch series implements PTP system timestamping for this switch
> > (using the API introduced for SPI here:
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg316725.html),
> > adding the following benefits to the driver:
> > - When under control of a user space PTP servo loop (ptp4l, phc2sys),
> >   the loss of sync during a switch reset is much more manageable, and
> >   the switch still remains in the s2 (locked servo) state.
> > - When synchronizing the switch using the software technique (based on
> >   reading clock A and writing the value to clock B, as opposed to
> >   relying on hardware timestamping), e.g. by using phc2sys, the sync
> >   accuracy is vastly improved due to the fact that the actual switch PTP
> >   time can now be more precisely correlated with something of better
> >   precision (CLOCK_REALTIME). The issue is that SPI transfers are
> >   inherently bad for measuring time with low jitter, but the newly
> >   introduced API aims to alleviate that issue somewhat.
> >
> > This series is also a requirement for a future patch set that adds full
> > time-aware scheduling offload support for the switch.
> >
> > Vladimir Oltean (3):
> >   net: dsa: sja1105: Implement the .gettimex64 system call for PTP
> >   net: dsa: sja1105: Restore PTP time after switch reset
> >   net: dsa: sja1105: Disallow management xmit during switch reset
>
> For the series:
>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Thanks Richard.

David, I noticed you put these patches in Patchwork in the 'Needs
Review / ACK' state. Do you need more in-depth review, or did you just
miss Richard's tag, since Patchwork ignores them if they're posted on
the cover letter?

[ in fact, I have a similar question for the "Accomodate DSA front-end
into Ocelot" series, which also has 1 R and 1 A on the cover letter ]

Regards,
-Vladimir
