Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C102B687A79
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjBBKnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjBBKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:43:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D65889A3
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 02:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675334553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ho+ccJtLtBpITLkLYhs6bIYgWBkO7LdUscEjHhHLUMw=;
        b=VGKgzpvYiPhgitq7QFuIDWeWTUxM4hSM5lXHTWeE7EHmVpwt9kdUSck/Nzq0rjPMa+R64I
        1/BEd31epJg0F0wxjYErcUss2oFnkk+gQ32xkTGV2LH5iZx5oYObzUQNuEY00B1xqo/M8g
        6fF043DCO31bncIpwOWITOw4jLYbTVk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-WbtAKN45NviOHLEG87s0ng-1; Thu, 02 Feb 2023 05:42:32 -0500
X-MC-Unique: WbtAKN45NviOHLEG87s0ng-1
Received: by mail-qt1-f199.google.com with SMTP id i5-20020ac813c5000000b003b86b748aadso737314qtj.14
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 02:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ho+ccJtLtBpITLkLYhs6bIYgWBkO7LdUscEjHhHLUMw=;
        b=D08nIeSssckrM2Ww0vT9li0S/ybMeByZwgVvUvKJLxhDd+0nqvRDe6XQCaR5Gll7kX
         ozSIDgpPBqiC497aWLwF5qI/bO/+3Hs53Gnq3ExtOxGr+Ws9+sJJWpG1jZyKd0RTupu+
         XGkxeFk1Ddh0difwRXimnMxNQNmXBz+y/9W7p/Yyw0J2DPDSd3iYvnxrTiHoferXDHHS
         U/CLDbg4CfU/Cg1G4/5rMSE28knpOdIsG/xS4H+KhR+hOPmnbHFgkQ5OABIBQfqFw1Ui
         4QpyoiCt6AfiqZENx5ek3IMb3Yb4Qu2ot/HvMZ1lRN20EFJsa1oMgpO+VeLMdYrQI2N7
         XnAg==
X-Gm-Message-State: AO0yUKURYXEIsV0u/rKGfkZTlAVxKjetDzLLB+WRYoFWY60TZxnf1wi1
        pN8dM2IG3fTATiHQqGgAMTKI0bE6pnNp8KR8LidL5yScGuuKrBsOJlridfNj/kcG0DW0swS7WAI
        kOMKfvkf8ZQGsyXoo
X-Received: by 2002:a05:622a:17c4:b0:3b8:5199:f841 with SMTP id u4-20020a05622a17c400b003b85199f841mr10073745qtk.0.1675334551792;
        Thu, 02 Feb 2023 02:42:31 -0800 (PST)
X-Google-Smtp-Source: AK7set9l9YbYKqY1fhf6MsOWze02notkxE8uOqZ+/rtvlhTb1RriumkksBnO6Q76zJf7Wp/YB33EhA==
X-Received: by 2002:a05:622a:17c4:b0:3b8:5199:f841 with SMTP id u4-20020a05622a17c400b003b85199f841mr10073723qtk.0.1675334551459;
        Thu, 02 Feb 2023 02:42:31 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id jt9-20020a05622aa00900b003b80fdaa14dsm13565916qtb.73.2023.02.02.02.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:42:30 -0800 (PST)
Message-ID: <9f37bea4eeb6340f5c20e74d134033d037fe969f.camel@redhat.com>
Subject: Re: [PATCH net-next 11/13] rxrpc: Show consumed and freed packets
 as non-dropped in dropwatch
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 02 Feb 2023 11:42:28 +0100
In-Reply-To: <20230131171227.3912130-12-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
         <20230131171227.3912130-12-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-31 at 17:12 +0000, David Howells wrote:
> Set a reason when freeing a packet that has been consumed such that
> dropwatch doesn't complain that it has been dropped.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> ---
>  net/rxrpc/skbuff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
> index ebe0c75e7b07..944320e65ea8 100644
> --- a/net/rxrpc/skbuff.c
> +++ b/net/rxrpc/skbuff.c
> @@ -63,7 +63,7 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb=
_trace why)
>  	if (skb) {
>  		int n =3D atomic_dec_return(select_skb_count(skb));
>  		trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
> -		kfree_skb(skb);
> +		kfree_skb_reason(skb, SKB_CONSUMED);

Just for the records, and not intending blocking this series, IMHO:

		consume_skb(skb);=20

would probably be more straight-forward/clear.

Cheers,

Paolo

