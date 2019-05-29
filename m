Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8592E520
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfE2TOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:14:47 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:42974 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2TOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:14:47 -0400
Received: by mail-vs1-f65.google.com with SMTP id z11so2695598vsq.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6KmtBCb39PWu4BYvpVu41VYk+/LHSYem2VpD68bT+PE=;
        b=YIcL6JjOWeCW83aX0FGg7zG1iQK1GcccXfTlzkTal2Gz00J25gb09ZtrbivAfNEg3B
         C+4qBOGhpfGh4BpjWriuc0o8t4d7IXdJbq8FzDRBH4EffxHd99c5pQ/l+4Uduu4SuP4I
         fbR8xJBOMRVNSSwoUzHV8vN/wo2OdEj1Tixh9Gc8123/G3YPHDYo6qbYlQm5MAOEA6v5
         yFU0ZO8NdpSNfaF4ZHdbOUTu3UmlLKdLcjBQFFLzydHGumUiSVNXFaYOml9socE8J85B
         SXLWAKnCihYRqfO1WTbeu6Yn79spxlwrjaaGa5R1NlPtyatqWZLDTtNEjcer68q5kbH1
         1pmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6KmtBCb39PWu4BYvpVu41VYk+/LHSYem2VpD68bT+PE=;
        b=mKFqw1Fvokn4/JOQ6cTWibRuSZeFhQGXtIM5nyT56ZGYzTKXzmd/WvexXEA204oqdG
         OzQDVBJu785hposcTw8Dj0fmkBPFVfPfEWK/xQxp1qZk/uwyNszHNOADpFnY71BySoAF
         f0e2DeGCb2p9ziqXzE13rsQvYUiIwE/IWlL+3MW2yeoi70L8ag4/1P/F4ZEx6x8sBFk2
         1buiJb8uA3yR//CXXNwXcbfhHHiXE5vntHCirfGphP/ILE4ffTmNl9tJSpeqogdpt+EM
         NCiaVk9LxLOrp15uILc3ViKyErDbV5sEtOOK9rfgzbE85RghdWdYzY7h23JGHATNppqy
         2wVQ==
X-Gm-Message-State: APjAAAXZ+lboizMCr9to1BZpbfFnCeo67EB1d30sDefEdY2C56z+3Thy
        k23qhp7NSRsQ12VTXRo+lL8BjA==
X-Google-Smtp-Source: APXvYqz5WZBmzj3nMAQfeCtj1nrssdj/JlP4GNQYfGvSj7626LjuCkoVB7Gy80Wq6CzSym1ztVYOYQ==
X-Received: by 2002:a05:6102:105d:: with SMTP id h29mr72929028vsq.84.1559157286609;
        Wed, 29 May 2019 12:14:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o11sm303939vkf.13.2019.05.29.12.14.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 12:14:46 -0700 (PDT)
Date:   Wed, 29 May 2019 12:14:40 -0700
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
Message-ID: <20190529121440.46c40967@cakuba.netronome.com>
In-Reply-To: <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
        <1559065608-27888-4-git-send-email-vedang.patel@intel.com>
        <20190528154510.41b50723@cakuba.netronome.com>
        <62E2DD49-AC21-46DE-8E5B-EBC67230FA7D@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 17:06:49 +0000, Patel, Vedang wrote:
> > On May 28, 2019, at 3:45 PM, Jakub Kicinski <jakub.kicinski@netronome.c=
om> wrote:
> > On Tue, 28 May 2019 10:46:44 -0700, Vedang Patel wrote: =20
> >> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >>=20
> >> This adds the UAPI and the core bits necessary for userspace to
> >> request hardware offloading to be enabled.
> >>=20
> >> The future commits will enable hybrid or full offloading for taprio. T=
his
> >> commit sets up the infrastructure to enable it via the netlink interfa=
ce.
> >>=20
> >> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >> Signed-off-by: Vedang Patel <vedang.patel@intel.com> =20
> >=20
> > Other qdiscs offload by default, this offload-level selection here is a
> > little bit inconsistent with that :(
> >  =20
> There are 2 different offload modes introduced in this patch.
>=20
> 1. Txtime offload mode: This mode depends on skip_sock_check flag being s=
et in the etf qdisc. Also, it requires some manual configuration which migh=
t be specific to the network adapter card. For example, for the i210 card, =
the user will have to route all the traffic to the highest priority queue a=
nd install etf qdisc with offload enabled on that queue. So, I don=E2=80=99=
t think this mode should be enabled by default.

Excellent, it looks like there will be driver patches necessary for
this offload to function, also it seems your offload enable function
still contains this after the series:

	/* FIXME: enable offloading */

Please only post offload infrastructure when fully fleshed out and with
driver patches making use of it.

> 2. Full offload mode: This mode is currently not supported by any network=
 driver. The support for this will be coming soon. But, we can enable this =
mode by default.=20
>=20
> Also, from what Vinicius tells me, offload modes for cbs, etf and mqprio =
are also disabled by default. So, it will make more sense to keep it disabl=
ed to be consistent with other qdiscs similar to this one.
