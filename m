Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E34A5E85
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiBAOqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiBAOql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:46:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF36C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 06:46:41 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m11so34826519edi.13
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 06:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3ITGYdcBWSOf+AkdgBNGx8EbsR/njSAZ3vO+AtMaAw=;
        b=F8SaJnRlrne5/nPN0G/UnX9RqoSJz55O7taww4TCsxth7cleGwaJCAIpHx0L9U6u2G
         Izxq+aaGa7B/WpzlvdLZfwaVzSKdxUlqNaYzax1S3i6+yS5ONE987PbR0tOybAqL1Xfx
         fHZ5WAtxqG16C4F5aiRDBZ/vbwRdfk3XhXARhouMD+SwiucmKbcYVA9RKe5cfP9B1rIC
         K6Z0Z9xd4UAUV19fm6NN8cUF7JFUJ1J0cgEM03vRJ2dANjIwlIVsC24hpyMg6FzEXgOy
         RHAVgQGrycvrqkHi+FB2gstpyRJf8zcajIst6+Q6hlfr1vmnpxp1qHQsnCqXolhDFLHH
         7hVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3ITGYdcBWSOf+AkdgBNGx8EbsR/njSAZ3vO+AtMaAw=;
        b=mYmcLkHkt0nwYCG1fWS0kw/ZSnALJngdLXKVzMrA21OsW7Q9kTrxZSjjTFSp4mz6vu
         MVc1OLAyRTq1etQR/fwq2YyeX5yhHeMSuhzaIQ0yZT/KEOyQi0+3d7NafsQHgsAoSub9
         AihgbRtGgmZz8k/kia9JlAv89eTBN/Mfdamn2X9uh/D92ATjs6sd/OIokhLlL3UvDWL9
         Rp7wWzR6H672sSRfDg+yucV3B0MuFL/ZFIN0dcEXRsGnqRnlTxNn/pCy9XKuh4vwd6IN
         utPRcPQ2Zks8evmtNf8cJ1wjSQKy2Q94nsrHNkMqIkau1qPX4z8VgvK1VnfgjpBKc9xo
         fNGw==
X-Gm-Message-State: AOAM533ltt4zbUMlJLOiiGIhW6q2yysv8RkMk8CE04SFcL6h9/JrnPmY
        InBqdmmbgWz7RdueCtmUnZs=
X-Google-Smtp-Source: ABdhPJxT4Qolw8XbL7KpuEpc67lgj8wxvuJBeLaGz6yF1FEkrm1YPGXDhi79U7RwY2Ibun6CGujqCQ==
X-Received: by 2002:aa7:c40a:: with SMTP id j10mr25306964edq.232.1643726799455;
        Tue, 01 Feb 2022 06:46:39 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id bo11sm14762558ejb.24.2022.02.01.06.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:46:38 -0800 (PST)
Date:   Tue, 1 Feb 2022 16:46:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220201144637.l2zmchkoy4pbayxb@skbuf>
References: <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <CAJq09z5sJJO_1ogPi5+PhHkBS9ry5_oYctMhxu68GRNqEr3xLw@mail.gmail.com>
 <CAJq09z4tpxjog2XusyFvvTcr+S6XX24r_QBLW9Sov1L1Tebb5A@mail.gmail.com>
 <5355fa92-cf8c-4fa5-5157-9b6574f1c876@gmail.com>
 <CAJq09z48A7Y6p=yNocUv17Ji1AfSuP4e6MdT1tNDY0Pfz_Om=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z48A7Y6p=yNocUv17Ji1AfSuP4e6MdT1tNDY0Pfz_Om=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 02:26:30PM -0300, Luiz Angelo Daros de Luca wrote:
> > > In my case, using an incompatible tailing tag, I just made it work
> > > hacking dsa and forcing slave interfaces to disable offloading. This
> > > way, checksum is calculated before any tag is added and offloading is
> > > skipped. But it is not a real solution.
> >
> > Not sure which one is not a "real solution", but for this specific
> > combination of DSA conduit driver and switch tag, you have to disable
> > checksum offload in the conduit driver and provide it in software. The
> > other way would be to configure the realtek switch to work with
> > DSA_TAG_8021Q and see if you can continue to offload the data path since
> > tagging would use regular 802.1Q vlans, but that means you are going to
> > lose a whole lot of management functionality offered by the native
> > Realtek tag.
> 
> Definitely not a real solution. It was just a hack to check if
> checksumming at slave device will overcome the issue. As I said,
> simply disabling checksum and doing it in SW "as usual" is not enough
> because SW checksum also sums to the end. We need to parse each
> possible transport layer to find its end or taggers must hint how many
> bytes to ignore, something like a new skb->cksum_stop_before_end.
> Another solution would be to hint the slave interface if it needs to
> checksum right there (modifying slave->vlan_features). None of that
> exists today. Is it the right way?

I think we're not getting any closer to a solution if we've started
discussing tail taggers.

See commit 37120f23ac89 ("net: dsa: tag_ksz: dont let the hardware
process the layer 4 checksum"). It proves that if you calculate the L4
checksum in software before inserting the DSA tag, it won't get
recalculated upon dev_queue_xmit() on the DSA master, since
skb_checksum_help() transitions skb->ip_summed to CHECKSUM_NONE, and the
process of inserting a header/trailer will not update the checksum, so
it will end up being correct on the receive end after the tail tag is
stripped.

Otherwise, I don't completely understand what is the end goal you're
after. Each skb is checked for netdev features when determining whether
to calculate the L4 checksum in software or not. Then even if that skb
was marked for L4 checksum offload by the stack, you can still call
skb_checksum_help() from the xmit procedure of the driver.

Do you want hardware offloading with your DSA header, or why do you say
that forcing slave interfaces to disable the offload is not a real
solution? If so, I recommend looking into a custom tagging protocol
based on tag_8021q.c, but word of warning, some elbow grease will be
required.

If you're ok with software checksumming and just want the minimum amount
of checks in the fastpath, I believe you should listen for
NETDEV_CHANGEUPPER events in your DSA master driver, where
dsa_slave_dev_check(info->upper_dev) is true. From there you should be
able to retrieve the tagging protocol used (if you can't, then export some
helpers that will do that), and enable NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
in master->features if the tag is Mediatek, clear them otherwise.
See bcmsysport.c for an example.
The timing of this notifier is such that it's pointless to mangle
master->vlan_features at that stage, since DSA has already inherited
them. So DSA slaves would still report NETIF_F_IP_CSUM, but the DSA
master would force a software calculation from the correct L3 & L4
offsets, and it would practically work.
Alternatively, I think you could move dsa_slave_setup_tagger() beneath
netdev_upper_dev_link(), and this would give the DSA master an
opportunity to modulate its master->vlan_features in a way that is
desirable to you. I don't see something that would break if you do that.

As Florian and Jakub explained, the APIs for TX checksumming are what
they are, I'm not very happy with the state of things either, but I
can't justify a DSA-specific API. With HW_CSUM, the stack gives you an
L3 and L4 offset, and that is compatible with DSA headers (not
trailers), so the onus is on the DSA master to fall back to software on
offsets it doesn't like.  One could argue that DSA should not work with
IP_CSUM | IPV6_CSUM, but I believe that there are existing drivers that
use these checksum features and that do work at least with certain DSA
tagging protocols (bcmsysport) or even look at the L3 and L4 offsets
(mvneta), meaning that they would work generically with DSA. So
practically speaking, if we issue a blanket statement that DSA shouldn't
inherit IP_CSUM | IPV6_CSUM but just HW_CSUM, that would still break
working setups. Now, we could still do that (since IP_CSUM | IPV6_CSUM
are theoretically deprecated), but then you'd have to be there and help
with some more elbow grease to fix the breakage in mvneta etc, to
convert them to HW_CSUM.
