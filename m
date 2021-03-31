Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCFE3500FD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhCaNK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbhCaNKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:10:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF02C061574;
        Wed, 31 Mar 2021 06:10:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so30020598ejc.4;
        Wed, 31 Mar 2021 06:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:date:references
         :to:in-reply-to:message-id;
        bh=NK4vUHta/woqJAuJAeHWHekKytBeMpGPEWYPmmzlnLM=;
        b=MKxrilH2QI84hoQaekvmb/yVWVOy4ktRSVpOfhG9jllSIWd/5Xed45+KHUI9vaNff0
         Zf5yDjPLg+XZ9bY0r73RV5DYPBadM3UeVTkKjQSXJ5RhPE2b7qjF4e4En6pTUNeEKidF
         ojOiVs6JyB8YjMlcUl+DqoIHgW+FDFrnzWn2BkGEAxXhrkOG3Ru9kgzAwkyNkJTPqfJj
         iGjLR9d38sK4OJnqwHGKQmzasLqCMJ1AWjvwoKaCtXZda38DbBgoL4EaWRa7nLNbKR0u
         61uesxeQXhBRjSGj2dILFxQc7yqE7+8e230oubmQzremIHcUJe1WCJyl99y++N68Begf
         lJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:date:references:to:in-reply-to:message-id;
        bh=NK4vUHta/woqJAuJAeHWHekKytBeMpGPEWYPmmzlnLM=;
        b=qql0uSiuLlG2bkKFkTiCWTLjhDYzE+rzqf8kZlRVtOugc4R5rArff4ap11akpXrrCm
         5yKl+vQUHYhLx+Tu7wMXVwd+laYeO2M+TUs4OwM3U4wFbqlMGXl100Udgy5+1nr7Bhf3
         g1XJHh+DpG5tcOAXJrxZSCcs/dpHP/o26SMyDvvJ9q2eQ4/lyLWO3RPmt/jf0nz9j0c6
         32NkzY1k/W+RXKyT4aQW7i74w1J9NO66beKEdUDtDAuLBo3tMUBnDf9vZBKqcPK5K5rg
         1lT4VzgxrJjkWT5I+X7+zDMOldp6Y7+Fel8Srj0U9EdjubmWBBUy7Xb/MZYvvLnyS0Zd
         7asg==
X-Gm-Message-State: AOAM5331Pigg9MAwhCqi2gjNlna/57ax3yOd0TpdMftUtJaqVX2+8rC2
        NPVIwrkqKicgMJpxhJjeTSg=
X-Google-Smtp-Source: ABdhPJzEdySfRZdS8SPzH5NG64YArEhPYkWmMZY0hKz8okszlIVGXInzcsAyIPq7l+zj5tiLp+jS2g==
X-Received: by 2002:a17:906:c45a:: with SMTP id ck26mr3366433ejb.125.1617196204316;
        Wed, 31 Mar 2021 06:10:04 -0700 (PDT)
Received: from ?IPv6:2a02:908:2612:d580:b423:5e79:2bd2:4a95? ([2a02:908:2612:d580:b423:5e79:2bd2:4a95])
        by smtp.googlemail.com with ESMTPSA id x1sm1200207eji.8.2021.03.31.06.10.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Mar 2021 06:10:03 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
Date:   Wed, 31 Mar 2021 15:10:01 +0200
References: <20210325195614.800687-1-norman_maurer@apple.com>
 <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
 <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
 <2e667826f183fbef101a62f0ad8ccb4ed253cb75.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        davem@davemloft.net
In-Reply-To: <2e667826f183fbef101a62f0ad8ccb4ed253cb75.camel@redhat.com>
Message-Id: <71BBD1B0-FA0A-493D-A1D2-40E7304B0A35@googlemail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Friendly ping=E2=80=A6=20

As this missing change was most likely an oversight in the original =
commit I do think it should go into 5.12 and subsequently stable as =
well. That=E2=80=99s also the reason why I didn=E2=80=99t send a v2 and =
changed the commit message / subject for the patch. For me it clearly is =
a bug and not a new feature.


Thanks
Norman


> On 26. Mar 2021, at 13:22, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Fri, 2021-03-26 at 11:22 +0100, Norman Maurer wrote:
>> On 26. Mar 2021, at 10:36, Paolo Abeni <pabeni@redhat.com> wrote:
>>> One thing you can do to simplifies the maintainer's life, would be =
post
>>> a v2 with the correct tag (and ev. obsolete this patch in =
patchwork).
>>=20
>> I am quite new to contribute patches to the kernel so I am not sure
>> how I would =E2=80=9Cobsolete=E2=80=9D this patch and make a v2. If =
you can give me
>> some pointers I am happy to do so.
>=20
> Well, I actually gave you a bad advice about fiddling with patchwork.
>=20
> The autoritative documentation:
>=20
> Documentation/networking/netdev-FAQ.rst
>=20
> (inside the kernel tree) suggests to avoid it.
>=20
> Just posting a v2 will suffice.
>=20
> Thanks!
>=20
> Paolo
>=20

