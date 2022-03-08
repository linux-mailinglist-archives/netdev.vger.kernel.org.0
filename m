Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF074D19CC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiCHN6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241473AbiCHN6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:58:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FF7017E2C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646747875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puhfoSE9GokKycjZoGZRRrkAs3Q39LvHcB/FyPzQkB0=;
        b=X5XbWQknGMhKBpqdiO23EKof4nMJUiMJPgmTeSj6mOiJ2z/HsLn0XvnY62Q6BGlzzncBNS
        fTXkFD3VJ6GWhpgp/hOcr+je9CM9MaIvlFAvhoBN3xsw1UtaPo/XRM2H2uCiPw3c8yeTkI
        kE3U2XzT/ZJFREAf9TQHGjff3qaMvpw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-eu0Dvp7VN9SWUtiX1jsurA-1; Tue, 08 Mar 2022 08:57:53 -0500
X-MC-Unique: eu0Dvp7VN9SWUtiX1jsurA-1
Received: by mail-ej1-f70.google.com with SMTP id hr26-20020a1709073f9a00b006d6d1ee8cf8so8643501ejc.19
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:57:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=puhfoSE9GokKycjZoGZRRrkAs3Q39LvHcB/FyPzQkB0=;
        b=0g1/1OnhZT62eF0LLFiCCl4/aepFm9NmkPK9BJ1i/WFHxLQ4IXF0jAzwY33bA9JhOX
         OS3lgsQ8RQAHrrjbVXMEioecakXiOiVXGe7XlyNrUN1Kch7067T+GAssD2Z14E81aD0/
         sOt9rsGqYpWYV+5BtvT/WVvVLvaPJzn67XsO0TYERqpRN136n6rwER3JLBv4sYGolAJJ
         1DIzSljRgmWHbw0OKtYWRmNR+5ZWVp7hKPwHN0BdfPvVc+YEW2Ey5hDYeHbZLonLrCvN
         LIY7R0woGembl6kvhwSrA5VSZvnTGGeIsX5fn/5+lNHIW0YqNT7j/nGAPv+VqXYzKQSa
         hFXw==
X-Gm-Message-State: AOAM531A6tFqXTukPy5ywwiAJ0WCwt6v4lYuyx7WZxQGfox3t086S7JF
        Rv5lM38jdwLNHoQYeFWBAII0bV3Da0lKQDGd9RcU+HovfCh1NMjkgTn87VsuWK6s+HyVsemhddN
        zZq9D+TdwoSSSiBkw
X-Received: by 2002:a17:906:c114:b0:6d8:cfd4:f746 with SMTP id do20-20020a170906c11400b006d8cfd4f746mr13550447ejc.538.1646747872516;
        Tue, 08 Mar 2022 05:57:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJe3Rg3v7QWxF3G1uJRx0mUn3IH6nShKbIYqTNJGsXEOGTwKIFBHdJu6cpd+vd922clncKrg==
X-Received: by 2002:a17:906:c114:b0:6d8:cfd4:f746 with SMTP id do20-20020a170906c11400b006d8cfd4f746mr13550423ejc.538.1646747872166;
        Tue, 08 Mar 2022 05:57:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gz20-20020a170907a05400b006d91b214235sm5913737ejc.185.2022.03.08.05.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:57:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 137691928B6; Tue,  8 Mar 2022 14:57:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, dsahern@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
In-Reply-To: <20220308004421.237826-1-kuba@kernel.org>
References: <20220308004421.237826-1-kuba@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Mar 2022 14:57:51 +0100
Message-ID: <87cziwy2ao.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> We have a number of cases where function returns drop/no drop
> decision as a boolean. Now that we want to report the reason
> code as well we have to pass extra output arguments.
>
> We can make the reason code evaluate correctly as bool.
>
> I believe we're good to reorder the reasons as they are
> reported to user space as strings.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: use Eric's suggestion for the name, indeed better than mine
> ---
>  include/linux/skbuff.h |  1 +
>  include/net/tcp.h      | 21 +++++++++++----------
>  net/ipv4/tcp.c         | 21 +++++++++------------
>  net/ipv4/tcp_ipv4.c    | 12 +++++++-----
>  net/ipv6/tcp_ipv6.c    | 11 +++++++----
>  5 files changed, 35 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 34f572271c0c..26538ceb4b01 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -314,6 +314,7 @@ struct sk_buff;
>   * used to translate the reason to string.
>   */
>  enum skb_drop_reason {
> +	SKB_NOT_DROPPED_YET = 0,

Haha, nice! Even feels like this is touching on some deep philosophical
truth about the state of packets - the best they can hope for is to be
not dropped... yet! :D

-Toke

