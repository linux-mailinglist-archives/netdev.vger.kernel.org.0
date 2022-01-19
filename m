Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C2D49319C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344675AbiASAIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:08:13 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:47102
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245605AbiASAIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:08:11 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 08CBD3F1C9
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 00:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642550888;
        bh=8BaQ2l2odlkJn5UhawaYPr2nAxhid6ydMu5TpmFEbYc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=qmEfb0Zf5T1hACP5zP3W+Bqjv37kBNFYx/wKgzT0sxW8dhejN0k99zhXhSUoNIVaL
         j3dY0JQUUn4VV3zPS7Y03vyKho3eYotnFxlE3kE6paVIRfPfG1LdWsGAvMlE3VUKJA
         zQh/QB4ZZokr0dJXjCK/36w/mn5uzwN+bxqydMeRFwkndWO/+BSYXQPb9WA1ZcnrTO
         /HlHTJ1VmqOqOc54siHlT0SCB6giFNcv8SfsClT9KNSShpCK/nxsuOJ1OORMkNamWW
         qr8ZMduFMdYPnuVV37xuThVQimkeEMc8H5dnK9w8sLIl8XjSD3jnhTjv3KQ041m9zI
         X+XhMuLf295jg==
Received: by mail-pj1-f72.google.com with SMTP id x11-20020a17090a6b4b00b001b404624896so578713pjl.1
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=8BaQ2l2odlkJn5UhawaYPr2nAxhid6ydMu5TpmFEbYc=;
        b=jccGdIPEF0WjHugiCh/OHIUTWZHLR8WJjynfCnlIsYEi4T2zRCAzj4N3wSSIPpsyZU
         7ReHm8DJUpPnMDChqWI/Q569dH8eCi2I2JaAU10hOdLz70lSe15MN9iYC8L0FKP5i3VY
         fbwxTqT8dVfuOdQEzWQAI7x0SVZi7g9uGuaecfx5ZqR91wL0bnTA2sLfWaA/JkD2q77G
         1WZOInho6LePRLZiz0sEvsgrY4ftgE++iKFoTWfNGBoVmsgQ7MEJ9/2U7GGfX+7yiGN1
         o7cYUoX2XqBQiaXLZFslWAD+w2gFyC0PwNpGFLjgTIZls0jGklb0FC6OFUUYqEWWFGu1
         XfYQ==
X-Gm-Message-State: AOAM530NGQvSetKqMfdSSuqE+kotJgEOnG3xMsWEY1yBTLavfkuDVWq5
        j/xOy/4DCAvFPZ2aKxSLkzAlMnYZyeyFQwlfpdpNNuL5hOqFe9OadnKchbqYvFgehvdo+FiidQP
        OfYaiqcF4A/2MY5uMRe5PcI98APYtOxTZAA==
X-Received: by 2002:a17:902:6b05:b0:14a:b331:d07b with SMTP id o5-20020a1709026b0500b0014ab331d07bmr13960230plk.172.1642550886641;
        Tue, 18 Jan 2022 16:08:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMmG4UeudRibV05AUi39cfGAoFJXebLI7EKU2UuPvx7Un2OeIZjExcKkJLqrLNRR64mDj49A==
X-Received: by 2002:a17:902:6b05:b0:14a:b331:d07b with SMTP id o5-20020a1709026b0500b0014ab331d07bmr13960211plk.172.1642550886375;
        Tue, 18 Jan 2022 16:08:06 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id f10sm3497564pjt.30.2022.01.18.16.08.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jan 2022 16:08:05 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2F3846093D; Tue, 18 Jan 2022 16:08:05 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 27F1AA0B22;
        Tue, 18 Jan 2022 16:08:05 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Ivan Babrou <ivan@cloudflare.com>
cc:     Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Empty return from bond_eth_hash in 5.15
In-reply-to: <CABWYdi1a7MKxM8XX9_1zRkp_h8AHGWT_GQTwAbJdz0iKEfrsEA@mail.gmail.com>
References: <CABWYdi1a7MKxM8XX9_1zRkp_h8AHGWT_GQTwAbJdz0iKEfrsEA@mail.gmail.com>
Comments: In-reply-to Ivan Babrou <ivan@cloudflare.com>
   message dated "Tue, 18 Jan 2022 16:03:15 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3775.1642550885.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 18 Jan 2022 16:08:05 -0800
Message-ID: <3776.1642550885@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ivan Babrou <ivan@cloudflare.com> wrote:

>Hello,
>
>We noticed an issue on Linux 5.15 where it sends packets from a single
>connection via different bond members. Some of our machines are
>connected to multiple TORs, which means that BGP can attract the same
>connection to different servers, depending on which cable you
>traverse.
>
>On Linux 5.10 I can see bond_xmit_hash always return the same hash for
>the same connection:
>
>$ sudo bpftrace --include linux/ip.h -e 'kprobe:bond_xmit_hash {
>@skbs[pid] =3D arg1 } kretprobe:bond_xmit_hash { $skb_ptr =3D @skbs[pid];
>if ($skb_ptr) { $skb =3D (struct sk_buff *) $skb_ptr; $ipheader =3D
>((struct iphdr *) ($skb->head + $skb->network_header)); printf("%s
>%x\n", ntop($ipheader->daddr), retval); } }' | fgrep --line-buffered
>x.y.z.205
>x.y.z.205 9f24591
>x.y.z.205 9f24591
>x.y.z.205 9f24591
>x.y.z.205 9f24591
>x.y.z.205 9f24591
>... many more of these
>
>On Linux 5.10 I get fewer lines, mostly zeros for hash and one actual has=
h:

	Presumably you mean 5.15 here.

>$ sudo bpftrace -e 'kprobe:bond_xmit_hash { @skbs[pid] =3D arg1 }
>kretprobe:bond_xmit_hash { $skb_ptr =3D @skbs[pid]; if ($skb_ptr) { $skb
>=3D (struct sk_buff *) $skb_ptr; $ipheader =3D ((struct iphdr *)
>($skb->head + $skb->network_header)); printf("%s %x\n",
>ntop($ipheader->daddr), retval); } }' | fgrep --line-buffered
>x.y.z.205
>x.y.z.205 0
>x.y.z.205 0
>x.y.z.205 215fec1b
>
>As I mentioned above, this ends up breaking connections for us, which
>is unfortunate.
>
>I suspect that "net, bonding: Refactor bond_xmit_hash for use with
>xdp_buff" commit a815bde56b1 has something to do with this. I don't
>think we use XDP on the machines I tested.

	This sounds similar to the issue resolved by:

commit 429e3d123d9a50cc9882402e40e0ac912d88cfcf (HEAD -> master, origin/ma=
ster, origin/HEAD)
Author: Moshe Tal <moshet@nvidia.com>
Date:   Sun Jan 16 19:39:29 2022 +0200

    bonding: Fix extraction of ports from the packet headers
    =

    Wrong hash sends single stream to multiple output interfaces.

	which was just committed to net a few days ago; are you in a
position that you'd be able to test this change?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
