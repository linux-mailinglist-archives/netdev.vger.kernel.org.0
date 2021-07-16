Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B53CBBC0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhGPSUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:20:42 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41458
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhGPSUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 14:20:40 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 336C440610
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626459463;
        bh=iIUxpkpHlT/ujJv35mg4KveIs6ZMWhsNWrIIJdMLdVY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=e1xwD4ESNvubQd7eM1pZkACw+zosSLTI7e2RcEuRoUnrY8ns1kl+lPEJuLrxSfuGQ
         lp+gM0XGjBcCB1GoySZG/QmUUL1rUCCl5syG7ofuImax7frqOcxMu6QzBNLdQmcDgX
         omOwpZSTkX3LGoHZnlEEqESx/kIscW4usm2nItLv3r9c62KHb3VEs8e5bG8W5h8oLI
         TKZpkDl8+A5tEr5bK9ovRDQXePNGBs7ihrDqnAIyxeswhIPY66T8yealO2FbtjvOZe
         V5l4LCIrsvPVJuS+SxV0RlEbgphICylifuA4zllrToscoxhbY2DOwPhcBBfo2kX0Pk
         TMfknsS1YBF7g==
Received: by mail-ej1-f71.google.com with SMTP id k7-20020a1709063e07b02905305454f5d1so3081588eji.10
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 11:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iIUxpkpHlT/ujJv35mg4KveIs6ZMWhsNWrIIJdMLdVY=;
        b=UEimVhen2Elp/9FDni+4DGiGq7OpEXj487vg5hc12WTCrwA2RKw11fsTxCw0bEYHZT
         opYO2dLcMqltZaroFR1HI/GFvle8fSpheapD4Zd4LDoLE0fiBvlRs4PbfwK+AfZ001nD
         NNTwoX8ZryQfCCTGS4pVpUvDgEsomx1gWR3B8VKVrfuMQhWu2SzYxv7zRdFVqm0VGoD/
         lneOsslXuc9b3REGuLfZikrKpN4Z8Glkla1VIxwHhi+1M3gCpmzQyHwMJkIst2n/VxWa
         yiKOrvWGEP7VVgv4eVuBfYYNLylJGts6rJRLY/fdeA4qosdhGSZZJE7nzapmKF9GZoW4
         spJQ==
X-Gm-Message-State: AOAM533F/wGKLvdDiSnCcGoNm3OB5du7g5X7YNr1MBH1muUeOU8fJtaX
        SOINSdXlzUC1CzMkYjiVTjvUs+yJLkBtGN584ZukuuZez+YT/FcpMu6wbAaWgoXL1Ct08keRU5A
        3GTg3GtpzKJMJ5891NWTkJB5uiEv0FeN2VGgh6EiTPhwBSo590w==
X-Received: by 2002:a17:906:f104:: with SMTP id gv4mr13185819ejb.193.1626459462976;
        Fri, 16 Jul 2021 11:17:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7df1dhE7FzdafW/owwyXmM1zYUZ7HBRYCPlHWpeQXx6e8+gqubotkBQv3ZT/yzAAMRbSMDc4ayjjFEpa3Tx8=
X-Received: by 2002:a17:906:f104:: with SMTP id gv4mr13185805ejb.193.1626459462770;
 Fri, 16 Jul 2021 11:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org> <d498c949-3b1e-edaa-81ed-60573cfb6ee9@canonical.com>
 <20210512164952.GA222094@animalcreek.com> <df2ec154-79fa-af7b-d337-913ed4a0692e@canonical.com>
 <20210715183413.GB525255@animalcreek.com> <d996605f-020c-95c9-6ab4-cfb101cb3802@canonical.com>
 <20210716171513.GB590407@animalcreek.com>
In-Reply-To: <20210716171513.GB590407@animalcreek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date:   Fri, 16 Jul 2021 20:17:31 +0200
Message-ID: <CA+Eumj7SPFXOMUGRxZqjG-0Jq_1EnWwh9Ny-a=+QsN8tfrrCwg@mail.gmail.com>
Subject: Re: [linux-nfc] Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
To:     Mark Greer <mgreer@animalcreek.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Jul 2021 at 19:15, Mark Greer <mgreer@animalcreek.com> wrote:
> > I am happy to move entire development to github and keep kernel.org only
> > for releases till some distro packages notice the change. If Github,
> > then your linux-nfc looks indeed nicer.
>
> Okay, lets do that.  I'm the owner so I can give permissions to whoever
> needs them (e.g., you :).

Then please assign some to the account "krzk" on Github. Thanks!

Best regards,
Krzysztof
