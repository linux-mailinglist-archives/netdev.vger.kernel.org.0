Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E82CE650
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgLDDPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:15:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgLDDPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:15:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607051665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ZZBwHUlkAo2mQlf/omWRQ3U/VftHPedEX4GpVFBakM=;
        b=Adl2DmBruljD8/IcVOV0N46HT/F9H/U3qSGSpzhy2Cf/Py19dSYggw12MV6wVlw/a/o0+m
        dmdOv3hwLZbKiNHe3C4bYugYdNC/dazGkSgEa9h2L4ns7mQecmiWClsh4hX6veTLLNZS5/
        r+r+Ct7T0b+lApUZQ0D1Bw6Gi5dNXdA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-cyuCk2P6Po6k9MIKKZHUYw-1; Thu, 03 Dec 2020 22:14:24 -0500
X-MC-Unique: cyuCk2P6Po6k9MIKKZHUYw-1
Received: by mail-oo1-f70.google.com with SMTP id 4so1996173ooc.21
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZZBwHUlkAo2mQlf/omWRQ3U/VftHPedEX4GpVFBakM=;
        b=bSQmgQKTSCj2/MTaPl0FPFTa3AV1rpjyx8uqItwEAuH1D16OloBc4BnyfT7cciitJd
         tGYvJvWdvJZUn5utodnKn+rxcZTwie1QPJKa/j+r1YX7sr62i1EAOmzapsjHqADtXErw
         h3OQauOX6U8KaYHanoJ00w2jD/mPqbCmvnLx4yqETWDO6yGdQJsvwOJ5hCHE9lLrIJJe
         /564aoOGtKbvxnx3F8Eq4JeqSkQoFyb8Ovcpj57wlah1KXhycUFZpwgoUfaXTz4KhgwX
         4Hyt/cZS2KEdCi15KrzSk3uQ/rOE+oUG1MHyn36zNXeqOVQd2TXUalL1hrG1fP2k2hoj
         bRww==
X-Gm-Message-State: AOAM533jah4oIw9uAoUa+2PIFSu3uv0pFLILkAnXboOmwbf3qL/KO8tM
        9v0fwtsn7kNt2RZctdxxdM1IizPTx9v+KDD6B9j9S1ueAxaluIYkEJthh7SQWYA5PX4R6s5rdQp
        SuBTOywAbNDENRCHc/3GSd1FNaTvoMdRL
X-Received: by 2002:aca:6255:: with SMTP id w82mr1659240oib.5.1607051663226;
        Thu, 03 Dec 2020 19:14:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzN78hUw/JrQhIanA7/trcLFQiN483Vjgq0gjfKP4OUu5Z+B+wiDa39AEa3lTF8AmmP9mJgTqDbGW6a6i4SCMM=
X-Received: by 2002:aca:6255:: with SMTP id w82mr1659227oib.5.1607051663014;
 Thu, 03 Dec 2020 19:14:23 -0800 (PST)
MIME-Version: 1.0
References: <20201202173053.13800-1-jarod@redhat.com> <20201203004357.3125-1-jarod@redhat.com>
 <20201203085001.4901c97f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203085001.4901c97f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Thu, 3 Dec 2020 22:14:12 -0500
Message-ID: <CAKfmpSd7JH4Y--z=8iPxekzSeAr0AVmQFPHaOYX71dcRoJouXQ@mail.gmail.com>
Subject: Re: [PATCH net v3] bonding: fix feature flag setting at init time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 11:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  2 Dec 2020 19:43:57 -0500 Jarod Wilson wrote:
> >       bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> > -#ifdef CONFIG_XFRM_OFFLOAD
> > -     bond_dev->hw_features |= BOND_XFRM_FEATURES;
> > -#endif /* CONFIG_XFRM_OFFLOAD */
> >       bond_dev->features |= bond_dev->hw_features;
> >       bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
> >  #ifdef CONFIG_XFRM_OFFLOAD
> > -     /* Disable XFRM features if this isn't an active-backup config */
> > -     if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
> > -             bond_dev->features &= ~BOND_XFRM_FEATURES;
> > +     bond_dev->hw_features |= BOND_XFRM_FEATURES;
> > +     /* Only enable XFRM features if this is an active-backup config */
> > +     if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
> > +             bond_dev->features |= BOND_XFRM_FEATURES;
> >  #endif /* CONFIG_XFRM_OFFLOAD */
>
> This makes no functional change, or am I reading it wrong?

You are correct, there's ultimately no functional change there, it
primarily just condenses the code down to a single #ifdef block, and
doesn't add and then remove BOND_XFRM_FEATURES from
bond_dev->features, instead omitting it initially and only adding it
when in AB mode. I'd poked at the code in that area while trying to
get to the bottom of this, thought it made it more understandable, so
I left it in, but ultimately, it's not necessary to fix the problem
here.

-- 
Jarod Wilson
jarod@redhat.com

