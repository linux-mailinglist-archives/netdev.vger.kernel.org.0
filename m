Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9318F247DA1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 06:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHRElU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 00:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHRElU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 00:41:20 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF46C061389;
        Mon, 17 Aug 2020 21:41:19 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id o2so8942622qvk.6;
        Mon, 17 Aug 2020 21:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gf51pqCh9hmyZ8rnan6e9c6VTVODdBAKE8gohS5mRuI=;
        b=lctg0OUx1nHGl0+MBZcnIRFxHXJ91IBQK07BObcp1w622xtRNCSH/XiRtIjrM2NqI3
         6jlLjDhlKJ/qkWebkxaS7EKlQv6ENHLEjKK6fr1Bg3ZhectDyjp50pR/w02jzXvjOI7X
         L6a9IzaoRc/k86j70arkeFNsOQAFK+ffjoGAnHzfUao9w+20GlEstjpaJeRiH2iQtO5a
         LaZb8p6S/uH1NI6wTcyMcHDjS1dgJRJ8gwGiw+VQM/jgY+ypbvhysIWEhfvSgMhkPsZs
         NmfQhRQcWOkFlRa3vk3cUfjGPNbgo7j6HHKwZ0XWQbk9c30DJn4SWt9UVdz4Y4107Bmg
         cFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gf51pqCh9hmyZ8rnan6e9c6VTVODdBAKE8gohS5mRuI=;
        b=PDq9dep9bVMdXIGoEZ7DPdEzfzzZVK4Vo2e3xXcKOML6WTmAeWVPcfSW03+ZwqwdV7
         xaa/TEGNQDWIKmAzmE6nx8gvt+5t0aCgrMBx9mxw3LB3ajkFM06siq8ausryQRkPiL2k
         AtdecK4z0RYJqa+b0otBRqdymBK4Xj0yK/lyHAM7IfHagssecXM9WR7yXfNR01SYdNCJ
         plg9epYRFR6Vc0IczzaKxxKfsX28tyMdGXL0yJh5FYByRqW+Sv4FL1lWrIJknIUo6cLx
         /8MGz5c2FyrXqr7crgxsHN9uRp6ukCCtlHKPRjX7RxWxQrL1UfGObJgqAkc+YffGhKzY
         JKQA==
X-Gm-Message-State: AOAM530CHhHvUnGCrkUaTz/P/myvvWMibPqSb9uq1UIriis4e4l6cRM0
        W43/Oq2yJicNXTHFxe47e/XGt8uDdzzNAmwpMVY=
X-Google-Smtp-Source: ABdhPJwvxKeUMPdxo3bMzBNMWymbnry9oNRXYHBfh9rzch/hoBlCqzQpWoInevxGOownJnHakBc16Ir7szs5Q7bYKTE=
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr17846086qvv.88.1597725678616;
 Mon, 17 Aug 2020 21:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
 <87y2mdjqkx.fsf@codeaurora.org> <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com>
In-Reply-To: <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 17 Aug 2020 21:40:42 -0700
Message-ID: <CALLGbRL95niReU+e1+5pO_byHdoWNuzBtHr_iz_HTAU0KwV2eg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 6:43 PM Tang Bin <tangbin@cmss.chinamobile.com> wro=
te:
>
> Hi Kalle=EF=BC=9A
>
> =E5=9C=A8 2020/8/17 22:26, Kalle Valo =E5=86=99=E9=81=93:
> >> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
> >> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
> >> the returned value instead of IS_ERR_OR_NULL().
> > Why? What's the benefit of this patch? Or what harm does
> > IS_ERR_OR_NULL() create?
>
> Thanks for you reply, the benefit of this patch is simplify the code,
> because in
>
> this function, I don't think the situation of 'devm_clk_get() return
> NULL' exists.
>

I admit I'm not looking at HEAD, but at least in the two versions I've
got checked out, devm_clk_get() can theoretically return NULL. This
feels like a gratuitous change anyway, but in any case it's wrong and
could cause wrong behavior.

- Steve
