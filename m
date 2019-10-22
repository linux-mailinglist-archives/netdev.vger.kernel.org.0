Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68672DFE58
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 09:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbfJVHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 03:35:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbfJVHfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 03:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571729746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DqnUKo3S/v+DMaC4AeuuAiOBCkX6zM+VypHM27CSLgk=;
        b=B4cYBdv6DRzuaJx8Picvl5r1hM689523lrg2GH7gmLbPi0ztBwsM67ZNyQwJ8fDAwuxWP0
        sPX97rlX25c04mLZ/ZP5pcdEPlX3tNhzdE19YV4edi9icGmAG4Jw+K29ExB2L9Dbm/Om+y
        lNch38SH8JPSM4k1g6AnOHIvPxIAItM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-nqFqGAh_NEGLd_BjzlDODw-1; Tue, 22 Oct 2019 03:35:44 -0400
Received: by mail-lf1-f69.google.com with SMTP id r21so1220260lff.1
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 00:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DqnUKo3S/v+DMaC4AeuuAiOBCkX6zM+VypHM27CSLgk=;
        b=ZbAFREaY/L+LmlQIWzC95xTf6zCWolCFBBPPEV25gSh0iqg65s1rz1AfVxEdsRY1D+
         byTGRfuKEC78MJqj8UVunQgg0mKDqvjRGoPBof3N7EAhoRzNB7/2v5jSqneOdQpSFg0x
         Ky3qIknuIm88AtnB03J0/t7pUG4zM1nKJJwM+G71BR5edPnQ4sHDfYyKb6NsE3A1kYDZ
         6pkojQdbMtUX1PahnoUhEF/P2no4lxoLfJNLc3h5SGofnK/AHp8q2nshfhaqIOp0sbBK
         AUSVUXJ6Yg7mKb7rlkqZs1yOV9taY7w6aeXkm3pCD5ez48mSGvfEQaRWr1rrJMKjmKSy
         CbVQ==
X-Gm-Message-State: APjAAAXdUxZhr4e9/mqbqp/GMRgp3VvV7qcX+h/KvDXPUaODYPkfszYr
        QQGwmoGqmszw3F/P0Z7d+v+j8U1EQQdmbs0ut/J8kRoxvageX5MWSwFP8Xydgpfgicg5rrS19d0
        2XLZJHxyr1cCwEryx
X-Received: by 2002:a2e:6101:: with SMTP id v1mr17785797ljb.132.1571729743085;
        Tue, 22 Oct 2019 00:35:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyjbZ9S8P/PhkdhD0q8yTvPk2jIKTwlJxy3YnyEuqRyLVmXnHeuMGWT3JSEDGyuxE0xYB4xnA==
X-Received: by 2002:a2e:6101:: with SMTP id v1mr17785784ljb.132.1571729742798;
        Tue, 22 Oct 2019 00:35:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i128sm7770121lfd.6.2019.10.22.00.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 00:35:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9A4911804B1; Tue, 22 Oct 2019 09:35:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, sridhar.samudrala@intel.com
Subject: Re: [PATCH bpf-next v3] libbpf: use implicit XSKMAP lookup from AF_XDP XDP program
In-Reply-To: <20191022072206.6318-1-bjorn.topel@gmail.com>
References: <20191022072206.6318-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 09:35:40 +0200
Message-ID: <87ftjlp703.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: nqFqGAh_NEGLd_BjzlDODw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
> eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
> which means that the explicit lookup in the XDP program for AF_XDP is
> not needed for post-5.3 kernels.
>
> This commit adds the implicit map lookup with default action, which
> improves the performance for the "rx_drop" [1] scenario with ~4%.
>
> For pre-5.3 kernels, the bpf_redirect_map() returns XDP_ABORTED, and a
> fallback path for backward compatibility is entered, where explicit
> lookup is still performed. This means a slight regression for older
> kernels (an additional bpf_redirect_map() call), but I consider that a
> fair punishment for users not upgrading their kernels. ;-)
>
> v1->v2: Backward compatibility (Toke) [2]
> v2->v3: Avoid masking/zero-extension by using JMP32 [3]
>
> [1] # xdpsock -i eth0 -z -r
> [2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/
> [3] https://lore.kernel.org/bpf/87v9sip0i8.fsf@toke.dk/
>
> Suggested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

