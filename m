Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82A31BB963
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgD1JAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:00:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgD1JAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:00:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588064434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxW1qjTd1LnOPfoDLRudR3VIiE6OpaYI7Q4WCzEXVWs=;
        b=fvhIUrDg2YXD8GfR+qDuC1KAQJ7kIgBsgEnKoCRnGXPWd++d0Xs0xOVxY1vOg9E6hE3sdJ
        Xph4bFcJrbUZmCtyaEAU255X9ODSPd67nsw1Y370Kv5mzHIVPpwpxqUgXwopCWTtmK5IUo
        NUt0qoBv3BJ9kK3F/AAK5uXrK2rqaZY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-feITv_hMOBGgQMwj5KlxMg-1; Tue, 28 Apr 2020 05:00:32 -0400
X-MC-Unique: feITv_hMOBGgQMwj5KlxMg-1
Received: by mail-lj1-f200.google.com with SMTP id p7so3539769ljg.15
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=mxW1qjTd1LnOPfoDLRudR3VIiE6OpaYI7Q4WCzEXVWs=;
        b=N0nU6k/mj4lWU+Kh8PszIBNrwN2KuFiKOBd/TZOINUIDd0ju/aq3V1UyZm3ETwRX8D
         KOmcpsr+4utWaNN8jPPWlO6xikoELWqlHlPZLLedM4uerjFl88WoUMtvvOfiX65R5GWl
         I59cid8mk2FdfdjG4c2L8HvFaBI/HJddMcax4UuaDHNEb10l4H23eOjvgW7z8f/bbbeU
         znLh5B7/QIYctOweSXDBviZXZrhjOVvjUSbJFNpJhVV/ep7IBR2flEPOFQyhk2Gzesgs
         R1ScIWXi6do2/RYrX3sD8sFOx2d+xZiaKaJ/9slgBLJXYCiOPTjuCq6a+M21JZzNJDzs
         y96w==
X-Gm-Message-State: AGi0Pubomf7zEt/l5nOx4X0K47+26kgsivbOTypIyvzL6HVhS+1cXs4b
        DFhXMpsTIq4EW2iLb94SOleL8sOZpQMpE9YNEDeazFu/vd7JK9M/fLNAJr2q3SB4m1NEETHKHFo
        T8zGchWIv3shh8tth
X-Received: by 2002:a19:c8cf:: with SMTP id y198mr17598084lff.197.1588064429192;
        Tue, 28 Apr 2020 02:00:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypJXUUxwttVHq7AAC9XoXgii6tIs1XnC+5s+SRp3/FGEun1yAR8w5nWvnrB5FohYfFlPeUbukg==
X-Received: by 2002:a19:c8cf:: with SMTP id y198mr17598071lff.197.1588064428955;
        Tue, 28 Apr 2020 02:00:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o22sm12399636ljj.100.2020.04.28.02.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 02:00:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5C3AC1814FF; Tue, 28 Apr 2020 11:00:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Subject: Re: [PATCH net v2] wireguard: use tunnel helpers for decapsulating ECN markings
In-Reply-To: <CAHmME9rUCYuBCFbw=yhNPqDDJWD3ZUQ_R9xjQ-yp6DXA9_iScA@mail.gmail.com>
References: <87d07sy81p.fsf@toke.dk> <20200427211619.603544-1-toke@redhat.com> <CAHmME9rUCYuBCFbw=yhNPqDDJWD3ZUQ_R9xjQ-yp6DXA9_iScA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 11:00:25 +0200
Message-ID: <874kt4x9w6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On Mon, Apr 27, 2020 at 3:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> WireGuard currently only propagates ECN markings on tunnel decap accordi=
ng
>> to the old RFC3168 specification. However, the spec has since been updat=
ed
>> in RFC6040 to recommend slightly different decapsulation semantics. This
>> was implemented in the kernel as a set of common helpers for ECN
>> decapsulation, so let's just switch over WireGuard to using those, so it
>> can benefit from this enhancement and any future tweaks.
>>
>> RFC6040 also recommends dropping packets on certain combinations of
>> erroneous code points on the inner and outer packet headers which should=
n't
>> appear in normal operation. The helper signals this by a return value > =
1,
>> so also add a handler for this case.
>
> Thanks for the details in your other email and for this v2. I've
> applied this to the wireguard tree and will send things up to net
> later this week with a few other things brewing there.

Thanks!

> By the way, the original code came out of a discussion I had with Dave
> Taht while I was coding this on an airplane many years ago. I read
> some old RFCs, made some changes, he tested them with cake, and told
> me that the behavior looked correct. And that's about as far as I've
> forayed into ECN land with WireGuard. It seems like it might be
> helpful (at some point) to add something to the netns.sh test to make
> sure that all this machinery is actually working and continues to work
> properly as things change in the future.

Yeah, good point. I guess I can look into that too at some point :)

-Toke

