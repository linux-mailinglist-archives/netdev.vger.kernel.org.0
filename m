Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB3D424A6E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhJFXR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJFXRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 19:17:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4485C061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 16:15:29 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y15so16917188lfk.7
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 16:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hYPX4u1EbRkF7geATizCsAO3x8Sc0p2p9R0aKPmTWAE=;
        b=5D41hLmswWy/YR+te5qKgw0WLqynFu4hpQNSvTdLQC5cOyWGjexDb59s9SFsrF1rdF
         HpmEyFFAytelBrXitR9ecKXQBvfSa53yBOViR4D+jHL7mu/hvXQ1GE6NTeyjK2MasDP/
         fE/dIh/IzgKFKGUXpdb97MaH4HOx70Hde49jR3dB8kIInh7cb+7jY6atTtlA6SNqeQTI
         HkR8jO5SmlDluh3ctMH07Sy1mD+PlU2Fu4ZpnHNJIbOSPCVoeeLTZ8eHgaLS0U4u812C
         44dSZz198Ho/RggDiFws7x2thfoiJ/kF/vRtY2rm/zmXRk6I9kZ28k5rb6eHbugtVTio
         gDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hYPX4u1EbRkF7geATizCsAO3x8Sc0p2p9R0aKPmTWAE=;
        b=1sMK6LNqLvolYMxqmveRKONfDaeApb5fxFb5TmfuJrC1tt8EwdwIAie6BEEpIFlN41
         OAObNw73RnIKXLSqAEt7S3yXlxYZrE28T+GdzmE2bNFWSbTqDOCDGmJMn0YFYNNzL58B
         6PY2nqLwrBKCVtGcS7D/+meO+u9qI6cdHDu3gHMWzGT6Xe6CA2NPo/2c+Qf+pmOiQOQQ
         rj+4J9lBGI2MuZwRx7NP+5cLMHKieNUzODYvmci/t2yZq5QfAJY1Tu9ZL4ZFzAhd3AAo
         5qLCJ1oKLl3KKS6oFYrDRiX3J3jyOAATpKoCjk5OiUWX6fahz+mtV3T1BziWTKx1zV+j
         EULA==
X-Gm-Message-State: AOAM532Hfp0I2lFdovfP+qXm7bgAECoutNbTIxocRBz9gzh7XEiiU4fu
        lk5qrUEV0rnV93eKK60ymIHyFg==
X-Google-Smtp-Source: ABdhPJzN9eVIZxxDJBOKF0QmP+z3R0fWvTl/agkgLrSZnSuvQVzvq38o82GTkYaOpnzCPRMc9a93iQ==
X-Received: by 2002:a05:6512:20b:: with SMTP id a11mr820109lfo.179.1633562128088;
        Wed, 06 Oct 2021 16:15:28 -0700 (PDT)
Received: from wkz-x280 (h-155-4-51-145.A259.priv.bahnhof.se. [155.4.51.145])
        by smtp.gmail.com with ESMTPSA id z10sm2553403ljc.117.2021.10.06.16.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:15:27 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: DSA: some questions regarding TX forwarding offload
In-Reply-To: <fdd15403-47b5-fcb5-6fec-870347a8480d@gmail.com>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
 <fdd15403-47b5-fcb5-6fec-870347a8480d@gmail.com>
Date:   Thu, 07 Oct 2021 01:15:26 +0200
Message-ID: <871r4xbv8x.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 19:50, Florian Fainelli <f.fainelli@gmail.com> wrot=
e:
> On 10/5/2021 3:12 AM, Vladimir Oltean wrote:
>> I don't want to answer any of these questions until I understand how
>> does your hardware intend the FID and FID_EN bits from the DSA header to
>> be used. The FID only has 2 bits, so it is clear to me that it doesn't
>> have the same understanding of the term as mv88e6xxx, if the Realtek
>> switch has up to 4 FIDs while Marvell up to 4K.
>>=20
>> You should ask yourself not only how to prevent leakage, but also the
>> flip side, how should I pass the packet to the switch in such a way that
>> it will learn its MAC SA in the right FID, assuming that you go with FDB
>> isolation first and figure that out. Once that question is answered, you
>> can in premise specify an allowance port mask which is larger than
>> needed (the entire mask of user ports) and the switch should only
>> forward it towards the ports belonging to the same FID, which are
>> roughly equivalent with the ports under a specific bridge. You can
>> create a mapping between a FID and dp->bridge_num. Makes sense or am I
>> completely off?
>>=20
>
> Sorry for sort of hijacking this discussion.
>
> Broadcom switches do not have FIDs however using Alvin's topology, and=20
> given the existing bridge support in b53, it also does not look like=20
> there is leaking from one bridge to other because of the port matrix=20
> configuration which is enforced in addition to the VLAN membership.=20
> However based on what I see in tag_dsa.c for the transmit case with=20
> skb->offload_fwd_mark, I would have to dig into the bridge's members in=20
> order to construct a bitmask of ports to provide to tag_brcm.c, so that=20
> does not really get me anywhere, does it?

Presumably this mask is generated in the driver somewhere whenever ports
joins/leaves bridges? Could you not just cache a copy of it in each
port's dp->priv? From there it is easy to get to it from the tagger on
xmit.

> Those switches also always do double VLAN tag (802.1ad) normalization=20
> within their data path whenever VLAN is globally enabled within the=20
> switch, so in premise you could achieve the same isolation by reserving=20
> one of the outer VLAN tags per bridge, enabling IVL and hope that the=20
> FDB is looked including the outer and inner VLAN tags and not just the=20
> inner VLAN tag.
>
> If we don't have a FID concept, and not all switches do, how we can=20
> still support tx forwarding offload here?

In principle, the deal you make with the bridge is basically:

   If you (bridge) give me (driver) a single skb, marked for offloading,
   to one of my ports, I promise to do the Right Thing=E2=84=A2 and forward=
 it
   to the same set of ports that you would have.

If your device needs a port mask instead of a fake DSA chip (what
mv88e6xxx does) in order to make that happen, that should be perfectly
fine.

So the FDB can either do lookups based on {DA} or {DA,VID}, but there is
no level of indirection there? I.e. you cannot have a set of VIDs map to
the same database?

In that case, my guess is that if you want to support multiple bridges
that operate completely independently wrt their FDBs, you will need to
allocate a VID per bridge like you say. That is the only field in the
lookup key that you can control. That VID could also be cached per-port
to keep the tagger overhead down.

> --=20
> Florian
