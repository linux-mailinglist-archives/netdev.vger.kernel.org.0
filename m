Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349C14312FF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhJRJQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhJRJQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:16:05 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE15C06161C;
        Mon, 18 Oct 2021 02:13:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z20so68373167edc.13;
        Mon, 18 Oct 2021 02:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYiwoLjIpwXhjE4+/22a2xkYUdGgH07KcD2ULSn0KKM=;
        b=am4HvN2wsY8dZhVj+hvASDKd7y7W33NU7V/XoEnE3+nhc/IUvQniFsDTIe6WFCxJOG
         dTjXGq47WsXdE7PuaDt5CFQtJMlliwg3uvdTeZWbKkm8zA41zCoCFfO3KhbW3S0sWCtO
         9rTc962aI6CV9o6RuPaTEhhjBvN2LInLb9G7e4ViVict/rMbfNy75N5cPAkOIA8aAR1T
         XxDyLBA3Sq5+YX2v0oqaoiSCOWi2VhM73SyoyM+F+RAjv/aUl2u4f/ZU+AADTvOZ5Hx6
         8yZ1P1XdDXc21Kud1BmK7uknKAX0EGHAMrpogHGwPfZkzxDdBz9U8zySX6KhoTD0t2rx
         54Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYiwoLjIpwXhjE4+/22a2xkYUdGgH07KcD2ULSn0KKM=;
        b=ofNPUIVyRi80IsiMF7pf60yP+CcB17Hnu8XvlX7sjxuSpS7WrpBFNkvpfDlr4rok12
         TcWa+OmzRHM79GMf6PsHmHf+5YNpZzolYLmTf/ns98eqphfijClkHj9fi25sgeXpSHUm
         Oa2MIUiTf41Zr0pdiB51rw26+fvh+Cd+mBmij+sso+fYMs78Smdb1F7nqO2neqQNxei0
         JBhx+qYPQIybftOe/jlDQTlhDRn5NfYuQbWsUIM0XmDym21XN7UgurdKxsaiZkJRXcSu
         Bc3V8p/qt/EiOjL6h6iJidErWt9qZBE8gzKkjzoyUGKyQB7/cU9uOLmZXdHpVm+qESnv
         qJLA==
X-Gm-Message-State: AOAM531GjLB5CNbiMa0tbLHgGKRgthBccgdtFsHo/ssA3nvoP3x65sUU
        rxWZuBQlZxU60spvO4oTtlxcPzdM/kdPwKRFjfk=
X-Google-Smtp-Source: ABdhPJyzgbVJD9WKuqniOdZkG09nayR+ufzFdsTUjr7xg3R/e5wA+IXRSGcKv9/nnFLlGs7E+k9+SM0ja79C9ylkqRk=
X-Received: by 2002:a05:6402:5ca:: with SMTP id n10mr43501196edx.216.1634548432334;
 Mon, 18 Oct 2021 02:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211017125022.3100329-1-mudongliangabcd@gmail.com> <20211018091206.cflpumnfm3mt7aiy@pengutronix.de>
In-Reply-To: <20211018091206.cflpumnfm3mt7aiy@pengutronix.de>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 18 Oct 2021 17:13:26 +0800
Message-ID: <CAD-N9QXUzjaPqs8sgi4CPjusMzQxNWvVYDxxTL8grj+Aw48JpQ@mail.gmail.com>
Subject: Re: [PATCH] can: xilinx_can: remove redundent netif_napi_del from xcan_remove
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 5:12 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 17.10.2021 20:50:21, Dongliang Mu wrote:
> > Since netif_napi_del is already done in the free_candev, so we remove
> > this redundent netif_napi_del invocation. In addition, this patch can
>        ^^^^^^^^^
> redundant, fixed (also in subject)

:\ Sorry about this typo.

> > match the operations in the xcan_probe and xcan_remove functions.
> >
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>
> Applied to linux-can-next/testing
>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
