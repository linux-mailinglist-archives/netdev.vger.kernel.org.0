Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF75299321
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786789AbgJZQ6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:58:08 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:38770 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1786740AbgJZQ5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 12:57:34 -0400
Received: by mail-vs1-f68.google.com with SMTP id b3so5185930vsc.5
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 09:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0IxDbw9xkqiRVjMXASTPx8jLKp0WDhukG7QJqTfdjM=;
        b=RfB8rPwjTA8vs3E4K0ZnlkEs3pC7qo0cqceU3vJpfmcdf24Z+E6Jt+ETsXZSJjcxjR
         UR0TOtj/NLEDWilkee0H9Mb787VHCc9Ab+boZIUrhzTLGIzGyCbOF5zjB0vKMlewdEMK
         u0gLdIqrEwDC+kXzOwdV3BKPuCS4qMO2hVNOftHYqDeIBwkkMPVCbg9eSMUl41wBN1Dk
         POy3ShUIQtOQUbcjNwTfQIarlS4x679gUxlein935yq0X22uDWo6f92fGAl0rsyArYwl
         XoeJngjPMZ4l5G0jOkIPxUFFlL0AtqNuzoIsQQFiIa+fkw2k6BZeIDMTDQfHqDIwyVi9
         oHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0IxDbw9xkqiRVjMXASTPx8jLKp0WDhukG7QJqTfdjM=;
        b=odLw4xA3xS8p9h8B6KaUEEbOOG4mCGfoIMLef4RrvxnV5FikliQNdp3r38F8C/8JLX
         Be5ty1igH7dVqJFSjlQxXlXRdRVn1qpuUKnzt5Ko5VUFDo9CSdpxDNFdEas+grvpGUE+
         WJhBk1I9aB9BOm1+tAcRoEymzp8vroORv/0qFwyGrqocRMKczb+FKrfzKgVYPhV6+s2F
         cIYiIFLB7OcVDJJq+QHkFHS0jl67ZEcnTD48JFSoNh7nbaUnUiafuh3rVpiQzGR9rwL0
         W4l5fXV/VLEe9NXJlpe2TVgYPOEtnrBVmRa9l/Aioks8OgZIc9gPvjyv7JqF5uk2y+9i
         XG6w==
X-Gm-Message-State: AOAM531Wj0dW5Uf/8D/ZswPnf+4ebnDoNUcptg/S3LJbo82OGiCG5dEu
        siA1EyTQxPYm3biNlnSP3hWf2jcX/GQ=
X-Google-Smtp-Source: ABdhPJw8ZVmP51Bfb+AEMb979J2pW9UcoTjPK9T+WjCJ9xGwHnW960Yfuny/tQxYA3ySCrfYr2o3SA==
X-Received: by 2002:a67:c90b:: with SMTP id w11mr21772394vsk.25.1603731451700;
        Mon, 26 Oct 2020 09:57:31 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id b13sm1148711vsm.16.2020.10.26.09.57.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 09:57:30 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id n18so5197646vsl.2
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 09:57:29 -0700 (PDT)
X-Received: by 2002:a67:b607:: with SMTP id d7mr19582090vsm.28.1603731449199;
 Mon, 26 Oct 2020 09:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201026150851.528148-1-aleksandrnogikh@gmail.com> <20201026150851.528148-3-aleksandrnogikh@gmail.com>
In-Reply-To: <20201026150851.528148-3-aleksandrnogikh@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 26 Oct 2020 12:56:52 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeR5n4xSpzMxAYX=kyy0aJYz52FVR=EjqK8_-LVqcqpXA@mail.gmail.com>
Message-ID: <CA+FuTSeR5n4xSpzMxAYX=kyy0aJYz52FVR=EjqK8_-LVqcqpXA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] net: add kcov handle to skb extensions
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 11:11 AM Aleksandr Nogikh
<aleksandrnogikh@gmail.com> wrote:
>
> From: Aleksandr Nogikh <nogikh@google.com>
>
> Remote KCOV coverage collection enables coverage-guided fuzzing of the
> code that is not reachable during normal system call execution. It is
> especially helpful for fuzzing networking subsystems, where it is
> common to perform packet handling in separate work queues even for the
> packets that originated directly from the user space.
>
> Enable coverage-guided frame injection by adding kcov remote handle to
> skb extensions. Default initialization in __alloc_skb and
> __build_skb_around ensures that no socket buffer that was generated
> during a system call will be missed.
>
> Code that is of interest and that performs packet processing should be
> annotated with kcov_remote_start()/kcov_remote_stop().
>
> An alternative approach is to determine kcov_handle solely on the
> basis of the device/interface that received the specific socket
> buffer. However, in this case it would be impossible to distinguish
> between packets that originated during normal background network
> processes or were intentionally injected from the user space.
>
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> --
> v2 -> v3:
> * Reimplemented this change. Now kcov handle is added to skb
> extensions instead of sk_buff.
> v1 -> v2:
> * Updated the commit message.
> ---
>  include/linux/skbuff.h | 31 +++++++++++++++++++++++++++++++
>  net/core/skbuff.c      | 11 +++++++++++
>  2 files changed, 42 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index a828cf99c521..b63d90faa8e9 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4150,6 +4150,9 @@ enum skb_ext_id {
>  #endif
>  #if IS_ENABLED(CONFIG_MPTCP)
>         SKB_EXT_MPTCP,
> +#endif
> +#if IS_ENABLED(CONFIG_KCOV)
> +       SKB_EXT_KCOV_HANDLE,
>  #endif
>         SKB_EXT_NUM, /* must be last */
>  };
> @@ -4605,5 +4608,33 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
>  #endif
>  }
>
> +#ifdef CONFIG_KCOV
> +
> +static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle)
> +{
> +       /* No reason to allocate skb extensions to set kcov_handle if kcov_handle is 0. */

If the handle does not need to be set if zero, why then set it if the
skb has extensions?

> +       if (skb_has_extensions(skb) || kcov_handle) {
> +               u64 *kcov_handle_ptr = skb_ext_add(skb, SKB_EXT_KCOV_HANDLE);

skb_ext_add and skb_ext_find are not defined unless CONFIG_SKB_EXTENSIONS.

Perhaps CONFIG_KCOV should be made to select that?




> +
> +               if (kcov_handle_ptr)
> +                       *kcov_handle_ptr = kcov_handle;
> +       }
> +}
> +
> +static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
> +{
> +       u64 *kcov_handle = skb_ext_find(skb, SKB_EXT_KCOV_HANDLE);
> +
> +       return kcov_handle ? *kcov_handle : 0;
> +}
> +
> +#else
> +
> +static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle) { }
> +
> +static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
> +
> +#endif /* CONFIG_KCOV */
