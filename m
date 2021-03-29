Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0F34D74B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhC2SeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhC2Sdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 14:33:40 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992E8C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:33:40 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id f9so13965230oiw.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 11:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QxUQo31YTZeeVvAPrn05EARkA5FRNjiZo6F8lja/ALc=;
        b=LZLYq3Oox3HLdrjf/8WOgJCN1tZ/FRIsk7Iqu+uJVxOk72+RCMVD+imrpeNpd4ym6G
         5+DYg0L1PHizc8G72cXXlcUTP6JeQ2S4jZ5i/lmz4PkaPu3YU6B0qFZJxLBg+vCMOuF3
         fGKBq0fHkQKka4T4DFSNJXvwTDDNG+RvpZ6EvBa67d7UIOsd32puw4qyQ0Wev58qIx3U
         km74JK158iRI+j0Mi1CICfapSHt1MhwBf77l7Rz8Z+MwkU3wJQTu7yJDR0vdS+obbBLk
         OkXg+QMYxHgbEtw/PzUYoh88HPjyKXSxN47or+YodHUukmUsEaukFmIP7OD9q7mRlOL3
         y4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QxUQo31YTZeeVvAPrn05EARkA5FRNjiZo6F8lja/ALc=;
        b=Bhjp90iftwyE2kD63nt1WaGkn2sAdfo/vfWqePLw0CGumLrIWH1GfQJw0e+ZKG78Wo
         L+gVq6CSfLU0IQ53H5GQaDNxcwXPpDi9DEYlNVaD6ZOlcTpRbv3mHVJELd5UzeIqZV1c
         RCtsvnaOXm6csduISfTfQ3YWqd3OAzPyUS3UhLSEqlN8bEUiaSnA47a/Ndygf4ysu8lZ
         54LDw5DeJimW22Ry/eA2FNUPbHs1g/wOVSR70b8szyggR92cMz88pxL+ZpgS4/MN2nnN
         9APSISxi9c9fXo811DXoFx7P+j4At7IzlTxIFbq3G9iSB8Z6f1CysOpHMjpFYgkzDKyO
         7e6A==
X-Gm-Message-State: AOAM532hvdER/ToYE8tKHMB02hHGsdX7FXQRFBA3Mu+CqlJb6GJd9ycc
        L/ebGfBr1rV1LzBxRE/vfy4=
X-Google-Smtp-Source: ABdhPJyjbduAVzlQlnikIk+EBYkOVmbPInN7Zve/Y3w76gCjR7WDXw8RrFkLibwZTIcegt2QsMrHaQ==
X-Received: by 2002:a05:6808:904:: with SMTP id w4mr322720oih.1.1617042820130;
        Mon, 29 Mar 2021 11:33:40 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id z3sm1355605oop.41.2021.03.29.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 11:33:39 -0700 (PDT)
Message-ID: <065c20b62c479ecd2a9d3bb7bf36de1ac8390a55.camel@gmail.com>
Subject: Re: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 29 Mar 2021 13:33:39 -0500
In-Reply-To: <CA+FuTSeBRCDcu7uKp9=7UZWR3zmSrk41ArqrseW9jHYgK+WPpg@mail.gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
         <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
         <CA+FuTSeBRCDcu7uKp9=7UZWR3zmSrk41ArqrseW9jHYgK+WPpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-03-28 at 13:00 -0400, Willem de Bruijn wrote:
> On Wed, Mar 24, 2021 at 2:20 PM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
> > 
> 
> > +       if (!ext_hdr || !iio)
> > +               goto send_mal_query;
> > +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio-
> > >extobj_hdr))
> > +               goto send_mal_query;
> > +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio-
> > >extobj_hdr);
> 
> As asked in v3: this can have negative overflow?

The line above checks that iio->extobj_hdr.length is greater than the
size of iio->extobj_hdr.

