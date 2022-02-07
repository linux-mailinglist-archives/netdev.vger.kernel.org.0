Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796744ACBF2
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 23:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbiBGWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 17:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbiBGWTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 17:19:23 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DF9C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 14:19:22 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id r20so1325708vsn.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 14:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQkFY6DiFU3YhdDvfn1MS9BhD+iIDIKFAm8dJkDzqKw=;
        b=scAscr8K6g3iFuYY2izOWRWH5zyLuISf4xEuug7MlSkSzT+5Ir8gwDWZTUp4H4SJV1
         eYTBuirACPiwSPgg7E40NDYxLfuIOJo3QwNutOAV8TaA7Mi2TfIGX2+PQrCZG7TYxWtt
         zLPjEOKGORYHJBFKeJyCJHfOw+nc61ddtjjSlridg5bCo8N0epBpO5z35bs6T/cjkagW
         N5r0x65iZATuh4COX4g+Gy0HrhGl/unwoKZ+J3T1eehULgjtANf3dUd6WBm0fQ1hyxFp
         DBAjzaC9Q6EQsbJPARnDx/P/ipYhvUNZVpts/x1/0wyG6tudGUYOPPv5FFffJNVkxKfl
         HBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQkFY6DiFU3YhdDvfn1MS9BhD+iIDIKFAm8dJkDzqKw=;
        b=Y6yjjVP73bwJND4MEPmwNb3adg5Zuh74ZMSBY9c928szSb8lnHZqzEniydMAM+zEP2
         bZtMjgc5EWgWZuo5OPlF2ZOeXGyudNvZsT05kQPP+S/r1hmiqAkD+zGe0GybhH+h6kBC
         8gd/J3Mpsjwm6RxUPVBvgVQ9A0B+EjM6rM1lJ7qX/lj2lamPlKqjm2rCdfyZ42woCy6w
         LzL8Fy+wTcUmTk5OvBPH+tLRO5ns6hMRxqFeR5WM248vjRwbJe+I+kuiPVMfMfymaOrX
         0zoCn5c7eTuNqqJGrKdHA+EsbyOaQRgrJ3AS99qfAzp6MZUp1Dk+abCcfsRdf0pIg0VU
         oTNg==
X-Gm-Message-State: AOAM531+Ge+Ef2TQFszIXDUxy0iZSdE+l32iZTxR+5tER6j6ROzD9M+z
        JvEYmkunTLKXFvLaAuRJThloLV0iXeGp3ebD6M23FA==
X-Google-Smtp-Source: ABdhPJwXS3o8mol+Wk6pc8ASt9fH1vhayBMJIhJSzaUgRcskgSj23MqN7ULSe0VTRuelYAoeG57jEbUXdy7GhooDVj0=
X-Received: by 2002:a67:d717:: with SMTP id p23mr751399vsj.38.1644272361351;
 Mon, 07 Feb 2022 14:19:21 -0800 (PST)
MIME-Version: 1.0
References: <20220204000653.364358-1-maheshb@google.com> <20792.1643935830@famine>
 <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jjLdLjrOAwPR8JZNPTNyy44vxYei0X7NW_pKkzkCt5WSA@mail.gmail.com>
 <20220207090343.3af1ff59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <8826.1644255465@famine>
In-Reply-To: <8826.1644255465@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 7 Feb 2022 14:18:55 -0800
Message-ID: <CAF2d9jh6O0wonKA3nw-Zx6jervXBMdJAbDuTEK6U9ccvaQr2rA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with slave_arr_updates
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 9:37 AM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: quoted-printable
>
> >On Sun, 6 Feb 2022 21:52:11 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
> =A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
> =A4=B0) wrote:
> >> On Fri, Feb 4, 2022 at 7:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >> > Quacks like a fix, no? It's tagged for net-next and no fixes tag,
> >> > is there a reason why?=20=20
> >>=20
> >> Though this fixes some corner cases, I couldn't find anything obvious
> >> that I can report as "fixes" hence decided otherwise. Does that make
> >> sense?
> >
> >So it's was not introduced in the refactorings which added
> >update_slave_arr? If the problem existed forever we can put:
> >
> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >
> >it's just an indication how far back the backporting should go.
> >For anything older than oldest LTS (4.9) the exact tag probably
> >doesn't matter all that much.
>
>         I think the correct Fixes line would be the commit that
> introduces the array logic in the first place, which I believe is:
>
> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that us=
> e xmit_hash")
>
>         This dates to 3.18.
>
Will do. Thank you both.
>         -J
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
