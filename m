Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2128F2AF85B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKKSnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 13:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgKKSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 13:43:45 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F513C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 10:43:45 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id r17so3208448ljg.5
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 10:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yGt8I2m2ygNLL0qwbfvzdXiNHQBYHzK8pjMEMnoC+xw=;
        b=CKTneloBsUOYraSb6MTO5b4j5ddzxVS6yRsBaKX02nCx1IN9PrhyeWo+iq54xTX/Ji
         EiJ2aWQCMwf4gncYD2uCOoL7sFPUpvFkD8Zbh9p9/a3nofPlyaGfvILUHnaRXp8Yolp1
         x5sQoZUSrGGR5UcUQjAJhY4iNeGuQcOgoHz3xi7Ked0Q24BgplKl3ql9QJGSNytUYccd
         u2s1al5t8ZkFYPIJUPbTcQahwK7rK+hqrduYlV+O3YtCnNWBuXhk1umHCWEAVfx38tSO
         gqC58eyuoWBqsXUR06JyAvTefG9N8w/+OyrYE4vehngAEBckUBmMRh+CPTQtImN7r38i
         VqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yGt8I2m2ygNLL0qwbfvzdXiNHQBYHzK8pjMEMnoC+xw=;
        b=Es2K+X21tdYzINLAMmSowsrlFJ5Kpe/BzTlkCXzk07snL63i1Brn+UIVQ0Apz7mfUM
         6eOMz/1iwOnjOHPsDoVrz8C668666MrBnBjnI4qFRx/gNi86e63zYxc+wCDlCq0XTRLU
         SwE2oGlsIiFDzAF0F9IgtUgfIxb5mXXNQTX3mIhQm+/BZOEVHpvxlwo+UY1v+ql7rtLa
         1hm+ROSoz3QvaLMeMlTMjE/i5WXGtWhV4VtF9N09B6lOXa3G66Ucpb/MuITfNfCOtFZs
         kT6Br+12iZCaipnp67Q0jZjgrVNd01HWPeQ9Zedd+jedfN9W0EI7hrW9QghVcZRVjm5R
         ExGA==
X-Gm-Message-State: AOAM533gnVm51KQpu41lXjbNgG+Bzc6G2Ez4iJ6XHC6IpLDvh3HihUYw
        vSIXmT2AvxqRagovFjtBwHFcbsvKadWjnTdzXtvmgXfbEa0Mrw==
X-Google-Smtp-Source: ABdhPJyb8A75UhZV6+3QMkTyRQ8xvNHjBLpeIVSZQncNIYeTggdDUSEPI6oBLnhe+JhANGd/rBUBOEAliPYawEAiC0c=
X-Received: by 2002:a2e:8008:: with SMTP id j8mr6486237ljg.452.1605120223935;
 Wed, 11 Nov 2020 10:43:43 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
In-Reply-To: <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 11 Nov 2020 15:43:32 -0300
Message-ID: <CAOMZO5DmDXWkG8snXpsjKPKdecZQESMB1cKdwW5hZ4bqDv_dSw@mail.gmail.com>
Subject: Re: Fwd: net: fec: rx descriptor ring out of order
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kegl Rohit <keglrohit@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Nov 11, 2020 at 2:52 PM David Laight <David.Laight@aculab.com> wrote:

> I've seen a 'fec' ethernet block in a freescale DSP.
> IIRC it is a fairly simple block - won't be doing out-of-order writes.
>
> The imx6q seems to be arm based.

This is correct.

> I'm guessing that means it doesn't do cache coherency for ethernet dma
> accesses.
> That (more or less) means the rings need to be mapped uncached.
> Any attempt to just flush/invalidate the cache lines is doomed.

This is the driver: drivers/net/ethernet/freescale/fec_main.c
