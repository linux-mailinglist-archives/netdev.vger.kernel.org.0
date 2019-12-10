Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221BC1196EA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLJV35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:29:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728339AbfLJVKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576012200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Dn0X1y8qWY4L6jupdvIYtGjXctpKGwYZyUlMuuX+gk=;
        b=QoR6Yr/J4bbjg/p1mvjp7aha9lOWnKDi9ZOSF9vhAgamPAx0hMo1FaX41vIJkJE+j2Lh2K
        ISZwzpZ2cts5uzgcrjzSZoPLxVlaazc7O+KU167PfBAEoT4Re2QMxxZODBx+13nljlG4+s
        XZwH0VLWZ0q7q7gg9ZpkjHENCtlY+f4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-v63zDGNYOkKITeruXuXq-A-1; Tue, 10 Dec 2019 16:09:59 -0500
Received: by mail-lj1-f197.google.com with SMTP id c24so4062572ljk.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:09:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6Dn0X1y8qWY4L6jupdvIYtGjXctpKGwYZyUlMuuX+gk=;
        b=UGHGjluyWw9PeKlt3oYLx1BLazUl5Q8vjI3GwImg9T4eg6c5vkfyO62xzLpJl4vkNA
         kR1Bx1xf1Yxkz17aStmGyNvi7iiehAHdiUKDabknlfefg3wmIJaOzMT/+xWlkYCPVaN7
         QwM1wCe+ImRR4DzLrs81yNgrwNBJkuqFUbeNiTU6913F6yqIZEBvnxTroOuQqOYVqndx
         tY/XkwczAXyCF2S3+Mesokq2/jYuydpzfxFAMDcXNDaQME/FDk9qFCcmx42dWjy0OkKq
         s4XaK/X5UYzoLQ1v18k8IKrIM1HjZe1KbTp3596LsghjAJFaHg2ESIhPlA187xHQUBIx
         R58A==
X-Gm-Message-State: APjAAAUQpV0HUE6sTRsOpsAbPnNmdPmQY+kLa+lePFEPMZ/a1NxVUdIU
        pNrtNbSL0utPKZjvxebEuoOiaIO0o4LzST8lkVGXpIdMYVPg4mAYXI0d9o2Sv0W5VP5YQYkF8e9
        n24fAFiL1CfYWHSex
X-Received: by 2002:a2e:a408:: with SMTP id p8mr3996820ljn.145.1576012197707;
        Tue, 10 Dec 2019 13:09:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvMCPn/czOu2GRrVuQOc/gN/GQSbTQE0kUF3zFgRZi0rgmbc3zka5Cy/ldLQX+t9WQBZ45iA==
X-Received: by 2002:a2e:a408:: with SMTP id p8mr3996800ljn.145.1576012197452;
        Tue, 10 Dec 2019 13:09:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f8sm2469467ljj.1.2019.12.10.13.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:09:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E6C981803C1; Tue, 10 Dec 2019 22:09:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or ksyms
In-Reply-To: <20191210125457.13f7821a@cakuba.netronome.com>
References: <20191210181412.151226-1-toke@redhat.com> <20191210125457.13f7821a@cakuba.netronome.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 10 Dec 2019 22:09:55 +0100
Message-ID: <87eexbhopo.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: v63zDGNYOkKITeruXuXq-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Tue, 10 Dec 2019 19:14:12 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> When the kptr_restrict sysctl is set, the kernel can fail to return
>> jited_ksyms or jited_prog_insns, but still have positive values in
>> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when try=
ing
>> to dump the program because it only checks the len fields not the actual
>> pointers to the instructions and ksyms.
>>=20
>> Fix this by adding the missing checks.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
>
> and
>
> Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm fie=
ld")
>
> ?

Yeah, guess so? Although I must admit it's not quite clear to me whether
bpftool gets stable backports, or if it follows the "only moving
forward" credo of libbpf?

Anyhow, I don't suppose it'll hurt to have the Fixes: tag(s) in there;
does Patchwork pick these up (or can you guys do that when you apply
this?), or should I resend?

-Toke

