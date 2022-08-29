Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCB5A516C
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiH2QSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2QSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:18:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826C452DD6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:18:32 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so4695625wmb.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=qaZiFJufiSPKZcnNHbg8MAn8rJRW/A3NE9R1PZr/vQc=;
        b=aoyMKFiZq6qsAQhX8u1tcaY13Tob/9wOy8KPzqZkIYMINtVKlBdKjs8mZy7PtX8J8N
         MbzKTCJiKAdvznkO+xwcK0WS5GZOrKW5uHvNw96c5wxnGowieToqugssyDNMnP9RGET8
         RjuJUatB2sYELS3lKG+F5j9waJwdyZSOyUWZWNgb2PkbQBskvPy3vUdUZY6buduS22os
         f2aIc/yd1H81yy31oakuIUhcpiSAouGJXGs3uB/yNnD/f8i6IoQOeOwnEigjI2Zsy3G2
         Fq9EHWsQFoi0YsB/0dJcG1MN76z6nOZR2Fos2l6xCrI6e6u4AEqwJTMpXXFmK2Vpj8z8
         02Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=qaZiFJufiSPKZcnNHbg8MAn8rJRW/A3NE9R1PZr/vQc=;
        b=LQqfgJDYZX7z074LZXUDoc96pAcHNclnQrgoP+LjpXPXXEPAL3r6Q/dTs3OINkd1MA
         9szr4xzq8ZO0QsZGGLIGxvgY0kWp9KVn6zsTq/HQSuJQ1hJdZ5iqFFsYpYFX5CjcI1ZR
         k8r4h+dwoWAQSpG5IF96qLUvTAX7OdFtkvsjEppfbXaYGply10kNpVl1VPLbeC0ZoRVN
         LHjktzeiHY+Cf9wUmIp2acfjZbp7pu4GLwiOlaT6lGD1LXF1ZK5uTs02KYVj9UIXh+9+
         3MzJi4gmCBnhNKrwZ7V6PdwjoiJaVxVD5QmEaDYB0t5lezjU6uxpE8yuqBoTt5zvbVUd
         FtYw==
X-Gm-Message-State: ACgBeo3cP7a6K35ACt/KYR7y6wfQgHlgjmUItRBvR9WnCmi0oJGGunGU
        ShUzTikLSt4pXvUDBldsbCh4o/rYKUfHAYagvGw=
X-Google-Smtp-Source: AA6agR5WL7v3NpBhMOF0ZZX29m+dHv8Qkkz8adtzXD54Vg0s77zlMeI2XhYyX6Io+2R/uO2c0S9bUIhEsCFf9a2kl1k=
X-Received: by 2002:a05:600c:3b9f:b0:3a6:53f:12fb with SMTP id
 n31-20020a05600c3b9f00b003a6053f12fbmr7480809wms.194.1661789910892; Mon, 29
 Aug 2022 09:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org>
 <95259a4e-5911-6b7b-65c1-ca33312c23ec@tarent.de> <e6509d55-ea5e-ee51-692f-2fe75ba28a21@tarent.de>
In-Reply-To: <e6509d55-ea5e-ee51-692f-2fe75ba28a21@tarent.de>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 29 Aug 2022 09:18:19 -0700
Message-ID: <CAA93jw5DQ7U_TU2SpJNEx4wHxcisb-Am8AHQJHk6hkJNV+w_RQ@mail.gmail.com>
Subject: Re: inter-qdisc communication?
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 9:08 AM Thorsten Glaser <t.glaser@tarent.de> wrote:
>
> On Mon, 29 Aug 2022, Thorsten Glaser wrote:
>
> > All references to ifb seem to cargo-cult the following filter=E2=80=A6
> >
> >       protocol ip u32 match u32 0 0 flowid 1:1
> >        action mirred egress redirect dev ifb0
>
> > I require any and all traffic of all protocols to be redirected.
> > Not just IPv4, and not just traffic that matches anything. Can I
> > do that with the filter, and will this =E2=80=9Ctrick=E2=80=9D get me t=
he effect
> > I want to have?
>
> https://wiki.gentoo.org/wiki/Traffic_shaping#Traffic_Shaping_Script
> has =E2=80=9Cprotocol all=E2=80=9D but there is still a filter required? =
Looking at
> net/sched/cls_u32.c this is _quite_ an amount of code involved; is
> there really no pass-all? Maybe it=E2=80=99s time to write one=E2=80=A6

In general I would really like to simplify the ingress path within the
kernel for common cases. My dream has been, of course, to be able to
do this:

tc qdisc add dev eth0 ingress cake bandwidth 40Mbit.

without needing a filter, mirred, and especially, have it remain multicore.


> bye,
> //mirabilos
> --
> Infrastrukturexperte =E2=80=A2 tarent solutions GmbH
> Am Dickobskreuz 10, D-53121 Bonn =E2=80=A2 http://www.tarent.de/
> Telephon +49 228 54881-393 =E2=80=A2 Fax: +49 228 54881-235
> HRB AG Bonn 5168 =E2=80=A2 USt-ID (VAT): DE122264941
> Gesch=C3=A4ftsf=C3=BChrer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, A=
lexander Steeg
>
>                         *************************************************=
***
> /=E2=81=80\ The UTF-8 Ribbon
> =E2=95=B2 =E2=95=B1 Campaign against      Mit dem tarent-Newsletter nicht=
s mehr verpassen:
>  =E2=95=B3  HTML eMail! Also,     https://www.tarent.de/newsletter
> =E2=95=B1 =E2=95=B2 header encryption!
>                         *************************************************=
***



--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
