Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011034280DA
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhJJLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:39:17 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:58542
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231829AbhJJLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:39:11 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 56B7F3FFF3
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633865832;
        bh=3aL2g6ASYJjmJXLGE2td/GKebrEEfp5cYtOVSOPNOjE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=YaQC/MsZUVthOkS9Dee/wD7KNQ4OAhbpdHueKM6x7dpSOzi9Yk6/MXANG1/KMHOA9
         EXxOBZrfzczIA5+gMgIs26z0UA0AIy2X4bxHbH0s/kTyZcq0t2X4xYQwLbbw8dHI04
         sj17NjBG+LtOXWmWEDzZrAB3OXKoZqngvMJ+yfD2XmR/vLf84WzCx9QSe4KzNTxaMR
         if0xMTYwqmCF2tXVgKbNEXKdcT8/cO4r7nhlg1t/76pGgkQr063ILKVU/f7VQDSQ2b
         su+iXO72WbGTsx6ziOJVsWNC7eIbvHIckyqTOpCdW0/XFsUX/v7Cw06PlhtgfCyfMp
         KStpVfM3qQbpw==
Received: by mail-ed1-f71.google.com with SMTP id z23-20020aa7cf97000000b003db7be405e1so2346578edx.13
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 04:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aL2g6ASYJjmJXLGE2td/GKebrEEfp5cYtOVSOPNOjE=;
        b=gdzKbpFqVYwDHfYqRYdr15QwQf1MMvsWKMf72lTtJrVZnQac9IhYAuvaXJLlibx09H
         /TT9cAejiC6Q98ndW8XXGu0WikgcB7gu6xYxnzmhJkTz4es22SJSPxMhjG5qhNSkhtam
         LMLzYXOu5+fr3PU2hSp5TPM41T41FpxwkYPLk/XfeocXt1CBGF8lOUI62Mm9xVblEh9n
         z8t6uaahUj46/yszclN4uFKkpDewvDYz3D+HWppIBenLBG9qfUlRXcXBXBCBd9Y0PM1I
         zWLDSvYKUbYZ6eK6ciwuTzVdL9KmWinUE0Ut3nXiyeNvW4BuFAhL5Y+8sWDGmOlxz7XZ
         gMRQ==
X-Gm-Message-State: AOAM530oSY6bmvsi8wl/yGB9SE7x5dThRXV68CRzVeXSvbrDptBR1I49
        iGKtZXaq5jJJiP7WPbALrtP3q595gGUDnQqgmWRfLVyub4tyBPcWBTru39CGQvrq7fUxPsfzJJv
        8nn9tFz+jvTrda4nYPZ81K/y5Aw8C0ODuh5jAlxZTFlt+ZVfI8A==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr17554112ejd.171.1633865830570;
        Sun, 10 Oct 2021 04:37:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmGfXRax8w6ByvvioynebBatQTyi+KnMs4IdARMtMQVkKFfh4370Xu091DRaFkuwupjNT9l7lw+PWQutb8gQQ=
X-Received: by 2002:a17:906:919:: with SMTP id i25mr17554102ejd.171.1633865830425;
 Sun, 10 Oct 2021 04:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
 <20211008.111646.1874039740182175606.davem@davemloft.net> <CA+Eumj5k9K9DUsPifDchNixj0QG5WrTJX+dzADmAgYSFe49+4g@mail.gmail.com>
In-Reply-To: <CA+Eumj5k9K9DUsPifDchNixj0QG5WrTJX+dzADmAgYSFe49+4g@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date:   Sun, 10 Oct 2021 13:36:59 +0200
Message-ID: <CA+Eumj65krM_LhEgbBe2hxAZhYZLmuo3zMoVcq6zp9xKa+n_Jg@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 0/7] nfc: minor printk cleanup
To:     David Miller <davem@davemloft.net>
Cc:     k.opasiak@samsung.com, mgreer@animalcreek.com, kuba@kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 at 12:18, Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
>
> On Fri, 8 Oct 2021 at 12:17, David Miller <davem@davemloft.net> wrote:
> >
> > From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > Date: Thu,  7 Oct 2021 15:30:14 +0200
> >
> > > Hi,
> > >
> > > This is a rebase and resend of v2. No other changes.
> > >
> > > Changes since v1:
> > > 1. Remove unused variable in pn533 (reported by kbuild).
> >
> > Please CC: netdev for nfc patches otherwise they will not get tracked
> > and applied.
>
> netdev@vger.kernel.org is here. Which address I missed?

The patchset reached patchwork:
https://patchwork.kernel.org/project/netdevbpf/list/?series=559153&state=*
although for some reason it is marked as "changes requested". Are
there any other changes needed except Joe's comment for one patch?

Best regards,
Krzysztof
