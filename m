Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C096A7C5F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 09:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCBIS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 03:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCBIS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 03:18:26 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E65170A
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 00:17:54 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id nf5so11139079qvb.5
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 00:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677745073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fnDT//7e2JIzJzaYCfhw7/uObzTQ6yhK1vb/ZciqNQ=;
        b=YyqddJhKPJH7iUiZpTFUqG16d36klRdQ+58RLYuTRTj5KEkSsHZOusGZiQkD4+dFzW
         gV8ouStPolCjb1TRm4Sok/97/NS2yxYqTsAdK90qB6MWyDV8Lay4ObTXnUFs6a+CpRZS
         iA08Im1Zwd12WSOYc0e9laFef1dmu0IHkC/RoBpalN0WsvGirODLBIL8jKUwZyUlRFaD
         iQvJdrJ1238uwdMaND8fhGgX1nVaz6jh/O3zxhrOQ5Y1WhzAgP9sVvBkDwkKuVLypLxV
         mTe+C6Qr0/Qf1gTaXUI5qiMW7Q1cvqmYfI0Wz99jGTpvLMfmFE8n1joHRWqjcI8ANl68
         CGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677745073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fnDT//7e2JIzJzaYCfhw7/uObzTQ6yhK1vb/ZciqNQ=;
        b=4A/PVkRtTC532FHHFZ9dJI4Dy0pwHVgByrSW13KLvz336Vds//RQhoKhsa/vaWm8t4
         jYJPIQO9ZzpPHwH5UjwWtNY6t3utBUfP2T/C9eba6KmqR0yNrgRqV9MwrcN9qwlAMdcD
         qyqMrDoX0ltcZ/BIJwmWIT+XhYLzb7pUbH85mF1MBUYEaNAvm8XM3okjuRk+lq6iY4j3
         Ct3Eo0Uh4lahEst31bXU6pDS1iUREGLgTSeB6+hhhS+rDCaGWf+bUvZRYCcNNo31Fv12
         rVM2J3SivcXokLFoJmAYLgkjTmQFlHBMG3/1MSU3sGa/USzYnqEmwAgESEKHxRhfQsHB
         R54Q==
X-Gm-Message-State: AO0yUKXz03cmqTWfO2DlE28QXKPaXH8G6EsRJr0PRIooWy3+wFbq/WAT
        IdQZBvAJ65+hmhZYHEsIyAEx5/thuHcQ9qvIZJ4=
X-Google-Smtp-Source: AK7set8gB8ipd68JLwsURelWnisDctocf4ifPIoe4V5L3QIv8pb2MuwTQ+uayazzdcPmRQMYchuLq4vZeh+mkJRIeJo=
X-Received: by 2002:a05:6214:1869:b0:56e:a27d:8d22 with SMTP id
 eh9-20020a056214186900b0056ea27d8d22mr341979qvb.3.1677745073497; Thu, 02 Mar
 2023 00:17:53 -0800 (PST)
MIME-Version: 1.0
References: <CAPagGtuJQO5dj=qd96kWFWLfcX8Pt0m9B9J8xiFGPNUfEnPLkA@mail.gmail.com>
 <20230301094206.6a624a51@kernel.org>
In-Reply-To: <20230301094206.6a624a51@kernel.org>
From:   ismail bouzaiene <ismailbouzaiene@gmail.com>
Date:   Thu, 2 Mar 2023 09:17:42 +0100
Message-ID: <CAPagGtvcLF2mdodsnBrmZfjaHCoFwwdsVOs2QEM9AYkxM_4JOw@mail.gmail.com>
Subject: Re: [PATCH] net : fix adding same ip rule multiple times
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        "edumazet@google.com" <edumazet@google.com>, pabeni@redhat.com,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thank you for pointing that out , it is my first attempt to suggest a
patch so I was not sure about the how to.

I will check the links you provided and use the correct method.

Best Regards

Le mer. 1 mars 2023 =C3=A0 18:42, Jakub Kicinski <kuba@kernel.org> a =C3=A9=
crit :
>
> On Wed, 1 Mar 2023 14:50:15 +0100 ismail bouzaiene wrote:
> > Hello,
> >
> > In case we try to add the same ip rule multiple times, the kernel will
> > reject the addition using the call rule_exits().
>
> This is not the correct way of posting a patch, please take a look at
> this (second result on Google BTW):
>
> http://nickdesaulniers.github.io/blog/2017/05/16/submitting-your-first-pa=
tch-to-the-linux-kernel-and-responding-to-feedback/
>
> Please also read:
>
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> and
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
