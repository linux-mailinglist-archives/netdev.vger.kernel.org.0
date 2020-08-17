Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F8F24781D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 22:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHQUaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 16:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHQU3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 16:29:53 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018CFC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:29:53 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r13so11271096iln.0
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/DKcMnlp2VgV4Tf8D8MjWGioanlcnwG6ljLnC2cEglQ=;
        b=PXgBasmNQm2kKl21mrQoQafBJtM/DfxW0AhrYsGjCgTCjAVW6aaLFZ4rjBLg9K9SIV
         Z685FqjcAX8RWS4njO+02ZwND6XCTpd7W+7Gs3cmSKNC1UIAjCn571oSb083WyHIVsT+
         CzWgkcK8oMC/Ea377dJjH7sdExbNkia55X/CpowYERLKvXpSN7PE3K5j4LSjPDm8Cw0x
         0CUJnnRF+6CweZ8BCEW3MRRj1Ahk5oQ3o9o9B2y2O+R1GlpNAlWkK8Kqe09w6pAdmfrl
         3CPRfa5PUks7cWHlUUbtRyKUn+RgwoI8oM5BQov0MqhTo73KvpVndKkp27n6V8rPWAE0
         Q/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/DKcMnlp2VgV4Tf8D8MjWGioanlcnwG6ljLnC2cEglQ=;
        b=ZHUI0OaXVT1SPow2BZWCW4FAuSJPEUBuzLxkGXDyPaoKf0gKuZFuFa+phEJ6axAJv4
         SYIe/JU+0mamddvI9gQG5MpHgCPNKFy64EPHIvyB9CCM/ye0RqRP8Rc9Adz+hbb1HrKC
         42/h9/w/pvtopXPUfvRxJ8iTtHE7NlvDZanaK1kD7ZT18Vc11mu9oRdKIrP8Wezgdft2
         hcg5jfc6vNxMfPvuohcyG1TRJlOL97Iga6gT0SVGssiuoGHelH4wXaA79ne0fgBTGV31
         /eGGRNFKAScmR4oo3OmHryEp7uMnGVmtgfHmfaGyOTxnaht+/3S34w9M5IbNf7Ku8L3X
         INaA==
X-Gm-Message-State: AOAM5308lEpaCPvwx4gak8uG7+YJ2WDvsf1DiOHAXU4bUFXLuzW5F+0T
        B+jkzwqrWS4atT9f6InCZ8WcB40AkyeTHlMUHQu60BRSwtj5VA==
X-Google-Smtp-Source: ABdhPJxY+wQrN0c7nLZ9iRGcbfrLk8WogRYAk5mU3HmAdYu5FyB58w27c0YkJDZWrvS3KZeI19BkmpvpO0X4df4fXlE=
X-Received: by 2002:a92:9145:: with SMTP id t66mr4273867ild.305.1597696192310;
 Mon, 17 Aug 2020 13:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
 <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
 <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
 <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org> <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
 <1b45393f-bc09-d981-03bd-14c4088178ad@infradead.org> <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
 <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org>
In-Reply-To: <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 13:29:40 -0700
Message-ID: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 12:55 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> TIPC=m and IPV6=m builds just fine.
>
> Having tipc autoload ipv6 is a different problem. (IMO)
>
>
> This Kconfig entry:
>  menuconfig TIPC
>         tristate "The TIPC Protocol"
>         depends on INET
> +       depends on IPV6 || IPV6=n
>
> says:
> If IPV6=n, TIPC can be y/m/n.
> If IPV6=y/m, TIPC is limited to whatever IPV6 is set to.

Hmm, nowadays we _do_ have IPV6=y on popular distros.
So this means TIPC would have to be builtin after this patch??
Still sounds harsh, right?

At least on my OpenSUSE I have CONFIG_IPV6=y and
CONFIG_TIPC=m.

> TIPC cannot be =y unless IPV6=y.

Interesting, I never correctly understand that "depends on"
behavior.

But even if it builds, how could TIPC module find and load
IPV6 module? Does IPV6 module automatically become its
dependency now I think?

Thanks.
