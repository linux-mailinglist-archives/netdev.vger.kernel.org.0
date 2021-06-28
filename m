Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC63B6B22
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhF1XEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbhF1XEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:04:08 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EBFC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:01:42 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d5so14801338qtd.5
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xREGAgfylRZEWnmtn339GHuIQT91FiRmLJWZ8/p5oek=;
        b=Bwg4oF6REQrItnlOB8OrOjCUwBv0XsDZFvpIdPPLbC2YtvK9pPJ5lmk0ZKjTi7dTLy
         2IFlRWaGfwK4wfy0vA0vIrbQ+yW3jwTo9tLHMtwzyRtkUQrN/nT8QzWErUEDoy3+RVAB
         olY/gWMcEUk4cabbPeKnKyIR0iZ2ITOnDKGIq7LOdX84V4uTShVk+d3feZZwPtzZsUdE
         6F5+A+yV0dY92N/KZrlmlWdnbNeATTI9we48Ovz+3t+2JARIXESyuPgOBP7bZONlkk2A
         qKpZfbBdNJqEWlTMBRO5RwAEIcgcjMAVqG/qK7QaUCRzr5QCzVRLZF7xRf3pKhtJxj50
         dQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xREGAgfylRZEWnmtn339GHuIQT91FiRmLJWZ8/p5oek=;
        b=Iu0/pKKL4sUqXcYPZ6XfEYXF4T52BV5cP66Peayo68ExcsYRApXHCOrikyaMtmw07o
         X9CJraCwhOnEteDZ3DEaZPxwHNMaPDF0zdmGYxCQxJmE7+3Ub6XNuu0L4AjrXwO1CeV/
         aQ36aH963DVyB3OZm5mTJaPTorlMuBL95O4Qjk2l80DnTyL4DhNmArGWlE3xJe9tbKsa
         kv2MFRwfntn5+fd9OcA+m5EIKof4kzfTP/8Ns5jZk294Zde8ZWluhdOU0YsV8ER/4PRo
         L/MyeIeC09uecbILXuLWFsmMDEg2f35rZ4H8dsw9r2S53z8+jywvTH+kQuMz7ISOGUae
         z0gw==
X-Gm-Message-State: AOAM531RA2sbzhCI7wdFFpyy/3f7auG1lOX3lPeshD3k+Y+zGJeXeJZ+
        4rtP/k11tzk6cnZ7kAkIkX9Ckh353RzmIRaerjgMvw==
X-Google-Smtp-Source: ABdhPJwf8mQ4SkyN1jbLZPnVqWe05sFmPrl2EKkSugHFkdfqlRXLAP7M6Q8DYdZw3pflXnUr4wCASMTe7Ulj6wNvV54=
X-Received: by 2002:aed:2064:: with SMTP id 91mr24033126qta.318.1624921301032;
 Mon, 28 Jun 2021 16:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210628192826.1855132-1-kurt@x64architecture.com>
 <20210628192826.1855132-2-kurt@x64architecture.com> <20210629004958.40f3b98c@thinkpad>
In-Reply-To: <20210629004958.40f3b98c@thinkpad>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 29 Jun 2021 01:01:30 +0200
Message-ID: <CAPv3WKfcHZ642S1SczFNMruq64H9E6x0KD5+bYWHcs3uu058cQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with plain
 RGMII interface
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,


wt., 29 cze 2021 o 00:50 Marek Beh=C3=BAn <kabel@kernel.org> napisa=C5=82(a=
):
>
> On Mon, 28 Jun 2021 15:28:26 -0400
> Kurt Cancemi <kurt@x64architecture.com> wrote:
>
> > This patch changes the default behavior to enable RX and TX delays for
> > the PHY_INTERFACE_MODE_RGMII case by default.
>
> And why would we want that? I was under the impression that we have the
> _ID variants for enabling these delays.
>

+1

From Documentation/devicetree/bindings/net/ethernet-controller.yaml

      # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

I guess you should rather fix the hardware description of your board,
i.e. use `phy-mode =3D "rgmii-id"` instead of tweaking the PHY driver
itself.

Best regards,
Marcin
