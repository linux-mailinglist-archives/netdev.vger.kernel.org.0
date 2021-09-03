Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA73A400046
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348463AbhICNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:11:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235200AbhICNLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 09:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630674644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NdJi3DfTaxZifAGejUa63MN7zsGNDj/aFYim+6FiDeE=;
        b=MwKLgtAiU5v0r1Z0eMHDUgE0mhcNX8I/1XZK9Bl0HF56LWsyqRcaRcBeZDBbMnMQMLPntX
        WA6sT/eh1i9SSqG+jZCp9fRaV2nHyEMpZetdPf5co7qFzUp95eDAnNr+6Hmnkc19nJ2/SO
        EwB7Wiyta/PJZPkEApbm6QwsZ1nmLIU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-GGeiqCk3O9-xXLcdTl_jUw-1; Fri, 03 Sep 2021 09:10:42 -0400
X-MC-Unique: GGeiqCk3O9-xXLcdTl_jUw-1
Received: by mail-ed1-f70.google.com with SMTP id j13-20020aa7ca4d000000b003c44c679d73so2748451edt.8
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 06:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NdJi3DfTaxZifAGejUa63MN7zsGNDj/aFYim+6FiDeE=;
        b=JOTKGLxBwjbnMAjLSyxfeEouN92gmbqoBGYF7sjDAM8D57HFxcisV/RbhoFmS8fu34
         t7T9EJzQHdjLkhQbGBQ9H+pZeKEkq8vM69BDnJ9We/iq/LqNK2WVgyQpa2pMdydHMu2w
         vZFxrFX5L5di93kNBKvlTki+nqk1Ohv0KjctLSany2om/Sw0UGmjKnEFQ1RYQ0mHJ7N+
         V95fGSIml0Kr0kgmCcNsf7xBS4zfHbV2FCBoudeECTvgJlPJkjIBqM0UGwbWISFyyZtj
         XxIg2posgBtzEsd67iNqzDVpKulM7gSoxn0n7ixJr5KuIQ6PjuIlz+U6204SPu/XTQMN
         kL+A==
X-Gm-Message-State: AOAM531gFgQwRrkcHFIpjsYdOklPRB+2AKExkEMEnqrtoytWYfw+EQ3W
        6KyV9S1aLN+KuZqRdzuBf/+WG5lIiLE5WXEYmCesYhzNeCmUx/e2okG87eeZBCc18/ercgFqF6c
        CcohuYPSmBSRfmZ8n
X-Received: by 2002:a17:906:e8a:: with SMTP id p10mr4064732ejf.265.1630674640605;
        Fri, 03 Sep 2021 06:10:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO0dOkNnbHgz/Kkaj0Zn4EuJ+1cwoPQ8XckLrxVQ3MKPnSGddN0iaeoeTNx7y9tONuno2Gcg==
X-Received: by 2002:a17:906:e8a:: with SMTP id p10mr4064625ejf.265.1630674639391;
        Fri, 03 Sep 2021 06:10:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id se22sm2782869ejb.32.2021.09.03.06.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 06:10:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F274318016F; Fri,  3 Sep 2021 15:10:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
In-Reply-To: <YTISE6AI3y3Le9ww@Laptop-X1>
References: <20210901122904.9094-1-liuhangbin@gmail.com>
 <YS+GX/Y85bch4gMU@zx2c4.com> <877dfzt040.fsf@toke.dk>
 <YTISE6AI3y3Le9ww@Laptop-X1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Sep 2021 15:10:37 +0200
Message-ID: <8735qlst2q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> On Thu, Sep 02, 2021 at 06:26:23PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Ran this through the same series of tests as the previous patch, and
>> indeed it also seems to resolve the issue, so feel free to add:
>>=20
>> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
>
> Thanks Toke for the testing during my PTO. I will try also do the test.
> Toke has all my reproducer. So please feel free to send the patch if I
> can't finish the test before next week.

You're welcome - yeah, I ran both the scripts you provided me with, and
Jason's patch fixes the issue in both :)

-Toke

