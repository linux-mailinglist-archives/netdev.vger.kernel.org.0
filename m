Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27D62D4393
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732585AbgLINxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732005AbgLINxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:53:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607521908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hg9g+sVoJ6kgUdtXHkyCXTcuMsLmixhN0YeOIGbL80w=;
        b=Aip1ITTIoMaHKwyJjVlCIbawEfBPD4HuUsAUPbp/aJFyH0YMz5Q0j7cBGtyphSDe2tBs1T
        /R0aM1vtr2UHeNKPFC2rRZjrxhxblx2YhhOnP7u5VGoL3tM1nqhPXru+UBAqc5+2BBiqff
        HWFOarXA0tWKfX9cPYzROMK8+FqNNa8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-55fde_cwOQq_jv-5-Yaqcw-1; Wed, 09 Dec 2020 08:51:47 -0500
X-MC-Unique: 55fde_cwOQq_jv-5-Yaqcw-1
Received: by mail-wr1-f72.google.com with SMTP id o12so677627wrq.13
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 05:51:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Hg9g+sVoJ6kgUdtXHkyCXTcuMsLmixhN0YeOIGbL80w=;
        b=G12L3hnyFOXMnsxArKAg0kGzrt8Q6AkTZWire8nzMarBSvOEPz5BIdQ1ouWslLfot6
         m3X5Mp+kzBkD82dUWWNq4q2NhgyKUwj1312InKGsKvAr8shgLxxDmSJF+iKLRJkWxqZJ
         5e9NTG0ILh+9qYHrVhQMcNI234iQHcVX1ZIOn0+jZ7gKSz54+JtRxGsrj61YSRamhVCl
         GABXjT7362b2ftzmmCYh42SIQm1Q7XSBWImyG12alVzrIUbM3hRUQbtOYtFuNPrKzGMA
         Hm1CDQenaagiPmRroceVtQa+GCMUUHricwOU4JOb9F75ZrbS2H70rncFXlQdbQG/uXQt
         uX8A==
X-Gm-Message-State: AOAM531h3JxauRBMiqk4kn6Oq2aMRZmC3jb9HC/kAhDeiPxCVi6+ls2n
        OGXAJIQ8zUevzUfJsE4DauGfOkZMFfI/tLXuSTfipvZTY5LdYCD0zsmh5s2LoMklruohQCvg5OW
        HS3enDlxKqScbIZjB
X-Received: by 2002:adf:a551:: with SMTP id j17mr2796136wrb.217.1607521905993;
        Wed, 09 Dec 2020 05:51:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy344kkv3uqKmIpHXLeHTtzvUQ+KbApOY9R7+uW9M5e9d7deK6JGMan9ETWm9IBUc89/wobZg==
X-Received: by 2002:adf:a551:: with SMTP id j17mr2796108wrb.217.1607521905813;
        Wed, 09 Dec 2020 05:51:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v7sm3355177wma.26.2020.12.09.05.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:51:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CC1AC180003; Wed,  9 Dec 2020 14:51:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v3 3/7] netdevsim: Add debugfs toggle to reject BPF
 programs in verifier
In-Reply-To: <160751272126.104774.9977428866761146011.stgit@toke.dk>
References: <160751271801.104774.5575431902172553440.stgit@toke.dk>
 <160751272126.104774.9977428866761146011.stgit@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Dec 2020 14:51:44 +0100
Message-ID: <87pn3jnl3j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a new debugfs toggle ('bpf_bind_verifier_accept') that can be
> used to make netdevsim reject BPF programs from being accepted by the
> verifier. If this toggle (which defaults to true) is set to false,
> nsim_bpf_verify_insn() will return EOPNOTSUPP on the last
> instruction (after outputting the 'Hello from netdevsim' verifier message=
).
>
> This makes it possible to check the verification callback in the driver
> from test_offload.py in selftests, since the verifier now clears the
> verifier log on a successful load, hiding the message from the driver.
>
> Fixes: 6f8a57ccf85 ("bpf: Make verifier log more relevant by default")

Ugh, the patchwork bot pointed out that I somehow managed to truncate
the commit ID here; apologies, will send a v4.

-Toke

