Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F9E42678C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbhJHKUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:20:45 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:58964
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239298AbhJHKUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:20:43 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CB21A40000
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 10:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633688327;
        bh=8OszAYwmyRLKjqkt/vzBzk84xsQhgfNIYVQxorJQ0FE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=SRF6YidZ+y7P84k1wpC6shqHno6BTxTmbsoYuiPcxw1TsfjP4euOmuuOMhpahf5e5
         BfQ+LGEBw2EAZAN3w4GCcHtr5p4lARCs4zTCUGmneSWKSXvesWkGpJd9qeEkTl2ZV1
         pRYYAw7QYghMw8gZOYIx06TRZvwAu9vhuI4D0GLUE7kpRixQ5EcVeiypLYwmBUmIhk
         1OSOCNbeTmWrDnfTHUzjm3bgrWCd3LmJRCdLF9lIipm6Za/+yyMIV2RDYBhYGygnai
         qwkUijZPOXBRRwuaO9i63vDze9llKkxroExSO3yWP23+vu5gVt1GOk+b80zz24lzkM
         HdlWg/dvb4XZQ==
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so8707905ede.16
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 03:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8OszAYwmyRLKjqkt/vzBzk84xsQhgfNIYVQxorJQ0FE=;
        b=sEfpW47LfKCy1iN8TLDNRP5K1GMSmOQ0jQp9XUsuazid+V6U6MBFgeKSieKHs3ecWo
         BVpOi4oUoVNTIdoSv/w2Sl+oXL4ewebVnTsukk9d1Tw49XcdEBr+7r2MJm06XTy1ohai
         klysXPh0NQeM0cvReDhpUstkT//v6scQitP44ufA06NuBYFsPk8J8hqjnSTZ5GnEkJAp
         YgNGwZwdMq4nE/DLjpo3H+he3VbrJuzPDzhcUMNMUUcvPisbVT6cBPxReLaJ7Lp7xsBh
         6ET2wijE89iaFDgGG7BB7eH1OUqWtBZ/T2bDb3PoMuBy+zenOc1W88mxE7JzftH2JRey
         Smag==
X-Gm-Message-State: AOAM532IPSGM1+CI8rREey3sg2ysYxPpBMM30feVeHSNtQdTqW+DcNWv
        OVu0ztzwaASjJWhG4QmAtLfZ0N8kDu1gwXKt4QCW39B0JwIetc9q2zALyXOkb4Fw4qgNnycNgQh
        a0v54MQW5WWZYAo+rHummiWigqaeZoFQ5qUdb4OQ/CpVU53k55g==
X-Received: by 2002:a05:6402:21eb:: with SMTP id ce11mr13601235edb.153.1633688327498;
        Fri, 08 Oct 2021 03:18:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7o7l2UNsnGaraOVKpHhb8tbtKVV+1I4OFVbSEp6Eg/VZ00BTQ9CBhrhN3STNdktZj1NYqnDUwdbEyoGT3BvY=
X-Received: by 2002:a05:6402:21eb:: with SMTP id ce11mr13601210edb.153.1633688327360;
 Fri, 08 Oct 2021 03:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com> <20211008.111646.1874039740182175606.davem@davemloft.net>
In-Reply-To: <20211008.111646.1874039740182175606.davem@davemloft.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date:   Fri, 8 Oct 2021 12:18:36 +0200
Message-ID: <CA+Eumj5k9K9DUsPifDchNixj0QG5WrTJX+dzADmAgYSFe49+4g@mail.gmail.com>
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

On Fri, 8 Oct 2021 at 12:17, David Miller <davem@davemloft.net> wrote:
>
> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Date: Thu,  7 Oct 2021 15:30:14 +0200
>
> > Hi,
> >
> > This is a rebase and resend of v2. No other changes.
> >
> > Changes since v1:
> > 1. Remove unused variable in pn533 (reported by kbuild).
>
> Please CC: netdev for nfc patches otherwise they will not get tracked
> and applied.

netdev@vger.kernel.org is here. Which address I missed?

Best regards,
Krzysztof
