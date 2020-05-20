Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED41DBB16
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgETRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:20:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B923C061A0E;
        Wed, 20 May 2020 10:20:28 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f13so3222888wmc.5;
        Wed, 20 May 2020 10:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CEEuZC5hZ/NpWe9c3PvjTU8NAaLoEEVby/Q8AvDU89g=;
        b=gmjTGRdN8NvVe03NT4wd+SkIQHVvGxrH5+8sCYSnKRJuWSMINbliQ6f1LCzYjUUMQD
         cuqXcWPHGBo8kol7s63JttvLEl2k7nb7EiHJAm9M3WE0ERQezyX2vdURS9NvTOa/xSq+
         9um7Hh30IU4PCXybyhU0Sy8ujciduNUJlU7YyNnzvY0uFTAi0t2H/NbjvB8ONCHWlFLx
         DrwqYhDVd0zSyQBIj1+WRVggybgRHtvBOitqwtcqJeI4GjckIfxLIkxBDG/vpA+z2zvS
         CjIjuauGYi+Fz5qVejWZUt5vt6V9sXtpgkpuFcO2aw3w40ISXsbZr7ZD8dnSUmxNrIan
         OlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CEEuZC5hZ/NpWe9c3PvjTU8NAaLoEEVby/Q8AvDU89g=;
        b=I3gybrVD6Me1FWLKLCv9f/J5ceSuZ01vNoavQB48EsINa9zgvyeANNwGMPMnVYzgvt
         UpRsSWplUoqwcXDUnxjDg+CpcSQnfk9dFZDQtCNSElWTC+zlFvr5WTpyUnSzecokuqBo
         0Vw5htyd0tMtwLLnf6kSYMT+PANmJHSXl4rYe1o9x1ybrEBwsErFm0MzFY0bXi1ZIxSw
         AnutwteFGbz+Cg+bJqREOXPF2svxTb3waJ5vbhDWUWojj8aKm/DoXbttK21YgYZaWxxP
         OXKaryS2a6UO4MioJFe9OepdgQjPvN6XrHkU6RW6vbfqhUUutl1qpB6Ycwc4jmAhBuyv
         evsA==
X-Gm-Message-State: AOAM530ypKKsMeChZv7LyAImpmuRhXljCNwnCJ5wCoDqeM3+xuc4VEOX
        OMJPnJnXD2oEIfDglPxgbB8MT3CDHE1X5hrujgI=
X-Google-Smtp-Source: ABdhPJwwZFlKCJNhGnNYLEI9v78F2nO1RxPtZs+6cyULKs3Qp2+VMcs/+0Jb7DyDGAiYkWa1EHE1Uigmw92eXD71z1s=
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr5876073wmm.155.1589995226910;
 Wed, 20 May 2020 10:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-10-bjorn.topel@gmail.com> <20200520100342.620a0979@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520100342.620a0979@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 20 May 2020 19:20:15 +0200
Message-ID: <CAJ+HfNjeF8fbHuVTg+hT7_-5obMJT_as39LahbM+M2AERmGSiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 09/15] ice, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 May 2020 11:47:36 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Remove MEM_TYPE_ZERO_COPY in favor of the new MEM_TYPE_XSK_BUFF_POOL
> > APIs.
> >
> > Cc: intel-wired-lan@lists.osuosl.org
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> patch 8 also has a warning I can't figure out.
>
> But here (patch 9) it's quite clear:
>
> drivers/net/ethernet/intel/ice/ice_xsk.c:414: warning: Excess function pa=
rameter 'alloc' description in 'ice_alloc_rx_bufs_zc'
> drivers/net/ethernet/intel/ice/ice_xsk.c:480: warning: Excess function pa=
rameter 'xdp' description in 'ice_construct_skb_zc'

Thanks! I'll clean that up.

Bj=C3=B6rn
