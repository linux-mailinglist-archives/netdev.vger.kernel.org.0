Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B910511AC09
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfLKN0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:26:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53666 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729132AbfLKN0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576070805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EoTSIGW7dIJHgyHfv6VYXZOjhqsmrik9Ca88NM1ooWk=;
        b=Y98O3Nt2rJHqjI3LL42I8MDVUt9Us9gvJWQ72flu6cdacMgJpGyM3uHrvqUJZ2aYBzb84L
        HiA/8M0evS8PsTc5YyZeAro00IaCqGN84ZViTdoCrdsgtL+C27Z3HbVKjMcu7T1zCw/5JS
        bkOOaqDYmYx7Z+F8QkmeRSig1tscQpI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-v4eicCIEMma9daT5UHfneg-1; Wed, 11 Dec 2019 08:26:42 -0500
Received: by mail-lf1-f72.google.com with SMTP id l2so5029478lfk.23
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 05:26:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Z7qkzCEcLT30vlK9W48ZkVutYS+mgkfmvmct14cHJaU=;
        b=KklPBLQzakoledhbLSYHP3g53j8A2LYbgE6/T0IaN+FyhlpSi/aif3o0RyWFo3EuBA
         h8b7EjoM7b6di1NhLKFfC/eAxpL0mZSPsgnz5xHwQSUq0FkmARagh7UbDTpCQ8s5LRr6
         /Dj3QXIdSHgiYDIznYgULkdkUNscToMOZuVj7Y3cJAlknNTqvE/8uGX9Dk2D5C7Syd96
         VnJ1pgzrdydB/eelDfsQFXD6Fk4HB6lBXMypDbclhxh3qoxStFy2pWglkdnylzKr52qH
         mcioie/PNMp8JAwAYV3UtHN+lLx8itwaHwZehogs9WCjMOYhijyO2ZEJf7453VcTA23x
         dUlg==
X-Gm-Message-State: APjAAAUhtQhJ2D2RtttMLCNiprJQqCHDFrverL82mDTVJHY+3W5DE72/
        onN86vRWNVyKaP4p14hGarqlpr9c5XlfMNZ6MUTcqC+WjgxMzZJcgPVqcTx3rgQX7/OkQPeZpSb
        oUkKKik3pTs/IfUBk
X-Received: by 2002:a2e:2201:: with SMTP id i1mr2015193lji.110.1576070800610;
        Wed, 11 Dec 2019 05:26:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYVnoqrtZTMQ9wa0n82A5zBywFy+czDxizbC4YxBS0hc+IR5MDsNMNL36dUhYMKqeuop2eqw==
X-Received: by 2002:a2e:2201:: with SMTP id i1mr2015175lji.110.1576070800467;
        Wed, 11 Dec 2019 05:26:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i1sm1186646lji.71.2019.12.11.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 05:26:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C395918033F; Wed, 11 Dec 2019 14:26:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
In-Reply-To: <20191211123017.13212-3-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 14:26:38 +0100
Message-ID: <87wob3f0xd.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: v4eicCIEMma9daT5UHfneg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> +/* The BPF dispatcher is a multiway branch code generator. The
> + * dispatcher is a mechanism to avoid the performance penalty of an
> + * indirect call, which is expensive when retpolines are enabled. A
> + * dispatch client registers a BPF program into the dispatcher, and if
> + * there is available room in the dispatcher a direct call to the BPF
> + * program will be generated. All calls to the BPF programs called via
> + * the dispatcher will then be a direct call, instead of an
> + * indirect. The dispatcher hijacks a trampoline function it via the
> + * __fentry__ of the trampoline. The trampoline function has the
> + * following signature:
> + *
> + * unsigned int trampoline(const void *xdp_ctx,
> + *                         const struct bpf_insn *insnsi,
> + *                         unsigned int (*bpf_func)(const void *,
> + *                                                  const struct bpf_ins=
n *));
> + */

Nit: s/xdp_ctx/ctx/

-Toke

