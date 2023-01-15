Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE78E66B0E5
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 13:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjAOMPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 07:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjAOMP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 07:15:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B4CEC68
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 04:15:28 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v6so37209296edd.6
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 04:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KG9F0um/JqIeSlLadyZkkcLkb5X/SIuXCsDe+eU09ro=;
        b=NjMBWAAYY61YLity6j928ZGxHwSx62ZwhrK9AxWY+o42r3detIwApwwlt+yplWPHLD
         XHXdF/IwsYkmibHGWD4XQQJs3Geujx4sPvKNfFmLCavPVB2FegaZRNazGOVLGqYI4h3R
         IFoga7ryBnzVwNU67+zcYdW9DweCxoqG3rPZgkBiYFFG08TrbWuDqbkHLeOALrYaFgGk
         jt415RXQrht6SrllfkxFuoTg2HnaDb4dg/QHNH9CWjJSSA3rl6UympJPXJ2VG7p7JIwE
         b/eO1cfUS+crAz45MjJvJzdtE92bXhHyPyhm3/TwoI5PNaRZ22V9CMqtshD2Q/XATyl+
         uc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KG9F0um/JqIeSlLadyZkkcLkb5X/SIuXCsDe+eU09ro=;
        b=ecrKca4L95DGNs65Hdm7bkC5+0pNrVKYfuAXXS/a9c0kELuNhSBIhzv2WG5sdrgV1Z
         BpOm8UKJIy4eivD+PDWYIixLPVUGqAseki4hjcJB+CCUKhRd1fR97gjub373pCXeKtpJ
         SZmdjF8pek4dy1I/BIvQNSmRbtJabm+LnskvpqabziCl1UzDpR5IEEcn0rd9A0BcVl1v
         20Mh2JoH+mkKMDj/g1bo8kzX+gKA9YT7cS3sByCaOmYjf/xHiRmxos1aSqOtmpdTVODy
         2nS0iIljlxyRTw9HNdVKIuyVsGzoVkG/fGuvxj/Bh6HtJs08dpE38RSR9QtZTzGHdZVO
         ItEg==
X-Gm-Message-State: AFqh2koblDQOXguW17fMEf7AFf3GPvJnzimasQEnyWa4i7/zXXf2F7Os
        PUjcrTxoiykohYC2sR28wkOcq8jA0LH98WQ4rgE=
X-Google-Smtp-Source: AMrXdXsi0EUjhLflhpgp0B8QKdpKf2HCNjaFgcr+hEEYgb7OEpchh6dXjWB0crSZ9OjZWT20/E1+RY3SiUbrVVmpOuo=
X-Received: by 2002:aa7:cad6:0:b0:490:df3b:d889 with SMTP id
 l22-20020aa7cad6000000b00490df3bd889mr4656959edt.205.1673784927200; Sun, 15
 Jan 2023 04:15:27 -0800 (PST)
MIME-Version: 1.0
References: <20230111130520.483222-1-dnlplm@gmail.com> <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
 <CAGRyCJGFhNfbHs=qhdOg9DYOq_tLOska2r2B08WTBbnFyXXjhw@mail.gmail.com>
 <CAKgT0Ueb7AA3NrwxFX7VjS_h1j-kOdXUGYchTjwCh9ah1kpbZA@mail.gmail.com> <20230113114800.357a96e2@kernel.org>
In-Reply-To: <20230113114800.357a96e2@kernel.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Sun, 15 Jan 2023 13:15:16 +0100
Message-ID: <CAGRyCJFDYGocQiaKrnPSvJk5rJkhEebf2HT=M+DsYWxEnWYo1w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool and rmnet
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub and Alexander,

Il giorno ven 13 gen 2023 alle ore 20:48 Jakub Kicinski
<kuba@kernel.org> ha scritto:
>
> On Fri, 13 Jan 2023 08:16:48 -0800 Alexander Duyck wrote:
> > > ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES works also as a way to determine
> > > that tx aggregation has been enabled by the userspace tool managing
> > > the qmi requests, otherwise no aggregation should be performed.
> >
> > Is there a specific reason why you wouldn't want to take advantage of
> > aggregation that is already provided by the stack in the form of
> > things such as GSO and the qdisc layer? I know most of the high speed
> > NICs are always making use of xmit_more since things like GSO can take
> > advantage of it to increase the throughput. Enabling BQL is a way of
> > taking that one step further and enabling the non-GSO cases.
>
> The patches had been applied last night by DaveM but FWIW I think
> Alex's idea is quite interesting. Even without BQL I believe you'd
> get xmit_more set within a single GSO super-frame. TCP sends data
> in chunks of 64kB, and you're only aggregating 32kB. If we could
> get the same effect without any added latency and user configuration
> that'd be great.

Thanks for the hints, I'll explore xmit_more usage and try to gather
some numbers to compare the two solutions.

Regards,
Daniele
