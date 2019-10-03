Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF9C990F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 09:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfJCHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 03:35:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725613AbfJCHfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 03:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570088136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVX9o2aIsobjvj9ovzq4arMUSieRziwrjgJlpz007LQ=;
        b=dfURVNUPSJKhy7rAZbyieYRbYKVBSzYwtXPG1o6r+sO0F57ls+so7AzgFiRVDvgwojb9SD
        Y5Uu6Wp6ocWPHm2yxO0VXvxgiJt0p9ltZOcj8i8ek2fW4oU6hcaQPx4NdSlzf7+P2XEKIh
        KOSs3cS+tMhWmrAhxKX66Iq47Hp3wvM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-VroriL2eP3yio8XfZID1nQ-1; Thu, 03 Oct 2019 03:35:34 -0400
Received: by mail-lj1-f198.google.com with SMTP id m22so554098ljj.6
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 00:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9yhr1Y6R6hpoctBnwHfdToZ6WWRJL/XNPXCJTovhDIU=;
        b=M14IPt7CdMYI1TstD72HQolej1GgFP1J5qLEDFo3xcp9tPP8tz2TbOhMD4kyVIvY7J
         yvjoUXdUQKCWQ99jB/xLLk+J9OOpNHWRbtHB/C66HKBfUrar+TScDj9+Kd9UHM4itVFv
         44XUL6iK6TlE+KF9uscNDRsM/ZTIwOp2iFwi175V8bzJp9zX3D/sXZXW4vCPxoVLCZNO
         j0WuX4ez+sA61q3zxKEbh8UuoKrZzEKe6W1zXXVgA8wcrCcOYaOfP1qxm1waETeJFAUQ
         VpK7vkGkFE2obKzEEJFvnDtGmQppIk2OGuoQ42JfJa7Nymfuu3jzJTLcpiQol9QDHa5Y
         Rn9A==
X-Gm-Message-State: APjAAAUrBTrNBpx4YMmFVAelgpZLL3vhV1EwOP/ZcJg9EcjdoZ2DkkHH
        ixlPdqJqFyIZo4p2NWNE3IdDaY78yliUN9rp2NPKmiYhi7SnfDH9fY1ysthBYWsbgC+cINz22Xv
        5QW5JjEf8GAaqrbHq
X-Received: by 2002:a2e:3e09:: with SMTP id l9mr2692192lja.215.1570088133427;
        Thu, 03 Oct 2019 00:35:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzChFE89gT7cYlzbxzsN4dmLGPxh6F7LE7US0V9HALZ/1N+fiPxQ42CkJYNDvYfQXUMeylcrg==
X-Received: by 2002:a2e:3e09:: with SMTP id l9mr2692188lja.215.1570088133289;
        Thu, 03 Oct 2019 00:35:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i11sm350007ljb.74.2019.10.03.00.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 00:35:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F39B918063D; Thu,  3 Oct 2019 09:35:31 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: split off tracing-only helpers into bpf_tracing.h
In-Reply-To: <20191002215041.1083058-5-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-5-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Oct 2019 09:35:31 +0200
Message-ID: <87imp6qo1o.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: VroriL2eP3yio8XfZID1nQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> +/* a helper structure used by eBPF C program
> + * to describe BPF map attributes to libbpf loader
> + */
> +struct bpf_map_def {
> +=09unsigned int type;
> +=09unsigned int key_size;
> +=09unsigned int value_size;
> +=09unsigned int max_entries;
> +=09unsigned int map_flags;
> +};

Why is this still here? There's already an identical definition in libbpf.h=
...

-Toke

