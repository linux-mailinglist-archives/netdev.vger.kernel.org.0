Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6189BD95
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfHXMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:13:16 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35613 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbfHXMNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:13:15 -0400
Received: by mail-ed1-f67.google.com with SMTP id t50so18203209edd.2;
        Sat, 24 Aug 2019 05:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qrbwbvMintEfbN3O8x/1+iStK6WU41doMdz4JBoT9mI=;
        b=Ru8DfersM4wIvcsmJvGjFZ5M6BQxkAmj+F7ABByrV06/XTMCL7jyL6TPg51jHDHTEO
         trOrgskHumIk/k3s21dO4cNp+Pu/piOP8hRxCzg1W1xmIkLU/OuLLUv4rHL8em5QqkyX
         0oAp80f6vbj1n9X8iATF3FZmtGv1DOisaF+iJNTaY37kLNHZNYrVLo0KbgE/kLI0v+Ck
         Tnt7FCef8fACk8UnAct1aNiOIL54aqVYspSTi/yZDfo7qXCa0msMyz3ZdUNZ0ced79BN
         /9SDFN+66YMp3vaqtbGC+XPl9zP9OQZeJ+jwTMLIYPjHdnGe6SReEi8jDNv2WHDGQMC7
         XxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qrbwbvMintEfbN3O8x/1+iStK6WU41doMdz4JBoT9mI=;
        b=fyADXj0yQU733weT5Qa9X0FEIqar/6WALX3WwGRU94EOF6G7GFpd10dQOHKKQVYOKG
         cIQIFl2zHy6tuyMBbRajyUrew4z5W+KNGloRas+OuSu4gRT6GJDjrG3dgNJI9fpGBWly
         N/QQn+z+G9mDHHL7tB5utj9xBbfz/yGw1nhc2p2xdekXUmUlzkXUvZZhXPxFENkxYKtz
         j5mkDdMiSKO0WfuO/MMgFNbHdBlX/5j4qp8FuLn5cIrOLPn1toAbVDqQDMbXZ4mJM+Gt
         qLr8nhMHBAGasll618M2LW1W3EIPmsX/hAH88q1AEbXBesyCx+wb++njQ2p9N4IiX2HY
         Hx7w==
X-Gm-Message-State: APjAAAWzETseZMF9pOD7kY/1fJLd9BwnqMlBRErDv8BbMhl74LOzjKSa
        O++h5FRIG6idhbIg6OwtviyCG4lywJgFLjRNJ4c=
X-Google-Smtp-Source: APXvYqyco6vgDk8O5il3NETaH+LBIBxotnk/iCuXINfwfRlj6Eho5VLzGHCjZQrgFppyTGCr3e9GtuUMTUuA94VM7vk=
X-Received: by 2002:a05:6402:124f:: with SMTP id l15mr9205396edw.140.1566648793847;
 Sat, 24 Aug 2019 05:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com> <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost> <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost> <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
 <20190822160521.GC4522@localhost> <CA+h21hrELeUKbfGD3n=BL741QN9m3SaoJJ0y+q_uthdxvSFVRg@mail.gmail.com>
 <20190823052217.GD2502@localhost>
In-Reply-To: <20190823052217.GD2502@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 15:13:02 +0300
Message-ID: <CA+h21hpUytc2S=NmEbjDiQo4wRrKJiE5ZT+jVgCyocUb2RMYNg@mail.gmail.com>
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

On Fri, 23 Aug 2019 at 08:22, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, Aug 22, 2019 at 07:13:12PM +0300, Vladimir Oltean wrote:
> > You do think that I understand the problem? But I don't!
>
> ;^)
>
> > > And who generates Local_sync_resp?
> > >
> >
> > Local_sync_resp is the same as Local_sync_req except maybe with a
> > custom tag added by the switch. Irrelevant as long as the DSA master
> > can timestamp it.
>
> So this is point why it won't work.  The time stamping logic in the
> switch only recognizes PTP frames.
>
> Thanks,
> Richard

So to summarize the pros and cons of a PHC-to-PHC loopback sync:
Pros:
- At least two orders of magnitude improvement in offset compared to a
software timestamping solution, even in the situation where the
software timestamp is fully optimized
- Does not depend on the availability of PPS hardware
- In the case where both MACs support this, the synchronization can
simply reuse the DSA link with no dedicated circuitry
Cons:
- DSA framework for retrieving timestamps would need to be reworked
- The solution would have to be implemented in the kernel
- A separate protocol from PTP would have to be devised
- Not all DSA masters support hardware timestamping. Of those that do,
not all may support timestamping generic frames
- Not all PTP-capable DSA switches support timestamping generic frames
- Not all DSA switches may be able to loop back traffic from their CPU
port. I think this is called "hairpinning".
- The solution only covers the sync of the top-most switch in the DSA
tree. The hairpinning described above would need to be selective as
well, not just possible.

So at this point, the solution is not generic enough for me to be
compelled to prototype it. Taking system clock timestamps in the SPI
driver is "good enough". We'll just need to work out a way with Mark
that this can be added to the SPI subsystem, given the valid
objections already expressed.

Thanks,
-Vladimir
