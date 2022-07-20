Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5E657B1F4
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbiGTHmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237035AbiGTHmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:42:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62DEC68DD2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658302954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZvrBy/Kj7TgGhssieadhz1IW2dSYmruA56tkzswN0BA=;
        b=TMWCqpbStI1i99mKz2h/sDq+G5QtFBr/uGu2DZkNtueNZKB76VLyYXl5VYAniHy9unAVAT
        kDsD3hCSHGkgjGVxBSbTVdw/5snwIKQSY1skQY47KFKADQ5uzk+9skey2l6fPRnGJ0+tOp
        dm7FqktCdB2FZrtz2BEzrS5l4FT/OUc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-aohhADqtOGyZWJ-4s3nFHw-1; Wed, 20 Jul 2022 03:42:32 -0400
X-MC-Unique: aohhADqtOGyZWJ-4s3nFHw-1
Received: by mail-lf1-f72.google.com with SMTP id u11-20020a196a0b000000b0048a5270f6b3so1694144lfu.11
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvrBy/Kj7TgGhssieadhz1IW2dSYmruA56tkzswN0BA=;
        b=ONsFXlxbvVc+yEPG2MhmfpGeAWAcICq+M+MSLp/aEHyvCrrBawjMLb16YGuHdTUrUm
         fF4P/2Mab9Ijxr2ZOzUGHaUGeapHGbhof1GWoATrDfsNEcvqBxmmBt6G144uzGuhxsrm
         FNtekFzsj0iutPEz9cIrDZk1bnxwCWda7CLSjilUeDzfsVXwTaSaWO8HLZsHDI6l2WSZ
         Pm6Z4EyXKY+2KPXOATS79ASiDYpqxnvryVpALr4pXtiX1H5kAGABY+os2YnFitEpVFuB
         tPX10q5kwiWUFpUlLv2KCaaMS8QGmUMw0J9TsygwzYkdFgyOb+OuYlvBF1DMkc7DWA0W
         ceWw==
X-Gm-Message-State: AJIora/fDF6HAZTx8zAKr9kCcYr64MRBqwlGvQY3ppNsZ4LgimLkZfUA
        gl/HyBkEPubHGNghQyITctdAtPKDl0O4JZttOQ5liiyXlZOMEBwBMU3L29aFz1/PtSnzAYgPxUo
        hrhdVhz18lVsJbzFNBKsxu/lBdElSxeCz
X-Received: by 2002:a2e:9e17:0:b0:25d:7654:4c6b with SMTP id e23-20020a2e9e17000000b0025d76544c6bmr16766012ljk.130.1658302951399;
        Wed, 20 Jul 2022 00:42:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u8GJqT3LcpFH0qCQvtPFFGg0e8NTDCZrVEPjVa/ZuxTh4N3b2nCdhBDp4yIDDQrfLSoBhH22h/iGh8gFpU1QY=
X-Received: by 2002:a2e:9e17:0:b0:25d:7654:4c6b with SMTP id
 e23-20020a2e9e17000000b0025d76544c6bmr16766004ljk.130.1658302951132; Wed, 20
 Jul 2022 00:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org> <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
 <20220720031436-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220720031436-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 15:42:19 +0800
Message-ID: <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
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

On Wed, Jul 20, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 20, 2022 at 10:07:11AM +0300, Alvaro Karsz wrote:
> > > Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx
> > napi on/off.
> > > However I am not sure we should treat any value != 1 as napi on.
> > >
> > > I don't really have good ideas - I think abusing coalescing might
> > > have been a mistake. But now that we are there, I feel we need
> > > a way for userspace to at least be able to figure out whether
> > > setting coalescing to 0 will have nasty side effects.
> >
> >
> > So, how can I proceed from here?
> > Maybe we don't need to use tx napi when this feature is negotiated (like Jakub
> > suggested in prev. versions)?
> > It makes sense, since the number of TX notifications can be reduced by setting
> > tx_usecs/tx_max_packets with ethtool.
>
>
> Hmm Jason had some ideas about extensions in mind when he
> coded the current UAPI, let's see if he has ideas.
> I'll ruminate on compatibility a bit too.

I might be wrong, but using 1 to enable tx napi is a way to try to be
compatible with the interrupt coalescing.

That is, without notification coalescing, if 1 is set, we enable tx
notifications (and NAPI) for each packet. This works as if
tx-max-coalesced-frames is set to 1 when notification coalescing is
negotiated.

Thanks

>
> > > It's also a bit of a spec defect that it does not document corner cases
> > > like what do 0 values do, are they different from 1? or what are max values.
> > > Not too late to fix?
> >
> >
> > I think that some of the corner cases can be understood from the coalescing
> > values.
> > For example:
> > if rx_usecs=0 we should wait for 0 usecs, meaning that we should send a
> > notification immediately.
> > But if rx_usecs=1 we should wait for 1 usec.
> > The case with max_packets is a little bit unclear for the values 0/1, and it
> > seems that in both cases we should send a notification immediately after
> > receiving/sending a packet.
> >
> >
> > > So the spec says
> > >         Device supports notifications coalescing.
> > >
> > > which makes more sense - there's not a lot guest needs to do here.
> >
> >
> > Noted.
> >
> > > parameters?
> >
> >
> > I'll change it to "settings".
> >
> > > why with dash here? And why not just put the comments near the fields
> > > themselves?
> >
> >
> > Noted.
>

