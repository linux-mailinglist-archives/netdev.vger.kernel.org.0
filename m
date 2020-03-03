Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF9177BDC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgCCQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:27:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729598AbgCCQ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXOES8R7lt1FaMV27O05pLr/5n+ZxyuO6JH2cTv43as=;
        b=OivsSYB1T6+tqMK4ZajvwTUKKytjx54jZJ2+o/iuPcpIhGAUk5c2umdXrcoNWKXbtjwZRL
        jnd5JZ8a5K0h9BdcTlQKVjxQ5AObul8w/+8s9n1kfmPrFzxW/SOkeXg54cvraofYrGk2sp
        niFKm985Ajz0nLxOZiTm1xm3heUCtN8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-4cypE74KNCGooFXx_jgMdg-1; Tue, 03 Mar 2020 11:27:37 -0500
X-MC-Unique: 4cypE74KNCGooFXx_jgMdg-1
Received: by mail-wr1-f69.google.com with SMTP id d7so1470594wrr.0
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:27:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EXOES8R7lt1FaMV27O05pLr/5n+ZxyuO6JH2cTv43as=;
        b=V5MED0G9gGwAMeukWJTqOl1p6GNFQHpJE3lYcUGHkVUbCARedQawSyTx52gCTeSv3o
         DLAZUHiyiL3SNis7erybWDH0w/yLr1V0XaZoWpBF10mBrk+gUwuWCfey1/cDe2/hQ4TK
         6gS1QCrcitDScbUSlV4BzuZ4jUgwk1pEEumK/IVSlIQo64Lgh09/Gu5thufwXEZ6Vsb6
         4ib9/jCIAEJLFsVNXRfVZL3vitGIqm8NcJkVkfV7k+UejjxghBccufZEWJmQTt5VQVeG
         S33urfxKKLm5RYfiKQc896ZmMxIQlICaEhi4Y1dEzBsTUrGWh1w+WDxeP9EDr+Twvqp2
         5ZEA==
X-Gm-Message-State: ANhLgQ2ylNqmFlLOF5WJni/xLn7ZOoa/YM5QYfHBaiTiFVOE6lqjEzGN
        CSY4jno1jFarTlg6YluVYZG76vabX9AN/LqwVahIltEPGCndEvUKWVVWMLgcBeOZmCr+qxRk/Qa
        FQU30cliJyVoGBGDb
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr4859155wmc.71.1583252856092;
        Tue, 03 Mar 2020 08:27:36 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvnvh2YnX6Vor6VsCTeF6I03GVmPgt9Mvj+GG8GAzUkK8YR/9BFT2Rg2tJKqt2/1ZUHVcEc7A==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr4859137wmc.71.1583252855877;
        Tue, 03 Mar 2020 08:27:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b14sm24703675wrn.75.2020.03.03.08.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:27:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B816180331; Tue,  3 Mar 2020 17:27:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrey Ignatov <rdna@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Takshak Chahande <ctakshak@fb.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs on an interface
In-Reply-To: <CAADnVQJM4M38hNRX16sFGMboXT8AwUpuSUrvH_B9bSiGEr8HzQ@mail.gmail.com>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk> <20200228221519.GE51456@rdna-mbp> <87v9npu1cg.fsf@toke.dk> <20200303010318.GB84713@rdna-mbp> <877e01sr6m.fsf@toke.dk> <CAADnVQJM4M38hNRX16sFGMboXT8AwUpuSUrvH_B9bSiGEr8HzQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 03 Mar 2020 17:27:34 +0100
Message-ID: <871rq95rpl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Mar 3, 2020 at 1:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> This is the reason why I think the 'link' between the main program and
>> the replacement program is in the "wrong direction". Instead I want to
>> introduce a new attachment API that can be used instead of
>> bpf_raw_tracepoint_open() - something like:
>>
>> prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
>> func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
>> err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // doe=
s *not* return an fd
>>
>> When using this, the kernel will flip the direction of the reference
>> between BPF programs, so it goes main_prog -> replacement_prog. And
>> instead of getting an fd back, this will make the replacement prog share
>> its lifecycle with the main program, so that when the main program is
>> released, so is the replacement (absent other references, of course).
>> There could be an explicit 'release' command as well, of course, and a
>> way to list all replacements on a program.
>
> Nack to such api.
> We hit this opposite direction issue with xdp and tc in the past.
> Not going to repeat the same mistake again.

Care to elaborate? What mistake, and what was the issue?

-Toke

