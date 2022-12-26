Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727C4655F9B
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 04:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiLZDqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 22:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLZDqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 22:46:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C7EDFC
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 19:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672026364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LPML0T2odU1efvKA6TB4e9nlnB9KljoL+oggFMgoV7U=;
        b=Bvu8b1TUY1E2MPEAP3BzBoEoDuDQoKPYHocp/o1Rt8ikM2/YBu6DnfFXD2fNYtdsENvGVf
        zcyJt8SRwssMs5agIdbFIh81blqjCSl0x1EHflJNlJsQP++ghg50WtnIYrmlTWQXc5PEWp
        0CSKvsGT0kho4qwN9OrUtzCV/fgfMpA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-gwr7SG6INlyNpkFS2SuroQ-1; Sun, 25 Dec 2022 22:45:55 -0500
X-MC-Unique: gwr7SG6INlyNpkFS2SuroQ-1
Received: by mail-ot1-f69.google.com with SMTP id e8-20020a9d63c8000000b006704cedcfe2so5875250otl.19
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 19:45:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LPML0T2odU1efvKA6TB4e9nlnB9KljoL+oggFMgoV7U=;
        b=XABv1EsKazpEcy3aBpcjeooz776pwbGPckO67WfRq29sGM7rtGExvRqs1s+Wr135yX
         EjObQmQP0kRRqs5fAy9izKVKY787TI4eTLfb4QQFgPOJGYkRDzshRu6b69wuQ4ybQoOH
         uKEX+OxRUmPC9mWuL23iNiTxw+yLP7zIRe3GJ2FYu2h9yv7oTRWwM476H6IXl9f7Cpjx
         LFXBkHWD795NThf0oB1x99tam8ohFMfICjJ8ymZ8MOqknVEMw8cTAiIWsw2s8rG0b5iy
         1g0qPI2ofj/x6X07pxCMRuq2b8rJTiB982la4ArBfYRVBWy+a5dZtqZn0j8gFl9JSw2y
         wFdQ==
X-Gm-Message-State: AFqh2koTUtqgnIo/oZJKs7xubHvXkNy38zFM0mJY6LA9FEu5dKN0Gkaf
        QP3O3T34xPSCCA/p0t+tSrIRl3NesPnxnNGlVM+4Nz/BsvGNjzwWIeDeikFR0irVEEcYLG7kVnX
        3kDPtyrPa7/QAic+lgbzZnLwxG0BgsLgp
X-Received: by 2002:a05:6830:4a3:b0:670:8334:ccf2 with SMTP id l3-20020a05683004a300b006708334ccf2mr1092692otd.201.1672026354896;
        Sun, 25 Dec 2022 19:45:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4l8sal78jwmSmfNpp5adoBH8DFpxNZ4rOpa5yo3+kGZLSJd99jDWK2hJIcSUrI33x/vEuSXvdG0zyZB3QQ+8=
X-Received: by 2002:a05:6830:4a3:b0:670:8334:ccf2 with SMTP id
 l3-20020a05683004a300b006708334ccf2mr1092684otd.201.1672026354707; Sun, 25
 Dec 2022 19:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com>
 <CACGkMEv4YxuqrSx_HW2uWgXXSMOFCzTJCCD_EVhMwegsL8SoCg@mail.gmail.com>
 <CAJs=3_Akv1zoKy_HARjnqMdNsy_n34TzzGA6a25xrkF2rCnqwg@mail.gmail.com>
 <CACGkMEvtgr=pDpcZeE4+ssh+PiL0k2B2+3kzdDmEvxxe=2mtGA@mail.gmail.com> <CAJs=3_BqDqEoXGiU9zCNfGNqEjd1eijqkE_8_mb3nC=GwQoxHA@mail.gmail.com>
In-Reply-To: <CAJs=3_BqDqEoXGiU9zCNfGNqEjd1eijqkE_8_mb3nC=GwQoxHA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 26 Dec 2022 11:45:43 +0800
Message-ID: <CACGkMEs=YrtP-GT_MKoZdORtYCD09QdmZGpgQUHMOMLG_eX-FA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 3:39 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> > This needs to be proposed to the virtio spec first. And actually we
> > need more than this:
> >
> > 1) we still need a way to deal with the device without this feature
> > 2) driver can't depend solely on what is advertised by the device (e.g
> > device can choose to advertise a very long timeout)
>
> I think that I wasn't clear, sorry.
> I'm not talking about a new virtio feature, I'm talking about a situation when:
> * virtio_net issues a control command.
> * the device gets the command, but somehow, completes the command
> after timeout.
> * virtio_net assumes that the command failed (timeout), and issues a
> different control command.
> * virtio_net will then call virtqueue_wait_for_used, and will
> immediately get the previous response (If I'm not wrong).
>
> So, this is not a new feature that I'm proposing, just a situation
> that may occur due to cvq timeouts.
>
> Anyhow, your solution calling BAD_RING if we reach a timeout should
> prevent this situation.

Right, that is the goal.

Thanks

>
> Thanks
>

