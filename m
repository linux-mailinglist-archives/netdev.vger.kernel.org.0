Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459F1136A8E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgAJKIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:08:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727315AbgAJKIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578650884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouxJJ7ApnaANEobDq55HQTWUJCot4siEbVgtMOtq/Lg=;
        b=MGYMSQ+3Zx9W9HtK/BfrRP3DwWYKjxCbQqWMNhB+r8ZTMfC1byIKFipG3DxGWJYiZ//Wyi
        wexFbRMIL+nSlHOcQco37B4IsgNYkNgT1kCTZaJRVKrgYvyaw3QOYZzvf5gLN6wqYKYztY
        k47lkNO+kFOuj8XwJAqaUvXoV2w4uF4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-UOmX14ruPkeOJicXJR7laA-1; Fri, 10 Jan 2020 05:08:03 -0500
X-MC-Unique: UOmX14ruPkeOJicXJR7laA-1
Received: by mail-wr1-f70.google.com with SMTP id f15so697267wrr.2
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ouxJJ7ApnaANEobDq55HQTWUJCot4siEbVgtMOtq/Lg=;
        b=nBCgfBehpmXcvywbkzFjbGz02cZGU9FDhSbuQfRhl1jQ9eQ9/XIWOYzo1rAkYkzll+
         3DpgzpN7Kwe4YHaqjHoKqo+PHQV7aEPFVAz94H6m9/gtUMoVlPYgUb+k3ievQMCEp0M5
         oQeX9kYIXC7kolLIjhey0m5+fUEH2dg0gXq77TUnJZezLAFgo5LSs/s7dmAl59zscTax
         UYHmK2yFoRcR7kg+k60qYvLn11UX8zUxWgjIbquQ8jZ8OiqpyB0ZQAd0UUOKPimiGR1K
         LVIT4OH49plXN8bdRQ9MD+HvDi9BzYAgHCdgAIc+kjRuMrgaF3M1pb0F5p2BtBJCTbRh
         fXyA==
X-Gm-Message-State: APjAAAX3sE5sxlnecOqfznh+a8O8Q7HmlzUupJ7PWCn7y07826Sxx7Tg
        GoFjPLdQr0zLsISkq+KEJ9sJZBflexDrOzFhXg6EljVtY3ETPrvmotml+KRHBnuTgV3z9IZ0JMv
        NaFzMm2op35Ax3JyG
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr2659498wrr.312.1578650881746;
        Fri, 10 Jan 2020 02:08:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqz0wViHteUrRixfoC9FsfmfvNOAdWKhVGBdPLZE6foMdNRyk41CPeTuX5udMW3Q3TdRcNkJuA==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr2659480wrr.312.1578650881546;
        Fri, 10 Jan 2020 02:08:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d16sm1718416wrg.27.2020.01.10.02.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:08:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E3C2180099; Fri, 10 Jan 2020 11:08:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function verification
In-Reply-To: <20200109230328.i6zuva5gqezpltwp@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org> <20200108072538.3359838-4-ast@kernel.org> <87y2uigs3e.fsf@toke.dk> <20200108200655.vfjqa7pq65f7evkq@ast-mbp> <87ftgpgg6p.fsf@toke.dk> <20200109230328.i6zuva5gqezpltwp@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jan 2020 11:08:00 +0100
Message-ID: <87sgknzksf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jan 09, 2020 at 09:57:50AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>>=20
>> > As far as future plans when libbpf sees FUNC_EXTERN it will do the lin=
king the
>> > way we discussed in the other thread. The kernel will support FUNC_EXT=
ERN when
>> > we introduce dynamic libraries. A collection of bpf functions will be =
loaded
>> > into the kernel first (like libc.so) and later programs will have FUNC=
_EXTERN
>> > as part of their BTF to be resolved while loading. The func name to bt=
f_id
>> > resolution will be done by libbpf. The kernel verifier will do the type
>> > checking on BTFs.
>>=20
>> Right, FUNC_EXTERN will be rejected by the kernel unless it's patched up
>> with "target" btf_ids by libbpf before load? So it'll be
>> FUNC_GLOBAL-linked functions that will be replaceable after the fact
>> with the "dynamic re-linking" feature?
>
> Right. When libbpf statically links two .o it will need to produce a comb=
ined
> BTF out of these two .o. That new BTF will not have FUNC_EXTERN anymore i=
f they
> are resolved. When the kernel sees FUNC_EXTERN it's a directive for the k=
ernel
> to resolve it. BPF program with FUNC_EXTERN references would be loadable,=
 but
> not executable. Anyhow the extern work is not immediate. I don't think an=
y of
> that is necessary for dynamic re-linking.

Right, makes sense. I'll just wait for your follow-up series for the
dynamic re-linking, then. Thanks for the explanation :)

-Toke

