Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4537D5FDD9D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJMPx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJMPx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:53:56 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCFC37F8F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:53:55 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b2so4869219eja.6
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X35oijgau3zqy5RlObCa9YgpeEDO6RKrlImQPBd/NL8=;
        b=qOj6rWRYElwJDsWlYKBPl6QkNJGHYvACG0VIuKKGQyN52s1BUjoSBgLGKQN1Fcm+Un
         AB3yX3GQonN8EenX3zK9t5QNCOnePhYLDM26IxWSPQhKyQGMR2f3HdHKtsIsnSv7j936
         ik/TWQBfAdHi1DgXacri/VXLl4Ao1JIj6fqxD5WJLxxqQe6dSbRxh1vVkiRJWQ+0C4BV
         H/7bH5r2fiLxX6M3mqXV1aUbC9RIu0lHQFh4ynPksQvKEUILnpQKvwbwVeII+aXbqDPO
         b/ZU6FEP+ghTjn44zS8ZxOvMRlz0v5c3DgNTrTCM+0enfsWbj2tQskakq0gCv0/n4syU
         kHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X35oijgau3zqy5RlObCa9YgpeEDO6RKrlImQPBd/NL8=;
        b=FBZOYAhbZPNFauiEJL3XBVbwK54TcWqjIsWyLi8dd9kdapzkWh4GNjmDSlhQ3ttsRq
         g3H1lu4owlT+AwO/yCCEeSbIzsx/peD4y/sc0tlF+1PjvD4Zd+WBbqPAo3pxDlLeXhQb
         DN5AbbCShSEeO5KEYbQg9f6k83Z+44+7+dDfN/k5ZBdnLMbeJu4cc5a7PRxYxPwtq1mx
         E7F7s08Bm6BOVwVr+fp0pTuLRCX+ilMCipXDIS61Cn7l5EzqjxstT79DJx4S9l4WhRrH
         BfKz7csT9lxHi+fcgSIOZSftvzQp5ij39dFzAG0OfuaxBmpMVLrltf/9e5GrGV2VMz+d
         99Yg==
X-Gm-Message-State: ACrzQf2V2q7bkBvtyU2bJCDSlAPkXJyjBNcRGkyPMoXllP+xmH5FmUe8
        mXJUGIREe13jG40acaTDWD2pFYzbeC6Zl6E5vR8=
X-Google-Smtp-Source: AMsMyM68QdzFdZIXVC8cOdlJbaDtJ9Kid469IuAtRwmA57UejB8+MV8PrvCycYKfPlzPJtfqvqHfLowrHuvrVTxDz/8=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr325032ejb.44.1665676433841; Thu, 13 Oct
 2022 08:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221012153737.128424-1-saproj@gmail.com> <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
 <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com> <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
 <Y0gcblXFum4GsSve@lunn.ch>
In-Reply-To: <Y0gcblXFum4GsSve@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Thu, 13 Oct 2022 18:53:42 +0300
Message-ID: <CABikg9yVfO_97qXgbS3xn-2mkonrREvHBs0_ocbDnshi+B7LBA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than 1514
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 at 17:10, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Without an 802.1Q tag (probably a VLAN tag?) the max frame has
> > > 1514 data bytes (inc mac addresses, but excl crc).
> > > Unless you are using VLANs that should be the frame limit.
> > > The IP+TCP is limited to the 1500 byte payload.
> >
> > Exactly! Incoming packets first go through a switch chip (Marvell
> > 88E6060), so packets should get tagged.
> >
> > > So if the sender is generating longer packets it is buggy!
> >
> > Looking into it.
> >
> > On the sender computer:
> > sudo ifconfig eno1 mtu 1500 up
> > ssh receiver_computer
> >
> > On the receiver computer:
> > in ftmac100_rx_packet_error() I call
> > ftmac100_rxdes_frame_length(rxdes) and it returns 1518. I suppose, it
> > is 1500 + 18(ethernet overhead) + 4(switch tag) - 4(crc).
> >
> > Would you like me to dump the entire packet and verify?
>
> You did not mention DSA before. That is an important fact.
>
> What should happen is that the DSA framework should take the DSA frame
> header into account. It should be calling into the MAC driver and
> asking it to change its MTU to allow for the additional 4 bytes of the
> switch tag.
>
> But there is some history here. For a long time, it was just assumed
> the MAC driver would accept any length of packet, i.e. the MRU,
> Maximum Receive Unit, was big enough for DSA to just work. A Marvell
> switch is normally combined with a Marvell MAC, and this was
> true. This worked for a long time, until it did not work for some
> combination of switch and MAC. It then became necessary to change the
> MTU on the master interface, so it would actually receive the bigger
> frames. But we had the backwards compatibility problem, that some MAC
> drivers which work with DSA because there MRU is sufficient, don't
> support changing the MTU. So we could not make it fatal if the change
> of the MTU failed.
>
> Does this driver support the MTU change op? If not, you should try
> implementing it.

Well, the ftmac100 driver does not implement _change_mtu() function,
but netdev->mtu is correctly set to 1504 because of DSA. So I am
submitting a v3 version of the patch using netdev->mtuft. Please, have
a look at it.
