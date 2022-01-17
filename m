Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFBB491210
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbiAQW6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 17:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243737AbiAQW6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 17:58:32 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F81EC061574;
        Mon, 17 Jan 2022 14:58:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so2864505wme.0;
        Mon, 17 Jan 2022 14:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WdGqrPm5cWV7Fm8a2fqKbzq52QqMkIvECYtgC/E9yPM=;
        b=AAcP4Hp3D8m9IhxRqBmYqoKvCN6EmbLO2SnnbybP7jbT5IuWq4MwS6fL43VvVj8H7d
         Dn8+V/uZ6IuHc7XaBEgofHf0AJ6Td9nplkyunXpbyCOxVcBNDLQ95LvWfYyCqLpJVV4G
         A1/uixI/bErREKFtAaF4zcXQr8hsUi8bnQVYhUlREQyDhfvI6k5isNgZkSp68Im+pzMB
         bQnr9WRReBZ2XfBlX/zxUd84gL+GbQSE9WZEW//EtVKGM8T3R+mHFm1l9bhZpgsLIbBC
         DlV1yamJkdb8ICSonaiAK1+/YseGjZGfclEpSzlB4LBEpOpsTxBzhqQPXZDjUfqn+cRk
         CnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WdGqrPm5cWV7Fm8a2fqKbzq52QqMkIvECYtgC/E9yPM=;
        b=D6g6T2+0r2OsdzQGTy+p+t8nxSTG1Y6nfTYxHg98Y0rGoWNV/iJQvpaK3j+23BIe11
         8mtAascRPBloOHKV0hbU9zPETbSTpe9PEPLu7evAqVKVrVptfyoTQpvlSKV75ugyUqon
         bqZeBNqTE8yy1vu7a5b8Fid5F1ag6r8bCCq+sbfiBRCeV7fD3/Es3ta/gAv1RFqd9iVG
         nzwfWhtntUQGDBNMXx2r0g/tX+WIqevBKh8knnm6j+fBpo1F+PXzoWhyXvYu8KXXxMTC
         LmZaWMUQhHDwlpUB+8/B8Uf0xlASkcS+kDX3vhgNvEO/XKkuvXUtux/n8h9YtB5rSl+j
         PlKA==
X-Gm-Message-State: AOAM533BU4VILYnQa3soZjHBtOCJtbOtLIOo0OAYi2NO+JU4QuB8Rucd
        +nbPYkm5zm7w6VBRqGTdrbZiX4eWQkdbhq81tEV2zy4HQno=
X-Google-Smtp-Source: ABdhPJy+qCiV9JCmr+ZXjl7E8g7ZxYIvCzqUg/jaRY8O2kwwpT3/1R4GMV86whkmFyHMpibcUGjY/f8yKtXNzjuY36s=
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr21415320wrq.154.1642460311074;
 Mon, 17 Jan 2022 14:58:31 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com> <20220117115440.60296-18-miquel.raynal@bootlin.com>
In-Reply-To: <20220117115440.60296-18-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 17:58:20 -0500
Message-ID: <CAB_54W71EnDyeE99UPuMoJ_EWVOSMv=_uqVz3jG=Jfz5UQMXDg@mail.gmail.com>
Subject: Re: [PATCH v3 17/41] net: ieee802154: at86rf230: Call the complete
 helper when a transmission is over
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> ieee802154_xmit_complete() is the right helper to call when a
> transmission is over. The fact that it completed or not is not really a
> question, but drivers must tell the core that the completion is over,
> even if it was canceled. Do not call ieee802154_wake_queue() manually,
> in order to let full control of this task to the core.
>

This is not a cancellation of a transmission, it is something weird
going on.  Introduce a xmit_error() for this, you call consume_skb()
which is wrong for a non error case.

> By using the complete helper we also avoid leacking the skb structure.
>

Yes, we are leaking here.

- Alex
