Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144583484DF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhCXWq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbhCXWqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:46:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD86C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:46:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y6so300941eds.1
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xwdt9KiYtDI03L746FEPZGOv3sB2yZBpC2mf/Vg4Mv0=;
        b=ptwPV8ds1XAkAcJ/VDG57wCyIX5pvb+pocPovYJsM6jIXpwxsJDFunSEVwarF1jQyH
         KzIKCvPFbYx4ImnKUsxML2ps3GngswWP9WHgdY4bUGdAAWHCKEwTJ25urj42KLy9iNHA
         ziA6WttjNF/5b6FxRqvxuQFe4fGSA+aHSNgiSTsAV4DKiq2Gbc8XL1ChcvoymkbZPpa7
         dBUYWrU4MKNW+QvjJg9BVK5H/mQ0GiIlu/cNvWh86ppbbXmHQ/g7RVxHU59R74UR6d0t
         c/7bBmscvDryI6cBWGt2veXI74UIm+VtRpy0vvI3EMiLMnos+u0tWVdZG10W0rpdW6lG
         /gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xwdt9KiYtDI03L746FEPZGOv3sB2yZBpC2mf/Vg4Mv0=;
        b=Io19f2hWYF1j2gYpluSBbKcdmzONgdAznY7iyCqpCp7hyFJxEwMFTfMao1ooqGXuQg
         gDN0gUC4oF7Nf+fvLLHI/vw6K0Th81Y8RfdQy2doNMWnKI9+qBf1/GNtEkJRPkXmKy6K
         XGm6CNEHcJyjzCDxAnIHm9khemaC0sMLJfxVu98e7cfIGG2sFb3E4ZbTYl/gq5U4udgZ
         6rb7McaPiLBI1Mts9aj8RpEcKhwV3R3o4y8z1uTxpmgKQsyAF+W/ID/LaKtc6EYbhTlR
         egfQMCrNJP0ATMFVCEdu9uEKGqQnVi0eUKJGSjsdILDea7ojSoroh/muHvzx2bkQrwuf
         Aj+A==
X-Gm-Message-State: AOAM532/eDbw/f5yjIVDpwTlAHW0TP8QXPYnCZUT4Two3wmekYaH0ghc
        Tu4vQS2bHo1LZV16Xlm77b/a5AYww5s=
X-Google-Smtp-Source: ABdhPJyWrQpWnt4CuzMtynOWdqn51NNilNHoXH4dg8uQSkJzJ04Z9D68rRVBQeiPsQZUnxVwxxZLgw==
X-Received: by 2002:a05:6402:32a:: with SMTP id q10mr5797249edw.15.1616625994154;
        Wed, 24 Mar 2021 15:46:34 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id cb17sm1822606edb.10.2021.03.24.15.46.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:46:33 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id o16so444028wrn.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:46:33 -0700 (PDT)
X-Received: by 2002:adf:fa08:: with SMTP id m8mr5807200wrr.12.1616625992864;
 Wed, 24 Mar 2021 15:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
 <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
 <efa5f117ad63064f7984655d46eb5140d23b0585.camel@redhat.com>
 <CA+FuTScT9W5V-ak=Wq_7zswyDRo9rzjOK1SQNRxESBCL93BOVQ@mail.gmail.com> <7974ce16adc27164afa63170483bb4371894c5e1.camel@redhat.com>
In-Reply-To: <7974ce16adc27164afa63170483bb4371894c5e1.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Mar 2021 18:45:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd+jRVCWq5Y-E=vsJcvSL2MpgyjpYaNk8o2JPMWE8ryyg@mail.gmail.com>
Message-ID: <CA+FuTSd+jRVCWq5Y-E=vsJcvSL2MpgyjpYaNk8o2JPMWE8ryyg@mail.gmail.com>
Subject: Re: !
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:51 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-03-23 at 21:54 -0400, Willem de Bruijn wrote:
> > > I did not look at that before your suggestion. Thanks for pointing out.
> > >
> > > I think the problem is specific to UDP: when processing the outer UDP
> > > header that is potentially eligible for both NETIF_F_GSO_UDP_L4 and
> > > gro_receive aggregation and that is the root cause of the problem
> > > addressed here.
> >
> > Can you elaborate on the exact problem? The commit mentions "inner
> > protocol corruption, as no overaly network parameters is taken in
> > account at aggregation time."
> >
> > My understanding is that these are udp gro aggregated GSO_UDP_L4
> > packets forwarded to a udp tunnel device. They are not encapsulated
> > yet. Which overlay network parameters are not, but should have been,
> > taken account at aggregation time?
>
> The scenario is as follow:
>
> * a NIC has NETIF_F_GRO_UDP_FWD or NETIF_F_GRO_FRAGLIST enabled
> * an UDP tunnel is configured/enabled in the system
> * the above NIC receives some UDP-tunneled packets, targeting the
> mentioned tunnel
> * the packets go through gro_receive and they reache
> 'udp_gro_receive()' while processing the outer UDP header.
>
> without this patch, udp_gro_receive_segment() will kick in and the
> outer UDP header will be aggregated according to SKB_GSO_FRAGLIST
> or SKB_GSO_UDP_L4, even if this is really e.g. a vxlan packet.
>
> Different vxlan ids will be ignored/aggregated to the same GSO packet.
> Inner headers will be ignored, too, so that e.g. TCP over vxlan push
> packets will be held in the GRO engine till the next flush, etc.
>
> Please let me know if the above is more clear.

Yes, thanks a lot! That's very concrete.

When processing the outer UDP tunnel header in the gro completion
path, it is incorrectly identified as an inner UDP transport layer due
to NAPI_GRO_CB(skb) identifying that such a layer is present
(is_flist).

The issue is that the UDP GRO layer distinguishes between tunnel and
transport layer too late, in udp_gro_complete, while an offending
assumption of that UDP == transport layer was already made in the
callers udp4_gro_complete and udp6_gro_complete.
