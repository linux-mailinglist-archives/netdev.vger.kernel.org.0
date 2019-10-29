Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3259BE89EA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388832AbfJ2Nul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:50:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388802AbfJ2Nul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JexFLIXNziOY/Hp82j+M6Mi54TFENjbZDKoY1+D14r4=;
        b=Ckye+fZ3CFgdgLFM/oTgHXAaGgKLBkJmcvZ+PuCfoI83joRa8OucA17YdX1S9VQCsN7qJq
        ZzDSMoeVtE4wkGPJ4umyV+T/OTo6+aEhBudRCprpquRhxpis67KOiMbbPeDbYWbOCaW45o
        qOIvD54yl8qXK5RJ2UwEbjuDCh8U6So=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-jPQK-TYzM-O3q2NBQHhypQ-1; Tue, 29 Oct 2019 09:50:39 -0400
Received: by mail-lj1-f199.google.com with SMTP id d25so171875ljg.13
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7ErEh4B9TcCeKpNzW2UWWVl8b/qcD3YHSeB/vQRjds=;
        b=G/ACSzgn4C/PZwwS23U9tIz/lg4BiDLaXZt555B1q5ohDPmcfYHSHWFhHRXQ9oEsRC
         5aInEAt9I2QcVeRYWWBIfczsv2to/2YqmT8uujM75CX5Wy0IfPWBwqv4Djt2rDPCWQyt
         Kcm67GRxBXFf8cMmwBBjWV808tcdVcubwJ1IC7EBQUeqOcvTCpyOAWKGe960QcHI1Z5J
         pAbzB/rmzKMCI6uQKZe1Exx9WL5HrTuI2fSzjxYuluRtcVfDX1OSLjBLEx3SBNX30mih
         omziQnvx1OwI0rhW3+kZWKq29XEzfqt8vZNzxNO1B8TqHRQETW8TmeDNRUs154O/+Hxo
         1V5g==
X-Gm-Message-State: APjAAAXeJg92hRPS56D9fLwe0oauxjtJLO5quRHaht924gbIbhaImeDX
        Zf3pIT1ShtXareYHgYU15RUBLG6VnVCEHKhQOBvIivE+44qU5lwmhbUJR7hIgA2TLd3A2VoYmJD
        a5xYmw/yOjcc1FHn5eIP6rrgDKT9M4HKx
X-Received: by 2002:a19:f811:: with SMTP id a17mr2560876lff.132.1572357037148;
        Tue, 29 Oct 2019 06:50:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyS0UuN7bz4jqf2X5flMLGKB+vIexXwx20Tv6+rGjAW/vVA7aL+e9LoFg4VwxLEI2u8dP1p9NiIJwVVaZmFIpg=
X-Received: by 2002:a19:f811:: with SMTP id a17mr2560865lff.132.1572357036976;
 Tue, 29 Oct 2019 06:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191029134732.67664-1-mcroce@redhat.com>
In-Reply-To: <20191029134732.67664-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 29 Oct 2019 14:50:01 +0100
Message-ID: <CAGnkfhzzjxeS8mTXEf_f=JyH1u0tY2HQn1Hyub+1BVo5_J4DOg@mail.gmail.com>
Subject: Re: [PATCH DRAFT 0/3] mvpp2: page_pool and XDP support
To:     netdev <netdev@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: jPQK-TYzM-O3q2NBQHhypQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 2:47 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> Hi all,
>
> Last patch series for mvpp2. First patch is just a param to disable percp=
u allocation,
> second one is the page_pool port, and the last one XDP support.
>
> As usual, reviews are welcome.
>
> TODO: disable XDP when the shared buffers are in use.
>
> Matteo Croce (3):
>   mvpp2: module param to force shared buffers
>   mvpp2: use page_pool allocator
>   mvpp2: add XDP support
>
>  drivers/net/ethernet/marvell/Kconfig          |   1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  11 +
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 232 ++++++++++++++++--
>  3 files changed, 220 insertions(+), 24 deletions(-)
>
> --
> 2.21.0
>

Sorry, discard this, it just slipped out, bad copy paste :/

--=20
Matteo Croce
per aspera ad upstream

