Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5632F48192D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 05:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhL3EAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 23:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbhL3EAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 23:00:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C53EC061574;
        Wed, 29 Dec 2021 20:00:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id h1so14136235pls.11;
        Wed, 29 Dec 2021 20:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aulNbFPCcjXwCXZwEfInFO0zkigoTVrqB4tOC/J40PY=;
        b=I6VFi5bBovASXleoCsxW2hMexWoAPvtGac+HfZRpC/AgPmPrxdoGGrMtfSaJmMPznt
         pYyiU1MfsynufUQrHGEY+cYYPyXaPa7BjQJxVfdj74uLTUDNDq1WT0QWNnjf3dx1Vh0K
         PfUTwglfxTb7/zNcBXpMIUR2vLJ8jIPZBS1RNDTH0S+vyoeVVO1BtAyXEPXh4nMf3tEi
         O1R/0FQM1pK166ETicrNGSGV1GUyi7Wqz9b2x2LPo/mDV9sgFA7dBr5lnBkqh2JpcCQF
         kS0xRaQkS1uBCxiB0+Ug8VD2GQ8P2zoBCzmuC8DCoUH8PQdMO0lue/zsS/zkVQ8suqgi
         vxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aulNbFPCcjXwCXZwEfInFO0zkigoTVrqB4tOC/J40PY=;
        b=5jFl1C7AqLGz2V6raXDBIUkNhDbecbALMevhX8JKDS8mS2s8QiPctXpjU4bIPLNhCJ
         KpinogqhWYAQgfcBPp8R3EukF0Pz9wa66Z0a5dg70tU/0+jLtGU1nNlcafRZNVjqMPr0
         r2QxqTUXrmdSEqE0St6OMoKyjtPS7ErAf5F6AAakOCoTQIi8nFqt02ErXHYWwJESwfZ2
         pMoPBgoF8q7dz1ciHEfMCm6Dh1gTdpFTq0YF8a7ULcmrMlenHRxEbVrJx2SFVjV/cWKA
         NWBsPBK6mSFInlYSmcK+V/iyOKM3txmO/40MXYl51R/Kpui0BBc4A9Eu85WbQmULIPwE
         A0SA==
X-Gm-Message-State: AOAM533GHzGIyGgUayiIou7rD3QGd7wRXv8IJvTca395AmoXnNXLh6ML
        dhQx//03Cy4zDLomtI2fOo5GSIRrLHyqJwDt04YGYBpd
X-Google-Smtp-Source: ABdhPJwXqLwtF3TmVOnQxiCm8I7Zcoupa6hvU0jLBVqISMQNeVhd82MG6ZztSOOW9N0TZBcW97T+7GNzzZ7voTMyhIE=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr29428656plm.78.1640836847380; Wed, 29
 Dec 2021 20:00:47 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
 <CAADnVQJK5mPOB7B4KBa6q1NRYVQx1Eya5mtNb6=L0p-BaCxX=w@mail.gmail.com> <CAFcO6XMxZqQo4_C7s0T2dv3JRn4Vq4RDFqJO6ZQFr6kZzsnx9g@mail.gmail.com>
In-Reply-To: <CAFcO6XMxZqQo4_C7s0T2dv3JRn4Vq4RDFqJO6ZQFr6kZzsnx9g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 20:00:36 -0800
Message-ID: <CAADnVQ+HJnZOqGjXKXut51BUqi=+na4cj=PFaE35u9QwZDgeVQ@mail.gmail.com>
Subject: Re: A slab-out-of-bounds Read bug in __htab_map_lookup_and_delete_batch
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 7:24 PM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> Hi, the attachment is a reproducer. Enjoy it.

Please do not top-post.
Forwarding a syzbot reproducer with zero effort to analyze
what's going on is kinda lame.
Maybe try harder and come up with a fix?
Or at least try git bisect and based on a commit find and
cc an author so it can be fixed (assuming issue still exists
in bpf-next) ?

> Regards,
>    butt3rflyh4ck.

Better stay humble.
