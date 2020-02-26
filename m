Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34E170A78
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 22:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBZVbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 16:31:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727550AbgBZVbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 16:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582752681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RtAKQsm0LoriVxXNFnGZipVaReMWANzCf0vj6de4/0Y=;
        b=CIWfW1OkXtABpBARSaKRj1NdryOGPt0ccn1Ev2WZo6finX5EqR4uUjP0M1T6khbegwlKwt
        hlUi5h8q9KU9aEQxybaRAmCvOovWfzWEwo8lXHqxsjqBFUZ0uNOb6Jlwq2WiURWtCXNHcT
        Y6tEO3dPqVq8o+q9A2WqCGKtDm2Z2bc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-pr_EKW-bPLKyLY7gWUYbSw-1; Wed, 26 Feb 2020 16:31:12 -0500
X-MC-Unique: pr_EKW-bPLKyLY7gWUYbSw-1
Received: by mail-wr1-f72.google.com with SMTP id o9so331100wrw.14
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 13:31:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RtAKQsm0LoriVxXNFnGZipVaReMWANzCf0vj6de4/0Y=;
        b=ppZRHa/iCbu8VlFLAprpo6NOuD323wi614XyKxN7PW1VcdILJDtZrxHHa5NuRubYJG
         KmaH0zEIHVhrxOA1d9vQ0ygQke+qBTdvKJCYw/oBTqkIMwWBVI7EEUW9OdjNXWdiaqOQ
         RkhCWF+7Ey7tWW+bTjSFWfbCFsiDTnuxnYLsDl8FAfBR1RjFQfwLv46+bWqQVajOFCcX
         Xy3dYJQPyAupAs99m3Ltm/qkKeLpnwmkFZ5UirM6ED29WQC7dWYY8yDm1r3ogzIuvVAk
         cDzHnmJQRWn/LggA3YwK0ilTAhdPKIYTGrBrwb39fyrCYIO3IO8x+3fcTtBNCd4kV2xN
         QkAg==
X-Gm-Message-State: APjAAAVjhBHNfd7VErTnVllKzwFTVCyU2TV7Sr54fZeBIJpjgN7a8vyz
        2XsPilkBEcTYDUIzi3ccw8p5muGoTRIDVqnyj57A/zW1Q71svJrdY2+DS2R8VU/QFcsWi5cUfiO
        5f8DDVjc6/GZxxB7Z
X-Received: by 2002:a5d:6452:: with SMTP id d18mr591848wrw.303.1582752670980;
        Wed, 26 Feb 2020 13:31:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXHgk8i7EIT5PG0ANV8HRemCOPkPlxbTXVwMZJWAiHY1e0SC9zx+6hiJ5V3ix62aTy99BRAg==
X-Received: by 2002:a5d:6452:: with SMTP id d18mr591832wrw.303.1582752670755;
        Wed, 26 Feb 2020 13:31:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o9sm5061340wrw.20.2020.02.26.13.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 13:31:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5FC23180362; Wed, 26 Feb 2020 22:31:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dahern@digitalocean.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <20200226120706-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk> <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk> <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com> <20200226120706-mutt-send-email-mst@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 22:31:09 +0100
Message-ID: <87o8tlxcgy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, Feb 26, 2020 at 08:58:47AM -0700, David Ahern wrote:
>> On 2/26/20 1:34 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >>
>> >> OK so basically there would be commands to configure which TX queue is
>> >> used by XDP. With enough resources default is to use dedicated queues.
>> >> With not enough resources default is to fail binding xdp program
>> >> unless queues are specified. Does this sound reasonable?
>> >=20
>> > Yeah, that was the idea. See this talk from LPC last year for more
>> > details: https://linuxplumbersconf.org/event/4/contributions/462/
>>=20
>>  Hopefully such a design is only required for a program doing a Tx path
>> (XDP_TX or XDP_REDIRECT). i.e., a program just doing basic ACL, NAT, or
>> even encap, decap, should not have to do anything with Tx queues to load
>> and run the program.
>
> Well when XDP was starting up it wasn't too late to require
> meta data about which codes can be returned (e.g. whether program
> can do tx). But by now there's a body of binary programs out there,
> it's probably too late ...

Well, right now things just fail silently if the system is configured
without support for a feature the XDP program is using (e.g., redirect
to an unsupported iface will just drop the packet). So arguably,
rejecting a program is an improvement :) There's ongoing work to define
a notion of XDP features (see [0]). Whether we can turn it on by
default, or if it has to be opt-in on program load/attach remains to be
seem. But it is definitely something we should improve upon :)

-Toke

[0] See https://github.com/xdp-project/xdp-project/blob/master/xdp-project.=
org#xdp-feature-flags

