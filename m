Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE6147CA4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbgAXJxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:53:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388266AbgAXJxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579859609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4t1ejswvOE8YpSGKPzSa4YPCF/SE/Nt+MqgosBi2Qk=;
        b=a7WjStH8j2BRUqoaC52bYDwrIH1hRDeJvhtPgA2kGU8p7A0Qnv744ynpiovVHLpk6qYp3m
        Blx2qTu34e4Rs2FlJTGCn9/8HlIsz4WIIkkfTdI/nOIsFcP6fpjkgMbWWpGoZOKuJmaJ+W
        VUw52eunmERAEFDCOTdHT+iMT4UX76I=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-eKSTLIOuNiu2XL8XUSiWkQ-1; Fri, 24 Jan 2020 04:53:28 -0500
X-MC-Unique: eKSTLIOuNiu2XL8XUSiWkQ-1
Received: by mail-lj1-f198.google.com with SMTP id k21so508604ljg.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 01:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=K4t1ejswvOE8YpSGKPzSa4YPCF/SE/Nt+MqgosBi2Qk=;
        b=UTTDsy3qSp0izdqnWRPQcQ3RCrZ3gLuMk9/HCyxZjo6Kg6yCSlQl6My+Gl54UvvdMH
         IrbWiCmacvR05Be1kIeCSJoDkyhxKy9FaeB5WMax/1k9Njco7NsNdgb4i/D4ZqZYatof
         EAVtAPQj1FhiiXJMkaad6/f3lPK9psKnqgJcMrVU9Bzr0/tiHsy8lNiw3D7wcSs18MkD
         Xh4u9vOMV6IpA4sEx6f5a33mgJ/82VpYNaXhUNLJuBrJ8bGpdPX+xIQgMIQaDTNgIbM/
         oq+8sAMpf3Fz4GJpITlOVaho4jVb3BXEOXi9fWSfMyzVt7DYSmJvYtnqsn/wYkKZ3zXA
         YEmA==
X-Gm-Message-State: APjAAAWUS/vXZCw22xyTODD3b/QuIx31zHYJ9oXIGBIkySC/G7iAnqDC
        ju5pSqWtFQEoKYTAYLiSA1UT8T6UuGnEl3XVN7IRJKuGUjueNXDlvESKOFwrp52Ov4nnQBOdD6q
        tWVmObZzwOkefFjVE
X-Received: by 2002:a19:7401:: with SMTP id v1mr1007732lfe.129.1579859606883;
        Fri, 24 Jan 2020 01:53:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQhJNQcaaDcM834fVbk7QurTLRj5MsyegI59sBDkZiVOmXuoqHNrXEWKdwQ6zpuD/sqWaBBQ==
X-Received: by 2002:a19:7401:: with SMTP id v1mr1007721lfe.129.1579859606635;
        Fri, 24 Jan 2020 01:53:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id q10sm2776696ljj.60.2020.01.24.01.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:53:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 622D1180073; Fri, 24 Jan 2020 10:53:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: improve bpftool changes detection
In-Reply-To: <20200124054148.2455060-1-andriin@fb.com>
References: <20200124054148.2455060-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 10:53:25 +0100
Message-ID: <87wo9hgoyy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Detect when bpftool source code changes and trigger rebuild within
> selftests/bpf Makefile. Also fix few small formatting problems.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Thanks for taking care of this!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

