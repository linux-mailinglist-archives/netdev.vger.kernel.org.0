Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50542335EF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfFCRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:03:29 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43189 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfFCRD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:03:28 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so3117026qtj.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 10:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=am+dNRanSfM5h6HFkfZX425XfgvKMLx1bGpcXWFpu2w=;
        b=u/Svv29crDNnFEKEhTfb/LgHkuzLBxS5231mB05VzvbTGaRDdsuaWYePqvLNLshCge
         MlxHocjWrwMLQtryiaL/vdIRoqwOatMPokxTWRMNnhkRe5h7BEHAVt+O6oNGFx/8D2lT
         XOpL0qFP6q+vgj3I1JSS1li6pg+9i397JOCL8DxkmEPzX7yy/5hheQPDyHyxEb1jYcJx
         KCHWEm9fNpUco6XiHn4FS7ABa/5+ynS/FYeVSjY2vUxpKZyscvFyHsDj2+W1zxwYEPhj
         dNif7qMFfZLk7X5VewGJDDOqQorlzJtO+e9vYEdYVfuloKqu0u3dveMM1gzvBOnd+TJ1
         qIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=am+dNRanSfM5h6HFkfZX425XfgvKMLx1bGpcXWFpu2w=;
        b=Oz20vhwAsM9YUSbStdP7iG3q+t5GmYdiD2Xhg3Eo7FCpetPkyZQai3KrMoK3Lz3dZ3
         Ms4MXoSRU4DLzLCgKP2WHHfHLRhzcoxRVTjLNIY6IEA+4smZWuYQwrN+IZMgeqbfDtqV
         Q/CNBYPc6pVLM1DVIDKa0ILA9FHZBrVmARL6UZpPXW045VibLsqefBJrbjbQmp0yduvP
         KxObDCaDAhOPvPy4PV9Qz/uBidp/QSpKuYhpeJ4A6H27p919/YFKHsDAWLv64bkJh2XW
         cSPTkfrH5Zgl9Cj9E/Izu8TtQhzp4pTDPRJjUFm+sIjHzxubPbOiaPAgxEyxPg251fft
         aKLQ==
X-Gm-Message-State: APjAAAW3DaXN53wJDIy4FOGc0DpvmFsHhOFhPJ/dBf9klHmHP6OmNdA7
        DhJnSNmYf8pRuxtpSLUd6m7E4A==
X-Google-Smtp-Source: APXvYqxFV9OBd1xIJwEZ5biX/0WT3ou36cazkhzkgiK/RguiXqVcdQ81M8Nkji7f030UaHMekeSQxA==
X-Received: by 2002:ac8:303c:: with SMTP id f57mr23859627qte.294.1559581407538;
        Mon, 03 Jun 2019 10:03:27 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m66sm8909018qkb.12.2019.06.03.10.03.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 10:03:27 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:03:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Message-ID: <20190603100321.56a6a6e4@cakuba.netronome.com>
In-Reply-To: <CAJ+HfNix+oa=9oMOg9pVMiVTiM5sZe5Tn6zTE_Bu6gV5M=B7kQ@mail.gmail.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
        <20190531094215.3729-2-bjorn.topel@gmail.com>
        <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
        <20190601125717.28982f35@cakuba.netronome.com>
        <CAJ+HfNix+oa=9oMOg9pVMiVTiM5sZe5Tn6zTE_Bu6gV5M=B7kQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 11:04:36 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On Sat, 1 Jun 2019 at 21:57, Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote: =20
> > > > +   if (!bpf_op || flags & XDP_FLAGS_SKB_MODE)
> > > > +           mode =3D XDP_FLAGS_SKB_MODE;
> > > > +
> > > > +   curr_mode =3D dev_xdp_current_mode(dev);
> > > > +
> > > > +   if (!offload && curr_mode && (mode ^ curr_mode) &
> > > > +       (XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE)) { =20
> > >
> > > if i am reading this correctly this is equivalent to :
> > >
> > > if (!offload && (curre_mode !=3D mode))
> > > offlad is false then curr_mode and mode must be DRV or GENERIC .. =20
> >
> > Naw, if curr_mode is not set, i.e. nothing installed now, we don't care
> > about the diff.
> > =20
> > > better if you keep bitwise operations for actual bitmasks, mode and
> > > curr_mode are not bitmask, they can hold one value each .. according =
to
> > > your logic.. =20
> >
> > Well, they hold one bit each, whether one bit is a bitmap perhaps is
> > disputable? :)
> >
> > I think the logic is fine.
> > =20
>=20
> Hmm, but changing to:
>=20
>        if (!offload && curr_mode && mode !=3D curr_mode)
>=20
> is equal, and to Saeed's point, clearer. I'll go that route in a v3.

Sorry, you're right, the flags get mangled before they get here, so
yeah, this condition should work.  Confusingly.

> > What happened to my request to move the change in behaviour for
> > disabling to a separate patch, tho, Bjorn? :) =20
>=20
> Actually, I left that out completely. This patch doesn't change the
> behavior. After I realized how the flags *should* be used, I don't
> think my v1 change makes sense anymore. My v1 patch was to give an
> error if you tried to disable, say generic if drv was enabled via
> "auto detect/no flags". But this is catched by looking at the flags.
>=20
> What I did, however, was moving the flags check into change_fd so that
> the driver doesn't have to do the check. E.g. the Intel drivers didn't
> do correct checking of flags.

Ugh.  Could you please rewrite the conditions to make the fd >=3D check
consistently the outside if?  Also could you add extack to this:

+	if (!offload && dev_xdp_query(dev, mode) &&
+	    !xdp_prog_flags_ok(dev->xdp_flags, flags, extack))
+		return -EBUSY;

It's unclear what it's doing.
