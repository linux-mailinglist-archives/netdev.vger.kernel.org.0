Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2D16FB4F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgBZJvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:51:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726329AbgBZJvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582710698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ryiasZiIIzyC6H3Cs2ZlrTn4bZhFW433koSeRF/avA=;
        b=W0WiM2LhqkABRFh43V1tngCtQExGkUY/8hmFT8A4yT6NQvbhWBTvocxOYR2EMfKFc2ghSB
        +FrL78gZgu9vK9wAm3yHVH5UNCjmgbHYBihATw7nkY8jMkWTt9I4O0SXVBvk1aMUE/6mKL
        6NMkuEgvxcvkWVKeVF9G9OmL0qUM+Dw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-sCnDdX9gOwOtMsJxradVaw-1; Wed, 26 Feb 2020 04:51:36 -0500
X-MC-Unique: sCnDdX9gOwOtMsJxradVaw-1
Received: by mail-wr1-f70.google.com with SMTP id w18so338108wro.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:51:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6ryiasZiIIzyC6H3Cs2ZlrTn4bZhFW433koSeRF/avA=;
        b=pIeDEG1fau5i0S3bvB7ap1a89o45mRVmY39LYXQZD5DD0aA4NXYtGEWKXFhRYbamVS
         SbFjUp9BP8oQeXiiG6anoikKEh5pXaFH3L6EnC57o4bg8oCC9L0S7bPdtm+tooxUNwID
         /Mz8evzWNVEzZcSyYXYC2GAz1XTfUewTgWmg7pkuUI8r2NGk/YNGGxHVDWWfShzeOPLo
         8URWZHe7hBS0OZaqYTM1YQhj/zw6cBqpZ3d+0upzolTu5oVMArm91ePgcU3t2Tjn/KmU
         GR/Hr8eb7PJp5KvzGgJcdTqfLtXpOFk7kG8+TDWP7akOiByoc/Lq5/D6Y5gNr/T0QN6E
         8rSQ==
X-Gm-Message-State: APjAAAXmTKIZVNYBUPd9Pnn5aFoBLb4d8EEnXobQnNAKYt69DhZ2zuN8
        rIi6gj0GkjLoyy+dDNZZXA8ibVV8ph0S7ZsUo0ajb350kJhcKUhYy/NNn1zBQNIjN9fIgmYZeBt
        tnYKZz/TlGsG9cCCR
X-Received: by 2002:adf:a48f:: with SMTP id g15mr4531873wrb.42.1582710695715;
        Wed, 26 Feb 2020 01:51:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmr/RXy38AqGVGgUMXadjtsAiGS73zheLkeDvNaPnDzZabOUQttEHk1ROehdDMP99kkRf3QQ==
X-Received: by 2002:adf:a48f:: with SMTP id g15mr4531857wrb.42.1582710695535;
        Wed, 26 Feb 2020 01:51:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z21sm2218412wml.5.2020.02.26.01.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 01:51:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 43E9F180362; Wed, 26 Feb 2020 10:51:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dahern@digitalocean.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
In-Reply-To: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
References: <20200226093330.GA711395@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 10:51:33 +0100
Message-ID: <87lfopznfe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
>> Another issue is that virtio_net checks the MTU when a program is
>> installed, but does not restrict an MTU change after:
>> 
>> # ip li sh dev eth0
>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
>> state UP mode DEFAULT group default qlen 1000
>>     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>>     prog/xdp id 13 tag c5595e4590d58063 jited
>> 
>> # ip li set dev eth0 mtu 8192
>> 
>> # ip li sh dev eth0
>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
>> state UP mode DEFAULT group default qlen 1000
>> 
>> 
>
> Cc Toke who has tested this on other cards and has some input.

Well, my comment was just that we already restrict MTU changes on mlx5
when an XDP program is loaded:

$ sudo ip link set dev ens1f1 mtu 8192
RTNETLINK answers: Invalid argument

Reading through the rest of the thread I don't have any strong opinions
about whether this should propagate out from the host or not. I suspect
it would not be worth the trouble, though, and as you say it's already
possible to configure regular network devices in a way that is
incompatible with the rest of the network.

-Toke

