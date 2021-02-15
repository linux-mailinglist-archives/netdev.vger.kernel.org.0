Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836C531C07C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 18:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBOR03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 12:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhBORYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 12:24:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFE9C061786;
        Mon, 15 Feb 2021 09:23:44 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c11so4542218pfp.10;
        Mon, 15 Feb 2021 09:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sLQol9oxPeOG1Kr+YSSO0W5V4v2gUOFh7QiJCDdWNqU=;
        b=PkxBFU5nVbo5oAYYa/lQpvEaEElCvLWhl43ILCDOizN0iRgnF7V6yqP6qzHIU6WwCo
         HW4tHjJF1xxu2ds31Pbjpj8r4MsTNwTEtlSRgxhJQreeLE3McunlDsmvy/FoGa42cGr8
         3wpDfMRo8hRMO2hEoD1r3EuWvn/FqeCaHahfd1TfnbQb/246+9jWL9AS886OLFia/OzI
         H51eHKJ0HBpSVqlXQdskpc6in/V9HpuqIbdqZe/xI9CamRfb0mZ8zOcD1LnrbFpholCp
         2cP9YhTwIDwzEdW7bGvqX2xG9zUXPlyNE6CV8TzI/2XyBn9aVntjE8bM48rB4ZsYXUxF
         xP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sLQol9oxPeOG1Kr+YSSO0W5V4v2gUOFh7QiJCDdWNqU=;
        b=UcyRoCvehsS3U/tsivFTm2l6eEabTyilmVvyjgpkV17kjQZ3rF4COPLfgW7dvvNxak
         xbcasdgRiSchFGKqKFQr0hnR3oKFl2qvh6GVFc5iNDi4Molb/TNvVUk/e5rGfsAlvjje
         xluQeeKHQyCcxUUssRhUNRaMPxN5MKAf1NqzAE9zsaKNObj6sZ57elrFkHeL8y5uhr2+
         nnklMFHIpb+P0WQhfIaNrSyixQadJ9p5hPAaQCGrUU1khQVyxqo6I37qgAmgEr3052Zk
         k3xPanvhCNp4zxN8/LA7/S4DHBiegns+6QRxs2e6xI4KTyVA+aCfFTjmBqXh4owpts4v
         Ds7Q==
X-Gm-Message-State: AOAM530tKC0ki2wK8OECh8IyJGnfclybBl5O94k19NnnphNcWIEVRzrw
        pciXqJZAI4irJ8AAPgfYxUbNyUw9ePIK++Z+uQ4=
X-Google-Smtp-Source: ABdhPJxMSxQgbZDj60ZX92Qj4c6eJW6AjebayDAVOr2OntGqTt+4gzqZzJwuYnqPvxV46243GSSB71IEf3cvjzqQ2Nc=
X-Received: by 2002:a63:7f09:: with SMTP id a9mr15435741pgd.63.1613409823721;
 Mon, 15 Feb 2021 09:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20210215072703.43952-1-xie.he.0141@gmail.com> <YCo96zjXHyvKpbUM@unreal>
In-Reply-To: <YCo96zjXHyvKpbUM@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 15 Feb 2021 09:23:32 -0800
Message-ID: <CAJht_EOQBDdwa0keS9XTKZgXE44_b5cHJt=fFaKy-wFDpe6iaw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v3] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 1:25 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> > +     /* When transmitting data:
> > +      * first we'll remove a pseudo header of 1 byte,
> > +      * then the LAPB module will prepend an LAPB header of at most 3 bytes.
> > +      */
> > +     dev->needed_headroom = 3 - 1;
>
> 3 - 1 = 2
>
> Thanks

Actually this is intentional. It makes the numbers more meaningful.

The compiler should automatically generate the "2" so there would be
no runtime penalty.
