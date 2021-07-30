Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28023DB91E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhG3NNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:13:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238745AbhG3NNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 09:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627650817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DvyXapxVzn+zrn+bjqa/tYPCaA3lgxakfkU7dEkt2Gk=;
        b=N/glq5dWiufBFcqIXf41uSBX8hakjkXggDZ/AwZM/eiro+hyM2zMQTWlXVJzOhyo8gYU+G
        JTEE3gV90ZnP7qttyp1i0+aPAuPIqtMyYSD4qSOo447UShLjq45fmI8WcE22/iEV5meHcs
        1/JKFcv72ZwITNlKH93b6YyJOAIG0Hw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-60GCsVaTPHGmo3SdMsczWw-1; Fri, 30 Jul 2021 09:13:36 -0400
X-MC-Unique: 60GCsVaTPHGmo3SdMsczWw-1
Received: by mail-wm1-f71.google.com with SMTP id n10-20020a05600c4f8ab029024eabacb065so1590904wmq.2
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DvyXapxVzn+zrn+bjqa/tYPCaA3lgxakfkU7dEkt2Gk=;
        b=a1CEcA2AL2qugv3HmvpaMDzWkwVlAc91t6XHq9I9Ee6yw4AfNSzOOf3eD1/r7KZeOK
         99Dz//E8AQtFOmn7OgHMJsnyNpGluVpTprAFBy46B4WVWTHqSwWdXlmb8/Xqh+KDtPrz
         3UOxwDlUvoV7MpbCMMo/LHM1TjfoxOlOemIA4dVfka/gCiv5HQwlrDJsQCH3kxRhsOUU
         BYCwgVDazwSIv8X3tP55v25y1epNRNEkHd4EmqSr3Wz8VZCWoTAYv87iNqT/UX1PCeLu
         pfPIHlqR5e0KvOkFpuM9C4aC1Orsf0ZZ1W1+RQw4K4V6hxE94DJMD14D8zu0M6p+L+qZ
         j1ZA==
X-Gm-Message-State: AOAM530aMPap+g1RTKBiOTFjAfRa4sUqd4CJ2iSySYNdP0kIla1VgjOV
        ROnnkbVT5unhjmqB6ft51mgsvSLifA85aaMO0ai4m18deMK6D+0vYz7hNXy94bMdTZ1VJiHVbBI
        A/jGcix99P/s47pw7
X-Received: by 2002:a5d:504d:: with SMTP id h13mr1681127wrt.132.1627650815260;
        Fri, 30 Jul 2021 06:13:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD2MsKHFFU4eOyDr26wAYTuvNeP0131zeNhnr5KNwTAgbS7faVz5h/KI8ty6cYFADK7C8aww==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr1681103wrt.132.1627650815058;
        Fri, 30 Jul 2021 06:13:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-57.dyn.eolo.it. [146.241.97.57])
        by smtp.gmail.com with ESMTPSA id x12sm1775128wrt.35.2021.07.30.06.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 06:13:34 -0700 (PDT)
Message-ID: <bc53b476f8a3a1bafb73c2f5072c0bad03bc1709.camel@redhat.com>
Subject: Re: [PATCH] sock: allow reading and changing sk_userlocks with
 setsockopt
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Date:   Fri, 30 Jul 2021 15:13:31 +0200
In-Reply-To: <20210730105406.318726-1-ptikhomirov@virtuozzo.com>
References: <20210730105406.318726-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-30 at 13:54 +0300, Pavel Tikhomirov wrote:
> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
> is enabled on it, but if one changes the socket buffer size by
> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
> 
> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
> restore as it first needs to increase buffer sizes for packet queues
> restore and second it needs to restore back original buffer sizes. So
> after CRIU restore all sockets become non-auto-adjustable, which can
> decrease network performance of restored applications significantly.

I'm wondering if you could just tune tcp_rmem instead?

> CRIU need to be able to restore sockets with enabled/disabled adjustment
> to the same state it was before dump, so let's add special setsockopt
> for it.
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> Here is a corresponding CRIU commits using these new feature to fix slow
> download speed problem after migration:
> https://github.com/checkpoint-restore/criu/pull/1568 
> 
> Origin of the problem:
> 
> We have a customer in Virtuozzo who mentioned that nginx server becomes
> slower after container migration. Especially it is easy to mention when
> you wget some big file via localhost from the same container which was
> just migrated. 
>  
> By strace-ing all nginx processes I see that nginx worker process before
> c/r sends data to local wget with big chunks ~1.5Mb, but after c/r it
> only succeeds to send by small chunks ~64Kb.
> 
> Before: 
> sendfile(12, 13, [7984974] => [9425600], 11479629) = 1440626 <0.000180> 
>  
> After: 
> sendfile(8, 13, [1507275] => [1568768], 17957328) = 61493 <0.000675> 
> 
> Smaller buffer can explain the decrease in download speed. So as a POC I
> just commented out all buffer setting manipulations and that helped.
> 
> ---
>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  2 ++
>  include/uapi/asm-generic/socket.h     |  2 ++
>  net/core/sock.c                       | 12 ++++++++++++
>  6 files changed, 22 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 6b3daba60987..1dd9baf4a6c2 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -129,6 +129,8 @@
>  
>  #define SO_NETNS_COOKIE		71
>  
> +#define SO_BUF_LOCK		72
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index cdf404a831b2..1eaf6a1ca561 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -140,6 +140,8 @@
>  
>  #define SO_NETNS_COOKIE		71
>  
> +#define SO_BUF_LOCK		72
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index 5b5351cdcb33..8baaad52d799 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -121,6 +121,8 @@
>  
>  #define SO_NETNS_COOKIE		0x4045
>  
> +#define SO_BUF_LOCK		0x4046
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 92675dc380fa..e80ee8641ac3 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -122,6 +122,8 @@
>  
>  #define SO_NETNS_COOKIE          0x0050
>  
> +#define SO_BUF_LOCK              0x0051
> +
>  #if !defined(__KERNEL__)
>  
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index d588c244ec2f..1f0a2b4864e4 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -124,6 +124,8 @@
>  
>  #define SO_NETNS_COOKIE		71
>  
> +#define SO_BUF_LOCK		72
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3eea6e0b30a..843094f069f3 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1357,6 +1357,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>  		ret = sock_bindtoindex_locked(sk, val);
>  		break;
>  
> +	case SO_BUF_LOCK:
> +		{
> +		int mask = SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK;

What about define a marco with the above mask, and avoid the local
variable declaration and brackets??!

Thanks!

Paolo

