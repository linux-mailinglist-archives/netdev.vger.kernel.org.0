Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38AF28D1A6
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgJMP7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 11:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731302AbgJMP7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 11:59:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92168C0613D0;
        Tue, 13 Oct 2020 08:59:39 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q25so9170568ioh.4;
        Tue, 13 Oct 2020 08:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GoK/FN58ddEqFxJb9/v0ALx7V7xXFOJvLkZX3jWieiI=;
        b=oylhnEaPP6ek6HyznEVGBglU1X4AQm1C3CktWmZqvyVeaMi2GU7Ra/7wM5wnnjNnOl
         DeW8tV6roR/LEStCUbRSl+eMZwakc0VDzKzo19Tf1mUzRDAdYSpN0RCOsHm4IvyRXor5
         UcDbV5LR2wMOP0EPvob2ZbW5C3XVrhjqP3o7Wugusaf9+pT6geRMr3XYwn9FXvZJGIfK
         brnTkNrrg5BhAeLZTvVeWMqZQa0qczKvNC9bXVwnMd6I/VfVCN5NAB23Oq8np8hwaz+N
         K6qqPJhOiuauqNMmJlcmJ2/pyHFe8jEXI8PdhcF35zd9ggVIx9YciuaPan+8MdE2qnJQ
         4LnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GoK/FN58ddEqFxJb9/v0ALx7V7xXFOJvLkZX3jWieiI=;
        b=p1/vLZbxfuUk59c3J3EWwW/awMRtO9BoXKQIg4w81G/gD8gzZxYt3SUnSp7qPndk25
         uLFkkrtNdkdVJEfkxmzVvnIPGismlZJeQ1cUP1iTaeSjBLfSvw0dNlx3sbxIg5cWvyuu
         1d/d/qy4a63KTmC58J/Gt4jA26BwMUopcNUehXNNaPlRBbbL6SwRiNgMIiZwpAZbngZB
         K8IoEjc+mJSXRVyHDFQnmGkwZohPJQoMeIOa1lE+9ctH6uvvKMgxmVz6F7V90Lmp1YZW
         KkoxwmddWrIxzrCOAA+k+7r4XKpwsGCKNUii5I+c/XaJPXJt5UoKJdRLsREWMNwGucYB
         QKvQ==
X-Gm-Message-State: AOAM530vR7OppbCGSJ37e6z1kkA7T1J4a5/Nn5OrVlKeMPdjKJuwy23e
        qGEZaSAZigkfLRH7Gqr7NCu8Hi0juQTqaBAwgKc=
X-Google-Smtp-Source: ABdhPJzZha795qGjwavS+Zmii1KbnFD70ocwhqgxvRVr9dwy9BI+9WNCFg1FDRdptRVvAg+T8XTI6OVi6tIDsfr3kfE=
X-Received: by 2002:a05:6638:98:: with SMTP id v24mr524631jao.113.1602604778970;
 Tue, 13 Oct 2020 08:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <20201007101726.3149375-2-a.nogikh@gmail.com>
 <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
 <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
In-Reply-To: <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
Date:   Tue, 13 Oct 2020 18:59:28 +0300
Message-ID: <CADpXja8i4YPT=vcuCr412RYqRMjTOGuaMW2dyV0j7BtEwNBgFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Oct 10, 2020 at 5:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:
> > > On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
[...]
> > > > Could you use skb_extensions for this?
> > >
> > > Why? If for space, this is already under a non-production ifdef.
> >
> > I understand, but the skb_ext infra is there for uncommon use cases
> > like this one. Any particular reason you don't want to use it?
> > The slight LoC increase?
> >
> > Is there any precedent for adding the kcov field to other performance
> > critical structures?

It would be great to come to some conclusion on where exactly to store
kcov_handle. Technically, it is possible to use skb extensions for the
purpose, though it will indeed slightly increase the complexity.

Jakub, you think that kcov_handle should be added as an skb extension,
right?

Though I do not really object to moving the field, it still seems to
me that sk_buff itself is a better place. Right now skb extensions
store values that are local to specific protocols and that are only
meaningful in the context of these protocols (correct me if I'm
wrong). Although this patch only adds remote kcov coverage to the wifi
code, kcov_handle can be meaningful for other protocols as well - just
like the already existing sk_buff fields. So adding kcov_handle to skb
extensions will break this logical separation.

--
Best regards,
Aleksandr
