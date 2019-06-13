Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E590244EFE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFMWNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:13:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38940 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFMWNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:13:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so108659pfe.6
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 15:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vBpV239lVZGsVFttEgs6I1loquWTjGM2fybPXSc6kXE=;
        b=zF/ntvzau96uXYha0NGrQYwz8Sn8ybozie8+n1svcbT2JMl8P9RmSLT1Spc6zV024K
         LsMRy+UOABU6LMgIS/IZpEp6mfxSS6XrIxrgBSc7pLpMpyrkMYiX+hbT/16LeAP85J8Q
         KovE8gKHVdjiILwA/eDiX+WPqsnrx//bMQHpFkbjxKX7qGI+AWeXDQZW4/Mc3wpjX/oh
         60OpiPvdD+DmyNLUCwr8ybxFyBZDU0SGB49YGosURVSijxEpYXDXnI+AwTUc5voEvSRO
         dWWf0nqmQGYbkLq/K6kiEPWBNjwvyt4Xm5lpx2Nff2QHRHL+B2jv8Vie4H+ftaoDi6ow
         gdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vBpV239lVZGsVFttEgs6I1loquWTjGM2fybPXSc6kXE=;
        b=kTA+fZo8z+LSsxuMf1nf6B5zQry7il7/Xxx6+sCYof88w2BiHETsUERmI1j/CDfzA7
         keuROZtIVQch/IzCfikXZk0C+j8Tg1zpSlxsjE8Gkpz/M6EpnduRpGTAN7TzSGOfrvQt
         AkoIkQmFykLon+VuC2iyuNAkFHpf3TI55b5vse+uzM9nNZfKK+Hr0u/c1ix5m3o2eHb3
         Gha0KAtmlHyKqFoxAfwDzDPCO/u93sO+asXswEbzuZ7RaHlDt+0x1P01jqn1x9qElq1F
         2A1MbKTeLjSEGmpnZaXMm4Ya3X5/g8r4n1AnTEMjLV+kb8JLM9VKMMLpzbpfNwKsaUXi
         X1/A==
X-Gm-Message-State: APjAAAUuF/QFaV2NcWhpCKojglN++jllomEAoSVrmr6WcUk17PElUWl9
        z4Th8bRW/nnS2YlXP7F8/d5aaA==
X-Google-Smtp-Source: APXvYqzW7UzSpBgBw41cIlZh4MHki33bwIjljD7aQxSQSHGuM7qhtjsFYIfrPg7/35SWtKNBSAkxDg==
X-Received: by 2002:aa7:8dd2:: with SMTP id j18mr26011901pfr.88.1560464016997;
        Thu, 13 Jun 2019 15:13:36 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 128sm660652pfd.66.2019.06.13.15.13.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 15:13:36 -0700 (PDT)
Date:   Thu, 13 Jun 2019 15:13:35 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 0/3] bpf: net: Detach BPF prog from reuseport
 sk
Message-ID: <20190613221335.GD9636@mini-arch>
References: <20190613215959.3095374-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613215959.3095374-1-kafai@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13, Martin KaFai Lau wrote:
> v3:
> - Use rcu_swap_protected (Stanislav Fomichev)
> - Use 0x0047 for SO_DETACH_REUSEPORT_BPF for sparc (kbuild test robot <lkp@intel.com>)
> 
> v2:
> - Copy asm-generic/socket.h to tools/ in the new patch 2 (Stanislav Fomichev)
> 
> This patch adds SO_DETACH_REUSEPORT_BPF to detach BPF prog from
> reuseport sk.

For the series:

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Martin KaFai Lau (3):
>   bpf: net: Add SO_DETACH_REUSEPORT_BPF
>   bpf: Sync asm-generic/socket.h to tools/
>   bpf: Add test for SO_REUSEPORT_DETACH_BPF
> 
>  arch/alpha/include/uapi/asm/socket.h          |  2 +
>  arch/mips/include/uapi/asm/socket.h           |  2 +
>  arch/parisc/include/uapi/asm/socket.h         |  2 +
>  arch/sparc/include/uapi/asm/socket.h          |  2 +
>  include/net/sock_reuseport.h                  |  2 +
>  include/uapi/asm-generic/socket.h             |  2 +
>  net/core/sock.c                               |  4 ++
>  net/core/sock_reuseport.c                     | 24 +++++++++
>  .../include}/uapi/asm-generic/socket.h        |  2 +
>  .../selftests/bpf/test_select_reuseport.c     | 54 +++++++++++++++++++
>  10 files changed, 96 insertions(+)
>  copy {include => tools/include}/uapi/asm-generic/socket.h (98%)
> 
> -- 
> 2.17.1
> 
