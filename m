Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF2433D90
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhJSRiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231226AbhJSRiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634664961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jc2BfaUWoqtDc9ItZrfxrQaVPoO7pD/AF6pbg1QoF/4=;
        b=MeBpQLohFuDs464u2I6geSNTIKX3wH996ChMIprkgXredBeYqDUcnM29v52tewEig0FpkF
        1nFxhGRYmccpwaAqphNNL2B0+l70fT9zYJ6KiUNjXK5e2Cs4Gza5E0GKJ9MBcaspTGwCoe
        aeJnCu3ET+syDzv5JQvkX+QZjyzfCas=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-r5e37_weNXCa6MOl4lAIuA-1; Tue, 19 Oct 2021 13:35:59 -0400
X-MC-Unique: r5e37_weNXCa6MOl4lAIuA-1
Received: by mail-ed1-f69.google.com with SMTP id a3-20020a50da43000000b003dca31dcfc2so1907683edk.14
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Jc2BfaUWoqtDc9ItZrfxrQaVPoO7pD/AF6pbg1QoF/4=;
        b=WdjdNspA5w1pXC3uhL4YV2wT+DvQgV9hvLrJJXEcOCmlVSEkz+8jNH0RrqoGig+O3z
         YzM5EldNq+un4Gz0OoFS1UCLfCbDQZkEFTaIjS27a56lLzxy328L1Q3KJ5ylgwQ3B8ET
         CoLUu/rz8oxy+LKeuSm2wUq4F8NEjXAKPQi22SToWkrwKFWaZEw9CLwOrcHHKkJcqfMv
         SC2lo0FnMPdU2m/2E0W/O2BQ1rocYKRMwLj1VELf7APuihPKmFC+8jsni3YJMp+yIm4P
         /O3+tEBYiu3XZ+rL5NMb8/CnnrUxGzKRrhyGppm12U9vc7pyPaI7v/r2+aeYoKco9hjk
         Wn6Q==
X-Gm-Message-State: AOAM531BJ0Wd+UtUpGDZUTXmdnfZeYqnGH9GEF4xJMZOBOhPa2e8lXMD
        cUUqCKn+jYvZ4LWm8og5/plMCAk+6uSKnxy0Mg533G9MckQxGD1vsBAIZj0t16jpzZ66zyxOrj2
        t4/FYntCpHug1GrLf
X-Received: by 2002:a17:906:1f95:: with SMTP id t21mr38996601ejr.234.1634664958636;
        Tue, 19 Oct 2021 10:35:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3AUDVf0RVyabhcgqw5Ai7j/Tk0sHUHevfAOzLXpiPs5E2XL8yMOe2L/ll1ROYRdmR3WAW7A==
X-Received: by 2002:a17:906:1f95:: with SMTP id t21mr38996570ejr.234.1634664958273;
        Tue, 19 Oct 2021 10:35:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v13sm10590387ejo.36.2021.10.19.10.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:35:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 19B2018025D; Tue, 19 Oct 2021 19:35:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] fq_codel: generalise ce_threshold marking for
 subset of traffic
In-Reply-To: <CANn89iKmR3XTjcHkpk=woDdED7YPi=8jNAOpKvvcjr9pY3bo0Q@mail.gmail.com>
References: <20211019171534.66628-1-toke@redhat.com>
 <CANn89iKmR3XTjcHkpk=woDdED7YPi=8jNAOpKvvcjr9pY3bo0Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Oct 2021 19:35:56 +0200
Message-ID: <87y26ogbnn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Tue, Oct 19, 2021 at 10:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
>> so it can be applied to a subset of the traffic, using the ECT(1) bit of
>> the ECN field as the classifier. However, hard-coding ECT(1) as the only
>> classifier for this feature seems limiting, so let's expand it to be more
>> general.
>>
>> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
>> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is appl=
ied
>> to the whole diffserv/ECN field in the IP header. This makes it possible=
 to
>> classify packets by any value in either the ECN field or the diffserv
>> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
>> INET_ECN_MASK corresponds to the functionality before this patch, and a
>> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
>> match against a diffserv code point.
>
> Please include what command line should be used once we get iproute2
> support.

Sure, will add that and send a v2

-Toke

