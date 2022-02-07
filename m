Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739F94AC7FB
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiBGRwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343720AbiBGRoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:44:15 -0500
X-Greylist: delayed 384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 09:44:14 PST
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E245C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:44:13 -0800 (PST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4B5273F4B4
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644255468;
        bh=dro8+D+54p75Kt9gfft6Sy+zM9pUCrf8SmGosTvwQTA=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=jux2f5friwXmuHYnUMlvxWSuhNa1H20MCP39r30GzwSCp6wYoyQmGaFN130e5eyk9
         EiQwVpHxuaV1GKLvIo5UEuX59NrjIH7AyZjFxqnF+5ugpc59lZ9HoGnm6zNkrTNJZP
         b2M5RLmVfI9QB+VxWldNYWgVRhOK0nzmn2joEYln2dq6HLsCb5JPhP9QH8C9C89i4+
         oE/VQDv5QiTNJLRLmga0sUnLhGFOAhhcBYKPRamUxA2WgLgMnYYKQ3A7xcdJuUbaCL
         +DkrwFXJlHHEtW6hY6iGCOW/MJSq9qMlY38YK5i8+oEujvY+QgYg5aeja7FI1SOWAD
         VV1MlHD4a3QRw==
Received: by mail-pj1-f72.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso3313003pjt.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:37:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :mime-version:content-id:date:message-id;
        bh=dro8+D+54p75Kt9gfft6Sy+zM9pUCrf8SmGosTvwQTA=;
        b=Kc5xFuWn0VgQUGQWGKIvTzECwTioPvRiFUqAkEUV0feQW2jjQ+a6CU3w7C2GQa6n0M
         9/qOOZak4SHkxU7AJqIrDWpMSOl2ynXe6PFhXo5NfcIaXoAFSJYOlKLi4KXW/JKZVdoq
         hjm1vefMwOgZatyVWMmXaNaP5/UiXGclXdqVcmABVI1DkAzjgITNwCmDKKf4GhWmQq6v
         yBOlBU8AEu/xJJA16tVWudeQbD6Dxrz+kyiGBDd3p6qX4dwrGfGiPqIb/e0zpQs1w2RH
         uo4BouSMxSDGGeON1ZahWjvbv/vfmVG6qg3lwmVZ9jsV5a8YaVIbZ9eqvvftGq2NfEii
         07rg==
X-Gm-Message-State: AOAM5305K0hXXnFu/wNHlPvD9KolCmZ2DQrqiFZZISHvZIwtr1bw6jFm
        OYVGdOhiSfjqw3l7t2zoXLtodvUOT1vjN0f16ZfV67luWESRZbzXfda9UEt8FcFNfDb5DUX1Wgp
        ybedL8k4GMcgzCNSouic/GE9DU4XZ2R5oDw==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr23289pjb.190.1644255466625;
        Mon, 07 Feb 2022 09:37:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbV6qZP4XKXhyoWSmlfPqK18req2XbPtY3tS4tBjcZc0as6zyTLKntersaHJG30dc5R3r7Kw==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr23272pjb.190.1644255466399;
        Mon, 07 Feb 2022 09:37:46 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id e28sm9029530pgm.23.2022.02.07.09.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Feb 2022 09:37:46 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 9D36D6093D; Mon,  7 Feb 2022 09:37:45 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 9589EA0B26;
        Mon,  7 Feb 2022 09:37:45 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "Mahesh Bandewar
        =?us-ascii?Q?=28=3D=3FUTF-8=3FB=3F4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+Ck?=
        =?us-ascii?Q?tQ=3D=3D=3F=3D____=3D=3FUTF-8=3FB=3F4KS+4KSw=3F=3D=29?= " 
        <maheshb@google.com>, Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with slave_arr_updates
In-reply-to: <20220207090343.3af1ff59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220204000653.364358-1-maheshb@google.com> <20792.1643935830@famine> <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAF2d9jjLdLjrOAwPR8JZNPTNyy44vxYei0X7NW_pKkzkCt5WSA@mail.gmail.com> <20220207090343.3af1ff59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8825.1644255465.1@famine>
Date:   Mon, 07 Feb 2022 09:37:45 -0800
Message-ID: <8826.1644255465@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>On Sun, 6 Feb 2022 21:52:11 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
>> On Fri, Feb 4, 2022 at 7:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> > Quacks like a fix, no? It's tagged for net-next and no fixes tag,
>> > is there a reason why?=20=20
>>=20
>> Though this fixes some corner cases, I couldn't find anything obvious
>> that I can report as "fixes" hence decided otherwise. Does that make
>> sense?
>
>So it's was not introduced in the refactorings which added
>update_slave_arr? If the problem existed forever we can put:
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
>it's just an indication how far back the backporting should go.
>For anything older than oldest LTS (4.9) the exact tag probably
>doesn't matter all that much.

	I think the correct Fixes line would be the commit that
introduces the array logic in the first place, which I believe is:

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that us=
e xmit_hash")

	This dates to 3.18.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
