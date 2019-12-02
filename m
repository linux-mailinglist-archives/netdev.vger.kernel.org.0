Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7710EC2D
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 16:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfLBPSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 10:18:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727401AbfLBPSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 10:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575299934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6Jhh/U1FheNObDciS7QNScB0Gyc+7SR1/zlHd1htEA=;
        b=DsUT++cumGKl3byuLgSFs8eXVi+yPNMKevjUhrVzoO7bTlbwTRLOBVtitN84f3WinU5Wq/
        53ODXWM3f7glFOSL73BBgeRc2yFgbWiJD7K8Busd2T85PUjY0STGE8EbJPWCmMYVe649nc
        XNCuH+6ACugRK/RqWuNzKe1QjexqMow=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-8Oip8TABN8ivLON_7UTEWQ-1; Mon, 02 Dec 2019 10:18:52 -0500
Received: by mail-lf1-f69.google.com with SMTP id z3so7166522lfq.22
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 07:18:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j6Jhh/U1FheNObDciS7QNScB0Gyc+7SR1/zlHd1htEA=;
        b=cHrc0VmHLwTaHwjCAe/WzKU2OfLS+l61POpsKLlIvvqErVpXysropYYXb+3ECr7Ww9
         vuED5gfgzSVIWlAb37BPebP1ZK7OyFyL1AJ0vzJK6+wgrwORlBkaHddT6XRhlIl1eiPv
         RuDMV30WCScV03S/gkGQxJEjzfXr9q1UdD/XyKSG64jB/S2JfOCHesNvn1BgS9qeijQX
         98v5SEbpCUH3Gd/khg87Hib8WI9IaOF3S/lqNa5g/WfpmUJKWU4GxCwj2+a1aUf6nLKE
         KtaJRziXyChQS1ymKP+kGdo5KV5QABK9s2idgtUkfxdpzap66+PPM9hXMukpWre4NNdl
         4AMg==
X-Gm-Message-State: APjAAAWGEoK/e3OjNMLFP9VywnKHuatNaO3/es9kyNvGGv+imKeRgDz2
        tDvceahi/8aITVLhw5PKcyiq9DPNoNhcYhANPBhJcbMhBzgWt3OjhNCr7WgNFV6AJ2WnifloEVS
        9lFTAM4OG8s20payG
X-Received: by 2002:a2e:94d:: with SMTP id 74mr5671786ljj.69.1575299928024;
        Mon, 02 Dec 2019 07:18:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfzut8z/cgmpk3y0XlnxuLbTxm5XWz2fCR9C5ZepMxCj6RF1Zxi3R+m7oo1Z99sDmHt7RHRg==
X-Received: by 2002:a2e:94d:: with SMTP id 74mr5671771ljj.69.1575299927908;
        Mon, 02 Dec 2019 07:18:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f2sm3187290ljn.94.2019.12.02.07.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 07:18:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 75528181942; Mon,  2 Dec 2019 16:18:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Victorien Molle <victorien.molle@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Victorien Molle <victorien.molle@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH] sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO
In-Reply-To: <20191202141138.26194-1-victorien.molle@wifirst.fr>
References: <20191202141138.26194-1-victorien.molle@wifirst.fr>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Dec 2019 16:18:45 +0100
Message-ID: <875ziyrc16.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 8Oip8TABN8ivLON_7UTEWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Victorien Molle <victorien.molle@wifirst.fr> writes:

> This field has never been checked since introduction in mainline kernel
>
> Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Fixes: 2db6dc2662ba "sch_cake: Make gso-splitting configurable from users=
pace"

Don't suppose this is likely to break anything by stricter enforcement,
so:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

