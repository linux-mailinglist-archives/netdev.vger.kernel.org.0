Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6AD3F2154
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhHSUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhHSUHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 16:07:10 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91CC061575;
        Thu, 19 Aug 2021 13:06:33 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id k65so14425779yba.13;
        Thu, 19 Aug 2021 13:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WgVeL5rNcSm7DbLe60psFxA38SGVBvQ21F+qiVfcReE=;
        b=bp0BTkx36du6n7yGA1xrjXX7LZj/PL05mTA6mEutAG4j9Mcn7ZGwzyZXiB1cXgOf0g
         Xr/IZE69dQ06Vf1UZmXD138M/Hu9Ue0EoNJV5HHQ5Jbjc30zsuL5zz/WURlkaZPocB5C
         Xikfn8pVPKjcCPnYiqPLRAC/HZpbzC6qc4ee6gcFVOLbw6TPCXHaLNhGVMJJRoX/sUBf
         A19qaupNe77ZkdeT9y+cYhHh1ZqsxCvDoC+rkj5HUFbFqaM98NFn/IbMoroGoeRRAfS2
         4oIRaFIaTkHDP5cZAehSwp9y0lnQLPnPUXqAOXwuIYO4JrN9njqbZ9vNnBAf28nrmSOU
         JroQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WgVeL5rNcSm7DbLe60psFxA38SGVBvQ21F+qiVfcReE=;
        b=U7LkKqfqwqM+yPJbNi87VhAVWUBDAuseMyZZ4UbRf304bdKViaRLpMrTV/lPmT3BoP
         5aIopfi7GI7pkGbu8t/VJOEEXCkAC0Vjrouzi+/SAjd5cyBnE6vPmxpE7j0VtecGVift
         3K9LZ0Ssc8iSensvWNo4gyixtECYZSRxTlyYlO3qTJKDW9rfaWL9Qeo4FOkhuledwvag
         6gg0Pv20SuLtKjlu8iHQBl+DJwPdlNmRhiLeYT2AEUgGtVCz1y913sKxOGS/ePwLxz80
         ZeZFGlV8lqyyg8kL+Ob8LdVrO0XhiTYo7h/W5HYWBOX07DY+V8BY2hTKMD6FAWqITCyZ
         ZMIg==
X-Gm-Message-State: AOAM532hZ/USIOWcgo5/CtuUI4FxKBHM1VIINgLtQ4aYU9CtOQhWOKtS
        N7n0enTOIyhkuhusMXNoKtgKtgAM+iAhXtBkT7s=
X-Google-Smtp-Source: ABdhPJxXaF+Y8DRt2+s7zIip6ayQ1kWTdOXXWCi6akHhcT+Hou+kzX0SqNnDHcgqE2jhHLN99i0TQmxfnU/1szGK7DU=
X-Received: by 2002:a25:1e89:: with SMTP id e131mr20660069ybe.90.1629403592676;
 Thu, 19 Aug 2021 13:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
 <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
In-Reply-To: <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 20 Aug 2021 04:06:21 +0800
Message-ID: <CAFcO6XMTiEmAfVJ4rwdeB6QQ7s3B-1hx3LJpa-StCb-WJwasPg@mail.gmail.com>
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, this bug can be triggered without your change. The reason why I
point to your commit is to make it easier for everyone to understand
this bug.

Regards,
 Xiaolong Huang (butt3rflyh4ck)

On Fri, Aug 20, 2021 at 3:53 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On 8/19/21 10:16 PM, Jakub Kicinski wrote:
> > On Fri, 20 Aug 2021 02:14:58 +0800 butt3rflyh4ck wrote:
> >> From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
> >>
> >> This check was incomplete, did not consider size is 0:
> >>
> >>      if (len != ALIGN(size, 4) + hdrlen)
> >>                     goto err;
> >>
> >> if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
> >> will be 0, In case of len == hdrlen and size == 0
> >> in header this check won't fail and
> >>
> >>      if (cb->type == QRTR_TYPE_NEW_SERVER) {
> >>                 /* Remote node endpoint can bridge other distant nodes */
> >>                 const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> >>
> >>                 qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
> >>         }
> >>
> >> will also read out of bound from data, which is hdrlen allocated block.
> >>
> >> Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
> >> Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
> >
> > Please make sure to CC authors of patches which are under Fixes, they
> > are usually the best people to review the patch. Adding them now.
> >
> >> Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
> >
> > We'll need your name. AFAIU it's because of Developer Certificate of
> > Origin. You'll need to resend with this fixed (and please remember the CCs).
> >
> >> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> >> index 171b7f3be6ef..0c30908628ba 100644
> >> --- a/net/qrtr/qrtr.c
> >> +++ b/net/qrtr/qrtr.c
> >> @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
> >>              goto err;
> >>      }
> >>
> >> -    if (len != ALIGN(size, 4) + hdrlen)
> >> +    if (!size || len != ALIGN(size, 4) + hdrlen)
> >>              goto err;
> >>
> >>      if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> >
>
> I am able to trigger described bug with this repro:
>
> #define _GNU_SOURCE
>
> #include <endian.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> uint64_t r[1] = {0xffffffffffffffff};
>
> int main(void)
> {
>     syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>     syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>     intptr_t res = 0;
>     memcpy((void*)0x20000000, "/dev/qrtr-tun\000", 14);
>     res = syscall(__NR_openat, 0xffffffffffffff9cul, 0x20000000ul,
> 0x82ul, 0);
>     if (res != -1)
>       r[0] = res;
>     memcpy((void*)0x20000000,
> "\x01\x21\x21\x39\x04\x00\x00\x00\xd6\x2c\xf3\x50"
>
> "\x1a\x47\x56\x52\x19\x56\x86\xef\x00\x00\x00\x00"
>                               "\xff\xff\xff\x00\xfe\xff\xff\xff", 32);
>     syscall(__NR_write, r[0], 0x20000000ul, 0x20ul);
>     return 0;
> }
>
> ( I didn't write it, it's modified syzbot's repro :) )
>
> One thing I am wondering about is why Fixes tag points to my commit? My
> commit didn't introduce any bugs, this bug will happen even _without_ my
> change.
>
> Anyway, LGTM!
>
> Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
>
>
>
>
> With regards,
> Pavel Skripkin



-- 
Active Defense Lab of Venustech
