Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBC96BEED1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCQQt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCQQt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:49:27 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56CE30CA;
        Fri, 17 Mar 2023 09:49:25 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id ja10so5914659plb.5;
        Fri, 17 Mar 2023 09:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679071765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KSEHp7+Ju3eyWnvUtXisTLMA/KDrhMQGp4FmsdKi0s=;
        b=dlvUbhJ1Dp5FS9jxVjbUSV3BfqVHtBKOhSKOeX80o3GhAjRxiCr+m5KqYOFnmzlE7x
         QNVu7lXVTJau5lZcvj1zq8wHLs5h3kEAM5kCMrrYAzXkeOHg2Doe+4DSMX/ef3Nszegt
         JhYWogf1B25wIjctofwrXg2PM1sGFUZBHht/uJ3va8qdINalEQrs/re7D1VoT2pSUZXq
         2WcSXg6Fy2D0Jx99H0GvDbVAN1sI68HmKqGb6+hZX5Ex8RcUE+VK6V6wMcfPbXGIcVU3
         lLuA+YWIttKzfHQiAoQZALdZKOmhlGVJG6hYvoyTphyFnsTdf8gB0sSVuC2ttS/DPVt6
         MGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9KSEHp7+Ju3eyWnvUtXisTLMA/KDrhMQGp4FmsdKi0s=;
        b=Uxs3tbI+zh79KENIdMYf5ZBdSBeZ8liAYiEByke8dheJmNX+ft2lN/G7Z0vmYbnsjZ
         Tx4wwGmH8Y21EYElUucg55UrAXEK+SgyBnuiEXPLl5fmiW+BcxbyPwe4Q2SHV5VUALVM
         97krVgach6sLTjOXCW5Fbj/t9HaEiTc5axFG3caw+ir3/8duekdIpTyrfHH0eNokXNjO
         75BoH9aV8XPjPyQaZglo6E0Vh5O00OO1rWMnYJkEfcvjB4NfjjEoBnNRFavuIDbQOZEX
         ZXeALLyRSnD2Vbvh6P0/39bVwZxw6Bd+24rYF+PgMBqf0c6UmkktLX+j3bOP54t7XEEm
         0bPw==
X-Gm-Message-State: AO0yUKX352q/2DqfxE6uEEQV16r6pjgBnmsmcYqQuHOjf37XRFfDAk6d
        XJxWaPCQ7LrK3EU1ZMRK3ZMvGDNZsnW4Higg57Y=
X-Google-Smtp-Source: AK7set+vTeJAJTM8fZ1dB35AFODYpfjB0wtfba02DSdpcnVOzgHttT/XNUC90oWEQtQDhorBMW59+S2xaF1Mo+/vj6E=
X-Received: by 2002:a17:90b:1952:b0:237:1fe0:b151 with SMTP id
 nk18-20020a17090b195200b002371fe0b151mr2380274pjb.8.1679071765292; Fri, 17
 Mar 2023 09:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230317120815.321871-1-noltari@gmail.com> <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
In-Reply-To: <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Fri, 17 Mar 2023 17:49:14 +0100
Message-ID: <CAOiHx==TiSZKE4AP3PZ9Ah4zuAsrfpOTvRADWpT2kMS9UVRH9Q@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 at 17:32, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Mar 17, 2023 at 01:08:15PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > When BCM63xx internal switches are connected to switches with a 4-byte
> > Broadcom tag, it does not identify the packet as VLAN tagged, so it add=
s one
> > based on its PVID (which is likely 0).
> > Right now, the packet is received by the BCM63xx internal switch and th=
e 6-byte
> > tag is properly processed. The next step would to decode the correspond=
ing
> > 4-byte tag. However, the internal switch adds an invalid VLAN tag after=
 the
> > 6-byte tag and the 4-byte tag handling fails.
> > In order to fix this we need to remove the invalid VLAN tag after the 6=
-byte
> > tag before passing it to the 4-byte tag decoding.
>
> Is there an errata for this invalid VLAN tag? Or is the driver simply
> missing some configuration for it to produce a valid VLAN tag?
>
> The description does not convince me you are fixing the correct
> problem.

This isn't a bug per se, it's just the interaction of a packet going
through two tagging CPU ports.

My understanding of the behaviour is:

1. The external switch inserts a 4-byte Broadcom header before the
VLAN tag, and sends it to the internal switch.
2. The internal switch looks at the EtherType, finds it is not a VLAN
EtherType, so assumes it is untagged, and adds a VLAN tag based on the
configured PVID (which 0 in the default case).
3. The internal switch inserts a legacy 6-byte Broadcom header before
the VLAN tag when forwarding to its CPU port.

The internal switch does not know how to handle the (non-legacy)
Broadcom tag, so it does not know that there is a VLAN tag after it.

The internal switch enforces VLAN tags on its CPU port when it is in
VLAN enabled mode, regardless what the VLAN table's untag bit says.

The result is a bogus VID 0 and priority 0 tag between the two
Broadcom Headers. The VID would likely change based on the PVID of the
port of the external switch.

Jonas
