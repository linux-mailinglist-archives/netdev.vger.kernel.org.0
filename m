Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675EF173509
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgB1KKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:10:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726400AbgB1KKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582884635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvH5sN9UdVxq7uySrn24Y2fuNAKD/E3xegJnUN0q9BE=;
        b=V3Spff5dIik0aw5bFOuwpFyQWq0603ShAYNHCPlyBTnFs6BxvScYZUJomfHoTKrnkxv6ft
        JpX6psS94VhutRhCO9cS2vkGIqkJFr59bGJBBhGv/wgEoxMPjDm2wAQkxEmE9H7M112cPO
        pqDw6a+bA9dcMFz0makPnmnV1NYyckc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-H09FdKnqOoiwpSKMxjKq1g-1; Fri, 28 Feb 2020 05:10:33 -0500
X-MC-Unique: H09FdKnqOoiwpSKMxjKq1g-1
Received: by mail-lf1-f71.google.com with SMTP id t141so343270lff.4
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 02:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GvH5sN9UdVxq7uySrn24Y2fuNAKD/E3xegJnUN0q9BE=;
        b=A8ZomUvYKD0dQ3mooehLw9m+y8cGyKYLRYZXOkzvPsGDXj0sLSDgxPIjE1ZSzsHodo
         b4OD90Rot8Nvl7tF85qz6Hb51EUD/CaL66FL7qX7GOyNb3q56JzPIYoZkxVuOPEcmjsS
         3gmpSJULfUqCu1xDPKu1KCXx3BamSCVjdMr0yW8/3iTLn+A/Ikwj0erkyjsd5wOcUF6X
         l6R6mrrAVABF1Aeaf/sJZdgUwLE8fDBkb0QtqiovY6uNblVc/etKrYOZWDwr4R0omvRO
         CbpJA/yz1dgxUws7OJu7p/cQbewFtm4VIsatVw2m3A6XCIIbljq2nF0pTjbcO1TbxfQA
         dTew==
X-Gm-Message-State: ANhLgQ0OjT5P/6mT8spTVopJbWHo3skiGsx/ZzEzsCmvTdoJePZEnp8b
        dBf5NpawygaL2OITUtQsuwRDb+G0VkSCcySUYFpYm88OIIRFg+h1oNIS6py0fqNwRFK4/TGbtEK
        MtiGsTlhhqHxq6X9k
X-Received: by 2002:ac2:5299:: with SMTP id q25mr2217453lfm.213.1582884632133;
        Fri, 28 Feb 2020 02:10:32 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtrk6e2bqNHHLe6tlbtoX+YGKrvCJcudDLZi7WCuhh4Zoe9WawzvSGrA08dLfCvv/wjbniNzA==
X-Received: by 2002:ac2:5299:: with SMTP id q25mr2217429lfm.213.1582884631905;
        Fri, 28 Feb 2020 02:10:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r25sm5194027lfn.36.2020.02.28.02.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 02:10:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6007A180362; Fri, 28 Feb 2020 11:10:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dahern@digitalocean.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
In-Reply-To: <3b57af56-e1c1-acc7-6392-db95337bf564@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org> <20200227032013.12385-4-dsahern@kernel.org> <20200227090046.3e3177b3@carbon> <877e08w8bx.fsf@toke.dk> <3b57af56-e1c1-acc7-6392-db95337bf564@digitalocean.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Feb 2020 11:10:30 +0100
Message-ID: <87lfonuind.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dahern@digitalocean.com> writes:

> On 2/27/20 4:58 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>  also, an egress program may want to actually know which
>> ingress iface the packet was first received on. So why not just keep
>> both fields? Since ifindex 0 is invalid anyway, the field could just be
>> 0 when it isn't known (e.g., egress ifindex on RX, or ingress ifindex if
>> it comes from the stack)?
>
> Today, the ingress device is lost in the conversion from xdp_buff to
> xdp_frame. The plumbing needed to keep that information is beyond the
> scope of this set.
>
> I am open to making the UAPI separate entries if there is a real reason
> for it. Do you have a specific use case?

I was thinking it could be a nice shorthand for whether a packet comes
from the local stack or was forwarded (0 =3D=3D stack). But no, I don't have
a concrete application where this is useful. However, if we define it as
a union we lose the ability to change our mind. Together with the
debugability issue I just replied with to your other email, I think it
would be better to expend the four bytes keep them as separate fields,
but still restrict access to the RX ifindex for now.

-Toke

