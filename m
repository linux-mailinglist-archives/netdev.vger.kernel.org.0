Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39D2368BF0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhDWEVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWEVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:21:09 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1414C061574;
        Thu, 22 Apr 2021 21:20:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e14so15973742ils.12;
        Thu, 22 Apr 2021 21:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bfLVBnTZtbCXme7JICbwC7/NBVO0O2WQqtAPYxM3Q/I=;
        b=FgmcuGZ0syuiKLzYWl2tuYsRKGXhNCUX+7CwwZNf0P0+0SeVPUnX1ETJYReka0munu
         HGb15hd/AoairCHbvNG3ESn6iZzopAD5/5Au6grcEdN8TQqKlxg/GLaNzagsNd+PmnnE
         jzt/ljnomKZ02LXGrJvaJoZ1mltntuqhRX38vzvBC30cef9rFbWElUDEeNBZ1Xgz5OIc
         /SD7afADmlslfruHyI37qaaQ18225zzso5yNvoLBm06YX79qq+6KidIHRX59lhu4IFma
         uSBqATRoqZ3U+65kJspcIrZxiPBfEox7te0MzAhikMv0IfKXUTozvD/82ApZUEe4Byso
         o7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bfLVBnTZtbCXme7JICbwC7/NBVO0O2WQqtAPYxM3Q/I=;
        b=nDdqJfzfvLyeMxLV2aMQPv5kTVgG2RajDs3GEj8RzUrtmQWZ6bT3+DKCbB48cudj+D
         tVnIT2Sq2nxn1grKfRx8RhGDN4hV454yBuwdnnDdcXvIZlgFlJDCBwPKYPamz68Cqw7A
         14/V83ifVGR1yFlr43B0BKMvzlLznEsFiAHjWMipAX30hDqZkv2WW9kAlUa1Us+CfZXa
         Fi/j+lcOBPtdsljOxnevNyR+XfbuHPjfJT5XPZbCr2SdbqvfG4rR2doc/VxcziCVoJ1Z
         XcwYdzbod4G8sqRrq5L/pZe/pOmb4oWuvsXbWD6d/nEqMb3PgmcJGN2OVcHuq6fgCb30
         qcow==
X-Gm-Message-State: AOAM533eO+YYG5kpNbvW4S33F7g42ZyTP8KLC32swN0UlbUeAEv2UbYB
        2PZeUM955Lyj7O2Fo8y+dwOE5GOAc+0Zj/bnYGw=
X-Google-Smtp-Source: ABdhPJwgV4flQel9CUZ9T70WOiNqK8DPdVt/s0KlhhI3DsBu+w2Fia8e2pMJJA4xV/XzlTD1p/X6G3/CLSvRhF19uzw=
X-Received: by 2002:a05:6e02:cad:: with SMTP id 13mr1352525ilg.77.1619151632322;
 Thu, 22 Apr 2021 21:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
 <20210422040914.47788-13-ilya.lipnitskiy@gmail.com> <20210422092608.6b8ed5ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210422092608.6b8ed5ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Thu, 22 Apr 2021 21:20:21 -0700
Message-ID: <CALCv0x0vVzdtr=yezvHsq9TSx-nd76NiT2zYqQOuOa2W86VEqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 12/14] net: ethernet: mtk_eth_soc: reduce
 unnecessary interrupts
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 9:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 21 Apr 2021 21:09:12 -0700 Ilya Lipnitskiy wrote:
> > @@ -1551,8 +1551,9 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
> >               remain_budget -= rx_done;
> >               goto poll_again;
> >       }
> > -     napi_complete(napi);
> > -     mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
> > +
> > +     if (napi_complete(napi))
> > +             mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
>
> Why not napi_complete_done(napi, rx_done + budget - remain_budget)?
> (Modulo possible elimination of rx_done in this function.)
No reason, I think. Thanks for pointing it out. I will clean up both
TX and RX NAPI callbacks to use napi_complete_done and to get rid of
that ugly goto...

Ilya
