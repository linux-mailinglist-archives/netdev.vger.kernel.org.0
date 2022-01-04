Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D519B484B50
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 00:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiADXot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 18:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiADXot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 18:44:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB16DC061761;
        Tue,  4 Jan 2022 15:44:48 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so4726713pjp.0;
        Tue, 04 Jan 2022 15:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rFigboCaXYTcvuNRtDgBu0q0Y7R4x8sRxiqQSIOekcI=;
        b=X5+1WcWadDxmLHgnLYPqBaG/G1hJXZTeGGqcKlkkmN8QBT0TR3uDpVvfYs3604CKSl
         hfrvgo7QCe8hQQYPtaAT+7JsOvefVtDEfRhZoT7ND1OA5Q88z5BnkwK6oFP4bNU2sfEz
         qEkCo/9fz4VMnD6DcFoXUq7IVkVOF+mbxP0QBjcD0F5aikjipVhZKIvQ+IRnAra9blB+
         D/yb2drEhiUqtFC6AbPJF0JPcToBKaEy08sTE5IoCJTGRXuHSbbHe25o4ELCYUBqzKGb
         1Z/FDnfp1wlvozPIudDBx5DNRAe5bHbvJjuGd4reK4bliBkF1BHdbUewRCqwtYIOsl1H
         8sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rFigboCaXYTcvuNRtDgBu0q0Y7R4x8sRxiqQSIOekcI=;
        b=7TSyDP9NBowm9lRUTAefQcHvPlDRTPGyn/wpYarudjAk3n9GzB63RsuQ88lTqDwn8a
         +wTYIj2KPy9BCABBaxt+V6nFOZqewC+UWBZVhgjrnyRZEyFoEFAY+tWEuKJ0xbpgYtla
         MjgIXsOEjWW8MXvL+vsIuBKeG20enhSiU1TvVO/dl7NjByjzIjntVJk67rDk6JLqlbBr
         qjOCb5uLBRB2JtE80LlbnDTSwHWyyPmxF8cQBhXt5bEoy/vCGertB58JznxTWcvInDZm
         +6I4Lp+KsQfEAyoRV0CRvm8wN89w7/mUR6iYQ6qbxN4qV7bd4devNfLfxfLA3Y6FqRU1
         Trbw==
X-Gm-Message-State: AOAM531BUJRTIGSmh+OtTcS8CzCiWrrrlmSodDtQRGhJhT1S4UKuoO/n
        pIHZcJLGzz730GiER7QluB0yRNb8k6G1MOsKPck=
X-Google-Smtp-Source: ABdhPJxDXGP6CPLDVKAH0WDxteDFEAe1jkRfrXfs/cYydaQYy7ZKL1gXXNkZgR+gX+mTaZzOZnsCyJtH+2uvcBAY0zE=
X-Received: by 2002:a17:902:7003:b0:149:ba80:8740 with SMTP id
 y3-20020a170902700300b00149ba808740mr13581814plk.143.1641339888399; Tue, 04
 Jan 2022 15:44:48 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <CACRpkdbEGxWSyPd=-xM_1YFzke7O34jrHLdmBzWCFZXt-Nve8g@mail.gmail.com>
In-Reply-To: <CACRpkdbEGxWSyPd=-xM_1YFzke7O34jrHLdmBzWCFZXt-Nve8g@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 4 Jan 2022 20:44:37 -0300
Message-ID: <CAJq09z5k396kc1VU0S_a_6gwpT5sO5LtXFcW_T8PPzKmkRpnQg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Linus!

> > +    description: |
> > +      realtek,rtl8365mb: 4+1 ports
> > +      realtek,rtl8366:
> > +      realtek,rtl8366rb:

There is some confusion with the n+m port description. Some 4+1 means
4 lan + 1 wan while in other cases it means 4 user + 1 ext port, even
in Realtek documentation. The last digit in realtek product numbers is
the port number (0 means 10) and it is the sum of user ports and
external ports. From what I investigated, the last digit numbers
normally mean:

3: 2 user + 1 ext port
4: 2 user + 2 ext port
5: 4 user + 1 ext port
6: 5 user + 1 ext port
7: 5 user + 2 ext port
0: 8 user + 2 ext port.

The description in YAML was from the TXT version but it is a good time
to improve it.

BTW, I couldn't find a datasheet for rtl8366rb. The commit message
says it is from a DIR-685 but wikidevi days that device has a
RTL8366SR, which is described as "SINGLE-CHIP 5+1-PORT 10/100/1000
MBPS SWITCH CONTROLLER WITH DUAL MAC INTERFACES".

Do you have any suggestions?

Regards,

Luiz
