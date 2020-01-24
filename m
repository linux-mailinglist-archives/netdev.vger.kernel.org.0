Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6A147CB9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgAXJyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:54:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388341AbgAXJyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:54:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579859643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kj9LFbCnEWlNmUswLahnvJmujUVg7he2BqdXZV1Y5Fk=;
        b=eNg6tnSD2+Zi/9b0BEzWAjUoSOSWUn9Y9rrVEyPtXapuwzDwCkzIyPDjF5sxMoFnO52pUA
        F20MVeNS1pES4riqQ17btby9RR1zCvAu/nhRtUbsuDfXn7WkN+ISbCFxUsg4PXKgxFOv4W
        FeV4L+g78kQZKSqlrP50CuJIjGfa7Ps=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-x2DBE6u4NOqPII1ywrpupw-1; Fri, 24 Jan 2020 04:54:02 -0500
X-MC-Unique: x2DBE6u4NOqPII1ywrpupw-1
Received: by mail-lj1-f198.google.com with SMTP id w6so495151ljo.20
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 01:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kj9LFbCnEWlNmUswLahnvJmujUVg7he2BqdXZV1Y5Fk=;
        b=ekzsM5pmTlSapdgNANSem++Wav8sFCX4ld6kHboahpNACHvpl1xY0QlE2ZWtKVBVe6
         Z1OksPhOJ5vU9P48nyR2ES4NM80Tvp9Rl/858MIuiaa7W46OjWcEM45wzAzIDQ7IY594
         R/aU1uHnbyoI8v5fHM+M3qTx8gvlovD2f6gDBhFAlxKyEHN6CwSrFjZnSkiV7lVdh6KA
         Cet1PVH1sgTRfadT3JfRcqCB7lKnvVrYW2ofLZiQ+ANJoJe/Nw9zJ3xfNM+gj+DEdJPT
         Gt5rwljSAAg/ptRRYaXOIk+bdeA4IpjY04lOPcBE2yo0TAePV53HvYvV6yWhuQi2qgNP
         HkSg==
X-Gm-Message-State: APjAAAVkUhyv8wXkpVp1pIyHZLk6woXhutkTj6LxQg2DNsauRD76m1lc
        CotQ4YK/llVV+4Jh7CPo30a5wArGQixe3xItYdFKdSv1vVUuAhLTuWGcpzZeDPQsnh1JcxvgMMw
        gSE2etH6FBp74rEok
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr1635757ljj.253.1579859640859;
        Fri, 24 Jan 2020 01:54:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzftReY65v+672gLoSlrbrdhqxQDfkSaIpLZLXpA465IVjPRlYrI26vbajFIoCoQGQMUjPZng==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr1635752ljj.253.1579859640716;
        Fri, 24 Jan 2020 01:54:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i1sm2743068lji.71.2020.01.24.01.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 01:54:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 705BF180073; Fri, 24 Jan 2020 10:53:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: print function linkage in BTF dump
In-Reply-To: <20200124054317.2459436-1-andriin@fb.com>
References: <20200124054317.2459436-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 10:53:59 +0100
Message-ID: <87tv4lgoy0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add printing out BTF_KIND_FUNC's linkage.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

