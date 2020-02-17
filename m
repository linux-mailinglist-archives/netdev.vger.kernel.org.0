Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB91610A0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 12:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgBQLHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 06:07:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33689 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbgBQLHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 06:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581937641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4meJ+9cGtIXsHFSQL1G0hT63jAf2xSIQo/UpbNAdilE=;
        b=fvhdaV0NNfIPezjxNs5364V2Vdz6ebK8LfQ7i7z2+MOQ2Hyvry4vAHUDzOkoYY46VCHwN7
        tGMHlsi6MvSTH1d1pf0aYS7V4dV0iuVH/dwl+/f31iodDW4nA4ZQD4ay2jvi8awanJTrn6
        pAuQqb1c7buWcJbrcftKuiEyKMnWN2Q=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-OI-Fs0whPW-RINz-uxjFAw-1; Mon, 17 Feb 2020 06:07:18 -0500
X-MC-Unique: OI-Fs0whPW-RINz-uxjFAw-1
Received: by mail-lj1-f199.google.com with SMTP id t11so5768669ljo.13
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 03:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4meJ+9cGtIXsHFSQL1G0hT63jAf2xSIQo/UpbNAdilE=;
        b=X1unhmK6T5lxQPx1JQUU82j/Jda3nhMPo9sI6G1lAWbXECLvd2k+QepSmlg/2/qBVg
         5d+/FvL9jApHE21HzcEJ1d04zuM/A+ICYzT0htH+rG7DZYjqzkySIhUtFo20jbn9rATU
         a15nHO4nY64SYzPxgiwf5jUbH29AUoanQMt0ElGAYd4dIQybT5Iy8IobxNyNXpKGDPIm
         GKm4gtvuFPrKTDukGUuwdPrteJfDwdLT5escbGRHvpOParcuirF14825yvMdSFk5pe/h
         PZ5Pa7L8l4wQrGm5AyFtpHs1I2v5Gj1wrTNk8MBf2YuV1a08UpI6IHop44m3HQjDnLoH
         erVA==
X-Gm-Message-State: APjAAAW0UZqPZe8FoHWXshW/B7bMynHI7qpKWGJaGB8VPkn5wIENHSfP
        JVoGW8kBabqsIjoXLLmFBEXaOxF8GAyshNu3onPrdJw5eE1iLvlA+IGFOtZ6NuJqQaQLgfgFiCY
        18PC27kNh06kOlPaD
X-Received: by 2002:a2e:e12:: with SMTP id 18mr9901876ljo.123.1581937636765;
        Mon, 17 Feb 2020 03:07:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwIPHCIs14g1Gu8hKPTMZVM4Wo6sviJJaYmXzxNaFPsm29lKGs9/zSmdLZZmKob3xGBzkcGNw==
X-Received: by 2002:a2e:e12:: with SMTP id 18mr9901866ljo.123.1581937636587;
        Mon, 17 Feb 2020 03:07:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q10sm173109ljj.60.2020.02.17.03.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 03:07:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3D9931808E6; Mon, 17 Feb 2020 12:07:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next v3] libbpf: Add support for dynamic program attach target
In-Reply-To: <158193725120.96608.9449808053785640511.stgit@xdp-tutorial>
References: <158193725120.96608.9449808053785640511.stgit@xdp-tutorial>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 17 Feb 2020 12:07:15 +0100
Message-ID: <878sl1bhgc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
>
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.
>
> The call flow would look something like this:
>
>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
>   trace_obj =3D bpf_object__open_file("func.o", NULL);
>   prog =3D bpf_object__find_program_by_title(trace_obj,
>                                            "fentry/myfunc");
>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
>   bpf_program__set_attach_target(prog, xdp_fd,
>                                  "xdpfilt_blk_all");
>   bpf_object__load(trace_obj)
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

