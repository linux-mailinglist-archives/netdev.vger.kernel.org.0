Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6E46773E5
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 02:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjAWByH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 20:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAWByH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 20:54:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD0C16B;
        Sun, 22 Jan 2023 17:54:06 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s3so12932383edd.4;
        Sun, 22 Jan 2023 17:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5z4Hd0Qs9SFsDBYXanxTnEoLsdmIZ6VAYEjeE+ksHI=;
        b=P5gYeWZzJ8Apxca/oufOTx2EM0Y6R+dRr06gyzXSYyx3MnrVBl1t2/Lw4IMiuifRN/
         YeneYV3iPCNnV49Fva/f21B5syoeuDJbm8JA27wI6a7miPEoR1gJwaRSLi3qIey5e2Df
         QgQIiTgEgzbJpqH3NIA9wSzLqTa5AtbIAUEksSp7I9tEbmKCRdN7baxc3d3ekZ4vXea4
         XWmi1cdz0S6VKn8t+o1d/xPTWC6GJgAae4jDzDQe9IYZV1MHcKn3Vu2id6swfjev4c4T
         YTapkFdOggFMS0wDPmVYpSjliz9CF2IP//VkZhR1CcVMTtFiAWeV4nWeucLicFRE2wfL
         E7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5z4Hd0Qs9SFsDBYXanxTnEoLsdmIZ6VAYEjeE+ksHI=;
        b=UIbMrS1YSkwHtkhUbzQi02gfH0Dq91iojpwlAB00MFpVYbpZalJEYOR5Cv3SwqTp6q
         lIWSwJaUF1GJN6IeThlctC1MKCue6HxBL9ickYhGVNkTzjI0STiHFe4eCyghmKE8syow
         2k+CaFjZmFlfa3UdtpAyZ/OKBQmbC9/bmWGek39iOrsrknoxsISrhIg35X9v8tNf9i4s
         A3kHgk5RoKT6zYfert0fmYUX2H6MaqV+WTxrjMcc9k1pIvu9R2l9RQHFqPaRfFZQFpKA
         Jsq2pX/V2Hcr6oZHeErfcqa9XA6FHmXD4Y5HeITt6ruhgPxbRdYXPo8kEH5upzkpC0JR
         3wGA==
X-Gm-Message-State: AFqh2koS8iR251Ub/iRP7ckF81b9gXG08AM9AEMuzg1xpgp9k+ppUgJY
        FAl6rj+GtuAvVnEXm1ttmf2cdcLQwxYIcxsyLsA=
X-Google-Smtp-Source: AMrXdXskOC8lBwF/BL0baqLazqE0xc0riXJdq8ydWpJRRmiXrhRFTGNGSbpZ+7vKrvzzNMoiSpYu0Wnukjswy3VTYmc=
X-Received: by 2002:a05:6402:28a4:b0:485:2bdf:ca28 with SMTP id
 eg36-20020a05640228a400b004852bdfca28mr3299131edb.251.1674438844563; Sun, 22
 Jan 2023 17:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20230121085521.9566-1-kerneljasonxing@gmail.com> <1bb796f9-b2dd-1c96-831a-34585770d80d@molgen.mpg.de>
In-Reply-To: <1bb796f9-b2dd-1c96-831a-34585770d80d@molgen.mpg.de>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 23 Jan 2023 09:53:28 +0800
Message-ID: <CAL+tcoDyeG8oLspkrdjwJX3=ZmcDD7JY63s=F3cmzaEsXNOveA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe: allow to increase MTU to
 some extent with XDP enalbed
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Mon, Jan 23, 2023 at 4:21 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Jason,
>
>
> Thank you for your patch.

Hello Paul,

Thanks for the review.

>
> Am 21.01.23 um 09:55 schrieb Jason Xing:
> > From: Jason Xing <kernelxing@tencent.com>
>
> There is a small typo in the summary: ena*bl*ed
>

Sure it is. That's my fault.

> > I encountered one case where I cannot increase the MTU size with XDP
> > enabled if the server is equipped with IXGBE card, which happened on
> > thousands of servers. I noticed it was prohibited from 2017[1] and
>
> That=E2=80=99s included since Linux 4.19-rc1.
>
> > added size checks[2] if allowed soon after the previous patch.
> >
> > Interesting part goes like this:
> > 1) Changing MTU directly from 1500 (default value) to 2000 doesn't
> > work because the driver finds out that 'new_frame_size >
> > ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
> > 2) However, if we change MTU to 1501 then change from 1501 to 2000, it
> > does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
> > is converted to 1501, which later size check policy allows.
> >
> > The default MTU value for most servers is 1500 which cannot be adjusted
> > directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
> > 1536) if it loads XDP.
> >
> > After I do a quick study on the manner of i40E driver allowing two kind=
s
> > of buffer size (one is 2048 while another is 3072) to support XDP mode =
in
> > i40e_max_xdp_frame_size(), I believe the default MTU size is possibly n=
ot
> > satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
> > insert a new header, say, vxlan header. So setting the 3K-buffer flag
> > could solve the issue.
>
> What card did you test with exactly?
>

It is the IXGBE driver that has such an issue.  The I40E driver I
mentioned here is only for contrast. It's not that proper from my
point of view if the IXGBE driver cannot directly adjust to 2000. Thus
I would like more reviews and suggestions.

Thanks,
Jason

> > [1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XD=
P")
> > [2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations wit=
h
> > XDP")
>
> I=E2=80=99d say to not break the line in references.
>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/ne=
t/ethernet/intel/ixgbe/ixgbe_main.c
> > index ab8370c413f3..dc016582f91e 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_=
adapter *adapter)
> >               if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
> >                   (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
> >                       set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> > +
> > +             if (ixgbe_enabled_xdp_adapter(adapter))
> > +                     set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> >   #endif
> >       }
> >   }
>
>
> Kind regards,
>
> Paul
