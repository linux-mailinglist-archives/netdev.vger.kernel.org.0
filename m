Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58C213BE9
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgGCOh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:37:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726035AbgGCOh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593787046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7h3VIBynGAlk+pxIYoEzFod8/JhmRY6WxDm0pv5l3KQ=;
        b=EW545tgLoW5EFcq1lcjulXTPEkekNqYCSiHao4iEEAL+cuf+5EkuFv3BEY4jC/Ng58yGcs
        z+Ma8CwWoniFgc4QgVhB95JdXe0F0xU+Mq2oKg+m+X2MwyHx70c0fkVinzVgzdbfYaGeKY
        7q0Ya9jzobe3DdD2qqKc0U8/70wF+NE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-7hmb0jx8Ms2C537F5oC58w-1; Fri, 03 Jul 2020 10:37:25 -0400
X-MC-Unique: 7hmb0jx8Ms2C537F5oC58w-1
Received: by mail-qt1-f197.google.com with SMTP id a52so10655302qtk.22
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 07:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7h3VIBynGAlk+pxIYoEzFod8/JhmRY6WxDm0pv5l3KQ=;
        b=a0tY5qbNaBCrh+vlTRyffDCGZ5d8gF+i/OsnItkVqli0fU3e1YPjvBo49Ouai4Vv33
         jxMbXcog7Z/w0Q9ls9E/+KR2ytVYhZ9dhNpDRe9e9BYxNHitlzpDC9rVb7z5l7F5P+Ya
         v8FC4lzTNI1z2I+GgQ8uAoSxKdAqpBgHTBazCQB/0cLvte960P+fIzNLp6CHdyBcC7zW
         O14Dl+cpfUPtf++Z9A0Pfv6qQ1/BjiQAG7Vt77rXuRLfFI9ZqlduchheaibVKWoyVgI6
         Q2/U/PfxUsB9HIWiFn8mEY2O22DH4wKLykAOUXu8rZT7QEVrvz3PmLf0qZoHwu2jMd7e
         bW5w==
X-Gm-Message-State: AOAM533IJoh8rko+KG8QdQbLcr8ZVvW2/nen8Yy2TDE5/N17sWb6hqrC
        MQWE6L45vuVVF5dxRTw4u6FSziI/LJ5QCvp1DK5nn2KE4E1HuZ2IjrXDeATqq0AINZPPrPd1kf0
        4edCbVayvyzXADqIS
X-Received: by 2002:a37:5b46:: with SMTP id p67mr34023943qkb.346.1593787044529;
        Fri, 03 Jul 2020 07:37:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/rfayxSbJbu3yk98ojqDffk/hNVOL8EuEKT5F/T8VpEAS/bHNmrwscdBkv/Nu2oiHHiwkTg==
X-Received: by 2002:a37:5b46:: with SMTP id p67mr34023909qkb.346.1593787044160;
        Fri, 03 Jul 2020 07:37:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j52sm12168959qtc.49.2020.07.03.07.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 07:37:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F03F51828E4; Fri,  3 Jul 2020 16:37:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net] sched: consistently handle layer3 header accesses in the presence of VLANs
In-Reply-To: <4297936b4cc7d6cdcb51ccc10331467f39978795.camel@redhat.com>
References: <20200703120523.465334-1-toke@redhat.com> <4297936b4cc7d6cdcb51ccc10331467f39978795.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Jul 2020 16:37:20 +0200
Message-ID: <873668ekbj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide Caratti <dcaratti@redhat.com> writes:

> hello Toke,
>
> thanks for answering!
>
> On Fri, 2020-07-03 at 14:05 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>   while (proto =3D=3D htons(ETH_P_8021Q) || proto =3D=3D htons(ETH_P_802=
1AD)) {
>
> maybe this line be shortened, since if_vlan.h has [1]:
>
> while (eth_type_vlan(proto)) {
>  	...
> }

Good point, missed that! Will fix and send a v2.

> If I read well, the biggest change from functional point of view is that
> now qdiscs can set the ECN bit also on non-accelerated VLAN packets and
> QinQ-tagged packets, if the IP header is the outer-most header after VLAN;
> and the same applies to almost all net/sched former users of skb->protoco=
l=20
> or tc_skb_protocol().

Yup, that's the idea.

> Question (sorry in advance because it might be a dumb one :) ):
>
> do you know why cls_flower, act_ct, act_mpls and act_connmark keep reading
> skb->protocol? is that intentional?

Hmm, no not really. I only checked for calls to tc_skb_protocol(), not
for direct uses of skb->protocol. Will fix those as well :)

> (for act_mpls that doesn't look intentional, and probably the result is
> that the BOS bit is not set correctly if someone tries to push/pop a label
> for a non-accelerated or QinQ packet. But I didn't try it experimentally
> :) )

Hmm, you're certainly right that the MPLS code should use the helper to
get consistent use between accelerated/non-accelerated VLAN usage. But I
don't know enough about MPLS to judge whether it should be skipping the
VLAN tags or not. Sounds like you're saying the right thing is to skip
the VLAN tags there as well?

Looking at the others, it looks like act_connmark and act_ct both ought
to skip VLAN tags, while act_flower should probably keep it, since it
seems it has a VLAN match type. Or?

-Toke

