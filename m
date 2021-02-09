Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C964D31462F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBICXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhBICXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:23:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B512BC061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 18:23:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b9so28811912ejy.12
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 18:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=94mftjIXUXpBGTzkXEut57NZO5dD9+ouWagMUcYq4T4=;
        b=SLSlfarox3w4/TQGho7hXHqSoG58gpoXK2cGVVcgl4Fuf/28mrLEx3jE86PZROBdvi
         jaOlj+yxmTKmDEOypCrrj577HA4KZBTpjjullrCcLxhuLU7cgs5H9MGuQCbHU09x7syb
         vvycvT+Szw3yWHgUsLgb3cTOrCZ9Cb1k7UMxXnA6Z3zCnKLYUosQYsWyk2ha1FKSoyYj
         4C5S86cL/h6aT2LA4wW1yRhxghMB72OaMeNUPpKjJPM8PuVU0QZj+/CS8yM68aKnvWHE
         UL/f+mY5Z0eU4uWRw5rhHps7ZIXl0r71V3Ebz44mo5wboy1gkxgitNB5tYvGF3t+qN3Q
         vmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94mftjIXUXpBGTzkXEut57NZO5dD9+ouWagMUcYq4T4=;
        b=A4p9xkf9nu7zLR6SAgtuR/EtWLTyJh4QmV8JFXMMmX2uhDlOFG1kokINHqR3v34pvk
         D9tvj0rOlzzXcBGvPQ92qxh7yuVgg6jFN6JCy+YTDbUgvk+H4Y0hvIfw3rqDK5QFjQ0n
         /OPVUHvZPZZcqhJZQpbLpxMf+bF95pN65zvrquYe50TD47bZ5Szj4iQY4C/mQssd0vk/
         TUlmROeq88oeXBGCuS13Eqm9dRqYftDX19QPRtRUhZ8pwWGiPVLAfkD1AUlit0YNMdrn
         RDVHEZqrA9qxJAm7CBSkmM4nA36FQmY5zWAX+5HYlncmBAtxda3Zji6vcCYp+DieMSEh
         /Ppw==
X-Gm-Message-State: AOAM533OcTo55mfUiJIw0lUhgISY0AAFoNXDTdK23S5vXLBqhtHoVvn+
        dbfsXEsEAML+VLZX06+LtkeeuTdVooWi56jXs1g=
X-Google-Smtp-Source: ABdhPJxQjbWNK4aidD+ZDHvvygfVH69T0+nRghKydruWSEWoCn+/58Wj1GUB3Qbefx94jcng1zE5uXaXcSRaO4283zE=
X-Received: by 2002:a17:907:767c:: with SMTP id kk28mr19424013ejc.98.1612837379530;
 Mon, 08 Feb 2021 18:22:59 -0800 (PST)
MIME-Version: 1.0
References: <20210208175820.5690-1-ap420073@gmail.com> <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
 <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com> <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com>
In-Reply-To: <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 11:22:48 +0900
Message-ID: <CAMArcTVRXR5MGEUqGbwvOG2o4ZpzE_-w0ctvfy04Q+rHD140=w@mail.gmail.com>
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 11:18, David Ahern <dsahern@gmail.com> wrote:
>
> On 2/8/21 7:05 PM, Taehee Yoo wrote:
> > Thanks, I understand why the arrays have been using.
> > I will send a v2 patch, which contains only the necessary changes.
>
> please send v2 as a patch series and not 8 individual patches + cover
> letter.
>

Okay, I will do that.

Thanks,
Taehee Yoo

> Thanks,
