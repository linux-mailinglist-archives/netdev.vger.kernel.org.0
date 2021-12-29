Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD8A481418
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhL2ObM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2ObM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:31:12 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99807C061574;
        Wed, 29 Dec 2021 06:31:11 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e5so44785844wrc.5;
        Wed, 29 Dec 2021 06:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cEnwtDepCWRMsqbEiePGkHOVDpvDpwQE2RGWhARN1Wo=;
        b=FPC+7lX27AlyFkM+h3rmxNEHNzpmiE/lVRUO8hxn75+T/yOS3eqton5N5qATqwZe6p
         FQM02ymXOtdQIza81hmsGZScudyJm0om3VGgjV2AEfHHcohLLPHRmJ24dLnCO+7IpJBA
         5Nq2tXhbnccQaxsKa0JA1cITe9QrS8MWitn8wMDWTcfOTZycESJGwIkwPP5VR3eT6bor
         5eLF8Cq1g7tlB3h6p6igXBEN7Jyb+3LMj3Q8reZQVmW631CxkOgze7G7M5t674TDID3Q
         YjuC9EhvBhYrfG7WoY3653dAv+SLalKHRaN+piWrHdl8PE55Jv+nBZE/RaDRKo8Kzj9e
         CC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cEnwtDepCWRMsqbEiePGkHOVDpvDpwQE2RGWhARN1Wo=;
        b=m5ivjAk5R2ixo2p7Yd5owLjevR0csYsTCrwR7wNfU7oijhiLDoiS82eLIEot9G8XZ2
         wLc5zDNDBmGkdUe4sQHQMos3MWnBcXdE+jEuFT2U8tXgdmM+wHkkmS4UKmI9qUYR9Kks
         mQ5yiF4ulm90XVCu33EFfFruZY8VikYg3EAX52qUbrBFw3jXndDos3FVcpjvOcqKoa8D
         pK8HwngsuqwA+ezxdXGclMT1CXHAq350LhCSjeDRe4FQf7aY2aMfBRhU8SLDmF61O71s
         sNmpngzS9PuWdnEciPdXDi/ptnXRBJWrEYsVHdCvqasMK7MIdo72bAKONIzibvgCNYhK
         D/Bw==
X-Gm-Message-State: AOAM530e1edKVk72WVWLXZenLqlxiUvbvUf7HH9npzP0YSEChsCxDLav
        kNmQDQFGHWElyJQ89YuVmqHh47UHehTo03UJ0Ks=
X-Google-Smtp-Source: ABdhPJx69lU469JucVuRNRwTlMMLyuoFdtR2jdXQhSgv7+tYijErixl7g0iFXFoJK8e8/VVPdyT7nXUF/IOc84Vsy3o=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr21189405wrd.81.1640788270149;
 Wed, 29 Dec 2021 06:31:10 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com> <20211222155743.256280-13-miquel.raynal@bootlin.com>
In-Reply-To: <20211222155743.256280-13-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 29 Dec 2021 09:30:59 -0500
Message-ID: <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
> +{
> +       bool promiscuous_on = mac802154_check_promiscuous(local);
> +       int ret;
> +
> +       if ((state && promiscuous_on) || (!state && !promiscuous_on))
> +               return 0;
> +
> +       ret = drv_set_promiscuous_mode(local, state);
> +       if (ret)
> +               pr_err("Failed to %s promiscuous mode for SW scanning",
> +                      state ? "set" : "reset");
> +

The semantic of promiscuous mode on the driver layer is to turn off
ack response, address filtering and crc checking. Some transceivers
don't allow a more fine tuning on what to enable/disable. I think we
should at least do the checksum checking per software then?

Sure there is a possible tune up for more "powerful" transceivers then...

- Alex
