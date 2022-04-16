Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE8D503474
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiDPGaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDPGaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:30:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B7E8874;
        Fri, 15 Apr 2022 23:27:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t4so9907907pgc.1;
        Fri, 15 Apr 2022 23:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SfC6N8rNkT816Snz0VnYd8t37yDWhWvdxYYSUPu0150=;
        b=fyXTPqWuEIfawlBmw3F7GEzALsTRckGK49QwIQlkKFrhPx29NjF0X3UBTJWHqcp7Qy
         zUS73GzafkEro0HTJJk5T9Zy/rIzUfOJYEfkWMV294C3XCxdwMjRv6uo8a9LcZw4mdHW
         OwFFHvzASj36SZy6jt7x8Kdfm/7AymLSUzqZ4ehmWniR/zm00tn5WTEFWsGTXPVJ9Arx
         uHenT76D5wpBDTYrzyPKj5yn88WuF/XrX8yK9mm8Z29aDZ8McT/d85suc7IMfvmZobH7
         wpSt3kWrdUwDgf1KpT4wbbwYm2XtEC206pokmPX785nNWOQ+geOUfRSsUci35HWQRPMy
         2xuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SfC6N8rNkT816Snz0VnYd8t37yDWhWvdxYYSUPu0150=;
        b=JoOlml6rQ36Kd8OrhYuFzvPSOedgnOd9L4v4YP76PJg2hgsEwbKQKUkSXVq9sQbx5z
         /LErbkxfIUoOvevqhjqDCNRyHIKKPgtM+IDlggqxi9V28/gQhIXiFWqFgnMsZQMkQjS+
         OqsIm4++ZVtWtEHGilXnjtg41VuQnH1gBWbzqtUCcZeL/+I1vtjBm8EKUC+hHad+FMUV
         Z93ayh59zW5m+QfNa2NDzowNs+xfG34iBkZiCFGfKrZuYwYr8186DMPHND1YY2ol8XZM
         Cc0I498CR0oOX/XMIHYJ+InwLopUO+fcPl9FcZ5imNWnUxrjKMcyuJME4GE2K4s2xrMU
         CUog==
X-Gm-Message-State: AOAM531bioDw6Ft9xMRFTklPopU7I38JnQHnhNsGlgWUp3GsSfAnlfq4
        TNEFztd1LCT0sVEoQ1L+B3cTnRzkvXlSY4ryEQs=
X-Google-Smtp-Source: ABdhPJxuXVx8ooTyDrdzm1tmYfgk51CFQw2OFdqFzDso/5JahWhLF8mmzzLg1aXsw/r6L//YlHN6vmGcml2sEACiuQg=
X-Received: by 2002:a62:fb0e:0:b0:505:fd9e:9218 with SMTP id
 x14-20020a62fb0e000000b00505fd9e9218mr2498851pfm.78.1650090455895; Fri, 15
 Apr 2022 23:27:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
 <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk> <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
 <20220414113718.ofhgzhsmvyuxd2l2@bang-olufsen.dk> <YlgmG3mLlRKef+sy@lunn.ch>
 <CAJq09z5hG7VkhkxdhVTUvA-dMJr6_ajkHYBZ6N2ROFXLz0gijQ@mail.gmail.com> <YlmCsMk/GekmdewG@lunn.ch>
In-Reply-To: <YlmCsMk/GekmdewG@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 16 Apr 2022 03:27:24 -0300
Message-ID: <CAJq09z7rckskEguiEtrT0ynehbKqSFq1Sec8L1wQZr8nZzbs7w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So to me, this is fine. But i might add a bit more detail, that the
> compatible is used by the driver to find the ID register, and the
> driver then uses to ID register to decide how to drive the switch. The
> problem i had with the mv88e6xxx binding was until i spelt this out in
> the binding, people kept submitting patches adding new compatible
> strings, rather than extend the documented list of switches supported
> by a compatible.

Thanks, Andrew.

I just sent two patches to deal with the cleanup.

Regards,

Luiz
