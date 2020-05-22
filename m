Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F3B1DECA4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgEVP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:59:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730358AbgEVP72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590163165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o+LgVNxrLUdzhoxKCcka7xv01FjRqYkhdnOLS6F+lCU=;
        b=FbHwP+fu+PIGs3KEUAEyuJFjMpPLPvpKRkCAzUiABxN/+VrR6SntYSdNCNxyqb8jep/Zfg
        sowpPbNvddkLtb0a1pJQj4cjkNGMW64N966JNDS/3Xk7VyYUYtGQBOyfStZPNtwwWcpjoN
        dZM+6RPbh3nMJAkzopFWb8L/5j4+gDY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-gLj6y9qZPymgVOz0K1YY_w-1; Fri, 22 May 2020 11:59:23 -0400
X-MC-Unique: gLj6y9qZPymgVOz0K1YY_w-1
Received: by mail-ej1-f69.google.com with SMTP id u24so4883500ejg.9
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 08:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=o+LgVNxrLUdzhoxKCcka7xv01FjRqYkhdnOLS6F+lCU=;
        b=nQY33vKw8KDcbKCXp/t2990RlTokmnTYlkOyt9RSnV+DqOqpJuswWa0CAC/y43zMf/
         Oxj51BAZjeDgHmFfGUAPyYUwZvuHkz993d98f1vMLMJChVIvT9qIiyjMxtV8JTmlh6x5
         hiYUDLXJocBrmccdDVpod0O3YofikQe9C5tzGYPJhsixOrejFZVoBwon2ZIpTqn5+lzQ
         n1wr7nJsLx/L2hXZotKiSUAGJMgM5Lh91YKUyIRdFhTVcxbwzwqJO1e7Hi9GWFnt51iG
         TVqDBc1yIHrW+exdiIzKH5Q1FU7rtlyalBpbHhAE2BpZlCITxch5H+gvc6p53PNgA3ut
         4ONA==
X-Gm-Message-State: AOAM533P7Q81NqoomHIYaocfAdHlEawkxmgUZceYIzw+8QjNsf2wwVD+
        gpooQ8vdJamYmzQGYSUVl0VfGNFMZOQhZ0jyI+wSf4EIkEVI02hklvJs1vqYa977cbyr7vlbUgL
        XjgTdXDmUpe4h7aqn
X-Received: by 2002:a17:906:6893:: with SMTP id n19mr9459063ejr.354.1590163162167;
        Fri, 22 May 2020 08:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKEx56A5mQjTG+Az+ixg5UamwCQo8PRu1WiyGWCiMxBvoEOdO1/UjVfu/HZAFta/FgAQuCcA==
X-Received: by 2002:a17:906:6893:: with SMTP id n19mr9459043ejr.354.1590163161996;
        Fri, 22 May 2020 08:59:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id on20sm4765384ejb.70.2020.05.22.08.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 08:59:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DC44918150E; Fri, 22 May 2020 17:59:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in DEVMAPs
In-Reply-To: <20200522010526.14649-1-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 May 2020 17:59:19 +0200
Message-ID: <87lflkj6zs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Implementation of Daniel's proposal for allowing DEVMAP entries to be
> a device index, program id pair. Daniel suggested an fd to specify the
> program, but that seems odd to me that you insert the value as an fd, but
> read it back as an id since the fd can be closed.

While I can be sympathetic to the argument that it seems odd, every
other API uses FD for insert and returns ID, so why make it different
here? Also, the choice has privilege implications, since the CAP_BPF
series explicitly makes going from ID->FD a more privileged operation
than just querying the ID.

-Toke

