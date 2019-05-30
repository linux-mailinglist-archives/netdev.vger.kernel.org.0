Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5104330363
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3UlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:41:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37026 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3UlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:41:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so4851100qkl.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 13:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=f5E0mA5EJgN67XjHcWSoimcwtGSg4IIi6lDpuHoTf3A=;
        b=VnKcVxjYZkufLSXo1mQwurs8pn/4FCkyQ0vGBFkGv1IZrARf5Jm9s0v6giq65h8/x6
         5pbSNgiRsEYkGbuxQSNjs+JnFABotZ3P+QESihl7yx5J4mn9wm7ugjS90dyXzdGUmigd
         +ick3x8X/c3HpUrZx9ogoTOYK35ZZk6s9kK+qWu8+SLtz70WL3qRV8X8ED5ieIXHga2r
         0nONmLMtCBZi267IWB6AOyXJa7hCO2Mrd0xtqU4TpOVlIrfWU+Pts79BPRYpEoVVtrKQ
         /fyZ+bK6HVy0bLS+hIX2Ac2lZx7L1OFSC0iXanWx0dffcJkV1Zo3sA44E/j8226OA0dp
         XS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=f5E0mA5EJgN67XjHcWSoimcwtGSg4IIi6lDpuHoTf3A=;
        b=s3Jg1/nJmbpHTaxCNAvzYUHPsT4WHslxINTv+oUTBfcBRn9K7+XaFxwopxkLatQboz
         pkg/iva0IVeD+ntN6xWQmxq1wqxEz7cIxGDAb7D4oiUw35ZzufUjRMEzebZEui4lnUDd
         EdX/aYo6fjb8GnomTDJ8NmA3zGKQ/Pk1a46HK/AhF+xThQ5klVfpCbDY1prJEoZUQVWA
         60qgwdp7HOdXcp/VKLYeCE7zN2is/87wKamL/OP8b4ObrhTg0SfkAp01THAxT3LF5jCj
         /l+g0wRjyqX0TKMPQElJkgH/Xr2Dks0OJdQ9h24KiZcJAVbuUD/Wukmmd19wPL00LgiM
         m4Mw==
X-Gm-Message-State: APjAAAUg04xdPaQ8Ir/yn1KLl2fViO147CXpyDacrWuxHpLHZwoL8tHR
        vC2CXQ+BFExjLObyabKzq+jbuQ==
X-Google-Smtp-Source: APXvYqzxEUVPph26eeKVeACUsWd/jmLha5zO0+5SbjUPvatAIj8u4pwF7Ljv8oB1l7zJefBKZ/MoNQ==
X-Received: by 2002:a37:640f:: with SMTP id y15mr5025019qkb.79.1559248881371;
        Thu, 30 May 2019 13:41:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a64sm1712514qkd.73.2019.05.30.13.41.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 13:41:20 -0700 (PDT)
Date:   Thu, 30 May 2019 13:41:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
Subject: Re: [PATCH net-next v1 3/7] taprio: Add the skeleton to enable
 hardware offloading
Message-ID: <20190530134115.36f13bb5@cakuba.netronome.com>
In-Reply-To: <861F87D1-6A0B-438D-BBD5-6A15BDA398F7@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
        <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
        <20190528154510.41b50723@cakuba.netronome.com>
        <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
        <20190529121440.46c40967@cakuba.netronome.com>
        <A9D05E0B-FC24-4904-B3E5-1E069C92A3DA@intel.com>
        <20190529140620.68fa8e64@cakuba.netronome.com>
        <861F87D1-6A0B-438D-BBD5-6A15BDA398F7@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 00:21:39 +0000, Patel, Vedang wrote:
> > On May 29, 2019, at 2:06 PM, Jakub Kicinski <jakub.kicinski@netronome.c=
om> wrote:
> > On Wed, 29 May 2019 20:05:16 +0000, Patel, Vedang wrote: =20
> >> [Sending the email again since the last one was rejected by netdev bec=
ause it was html.]
> >>  =20
> >>> On May 29, 2019, at 12:14 PM, Jakub Kicinski <jakub.kicinski@netronom=
e.com> wrote:
> >>>=20
> >>> On Wed, 29 May 2019 17:06:49 +0000, Patel, Vedang wrote:   =20
> >>>>> On May 28, 2019, at 3:45 PM, Jakub Kicinski <jakub.kicinski@netrono=
me.com> wrote:
> >>>>> On Tue, 28 May 2019 10:46:44 -0700, Vedang Patel wrote:     =20
> >>>>>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >>>>>>=20
> >>>>>> This adds the UAPI and the core bits necessary for userspace to
> >>>>>> request hardware offloading to be enabled.
> >>>>>>=20
> >>>>>> The future commits will enable hybrid or full offloading for tapri=
o. This
> >>>>>> commit sets up the infrastructure to enable it via the netlink int=
erface.
> >>>>>>=20
> >>>>>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >>>>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>     =20
> >>>>>=20
> >>>>> Other qdiscs offload by default, this offload-level selection here =
is a
> >>>>> little bit inconsistent with that :(
> >>>>>  =20
> >>>> There are 2 different offload modes introduced in this patch.
> >>>>=20
> >>>> 1. Txtime offload mode: This mode depends on skip_sock_check flag be=
ing set in the etf qdisc. Also, it requires some manual configuration which=
 might be specific to the network adapter card. For example, for the i210 c=
ard, the user will have to route all the traffic to the highest priority qu=
eue and install etf qdisc with offload enabled on that queue. So, I don=E2=
=80=99t think this mode should be enabled by default.   =20
> >>>=20
> >>> Excellent, it looks like there will be driver patches necessary for
> >>> this offload to function, also it seems your offload enable function
> >>> still contains this after the series:
> >>>=20
> >>> 	/* FIXME: enable offloading */
> >>>=20
> >>> Please only post offload infrastructure when fully fleshed out and wi=
th
> >>> driver patches making use of it. =20
> >>=20
> >> The above comment refers to the full offload mode described below. It
> >> is not needed for txtime offload mode. Txtime offload mode is
> >> essentially setting the transmit time for each packet  depending on
> >> what interval it is going to be transmitted instead of relying on the
> >> hrtimers to open gates and send packets. More details about why
> >> exactly this is done is mentioned in patch #5[1] of this series. =20
> >=20
> > From looking at this set it looks like I can add that qdisc to any
> > netdev now *with* offload, and as long as the driver has _any_
> > ndo_setup_tc implementation taprio will not return an error.=20
> >=20
> > Perhaps this mode of operation should not be called offload?  Can't=20
> > the ETF qdisc underneath run in software mode?
> >  =20
> Yeah, it doesn=E2=80=99t make much sense to run ETF in software mode but =
it
> can be done. What about naming it txtime-assist instead?

Sounds good!  txtime.* works for me.

> >> What we can do is just add the txtime offload related flag and add
> >> the full offload flag whenever the driver bits are ready. Does that
> >> address your concern? =20
> >=20
> > That would be a step in the right direction.  And please remove all the
> > other unused code from the series.  AFAICT this is what the enable
> > offload function looks like after your set - what's the point of the
> > 'err' variable?
> >  =20
> Yes. This patch seems to have a few really silly mistakes. I
> apologize for that. I willl clean it up and send another version of
> the series. There is no unused code anywhere else in the series.

Thanks!
