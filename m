Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC28433D8E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhJSRhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhJSRhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:37:54 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B08C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:35:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so15806357eds.9
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=JC1fxc3Mpocb/zt8LVoDRU+WWCRszoymiZrPcMwe9dc=;
        b=nFBFwXlCPcGTU4AqnY12jMiGPpejLyJy/UcrPhVYOn9sSLMYUmFedyxEoxhl2eLRbJ
         xyFO+urrLS/OYE7Wl2Qr+t1g2GDSd+HfQUYvZDfos3TRvdXdvlAs2d8smHddvqBnB9cW
         xPmj43j7rtn7TCJMXW5zkPuHn0VmdSivkn2FmdMVKjJ6aqWbH7MeroODQWZGZA8YDBoO
         IUr6F7aizRXN70IVcCD88KZmWYphPFJr1i1AMRHThPHWskiLjz+LGVagXFPX3KJnZaba
         rexW0knrnlLNQ7jYYnc0DMuI0W2bvMjZ7F6Y9Bnolmr0a7btdJtWe0Hr4KUf0hlSkFXq
         tHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=JC1fxc3Mpocb/zt8LVoDRU+WWCRszoymiZrPcMwe9dc=;
        b=z1v6w1uhywvDJUKYuOvbtBX0GE5YM6RI9SugeSQz5Bz4YI01m+kpy/XfgVAMBOqcTE
         af5naPJodzPgIBJdjg0ACBfbmHGNcgJNQsO8cpBpql91HD2HnIAl1Pzs6gUAN0eLicFW
         h9x3GZEjWmC0O1QImOfFt+c9S2ihtGT3XqJtte0046kcqsi0Ika78yPsKG3+59ZqqAIf
         aOiju7xqCNUXRI6vSDzviggrLYOLJkicAE/0uGoGTON23GK3xInRwssDFQ+AqTxWpary
         7jw0qhbRC2J2oF4oFqjPCCdCzJ8FucyZikeLi7RE8I2mqvKcSh7rMz8IPz7AkPPiRUUZ
         NDDw==
X-Gm-Message-State: AOAM533o6/QEGt1ZFGz0qBlrerrK6tsGBFcMuHFMKomtjPswT15o0BUT
        sVJ61sqUEZ0hpSyaIF9MPhzzHNnpOy/3tc3O1dDD6w==
X-Google-Smtp-Source: ABdhPJyNjag4R3MK/kJth5oyR63DRmLgUJ1fuF3XdLirI/zaX5ch7jpA6qdtZsxqNFOhGwdkJRrbRoNOklBQhtCgWMM=
X-Received: by 2002:a17:907:75e4:: with SMTP id jz4mr38713923ejc.106.1634664867810;
 Tue, 19 Oct 2021 10:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211018183709.124744-1-erik@kryo.se> <YW7k6JVh5LxMNP98@lunn.ch> <20211019155306.ibxzmsixwb5rd6wx@gmail.com>
In-Reply-To: <20211019155306.ibxzmsixwb5rd6wx@gmail.com>
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 19 Oct 2021 19:34:16 +0200
Message-ID: <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
To:     Andrew Lunn <andrew@lunn.ch>, Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 17:53, Martin Habets <habetsm.xilinx@gmail.com> wrote:
>
> On Tue, Oct 19, 2021 at 05:31:52PM +0200, Andrew Lunn wrote:
> > On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > > These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> > > for 1000BaseX and missing 10G link modes") back in 2016.
> > >
> > > Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> > >
> > > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> >
> > Did you test with a Copper SFP modules?
> >

I have tested it with a copper SFP PHY at 1G and that works fine.
I don't have the hardware to test copper 10G (RJ45).

> > > +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> > > @@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
> > >     case MC_CMD_MEDIA_QSFP_PLUS:
> > >             SET_BIT(FIBRE);
> > >             if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> > > -                   SET_BIT(1000baseT_Full);
> > > +                   SET_BIT(1000baseX_Full);
> >
> > I'm wondering if you should have both? The MAC is doing 1000BaseX. But
> > it could then be connected to a copper PHY which then does
> > 1000baseT_Full? At 1G, it is however more likely to be using SGMII,
> > not 1000BaseX.

Yes, we can return both.

Similarly, is there a reason only CR modes are set for fiber ports,
when I expect LR/SR/etc to work as well?
I can set the modes for 10G similar to the example in 5711a98221443
("net: ethtool: add support
for 1000BaseX and missing 10G link modes"): CR/SR/LR/ER
I inserted a LR SFP+ module and ethtool -m could list its settings at least.

>
> Yes, they should both be set. We actually did a 10Gbase-T version of Siena,
> the SFN51x1T.
>

For the baseT-version of the cards the supported modes are set further
down in the file
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/sfc/mcdi_port_common.c#n149),
so they are not affected by this change.

Thanks
/Erik
