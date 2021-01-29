Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CE5308A99
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhA2QsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:48:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230389AbhA2Qq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611938732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ck2gV0VuH7GBK/QhpVV19oowTPnRxR9Fj1/n8dmUshs=;
        b=IMML3lCUzOD8lVezHDe/ffBQB4Iyfp/GT7+gHRqpleJpT+68c6MWpUH7clYgkejowAgYsH
        AOSplzhVjYqkY7udEcwgqCIMKTwmeGznz2NLXCUbKJblOVm+tINpXcsRPTOPFRuwnEvkjZ
        Dry6Ov2KXqJ09VUUyvxtM0K0bA1kXLs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-2nlnyJdSPxCpW9Nz5mLjlw-1; Fri, 29 Jan 2021 11:45:30 -0500
X-MC-Unique: 2nlnyJdSPxCpW9Nz5mLjlw-1
Received: by mail-ed1-f70.google.com with SMTP id y6so5169846edc.17
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 08:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ck2gV0VuH7GBK/QhpVV19oowTPnRxR9Fj1/n8dmUshs=;
        b=LwN2v1UQNueoJT8ghLj3Lcw2eCofcSUGRdUU+H0eCk1Fwvig/8JOsKIp+lvU9Lg+TJ
         bL7kOEbNEN1Uvvp4dvElROFc5I9KSic/U6Rqvf0obRVFoC9g92UubILsVQAxVHN/wQ90
         WXeYtR8RJmxoYlySQz/vYNa3YayJ+o70qE/xKFzVal3mDPiXljMBCONUFHJh2Kldygju
         EDRAjexzw5aV5zxO+2BuDHre2I4nWsj9TGkIBvu642NSLHk8gKTshTc4ZGtmU0OSPyWd
         xTp/uiKAm2QiYKQTqzuY/rPH83v1BV/RmQYGqFIoMEoBm5OOVuFoDQDiPpzAumdKdrwL
         vNjQ==
X-Gm-Message-State: AOAM531YMe6mYXsGx312NqfxZU+sjmU5262T9HL9RYZ+jh6N1+FrUj68
        RK+d7ETkPbPK0aroPkDROjnWMS7GLHf0XxmmphLbgL8lx+SibxX6vhh1n96Qu/IycCmjoiucLqi
        oAg5xJ4QS9ypLHKmQ
X-Received: by 2002:a17:906:19c3:: with SMTP id h3mr5354779ejd.429.1611938728988;
        Fri, 29 Jan 2021 08:45:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKpxUYoG1lbAwAaLwecC1FX99XnsCjATniGAZbZE7z0grlFcWGVX/gJNRVjxorx1Erb8Laww==
X-Received: by 2002:a17:906:19c3:: with SMTP id h3mr5354742ejd.429.1611938728619;
        Fri, 29 Jan 2021 08:45:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qk1sm4032098ejb.86.2021.01.29.08.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 08:45:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 718D6180331; Fri, 29 Jan 2021 17:45:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [RFC PATCH bpf-next] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
In-Reply-To: <20210129153215.190888-1-bjorn.topel@gmail.com>
References: <20210129153215.190888-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 Jan 2021 17:45:27 +0100
Message-ID: <87im7fy9nc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds one bpf_redirect_map() implementation per
> map. Correct function is automatically selected by the BPF verifier.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
> Hi XDP-folks!
>
> This is another take on my bpf_redirect_xsk() patch [1]. I figured I
> send it as an RFC for some early input. My plan is to include it as
> part of the xdp_do_redirect() optimization of [1].

Assuming the maintainers are OK with the special-casing in the verifier,
this looks like a neat way to avoid the runtime overhead to me. The
macro hackery is not the prettiest; I wonder if the same effect could be
achieved by using inline functions? If not, at least a comment
explaining the reasoning (and that the verifier will substitute the
right function) might be nice? Mostly in relation to this bit:

>  static const struct bpf_func_proto bpf_xdp_redirect_map_proto =3D {
> -	.func           =3D bpf_xdp_redirect_map,
> +	.func           =3D bpf_xdp_redirect_devmap,

Ah, if only we were writing the kernel in a language with proper macro
support... One can dream! :)

>> For AF_XDP rxdrop this yields +600Mpps. I'll do CPU/DEVMAP
>> measurements for the patch proper.
>>
>
> Kpps, not Mpps. :-P

Aww, too bad ;)
Still, nice!

-Toke

