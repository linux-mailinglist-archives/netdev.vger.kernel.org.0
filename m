Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA532EC535
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhAFUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727049AbhAFUkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:40:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609965529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WykEemMsSiBCYaO/Puc+Apjx+xtTM6cWf49K8KW8Nsw=;
        b=diIrrW0XQFmNWInsVP2Yc1HLxFCBt+IFAfMBTnFJByZV3FMEqr1t+iFSBJNikhUyOQsYo7
        z8/wEoeWFpqSUL8YZSVMKlsksHS6S46hlzWKpoGpBZdmLfzOa5J6uQfYiicDQPU6a/mXuO
        mzOron3OuAOk4AYyrDCTKtpDOaZ/z6A=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-wCqu3R-JN6mFnsVFFtiyZw-1; Wed, 06 Jan 2021 15:38:48 -0500
X-MC-Unique: wCqu3R-JN6mFnsVFFtiyZw-1
Received: by mail-pl1-f197.google.com with SMTP id b2so2338509pls.18
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 12:38:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WykEemMsSiBCYaO/Puc+Apjx+xtTM6cWf49K8KW8Nsw=;
        b=ShoodiIjsLcjavrk1sBVk07qPspqpdqTzoTS6NWN71SsilFpcNk+h3BDik/kNeKK/Q
         pkvem9OQgcEl3uGcsdSnOGJCi0TqLZ+Mc9eyAuYm6E3qvg2OIAAYGbXwf9/Ahi8DpI2N
         OvC1InL4ftl1lJDWNFAaUFiOlBiu1PkCoqDiCCEf1twtL99v7y4uzQFMGuzcOMzVaAcP
         h35xnLZtqSDLbAcButh54pzEMrz91cJNscFIs6Z7MvO7wPmXux+kBrPpIhUZLT3UZxI7
         +dFiP26ok56F546C00nIC3oFfWU1Lp2w1ajwSgOUbQ4B3nylbKD4aJgIdPTu48qPfJgn
         9qtQ==
X-Gm-Message-State: AOAM531wD4eEKnhROtD82ECW9OmaduzgbwC0ng3h5lH8jPtnCX5OzEXh
        cem0i+IhKsNRdkxsLeVzr0aJNqUE8VUXxK0lBp9WbkbSeaOzJQG9kjNlBzY8PTO38JZ7MYqSaVx
        of3IvMT8YQBH6kiyi
X-Received: by 2002:a17:90b:305:: with SMTP id ay5mr6093113pjb.4.1609965527158;
        Wed, 06 Jan 2021 12:38:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMvigwcpzJfhK+u159EzK0eYZNgQ355e+zBsR/dUdJ872UCYZ4ZRGxD85J8aMtpauw6Cpqzg==
X-Received: by 2002:a17:90b:305:: with SMTP id ay5mr6093099pjb.4.1609965526941;
        Wed, 06 Jan 2021 12:38:46 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id h17sm3261485pfo.220.2021.01.06.12.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 12:38:46 -0800 (PST)
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in
 rxrpc_read()
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <f02bdada-355c-97cd-bc32-f84516ddd93f@redhat.com>
 <548097.1609952225@warthog.procyon.org.uk>
 <c2cc898d-171a-25da-c565-48f57d407777@redhat.com>
 <20201229173916.1459499-1-trix@redhat.com>
 <259549.1609764646@warthog.procyon.org.uk>
 <675150.1609954812@warthog.procyon.org.uk>
 <697467.1609962267@warthog.procyon.org.uk>
From:   Tom Rix <trix@redhat.com>
Message-ID: <07564e3e-35d4-c5d4-fc1a-8a0e8659604e@redhat.com>
Date:   Wed, 6 Jan 2021 12:38:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <697467.1609962267@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/6/21 11:44 AM, David Howells wrote:
> Tom Rix <trix@redhat.com> wrote:
>
>> These two loops iterate over the same data, i believe returning here is all
>> that is needed.
> But if the first loop is made to support a new type, but the second loop is
> missed, it will then likely oops.  Besides, the compiler should optimise both
> paths together.

You are right, I was only considering the existing cases.

Tom

> David
>

