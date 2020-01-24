Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82647147C2C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbgAXJtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:49:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22653 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387870AbgAXJtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579859378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xigp4eF/RMP8u5+pxsYP+dk8uncFQszTZxN8dby6Chs=;
        b=KsFPwWYwnueDaz+WZMVne19EXgW1p36oFrxCmG7yePxDI/Z/xP1V5VXkMcgAMxxaWaSzrA
        x37SFNh8B1+AxOSV99pUpbQUAyLicqCtNtDPz+XBypxET0hlqZjA0xOGfX6gcMilKFpT6N
        X0JWrAarNgu6ngx1upxMx4UFROYoCp0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-h_te3zYkNjqobf7skwPlOQ-1; Fri, 24 Jan 2020 04:49:35 -0500
X-MC-Unique: h_te3zYkNjqobf7skwPlOQ-1
Received: by mail-lj1-f197.google.com with SMTP id l14so496959ljb.10
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 01:49:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xigp4eF/RMP8u5+pxsYP+dk8uncFQszTZxN8dby6Chs=;
        b=JI+++itF38iPu12SSvs0YdZfobuFCwKrR7QPST34OHmgjYPHQUCl3KD1gNj2tXU3je
         yFVVi/CjDsQTD6e0VCWkydk12SeHzMbReP3GBiqPee7AgPcLs8HqD11w9upDaQRH9NA5
         zkxWuBVR8AhySfKhgUmSUXhESvKodgZThrciw/uYgR5auwQjXYvU/eLieLurovBFouG7
         wxGjK9Qt8HjMt0cCETl3g2SMky+/NM5Rtp0vEUt6Pg2rx/hYkEiTybcp5v1S+xk/g9GE
         cRE2f/+vMePysOAFc30QENq1TP18icRNU4MXJA7VMCRclK61Qo72/2K6G5EeKXb+RnBE
         TTVg==
X-Gm-Message-State: APjAAAUTN/Vh26qi+4SLRbRAUWhackmEU/3XDPqltoFsfiYWIbrDZOSv
        tiFzzAW89Feb4qH2LZLQ1V0ArCFxhn0C2pEL5DMNLOj04fgs84c+c7kiZvnTdEyFwJSix6RZ7yM
        /FL9pMysX/sRMX0le
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr1802692lja.16.1579859373602;
        Fri, 24 Jan 2020 01:49:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyppRlFHHc8J0/CZtXwIIJxvCr2553CGnknWsCHEYZ3kmp9+dYB9Chwlz5MuYOCcLlZekBY9A==
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr1802678lja.16.1579859373387;
        Fri, 24 Jan 2020 01:49:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s12sm3092468ljo.9.2020.01.24.01.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:49:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7132F180073; Fri, 24 Jan 2020 10:49:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <4e5cda5b-30be-751a-be74-6f10b2978a8f@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-3-dsahern@kernel.org> <87wo9i9zkc.fsf@toke.dk> <4e5cda5b-30be-751a-be74-6f10b2978a8f@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 10:49:30 +0100
Message-ID: <8736c5i3px.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 1/23/20 4:34 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@kernel.org> writes:
>>=20
>>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>>
>>> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
>>> at the XDP layer, but the egress path.
>>>
>>> Since egress path does not have rx_queue_index and ingress_ifindex set,
>>> update xdp_is_valid_access to block access to these entries in the xdp
>>> context when a program is attached to egress path.
>>=20
>> Isn't the whole point of this to be able to use unchanged XDP programs?
>
> See patch 12. Only the userspace code was changed to load the same
> program with the egress attach type set.
>
> The verifier needs to check the egress program does not access Rx only
> entries in xdp_md context. The attach type allows that check.
>
>> But now you're introducing a semantic difference. Since supposedly only
>> point-to-point links are going to be using this attach type, don't they
>> know enough about their peer device to be able to populate those fields
>> with meaningful values, instead of restricting access to them?
>>=20
>
> You are conflating use cases. Don't assume point to point or peer devices.
>
> This could be a REDIRECT from eth0 to eth1 and then an EGRESS program on
> eth1 to do something. In the current test scenario it is REDIRECT from
> eth0 to tapN and then on tapN run an egress program (Tx for a tap is
> ingress to the VM).

But why would any hardware driver implement this program type, instead
of the proper TX hook? I thought the whole idea of this "third"
not-quite-TX program type was the virtualisation offload case. If you
just want to be able to run eBPF code in the TX path, why not implement
the proper TX hook straight away?

-Toke

