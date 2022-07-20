Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B177B57B200
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbiGTHqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiGTHqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 462D65143A
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658303175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbZhJzi1XjEO0VjMc3OCE070kAR/2Bm1MhVgWqQyN3E=;
        b=V1/zPyFpZC/QkAbTxFJDWuzA8u/ntJuC6wGdubJyyecM/NNh0M9vXYn2KmOeKu1gZsXO4J
        W1zzv2ilOzxMA3yt2JUeJ823EUFLNSXefeNVzU+UE2DgaXYU8veFhRCBAt69DQX1u6n5mE
        cwXj0YWWWr0duea7uiL1OrXfj03GRqs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-N9m6-2FTONeWFImOeDBW-w-1; Wed, 20 Jul 2022 03:46:13 -0400
X-MC-Unique: N9m6-2FTONeWFImOeDBW-w-1
Received: by mail-lj1-f200.google.com with SMTP id z11-20020a05651c11cb00b0025d8baefafdso2885712ljo.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TbZhJzi1XjEO0VjMc3OCE070kAR/2Bm1MhVgWqQyN3E=;
        b=Av4wTszA0v/sw6G6e+Qi5KHzR501LB4tgNbyn+mpNh1uozAWrBXifSLHbpVFEGZBT6
         NKmxfzSY1xSo/zqI4i0R/7vlIsrBgYGvVjYL+w5p7qNkHMXlFg+K10sv2j4YrWel3fGf
         lTC5WfQCatgwxiDT5PI3pwXaSRf8lnZxomebkHVaUxjTLJ8l0vL6aezI9H1yAKwDsL15
         t2HFSgUsY8vtHojY+93XC3W2fW5eFa4fvwYH4f2OHscvwDE7PI7qRD4qENc5YSDcO0X6
         Evha4445ChBqwcydIPGVvY1ANiPW1Gb4Vab2gzwoifdBIqwIILshUy0/ywaRN4jWEU4S
         ltAQ==
X-Gm-Message-State: AJIora8LP9qSmg+9MoZopoESBPhBKVf0hoUZa3OlWvLfKXv0tZcprlxM
        +ry6/STzyPwWWogcfTAAaPcd8Q7+4fA/bW/VcB4X+z5iRi2o/ElJ7VYcQRZkeWXmtTsraC8gksc
        bkuk9uZBZ+6v1i2vInackQ/TKu5yLGJdh
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id h21-20020a0565123c9500b0048a03d109dfmr20408788lfv.641.1658303170905;
        Wed, 20 Jul 2022 00:46:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sBHZbWAClAKFaljG/LXylheGAMREbjMAZVjFxCsAUlkvf/2k9MEDHXhq8r7jzuqdP4PcupZRfy2LL4RBym048=
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id
 h21-20020a0565123c9500b0048a03d109dfmr20408782lfv.641.1658303170713; Wed, 20
 Jul 2022 00:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org> <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
 <20220720031436-mutt-send-email-mst@kernel.org> <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
In-Reply-To: <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 15:45:59 +0800
Message-ID: <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 3:42 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Jul 20, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 20, 2022 at 10:07:11AM +0300, Alvaro Karsz wrote:
> > > > Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx
> > > napi on/off.
> > > > However I am not sure we should treat any value != 1 as napi on.
> > > >
> > > > I don't really have good ideas - I think abusing coalescing might
> > > > have been a mistake. But now that we are there, I feel we need
> > > > a way for userspace to at least be able to figure out whether
> > > > setting coalescing to 0 will have nasty side effects.
> > >
> > >
> > > So, how can I proceed from here?
> > > Maybe we don't need to use tx napi when this feature is negotiated (like Jakub
> > > suggested in prev. versions)?
> > > It makes sense, since the number of TX notifications can be reduced by setting
> > > tx_usecs/tx_max_packets with ethtool.
> >
> >
> > Hmm Jason had some ideas about extensions in mind when he
> > coded the current UAPI, let's see if he has ideas.
> > I'll ruminate on compatibility a bit too.
>
> I might be wrong, but using 1 to enable tx napi is a way to try to be
> compatible with the interrupt coalescing.
>
> That is, without notification coalescing, if 1 is set, we enable tx
> notifications (and NAPI) for each packet. This works as if
> tx-max-coalesced-frames is set to 1 when notification coalescing is
> negotiated.
>
> Thanks
>
> >
> > > > It's also a bit of a spec defect that it does not document corner cases
> > > > like what do 0 values do, are they different from 1? or what are max values.
> > > > Not too late to fix?
> > >
> > >
> > > I think that some of the corner cases can be understood from the coalescing
> > > values.
> > > For example:
> > > if rx_usecs=0 we should wait for 0 usecs, meaning that we should send a
> > > notification immediately.
> > > But if rx_usecs=1 we should wait for 1 usec.
> > > The case with max_packets is a little bit unclear for the values 0/1, and it
> > > seems that in both cases we should send a notification immediately after
> > > receiving/sending a packet.

Then we probably need to document this in the spec.

And we need an upper limit for those values, this helps for e.g
migration compatibility.

Thanks

> > >
> > >
> > > > So the spec says
> > > >         Device supports notifications coalescing.
> > > >
> > > > which makes more sense - there's not a lot guest needs to do here.
> > >
> > >
> > > Noted.
> > >
> > > > parameters?
> > >
> > >
> > > I'll change it to "settings".
> > >
> > > > why with dash here? And why not just put the comments near the fields
> > > > themselves?
> > >
> > >
> > > Noted.
> >

