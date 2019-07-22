Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187426FE8C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfGVLMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:12:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54808 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfGVLMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:12:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so34706738wme.4
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 04:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bofh-nu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugRN07ELNBGju0FZXfeTINwMh3Eu6S1IN6qjdKCIFBE=;
        b=gFpS54Ax3j5KsNqU6isZdGlE+UrqmTn1H7kDrcDfPtz5MDBUHiilO+ZhfhdUYaCeeU
         rnEF6ZKsuR9+Iv9LsEGoAaEVzSJuQ9SY3MRzFskJQjMVNJtpIQo5TVJC2A470Fnv5WKA
         Kkwh4Qvq5M8KWeAHKby9Ab4DdLCxK9kvQlmG+LVcXjze03oJ9l16KEKk7AfepwwSlUmB
         4PCxmpKH72WnymNl5ig50UJfK/N7j5HIxINywTZieue+9SYmx5xcD735gsjHwAFt1cX0
         5yC2/bv/9IG7OT2uIPZuVOkzW+kwc0AoBZclZ7h01TmKpUOxv2kH86Bx5WGN7FOca3nn
         oKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugRN07ELNBGju0FZXfeTINwMh3Eu6S1IN6qjdKCIFBE=;
        b=FVHFRtzdyTN2IXVV2ogUrikkMFZ+GLblHzMQglHrh4e3/vfnVsTPnFq/rAoZsVCt0x
         38gigFVJbaKUkU0r6CsHLM++OWyPmlsLJ3OfT8DFH8Tn+XyR5Mtv47Of1ElZYeY1Y0mK
         EAX1YWPgB9ZEDXi8axz24/xB5VhXPqKZ2+fjUuW5D2AjL2Xo4P3zi6whi3JDKsB3Ufek
         v1EKAflAoExzoVp8gWGND9M0ECWp49sNqApnPvjFl0lCXcjYPEPbKD5ruMGdkftmpDUu
         1g8cKoNDuvevejb9i+D8Bv6pWRCI0ejJGF87v7QjFp1tcUrVaLgdYHmXjcNBRdzrWZBy
         4FBQ==
X-Gm-Message-State: APjAAAWEPP8BZlumds5Sj/4mJ+qpuXW5R4eOYCwTlqggMWEh+3sYXoAf
        UI/XhuVhbcHXpXgCXIsd6hxBMC2EvXTr4lKG7Ow=
X-Google-Smtp-Source: APXvYqyMOVi1QeBfQY7y3XFV+dCnJfmPmLUDhkHjFCy6dBRz6GZNepCI13S7cLN1oIlGT7gkQSUn4ppFimfg0qTYAS4=
X-Received: by 2002:a05:600c:24a:: with SMTP id 10mr64703351wmj.7.1563793921410;
 Mon, 22 Jul 2019 04:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562149883.git.joabreu@synopsys.com> <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com> <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
In-Reply-To: <20190722101830.GA24948@apalos>
From:   Lars Persson <lists@bofh.nu>
Date:   Mon, 22 Jul 2019 13:11:50 +0200
Message-ID: <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page Pool
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 12:18 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Thu, Jul 18, 2019 at 07:48:04AM +0000, Jose Abreu wrote:
> > From: Jon Hunter <jonathanh@nvidia.com>
> > Date: Jul/17/2019, 19:58:53 (UTC+00:00)
> >
> > > Let me know if you have any thoughts.
> >
> > Can you try attached patch ?
> >
>
> The log says  someone calls panic() right?
> Can we trye and figure were that happens during the stmmac init phase?
>

The reason for the panic is hidden in this one line of the kernel logs:
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

The init process is killed by SIGSEGV (signal 11 = 0xb).

I would suggest you look for data corruption bugs in the RX path. If
the code is fetched from the NFS mount then a corrupt RX buffer can
trigger a crash in userspace.

/Lars
