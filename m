Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2584434A5B5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCZKiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhCZKib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:38:31 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A1C0613AA;
        Fri, 26 Mar 2021 03:38:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id bx7so5714201edb.12;
        Fri, 26 Mar 2021 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8XNBg7+3dkDlHPxMLn0P7+GP5Z2WC1cbwLitIQ3EtqU=;
        b=Bd5hUEXn53RDRe5d8mh+8zMoGFX7eeVg0QAFW0eFa7jfhfFvUi2q0bv78HAE4FJaIq
         sSeUZmMFGrn2G5ZGlILQ/KsHtV4coWFkfq7tc5WvGelCXPCqewejNcB2OdKd8B0eO0/K
         f1tiTgeXiiNaI6WIPxBHeKhdQU7FS24F0YAazmiE0PeoC9F1XgkoNcHnlFt+WLdo7ktu
         vqzjQqW8Jr5TnT+kZ4fx0+M4Fnwm3Bx00IbAW17Krr1l9f+uixpPDGnVigeSuGBzfyoh
         1vK0vFBN0lfBbR6FRe7n6RkX51uS9oYvC1/kPds3liJWXUGVjFiI/kWtoAjLXiP/B6vk
         9pow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8XNBg7+3dkDlHPxMLn0P7+GP5Z2WC1cbwLitIQ3EtqU=;
        b=mZNm6tmSFQvseYVM+VH/VETSwXAVyW5aXDqlKtfw90x4nZuhXjHir/gKxW1PEsJqi1
         cV0sDGZddURYGSP38auSzse9Y+O50N7gsbm0LHM0XW0MA9hd01gSbpe3wNKwhvEkUsPE
         +c9Awvyg9Ua5hLFen2EQoQm/gInPQ/qtIcnzFVaU2mslaoZpob8rAUUe+eaHnyrLVXlF
         0558b3IhE4TEfCQfl07zovRFbaNblnt7le1uCI5VekMjqBlxjyE5JPKnplj282RgFJsa
         icGWBFrZimkQTk0KmxispgqURt+mGZv/a80jq0iOpPe4wk8OYS//y8YXj+Edpup5Bs0a
         2U9g==
X-Gm-Message-State: AOAM530JmQX3SPHDxrD1LGJEisTsPpexwwZuC9kld67PB+6V/drF+BoQ
        EaRGWX9vx1IfcorePsSU2/kMwXCe/iMoYA==
X-Google-Smtp-Source: ABdhPJzo2gvHtBDFggeZsUxvuZKGfaWpTuWOcKpAb9G3ZZIe7eZlVzYhIcOh0RDFDnGQtX1E7KtF/Q==
X-Received: by 2002:a50:ec0e:: with SMTP id g14mr14347883edr.264.1616755109855;
        Fri, 26 Mar 2021 03:38:29 -0700 (PDT)
Received: from ?IPv6:2a02:908:2612:d580:4458:3fcb:72ab:e73e? ([2a02:908:2612:d580:4458:3fcb:72ab:e73e])
        by smtp.googlemail.com with ESMTPSA id r4sm3689107ejd.125.2021.03.26.03.38.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Mar 2021 03:38:29 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Norman Maurer <norman.maurer@googlemail.com>
In-Reply-To: <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
Date:   Fri, 26 Mar 2021 11:38:28 +0100
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC14C055-97AE-4A33-B39C-24944B02932F@googlemail.com>
References: <20210325195614.800687-1-norman_maurer@apple.com>
 <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On 26. Mar 2021, at 10:36, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> Hello,
>=20
> On Thu, 2021-03-25 at 20:56 +0100, Norman Maurer wrote:
>> From: Norman Maurer <norman_maurer@apple.com>
>>=20
>> Support for UDP_GRO was added in the past but the implementation for
>> getsockopt was missed which did lead to an error when we tried to
>> retrieve the setting for UDP_GRO. This patch adds the missing switch
>> case for UDP_GRO
>>=20
>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>> Signed-off-by: Norman Maurer <norman_maurer@apple.com>
>=20
> The patch LGTM, but please cc the blamed commit author in when you add
> a 'Fixes' tag (me in this case ;)

Noted for the next time=E2=80=A6=20

>=20
> Also please specify a target tree, either 'net' or 'net-next', in the
> patch subj. Being declared as a fix, this should target 'net'.
>=20

Ok noted

> One thing you can do to simplifies the maintainer's life, would be =
post
> a v2 with the correct tag (and ev. obsolete this patch in patchwork).

I am quite new to contribute patches to the kernel so I am not sure how =
I would =E2=80=9Cobsolete=E2=80=9D this patch and make a v2. If you can =
give me some pointers I am happy to do so.


>=20
> Side note: I personally think this is more a new feature (is adds
> getsockopt support for UDP_GRO) than a fix, so I would not have added
> the 'Fixes' tag and I would have targeted net-next, but it's just my
> opinion.

I see=E2=80=A6 For me it seemed more like a bug as I can=E2=80=99t think =
of a reason why only setsockopt should be supported for an option but =
not getsockopt. But it may be just my opinion :)

>=20
> Cheers,
>=20
> Paolo
>=20

Thanks
Norman=
