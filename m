Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30B92BBF2C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgKUNYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 08:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgKUNYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 08:24:12 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA70C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 05:24:11 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id m16so6602677vsl.8
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 05:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQenOEPvudXiTP590FQZFveKk8gAJ+gA7H54pS4S7Iw=;
        b=jke1Sx0mQtRGzAJpenqJfRPiUTvadnOB6vZD1ehmz/VV/f7eYbQXmNfJ3FRqk04J36
         by/Sa+4kwCBnb+ITsLBVhDB6ITaFexFiFXVSJURjjpnLhHphf/RHIWQ2qrcCl9ezB/yk
         n8I+WQ25pJmugWbVZLwPm/RukieNTP0J2NoIimIF/XTct97BpPn3zNxQlkNYbgAH5uBZ
         7AEDFH7RWQ0fmQOMTHBzMfo3wGKnfczSBLm9yfjXkM3FmqFrYVhAUnnRX0aATtC4MiCw
         K+7UiRGIUFUnVG92JfJTfvr6oj7txWAJ/GqNG65xP76vGf+yaQAmExqFRojUS7rlDj73
         tJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQenOEPvudXiTP590FQZFveKk8gAJ+gA7H54pS4S7Iw=;
        b=cWRC925n/Cs4moQJgzq0/FUOor9mOuOyJXd1hv/gRIAUIyTKzWNnFJEUH3d2TI9+/W
         K2I2uLLmF7AMwv+YT6dZc1WQPAYMEA8nFAULy4rxGpTgAZyBTMzE900sOyUcbxIFlXKC
         DCYmbKtUUTLwLXUaR0cVxLxxuKAPr1PvTe+e0o1iS1cQ2ltapq5DLYOwyrHTFp7SrmFO
         4kxuo87c6fq+zyGMeopn0HVKeMXKreMXSiFFaSo0LKYpVUsPCp/qqrX0s9DNDDoEIijS
         SO74CVilFf8Ax6UVTFK8s5Cxr5t2mFSqXU/2XCtS+mEdDTKz3EHYywIVLq28kd6yX5Zn
         wD2Q==
X-Gm-Message-State: AOAM530S30uTbGsrSptT0pLj3n129dFLXdz2YXO5jYsqrWJ3E7jYGCCQ
        czq45EwpUUmDXbDHDcDsSl2+3UfoRY4=
X-Google-Smtp-Source: ABdhPJxk1Ohg+MyNjzZKD6U6dsHkBNsyCDT0GdJP53S7lsxSH46pkXKZJrMp0MZwR/tV2f10DMpjjg==
X-Received: by 2002:a67:68c6:: with SMTP id d189mr16665266vsc.10.1605965049004;
        Sat, 21 Nov 2020 05:24:09 -0800 (PST)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id 22sm638414uak.8.2020.11.21.05.24.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 05:24:08 -0800 (PST)
Received: by mail-vs1-f42.google.com with SMTP id x11so6604116vsx.12
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 05:24:07 -0800 (PST)
X-Received: by 2002:a67:ed4b:: with SMTP id m11mr14808682vsp.14.1605965047278;
 Sat, 21 Nov 2020 05:24:07 -0800 (PST)
MIME-Version: 1.0
References: <20201121062817.3178900-1-eyal.birger@gmail.com> <CAHmME9rYRrWOs247vFJX-MAY+Zn3yUudOxVhqL13mWp8E+i0-A@mail.gmail.com>
In-Reply-To: <CAHmME9rYRrWOs247vFJX-MAY+Zn3yUudOxVhqL13mWp8E+i0-A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 21 Nov 2020 08:23:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfcHW=+8=okyU9XuM7=pRnKjjqHdS0q_5ybP7xAUNXHQA@mail.gmail.com>
Message-ID: <CA+FuTSfcHW=+8=okyU9XuM7=pRnKjjqHdS0q_5ybP7xAUNXHQA@mail.gmail.com>
Subject: Re: [net,v2] net/packet: fix packet receive on L3 devices without
 visible hard header
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 2:56 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On 11/21/20, Eyal Birger <eyal.birger@gmail.com> wrote:
> > In the patchset merged by commit b9fcf0a0d826
> > ("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
> > did not have header_ops were given one for the purpose of protocol parsing
> > on af_packet transmit path.
> >
> > That change made af_packet receive path regard these devices as having a
> > visible L3 header and therefore aligned incoming skb->data to point to the
> > skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
> > reset their mac_header prior to ingress and therefore their incoming
> > packets became malformed.
> >
> > Ideally these devices would reset their mac headers, or af_packet would be
> > able to rely on dev->hard_header_len being 0 for such cases, but it seems
> > this is not the case.
> >
> > Fix by changing af_packet RX ll visibility criteria to include the
> > existence of a '.create()' header operation, which is used when creating
> > a device hard header - via dev_hard_header() - by upper layers, and does
> > not exist in these L3 devices.
> >
> > As this predicate may be useful in other situations, add it as a common
> > dev_has_header() helper in netdevice.h.
> >
> > Fixes: b9fcf0a0d826 ("Merge branch
> > 'support-AF_PACKET-for-layer-3-devices'")
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Willem de Bruijn <willemb@google.com>
