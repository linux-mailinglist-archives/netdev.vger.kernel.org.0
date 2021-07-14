Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC03C85D2
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhGNOSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231543AbhGNOSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626272128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBYm9n1JHXZyPXbWdNZg18WOdwYLu4hkfmz0//Wgw9g=;
        b=HYHuZuYUKeRD9oPu/SZhBxNjLLE5zLnT2RTdWZTfcrI/lSl9FqVjVF9iwXgE2+QLgx16aT
        gdbfBhMbmUNNSMy0CpzPhTELkpQn2+B5Nm4g1UububAivTNCa+wqXJjlZ4wqWcrGP1YzXe
        Wifx7kQxkecyuB92Qpe5UHyDKVtozCE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-2dbBPNRmM2qTsplvwzJuHA-1; Wed, 14 Jul 2021 10:15:25 -0400
X-MC-Unique: 2dbBPNRmM2qTsplvwzJuHA-1
Received: by mail-ed1-f72.google.com with SMTP id p13-20020a05640210cdb029039560ff6f46so1302858edu.17
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 07:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BBYm9n1JHXZyPXbWdNZg18WOdwYLu4hkfmz0//Wgw9g=;
        b=CjbDjThY2uybwzi+FWbpEXsU0bXW58RfHbOdX6BzC2UdLPlmpjhDvDD9aHNS4esuzL
         TIjuJeyacrBXTnVN/a2FZ8qzPfKP9NI3IbGP/+j3h40R4J27EV8Aq4SoXnH8kTVgQXLG
         +pOSS8mZEkoWZI00VkypRdhtfkw7E1kv5kd9MGiQU76XaRX85+uN8vvbc57gLxXlmfJk
         0IWdK3MDE5BjaWHtV2n2Lnz4BGV/VuWj4OVAcvrfahTj9Ccxp74lDBJ7DgmIGp3S75B7
         FfmZyr5LlQ/gkGJIQr/LyFphaq0p6vRGuhdgJrTB3HDgAztrMzmhfmdBg7Sj90TPFCUw
         alcQ==
X-Gm-Message-State: AOAM532IIu6A0W8MMdF4tZzbCwOZbho7VWmaZyIlUAAtbVdL7cLHbLHg
        zELk9aKnHkhZt3UATaet6alvKd/qypXt47hkwikKdzOdZe9+pY6FftF3AAEHdWBGZfzlxhhWmbq
        2cmF1kOWsjelDnZjt
X-Received: by 2002:a17:907:1c8d:: with SMTP id nb13mr12794765ejc.155.1626272122492;
        Wed, 14 Jul 2021 07:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx44GSIqjM8mInhWCz3gqHqXMTEt/1u7//N2lpZQtN7OzLESX29Qn0OFaYivmxKjfe/CSD5iw==
X-Received: by 2002:a17:907:1c8d:: with SMTP id nb13mr12794643ejc.155.1626272121106;
        Wed, 14 Jul 2021 07:15:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j1sm1091866edl.80.2021.07.14.07.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 07:15:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B9D6E180709; Wed, 14 Jul 2021 16:15:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: Ask for help about bpf map
In-Reply-To: <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
 <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
 <8735sidtwe.fsf@toke.dk> <d1f47a24-6328-5121-3a1f-5a102444e50c@huawei.com>
 <26db412c-a8b7-6d37-844f-7909a0c5744b@huawei.com>
 <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 14 Jul 2021 16:15:19 +0200
Message-ID: <87k0ltf0co.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"luwei (O)" <luwei32@huawei.com> writes:

> Hi Andrii and toke,
>
>  =C2=A0=C2=A0=C2=A0 I have sovled this issue. The reason is that my iprou=
te2 does not=20
> support libbpf, once I compile iproute2 with libbpf, it works. Thanks=20
> for reply!

Awesome! You're welcome :)

-Toke

