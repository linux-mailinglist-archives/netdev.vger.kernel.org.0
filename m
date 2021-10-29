Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B985343FAD7
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhJ2Kiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231732AbhJ2Kit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635503780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zTf+kP+TTNJjwaC8Adr///Yv4cYdq6F0Z4nTu/ogXo=;
        b=UBT1VhUv2hHzpbzRWrKQjXKpMr5j1Spq7kSBBZ94Il9/TpB6nkAnMM+EeMlj8WwvOYigiY
        lznhYedekIEgTTQWM8tY0GYH+orxpGo84h69n6zCMyvpEJ5ZYrMhwHHw8SGkxygQeBmkjO
        L5IGRAFFQTzdUcJY2dYxShktI1BgCmw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-XSokmvVGMqql7FuqC886Ow-1; Fri, 29 Oct 2021 06:36:19 -0400
X-MC-Unique: XSokmvVGMqql7FuqC886Ow-1
Received: by mail-ed1-f70.google.com with SMTP id q6-20020a056402518600b003dd81fc405eso8819752edd.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6zTf+kP+TTNJjwaC8Adr///Yv4cYdq6F0Z4nTu/ogXo=;
        b=02S9cVFXHVX4O8M3YHJyXeteTVFM7EtAG1YPE/COwFOtf7PbIiThtAm1FLm2gCLxMF
         GBehKYSdZqgJMFv+4J2o5nWgATVGeYvJLxEoMNYN3QVyO8Cq6RmMetYth26wbh2Ws7xF
         oXFFHV9medBrl8+zR7Ao+4iDB9SyAp7B/Mn5JFqkSsa5PxSK/q1odMqaiVQKOyJGg4Bd
         6FZRwfYGxlFy7OYtmQnpWl4CkF0PI4z9h4qd89rGCTgxYbE4pLNd/5uZlAIKBXmS8iEn
         zPX7vXMu+XMDNc+JpIqAIABwYYjNQo+7642fmCu5qfPfbuqONTOCypPboYxAEQMeOi9j
         Mz5g==
X-Gm-Message-State: AOAM531se4K67HBLYr4neHy7qzKhxlGfjJW8UNf3acgaiZKL+GzJpHLR
        JJD+YKDhxLKqjNv3VMo2H0e023rbZ5OtiKmtuJXjcQdMbcaHDgRIN/92y6gCnQZLYMJOetx/YSw
        YjiHa2ox9qBKs9GgK
X-Received: by 2002:a17:907:868c:: with SMTP id qa12mr12174750ejc.346.1635503776876;
        Fri, 29 Oct 2021 03:36:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0vSAUG187MJcKLC8ZiB6qmj2025d/UW8QZOcijvFGVGylan+cJPkDv+Ymiqz0I7USKh4+xg==
X-Received: by 2002:a17:907:868c:: with SMTP id qa12mr12174639ejc.346.1635503775911;
        Fri, 29 Oct 2021 03:36:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a9sm3281830edm.31.2021.10.29.03.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 03:36:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1970180262; Fri, 29 Oct 2021 12:36:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2] libbpf: deprecate AF_XDP support
In-Reply-To: <20211029090111.4733-1-magnus.karlsson@gmail.com>
References: <20211029090111.4733-1-magnus.karlsson@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 Oct 2021 12:36:14 +0200
Message-ID: <87mtms86e9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Deprecate AF_XDP support in libbpf ([0]). This has been moved to
> libxdp as it is a better fit for that library. The AF_XDP support only
> uses the public libbpf functions and can therefore just use libbpf as
> a library from libxdp. The libxdp APIs are exactly the same so it
> should just be linking with libxdp instead of libbpf for the AF_XDP
> functionality. If not, please submit a bug report. Linking with both
> libraries is supported but make sure you link in the correct order so
> that the new functions in libxdp are used instead of the deprecated
> ones in libbpf.
>
> Libxdp can be found at https://github.com/xdp-project/xdp-tools.
>
> [0] https://github.com/libbpf/libbpf/issues/270
>
> v1 -> v2: Corrected spelling error
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

