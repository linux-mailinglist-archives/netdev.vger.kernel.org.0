Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CB487B6B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348571AbiAGR3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:29:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348577AbiAGR3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641576571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w2KxBeQrAHXVA9SVJNoEJTZJLIEcRuBQ110rV6r0h9c=;
        b=EtzPgzGMFayqkMrb51VR7+YgYtHD6NbYBNhUCqlZRIQ2cVTOepRCn3Zoxz/vHsZOcNBWm6
        auyOGoZTstYOwvHK/+kIo61wtXrO7mJtVBQKl1IVBzPwgta6ITYYTNUju0hj2TVwHuVnLR
        bPW6VEgzG/8ka8vZgNFQXMcWb8yl7sk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-PmJ5yNWaNVWag39g7DOzDg-1; Fri, 07 Jan 2022 12:29:30 -0500
X-MC-Unique: PmJ5yNWaNVWag39g7DOzDg-1
Received: by mail-ed1-f71.google.com with SMTP id r8-20020a05640251c800b003f9a52daa3fso5178753edd.22
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 09:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=w2KxBeQrAHXVA9SVJNoEJTZJLIEcRuBQ110rV6r0h9c=;
        b=qEIsWByYFLvkW6k3La4aKN36W4GS+wSi+F/gbSKEIPIiUqulKwXjDxaHR12Ur1rXz+
         VORkY6dVxbXtMKycfonGUbJnKmzGnI6geCf9jYBkr7qxrnySvItRa+K0WyO6ZbnXEkiL
         v2QZcokZYwXahapnKjdKKZ5+UQwdNB7rFOa6ioftAnW3dGJWPRcDIb/6c6ydcDbndwOY
         7Tp6sqUoM9rL7jOjuCESU2wsLBTGR6nioMdTbolIip5czDMfc00cO3cZEkJwdD0GWOwh
         9J4akFCs8YxOahkFGswZ9BQ2CLGM8ySvd/HwNPBpz3w3h7HNuabz8VB4Xas/41Pr7ziW
         ZC+g==
X-Gm-Message-State: AOAM532kDGn43T0BrYE9Z4dOWOqQpfapBThZKC4/QL+X8oAwhheEE/Hx
        w2odZ4+x+zjyRMf+tGKCd4e4HplP1oQgFXnLaBH2rpbYGBNe3eL5UERgc3UsHGctcJOG++y+Coi
        acD1fMuxHDxQxfNqf
X-Received: by 2002:a17:907:6d9b:: with SMTP id sb27mr51336325ejc.1.1641576568818;
        Fri, 07 Jan 2022 09:29:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzZgAyvHy6/3n4mdP5+CHjQ6k0K3cLQ0RLXe8ADTAkR0sdYwTJWo+R+P5+Omx9hBM/6p+3nw==
X-Received: by 2002:a17:907:6d9b:: with SMTP id sb27mr51336290ejc.1.1641576568381;
        Fri, 07 Jan 2022 09:29:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qw4sm1574095ejc.55.2022.01.07.09.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 09:29:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 162B0181F2A; Fri,  7 Jan 2022 18:29:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        syzbot <syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [syzbot] general protection fault in dev_get_by_index_rcu (2)
In-Reply-To: <CAADnVQLH5r-OLfGwduMqvTuz952Y+D7X29bW-f8QGpE9G6dF6g@mail.gmail.com>
References: <000000000000ab9b3e05d4feacd6@google.com>
 <CAADnVQLH5r-OLfGwduMqvTuz952Y+D7X29bW-f8QGpE9G6dF6g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Jan 2022 18:29:27 +0100
Message-ID: <874k6fa1zc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> Toke, Jesper,
>
> please take a look.
> Seems to be in your area of expertise.

Yikes, I think I see the problem. Let me just confirm and I'll send a fix :)

-Toke

