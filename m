Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C8667F3E0
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjA1B6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjA1B6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:58:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4497BBC7
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674871049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ev6Iprgm0BfLCNvx4GMlcEnMLp0hyf/TajiPKchsa84=;
        b=UsG083x/J4dnMSB1B9tGHlcWfYLjJVUianqBjE95Xies15pLfQt+3jXN+8Nq/mXPomBB7I
        rZQeL1Mtp8foK8sp6IiRqqpY7q6ocEHDr4VoITqtkj/sd0k2VltuReuSWM1VIJD6va+270
        /mEYota6rp9eyfo2IUuJ3JGCbJCQxU0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-X9KN1PFPPLCarA3tmhMaZw-1; Fri, 27 Jan 2023 20:57:20 -0500
X-MC-Unique: X9KN1PFPPLCarA3tmhMaZw-1
Received: by mail-ed1-f71.google.com with SMTP id m12-20020a056402430c00b0049e4ac58509so4674404edc.16
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ev6Iprgm0BfLCNvx4GMlcEnMLp0hyf/TajiPKchsa84=;
        b=p7651HUZnGOosXz6u+3ANqfaFZ7gnVQGx6r8kd93f0N0lQ8//FlT0lJJy3se5Mx4a2
         fOcIH2lPh9aapG0ZtzbboEJxUX/WMgAporqY5gKcmDFz1A2us6j87iM5GqT6ZTIbBa2a
         NlgDuUw1y/wFYJ2ymyBM7lp6b6Uv1EzSP9QiK4djmshrkxkxTYib+HBcHJxz6J6wh/aM
         PRY3+bZIfa202OjlXmFFOIw/WtXL+tiaFot5vyq45f354TZ8Ge8B3SY/r/TL0NRxa0w/
         KiGWiS340yzAOBzeYFmMpdCmXhWkg7XgCgqiHI7u3NNMRnmQ32enDE3BwucVQgPKzUl8
         LO/w==
X-Gm-Message-State: AFqh2krGt0pm3UmkphiHbRSo1VU/mNx4g1TXnZBZ7djs+T2UmAam6hd3
        0nxEcieWk66IVHF3HuYHz2kh5Nr//KPH8xGEAqiLu56C0HyrdvCBlr2x5dOBnH8WDEiFHqaZSDI
        skwAIKO5Q1sq/7R+arC82L3iETGc2Oz7s
X-Received: by 2002:a17:906:3a5b:b0:870:baa6:676c with SMTP id a27-20020a1709063a5b00b00870baa6676cmr6119221ejf.132.1674871039889;
        Fri, 27 Jan 2023 17:57:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtanqSd7MgToKGma445A3qz4TJxSYPH1M8+rA1DH+9zaVF6lXc4fT4gfM9QDUQKrssiLkQG8gIzdAgJAoggFxU=
X-Received: by 2002:a17:906:3a5b:b0:870:baa6:676c with SMTP id
 a27-20020a1709063a5b00b00870baa6676cmr6119210ejf.132.1674871039681; Fri, 27
 Jan 2023 17:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
 <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
 <20230124110814.6096ecbe@xps-13> <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
 <20230125105653.44e9498f@xps-13> <CAK-6q+irhYroxV_P5ORtO9Ui9-Bs=SNS+vO5bZ7_X-geab+XrA@mail.gmail.com>
 <1322777.1674848380@dyas>
In-Reply-To: <1322777.1674848380@dyas>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 27 Jan 2023 20:57:08 -0500
Message-ID: <CAK-6q+ix3PybA-Af-QRRZ2BwSLYH76SnqhRCsmRpiy_6PFrorw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
To:     Michael Richardson <mcr@sandelman.ca>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
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

On Fri, Jan 27, 2023 at 2:52 PM Michael Richardson <mcr@sandelman.ca> wrote:
>
>
> Alexander Aring <aahringo@redhat.com> wrote:
>     >> - MLME ops without feedback constraints like beacons -> should go
>     >> through the hot path, but not through the whole net stack, so
>     >> ieee802154_subif_start_xmit()
>     >>
>
>     > it will bypass the qdisc handling (+ some other things which are around
>     > there). The current difference is what I see llsec handling and other
>     > things which might be around there? It depends if other "MLME-ops" need
>     > to be e.g. encrypted or not.
>
> I haven't followed the whole thread.
> So I am neither agreeing nor disagreeing, just clarifying.
> Useful beacons are "signed" (have integrity applied), but not encrypted.
>

I see. But that means they need to be going through llsec, just the
payload isn't encrypted and the MIC is appended to provide integrity.

> It's important for userspace to be able to receive them, even if we don't
> have a key that can verify them.  AFAIK, we have no specific interface to
> receive beacons.
>

This can be done over multiple ways. Either over a socket
communication or if they appear rarely we can put them into a netlink
event. In my opinion we already put that in a higher level API in
passive scan to interpret the receiving of a beacon on kernel level
and trigger netlink events.

I am not sure how HardMAC transceivers handle them on the transceiver
side only or if they ever provide them to the next layer or not?
For SoftMAC you can actually create a AF_PACKET raw socket, and you
should see everything which bypass hardware address filters and kernel
filters. Then an application can listen to them.

- Alex

