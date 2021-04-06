Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C61355E05
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242945AbhDFVf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:35:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242075AbhDFVf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617744918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dpN8Kh7q/orjObX7zp1HqUcJQbSHGIFAdNalMLjTGps=;
        b=cBKRFj3w6P3jijUbyI3PsjSzLuByjj27JupplM7/5qp4p94b3AYyJl08AyOC8q4O9L9ryq
        w+fwKKd2l/xfL6SpI50qd/tLlCLy2J/yO8dy34p9NP/W5TvLMykP+NbewNEveFBNsAQTkn
        pK2WS+/86WF21dnoOUWIeAHlhAoIi1k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-TdBh_0Z8OACw1zhzgbwY6w-1; Tue, 06 Apr 2021 17:35:16 -0400
X-MC-Unique: TdBh_0Z8OACw1zhzgbwY6w-1
Received: by mail-ej1-f70.google.com with SMTP id jt26so236846ejc.18
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 14:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dpN8Kh7q/orjObX7zp1HqUcJQbSHGIFAdNalMLjTGps=;
        b=djB4vqmGazwvb6MvRr/ob1bdxfvBl2h8WOlbriZheK/NzpE50T7rB3IMCSFAXN/siP
         Y7QNtZuGKFHOAo6BSUud6FNQkkCT6HMbnHo/xjaMRyC6aFLlk7dJVVI6AJMUrF238M9z
         LUpE3lIRypPcFiVKdUGff9eBKyOFMVCrTmMPumg9OQmasBSfR2tihHOcrlkrn9cq/cC5
         Peew1RLkpYS1I2Kn9dRLv7Xmwowi2QknSbbhTEeWb4YGIlxiLOS3ebBUHpQHkBBEMEy8
         /6LUmu3W2qbmgAm1Wc8K4q8pPsxuxRDRdWYkeUl+fFsBUmXQAXncC+cZnsSti3+10zzd
         ZEXw==
X-Gm-Message-State: AOAM531AyzWWHo7c0cEgvNQP1hp0MKUxpZMRfYw1lyn/+utN9MCoq6QT
        cJQhQvQJLs1rMVTei24bNXpy0AG2cDniB8m++b7MA2mYuRz9TRwY8Oh+rfezONbvGwkjjCxwhTE
        4kXxR0FO/WElrCRG7
X-Received: by 2002:a17:906:130c:: with SMTP id w12mr32115ejb.169.1617744915641;
        Tue, 06 Apr 2021 14:35:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+CL7dEdgQ4m4YY3Ts2c59TsvVs+NRz0pZHUPGS35XAhnFpQVzGhICRF7jrO3/LzsD9tD/5Q==
X-Received: by 2002:a17:906:130c:: with SMTP id w12mr32086ejb.169.1617744915250;
        Tue, 06 Apr 2021 14:35:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b13sm481806edw.45.2021.04.06.14.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:35:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0D4F5180301; Tue,  6 Apr 2021 23:35:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 1/5] bpf: Allow trampoline re-attach for
 tracing and lsm programs
In-Reply-To: <20210406212913.970917-2-jolsa@kernel.org>
References: <20210406212913.970917-1-jolsa@kernel.org>
 <20210406212913.970917-2-jolsa@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Apr 2021 23:35:14 +0200
Message-ID: <87tuoj2j1p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@kernel.org> writes:

> Currently we don't allow re-attaching of trampolines. Once
> it's detached, it can't be re-attach even when the program
> is still loaded.
>
> Adding the possibility to re-attach the loaded tracing and
> lsm programs.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

