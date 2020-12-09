Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31642D4042
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgLIKpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:45:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730195AbgLIKpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:45:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607510659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8IvleJJEPOqI+HQOJ3Wox6u0RaiRXVtyZzUPbNVvNk=;
        b=B+ckHLjgrBWFgtyhdMsZqunQmTQVpiam3MzRaHAoGpcc3z1VC80yA0W+L6CvN9B2gEuBx7
        WU6953NgwhEf9l2i78WTHutgWZIFg4jTYH+Jfwd3u2bd2/h9ktyWs7rQTeaXQz+3Zj8Pau
        y5SC0ZTN9kESLiDazEGA1Yi1xMDXPVQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-G5hIZrfFMmm7lH8zBVwkbQ-1; Wed, 09 Dec 2020 05:44:13 -0500
X-MC-Unique: G5hIZrfFMmm7lH8zBVwkbQ-1
Received: by mail-wr1-f69.google.com with SMTP id r11so489006wrs.23
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 02:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=E8IvleJJEPOqI+HQOJ3Wox6u0RaiRXVtyZzUPbNVvNk=;
        b=hgSpzHZSmhJMEJS0zAiQtD+92LhHzt3BGLJwWEwo4FOd2Ms6razSU5lqvZcy3bMNX1
         5ZCicNjZU1RXTUJX0l8dyalVvYTh8Y0P43GEDATTow2h0RJO0ZRcE2HVU6rGiamBsBeD
         akSv7M9FBVOjx0CBxyBSAFoiBc9v+3/yqVl/JcR8Ohn7/iqJldbBBPXBMAvfQoDGPtLd
         MsGelLsyHJu59FdR0+iyGOgbKMVQ9HuDVAJ59Qq8x9fX2lgbo3+Kmte1nEYuxlCvzE2G
         YB+hGqei/48CHDG1dMPwZRjAsDAmOQfBDRMh3bEXksFJNEW2weeEZcT0SGXBkcgNYRLq
         WnEQ==
X-Gm-Message-State: AOAM530oksOgg950+7Bqb1FHYJ/1jnkyLvRWKNHM17C0JcehcyQbbDq8
        uYPDkScanWyN5H/COWj+vLKwxHOWg4uQS8xDGMSR0Wj3yjWS7XUhpNK6qFJSp81142qx5TaUmrT
        JuXtZM2Yzt8/TznDe
X-Received: by 2002:adf:fc49:: with SMTP id e9mr1946098wrs.31.1607510652340;
        Wed, 09 Dec 2020 02:44:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5nub/Sq5c7l451OlXUqVkHzYJB0YUybvkCyDo/5w5jzbg7upcJ+TzGTlUpp+wlUbbbkH0sg==
X-Received: by 2002:adf:fc49:: with SMTP id e9mr1946085wrs.31.1607510652196;
        Wed, 09 Dec 2020 02:44:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i8sm2313198wma.32.2020.12.09.02.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:44:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 437EC180003; Wed,  9 Dec 2020 11:44:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhu Yanjun <zyjzyj2000@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        netdev <netdev@vger.kernel.org>, jonathan.lemon@gmail.com
Subject: Re: [PATCH v2 1/1] xdp: avoid calling kfree twice
In-Reply-To: <CAD=hENc8CmxdPeWbQ=4GFdtQCoCqUc87xS5sq+VePZEGC2-Z6g@mail.gmail.com>
References: <20201209050315.5864-1-yanjun.zhu@intel.com>
 <f68c2d75-4a51-445d-cecf-894b65cb8d55@iogearbox.net>
 <CAD=hENc8CmxdPeWbQ=4GFdtQCoCqUc87xS5sq+VePZEGC2-Z6g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Dec 2020 11:44:11 +0100
Message-ID: <87a6unp8ck.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhu Yanjun <zyjzyj2000@gmail.com> writes:

> On Wed, Dec 9, 2020 at 1:12 AM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>>
>> On 12/9/20 6:03 AM, Zhu Yanjun wrote:
>> > In the function xdp_umem_pin_pages, if npgs !=3D umem->npgs and
>> > npgs >=3D 0, the function xdp_umem_unpin_pages is called. In this
>> > function, kfree is called to handle umem->pgs, and then in the
>> > function xdp_umem_pin_pages, kfree is called again to handle
>> > umem->pgs. Eventually, umem->pgs is freed twice.
>> >
>> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> > Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
>>
>> Please also fix up the commit log according to Bjorn's prior feedback [0=
].
>> If it's just a cleanup, it should state so, the commit message right now
>> makes it sound like an actual double free bug.
>
> The umem->pgs is actually freed twice. Since umem->pgs is set to NULL
> after the first kfree,
> the second kfree would not trigger call trace.
> IMO, the commit log is very clear about this.

Yes, it is very clear; and also wrong. As someone already pointed out,
passing a NULL pointer to kfree() doesn't actually lead to a double
free:

https://elixir.bootlin.com/linux/latest/source/mm/slub.c#L4106

-Toke

