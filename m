Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B425FDCA1
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJMOtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJMOtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:49:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AFFF0368
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:48:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id q9so4564540ejd.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQGXKgyaCRLgUYsoS9TYEUpR0tiCy3Upp04Xdr9vnUs=;
        b=Uv9RPSL35S1FIQX9hVM2S+K531Iw/OgD3w+TW6GF9DrlDxyx7Bjb2p2zB8D1/vKfMk
         E7nCGbq/IROSVFbNa+EbVLXInhBU5Hd9pqvSIy0PhaDFZ02K8OQEMVuQ0IMbDJPxxtF9
         ZBkPDgOhbRGXcCfzw0PxOmESZIz6W/OMILjzGnzT2ocNTmyCFXNwatQuUrTGgivofNIS
         ghmMHjFPUhjelIxeD3jDrXyRtDVmoid7egg0zrwzMWv46toP16mX7AgoLfxdZdqr73fY
         vIivpqP5lC4NkfHJOa62ywI4+wJCDxDJn5WFJeRSPtUhkA3EcFrj7GY84z3WjHfxkZuO
         SInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQGXKgyaCRLgUYsoS9TYEUpR0tiCy3Upp04Xdr9vnUs=;
        b=DSH0LVQRVihJ8uFxm70S0EZFR1hVknrT6NgaOmZX+v54VyQb+jLh2sloBkSLnwhe+y
         lpClmAARjajJU0wAKPKSkfq5enRfbYUqJxEnHHln2iD6r3yd3I7XNYg6TJJQg6HnVgkS
         Lpa4rce6TvmDld0LmBLIhSrow0nVaxkT7Y1CtImJc74S/0RO28vejBSduS2XjoN5ms2e
         Y8KSr4XVFbwLVgEcSf333CZa8d6clHRDrkFGecP5IRxEj1qralYK0XRJnYjysMvzUQRH
         j7nABcdsMcGZKGJ3xgzT1lRA+QapsKLnNqTxrQxi3xI367vlNlI29lBgIeGzO6zn0CZL
         cUfw==
X-Gm-Message-State: ACrzQf1Tx3PKkdezjqVwSBYC1nSGiEh4zVv+gnhy5IPSRCPDB4ypBqJR
        zhpYkWxkrcEZwcyDuc6OcJg=
X-Google-Smtp-Source: AMsMyM4n8C7oL5Pw52QT1SkGoPEXbSCaTd7TYAbbl683mKL2R6qz46/JuW9v5+oyzu/5iwdUbd9g9A==
X-Received: by 2002:a17:907:7d8d:b0:78d:d467:dd3 with SMTP id oz13-20020a1709077d8d00b0078dd4670dd3mr72831ejc.547.1665672537194;
        Thu, 13 Oct 2022 07:48:57 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id du1-20020a17090772c100b0078df3b4464fsm2966998ejc.19.2022.10.13.07.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 07:48:56 -0700 (PDT)
Date:   Thu, 13 Oct 2022 17:48:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than
 1514
Message-ID: <20221013144853.k6jetben5vidyqkj@skbuf>
References: <20221012153737.128424-1-saproj@gmail.com>
 <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
 <f05f9dd9b39f42d18df0018c3596d866@AcuMS.aculab.com>
 <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wnvHCLGXCXc-tpyrMaetHt_DDiYCrprciQ-z+9-7fz+w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 01:29:00PM +0300, Sergei Antonov wrote:
> On Thu, 13 Oct 2022 at 00:41, David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Sergei Antonov
> > > Sent: 12 October 2022 17:43
> > >
> > > On Wed, 12 Oct 2022 at 19:13, David Laight <David.Laight@aculab.com> wrote:
> > > >
> > > > From: Sergei Antonov
> > > > > Sent: 12 October 2022 16:38
> > > > >
> > > > > Despite the datasheet [1] saying the controller should allow incoming
> > > > > packets of length >=1518, it only allows packets of length <=1514.
> > > >
> > > > Shouldn't that be <=1518 and <1518 ??
> > >
> > > Oh, thanks for noticing. But still it should be slightly different:
> > > <= 1518 and <=1514
> > > Here is my test results of different packet sizes:
> > > packets of 1518 / 1517 / 1516 / 1515 bytes did not come to the driver
> > > (before my patch)
> > > packets of 1514 and less bytes did come
> >
> > I had to double check the frames sizes, not written an ethernet driver
> > for nearly 30 years! There is a nice description that is 90% accurate
> > at https://en.wikipedia.org/wiki/Ethernet_frame
> >
> > Without an 802.1Q tag (probably a VLAN tag?) the max frame has
> > 1514 data bytes (inc mac addresses, but excl crc).
> > Unless you are using VLANs that should be the frame limit.
> > The IP+TCP is limited to the 1500 byte payload.
> 
> Exactly! Incoming packets first go through a switch chip (Marvell
> 88E6060), so packets should get tagged.

Well, this is the first time you mention of any switch DSA tag.

To my knowledge, what Linux understands by MTU is the maximum size of
the payload (SDU) accepted by the 802.3 MAC or 802.1Q layer. So a MTU of
1500 should allow a frame size, with Ethernet header and FCS, of 1518
octets, or optionally 1522 octets in case it is also VLAN-tagged.

A DSA header, or trailer, is part of the L2 payload, so DSA automatically
tries to increase the MTU on the DSA master to make sure that MTU-sized
frames going through the switch interface don't exceed the MTU of the
master when an extra tag gets inserted.

The only bug in the ftmac100 driver is that it reports netdev->max_mtu
of MAX_PKT_SIZE (1518) instead of 1500. It does *not* support this MTU,
it only supports 1500.

Had it properly reported 1500 as max MTU, you'd have seen that DSA tries
to call dev_set_mtu() on the ftmac100, to account for its tag length.
The driver does not implement ndo_change_mtu, only blindly says that
everything up to 1518 L2 payload length is accepted, and DSA thinks
everything is ok (1500 + 4 = 1504, still less than 1518).
