Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB7A48252D
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 17:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhLaQdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 11:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhLaQdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 11:33:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04604C061574;
        Fri, 31 Dec 2021 08:33:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p14so20464959plf.3;
        Fri, 31 Dec 2021 08:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYkfI2lt/GY9SHQWwHyxFcycOWwFfQwKdXXFkZw1qm0=;
        b=VR1utab4LzjntxdgFUljyqrFbwGNJzksfjcZUoJHYaAG3K6tMu4mFV9wZkPDiRKFE9
         dnYnx1AG8Wu+Es9dO7XiSOLTmkiDuQFv8R1jz+XBt9uSekrGGF6EJNiyaoCuUa6xEYLX
         l0dHPD8iAHPpynO46A5At72iuNL6hRZoJYfXjGfWkJ7ZabWE+6LbXrk2Qz1foDlOrrt6
         8r37EcvcrHs6OSqhBbhZzgbi+xWDUhTnA5ufn2b3TjlPNbsINbAFdB9ftI1SIanrOOIb
         RMvrihCS+6msYLuGHwrjS7/dOlweaJq08Xmwne/DYULUj1f2MRCOYBA/5NVxFn2wU4C7
         eqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYkfI2lt/GY9SHQWwHyxFcycOWwFfQwKdXXFkZw1qm0=;
        b=EX5uYTCXAPqHnqudOqOfXWr68+na2BA7nvpKu3oZqOXoPjkm3UdnfoF3kMHxGZaH+m
         M6dZ5HUjWW/ocJDrypY4rQRvOAE6zwFAcyjpewib/I8oRX3KcpWo6Z0uS+nvIyKXJJ8Y
         GCYtBss/pi4KKVQ+UzFm9ako2A+mKEyLFCV786GNL6iOvS3c6um645nUB9pudqboIwgE
         uUGuZl39jWy32Og71rdvps7pedF7buDfcutZ+nW5QWmNPU7IkcDZZ8tqdoCFPX5hl00i
         x4/OVjP5Rj8lmApjy1rXRKMyqC3+/SCIHJ7qRCqomdBexLodPc4F1mHWrQldVLrIASOR
         JCSg==
X-Gm-Message-State: AOAM5305avEuWv63c8ibm33dTZIHN/a4q05WhdaFMibNjtc8YoDBolfd
        mMsOmVdt3j6x7XSOS479KmdiRHXVhdiiERhomdk=
X-Google-Smtp-Source: ABdhPJwUUmvcggc7fwNX2mgthnOh09IiedQF63NEiOxG4/o68b5hbtlSO2jgXHo69YG9PP6MgHdMI0SqbrkWwo1DKHM=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr35913517plm.78.1640968380417; Fri, 31
 Dec 2021 08:33:00 -0800 (PST)
MIME-Version: 1.0
References: <20211231153550.3807430-1-houtao1@huawei.com>
In-Reply-To: <20211231153550.3807430-1-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 Dec 2021 08:32:49 -0800
Message-ID: <CAADnVQLfCq9urgtNuW2dgjUj-wb+AxSj5YzHb4GvSZR-TtZ7kw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: support bpf_jit_enable=2 for CONFIG_BPF_JIT_ALWAYS_ON
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 7:20 AM Hou Tao <houtao1@huawei.com> wrote:
>
> bpf_jit_enable=2 is used to dump the jited images for debug purpose,
> however if CONFIG_BPF_JIT_ALWAYS_ON is enabled, its value is fixed
> as one and can not be changed. So make the debug switch work again.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>

That was discussed in the past:
https://lore.kernel.org/bpf/20210326124030.1138964-1-Jianlin.Lv@arm.com/
The old point stands.
