Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E65285DA
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243919AbiEPNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243924AbiEPNsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:48:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76B263A1AE
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652708911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57nX9+DJ9pzSNXCPQNiWdem4yYDcaqqFG+T6NzTRiRA=;
        b=goJD5L8FiM3FH+N1Ox1ZvwePZbPomof+x0LyWXz5jV0utOUQNXYctkwqqd43BQd7GmZtSV
        fdGWisWGoDcIpqIH9n+Tom6PWoP8E3jT/zBaNxlBuUGHnndhdB1tXHsNxRDxHjljPWLIcJ
        2wfMzzk/GUKGEUmeIfJilbTa7nzh+ss=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-Mm6RIcBOMI2JmtV4KlM0gA-1; Mon, 16 May 2022 09:48:30 -0400
X-MC-Unique: Mm6RIcBOMI2JmtV4KlM0gA-1
Received: by mail-wm1-f70.google.com with SMTP id u3-20020a05600c210300b0039430c7665eso5682301wml.2
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=57nX9+DJ9pzSNXCPQNiWdem4yYDcaqqFG+T6NzTRiRA=;
        b=bPtFBOuE304AIlIMtSvHrBog+qgy2vy2liCtg0+BW2Tm3japw/qFZ2CHzNDroSdScP
         lt2SMs13bBjMSxnWp+W8t8JZf+AIaJgraXzYOS+R6m8b5gdBoXOJ6ac+Pg197B5EhLYT
         zNYbFiYp4gQKYn33YqWKrB8bXmyVGRR/flCHkwPSAn5uC6Flz177PZZT5imUQJuKzIcG
         QapMg0lMI9BF5kYzCjOO1n6x7xeTIxEkw5UHVq3p8h2VC8T2rfc3Fz0RM19JCtG9ckyP
         fYPbkxciaiBmvPAshoB7jETA512mw9UAwXQYYJD/sD7a7oDRPz+KAwVdeaiA+2icHhiL
         Rutg==
X-Gm-Message-State: AOAM532dmOno7FxUpaeou3wDIZ6PLtwTnocz0lsoXAIG70pCxU+lJIu+
        sPR5dLFz4TDmE3w9xtLQ//YwuhjkS4MV1pMYGG06KIV7H3oRJUykw5WZVPkWgcevRH1WhlsuGRb
        Zoz/1oPf8bDVSNanC
X-Received: by 2002:a05:6000:1acd:b0:20c:811c:9f39 with SMTP id i13-20020a0560001acd00b0020c811c9f39mr14229569wry.482.1652708908811;
        Mon, 16 May 2022 06:48:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1N1IEJUolePSGBxQndOqX6hnOE8gJUzm1/HRPtQ5QyKNbO3nFvdniXioWurU3ZWSvtucx9g==
X-Received: by 2002:a05:6000:1acd:b0:20c:811c:9f39 with SMTP id i13-20020a0560001acd00b0020c811c9f39mr14229543wry.482.1652708908577;
        Mon, 16 May 2022 06:48:28 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id k20-20020a7bc414000000b003942a244ee9sm10144614wmi.46.2022.05.16.06.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:48:28 -0700 (PDT)
Message-ID: <b9025eb4d8a1efefbcd04013cbe8e55e98ef66e1.camel@redhat.com>
Subject: Re: [PATCH net-next v3 00/10] UDP/IPv6 refactoring
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 May 2022 15:48:27 +0200
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
> Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
> cleaner than it was before and the series also removes a bunch of instructions
> and other overhead from the hot path positively affecting performance.
> 
> Testing over dummy netdev with 16 byte packets yields 2240481 tx/s,
> comparing to 2203417 tx/s previously, which is around +1.6%

I personally feel that some patches in this series have a relevant
chance of introducing functional regressions and e.g. syzbot will not
help to catch them. That risk is IMHO relevant considered that the
performance gain here looks quite limited.

There are a few individual changes that IMHO looks like nice cleanup
e.g. patch 5, 6, 8, 9 and possibly even patch 1.

I suggest to reduce the patchset scope to them.

Thanks!

Paolo

