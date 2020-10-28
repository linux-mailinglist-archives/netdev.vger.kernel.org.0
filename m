Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B717C29D350
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgJ1Vm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgJ1VmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:42:21 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1F1C0613CF;
        Wed, 28 Oct 2020 14:42:21 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id ev17so545217qvb.3;
        Wed, 28 Oct 2020 14:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PaBzC30HOBjtiicG4b94s8rB0FZ//7C+5qGGQBot4JU=;
        b=G7ns8ZocQtdrC3VvjvNb65BbakAUXQIP4hqAkOGtj9f9xUxhSjqo+9G4Sk56HbkyVB
         M0gYDzfe4MG2GjmEwm6EU+g/WQAGdZdtuFLtjG/VzTDqfBRqgfjOFRiOReqYmvqK/7PJ
         CNIUg1RztQi3+VAhZpj8KNKpJaidtjy5/uxLZOlvzhCg6Wujffbz0GW3I4rO5zXPvkA+
         xiOKywlh9ZTy0l1xSgFmSvQGs4aOSVVaXzF8p/I7jXbteu6RyBZ+DzOFjo1Id86X+K3C
         qOpop4LIWfN9RhfdloSHpUDi1whPE5K1b8sfug4H37sVbZn2rBdkTWFdRewtzcQicyes
         q+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PaBzC30HOBjtiicG4b94s8rB0FZ//7C+5qGGQBot4JU=;
        b=VF8cj+ZDhPMfw1Dy42plnix7k2Nz48/RuRWGYwNUBvHYCR7fkp1ItgDHa2cfxwdpkb
         TXErS0fCB/wmrnpd0AGLkSSpSN44CjBlPazDouovhCAKbzKCD5klyQyZzOkTj1VHejoL
         /ZQfxnZwpXDkyZknGDlMgqm5o+aS47lfqJMcAHbpSo7nlieGb3/W+bCqrjhOAbt7hnb5
         MfRLhC/x0WJkZcLxgulQE5bDFgErVJMkBVYfb6WiVfFzMFzMsKCexdEE3x9jcFHuTsB2
         skyXO+6ufQfj5SifFKF8cjrypIBCoC5Q3vID8XtKUW+wpRsX3SdgzQSOw4GJkEKV3VNb
         JMzw==
X-Gm-Message-State: AOAM532o7gOBqHOpUhn5e9QbBnq6WzSFuTAuIE2j83DdNwFYyQ4wrFf/
        CpPRW1a7+QGn3YFRKDDc+u4PEjrQwsUt7Q==
X-Google-Smtp-Source: ABdhPJy5XpztrCTp8VUvsv7HKU1FXPy9ndgvwBuDUDOupJzjeP2IIp0AscOZUG9p373OZp7VyCYpxw==
X-Received: by 2002:aa7:95a6:0:b029:155:336c:3494 with SMTP id a6-20020aa795a60000b0290155336c3494mr1132721pfk.17.1603919833214;
        Wed, 28 Oct 2020 14:17:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id q189sm492911pfc.94.2020.10.28.14.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 14:17:12 -0700 (PDT)
Date:   Wed, 28 Oct 2020 14:17:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201028211706.zahkpijmf5zdtrbi@ast-mbp.dhcp.thefacebook.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028132529.3763875-1-haliu@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 09:25:24PM +0800, Hangbin Liu wrote:
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

Awesome to see this work continue! Thank you.
