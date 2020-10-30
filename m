Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7B2A1000
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgJ3VMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgJ3VMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:12:31 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C22C0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 14:12:06 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id n189so1755628vkb.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 14:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQLa8LWKxC3lcbV7jooXmpqWy2UXhLg78ZfSY/NE6+M=;
        b=AD04DIVv6qIel8GigG+5QDWAwqdbuOtVEEFYN2UYKFuPirirrVEL9AwF4QPd5S6DzY
         Q08Cu5fIp6UemLRDkGiJpZteNE90JlmoEMTrYYbYtHXtwzr6K2c/tGqYEJRkdoZzfv5W
         wNszxx4MI3QWKcMIAlh7Y4CYCLgT/FPJgnEju3bqstolw6WSTPPxUFvY0N8S5bXDUxQo
         +wakTLT6GwgdwBA3SdxYphcl1jaiq3JL58zXbXh2u2tjfOZEXwu8YAEzHXouUhlI4Pi5
         r2qDcXD38PE0X70ESOIZ1C6iMmg0ve2ZqXtteXfB3cx84N1Ds/TlNWJFlNor2fh3RNBl
         5e1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQLa8LWKxC3lcbV7jooXmpqWy2UXhLg78ZfSY/NE6+M=;
        b=AcFYL/zBHmn2sEtwVivuGbOCA1L94aCgI2zs/HqiHmc0kQkWHfrpLa+lxqUXjR3F/g
         gU1aCXXM94E/H6ffJeRgL1RRZOc2DdZVf7HYhWx7rzO9UR9DZhEntQiFWCQSgYSdCEn4
         +pePqP/NOCLElwCM4dXFt7++yJ15+2fjVEVYBwykExPpCIkim1Py5w+gqGH+0dcOSYsU
         rMGkR44jux/D6TdYlzJJTvuyvDu9G+lf0xJzknUiwgNfNZQHWhqUhy7qOJa28QjOwzDD
         T0AN+0fNqCBprZcFEmJSQK2n8MzwpO0amlwk7ESUqXHHBED6euwKbl3ZsG3BUjEdpzc9
         D4JQ==
X-Gm-Message-State: AOAM5314nd79iAJOTXTWnrJIsNc/D1bWk0mq84LrRniiIsvQzuzJTN9u
        YApbhdZ+Au2D9Pt+MN8GgXXDh+Tww5Q=
X-Google-Smtp-Source: ABdhPJytQii4NT15CU7KVDL18umnsOFtOed0JdLtpCQ2vsxjPsMztsYSE5+0qbyCeE4m48KR5H501Q==
X-Received: by 2002:a1f:3042:: with SMTP id w63mr8563692vkw.11.1604092324453;
        Fri, 30 Oct 2020 14:12:04 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id 105sm784888uat.18.2020.10.30.14.12.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 14:12:03 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id x11so2157464uav.1
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 14:12:03 -0700 (PDT)
X-Received: by 2002:ab0:5447:: with SMTP id o7mr3339080uaa.37.1604092322543;
 Fri, 30 Oct 2020 14:12:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-2-xie.he.0141@gmail.com> <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
 <CAJht_EMdbGQdXhYJ7xa_R-j-73fbsEjSUeavov40W52aGvQ21g@mail.gmail.com>
In-Reply-To: <CAJht_EMdbGQdXhYJ7xa_R-j-73fbsEjSUeavov40W52aGvQ21g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 17:11:24 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfD27KDkbnO=PeS0Dhn7s3+0U1N+e_Xrn7G9m0qT2Lcrg@mail.gmail.com>
Message-ID: <CA+FuTSfD27KDkbnO=PeS0Dhn7s3+0U1N+e_Xrn7G9m0qT2Lcrg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 4:02 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 9:35 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > In general we try to avoid changing counter behavior like that, as
> > existing users
> > may depend on current behavior, e.g., in dashboards or automated monitoring.
> >
> > I don't know how realistic that is in this specific case, no strong
> > objections. Use
> > good judgment.
>
> Originally this function only increases stats.rx_dropped only when
> there's a memory squeeze. I don't know the specification for the
> meaning of stats.rx_dropped, but as I understand it indicates a frame
> is dropped. This is why I wanted to increase it whenever we drop a
> frame.

Jakub recently made stats behavior less ambiguous, in commit
0db0c34cfbc9 ("net: tighten the definition of interface statistics").

That said, it's not entirely clear whether rx_dropped would be allowed
to include rx_errors.

My hunch is that it shouldn't. A quick scan of devices did quickly
show at least one example where it does: macvlan. But I expect that to
be an outlier.

> Originally this function drops a frame silently if the PVC virtual
> device that corresponds to the DLCI number and the protocol type
> doesn't exist. I think we may at least need some way to note this.
> Originally this function drops a frame with a kernel info message
> printed if the protocol type is not supported. I think this is a bad
> way because if the other end continuously sends us a lot of frames
> with unsupported protocol types, our kernel message log will be
> overwhelmed.
>
> I don't know how important it is to keep backwards compatibility. I
> usually don't consider this too much. But I can drop this change if we
> really want to keep the counter behavior unchanged. I think changing
> it is better if we don't consider backwards compatibility.

Please do always consider backward compatibility. In this case, I
don't think that the behavioral change is needed for the core of the
patch (changing control flow).
