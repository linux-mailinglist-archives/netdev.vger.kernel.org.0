Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC467DCCF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 05:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjA0EQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 23:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjA0EQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 23:16:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1077B16336;
        Thu, 26 Jan 2023 20:16:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id k4so5016780eje.1;
        Thu, 26 Jan 2023 20:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pCPg4p/kNjS/XcZm5od+BEqI0eRA9tT6yJAnZLVLufo=;
        b=XXpkOMwOgo0LHzHR/loDFVHUu5rPtT+qqbPGwCH73uVWNDGczt3AMcYqY2IRWlXPnI
         dg5++kJa018KtzQdnQCDIEIqJwilrAFYDoev57v/iwQxqtGhE5AwQE4V5nzmikM/aEOU
         upnNhEuBKgvqzYUFVcDkkxUlf6DfH/3F/CFY5A17at704BCfGkVLR9vnH6jg7fNj7ZW1
         rMirPTM01DJ7cEkflA1z9BZ3fa3SejeFjhVmkrE3OH21lUS6aHcPz3ilT1czvh1f/x6H
         4faGHdWRljQfJi45c3ZMh964EC7IaFLfaXdVuvOIYFd0Du/LJtaeAtI/FBGimONmURs3
         sFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pCPg4p/kNjS/XcZm5od+BEqI0eRA9tT6yJAnZLVLufo=;
        b=Pql/AOd6Lh0o0ethfEHxSbiKIiTybDaDj54wWw59VY/TjN+DyBFiwso7gnPNOG/VC4
         b9VYJJlBYl1Sg/SVBzxqfh22eLjk8+hQtpghzK/MJFQ+5NOAFCpljYOKpKoMDYrkx9xk
         shh0nDx+i85lmCDRkjZalPgcKZddgDWRhmmTAvbX5r7ygDuduyz2PCzs6oNMYdiO/zZ4
         dVBznoTfIguC5J2ffQAIqg3eblqfcu3r61MfqSmIo/LaJsBhETsXZAm1YfWHBFaGiWdl
         tvoY5mljouLbB6Bd0paEYAKAOhC8ZhiE5zXmiwHVK68FyO7bZEaDYfJRRBl4qwhqbWAZ
         MkLA==
X-Gm-Message-State: AFqh2kq3QOTo/GIDHWoimoQRcG1KQ2U09QMvVk2GX/5uafwGtpfBlKvs
        D7AJDdKYf6Yosq/HP8ARpYct7Of9r6tVnw8byEqeb52B1lo=
X-Google-Smtp-Source: AMrXdXtS93XYT2PTeYAhswaSqtGBBNjGjzbSX2zXwaBaiv1xo/CoL2aXV/Thiix7NKQbiSLkQPk4A5chCCSzRBz7TP8=
X-Received: by 2002:a17:906:7d14:b0:86f:9fb1:30a8 with SMTP id
 u20-20020a1709067d1400b0086f9fb130a8mr5599478ejo.181.1674793002473; Thu, 26
 Jan 2023 20:16:42 -0800 (PST)
MIME-Version: 1.0
References: <20230121085521.9566-1-kerneljasonxing@gmail.com>
 <Y9JvUKBgBifiosOa@boxer> <48639eb0-27d9-5754-0687-286e909ceff0@intel.com>
In-Reply-To: <48639eb0-27d9-5754-0687-286e909ceff0@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 27 Jan 2023 12:16:06 +0800
Message-ID: <CAL+tcoD2wNOS-Tg+A94naTP2QtVmcoDLZTpapRiD4PVkW3H5eQ@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: allow to increase MTU to some extent with XDP enalbed
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
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

On Thu, Jan 26, 2023 at 11:56 PM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Thu, 26 Jan 2023 13:17:20 +0100
>
> > On Sat, Jan 21, 2023 at 04:55:21PM +0800, Jason Xing wrote:
> >> From: Jason Xing <kernelxing@tencent.com>
> >>
> >> I encountered one case where I cannot increase the MTU size with XDP
> >> enabled if the server is equipped with IXGBE card, which happened on
> >> thousands of servers. I noticed it was prohibited from 2017[1] and
> >> added size checks[2] if allowed soon after the previous patch.
> >>
> >> Interesting part goes like this:
> >> 1) Changing MTU directly from 1500 (default value) to 2000 doesn't
> >> work because the driver finds out that 'new_frame_size >
> >> ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
> >> 2) However, if we change MTU to 1501 then change from 1501 to 2000, it
> >> does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
> >> is converted to 1501, which later size check policy allows.
> >>
> >> The default MTU value for most servers is 1500 which cannot be adjusted
> >> directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
> >> 1536) if it loads XDP.
> >>
> >> After I do a quick study on the manner of i40E driver allowing two kinds
> >> of buffer size (one is 2048 while another is 3072) to support XDP mode in
> >> i40e_max_xdp_frame_size(), I believe the default MTU size is possibly not
> >> satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
> >> insert a new header, say, vxlan header. So setting the 3K-buffer flag
> >> could solve the issue.
> >>
> >> [1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XDP")
> >> [2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations with
> >> XDP")
> >>
> >> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> >> ---
> >>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> index ab8370c413f3..dc016582f91e 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> @@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
> >>              if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
> >>                  (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
> >>                      set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> >> +
> >> +            if (ixgbe_enabled_xdp_adapter(adapter))
> >> +                    set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> >
> > This will result with unnecessary overhead for 1500 MTU because you will
> > be working on order-1 pages. Instead I would focus on fixing
> > ixgbe_change_mtu() and stop relying on ixgbe_rx_bufsz() in there. You can
> > check what we do on ice/i40e sides.

Well, now I see the commit 23b44513c3e6f in 2019. Thanks, Maciej.

> >
> > I'm not looking actively into ixgbe internals but I don't think that there
> > is anything that stops us from using 3k buffers with XDP.
>
> I think it uses the same logics as the rest of drivers: splits a 4k page
> into two 2k buffers when MTU is <= 1536, otherwise uses order-1 pages
> and uses 3k buffers.
>
> OTOH ixgbe is not fully correct in terms how it calculates Rx headroom,
> but the main problem is how it calculates the maximum MTU available when
> XDP is on. Our usual MTU supported when XDP is on is 3046 bytes.
> For MTU <= 1536, 2k buffers are used even for XDP, so the fix is not
> correct. Maciej is right that i40e and ice do that way better and don't
> have such issue.

Thank you for the detailed explanation. And yes, I checked this part
in the ice/i40e driver which introduces ice/i40e_max_xdp_frame_size()
to test if we can change MTU size when the driver is loading the XDP
program.
I will rewrite the patch as the i40e/ice does in the next submission.

Thanks,
Jason

>
> >
> >>  #endif
> >>      }
> >>  }
> >> --
> >> 2.37.3
> >>
>
> Thanks,
> Olek
