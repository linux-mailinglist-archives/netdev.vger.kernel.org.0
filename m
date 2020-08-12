Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3834D24276C
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 11:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHLJYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 05:24:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39069 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726409AbgHLJYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 05:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597224291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0RAsBMV1VRV9PTxV0Jb0bq8SzJBZPYK2PYTUHp8OeY=;
        b=YW7j3JlyVtgxy+Ehjg70JLa3vJ4hAzvP7ZkI150x1Yy/RpXWmcCb2txHqfQZe7fhCtYjgP
        q3oPp9LHf5bEZqxezJcdHx0zgZUP8YMMCMY/rEsPmw8S/BU+DBbMk2FU6EtAhkopgZJ9CH
        yG5wj53lCdlGNW5FWyUI6EFX64DV5b8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-JnCcrX77PeGR64EYl5Scsg-1; Wed, 12 Aug 2020 05:24:49 -0400
X-MC-Unique: JnCcrX77PeGR64EYl5Scsg-1
Received: by mail-wr1-f72.google.com with SMTP id r29so672992wrr.10
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 02:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=D0RAsBMV1VRV9PTxV0Jb0bq8SzJBZPYK2PYTUHp8OeY=;
        b=rDTYPr7dq23sLC/vqPMd+VNcRnyqer+cfTGJsHCiFS7J6sv2aZBmthiYBVTEk1eHXh
         cSPs4S0J6E68VIH1axZKGGrNgkmk5Xpc8aGVWJnGELDC2ygdkj9BShryoPZn7zPYn2vR
         pC+UmOen42iXqEfrD/ARU5Iez8XRPJenOL+9fI6LFELu4iERl5vEZimd7P0Tlw6DuG8H
         rF69Pu9vWbs/yvR+taZzdxY2osZOm3rUKjNkfMm+RllkJ4YHauXB6df795D2CwJuwOf4
         IJsa48JTfdC+YrUtac8zEcsgOCw/U/0mQFL7EFQl5PqLphsAd/g8HPn2VaVjY3z6WLHt
         lNCg==
X-Gm-Message-State: AOAM531d6uwFlnl8/TqOWG4/1jThLTCFiw6euDoq27Za0dMhjXZ4VbZ3
        pyaVORK2nWLpY7/YPsetxKChaZeVsGZKVsu/bYUYyNC6Q/tmNPG2WLQjUgr/88v1FZgu0RyXFcI
        WDOQDYG2oJL4JXa6e
X-Received: by 2002:a1c:7e44:: with SMTP id z65mr8195717wmc.13.1597224288390;
        Wed, 12 Aug 2020 02:24:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqjk1UDn6Bdzt14vEBN5NYKE1v9wqJxw7iHNj67SWRlTXQtUQfNcFDAvuYP2Qw2MtuhfUqww==
X-Received: by 2002:a1c:7e44:: with SMTP id z65mr8195702wmc.13.1597224288234;
        Wed, 12 Aug 2020 02:24:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x6sm2976425wmx.28.2020.08.12.02.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 02:24:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1AB518282F; Wed, 12 Aug 2020 11:24:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf] bpf: fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
In-Reply-To: <20200812022923.1217922-1-andriin@fb.com>
References: <20200812022923.1217922-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Aug 2020 11:24:46 +0200
Message-ID: <87imdo1ajl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Enforce XDP_FLAGS_UPDATE_IF_NOEXIST only if new BPF program to be attache=
d is
> non-NULL (i.e., we are not detaching a BPF program).
>
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Fixes: d4baa9368a5e ("bpf, xdp: Extract common XDP program attachment log=
ic")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

