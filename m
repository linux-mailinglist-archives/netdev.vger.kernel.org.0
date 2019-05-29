Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035B02E709
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE2VG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:06:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35150 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfE2VG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:06:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id w1so4408114qts.2
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 14:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MqXYXRaBFItBsHHkgU4M7KnuPXThq1x3lVkOOfoofs4=;
        b=DK0aeHls+5hd5+F5PjaYUz8T7p+gMl50xHI8x+GB4HvWsTqVxPVOlzrK4D/6+6pp43
         9IRBpx11Ir+dRZIvgT/sGloXbSGlb3OiLklrhKIDGe2Xt01T8WaIJNVnWT8f72G9VZIK
         64GlWDRfMf1yrgUsWuVHsA0aRHnF8LjKDJouSp32rGcNQ7Hafj6K8yzRxcsd1b6Fij/V
         AhfcoRGRN23XVhDxYevzrTFa0oEU1gZwTf8UnriJXJKnHktHOL067h2Q3utFo0Bzx72Q
         MWk3mBZlISZHL8AA4ruBuO63yC0xde2NTsvqNFAbyrrkWShVPnLIwgMdIFpplDZVFaa5
         hIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MqXYXRaBFItBsHHkgU4M7KnuPXThq1x3lVkOOfoofs4=;
        b=LfYATYBSCeHxrB8+ENFeUMZQJgMfc5o0Dxm3MQZAv9rNEyrBmyUjbZTT9SzJjhHo/I
         eRJNuhCqsqbqct7a3Dwz1X891jI7vHP2J25BJxzzl6sdvtfCW1MyUeA78xwX9k3WqbXX
         YCSA9Eo1L/u8J3cwmnisoCVbrVie67YNOq9Hd48PABT0Hoy2Nme88ac0DiHClVZS5HQb
         nOv11Yr0SEnHp0HVCVHGSaf/mbng9+B+rEU68IeueH+1BOGC+2xo2bRSePsvuH9mg3sZ
         /i0UFUkI+3dOK/+xAftHdFBMuWGJHko8+bB3ZVZ1quaVqXXHcq8qIIxv8vNwBzMj8B2t
         23AQ==
X-Gm-Message-State: APjAAAXtNyr2TQnLnKBJ3/JRmjyfJavDzQerfMXePiiuiuFV9eon5k+n
        Gzr+UPK4jqmKAQrWlN0LvdBDrA==
X-Google-Smtp-Source: APXvYqwaZFMYcRgF3kJ1Zbgoq66po7GVwgfHV6dR6e2hhP2Naz8EutD/KUw/qtneqLnPe5uQKpZVJA==
X-Received: by 2002:ac8:24f5:: with SMTP id t50mr76623qtt.285.1559163986409;
        Wed, 29 May 2019 14:06:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y45sm339553qtk.75.2019.05.29.14.06.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 14:06:26 -0700 (PDT)
Date:   Wed, 29 May 2019 14:06:20 -0700
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
Message-ID: <20190529140620.68fa8e64@cakuba.netronome.com>
In-Reply-To: <A9D05E0B-FC24-4904-B3E5-1E069C92A3DA@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
        <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
        <20190528154510.41b50723@cakuba.netronome.com>
        <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
        <20190529121440.46c40967@cakuba.netronome.com>
        <A9D05E0B-FC24-4904-B3E5-1E069C92A3DA@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 20:05:16 +0000, Patel, Vedang wrote:
> [Sending the email again since the last one was rejected by netdev becaus=
e it was html.]
>=20
> > On May 29, 2019, at 12:14 PM, Jakub Kicinski <jakub.kicinski@netronome.=
com> wrote:
> >=20
> > On Wed, 29 May 2019 17:06:49 +0000, Patel, Vedang wrote: =20
> >>> On May 28, 2019, at 3:45 PM, Jakub Kicinski <jakub.kicinski@netronome=
.com> wrote:
> >>> On Tue, 28 May 2019 10:46:44 -0700, Vedang Patel wrote:   =20
> >>>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >>>>=20
> >>>> This adds the UAPI and the core bits necessary for userspace to
> >>>> request hardware offloading to be enabled.
> >>>>=20
> >>>> The future commits will enable hybrid or full offloading for taprio.=
 This
> >>>> commit sets up the infrastructure to enable it via the netlink inter=
face.
> >>>>=20
> >>>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>   =20
> >>>=20
> >>> Other qdiscs offload by default, this offload-level selection here is=
 a
> >>> little bit inconsistent with that :(
> >>>  =20
> >> There are 2 different offload modes introduced in this patch.
> >>=20
> >> 1. Txtime offload mode: This mode depends on skip_sock_check flag bein=
g set in the etf qdisc. Also, it requires some manual configuration which m=
ight be specific to the network adapter card. For example, for the i210 car=
d, the user will have to route all the traffic to the highest priority queu=
e and install etf qdisc with offload enabled on that queue. So, I don=E2=80=
=99t think this mode should be enabled by default. =20
> >=20
> > Excellent, it looks like there will be driver patches necessary for
> > this offload to function, also it seems your offload enable function
> > still contains this after the series:
> >=20
> > 	/* FIXME: enable offloading */
> >=20
> > Please only post offload infrastructure when fully fleshed out and with
> > driver patches making use of it.
>
> The above comment refers to the full offload mode described below. It
> is not needed for txtime offload mode. Txtime offload mode is
> essentially setting the transmit time for each packet  depending on
> what interval it is going to be transmitted instead of relying on the
> hrtimers to open gates and send packets. More details about why
> exactly this is done is mentioned in patch #5[1] of this series.

=46rom looking at this set it looks like I can add that qdisc to any
netdev now *with* offload, and as long as the driver has _any_
ndo_setup_tc implementation taprio will not return an error.=20

Perhaps this mode of operation should not be called offload?  Can't=20
the ETF qdisc underneath run in software mode?

> What we can do is just add the txtime offload related flag and add
> the full offload flag whenever the driver bits are ready. Does that
> address your concern?

That would be a step in the right direction.  And please remove all the
other unused code from the series.  AFAICT this is what the enable
offload function looks like after your set - what's the point of the
'err' variable?

+static int taprio_enable_offload(struct net_device *dev,
+				 struct tc_mqprio_qopt *mqprio,
+				 struct taprio_sched *q,
+				 struct sched_gate_list *sched,
+				 struct netlink_ext_ack *extack,
+				 u32 offload_flags)
+{
+	const struct net_device_ops *ops =3D dev->netdev_ops;
+	int err =3D 0;
+
+	if (TXTIME_OFFLOAD_IS_ON(offload_flags))
+		goto done;
+
+	if (!FULL_OFFLOAD_IS_ON(offload_flags)) {
+		NL_SET_ERR_MSG(extack, "Offload mode is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack, "Specified device does not support taprio offload=
");
+		return -EOPNOTSUPP;
+	}
+
+	/* FIXME: enable offloading */
+
+done:
+	if (err =3D=3D 0) {
+		q->dequeue =3D taprio_dequeue_offload;
+		q->peek =3D taprio_peek_offload;
+ 		q->offload_flags =3D offload_flags;
+	}
+
+	return err;
+}
