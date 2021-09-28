Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B451E41A60F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhI1D3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbhI1D3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 23:29:45 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2D1C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 20:28:07 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id m70so28718622ybm.5
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 20:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RiLP08FsZBUk+hWO/2M+gq118BWhjglrDtGcyjcLYZg=;
        b=NmGk5Lw5EOaYWFM7N7E3gGogGPSxpA3ggQ/sgi6HrDoQve8fssajfEU1wpDmEcOJJk
         d+Cc7OfX/V95KcldC+nX74z7+HOEIGOBYotn9F6sSvkvUt87E0+HdEko/+vYKuugEFFL
         SyGmBKSRiP3M1+55ZqA8g/YfQf4DxvNamXlz0zzDU5vOHtn2clRpBmYxb3I774m7oTiG
         lG4nijiuXcI3BLEocBxJImeV5z86+EuOxS++FgeODMplgAiXnoZtln/IW5th21CqvS2p
         ch9koVK27O8EOGIVn/fs5Our4ZpB5XLtSBnzJ4ZO7uKiacm4Fge2pSZ0KWtAuLJk1SDk
         iOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RiLP08FsZBUk+hWO/2M+gq118BWhjglrDtGcyjcLYZg=;
        b=7iVrnRDPzSpGADsaGaTMcG9s4XhVly/CXEYJvoB5nBQxtLlRrVPBHL05hwAN8bx68W
         J/xPZjfR7toueV2hhbhqiVhEY8VAaAhCmrz3Ce5OVhE3HLpxbRpywdHc7s04x5s48bv8
         WeRYqrMjlhByqbV0GDcHhi8KI+LOi/CqsGcgomCRvd5BnuIuDW9AEFicSjAbTRf/Mzdh
         4M9lCRs5fMQTAXBib37o39b3Y552W0YEOj27AhW6mIAOPIi/LmafYECP+EGuXWWoztwx
         FI7mkwTer1trr06+j4XGboPHRd8mw68FxccaiCzg+hKb0xTo1uwwPD7ZURiNBoJP6o93
         GgtA==
X-Gm-Message-State: AOAM531Qrm6iq2ytmWf1ObQcuJRtK7qgBbmdoPoZV2o+RgMHLfZTSt8R
        kolbqb/PGmhmvtUPDrXA0rtosOPHvpyWcl48XHQ=
X-Google-Smtp-Source: ABdhPJwSPhW9ae7dgYmz4ku03bVZmlDul9/+i/Io4gAHOAW5aIH0uUpjt/qoDPEREFo+Dl5V/XtZb6ZT4iCZ/bZsp1o=
X-Received: by 2002:a25:3b04:: with SMTP id i4mr4162689yba.524.1632799686518;
 Mon, 27 Sep 2021 20:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210928031938.17902-1-xiyou.wangcong@gmail.com> <CAHmME9rbfBHUnoifdQV6pOp8MHwowEp7ooOhV-JSJmanRzksLA@mail.gmail.com>
In-Reply-To: <CAHmME9rbfBHUnoifdQV6pOp8MHwowEp7ooOhV-JSJmanRzksLA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Sep 2021 20:27:55 -0700
Message-ID: <CAM_iQpV-JKrk8vaHDeD0pXaheN0APUxH5Lp+mGCM=_yZQ1hd4w@mail.gmail.com>
Subject: Re: [Patch net] wireguard: preserve skb->mark on ingress side
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 8:22 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Cong,
>
> I'm not so sure this makes sense, as the inner packet is in fact
> totally different. If you want to distinguish the ingress interface,

The contents are definitely different, but skb itself is the same.

Please also take a look at other tunnels, they all preserve this
in similar ways, that is, comparing net namespaces. Any reason
why wireguard is so different from other tunnels?

> can't you just use `iptables -i wg0` or `ip rule add ... iif wg0`?
>

My bad, I forgot to mention we run eBPF on egress side, where
skb->dev is already set to egress device (a non-wireguard device),
and of course skb_iif has been cleared even earlier.

Thanks.
