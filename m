Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7E479847
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhLRC7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhLRC7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:59:16 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E47C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:59:16 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so5125694oto.13
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O4bkZtAogb1N7n7U8/nfqUv5uVHGYTOshcCRiPCxQSk=;
        b=u2zPKEBt3h0fbwul1U7ul1vhD81q2RYkrL5ZimezaZIuLwSjrcl/EJxwYBnxlNySvd
         SLpFlvVGr61jJQjJapal8alo3I1alyuVuc74Yoj2/AbuYNJPzBhMEtKz8n4MPDbLeP+/
         /T8dVD8gi+Cfj/t56o01UIddsEdczMfz5nu24/uLhXUTVLEJRZWANoN/EAnSWPdXdoKK
         oZaVdM1jxQNd7V4uhTwhrr6afV6hBXWZ7eCfiR2Vpqgj9fCfzkssc9enCqcwNm4IcHxs
         5gGnasL3QiwEjR7YY4Gw09ZJYgKE2m9vUt79oLkPhQXTnqbezhUm95q3a2D/oQJp41uR
         Uq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O4bkZtAogb1N7n7U8/nfqUv5uVHGYTOshcCRiPCxQSk=;
        b=Fap4VkSx9t6XtG3kQ0QoEHBJW5l9r2IEJigsFNejn3JmufvUKR/SN/8ehoctV2o49K
         ZfmRgslI1SADcAtEfQo1JP1HiZjqsQ98ydMdIa32OkAUn08BnQWk7gzanj1r+gCW9pit
         LJnyCao2rqjilPadO5bNrSWy0uh8lPfDumohR/N6V9OJegZj/5Wf6H/oaiuU1jkP4GhD
         +V7DCkdEvGzmgv4jKmG7cLbnlcfANYhR0/iJYn1BR6xzEVpisfVz71PW6Pdn1J4bdSb0
         xLgWNT9DRkH7E0pQZKMf7WmyhCbMgqP+WMsc0+7RDenKlLiUyO7psEk4fKY6NM4Hsb/M
         +NBQ==
X-Gm-Message-State: AOAM532OrPZ/Z2k3BFTZP160xqa2rRHkehLmQdd18pyYckgzBGFwwsit
        PCwh4JVyywGOHTfMVYruqVlVGYo1q+V+4iaNbBjypA==
X-Google-Smtp-Source: ABdhPJxMtYNH7zylVtocq3xTJsDc0fWeBrt5ejKKum2mUGDOCvziBxOoaLB3jtCHFFB+wspobWMqOkbPvSc1Gwl4y/k=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr4216404otj.35.1639796355830;
 Fri, 17 Dec 2021 18:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-12-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-12-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:59:04 +0100
Message-ID: <CACRpkdaOJh70bGx2_FgDMQ6gf3_gh=hiSumdGLz=CDfspvY=gg@mail.gmail.com>
Subject: Re: [PATCH net-next 11/13] net: dsa: realtek: rtl8367c: use
 GENMASK(n-1,0) instead of BIT(n)-1
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:

> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
