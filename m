Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E592E100F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgLVWRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgLVWRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:17:38 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBA7C0613D6;
        Tue, 22 Dec 2020 14:16:57 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id o6so13347371iob.10;
        Tue, 22 Dec 2020 14:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vcuCwqWsHQ0Jro60u5SF/gPTaAVB4GUgkYUHbcvSl/0=;
        b=IAVF8kPRyM2u8xrdPfII9YxGhOpLPRXwwaYaOMnBazAcx0tVHO+bF3eMEojveuULcR
         cad0e+XShOoDA1Aomwy+kXreMF9BBpIXWa6ZT3NPcBKChmnmU2yXR2CskLx5jkTiZgme
         gwZIns+gso20Fln6aRZXw6iMqncW7QM6vsMOrmsWv8FKic4NeyG4aDswwFnk9jPJ08ha
         H2GQaxp/K9OEWOduvZB7+mBOKz3T4rsNqSZ0Oda06UW+HTSfo+6Vt/mZY1IROgWHGOF9
         TKOrl2wAab2zP+GkTRGVce+La61TVT8d5lstnUHr/kaEA6uRKoCb+TRrOfoCIqlzwW+K
         JuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vcuCwqWsHQ0Jro60u5SF/gPTaAVB4GUgkYUHbcvSl/0=;
        b=eZGbg0Kld1+AdXNOhT5/sUhZ4ETsg/bOL4XaAoKekSS3gv+rQu40DsPJAQI8zLCg7g
         je7TRBAa/ThgHng4RBapVJyP+GdblV7gwwSBqzjBj8DWCSdTZ1e9D0l7043Yd0oxnujb
         EcwBpWBaALgI6n5iTKB3U8cz5wv98/ULkEbZeD47nwMgsFaiaDQwNHkJNpcNnowCCFN0
         2AUVJZNBUKa2P34NZwUQwrsjJWuz5QwIQ5avFLY5fxI9F43rzs9FuY3lbtENz4WPAlB6
         ODD8K9fEDHnsdGVxW2F6R+x2F2pKM0uhvkXc+Qd6gpx2vkhq0ZhOhtPQJlHs7mZtEloe
         adLQ==
X-Gm-Message-State: AOAM532WT//mWkY64aGJ/mBmZhGCR33IOEsBJRq8ZqlviWatNLRNSaif
        n8P11zeNIMKiayjJL9OblM4f0KdWTIKg/4VsleY=
X-Google-Smtp-Source: ABdhPJxSS8Ck1wKKpqAF+9lUA7Bj6TaXUPuyvnY+wgT+0U4WaUJmmAliC02tO6t3wSxSPcGsEksAKSFlTDD/QO4rKNc=
X-Received: by 2002:a02:7a50:: with SMTP id z16mr20532413jad.87.1608675417178;
 Tue, 22 Dec 2020 14:16:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608670965.git.lorenzo@kernel.org>
In-Reply-To: <cover.1608670965.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 22 Dec 2020 14:16:46 -0800
Message-ID: <CAKgT0Ud66UtBxQ6a-DKbswB6tNSGojhoSi81YEWHtO03qx97XQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        lorenzo.bianconi@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 1:09 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce xdp_init_buff and xdp_prepare_buff utility routines to initialize
> xdp_buff data structure and remove duplicated code in all XDP capable
> drivers.
>
> Changes since v4:
> - fix xdp_init_buff/xdp_prepare_buff (natural order is xdp_init_buff() first
>   and then xdp_prepare_buff())
>
> Changes since v3:
> - use __always_inline instead of inline for xdp_init_buff/xdp_prepare_buff
> - add 'const bool meta_valid' to xdp_prepare_buff signature to avoid
>   overwriting data_meta with xdp_set_data_meta_invalid()
> - introduce removed comment in bnxt driver
>
> Changes since v2:
> - precompute xdp->data as hard_start + headroom and save it in a local
>   variable to reuse it for xdp->data_end and xdp->data_meta in
>   xdp_prepare_buff()
>
> Changes since v1:
> - introduce xdp_prepare_buff utility routine
>
> Lorenzo Bianconi (2):
>   net: xdp: introduce xdp_init_buff utility routine
>   net: xdp: introduce xdp_prepare_buff utility routine
>
> Acked-by: Shay Agroskin <shayagr@amazon.com>
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
> Acked-by: Camelia Groza <camelia.groza@nxp.com>

The changes to the Intel drivers look fine to me, although it might be
nice to have someone from Intel provide a review/ack. I've added
intel-wired-lan to the thread so that someone from Intel can hopefully
review and also ack this.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
