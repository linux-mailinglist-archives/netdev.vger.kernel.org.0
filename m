Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D5148B57
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388413AbgAXPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:37:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388032AbgAXPhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579880224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P41s+GnXtcgFF3H+FN42+xe/S22EYCYIK6IFnNFYiyM=;
        b=iTRpqId3nZzsmGk5Gb/pFv3YBQ0kFCzk1jr5r1HyYrzH22iNxDglnakDr6+zBU96cFfeoR
        lnFpN9IU1Ya5GB5YlU2ps8Nt8PhNijKSLdRk6Nt7wrUcSfU/heqyu3Adj7fFnJ895scetL
        c66NMqVqxiFxIuy1xLGVvEqOFi+ktuM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-YXzIXLcoOa--01t1QRIlZw-1; Fri, 24 Jan 2020 10:37:01 -0500
X-MC-Unique: YXzIXLcoOa--01t1QRIlZw-1
Received: by mail-lf1-f70.google.com with SMTP id y21so355864lfl.11
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=P41s+GnXtcgFF3H+FN42+xe/S22EYCYIK6IFnNFYiyM=;
        b=LuDa8525+5xHKsbH3yD9R9Y0uP2lV4L4kBh/CXQUbNv/PHeRdVhPGaS49vpflcbAiC
         2jLc/+JVLBLwRZ53C2Wz7JL1ci2k56SDz0WVxYdP7JXsVziltzeFqM8Kb9bmZuYY8cEk
         Sz6XIn5BtvYtcwV2vqYxIEnsTHLEFSiyRcUDddIb7g8wL/zCwZakwxuOr4h/hPLF6mxS
         EIm4TdMc5faOuFQSTx+dx5TkMYuIuTzpZKuXQUxXgxawPvVGYE7x/OtCMJFs3oE/w9f0
         WSURpM1lfxywoZU+Jtnb9UFyq9loyJKGh6+IxZFGPAMt4EoVyXxz7U8ic/EiEFYxf7Xs
         rQFA==
X-Gm-Message-State: APjAAAUVye3gNqX/Q5XZaIC9LDUBDxzYf8YqpNHvLk6i5XxGsx/FNxVi
        JhmorLlX0Pc5D753DgmFdQGTD9nJMqXcgBHXGyEpypnswQSS8Wh15juULFWhpfNMPo2YDUx1jVx
        cFmZinLdhjCmAixUl
X-Received: by 2002:ac2:5596:: with SMTP id v22mr1659396lfg.200.1579880220218;
        Fri, 24 Jan 2020 07:37:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4IhlgclduEi4+xag87SHFntDSIBGOPnH08fkddo7c5hS1nusECC/K9IlaG/PFNYNoZ9lOvw==
X-Received: by 2002:ac2:5596:: with SMTP id v22mr1659379lfg.200.1579880219987;
        Fri, 24 Jan 2020 07:36:59 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id n1sm2861179lfq.16.2020.01.24.07.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:36:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E4A5180073; Fri, 24 Jan 2020 16:36:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200124072128.4fcb4bd1@cakuba>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 16:36:58 +0100
Message-ID: <87o8usg92d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 23 Jan 2020 14:33:42 -0700, David Ahern wrote:
>> On 1/23/20 4:35 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > David Ahern <dsahern@kernel.org> writes:
>> >> From: David Ahern <dahern@digitalocean.com>
>> >>
>> >> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attach=
ed
>> >> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers =
as
>> >> the egress counterpart to the existing rtnl_xdp_fill. The expectation
>> >> is that going forward egress path will acquire the various levels of
>> >> attach - generic, driver and hardware.=20=20
>> >=20
>> > How would a 'hardware' attach work for this? As I said in my reply to
>> > the previous patch, isn't this explicitly for emulating XDP on the oth=
er
>> > end of a point-to-point link? How would that work with offloaded
>> > programs?
>>=20
>> Nothing about this patch set is limited to point-to-point links.
>
> I struggle to understand of what the expected semantics of this new
> hook are. Is this going to be run on all frames sent to the device
> from the stack? All frames from the stack and from XDP_REDIRECT?
>
> A little hard to figure out the semantics when we start from a funky
> device like tun :S

Yes, that is also why I found this a bit weird. We have discussed plans
for an XDP TX hook before:
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#xdp-=
hook-at-tx

That TX hook would run for everything at TX, but it would be a separate
program type with its own metadata access. Whereas the idea with this
series (seemed to me) to be just to be able to "emulate" run a regular
RX-side XDP program on egress for devices where this makes sense.

If this series is not meant to implement that "emulation", but rather be
usable for all devices, I really think we should go straight for the
full TX hook as discussed earlier...

-Toke

