Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC7C50E79A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbiDYR7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiDYR7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:59:09 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2737221E11
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 10:56:04 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id v2so4196600qto.6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9AprGNfd3CvvgyyCMDEqKnXuLtvajkiKghGw4Z+xUJM=;
        b=TJVSWo37TXdK0yt14mHFsa09gbEqMQHz88JNJ7n7i5YlcJKeTrqNdGxannnCndWs0K
         68A3k7lpABLns1GF3xtrxqa7qtAgY1nccTBcuAoVvViHAJl6+u2sW2wzLx7gchILQMTn
         bZByKd4Qde3fqXiS0iBlyssObPzchBZpQZCAkmBndDbcsxhzBb8VvQ/AO2mq80k7fzA9
         ST9PamUQbKRIrmiX+UmyB3eJ9Xi52QRRrztyn5JIH1GbqnhTNwK73cbyjy21DhAOGoa9
         qrakKMiQLRsIl0rloqms3TH+pFeI6jksnt9esZj/whFY81WJHcN6SaboWXx2oRt8Shqg
         FN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9AprGNfd3CvvgyyCMDEqKnXuLtvajkiKghGw4Z+xUJM=;
        b=OaI35JZTrXjzg6l75Q0/5UBHQ5wTWtk2DMSG3UppH1zFRPG4R5Q0/xiv5ww0sZs1Tu
         3LhAwgjKg3Smx2HYSKwYN5Jq6yiQYFZR/xlWVkhVdsbWJcunMXcc2nBNvSGylcldozz1
         h+6MYvAiZYX2+fNxzweWZRO8zpq8qjOEJuMMHYBtwPak/kSDfzTitXKl8i6ynjbNP86w
         O7w0lfeYH+pfIMjLUfp68i01CSLA69WjCPQQdLxn0dhwB5XQHk3Rw252FttCI/VOY7dI
         xjYM+IV4sINFWd+GpLeYLASAAUSaYgsyMEo10GGnJqyBIqeewlOURetTMeed8ut8l1n8
         AdZg==
X-Gm-Message-State: AOAM5301aVgtacK3NyFActGRnz0DLKy/ogbiZz/fUvmOhkucrLs7EaiB
        rnDvA+MO0W4tLjx705ENvOoqOAqkknM6YG9Q3zQ23A==
X-Google-Smtp-Source: ABdhPJyzL90ItqUYyaZOt93uaYxReQVj4pfA2w3tm7EXrOQl1I6uYK45yPjEhP8v5aLp/7cEWvjndiehIAt27yJxOag=
X-Received: by 2002:a05:622a:647:b0:2f3:6348:3105 with SMTP id
 a7-20020a05622a064700b002f363483105mr7237082qtb.429.1650909363326; Mon, 25
 Apr 2022 10:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com> <CANn89iKM-f=VLfwb9wq8+_bmaLjP_Xg5CanqJWhans2DXE=v5w@mail.gmail.com>
In-Reply-To: <CANn89iKM-f=VLfwb9wq8+_bmaLjP_Xg5CanqJWhans2DXE=v5w@mail.gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Mon, 25 Apr 2022 10:55:52 -0700
Message-ID: <CA+HUmGj_rM43PTpz3nsn8=8r7vR1jcKB2_CMJBHejM7T-3S_xw@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp: md5: incorrect tcp_header_len for incoming connections
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 12:37 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Wait a minute.
>
> Are you sure treq->af_specific is initialized at this point ?
>
> I should have tested this one liner patch really :/
>
> I think that for syncookies, treq->af_specific is not initialized,
> because we do not go through
> tcp_conn_request() helper, but instead use cookie_tcp_reqsk_alloc()
>
> Before your patch treq->af_specific was only used during SYNACK
> generation, which does not happen in syncookie more while receiving
> the third packet.
>
> I will test something like this patch. We could move the init after
> cookie_tcp_reqsk_alloc() has been called, but I prefer using the same
> construct than tcp_conn_request()
>

Thanks for fixing this Eric. I had not considered syncookies.

Francesco
