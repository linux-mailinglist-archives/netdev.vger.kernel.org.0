Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A417968E5DA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBHCJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBHCJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:09:50 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E5367E8;
        Tue,  7 Feb 2023 18:09:46 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id a10so11541717edu.9;
        Tue, 07 Feb 2023 18:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SpgS7vzqoUvjQY9Jf7h1UeSDSMCNGIGVVJBydDqIcdo=;
        b=mO/tqcWEQCm9hB0QmsatDqD6dE1M+15ufD/mZhTiJZH9Sfgsz9M9tt9XbiIS6RVRzF
         Eqv1EeRwOBVZmHJkF/AqGEB4A+jT5wwyvyDRIz1Le/Fgm7+phnWppwfm1oU+ykO1UzRt
         wX8KvkRiZJiyvLnVC+kuy+wHo/kBvrZpqyVlKSFBdFDUNY42dT7w/GTIqgzkDWhXRTSG
         DbrVe3V80Or9F8lsTtQ1iohICvclSIwAvzAN6Q7wAomWPsc5Hs9OrlgPgUM5CKQRCvRA
         4btD88X89lbAbRROWCTWYxAOSpRQcu2NPoVNXUPVCa+Vz0AGT6hjQjxHde/PSbFOG36u
         Te1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SpgS7vzqoUvjQY9Jf7h1UeSDSMCNGIGVVJBydDqIcdo=;
        b=uFREO1bjvBEHYGhHxmaUtzFa8AMUcRBXig/mjL0b4DpE9qtD7DfvBgJbDkJi7Fp34O
         SLRIxxdppBy9lPNDRfJPI/VmAq4g73/X1/G1BKVZHcg/88kcKfRAz4RFWTOsGEyjfOyC
         8xZsN1tqc5TXHliuq0bi4ZHCQILT2bNpI5Nc+gNdIK99NyWzZV3MEl6K3FCYKamm7P2i
         i9wOJ14rBDFpR5WTsy2tGxZst64+f+/FB4sBTIYVGeBSnzRv5RDgv3IcR3u33W01PcBK
         +uTzeHx0RMPB8r45JJq3sABCtE0xLQ4dh/PtmBCOqWQIDArwTMhgAwt7qKTJkbj6BxzG
         KB2g==
X-Gm-Message-State: AO0yUKV6bcF2uXX/zTNilInIIZqXoE9dUHnRxkMQ2czIki1MgiAd3ta1
        CTM71aNObqJ/OkH0+8SdSoejM48VvzJEdMOo99k=
X-Google-Smtp-Source: AK7set9t8xvkYsqVc61Bps7bR6RXA1/dv8gBL704YBC5h/c6B/SI52m96vZJbR0FtaE4LydM3TgqvsV7yXxSPoB1t0Y=
X-Received: by 2002:a50:8e1a:0:b0:4aa:b408:7dc1 with SMTP id
 26-20020a508e1a000000b004aab4087dc1mr1471827edw.43.1675822185146; Tue, 07 Feb
 2023 18:09:45 -0800 (PST)
MIME-Version: 1.0
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
 <20230204133535.99921-2-kerneljasonxing@gmail.com> <8d2ec49e-9023-5180-54c4-c09db24d2225@intel.com>
In-Reply-To: <8d2ec49e-9023-5180-54c4-c09db24d2225@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 8 Feb 2023 10:09:09 +0800
Message-ID: <CAL+tcoBnwC7=Z-jNv69R2baQyDgYKsvS8SQtRqLePn6ac_+A6A@mail.gmail.com>
Subject: Re: [PATCH net v3 1/3] ixgbe: allow to increase MTU to 3K with XDP enabled
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Wed, Feb 8, 2023 at 3:03 AM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> On 2/4/2023 5:35 AM, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
>
> ...
>
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index ab8370c413f3..2c1b6eb60436 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
> >                       ixgbe_free_rx_resources(adapter->rx_ring[i]);
> >   }
> >
> > +/**
> > + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > + * @adapter - device handle, pointer to adapter
> > + */
>
> Please use ':' instead of '-' for kdoc
>
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:6785: warning: Function
> parameter or member 'adapter' not described in 'ixgbe_max_xdp_frame_size'
>
> i.e.
>
> @adapter: device handle, pointer to adapter

Thanks for correcting the format. Now I understand.

Thanks,
Jason

>
> > +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> > +{
> > +     if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> > +             return IXGBE_RXBUFFER_2K;
> > +     else
> > +             return IXGBE_RXBUFFER_3K;
> > +}
> > +
