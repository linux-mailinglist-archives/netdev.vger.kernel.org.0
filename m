Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5019F5FC964
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJLQmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 12:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiJLQmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:42:46 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA63CBB055
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:42:44 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id k2so39245429ejr.2
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fi+05BteQs1tUO7T9SXE9tvOcc1NZmf2rVbl3jcKt2o=;
        b=h1RLdkT8H3kgPZoVrxw0aSAVCeVxAivRTaPgJ+omZ1Y5Jym4UXoM2cEXD5OihdOmyK
         zo/ljvCn9Hn4NMT8i8dXH8mldly821hkJ+8jcYIu96tw77RcfXs0HcrPvrVXkWqjzbRU
         lYrJk9odsxAvuWJEvbMnCXJ48pJ2z4oMes+sYoEQilCjnc6FsoZEB5YNvRpo65axo5Ie
         NQBboIE/eMoNprybNlBmGRBzHSfvg2ttwvz3VPsu64nMzGiWVPzA0XN5KVSWNPBjAihK
         c7aj3vZOju35tijCejXNri6hEUX0Wiwp+NBkDWAsuXg5rECMrSzy629G/8iPVmzwaPoj
         enUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fi+05BteQs1tUO7T9SXE9tvOcc1NZmf2rVbl3jcKt2o=;
        b=PdnE+qZwHBTs6+QFE4O98Q+uCI0MyJUqdZeuoihmotEKgEcC9Lq4hvbtItgdWwKa6O
         duwZp11rTHRdjZBEDqpa+54giO+Th0hDQMSzZ+b+XU7ckwdX3G/usczfPD2n0loQraLr
         2pGDFnbFgE2suT3aXjQsKZVG/+bDp0n1Ai13WSfZ2Kt8Ah3Ywo/ztef1n9Fd26urVH5F
         ZyV4mXxgemXlD9YGGxx6FZkJ++YguzU24ZmWd/LMjQn8mmjHq1PokA+1OxNqX/cCZZF6
         axqXW+oimdsyaaDE1s8NUHtDmeo6UV51tEhZzOki+y3dggU39P4ATEbGRPROSu3YRlj2
         hzfA==
X-Gm-Message-State: ACrzQf03/lZf70RbIKKmri3KVixkD8kVzcd8m9Onzd3vnWXP8NlV7OU1
        dkG4oUu0WhujO6sOxpqiMFn8/IZY/p+dH/89JFI=
X-Google-Smtp-Source: AMsMyM6mp9JRxxGNdUEEmzA7DThTJyeg2hEIfyjPOhrZBLhJVyA1V3tEmeIzAGSLhjvhvRTTfS46Pc+ybWMDyTJG98A=
X-Received: by 2002:a17:907:8688:b0:782:6637:e8dc with SMTP id
 qa8-20020a170907868800b007826637e8dcmr24231345ejc.174.1665592963206; Wed, 12
 Oct 2022 09:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221012153737.128424-1-saproj@gmail.com> <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
In-Reply-To: <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 12 Oct 2022 19:42:31 +0300
Message-ID: <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than 1514
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_SBL_A autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 at 19:13, David Laight <David.Laight@aculab.com> wrote:
>
> From: Sergei Antonov
> > Sent: 12 October 2022 16:38
> >
> > Despite the datasheet [1] saying the controller should allow incoming
> > packets of length >=1518, it only allows packets of length <=1514.
>
> Shouldn't that be <=1518 and <1518 ??

Oh, thanks for noticing. But still it should be slightly different:
<= 1518 and <=1514
Here is my test results of different packet sizes:
packets of 1518 / 1517 / 1516 / 1515 bytes did not come to the driver
(before my patch)
packets of 1514 and less bytes did come

> Although traditionally it was 1514+crc.
> An extra 4 byte header is now allowed.
> There is also the usefulness of supporting full length frames
> with a PPPoE header.
>
> Whether it actually makes sense to round up the receive buffer
> size and associated max frame length to 1536 (cache line aligned)
> is another matter (probably 1534 for 4n+2 alignment).
>
> > Since 1518 is a standard Ethernet maximum frame size, and it can
> > easily be encountered (in SSH for example), fix this behavior:
> >
> > * Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
>
> What does that do?

If FTMAC100_MACCR_RX_FTL is not set:
  the driver does not receive the "long" packet at all. Looks like the
controller discards the packet without bothering the driver.
If FTMAC100_MACCR_RX_FTL is set:
  the driver receives the "long" packet marked by the
FTMAC100_RXDES0_FTL flag. And these packets were discarded by the
driver (before my patch).

> Looks like it might cause 'Frame Too Long' packets be returned.
> In which case should the code just have ignored it since
> longer frames would be discarded completely??

Is there such a thing as a response packet which is sent in return to
FTL packet? Did not know that. My testcases were SSH and SCP programs
on Ubuntu 22 and they simply hang trying to connect to the ftmac100
device - no retransmissions or retries with smaller frames happened.

> > * Check for packet size > 1518 in ftmac100_rx_packet_error().
> >
> > [1]
> > https://bitbucket.org/Kasreyn/mkrom-uc7112lx/src/master/documents/FIC8120_DS_v1.2.pdf
> >
> > Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")
> > Signed-off-by: Sergei Antonov <saproj@gmail.com>
> > ---
> >
> > v1 -> v2:
> > * Typos in description fixed.
> >
> >  drivers/net/ethernet/faraday/ftmac100.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
> > index d95d78230828..34d0284079ff 100644
> > --- a/drivers/net/ethernet/faraday/ftmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftmac100.c
> > @@ -154,6 +154,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
> >                                FTMAC100_MACCR_CRC_APD | \
> >                                FTMAC100_MACCR_FULLDUP | \
> >                                FTMAC100_MACCR_RX_RUNT | \
> > +                              FTMAC100_MACCR_RX_FTL  | \
> >                                FTMAC100_MACCR_RX_BROADPKT)
> >
> >  static int ftmac100_start_hw(struct ftmac100 *priv)
> > @@ -320,6 +321,7 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
> >  {
> >       struct net_device *netdev = priv->netdev;
> >       bool error = false;
> > +     const unsigned int length = ftmac100_rxdes_frame_length(rxdes);
>
> Do you need to read this value this early in the function?
> Looks like it is only used when overlong packets are reported.

I decided to make a variable in order to use it twice:
in the condition: "length > 1518"
in logging: "netdev_info(netdev, "rx frame too long (%u)\n", length);"
You are right saying it is not needed in most cases. Can we hope for
the optimizer to postpone the initialization of 'length' till it is
accessed?
