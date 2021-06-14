Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFA3A7120
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhFNVWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbhFNVWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 17:22:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4EC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 14:20:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso608759pjx.1
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 14:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqRik6GMecrGZ7x1dcTGaPfCfWVDcGihJNswj8MbwNs=;
        b=NaTBqEV9d8lx4Ao5AuhOGoYiVCLl9Ni9sQfIH9uOb64NavBexsf1fQfdR8i6jzjlAD
         w2AsNQDpkAV/THzycGw9D1Yt+RhC/K4w0JHIrXLdUpwN/2ACKrwHVaN8NeQ1tDojpXQA
         iIPQpI19Gm5Vj9o0TeGwV/aV7UwqorWWpNjTx0igCzVj0PCLkPbgMsbH7ItK069BjBFD
         BfHB9j+JWz4WWHej2PC7B0QrTJdPvCiosf1RxdJqqDBssJSSdEcX9AwPjpPDnE+EAVbF
         l/FsTDiiYxmA3BRxgCGP9eJCZDTh2YAO9wp9zTPMBui7LT3gwI7MVTzOdoIBl9duyNuR
         Be6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqRik6GMecrGZ7x1dcTGaPfCfWVDcGihJNswj8MbwNs=;
        b=aZ4gDYUrT5hlDSy5dfkSgk8d8PBPQ7I2DCp+y3LgO72zo2YDSdf5dAMG057Zp9lEDy
         tEJC25GiUme+yp0TLmdYI95UtAwuB5gWmugyTktvO1WbH3cCKP6WagmNa4AtP9wiwSG9
         aMVdgFjiFqnp9Qdi4+IpgAAf3QIHXs49/QXBJIfqrzHpID9ZiLpxU0Ag52lrJaN+hYlf
         kC4syLnR/Y+bWnXx2x+EjAiXL496CwlxksTnD4dLViuE68CQoQeODJTifhne/Dm2Oqh2
         QO5phv3JwZKt0bdN3/ptZmQ8mimXQ6XAvtjb9g9Ojk1bPG/k2vIDuVNfX1AvZLWJ4Fn9
         3oBw==
X-Gm-Message-State: AOAM530DrllStJUSN7Gh9cgcM9TVFsEvoGYqPgKL1+zXVcqvu26eBqjM
        Hn36hr0OPyDhgaIk7NmzOM5wJA==
X-Google-Smtp-Source: ABdhPJzXoGw/g2m4d+5pn+DXX5WWyFZWRO3nWGRYO6e22EosU1JXo+poddzh1o/L0yiZ0M+3aR4Lgg==
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr1163709pjp.1.1623705637868;
        Mon, 14 Jun 2021 14:20:37 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id d8sm13722490pfq.198.2021.06.14.14.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:20:37 -0700 (PDT)
Date:   Mon, 14 Jun 2021 14:20:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Scott Fields <slfields66@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: "ip addr show" returns interface names that won't work with "ip
 addr show dev <ifname>"
Message-ID: <20210614142029.56ad4421@hermes.local>
In-Reply-To: <B4F46201-5CB4-416A-928C-13F885727CFD@gmail.com>
References: <4DC83BAC-29D0-404E-8EA7-74B2BD80446C@gmail.com>
        <B4F46201-5CB4-416A-928C-13F885727CFD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 14:52:50 -0500
Scott Fields <slfields66@gmail.com> wrote:

> Has this been received? I=E2=80=99ve not seen any response.
>=20
> > On Jun 11, 2021, at 5:27 AM, Scott Fields <slfields66@gmail.com> wrote:
> >=20
> > =E2=80=9Cip addr show=E2=80=9D will return a list of devices that may n=
ot work with =E2=80=9Cip addr show dev <ifname>=E2=80=9D.
> >=20
> > If you have list vlan device, it will return it as =E2=80=9C<vlan ifnam=
e>@<parent ifname>=E2=80=9D.
> >=20
> > However, =E2=80=9Cip addr show dev <ifname>=E2=80=9D will not work with=
 that name.
> >=20
> > =E2=80=9Cip addr show dev <ifname>=E2=80=9D should work with interface =
names that =E2=80=9Cip addr show=E2=80=9D returns. =20
>=20

The % syntax is how ip commands show the link field of the device.
It has been that way since the initial versions of iproute2 back in 2.4 Lin=
ux kernel.
So it is a historical behavior that won't change.
