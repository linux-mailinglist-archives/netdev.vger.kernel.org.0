Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7043455EB1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhKRO4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:56:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhKRO4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637247189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktZwmNj2i6HRghsgzsPdqkJk4QpYNvRhiEpD3DouXpc=;
        b=TvXzHUGo14MPME6da1vCoaZ7+VD8KP2gSj5pdmOKJLM5Z8FBiyylHsce4DigTxoAjlbKMj
        U73qeXX+XfsIoff8bw/+xhgR1lpT2sp6kRpUed6+UTZEwQ+rHH3bBKwictLVpHTrbBQV3B
        eSSG85PPGWRfvplJm0thnGABFzHvfw4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-yR9LcULyPdy_Y8OpDAH3TA-1; Thu, 18 Nov 2021 09:53:08 -0500
X-MC-Unique: yR9LcULyPdy_Y8OpDAH3TA-1
Received: by mail-qk1-f197.google.com with SMTP id v14-20020a05620a0f0e00b0043355ed67d1so5021209qkl.7
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 06:53:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ktZwmNj2i6HRghsgzsPdqkJk4QpYNvRhiEpD3DouXpc=;
        b=zzDChMUgSuU6NQ4ZeM9LZjXQk+jrOLyKByLaOTsKCXIL2j/2o9UyDqjZiZE+BkV7ki
         OTDaCQZ2PlDMB2bglI8jYscFYO+B8YFtuoqiF/l2xawI4FD0+h3447aghkFxmEjyr0Sn
         fDM0Ikayvurcs26HgYl1c0KNz+1rovChb2qI8f7aSu8QZtZBYTDuZjmzW3bvBywjzjw/
         0IB8FDrJuFYeBZ+sv0EF418P85zVObhNzMYB+nCmpqiwhU0u5lPUHUdaZtD4xHa14ea6
         6dR+JZxBSg0AtGxKu+2+IcBwiAB5sTuB9LZtWD6V/rcFuM0VhpRLiSzfpfTSeUMf1lSc
         xgGA==
X-Gm-Message-State: AOAM532+2dVAJDEWrJR/TKifqtuAdSF5o6LDXDGAfiai6eA2/y9/T+Ex
        xKW4HPWqQ/3qxzw0FiFCbMeBpykiXP+wwFh6qwjRJXUf+azmS8b4r1RmZ0ghz+27NBOxrpjXIzN
        ZBmSlTzA1WaYG4iKtdkTouruP/+BQ4SJp
X-Received: by 2002:a05:620a:2403:: with SMTP id d3mr21281687qkn.281.1637247188138;
        Thu, 18 Nov 2021 06:53:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSc+hBdpB8rrN3UkT8yniJtEKjtj0Ij4dD3He2By/RfQJkikWJixdi13MzE6tEqilPyDs+LXKP7bNIxMaR/4o=
X-Received: by 2002:a05:620a:2403:: with SMTP id d3mr21281669qkn.281.1637247187998;
 Thu, 18 Nov 2021 06:53:07 -0800 (PST)
MIME-Version: 1.0
References: <20211118082355.983825-1-geert@linux-m68k.org>
In-Reply-To: <20211118082355.983825-1-geert@linux-m68k.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 18 Nov 2021 09:52:57 -0500
Message-ID: <CAK-6q+gQCzJeV5VbCJUbg1dt=4nPvgBAOP5cPmLchmnro1pQ_A@mail.gmail.com>
Subject: Re: [PATCH] fs: dlm: Protect IPV6 field access by CONFIG_IPV6
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        "Reported-by : Randy Dunlap" <rdunlap@infradead.org>,
        cluster-devel@redhat.com,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 18, 2021 at 3:26 AM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
>
> If CONFIG_IPV6=3Dn:
>
>     In file included from fs/dlm/lowcomms.c:46:
>     fs/dlm/lowcomms.c: In function =E2=80=98lowcomms_error_report=E2=80=
=99:
>     ./include/net/sock.h:386:34: error: =E2=80=98struct sock_common=E2=80=
=99 has no member named =E2=80=98skc_v6_daddr=E2=80=99; did you mean =E2=80=
=98skc_daddr=E2=80=99?
>       386 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
>           |                                  ^~~~~~~~~~~~
>     ./include/linux/printk.h:422:19: note: in expansion of macro =E2=80=
=98sk_v6_daddr=E2=80=99
>       422 |   _p_func(_fmt, ##__VA_ARGS__);    \
>           |                   ^~~~~~~~~~~
>     ./include/linux/printk.h:450:26: note: in expansion of macro =E2=80=
=98printk_index_wrap=E2=80=99
>       450 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__=
VA_ARGS__)
>           |                          ^~~~~~~~~~~~~~~~~
>     ./include/linux/printk.h:644:3: note: in expansion of macro =E2=80=98=
printk=E2=80=99
>       644 |   printk(fmt, ##__VA_ARGS__);    \
>           |   ^~~~~~
>     fs/dlm/lowcomms.c:612:3: note: in expansion of macro =E2=80=98printk_=
ratelimited=E2=80=99
>       612 |   printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
>           |   ^~~~~~~~~~~~~~~~~~
>
> Fix this by protecting the code that accesses IPV6-only fields by a
> check for CONFIG_IPV6.
>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 4c3d90570bcc2b33 ("fs: dlm: don't call kernel_getpeername() in err=
or_report()")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Thanks, but the issue has already been fixed in the same way [0].

- Alex

[0] https://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git/=
commit/?h=3Dnext&id=3D1b9beda83e27a0c2cd75d1cb743c297c7b36c844

