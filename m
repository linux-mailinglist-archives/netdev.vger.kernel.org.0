Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E040433EF44
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCQLIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:08:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhCQLHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615979263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sFmaH41LDlPjG9Ynwp45uLWY+uwr7N1DcuUG5izOuw8=;
        b=OLgkObXWJ7fGt+ohsMwHrhWMqQFtagOkSVoDENf8RAVzuSr7W/8iO3zEjISyAsH3i/tyc8
        fTUUiu4wWr+fWatg57+1V9Gm1/mmL0MwaTHH6X9uHr3vickMxUn0htqZPP5mDpeMZZKYR3
        qTOecSjjHqgVinlYbZGWZU8sE5vEW2g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-HbcAgBoGPK2pixk1jXUGbw-1; Wed, 17 Mar 2021 07:07:42 -0400
X-MC-Unique: HbcAgBoGPK2pixk1jXUGbw-1
Received: by mail-ej1-f71.google.com with SMTP id si4so15099690ejb.23
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sFmaH41LDlPjG9Ynwp45uLWY+uwr7N1DcuUG5izOuw8=;
        b=jkLkRRWyiNkEBdrQU82M/TTvn6zzbUXtD54TN7ZddzOoU3ckh0fnBpbEq3tyLYVavw
         5Gidmnvk5IX4ICa4LJ80/NbVunu3cYRTTPooh2yM5NYB15FTu6Mjq1TXLTe1gOS1E692
         9jLqfs30mC4zD3A5zVD1sovfyX0rOnQ9rnvS2SbPD0I3G96AIgmO9FDxiUEo8lUxUNWK
         rE+e75SfwGEVN2ukOSKv2R3sE2JhfQ1cmUViT+hSYt+waViaUcjO3rF+GeUOr6gQTjKN
         v8wJfYKJJGhq5fDq44GxWHwZJ/sv1CqyXhh0M7EqFiSbeXWTLW3unqjqqWbADOcdjXFq
         pdbw==
X-Gm-Message-State: AOAM5320thvu2/SsLsVwP22UWLQjAbpjxG0+GGxJ4RQApX8DFkbDsz9M
        0ESXWJWAlBvwEWyAkpQQJ+TaGEVjnvivwrLOS35lPw1jhRy9SS4lDlkLqOueFjGFYSyltW6ytVi
        wWb8mzgd6YuU6lgmJ
X-Received: by 2002:a17:906:2314:: with SMTP id l20mr35375416eja.178.1615979260620;
        Wed, 17 Mar 2021 04:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylmtlvBiYwpe22USdjn0rPdjb/Edoq2N3MMGbDCmY44u09j1aukE8925/xi14GcDNAZySNvg==
X-Received: by 2002:a17:906:2314:: with SMTP id l20mr35375374eja.178.1615979260206;
        Wed, 17 Mar 2021 04:07:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a22sm11341585ejr.89.2021.03.17.04.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:07:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 36DC8181F55; Wed, 17 Mar 2021 12:07:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libbpf: use SOCK_CLOEXEC when opening the netlink socket
In-Reply-To: <20210317104512.4705-1-memxor@gmail.com>
References: <20210317104512.4705-1-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Mar 2021 12:07:39 +0100
Message-ID: <87y2emca2s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> Otherwise, there exists a small window between the opening and closing
> of the socket fd where it may leak into processes launched by some other
> thread.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

FYI, you should be tagging patches with the tree they are targeting. In
this case probably the 'bpf' tree (so [PATCH bpf] in the subject).

Also, a Fixes: tag would be nice here?

-Toke

