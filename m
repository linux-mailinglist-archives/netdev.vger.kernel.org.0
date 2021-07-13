Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A258E3C6A66
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 08:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhGMGXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 02:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229798AbhGMGXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 02:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626157227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4nsKDY6NNQsjKT8elVvpHdt/irXtZ9RqD2SnFvWtPo=;
        b=K2XIb4hwrQxyITQMNdnEhhhVO48OnGWG/+7aACwB+55Do9r0uCrnnpBsN5t1kiuzUhw3T2
        A/5a6xXvDQK7wxfYLAt9sKCBAVtazGstbAezQCJHpNFSDULtVngXDQ5UbOMWNavSSPhKPj
        y+nGouwCjYrhKGyHlS1y/bTPkrLdL6A=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-mki7YO_hObu_WYP8j5_alw-1; Tue, 13 Jul 2021 02:20:26 -0400
X-MC-Unique: mki7YO_hObu_WYP8j5_alw-1
Received: by mail-il1-f199.google.com with SMTP id v6-20020a927a060000b0290205af2e2342so10108410ilc.15
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 23:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E4nsKDY6NNQsjKT8elVvpHdt/irXtZ9RqD2SnFvWtPo=;
        b=SIa6OrL8uWXN3BYbgUV5JtxSq4J9M4uWOsaguuO6a7IhAaHwP03UrOabSb14vdO6UJ
         ymygxzg3PdJO5k7L0R/vb9iT60VOPnbD2jfjbH4oh+QsglaTXyOB0rDGlBvoNMOuvVhi
         Bv/IodsedtM1lShysv9rzh/t7m9RkBKSWM9jSICte2ob22MxbR/lbd1CB9LnylcIEZNg
         0W+nSlpA/QIvtR5dxyDnThnIjk45B/A++M05kJ3TWu5KIrMLUA7upRjw65PXu7761mB0
         kz3uEG6iliKa3B3KAQqFa5VZMCkuF1nFyeiRDqqq291gV2NYr6i1topDlA/waPw9sTn0
         gtDg==
X-Gm-Message-State: AOAM531ZAqIbfP6XsYdqOX4kgNBAoiWztsjtQUKIiUh9KzJSOc9MjvcZ
        hMWPuhdL+lk48964UfGHrkQHryIdgRZpDpBNa3Y0PscQvE1XgF8dLLxZcnYajKZXttlUn+RVEzb
        POnc7XGp5DXgXcxPqGvI5rSwiB9wSewLL
X-Received: by 2002:a05:6e02:921:: with SMTP id o1mr1914744ilt.57.1626157225651;
        Mon, 12 Jul 2021 23:20:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3kiD/a8JM5nHkDEQo+XiTaFj9b0wO1WbJI0xT5YFJRKB3iin18hAgPlrOEwutplukAALDfhQsu6lIqe4FFAw=
X-Received: by 2002:a05:6e02:921:: with SMTP id o1mr1914729ilt.57.1626157225469;
 Mon, 12 Jul 2021 23:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210707081642.95365-1-ihuguet@redhat.com> <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
 <20210707130140.rgbbhvboozzvfoe3@gmail.com> <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
 <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com> <4189ac6d-94c9-5818-ae9b-ef22dfbdeb27@redhat.com>
 <CACT4ouf-0AVHvwyPMGN9q-C70Sjm-PFqBnAz7L4rJGKcsVeYXA@mail.gmail.com> <681117f7-113b-512d-08c4-0ca7f25a687e@gmail.com>
In-Reply-To: <681117f7-113b-512d-08c4-0ca7f25a687e@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 13 Jul 2021 08:20:14 +0200
Message-ID: <CACT4oufpg0RkY3yk1Cs4z=OmK8JjSevAF6=YD02RTyFS+qLcZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev queues"
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesper Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 4:53 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
> I think the proper solution to this is to get this policy decision out
>  of the kernel, and make the allocation of queues be under the control
>  of userspace.  I recall some discussion a couple of years ago about
>  "making queues a first-class citizen" for the sake of AF_XDP; this
>  seems to be part and parcel of that.
> But I don't know what such an interface would/should look like.

I absolutely agree, or at least standardize it for all drivers via XDP
APIs. Let's see if any good ideas arise in netdevconf.

Anyway, meanwhile we should do something to have it working.
--=20
=C3=8D=C3=B1igo Huguet

