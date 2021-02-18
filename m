Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CE831EA8B
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhBRNqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:46:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231819AbhBRLjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 06:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613648281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36Nxu7fh3KcvHdksE5HDqIJ3wvrGYUMQwh0wbPL/3hQ=;
        b=ParTW8z0ZAfkJkQwtKZ6qyHBCLW8TBd5wPsNck6zRO01W4oLbFifWsjjk/hGU4WHN8dR98
        oROnytqMeapDBhoVvKWvGGYLH/5T6KsQTuqeRn3lPv4y/ePZUV/GU5R/A9dq499K+p9Uhv
        Kb/HA3Xxn/7zsKQQFRZJ4E76kYKPv/o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-r3ZJoTk9NN2yBkLvwMz4qw-1; Thu, 18 Feb 2021 06:33:12 -0500
X-MC-Unique: r3ZJoTk9NN2yBkLvwMz4qw-1
Received: by mail-ej1-f70.google.com with SMTP id yh28so559448ejb.11
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 03:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=36Nxu7fh3KcvHdksE5HDqIJ3wvrGYUMQwh0wbPL/3hQ=;
        b=Yuij9ohAS8OMK9/YdTKI6zvG28cMXB+ICE0mVemj7YkodFCTN2nfCDKGjxLsyGNOMu
         7/t/vOvDHHgn+3NzxPC6nrW7xlc+v3STvvsMtSfR6gLfW9VF2speds9decqPzSI+lVx5
         xY7TLtQmnSrGNL8gDKv7yFRG04L65S/re7EU4MFbtYKoRIUv+XuNgk63ei86KbxZE+XI
         7NAxNsksyWIQ697L++WMJguIHKjTewGsVKEzgw8VdMUmDc3nRCj/QJp5hqla5Qr9TAfu
         p5vgPkCq7VKrOc1o8w75K4Rgyvwp02FGYNaduKd8Q5X1mQvupjz0XJWIfceF9mnwCMbz
         Q60Q==
X-Gm-Message-State: AOAM533QZnrjcENtGBInl7aD7BG80X74hg+fFEJhdtbLkvDfdjJ66Zsf
        l5Olj1o/6UD3WozFpuc+GiWjwIuv0LuoRpytsvr6TNw4FhJFNFiCE9buH7WtQ0j87rgR9oVBlHV
        VVhLYpaiXYPmzKsgK
X-Received: by 2002:a17:906:4c90:: with SMTP id q16mr3650793eju.49.1613647991259;
        Thu, 18 Feb 2021 03:33:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwncoh1x9SnZ4fpM1Vv1Dk74fJ6NcnMvbuj6niroKBejeYqbgEzKQVsxkuh9Jeo8iBmL8Bskg==
X-Received: by 2002:a17:906:4c90:: with SMTP id q16mr3650770eju.49.1613647991115;
        Thu, 18 Feb 2021 03:33:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p20sm701475ejo.19.2021.02.18.03.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 03:33:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 619B31805FA; Thu, 18 Feb 2021 12:33:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Stringer <joe@cilium.io>
Cc:     bpf@vger.kernel.org, Joe Stringer <joe@cilium.io>,
        linux-man@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        mtk.manpages@gmail.com, ast@kernel.org, brianvv@google.com,
        Daniel Borkmann <daniel@iogearbox.net>, daniel@zonque.org,
        john.fastabend@gmail.com, ppenkov@google.com,
        Quentin Monnet <quentin@isovalent.com>, sean@mess.org,
        yhs@fb.com
Subject: Re: [PATCH bpf-next 00/17] Improve BPF syscall command documentation
In-Reply-To: <CADa=RywykZt_kMVcCJk8N0vm2sJHW2_mKTr9Z8m2rTsnqvinqA@mail.gmail.com>
References: <20210217010821.1810741-1-joe@wand.net.nz>
 <87r1len6hi.fsf@toke.dk>
 <CADa=RywykZt_kMVcCJk8N0vm2sJHW2_mKTr9Z8m2rTsnqvinqA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 18 Feb 2021 12:33:09 +0100
Message-ID: <87mtw1life.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Stringer <joe@cilium.io> writes:

> On Wed, Feb 17, 2021 at 5:55 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Joe Stringer <joe@wand.net.nz> writes:
>> > Given the relative success of the process around bpf-helpers(7) to
>> > encourage developers to document their user-facing changes, in this
>> > patch series I explore applying this technique to bpf(2) as well.
>> > Unfortunately, even with bpf(2) being so out-of-date, there is still a
>> > lot of content to convert over. In particular, I've identified at least
>> > the following aspects of the bpf syscall which could individually be
>> > generated from separate documentation in the header:
>> > * BPF syscall commands
>> > * BPF map types
>> > * BPF program types
>> > * BPF attachment points
>>
>> Does this also include program subtypes (AKA expected_attach_type?)
>
> I seem to have left my lawyerly "including, but not limited to..."
> language at home today ;-) . Of course, I can add that to the list.

Great, thanks! :)

-Toke

