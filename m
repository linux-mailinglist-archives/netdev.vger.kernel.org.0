Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8A41DB14E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETLRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:17:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726486AbgETLRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589973430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+3+XJ/Vfn9hEmmjKQHW1eZ3jCSPljvkuiuCcfSEsoMI=;
        b=Lk5+pc+V53e5JmA5lxF0AsbfqeP8wHqcvhI8Q94WRGPFONiKhIleTgV7U+ZM/in7b+gNhS
        SBmb5rkdg4nKIulAlSp7VSdxuTAZw/+mmeMiKFvWJji0ONAzJ1PZirQxOU1iJNXOykhzBi
        cXGaVRB9IRWoMuEK2tA7E66PJCJTuGc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162--aAkZPh2PUOsD1jAQE4qwQ-1; Wed, 20 May 2020 07:17:02 -0400
X-MC-Unique: -aAkZPh2PUOsD1jAQE4qwQ-1
Received: by mail-ej1-f71.google.com with SMTP id qn27so1203139ejb.11
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+3+XJ/Vfn9hEmmjKQHW1eZ3jCSPljvkuiuCcfSEsoMI=;
        b=Z0LPj555jVtBBHGKDmeC+p2cDvZ0mIScs5T9gMbAMd/I9qsqc8PTY3BipRj+dL5lqX
         0iV2A8fguwZKncoELNPkVLmZqeYJnT0/xPHuXyC4rQS9m0C/2/xxPx+5bPjle6mu4mEh
         HFnbkw/p4h0fe15nXWzfNKx6VjTtLxyZaRVuWKf/5k/UrS8b3q7FdixWRdOy+oG3j53n
         T2DXuYfTnZkgsbWKD0WR8xe8/gM6t7Vouno5uvx159+HGfDce6wyX7WG5V/nruNtFQ8E
         GSNH+1GkYRUiwOoY8ERpNfnNSDmSYy+B7/Htsq5VSQWWYhe9wOlfxhRxMPn5WQxM45Uw
         DNMQ==
X-Gm-Message-State: AOAM532Bcqy7zTGrZRgWfxSk2V1K0MCvf4o9Rk0obs5jjQLeyM3cw9tY
        fUiPSTBhE4aNKpuXl8Y5q/2LatukZVn+b9sTHxp+NAUAdaMQDMWIwyhzw73WTEipxK3VWnSfj+8
        R4/zUh+xdvTylRR2z986OiEw58wQpNmok
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr2772103edu.62.1589973421133;
        Wed, 20 May 2020 04:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9yaJKGnybcRqUxUy3GthqkOjqhNi4tj5jBm01HqNr4HhbfSnN0NrfDJG+uO9vI/xvh0Cix+t4RnN+OLDEWpE=
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr2772082edu.62.1589973420888;
 Wed, 20 May 2020 04:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200423170003.GT25745@shell.armlinux.org.uk> <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk> <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
 <20200509195246.GJ1551@shell.armlinux.org.uk> <20200509202050.GK1551@shell.armlinux.org.uk>
 <20200519095330.GA1551@shell.armlinux.org.uk> <CAGnkfhzuyxJDo-DXPHPiNtP4RbRpry+3M9eoiTknGR0zvgPuoA@mail.gmail.com>
 <20200519190534.78bb8389@turbo.teknoraver.net> <20200520111043.GK1551@shell.armlinux.org.uk>
In-Reply-To: <20200520111043.GK1551@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 20 May 2020 13:16:25 +0200
Message-ID: <CAGnkfhx2qHVSBNTRQf+RQiRWBHxF5hPE=5m+YVKBv6C97P=BOw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 1:11 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, May 19, 2020 at 07:05:34PM +0200, Matteo Croce wrote:
> > On Tue, 19 May 2020 12:05:20 +0200
> > Matteo Croce <mcroce@redhat.com> wrote:
> >
> > Hi,
> >
> > The patch seems to work. I'm generating traffic with random MAC and IP
> > addresses, to have many flows:
> >
> > # tcpdump -tenni eth2
> > 9a:a9:b1:3a:b1:6b > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.4.0 > 192.168.0.4.0: UDP, length 12
> > 9e:92:fd:f8:7f:0a > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.4.0 > 192.168.0.4.0: UDP, length 12
> > 66:b7:11:8a:c2:1f > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.1.0 > 192.168.0.1.0: UDP, length 12
> > 7a:ba:58:bd:9a:62 > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.1.0 > 192.168.0.1.0: UDP, length 12
> > 7e:78:a9:97:70:3a > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.2.0 > 192.168.0.2.0: UDP, length 12
> > b2:81:91:34:ce:42 > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.2.0 > 192.168.0.2.0: UDP, length 12
> > 2a:05:52:d0:d9:3f > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.3.0 > 192.168.0.3.0: UDP, length 12
> > ee:ee:47:35:fa:81 > 00:51:82:11:22:02, ethertype IPv4 (0x0800), length 60: 10.0.0.3.0 > 192.168.0.3.0: UDP, length 12
> >
> > This is the default rate, with rxhash off:
> >
> > # utraf eth2
> > tx: 0 bps 0 pps rx: 397.4 Mbps 827.9 Kpps
> > tx: 0 bps 0 pps rx: 396.3 Mbps 825.7 Kpps
> > tx: 0 bps 0 pps rx: 396.6 Mbps 826.3 Kpps
> > tx: 0 bps 0 pps rx: 396.5 Mbps 826.1 Kpps
> >
> >     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> >       9 root      20   0       0      0      0 R  99.7   0.0   7:02.58 ksoftirqd/0
> >      15 root      20   0       0      0      0 S   0.0   0.0   0:00.00 ksoftirqd/1
> >      20 root      20   0       0      0      0 S   0.0   0.0   2:01.48 ksoftirqd/2
> >      25 root      20   0       0      0      0 S   0.0   0.0   0:32.86 ksoftirqd/3
> >
> > and this with rx hashing enabled:
> >
> > # ethtool -K eth2 rxhash on
> > # utraf eth2
> > tx: 0 bps 0 pps rx: 456.4 Mbps 950.8 Kpps
> > tx: 0 bps 0 pps rx: 458.4 Mbps 955.0 Kpps
> > tx: 0 bps 0 pps rx: 457.6 Mbps 953.3 Kpps
> > tx: 0 bps 0 pps rx: 462.2 Mbps 962.9 Kpps
> >
> >     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> >      20 root      20   0       0      0      0 R   0.7   0.0   2:02.34 ksoftirqd/2
> >      25 root      20   0       0      0      0 S   0.3   0.0   0:33.25 ksoftirqd/3
> >       9 root      20   0       0      0      0 S   0.0   0.0   7:52.57 ksoftirqd/0
> >      15 root      20   0       0      0      0 S   0.0   0.0   0:00.00 ksoftirqd/1
> >
> >
> > The throughput doesn't increase so much, maybe we hit an HW limit of
> > the gigabit port. The interesting thing is how the global CPU usage
> > drops from 25% to 1%.
> > I can't explain this, it could be due to the reduced contention?
>
> Hi Matteo,
>
> Can I take that as a Tested-by ?
>
> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
>

Tested-by: Matteo Croce <mcroce@redhat.com>

probably also:

Reported-by: Matteo Croce <mcroce@redhat.com>

Thanks,
-- 
Matteo Croce
per aspera ad upstream

