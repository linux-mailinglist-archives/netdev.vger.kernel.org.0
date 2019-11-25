Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B59109166
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfKYP46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:56:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37673 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728565AbfKYP46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:56:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574697416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6vjFioBBY91NKmkSnyHowHjVwDMiWIgvvSsxMIvQQ0=;
        b=MMZoicXlB7qai5oVZ09gO0kdZro+xsKN5fwSXL7j1X/SvjcOfhyc2R2pIyThfhgbajDxJ9
        yaiqqPe/vqh5uWk1NHac43YPUc2vBGcteCzRxp3DwP3OYE62w2ZKo3RF+HUGgR4sMZAqPx
        MT4PgvMdItxFxRj6hRsRUbMn4VieJaw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-vPx2ZT4TOKi0BJErfLmuow-1; Mon, 25 Nov 2019 10:56:55 -0500
Received: by mail-lf1-f69.google.com with SMTP id d16so3178868lfm.14
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 07:56:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=k6vjFioBBY91NKmkSnyHowHjVwDMiWIgvvSsxMIvQQ0=;
        b=rW9MX2NG+NJrZxzK8/nWLv73MQQ1vnOmgky/jwWSEyg58iEndhdBzGLAgG/Hu8tgkI
         NuAi0WhoBLnFaAV8i+FeNDucZHH1rnk624Zaah+xFXNzQocmgpQLm6oWZ4RcOGgVMjZ9
         gZidIWkMzZzDRabDghj9Ufj1SSfvLAiv1gREvTZq1PpChnJOOpdS2FAktCWiJtoaEPls
         tNTkV78RT5rD8k459Do8USK6CrCm/pukROjIZQHL8jnMblMLZLMYSjORELQJ/6ZizKmz
         8vdGhmpS4Z8gqVT9ofdzV2gOMUk6Np/pg7kyQEB+Kit+IMMmIjNbHUnd0JHUr0gwEpt5
         /99w==
X-Gm-Message-State: APjAAAU5d9Xpw6i83OHqvS6jMv/KnlyUdHWJO7Z6qwMhRQCoOtTLLU1R
        CoEBU1VpuuNAWU5iEdv8PPCPzQTCjr0usDwKcHfDXyIy9qDOJAgSXUk752hI8OWuwlWeQzizvFC
        byJQNtRm2/DoBm0ym
X-Received: by 2002:a2e:2419:: with SMTP id k25mr22936144ljk.59.1574697414159;
        Mon, 25 Nov 2019 07:56:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/9tRwtySinodJJAoAACUPPhh9jwmcEOD8VZ0y/GgcrSRNg+0Zrh8SQlpQGUJLbXmS/m8OXQ==
X-Received: by 2002:a2e:2419:: with SMTP id k25mr22936136ljk.59.1574697414019;
        Mon, 25 Nov 2019 07:56:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p193sm4380361lfa.18.2019.11.25.07.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:56:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A6F241818BF; Mon, 25 Nov 2019 16:56:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
In-Reply-To: <CAJ+HfNhFERV+xE7EUup-tu_nBTTqG=7L8bWm+W8h_Lzth4zuKQ@mail.gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com> <875zj82ohw.fsf@toke.dk> <CAJ+HfNhFERV+xE7EUup-tu_nBTTqG=7L8bWm+W8h_Lzth4zuKQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Nov 2019 16:56:52 +0100
Message-ID: <87d0dg0x17.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: vPx2ZT4TOKi0BJErfLmuow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Mon, 25 Nov 2019 at 12:18, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>
>> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> >
>> > The xdp_call.h header wraps a more user-friendly API around the BPF
>> > dispatcher. A user adds a trampoline/XDP caller using the
>> > DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
>> > xdp_call_update(). The actual dispatch is done via xdp_call().
>> >
>> > Note that xdp_call() is only supported for builtin drivers. Module
>> > builds will fallback to bpf_prog_run_xdp().
>>
>> I don't like this restriction. Distro kernels are not likely to start
>> shipping all the network drivers builtin, so they won't benefit from the
>> performance benefits from this dispatcher.
>>
>> What is the reason these dispatcher blocks have to reside in the driver?
>> Couldn't we just allocate one system-wide, and then simply change
>> bpf_prog_run_xdp() to make use of it transparently (from the driver
>> PoV)? That would also remove the need to modify every driver...
>>
>
> Good idea! I'll try that out. Thanks for the suggestion!

Awesome! I guess the table may need to be a bit bigger if it's
system-wide? But since you've already gone to all that trouble with the
binary search, I guess that shouldn't have too much of a performance
impact? Maybe the size could even be a config option so users/distros
can make their own size tradeoff?

-Toke

