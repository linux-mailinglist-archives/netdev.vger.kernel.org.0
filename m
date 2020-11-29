Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE032C783E
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 07:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgK2GRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 01:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgK2GRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 01:17:32 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413C0C0613D3
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 22:16:52 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t21so7747375pgl.3
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 22:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=31+s0q7ELwy1refrSvrmUs31CNRUozjyv/fhDb62J7o=;
        b=aeRcnrJjrOgI3CrnMQuoNe7diwfO/PE7YIhUymvETvBC9jABpXcwA+rgFpaYW61qt4
         tTZZL/kD03QKCl3sBU6zTlQ4a50C9EAU/V70x+24YA5n0z55MBUZsxcf4qTX1m7HvsDH
         y1g0a5Iat/JjJWjIP8FjHgNa89NLghklSQpdufOQZ2JcfUtqTA6Zm146pGTElstTVouN
         4ifT4KTt83iW7lM1UnnfaYELWh/2V510ddo9iEEGtt6RGCn8WFcB7hAn8HvjyyvFZfBy
         PcJKWOpeyEf29mqFUMhl1TKFxtNkny0TSNRsl20PRF0nDKD45GFXlXrhlxF410OVQgqK
         ZkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=31+s0q7ELwy1refrSvrmUs31CNRUozjyv/fhDb62J7o=;
        b=IKtNhD4xLOk+ufGm7KFlBIL3MNcAK+u4sEzZjcwat+4tcQO7ENkqc3tbdhSMx9fu95
         mvtSvz2cH+q8MU4dB2ZhyJRIw+Cc9cZDDEPS8ictkYSKSd0dbwXv14MWe1D/5oYerwAx
         X0KVL6Kt0n9rLHOigHpmH2ZxVGFznIof1BFKD9QeEAHI37fiUMMnY4Y5YDpIbyq+IaHg
         FSnf+179QuLP7lMIvKhmPNZIiS9b7U9TTDx02XhVKk72UmS6hubNWWvpLgEQj6FcqnaT
         9qd/eHu1S3b5epPJ5bY+dgaHkHZx15DvEMZ0Vqp+1oo7VTtsnFvPGzUMleMZwmZILJMi
         MdQw==
X-Gm-Message-State: AOAM5302Q7M3lXBj4ZEQI215asYmsX7QNNO2gFIWg/OQXzwzSwKaDoIn
        zMvLVW57WMQebXqVQmtYFAISzw==
X-Google-Smtp-Source: ABdhPJw+oqpKo6th2shFrfO0jESPXweMYYpL26TIKkYiXJ1FqbvQmSj3P2ZxP/e1RxAan+ZHuNKxnw==
X-Received: by 2002:a63:4106:: with SMTP id o6mr12781088pga.38.1606630611628;
        Sat, 28 Nov 2020 22:16:51 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m9sm17753207pjf.20.2020.11.28.22.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 22:16:51 -0800 (PST)
Date:   Sat, 28 Nov 2020 22:16:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201128221635.63fdcf69@hermes.local>
In-Reply-To: <20201023033855.3894509-1-haliu@redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 11:38:50 +0800
Hangbin Liu <haliu@redhat.com> wrote:

> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
> 
> This is achieved by checking for libbpf at './configure' time, and using
> it if available. By default the system libbpf will be used, but static
> linking against a custom libbpf version can be achieved by passing
> LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> abort if no suitable libbpf is found (useful for automatic packaging
> that wants to enforce the dependency).
> 
> The old iproute2 bpf code is kept and will be used if no suitable libbpf
> is available. When using libbpf, wrapper code ensures that iproute2 will
> still understand the old map definition format, including populating
> map-in-map and tail call maps before load.
> 
> The examples in bpf/examples are kept, and a separate set of examples
> are added with BTF-based map definitions for those examples where this
> is possible (libbpf doesn't currently support declaratively populating
> tail call maps).


Luca wants to put this in Debian 11 (good idea), but that means:

1. It has to work with 5.10 release and kernel.
2. Someone has to test it.
3. The 5.10 is a LTS kernel release which means BPF developers have
   to agree to supporting LTS releases.

If someone steps up to doing this then I would be happy to merge it now
for 5.10. Otherwise it won't show up until 5.11.
