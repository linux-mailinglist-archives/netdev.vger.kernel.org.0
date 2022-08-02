Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4FE587E2A
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiHBOcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiHBOcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:32:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9562A7;
        Tue,  2 Aug 2022 07:32:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o3so13619167ple.5;
        Tue, 02 Aug 2022 07:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=a2I3feE0Mlfc3dQYVR+6wp2Xd8855Ae93uhZIIi/yHM=;
        b=aesQNlVxD1yT/+g/rcziiqLmKf9Hlm4zQQ8bBvOm0oMfANjlGDpxKqZmpWKm2YnQDm
         LFZ/MXvbb3s71YM75UkKN4Jt4s/ZWOV3PKtzYjpYxhWxYjfsefJutvUBRtmXRkDT/+fh
         gvKoiOn1EBsouTWHyg6Ju3+b6aBVDJ1KmwG+DpepedgZHxZgRbFkbSTgUmbcGvP0mIp0
         y/+m+2Hx6jAYOjwCJ0cO5ZlX1EwegRTdAkUDJY2269qXI/owaAW0twShGzApePCaVe7h
         D/jqVN4qGJ8AoNxqd1bLBacScqDR+hSIys2eexLd8l1X5EptRGbTSsyq3NtxmxZmQdO6
         O7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=a2I3feE0Mlfc3dQYVR+6wp2Xd8855Ae93uhZIIi/yHM=;
        b=DplfZWu2I5g6QWxGV4yrpLSf6P8/jGGrl+3HNy6wZykJluMazYLUJ3aOf9oedhiNEK
         AGxgaLVuomVIgElgdXCYh57lXq9FT/uQ2d2I56FrylPRj254p76RVsO/OqiZzdw+ZMiA
         Ieh0bNGVrhvNYgeKcP2vlNnVzC4R7N0ytpXRcCMyLEGvo/Y5FIXChho7lGqMVcfCzZww
         iSXGyiowLomm1EGy8s/sFagsDJKMYOozbzzWYUEVVwOhRgmXbwg9w8otqA83Z4VpTCFR
         DUP694AgxbUYejerBpHnbMrqqB3n5lovW15QWWqA7sCckZyXxUx9mzHb2X13C0hT7Lvn
         ZJ7Q==
X-Gm-Message-State: ACgBeo2zdOAEClkntUsJI45ljvZcicBNDueYSEaOIxb6SwI9iNZdaoWm
        Gt6COsA9Ue7GlZsl+IcSvk4=
X-Google-Smtp-Source: AA6agR5f0C9L4dHw1ZGT1V6HsSKE+oSWd0oY5hDNIEcYNyrNHoM+heSlQ+rbuArRCrxHcS4G+noBOA==
X-Received: by 2002:a17:902:ab96:b0:16a:6db6:2715 with SMTP id f22-20020a170902ab9600b0016a6db62715mr22067267plr.141.1659450741586;
        Tue, 02 Aug 2022 07:32:21 -0700 (PDT)
Received: from localhost ([223.104.103.89])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090311d000b0016be6a554b5sm12172323plh.233.2022.08.02.07.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 07:32:21 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     jakub@cloudflare.com
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, guvenc@linux.ibm.com,
        guwen@linux.alibaba.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org, songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, ubraun@linux.ibm.com,
        wenjia@linux.ibm.com, yhs@fb.com, yin31149@gmail.com
Subject: Re: [PATCH v2] net/smc: fix refcount bug in sk_psock_get (2)
Date:   Tue,  2 Aug 2022 22:32:14 +0800
Message-Id: <20220802143214.5885-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87wnbsjpdb.fsf@cloudflare.com>
References: <87wnbsjpdb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion!

On Mon, 1 Aug 2022 at 17:16, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> This way we would also avoid some confusion. With the change below, the
> SK_USER_DATA_NOTPSOCK is not *always* set when sk_user_data holds a
> non-psock pointer. Only when SMC sets it.
>
> If we go with the current approach, the rest of sites, execpt for psock,
> that assign to sk_user_data should be updated to set
> SK_USER_DATA_NOTPSOCK as well, IMO.
Yes, as you point out, in this patch, this flag's name should be
*SK_USER_DATA_NEEDCHECK_NOTPSOCK*, which is more clearly.

To be more specific, we don't need to set this flag for
every sk_user_data who holds non-psock pointer. Only set the flag for
the site that has been reported involved with the type-mismatch bug
like this bug.
> > During SMC fallback process in connect syscall, kernel will
> > replaces TCP with SMC. In order to forward wakeup
> > smc socket waitqueue after fallback, kernel will sets
> > clcsk->sk_user_data to origin smc socket in
> > smc_fback_replace_callbacks().
> > 
> > Later, in shutdown syscall, kernel will calls
> > sk_psock_get(), which treats the clcsk->sk_user_data
> > as sk_psock type, triggering the refcnt warning.

For other sites, this patch is actually transparent to them, because
the *SK_USER_DATA_NEEDCHECK_NOTPSOCK* flag is always unset. So this
patch won't affect them, which won't introduce any extra
potential bugs.
> +/**
> + * rcu_dereference_sk_user_data_psock - return psock if sk_user_data points
> + * to the psock
> + * @sk: socket
> + */
> +static inline
> +struct sk_psock *rcu_dereference_sk_user_data_psock(const struct sock *sk)
> +{
> +	uintptr_t __tmp = (uintptr_t)rcu_dereference(__sk_user_data((sk)));
> +
> +	if (__tmp & SK_USER_DATA_NOTPSOCK)
> +		return NULL;
> +	return (struct sk_psock *)(__tmp & SK_USER_DATA_PTRMASK);
> +}

>
> Hi,
> Since using psock is not the common case, I'm wondering if it makes more
> sense to have an inverse flag - SK_USER_DATA_PSOCK. Flag would be set by
> the psock code on assignment to sk_user_data.
However, your suggestion seems more elegant. For my patch, as you point
out, when anyone reports a new type-mismatch bug, the relative assign to
sk_user_data should be updated to set *SK_USER_DATA_NEEDCHECK_NOTPSOCK*
flag.

For your suggestion, you seems avoid above situation. What's more, as I
use git grep to search, there seems no direct access to sk_user_data,
all via a small amount macros and wrapper functions. So we can keep
transparent by only update those macros and wrapper functions, which
also won't introduce any extra potential bugs.

I will patch as you suggest in v3 patch.
