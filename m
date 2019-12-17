Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A49123680
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 21:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfLQUHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 15:07:16 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43935 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfLQUHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 15:07:16 -0500
Received: by mail-ed1-f66.google.com with SMTP id dc19so9030485edb.10
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 12:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lxKMm+Q20QpTaRO4OM0l94NjyUta3v7Pm5It/ZvcpMc=;
        b=Po1+5Iqaoit9nvlvySgvkgknEE9UjJiih8lLQwXmhioUq8IAZ5Y5vzL6Go++oFRU7/
         X0hUekDwSqbhBM5+VfEBmqnX80p6J9rOPEgh3oPAtO0XfDiX7N3/EbJRrwv83DanJduV
         282gVLFWzF+R9spnuai0Tm5hgtKjmnjeQTtx/kNuxqZtuJZQvxtH22TPDXa461J5zHV/
         gfemkUUJmdW0khonMe98gvP3niMNYxh48LFHdaUNTeGCCMxOlp9YLZ8xsjIC1xGwRsva
         2MVZI8ZczsdOfmsyT+OnMkhlUmU3GsdWfsn+TZdYprLWsM1wvvIoiur6dgCsF4zObMvR
         m1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lxKMm+Q20QpTaRO4OM0l94NjyUta3v7Pm5It/ZvcpMc=;
        b=VQPImniuoBoGVhuNjoBOf2a9z+7RHQIsG9pCAYCrEKNo+/IZz3wVewxoeFlQHjrLQi
         Jtsro1dT8ytlj2LM+rPD6DsF/sxzqi4cJpo0Li+NTTiin7x4tV3QaTHhMKLxPMeZwZ+H
         LPeQwSb7xS4Yg4oCjKxEnjz3oibictgJvLACAIy73vBzHKccU6TkxiBkmtcybAYkG+FW
         UiQyByMi1x+Tc5YvtiYH43aiIbsWfbpV7EceEgYd+q3WZNG3eEc4bUHCrzPwv7Ay0IeF
         Eq7qalxpOxBJt2sZtXxebzfqvXIGpXsK2Tq+Dcuqr4clF4WR2PrYl4CDsu05VijXkUyq
         MysQ==
X-Gm-Message-State: APjAAAXNhQHAri+O4TMxgo8x9XaQCDnHe5KCs3WXN6xuI584E+JxNntF
        bjQhuzuAmKhbbneI35SdVrKlZnUfrm1IklCws3U=
X-Google-Smtp-Source: APXvYqx4dIv6pu1SgEx7abFkfLl+YDR/mZ7UCyzdsWagMVUqtV0N/9sNmQ0bm4TOysZ8RuW+QF2yyHhfXXvi5VIRNo8=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr7463470edq.18.1576613234876;
 Tue, 17 Dec 2019 12:07:14 -0800 (PST)
MIME-Version: 1.0
References: <20191216223344.2261-1-olteanv@gmail.com> <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 17 Dec 2019 22:07:03 +0200
Message-ID: <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jake,

On Tue, 17 Dec 2019 at 21:57, Keller, Jacob E <jacob.e.keller@intel.com> wr=
ote:
>
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Vladimir Oltean
> > Sent: Monday, December 16, 2019 2:34 PM
> > To: davem@davemloft.net; jakub.kicinski@netronome.com
> > Cc: richardcochran@gmail.com; f.fainelli@gmail.com; vivien.didelot@gmai=
l.com;
> > andrew@lunn.ch; netdev@vger.kernel.org; Vladimir Oltean
> > <olteanv@gmail.com>
> > Subject: [PATCH net] net: dsa: sja1105: Fix double delivery of TX times=
tamps to
> > socket error queue
> >
> > On the LS1021A-TSN board, it can be seen that under rare conditions,
> > ptp4l gets unexpected extra data in the event socket error queue.
> >
> > This is because the DSA master driver (gianfar) has TX timestamping
> > logic along the lines of:
> >
> > 1. In gfar_start_xmit:
> >       do_tstamp =3D (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> >                   priv->hwts_tx_en;
> >       (...)
> >       if (unlikely(do_tstamp))
> >               skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
> > 2. Later in gfar_clean_tx_ring:
> >       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
> >               (...)
> >               skb_tstamp_tx(skb, &shhwtstamps);
>
> I'm not sure I fully understand the problem.
>
> I thought the point of SKBTX_IN_PROGRESS was to inform the stack that a t=
imestamp was pending. By not setting it, you no longer do this.
>
> Maybe that has changed since the original implementation? Or am I misunde=
rstanding this patch..?
>

I am not quite sure what the point of SKBTX_IN_PROGRESS is. If you
search through the kernel you will find a single occurrence right now
that is supposed to do something (I don't understand what exactly)
when there is a concurrent sw and hw timestamp.

> You're removing the sja1105 assignment, not the one from the gianfar. Hmm
>
> Ok, so the issue is that sja1105_ptp.c was incorrectly setting the flag.
>
> Would it make more sense for gianfar to set SKBTX_IN_PROGRESS, but then u=
se some other indicator internally, so that other callers who set it don't =
cause the gianfar driver to behave incorrectly? I believe we handle it in t=
he Intel drivers that way by storing the skb. Then we don't check the SKBTX=
_IN_PROGRESS later.

Yes, the point is that it should check priv->hwts_tx_en &&
(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS). That was my initial
fix for the bug, but Richard argued that setting SKBTX_IN_PROGRESS in
itself isn't needed.

There are many more drivers that are in principle broken with DSA PTP,
since they don't even have the equivalent check for priv->hwts_tx_en.

>
> Thanks,
> Jake
>
>

Thanks,
-Vladimir
