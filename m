Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7F5A5B90
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiH3GMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiH3GMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:12:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A65FB776E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 23:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661839921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwbS+lwtuZwsu6TG+VqXf8rOZlkuDfcVcPpWtB3vevo=;
        b=f/EbowKuRtQ38C/K9DBj1QZua6OwVI2bzWZr8ns1TQPAuQ6lhs9gvF+uTyh8N9UQG9uuwT
        jLu5/uiw5lSpgye6gJ3FblMDCLJXcI7tAZWml5bcMr3iEdEm3M4tF2K4iLIX+vY9tKqB2y
        4qfepCV0twZlER2DNffdmtNs53bfkkQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-7kGfckHZPdCxGHMvNlICJw-1; Tue, 30 Aug 2022 02:11:50 -0400
X-MC-Unique: 7kGfckHZPdCxGHMvNlICJw-1
Received: by mail-qt1-f198.google.com with SMTP id y12-20020ac8708c000000b00342f1bb8428so8016627qto.5
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 23:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=xwbS+lwtuZwsu6TG+VqXf8rOZlkuDfcVcPpWtB3vevo=;
        b=06HcXe5AjGZ6pzfZT/OVfX9HwUpCaH+1g2/NbbJc+eYvFGZdak/6LAHAYwslTmS8D1
         dtAkPvcfkW2fB3ZtzVwVhUa6qNURtip5tV6R960vBlaDWmZRkK9OUJLtFLlpJZfbs1Co
         akQEfNegFime/Ks2SWsDRIRHtJDI8suuzEj7irxtBN62cQ30dCbw4/WDO/xCpsSB4fQZ
         U6QB5aTHDdZt0xLVr7s48TeA5J0s5GBfVIZbtp/pODCPSowhEXW/Zmo1BEc4uqS6vKtg
         7EGmtt8+enHHqgg8yFICpAEJfubuXpVaBVjyYAeZqUqf9ga5MXTZT10Hk8bSZ8wtKq5P
         Ferw==
X-Gm-Message-State: ACgBeo0nchOzA+MX0RXfS4+BTDvgARASv2jXj54dR/VlnU68IKTNkV+V
        xYDq14Dh6oZQUGxjigbmxgb56i3q72Z3xXhzP6mci+AoflC7IWHw1UNdQue09xVhLuCCTQXOjfV
        OB1CL2r0aPV6kyYpRNdsEd+0iVA9Wbu0P
X-Received: by 2002:a05:622a:18e:b0:342:f7a9:a133 with SMTP id s14-20020a05622a018e00b00342f7a9a133mr13547470qtw.402.1661839910000;
        Mon, 29 Aug 2022 23:11:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5jyUNy6WzF1a6pFgV1vGVp67dzg51Cc7sFGUauK+y7WjCmpWMNa+cS8OGbv96t7fw9W4NwjzQzab1SsoLQp/c=
X-Received: by 2002:a05:622a:18e:b0:342:f7a9:a133 with SMTP id
 s14-20020a05622a018e00b00342f7a9a133mr13547458qtw.402.1661839909752; Mon, 29
 Aug 2022 23:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220819082001.15439-1-ihuguet@redhat.com> <20220825090242.12848-1-ihuguet@redhat.com>
 <20220825090242.12848-3-ihuguet@redhat.com> <20220825183229.447ee747@kernel.org>
 <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
 <20220826162731.5c153f7e@kernel.org> <CACT4ouegMFu7OZ9MQehYXH002P_Hz4OKfuObCzZ6pFOTGPUAsQ@mail.gmail.com>
 <20220829172853.6717774a@kernel.org>
In-Reply-To: <20220829172853.6717774a@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 30 Aug 2022 08:11:39 +0200
Message-ID: <CACT4oudqukscdA4=y6MxGOacJ7TJ8ZVu6DEDW2MLeL8o1g+0qA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 2:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 29 Aug 2022 09:03:44 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > > We usually defer refactoring for coding style issues until someone
> > > is otherwise touching the code, so surrounding code doing something
> > > against the guidance may be misleading.
> >
> > Yes but I'm not sure what I should do in this case... all other
> > efx_filter_xxx functions are in filter.h, so putting this one in a
> > different place could make it difficult to understand how the files
> > are organized. Should I put the declaration in the header (without
> > `inline`) and the definition in a new filter.c file? Should I move all
> > other definitions to this new file?
>
> Hm, I see, perhaps adding a new filter.c would be too much for your set.
> Let's leave the definition in the header then.
>
> > Also, what's exactly the rule, apart from not using `inline`, to avoid
> > doing the same thing again: to avoid function definitions directly in
> > header files?
>
> Not sure I'm parsing the question right, but it's okay to add small
> functions in local headers. Here it seem to have only been used in
> one place, and I didn't see the context.
>

I expresed it terribly badly, but you parsed it right. Thanks, now I
understand what your concern was.

--=20
=C3=8D=C3=B1igo Huguet

