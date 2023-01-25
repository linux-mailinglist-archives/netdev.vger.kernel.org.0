Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC867AAF2
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbjAYHfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbjAYHfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:35:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057EA366B3;
        Tue, 24 Jan 2023 23:35:41 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qx13so45109626ejb.13;
        Tue, 24 Jan 2023 23:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nGlLQMRMs18KEtYyX/ac08EXCvqt8zu6xcJXDeQV2dY=;
        b=bWNJ/LJR+NUbijN/7bqMprkmjukf4ykfGNFFWppAlD3Cx/K5m1emzCRPf9to0gB8KT
         e4ZAfaCU5ytNjLogzpSG9Rvws5G8DUWw8pl0djAUr3ZMmDCSvU1uB+kVKIeBJznv7bgP
         S+yMx0c7B4CI585tCkNkIU0uUg6eU2oGNxs2JgqfuTxlfhbSF2/hFBFyKDX2xBl7Di3A
         GHjAs1hpGgSU1bbhAaLNAZRejq0MOCdHrK1YD3G3W5/LXSMH4d5QEE+sMNDfOWWaRuDZ
         YQjtsp1KIgZLIubEMuOTnX5REeqF1thciqndV5FF/NKJ526imNpA7D7AwlWqjfV/DlEb
         rbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGlLQMRMs18KEtYyX/ac08EXCvqt8zu6xcJXDeQV2dY=;
        b=BFgDztUCfa2FVEruxs6WbjmGmnEjBOxe4xmZ+U89dxxeMZN2Ftnu1+gltQ6GKJTB9c
         ulx7ccPOdqlvunT78mTGsKVzTfFqI2Gflc826X6JwD5rl7WTsSPRqNRmX0a4etrMIN4I
         vGrRA50cZIqOESiLsNGH8SC7iZM9ZHmU9KC0WOyboA42o4qjH+7wO6O28GemrGo4jqYC
         F764PstGZqBhL1XTlHSBKmSpSkUSaSatwZyIu00VRoPpgTTkIZylDXe8HVsX3zW4lqBb
         jfSQAgXMYIRkJ0p6c7xVb71BSAUQe9c+ZFjXBxkUDwHJKIn9grNZqF0EPZN2TXIJKrzV
         KScw==
X-Gm-Message-State: AFqh2kqmc8Xeh9eACIKq4zMJsTkjnx4YUQ5o0Kj/hawlhsyXDSzRQNbK
        V/dMRpgXGWWDwgNhLv8RLsU6I3VUhW9QkL6k7xc=
X-Google-Smtp-Source: AMrXdXt8i9aVPI6v11qB48IeNNXkHiq5ha7Oj7NPA6OVN6+Co5mVwtVBruuOJ2igGy1FFungvJuKuwF3qFgVtRskGBs=
X-Received: by 2002:a17:906:9f21:b0:872:f8b7:3b52 with SMTP id
 fy33-20020a1709069f2100b00872f8b73b52mr2819374ejc.373.1674632139408; Tue, 24
 Jan 2023 23:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20230121085521.9566-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230121085521.9566-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 25 Jan 2023 15:35:03 +0800
Message-ID: <CAL+tcoCcTHUXKiNW7jau4E5_H6HKXLN6-m8D9B2fBXSgRReS4A@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: allow to increase MTU to some extent with XDP enalbed
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
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

I'm sorry. I just noticed that I sent it to the wrong email address of
john.fastabend previously. So I corrected it here.

Thanks,
Jason

On Sat, Jan 21, 2023 at 4:55 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> I encountered one case where I cannot increase the MTU size with XDP
> enabled if the server is equipped with IXGBE card, which happened on
> thousands of servers. I noticed it was prohibited from 2017[1] and
> added size checks[2] if allowed soon after the previous patch.
>
> Interesting part goes like this:
> 1) Changing MTU directly from 1500 (default value) to 2000 doesn't
> work because the driver finds out that 'new_frame_size >
> ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
> 2) However, if we change MTU to 1501 then change from 1501 to 2000, it
> does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
> is converted to 1501, which later size check policy allows.
>
> The default MTU value for most servers is 1500 which cannot be adjusted
> directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
> 1536) if it loads XDP.
>
> After I do a quick study on the manner of i40E driver allowing two kinds
> of buffer size (one is 2048 while another is 3072) to support XDP mode in
> i40e_max_xdp_frame_size(), I believe the default MTU size is possibly not
> satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
> insert a new header, say, vxlan header. So setting the 3K-buffer flag
> could solve the issue.
>
> [1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XDP")
> [2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations with
> XDP")
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..dc016582f91e 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
>                 if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
>                     (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
>                         set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> +
> +               if (ixgbe_enabled_xdp_adapter(adapter))
> +                       set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
>  #endif
>         }
>  }
> --
> 2.37.3
>
