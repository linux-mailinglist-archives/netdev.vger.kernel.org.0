Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2045C4F6D96
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbiDFV7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiDFV7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:59:39 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5165798
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:57:41 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id v13so595863qkv.3
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 14:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rU3HELUX1XIytnmJX3ImprHYMsSbQFe5QXWr9mWpDno=;
        b=gqSaIZ6PbdRaDdsgcUaKEm4bAh0znrnMb0xSRY8tLLEoZys8+3TpztKS9SLxOEwEwf
         rxuQJbK6+WYzU486JcgzpTMVJlG0tJR4rKgb8wm70JlQfHu+50wpC4DixvUqlZdXp9M1
         SOiFBIaHLXHYJL6GBIZVbMAU4bu533ieqLFeL0GrGE4aOyWOhLHDJ7sgVqN4GQLes6Go
         DQxgHpJrQrLDIP+ijEZwnFJ68EPz59uz0l8LZwb4aJKZsa3jEF0+MWR82r+V2zSRBxIH
         zMPvNAEM0IVAlsd66H8KYQMpsVnUg7MkqKsEeEv965c7kTobzs4FcefoV8NCaGS4Zh25
         x4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rU3HELUX1XIytnmJX3ImprHYMsSbQFe5QXWr9mWpDno=;
        b=KZLtMw5xwNTaZENAHA6P2JcxUg/CSruHoi0/KvL7KqHz6sFINyqkwA70LEIx0Yq83M
         ua6L7VXl4W8W2O1dKP6NmXEHE6rWBUe3H6qEZfb6R6GrEZm1QwcK3Z8U8ZfeFRTDb2iS
         0hXbc1LAxMHVTtRM0+UlRDExEy0AprJ/lGarqCsWnwDD32o3GAdGVgB4OFD/NElPuZZT
         ouwj3ho+1Xd3AYIITJ2XRbMj9Mdz41K5QfOX2ZY8bT522psaVGHRO1mEO19FOaQ7Jn63
         hBXb6/UWocPfbBtbWsob4VHP/fQ11dJBthN472n+E1dxVCDCntZDkNrsIau4flWQDNUS
         jnGA==
X-Gm-Message-State: AOAM531ssnBor0M4L/t2pM8MA/7Or2rZnDo8GHf+v87/vyADQX4qgVNv
        hWYoOfOnkVfUfGCfbAZQGFe+7jsn6Qw=
X-Google-Smtp-Source: ABdhPJxwgHx1w9JJUaPNous2jkFGOQ0/EMgirVQCxTWX7zzVjdQU120GydHQtBV8FiUVhb9Xx4VA2g==
X-Received: by 2002:a37:c15:0:b0:67e:37f2:e691 with SMTP id 21-20020a370c15000000b0067e37f2e691mr7242563qkm.722.1649282260804;
        Wed, 06 Apr 2022 14:57:40 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id s16-20020ac85cd0000000b002e1ed82f1e5sm15711580qta.75.2022.04.06.14.57.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 14:57:40 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2eba37104a2so42739327b3.0
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 14:57:39 -0700 (PDT)
X-Received: by 2002:a81:b04a:0:b0:2eb:6919:f27 with SMTP id
 x10-20020a81b04a000000b002eb69190f27mr9061866ywk.54.1649282259237; Wed, 06
 Apr 2022 14:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
 <20220406192956.3291614-2-vladimir.oltean@nxp.com> <CA+FuTSdK4T7DBf9wi3GjXA6P9o+6X-7c5vh9V0BN40GwbKSeGw@mail.gmail.com>
 <20220406194711.3apwre6dbzbtw3ou@skbuf>
In-Reply-To: <20220406194711.3apwre6dbzbtw3ou@skbuf>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Apr 2022 17:57:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTScA5=kkgZ2MfbzFpxKtkVdkZe_9Vmz1innHf+co7hJTAQ@mail.gmail.com>
Message-ID: <CA+FuTScA5=kkgZ2MfbzFpxKtkVdkZe_9Vmz1innHf+co7hJTAQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 1/2] ipv6: add missing tx timestamping on IPPROTO_RAW
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 5:15 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Wed, Apr 06, 2022 at 03:45:14PM -0400, Willem de Bruijn wrote:
> > On Wed, Apr 6, 2022 at 3:30 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > [ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]
> > >
> > > Raw sockets support tx timestamping, but one case is missing.
> > >
> > > IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
> > > has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
> > > not. Add it.
> > >
> > > Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > For 4.14.y cherry-pick:
> >
> > Acked-by: Willem de Bruijn <willemb@google.com>
>
> Thanks.
>
> > Might be good to point out that this is not only a clean cherry-pick
> > of the one-line patch, but has to include part of commit a818f75e311c
> > ("net: ipv6: Hook into time based transmission") to plumb the
> > sockcm_cookie. The rest of that patch is not a candidate for stable,
> > so LGTM.
>
> Point out how?

In this case I did, so we're good. In general, perhaps it's fine to
add such comments below the original Signed-off-by/Acked-by/.. block?
Not sure what the common approach is, if any.
