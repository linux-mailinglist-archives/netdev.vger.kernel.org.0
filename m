Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3316FA24
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBZJCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:02:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbgBZJCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582707729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bMe5RI4DvbrmMXfbiFFaSOXMNH+r/Krmbk2nEUEO/kA=;
        b=iiZAHMfxZP/MT0Zy9AtpYn/A+xHBGYR+BRsDVfxhNB5Awwnm6LciUbEgrszC1vbpk7u4Qd
        Y7dbI/6FESq7M3EIgA1s2B6CH9ExcNokrEJ+EeG9lWcV2NabY/pgYIn+M88ujn9Zqagt2V
        Cnxqw5MiGumJ4Gq5cEo8VSfs7qrK14Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-11ERyfPGOeSpGf2uFvj3FQ-1; Wed, 26 Feb 2020 04:02:08 -0500
X-MC-Unique: 11ERyfPGOeSpGf2uFvj3FQ-1
Received: by mail-wm1-f69.google.com with SMTP id y7so641820wmd.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bMe5RI4DvbrmMXfbiFFaSOXMNH+r/Krmbk2nEUEO/kA=;
        b=A0INI/CZbvpLaQjF+oUuQTph9dXpXbzxb3BKNFztXD+ObZFogF8QZhB4Ht8jF78rMl
         XFVXNexcx6mtQTawot4b+Z6dbgNGU3l60oJYXsVoMfEL3G9f0nXavs2UNd1Mt4nMUb20
         YOmXC2CF6Ua47H5tRO1glucmWkke+1UKUFmM3Xb6TpPP7RV3VcSiU3FiO7SqptMSgFgk
         JfnUHlqKCmWyeOXIlqIMed3WVqcBrwvRPxGoPEr814W7wKI7gddx1WB0+WPW6OOy7Cwg
         Xq/Mnu6+1+z1Qgf+ogpOb9hNNaosBIzb0Jb5p8kxKBgb4HQJhrxy/LKc4fwCvCWGAJ0J
         Jg2g==
X-Gm-Message-State: APjAAAXmGsWdPPXpbA3LDaPZRBL4iM/WterkydFKlzzfxX7LUiXuOjSB
        vSkA1s2m8iPM+6mWr9V/nLmy/6yDrM1kb1KH8gYKRLNdg3f2d09l8EA3uh2nn3tFlJRrqo4iVaC
        REDl/YyxV5xnbvWOz
X-Received: by 2002:adf:f586:: with SMTP id f6mr4114524wro.46.1582707727436;
        Wed, 26 Feb 2020 01:02:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxi4Z12n2xdDlGLoAW6WsdmnSeHrkEXC0iIIxDIUHJsNqkBHWI3Pv7Y5uUtN2gA4pML50pbA==
X-Received: by 2002:adf:f586:: with SMTP id f6mr4114433wro.46.1582707726602;
        Wed, 26 Feb 2020 01:02:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y12sm2325074wrw.88.2020.02.26.01.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 01:02:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8280D180362; Wed, 26 Feb 2020 10:02:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <20200226034004-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk> <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk> <20200226034004-mutt-send-email-mst@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 10:02:03 +0100
Message-ID: <87o8tlzppw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, Feb 26, 2020 at 09:34:51AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> we already do block some reconfiguration if an XDP program is loaded
>> (such as MTU changes), so there is some precedence for that :)
> Do we really block MTU changes when XDP is loaded?
> Seems to work for me - there's a separate discussion going
> on about how to handle MTU changes - see
> https://lore.kernel.org/r/7df5bb7f-ea69-7673-642b-f174e45a1e64@digitaloce=
an.com
> 	virtio_net: can change MTU after installing program

Maybe not for virtio_net, but that same thing doesn't work on mlx5:

$ sudo ip link set dev ens1f1 mtu 8192
RTNETLINK answers: Invalid argument

-Toke

