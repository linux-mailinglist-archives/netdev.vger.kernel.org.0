Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8637E2FDA79
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbhATODw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:03:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733219AbhATMyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611147175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Taj+EswQldqKUIFQmaJPXclMJabya3UPoVORBovNqEA=;
        b=Jvznwj2PV+giN4VDESCkS3Enzyf3e665LzGWQufG1NOG/FVQuHcTDPK36E9HU/YMTnWUQO
        dVEWbZwzlCIslVzK85f02biiv3JGf3xE9+2ANqxxsE75jyM/DMhnkCRWWpPkcRaSuHghXL
        kVO9PgLnR2j2ehMtfTN+mrnfGs2RrYU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-hHFw7x_1Nd2Kr4a9P3W6Sw-1; Wed, 20 Jan 2021 07:52:54 -0500
X-MC-Unique: hHFw7x_1Nd2Kr4a9P3W6Sw-1
Received: by mail-ed1-f71.google.com with SMTP id g6so11014298edw.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:52:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Taj+EswQldqKUIFQmaJPXclMJabya3UPoVORBovNqEA=;
        b=J5GoUpkuN5euvW5MMNS0QvKQa1gFbfH5ppWqAGDOlkm6oWfZYEg39rV9i+tGetLq6y
         UlIXZltgCnKFv+Smx+d6K+wH/RLLWE3dP6L8ggSkJ8RKaTaaEwfeMoSzx7k/iuvaC0Fw
         KbQpbCY1FekCPJf4fR+kVJNhWDXHtXnccei0NynzgQjfz/nkn4ZT7RS/NfnrpkCIbcGi
         cJpbFGvuNsiKk9qwXvMpf725NZrIqup490/cW3t8NtFGmmLPfWKS+oHTnGRYVv+pGJk5
         z9LwfAl83BH8IyiWNIBJTzsILLqio9RmSk1qWD+/cu0VfRuTsjRU3IT9eT++DYqFyCBo
         JufQ==
X-Gm-Message-State: AOAM531JTxPN8752VCj9G4jDshNm7DZMh1tbqMpY7yAnzu+LNJu2j1fu
        MpHGtwGbEX6WAS5DaQZydiHmRStKhwnf38zaZNDVij0q5mEV55HHmjNDOeTdDNthJLH65hcJvLB
        XJJMRmmYi3OjyyUPo
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr7283820edv.211.1611147172869;
        Wed, 20 Jan 2021 04:52:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9go95uH5akXQC+KBEihJbMv6KtIQM8A+/MZ1aH+Ky6Rn6XfXLrNt1ly2FZiJLGIP6BMj6cw==
X-Received: by 2002:aa7:ce87:: with SMTP id y7mr7283808edv.211.1611147172749;
        Wed, 20 Jan 2021 04:52:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m24sm861822ejo.52.2021.01.20.04.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 04:52:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB048180331; Wed, 20 Jan 2021 13:52:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
In-Reply-To: <20210119155013.154808-6-bjorn.topel@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 13:52:51 +0100
Message-ID: <875z3repng.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add detection for kernel version, and adapt the BPF program based on
> kernel support. This way, users will get the best possible performance
> from the BPF program.

Please do explicit feature detection instead of relying on the kernel
version number; some distro kernels are known to have a creative notion
of their own version, which is not really related to the features they
actually support (I'm sure you know which one I'm referring to ;)).

-Toke

