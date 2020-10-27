Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273D929ACED
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900529AbgJ0NOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:14:09 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:45723 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900513AbgJ0NOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 09:14:07 -0400
Received: by mail-ej1-f67.google.com with SMTP id dt13so2122901ejb.12;
        Tue, 27 Oct 2020 06:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tXCh10L6SQ/i1jAypyelKxw6+jw7G2ndnRAA6TkZnhQ=;
        b=bbdR283hpRGZjvgIPzlZojPzICFZFefNUuU5ZTlnsljeK+GFNOK7wCkzS+drlzHePv
         g+hz5vMd0UqX5sfyP/Ykd2OekHy/yUcHcugq1BA0hVTv3fuiYpDof8I2xYYV2fL59aPD
         Vr9fXAW/9YJSSBYiRN3cgyG0FapXrD+codJhGe8srHeEQXSJNxhT17h2wVqEDJpxDwHB
         xD7q/2ySeRc0dA1BYSA8Xyg7PwQgKLUKyzZF+I0hC7HjGnxa9prORGUnCdUkEM7UXFPo
         CQHANjdy6ZIQyBS8syaW7BOYCa1fU1lazGllPME/IPJ4IftHghTSqnUQelV3djkEoPCB
         ybTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tXCh10L6SQ/i1jAypyelKxw6+jw7G2ndnRAA6TkZnhQ=;
        b=FA1JgR/NCfji4bCrgmMpWBCVf2e6WRwymjTpwtoFjVcPHosuDgGdSWH5lpl2Am6mmp
         ODk6Y8OUDNsz4WED2B4/WMikwbQ3KOFvQrh0BTnOoUHqQttKuwUqpoQU/1KqGZnLoSh3
         jC+FJUgBk6b/I2G0D35bdU/U976lCexuPrVuqYccy6fCQ4v1jlt/XZqr+K1RyvvS6fle
         qeMXK8lqV2HOQEm+LqCRkzwcjutWwqM/RiBnTxqZS0667SHj+a65BE2gF/pIxPpLqSRr
         t2coUoNd+46R3UkllzK+inoKauz2MvNZk8gEASXYnKo1AopbOzp+RDdQWwIWcm3nfWPB
         qDHw==
X-Gm-Message-State: AOAM530Q+lnAGsPAe1dhU8ijYeAItM3n9pD/xDMy9EZRzssRPTQFfq5Z
        97E0Zz7te++r1Y7F6PzAw40mRb426lmEOYVHvjU=
X-Google-Smtp-Source: ABdhPJxcm0RqztaYgbxFJmGIMA54GBLWoYl6lPTvCEjRgI13WS0Rexa+oJAp1pAe9g59yXpGqTrGVZ4eNr5FNBvZb1c=
X-Received: by 2002:a17:907:204c:: with SMTP id pg12mr2239886ejb.464.1603804444784;
 Tue, 27 Oct 2020 06:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
 <20201026150851.528148-3-aleksandrnogikh@gmail.com> <CA+FuTSeR5n4xSpzMxAYX=kyy0aJYz52FVR=EjqK8_-LVqcqpXA@mail.gmail.com>
 <CANp29Y7WOFZ-YWV84BucHvFRg628He+NDsGqCZfdsn_crwVW2A@mail.gmail.com>
In-Reply-To: <CANp29Y7WOFZ-YWV84BucHvFRg628He+NDsGqCZfdsn_crwVW2A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Oct 2020 09:13:29 -0400
Message-ID: <CAF=yD-+izgrvj2diXK9=mztq+z0Gb8eVJYB78zUyP5U_WsMY4A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] net: add kcov handle to skb extensions
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 8:31 AM Aleksandr Nogikh <nogikh@google.com> wrote:
>
> On Mon, Oct 26, 2020 at 7:57 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> [...]
> > If the handle does not need to be set if zero, why then set it if the
> > skb has extensions?
>
> The point of that condition is to avoid unnecessary allocations of skb ex=
tension
> objects. At the same time, one would expect skb_get_kcov_handle to return=
 the
> latest value that was set via skb_set_kcov_handle. So if a buffer already=
 has a
> non-zero kcov_handle and skb_set_kcov_handle is called to set it to zero,=
 it
> should be set to zero.

I see. I thought it was some best effort approach: if there happens to
be space, use it, but don't allocate. Which I did not understand.
Could you rephrase the comment to make more clear that this is about
clearing a possibly previously set value.


> > skb_ext_add and skb_ext_find are not defined unless CONFIG_SKB_EXTENSIO=
NS.
> >
> > Perhaps CONFIG_KCOV should be made to select that?
>
> Yes, thank you for pointing it out. I=E2=80=99ll fix it in the next versi=
on.
