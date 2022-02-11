Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0354B3127
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbiBKXMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:12:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBKXMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:12:54 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02994D62
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:12:52 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id u16so13080810pfg.3
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+n/Lnka+2Tyq0QmlWm7iUQEJhcCtzrJbb7eWZYa85+A=;
        b=Y38pq6QVYG7a4T42TacAmoKbTnp588jMF3a+x3mTAkqwHe6sg+s/Om1iUCzeUfgDP9
         HkZgf4Da+CNS3CLo4pAnEtOrCPiQ+PiOgQcgqq3sqI6muJCpb2q48dwi6UQZ9goeKQ2X
         PJADQGzwJPsKsBlxRFWdCJ0tZeo9pRDECXGcaToFHzkvRYyEGPRp0WlpYUTvLzyoc3ST
         RW3PksBjxevAsJkXI7b8JROrW2XCetgGtTeqvOQ4SIwmswFrmX/d57b6hiWkLUGr7SIn
         YkoK5XeIIH2o6nEI5HK3GQh+saDW54e91SpIQDwfcUdSxlwzGzs5BMY87oiJlIGGxluC
         22dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+n/Lnka+2Tyq0QmlWm7iUQEJhcCtzrJbb7eWZYa85+A=;
        b=ZsTp5QKnRzIXUWyQ0z+3O/Zx0H6stKk2TyC0k6NsA1xl0IlPMHtD6jcBdlKYg86MUW
         wriztvZT+BvtUGGigVK1wpdmeieYxLfKffIoIrzdpFwaa4fFpWKjvkWT0+93m2EGI/Fm
         jDlM9e4qOW/Vw/RJH0vFLaV7bEncYvriDwxCzlYK6yu9SOknadGuFThJF5g/t2s+e3Gv
         e/rP5FjcrpPnHFnSO1vZCCmSLDpWGYC2SYrvaGN/HNw+lNhP7c2DlI/WLmwZPhgUHTXa
         zk1tB506hHOnOTfLbBTJJdkvfO8SOBOXwfFdjSUpbXrjZRsJlXj/fmyNL6o/5Q+pPrmk
         d+AA==
X-Gm-Message-State: AOAM530FEjxzqXmb/bBS2agNXdgVmy1XkEp5SYfcBvxXlfYrVm+54Uj4
        aUA4vYGTMxYny3eOJ1tPxMLIVlXAEhrJwf4DnHYrpLF7uJUHwy+L
X-Google-Smtp-Source: ABdhPJyUsjCTIV55j8J2drSADbb8RDiuKFyHdi52I7QVJcqyMsDHpaIFyZQXGtyz+jqUa7firZupnCE6UvPJh5W5rGU=
X-Received: by 2002:a63:82c7:: with SMTP id w190mr3152902pgd.547.1644621171445;
 Fri, 11 Feb 2022 15:12:51 -0800 (PST)
MIME-Version: 1.0
References: <20220211051403.3952-1-luizluca@gmail.com> <87a6exwwxl.fsf@bang-olufsen.dk>
In-Reply-To: <87a6exwwxl.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 11 Feb 2022 20:12:40 -0300
Message-ID: <CAJq09z40AvaTK3gG6W97s1jmfZU+ER6u0_Yqy3ii0S03d4Q42A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before setup
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
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

> >
> > +     /* leave the device reset asserted */
> > +     if (priv->reset)
> > +             gpiod_set_value(priv->reset, 1);
> > +
> >       dsa_unregister_switch(priv->ds);
>
> Wouldn't you prefer to reset the chip after dsa_unregister_switch()?

Thanks Alvin, you are right. Maybe a thread might ask something after
reset/before unregisters.
