Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C6633F0DA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCQNFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhCQNEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615986285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5K1eWFevd/HHcWFLKscE1HUL+tCoTqGMwfzyUYEhIo=;
        b=bbuansKa21ji/52OzFrkNTr4b1CKgmQeV+wp2DjisLJeSwit/VXzASsKUbqwioX3g4LVI7
        /pIWG4PSoMx3VYBHSinC94r55nQfCQb3MMPpx7l3dT6GqlNcUne2yqTzJbRM8xHPZeZl6n
        uAhNaqDEgC9rzFwjZCbIpiCJQ73j0VU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-KmvnD66vPP69WjvFHmtdDg-1; Wed, 17 Mar 2021 09:04:41 -0400
X-MC-Unique: KmvnD66vPP69WjvFHmtdDg-1
Received: by mail-ed1-f70.google.com with SMTP id i6so19425805edq.12
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 06:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=h5K1eWFevd/HHcWFLKscE1HUL+tCoTqGMwfzyUYEhIo=;
        b=F4pXLhx/7KW1YJnFuKnSSzXaKDrwubYyl1ayBT03h3kkPdP0vQKH9cXan67dKEnReW
         U4AcLE1l9SiIeIwWPR39VVp0jrBhpUuGPXbimmHS48H9Qg98LcCE4o6R/sUs9ifpho4x
         zc/MUIENiXwgNa2wnkC0gdfTML/GiMJuG5jNEGfi9b0D0NbdGEN3zC2DRzskjud/Sy8X
         JTdDbytOrwZYPbDp6mkLfU7i6C3im0O2NdF3Z2Is802QVUBAMv/fzDQ0ElF9Rs+ZkF0Y
         dh4BowiFlJVNGSNtHjqo0Ker+ctWc305HNiyw0Tia/ClcHZ0RklsS2lo1hoAqGHFI8q0
         UE9Q==
X-Gm-Message-State: AOAM532+N65V4WMnkXLChPGChLKVMlQLw2fzC/bFKPyD0c9YNUCvjP0p
        8NhHjVLbg8f7n9zMXzgDcahf8qV3NtsKZIiuatK5WY6pblQNE4uqS4v7Hnd3+XYa9tcQRwpWZk2
        yBAz8+HetsWzrBJcV
X-Received: by 2002:aa7:d98b:: with SMTP id u11mr42842200eds.352.1615986280713;
        Wed, 17 Mar 2021 06:04:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyDhSRwms9eliBndoHdtnij7qZI8LvV0vW97nB6OL4IrtYBHURFzssnERHOda1/sbEJA5eYQ==
X-Received: by 2002:aa7:d98b:: with SMTP id u11mr42842187eds.352.1615986280598;
        Wed, 17 Mar 2021 06:04:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x1sm1426421eji.8.2021.03.17.06.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 06:04:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 73A53181F55; Wed, 17 Mar 2021 14:04:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, ast@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2] libbpf: use SOCK_CLOEXEC when opening the
 netlink socket
In-Reply-To: <20210317115857.6536-1-memxor@gmail.com>
References: <20210317115857.6536-1-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Mar 2021 14:04:38 +0100
Message-ID: <87lfamc4nt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> Otherwise, there exists a small window between the opening and closing
> of the socket fd where it may leak into processes launched by some other
> thread.
>
> Fixes: 949abbe88436 ("libbpf: add function to setup XDP")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

