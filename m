Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288D9677D81
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjAWODP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWODO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F53265BE
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674482522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ob/X2Lk8QlnO3+PobfsCOweUDDV5F6OFU41UzjSYi4=;
        b=icfRrtQWUDtF4Jx2T4wKbLIw5qcat3/Ls7zNh4U/GNtaJBmnV77t0+dmeqOJVVwGL3R36W
        UdzHVjod7rMJxijpLHSSGz5AVAqjUJy8w76Ljod3Yz7c/lhuLSudftn4q9/P+YD3+i5ys3
        IKDrN/+IUoQFBiiYHCo1XKYBR6s9R3A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-dLx0TzZMOsaaTvJWLN9vSw-1; Mon, 23 Jan 2023 09:01:55 -0500
X-MC-Unique: dLx0TzZMOsaaTvJWLN9vSw-1
Received: by mail-ej1-f70.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso7834028ejc.23
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:01:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ob/X2Lk8QlnO3+PobfsCOweUDDV5F6OFU41UzjSYi4=;
        b=g285B5Rn1aB6tZ7yXmCOzBhamWXueV1gMhzTXl1eiapXWDh7rh3xU9Y4idbjE8plsk
         l55Ucxr8OJe1XibfX1FQMOx37phvP5iAV2Q/rbNS53e8vIyHEXaUlBBbmppXrAOTCN97
         WXJE1OPxUe1cKyLrxBZ3uHRL2zU7KpSQLD89x8JYJSwZn2yhIKRtx9DNz/yQQ2rn25Hp
         60q12sZ9aCS9LYE98IbNW8F3sP/6zjAfu6T/wDyrGXQUL5imuHkZ95qdxiRkULEZHVNm
         aGGZLNM0Td6WLmllS3Il8pTs4rlGbxvrHdaYInnajw0po9T5QO59pNg1fs1oWDvCh4sW
         MR/A==
X-Gm-Message-State: AFqh2krbH74ZXlb1RjKV9n6QYjkXYjHAq/s4GsVmnlySSjfw0Wva5eJi
        TSUpvuTgSbhK6rBxdPwg6HxpuNhgIA0yAgsSdAZ/B6zmvAzvxKcvxvsRuINmFAPl7fQVbvkpRpL
        XfS6HDODelZ4A6JEyTVpr+TFXLtUsAng5
X-Received: by 2002:a17:906:454b:b0:847:dc26:fb5a with SMTP id s11-20020a170906454b00b00847dc26fb5amr1938774ejq.329.1674482512636;
        Mon, 23 Jan 2023 06:01:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvVCH5JHXLuFNDsR5AtDhOX7OfEDcPt+3kSysnQxHfxvn2bJlBnMQS9g0s2pVHVPkizkgBZSRJzioQ/QC9zCdw=
X-Received: by 2002:a17:906:454b:b0:847:dc26:fb5a with SMTP id
 s11-20020a170906454b00b00847dc26fb5amr1938761ejq.329.1674482512302; Mon, 23
 Jan 2023 06:01:52 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com> <20230118102058.3b1f275b@xps-13>
In-Reply-To: <20230118102058.3b1f275b@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 23 Jan 2023 09:01:41 -0500
Message-ID: <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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

Hi,

On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
>
> > Hi,
> >
> > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Scanning being now supported, we can eg. play with hwsim to verify
> > > everything works as soon as this series including beaconing support gets
> > > merged.
> > >
> >
> > I am not sure if a beacon send should be handled by an mlme helper
> > handling as this is a different use-case and the user does not trigger
> > an mac command and is waiting for some reply and a more complex
> > handling could be involved. There is also no need for hotpath xmit
> > handling is disabled during this time. It is just an async messaging
> > in some interval and just "try" to send it and don't care if it fails,
> > or? For mac802154 therefore I think we should use the dev_queue_xmit()
> > function to queue it up to send it through the hotpath?
> >
> > I can ack those patches, it will work as well. But I think we should
> > switch at some point to dev_queue_xmit(). It should be simple to
> > switch it. Just want to mention there is a difference which will be
> > there in mac-cmds like association.
>
> I see what you mean. That's indeed true, we might just switch to
> a less constrained transmit path.
>

I would define the difference in bypass qdisc or not. Whereas the
qdisc can drop or delay transmitting... For me, the qdisc is currently
in a "works for now" state.

> In practice, what is deliberately "not enough" here is the precision
> when sending the beacons, eg. for ranging purposes (UWB) we will need
> to send the beacons at a strict pace. But there are two ways for doing
> that :
> - use a dedicated scheduler (not supported yet)
> - move this logic into a firmware, within an embedded controller on the
>   PHY
>

then bypassing qdisc would be better.

> But that is something that we will have to sort out later on. For now,
> let's KISS.
>
> > btw: what is about security handling... however I would declare this
> > feature as experimental anyway.
>
> I haven't tested the security layer at all yet, would you have a few
> commands to start with, which I could try using eg. hwsim?

hwsim should work. But again don't trust the transmit side, there are
currently problems. Wireshark has also a feature to give the key and
encrypt on the fly for 802.15.4.

- Alex

