Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9ED3D2732
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhGVPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:21:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhGVPVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626969734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hva5vELoleu80vnwOXHVIvlXrtyMK1gEcb1LP/Bg0sE=;
        b=bAnTDh+Hjca4lSkK79TBCWCIinFPRduZdWTnv5Erqd2+EUfUVBbHxJEAHcGmJS0baYhSCS
        NX7nfTUI9oFM3UNfFoQKNQ6TCn7lodM3fs0c6Kj/PglJsMDQYKZAfhOcDWt63Qkt0n1+Ov
        boI5tJe3YJ1CTXJfpuh/xI9MI0Yja3k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-6vyIiIjQPSaAxEJ6Uv58Ug-1; Thu, 22 Jul 2021 12:02:13 -0400
X-MC-Unique: 6vyIiIjQPSaAxEJ6Uv58Ug-1
Received: by mail-ed1-f69.google.com with SMTP id n6-20020aa7c4460000b02903a12bbba1ebso2977774edr.6
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 09:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Hva5vELoleu80vnwOXHVIvlXrtyMK1gEcb1LP/Bg0sE=;
        b=BRmpJ375rE2O95qDhn9j4SR0kwb+0WK2FePgiNtxlgzfjG0PyUtAwvJ88ssKAR1gun
         W/TsI6kGVlGVBY3IS98zL4P5OqJD9vNRStxfoLXc3begxuW1IAvotx+Xq5obJJDkZ6aS
         8Vny3Syf/r+SZw9cKIQxLh/3818m7VdT2nKVbGNw32pIijcRfoIqu7PSGpLtzpwF1jYF
         GNfd8w9reGnqoIYAfdjt6LhEw3VRMttPx1/rWrFUetdfAA/Outkr6MumghIDn5gAQOxC
         bfNRxUBzWJBjqNh6Uw/2s7+UjSo20zB7PaCp40Q915FgKp84j4NKrgHl+rWnbauHREgT
         d51g==
X-Gm-Message-State: AOAM533vbEeTjvTevr++zHj7kGdxpXnDQofpr5XMo1K29cUqKIOksspC
        VF8Cmb/E0ViCzCKdpwPigiIRa7+McMHSzPxdWdVucBSIj+e56mHAGuTThEb6+pRFT1aIV2DwXco
        TsSLKxMii/iv3jpzx
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr565401ejb.187.1626969731816;
        Thu, 22 Jul 2021 09:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycmiIAoSzdAdAmayQM6GAkHX69bNZ/yHswCVn44aXv8niWoNvdHHOcE4YQwu0ybKadbnu5gg==
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr565376ejb.187.1626969731460;
        Thu, 22 Jul 2021 09:02:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jp26sm9743574ejb.28.2021.07.22.09.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 09:02:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DADC718031E; Thu, 22 Jul 2021 18:02:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] libbpf: Move CO-RE logic into separate file.
In-Reply-To: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
References: <20210721000822.40958-1-alexei.starovoitov@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Jul 2021 18:02:09 +0200
Message-ID: <871r7q8hha.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> From: Alexei Starovoitov <ast@kernel.org>
>
> Split CO-RE processing logic from libbpf into separate file
> with an interface that doesn't dependend on libbpf internal details.
> As the next step relo_core.c will be compiled with libbpf and with the kernel.

Interesting! What's the use case for having it in the kernel as well? :)

-Toke

