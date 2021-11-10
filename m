Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914C344BD60
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhKJI41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:56:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhKJI41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636534419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cR5sqbN1957iQ/bal6X9SNI5rajv2fdoOQTfC/GcDE=;
        b=BS+2GJPORhOauX6ZxKUUWRT3Nn4SJa10an1BGNqDMouo0dhAL90v5nPRowv0yw9e6RvmFu
        ZcYHafmAbtrowpV12SFdU3jpPuo7iY5QzWS/dbN+PKPyNUVDcWfGduZ5mH0pAEbnnnbVS4
        YXolE8/vRWHkooczPXlfjGuqwEKGZVw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-FRvry2vGNsmTaR0TlN1pTA-1; Wed, 10 Nov 2021 03:53:38 -0500
X-MC-Unique: FRvry2vGNsmTaR0TlN1pTA-1
Received: by mail-ed1-f71.google.com with SMTP id w12-20020a056402268c00b003e2ab5a3370so1766040edd.0
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 00:53:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=9cR5sqbN1957iQ/bal6X9SNI5rajv2fdoOQTfC/GcDE=;
        b=RwL2/Jsax6gWRtYJMkGKrYoun3Wsx6KxdXUuh/Fl1RdxW+fEobVSscCC4qsgNf8kwM
         pxttf3Ptm2abOSHeFwzj7dtiOn1BJi7UtnPsyP6CudVniPWWIWbEgEl3KyJdVTO0ZMUl
         Bn47dtqgyFtcDyc+75rwCPqsFvcpbcHLTpkirRMX22hy9Ip9Bx/o6URIvHicsz4fBnCA
         QwRixL7Oe5dYflzSsRDtsc0GSk1X9XFvbCtYFvvVGmx+Dm98QDYAozStR2KVH2lWK0Dc
         Ro5mbAnmSLuQNn3B0qwHkwQRWhHsrpMwmYi3effbClQHtSN1YSXlFErgENjJZS5/ufbF
         87SQ==
X-Gm-Message-State: AOAM5329e1Z7lEezEYZRm6O/Xh0vhIO2xbiz8poTbRICSJNqsHjuBbIU
        BVkxFfFO+uJ2Wv8u4iitIT/92//ALr8SOrY2R2PsWuaN5J42/y0BBJY3EGPDzpbX5m6YNpf7cRF
        HkqZ+OqxWTBD2nPHB
X-Received: by 2002:a17:906:cd18:: with SMTP id oz24mr18338198ejb.166.1636534417418;
        Wed, 10 Nov 2021 00:53:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKJaoLZ/EZKOb6+YOSDdmJl1tIhkXRCt9cQq0I+y+4Q41Ds7ob43uAUnoCI9K3PLc4Ab2RUA==
X-Received: by 2002:a17:906:cd18:: with SMTP id oz24mr18338169ejb.166.1636534417199;
        Wed, 10 Nov 2021 00:53:37 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id r22sm10690912ejd.109.2021.11.10.00.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 00:53:36 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3d5a4644-62d8-8eac-fb6a-4dc9468372c3@redhat.com>
Date:   Wed, 10 Nov 2021 09:53:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Joe Stringer <joe@cilium.io>,
        Peter Wu <peter@lekensteyn.nl>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and
 .gitignore
Content-Language: en-US
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20211105221904.3536-1-quentin@isovalent.com>
In-Reply-To: <20211105221904.3536-1-quentin@isovalent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/11/2021 23.19, Quentin Monnet wrote:
> Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> 907b22365115 ("tools: bpftool: dual license all files") we made sure
> that all its source files were indeed covered by the two licenses, and
> that they had the correct SPDX tags.
> 
> However, bpftool's Makefile, the Makefile for its documentation, and the
> .gitignore file were skipped at the time (their GPL-2.0-only tag was
> added later). Let's update the tags.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Joe Stringer <joe@cilium.io>
> Cc: Peter Wu <peter@lekensteyn.nl>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Tobias Klauser <tklauser@distanz.ch>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   tools/bpf/bpftool/.gitignore             | 2 +-
>   tools/bpf/bpftool/Documentation/Makefile | 2 +-
>   tools/bpf/bpftool/Makefile               | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
> index 05ce4446b780..a736f64dc5dc 100644
> --- a/tools/bpf/bpftool/.gitignore
> +++ b/tools/bpf/bpftool/.gitignore
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>   *.d
>   /bootstrap/
>   /bpftool
> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
> index c49487905ceb..44b60784847b 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>   include ../../../scripts/Makefile.include
>   include ../../../scripts/utilities.mak
>   
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c0c30e56988f..622568c7a9b8 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>   include ../../scripts/Makefile.include
>   include ../../scripts/utilities.mak
>   
> 

