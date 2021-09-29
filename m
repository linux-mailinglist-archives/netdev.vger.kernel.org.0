Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACA741CD7C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346771AbhI2Ukw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345611AbhI2Ukv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 16:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632947949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1q2iWY5x6NtiyghS9gn8oPV2bKVir0LZN4nVYY52WSw=;
        b=cTY2oDsj+KN+FtRpjmsokxrf/XUk2RMXXl801EK63FLSP9D4t4CScj5iqdlzVylL6aouJ9
        H0CgwXBWkc0t2z03PTckfavj4xg/H01Qq5i6mton3iKxUCKcXZYUwDySI8lVMQLXmAzfCt
        x1dNRs65h0UJY0dT7EtXlrsaQkHAVzc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-ebCkog-zOs2VD6mDg6_BGA-1; Wed, 29 Sep 2021 16:39:08 -0400
X-MC-Unique: ebCkog-zOs2VD6mDg6_BGA-1
Received: by mail-ed1-f70.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so3483845edj.21
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 13:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1q2iWY5x6NtiyghS9gn8oPV2bKVir0LZN4nVYY52WSw=;
        b=VEJQ5478nuh7RPTpOSjtIrAbuffaC0a1ZJL9MvwFdwgkDv+RjwRA9MP20YF0v6W+Sj
         jB/ANIqrztmE4EE1ClqsczV8O7Wjc6GshlwDNghbxdJ2Qg4qqzsN3xVXkQ+tihGqjjk5
         41Zd5+nOp47yH3+kXRbpuqeyY6sPL+MrmEEdiCT6PuUNb8xyP5EbGp9JDIYixd0dX+6Q
         8Hj6CHTfNaNFAraex6YaSKataLVxiaCqatOr4zviw0QZyy374nKKnZsvuztMlCjToI07
         5hM+VhX5HokX11H97ZToe+TcO92CtUbS+9ZM474MP/rWS1JIYFGYJ1M44GTkR36h77vW
         IFZA==
X-Gm-Message-State: AOAM532mmHnsn47nSZBN9O4VF8SpBQTAHSF02PL6jaQh9NP2ipjsCuRI
        ZnO2tTaqztvc9bOBHSJLdi9DlGv1qIO2IkcGIVObTZ4BFHFpwCZrLnP4kDTNnKYmwzVfUhYSems
        uIhwpceM5N8FMbXgs
X-Received: by 2002:a05:6402:847:: with SMTP id b7mr2454877edz.242.1632947946873;
        Wed, 29 Sep 2021 13:39:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfFNcYoblnlae3U4yRwj0z0K5t3IzH+wSxByDMfEUiBPCc7QN8JJkD0RlKmLnCKsCQnU47yQ==
X-Received: by 2002:a05:6402:847:: with SMTP id b7mr2454830edz.242.1632947946525;
        Wed, 29 Sep 2021 13:39:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v13sm504982edr.0.2021.09.29.13.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 13:39:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E2F4718034F; Wed, 29 Sep 2021 22:39:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
 <87v92jinv7.fsf@toke.dk>
 <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
 <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
 <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Sep 2021 22:39:03 +0200
Message-ID: <87mtnvi0bc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 29 Sep 2021 11:54:46 -0700 Alexei Starovoitov wrote:
>> I'm missing something. Why do we need a separate flush() helper?
>> Can't we do:
>> char buf[64], *p;
>> p = xdp_mb_pointer(ctx, flags, off, len, buf);
>> read/write p[]
>> if (p == buf)
>>     xdp_store_bytes(ctx, off, buf, len, flags);
>
> Sure we can. That's what I meant by "leave the checking to the program".
> It's bike shedding at this point.

Yeah, let's discuss the details once we have a patch :)

-Toke

