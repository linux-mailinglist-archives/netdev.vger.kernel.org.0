Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02C1E0E2D
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 14:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbgEYMPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 08:15:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390448AbgEYMPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 08:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590408938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTL89GGnZOwvxbGI5NbmBKjN/Tz20oB8phBVb564uz8=;
        b=PD82/GOizeiwPTw8xtaSSROMui2DbCzFYgz532dyqbMjIxxmAmvduWt02p1ew+e1qS2euc
        N3hSqrlLQTJ5mZZmtFYZVFRi5SRAfA4Z3pUt9vQv2TogxKddZcWuLGSSi/Iymsyq8i+le9
        4dLkrGwa0QUBTr/gP4HT4RKL5Ob27y8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-M7QISJ3NMl6HBrYPdP5nGA-1; Mon, 25 May 2020 08:15:35 -0400
X-MC-Unique: M7QISJ3NMl6HBrYPdP5nGA-1
Received: by mail-ej1-f69.google.com with SMTP id o23so6312914ejx.21
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 05:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YTL89GGnZOwvxbGI5NbmBKjN/Tz20oB8phBVb564uz8=;
        b=V2Tk6nGYBgZhTRSKGS5MfH2C3tcF3GGRTARF4cJ9ELOp2n5veIizJe17F3Y4wzws56
         cxcc3nFR0LDZm3pUcSGBTEPDE4IOLp92DndoABPMRtQBQRULFUlUJsKmMf3dwsw4Maq8
         4iekh6XfAb6qRwitoWAlfBZDKe7x8o92GZ81poe0pD0vQK4hT7KaQ/GEEWyKxMo2PJQ8
         KkPpfL3CfBgdSGpF3A6CEuPR/GD8sairp3m0YDDLLkX4oZB7iCYB+erzfjr7mM5WFNZ1
         Q0hDhS8yDoduzQtQOn0FR3Gl9nE8kL9DHaWOgHTuFEg/qsAtclE4I0P284fGbRkVKeBV
         1zXw==
X-Gm-Message-State: AOAM5317N8Fabuzr5bJyGAhm193kJlyFGU4r1MMIId1GW+kFBCkW6903
        h2AZTgY8E9P7QQ7rcZWvoqy9jGMoN+Sh1e7XoczMhGevC/HorKdDmKolGxbD1Xzp63GD7W6d7Xr
        3Lzx3B7kjHvAYQ2nD
X-Received: by 2002:a17:906:4749:: with SMTP id j9mr18049583ejs.23.1590408934017;
        Mon, 25 May 2020 05:15:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytqXUTM8CMdcyAFjdnwbkQqDTWkpNVtMc9nwyUdGvjiF9fHLM2HjUTkSTXKi58Ln8d9IGa5A==
X-Received: by 2002:a17:906:4749:: with SMTP id j9mr18049570ejs.23.1590408933840;
        Mon, 25 May 2020 05:15:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c20sm15817306edy.41.2020.05.25.05.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 05:15:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B9F818150E; Mon, 25 May 2020 14:15:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in DEVMAPs
In-Reply-To: <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com>
References: <20200522010526.14649-1-dsahern@kernel.org> <87lflkj6zs.fsf@toke.dk> <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 May 2020 14:15:32 +0200
Message-ID: <87v9kki523.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/22/20 9:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@kernel.org> writes:
>>=20
>>> Implementation of Daniel's proposal for allowing DEVMAP entries to be
>>> a device index, program id pair. Daniel suggested an fd to specify the
>>> program, but that seems odd to me that you insert the value as an fd, b=
ut
>>> read it back as an id since the fd can be closed.
>>=20
>> While I can be sympathetic to the argument that it seems odd, every
>> other API uses FD for insert and returns ID, so why make it different
>> here? Also, the choice has privilege implications, since the CAP_BPF
>> series explicitly makes going from ID->FD a more privileged operation
>> than just querying the ID.
>>=20
>
> I do not like the model where the kernel changes the value the user
> pushed down.

Yet it's what we do in every other interface where a user needs to
supply a program, including in prog array maps. So let's not create a
new inconsistent interface here...

-Toke

