Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADD66B34D
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjAOR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjAOR74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:59:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E95CC3F;
        Sun, 15 Jan 2023 09:59:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so31777861pjk.3;
        Sun, 15 Jan 2023 09:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kadheJ1b09KgtyLj9+2dkLZRUBCHQfWVd+yZnt+e1yk=;
        b=K74bt2dkLR/B+9EClHqEEIElkkyafMlCmCdI4dr0gO6ZApaP+U/bw5fRAGusxwxiR1
         Mu+1abtbC9Ldvb540qFiEcxPqcPeLc5EEwXsxFVxWzVP7dxJ0JDFZ/VuwLjxccDcGLYJ
         Wwjewfw5Jck7tPKi4iPhiRBCgNbtheex1LE1zy+vPPu0tnk0biN7AMf1qVEZcXACRDGO
         2zm1bQS1OYNA6skRYNEJ4trRonYCrslGUjjP3SZTLmoYLVdHQzJSvovuDOtRwGiG15Xw
         nhwBetxfUsMB9QJzGj5RrL0Ukt8gOahi7Dfu7l9CMQZ6Gkx0tA/v+Nkx8kVXn0iMq78C
         NJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kadheJ1b09KgtyLj9+2dkLZRUBCHQfWVd+yZnt+e1yk=;
        b=aGQMDXG70nXGqa22/oQExBx3fbmiDsQn32gU3V5JdBGnrH86POkM6fADW+cCrWLHC2
         Hrh/pXDUsoLQH7HtTfXPJori5YvGv8v38kDHBhj+KbmqG/KegUYoN+4NsfqasFnmYent
         k1+8uRzIzCFf4KOnEzzQhhGACc9IwQAgru7S3T8IJYGXMrOVg5QaTuvhKWxyvklGIUyM
         0aZxjjQkPkjqpS+FbyFxrxUmLLQko5JwPGrFSWibvKtTNfuzRcbeYJy5xnvvPPO60GAt
         ofwqytojQl+u0qOKX3InD9mXolhs5mz0/NXptzREq1a0xzC6QRyCTMnTJ6VFYv6yI6/d
         OWVQ==
X-Gm-Message-State: AFqh2krhqTIhbzhxcT1XHmY05RZJo9yqcOsxbS6sNxRW58xoiYJaJ2sZ
        OYMnZvgdkYxBnjKCIGlqees=
X-Google-Smtp-Source: AMrXdXvQhTorh9DHt/JQhk2Uq8z+0LqazZE5TaPDF3SG92Mi0rpniY8JCwzWhgJkAQracBY/Hqtg8g==
X-Received: by 2002:a17:90a:b38a:b0:225:c902:c86a with SMTP id e10-20020a17090ab38a00b00225c902c86amr18217485pjr.28.1673805594681;
        Sun, 15 Jan 2023 09:59:54 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:df0a])
        by smtp.gmail.com with ESMTPSA id q63-20020a17090a17c500b002191ffeac8esm4134395pja.20.2023.01.15.09.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 09:59:53 -0800 (PST)
Date:   Sun, 15 Jan 2023 09:59:50 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH HID for-next v2 6/9] HID: bpf: rework how programs are
 attached and stored in the kernel
Message-ID: <20230115175950.xa75mmt6jhjhxgdq@MacBook-Pro-6.local>
References: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
 <20230113090935.1763477-7-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113090935.1763477-7-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:09:32AM +0100, Benjamin Tissoires wrote:
> Previously, HID-BPF was relying on a bpf tracing program to be notified
> when a program was released from userspace. This is error prone, as
> LLVM sometimes inline the function and sometimes not.
> 
> So instead of messing up with the bpf prog ref count, we can use the
> bpf_link concept which actually matches exactly what we want:
> - a bpf_link represents the fact that a given program is attached to a
>   given HID device
> - as long as the bpf_link has fd opened (either by the userspace program
>   still being around or by pinning the bpf object in the bpffs), the
>   program stays attached to the HID device
> - once every user has closed the fd, we get called by
>   hid_bpf_link_release() that we no longer have any users, and we can
>   disconnect the program to the device in 2 passes: first atomically clear
>   the bit saying that the link is active, and then calling release_work in
>   a scheduled work item.
> 
> This solves entirely the problems of BPF tracing not showing up and is
> definitely cleaner.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Alexei Starovoitov <ast@kernel.org>
