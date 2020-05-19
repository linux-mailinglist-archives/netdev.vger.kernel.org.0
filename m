Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9C1D9D79
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgESRGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgESRGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:06:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1BEC08C5C0;
        Tue, 19 May 2020 10:06:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f13so3806026wmc.5;
        Tue, 19 May 2020 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b0b+DAWsimTwHxmy06gC1qGATqHB41HGKjKMHuwB2uU=;
        b=MfGRtbZZN/6k9+wrlP2zSdODee8Kn2QMUL/8Ac6tS6yHb3r8m6+MdCT9zPTPzeU1bh
         iBaeIRXuJeWmrcRrYr2Ncl75OrlrAjpsKpnhD3i8CWAZhepgZGpfutsOGBg3lLIE0vGb
         6Sj+AbGtcN1W7daBksFLJO2r8GovEcfrwfPUdj+253ep5uVVDZ96wj7Hy92GkDH02Bu/
         c0F2eRV3e9oR49N/mS6eQAST8HlLpI9bycnb06i9dISfkaFo5b+2RZpgWr8p9O8vYUdW
         0fj21SkwZGgas8XZUAY0JS4YGRhjBUMVZhyT2YA73HmIIdtcJeA05E69kFQdG28feQ5J
         ShHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b0b+DAWsimTwHxmy06gC1qGATqHB41HGKjKMHuwB2uU=;
        b=NPVrbdqsz8RaWqqNDf9A6pHNEpJbKKdxBc38h2NFN51w55wIWYYj8PakDpmnauTEHK
         H7guAnMFAh2XZQR8qARxd23WPtfggunYhN+omWI/7pq78bNIAsP/IcXBm7hKZC0iO5Va
         MCuqHMqLiGB/MUzK+/bLAzJcy1CTJj5INgfmzxW3+iFMOusTBdKhMPOZFjf+koXN1UkM
         7LYeGVGUKZaym252IkZSMcXkrN01kkFTLsWkHHj83C6XGtEN0YXIBc0ImgMkam9WO8uE
         EuCWBOetCFhfVkR6Y2Ww1Tti0dESCiFlZXpDADIzwrxLT2G/9t3cqGG91eZroHD+0LPc
         adkg==
X-Gm-Message-State: AOAM532996DiujznV+rkj9JOkd4mhORO88hb63jy7P2r+d5sPE48zQGN
        mLNvDtiosiSoz+4nlCP2LHchanRoceniv72jaRw=
X-Google-Smtp-Source: ABdhPJxy2Vuubx4taPhjA38NN0S65kjz787Mc5Ytyn12i7oNvkxHFWadGOZ8hPI5SvYsnQIOwXmu+TeL1T73xs+taxk=
X-Received: by 2002:a1c:a557:: with SMTP id o84mr358436wme.165.1589907998184;
 Tue, 19 May 2020 10:06:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200519085724.294949-8-bjorn.topel@gmail.com>
 <202005192351.j1H08VpV%lkp@intel.com> <c81b36a0-11dd-4b7f-fad8-85f31dced58c@intel.com>
 <20200519095539.570323c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519095539.570323c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 19 May 2020 19:06:26 +0200
Message-ID: <CAJ+HfNiunSSR8yY3_wHdxW71kmxMXhsRg2TRv+OVvSg9UZCFWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/15] i40e: separate kernel allocated rx_bi
 rings from AF_XDP rings
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        kbuild-all@lists.01.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 at 18:55, Jakub Kicinski <kuba@kernel.org> wrote:
>
[...]
>
> While at it I also get this on patch 11 (gcc-10, W=3D1):
>
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function mlx5e_allo=
c_rq:
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:376:6: warning: variabl=
e num_xsk_frames set but not used [-Wunused-but-set-variable]
>    376 |  u32 num_xsk_frames =3D 0;
>        |      ^~~~~~~~~~~~~~

Ah, yes. Thanks!

I'll wait until tomorrow for more input, and then do a respin.


Bj=C3=B6rn
