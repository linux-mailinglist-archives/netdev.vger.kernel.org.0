Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F404B7557
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbiBORHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:07:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242162AbiBORHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:07:03 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA0C7C27
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:06:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q7so33126118wrc.13
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64ujAZGCy+wXFieA5/Bj8ZqtpVN9eii19Jh2KoGa8VQ=;
        b=L2GzMwlPsZ7uQ/GDO30qwxGgBGqGNVBqZLTl0CXEl3tlyoMniWdKzQPzNGWr9Zxt7/
         S5EcncmoO3Vw6GI+9aYAF8XbQ2lw3eyls4FC+lu2pAGfHzvu7Ob9zAEnfKAY55nAZ6d7
         12ZXoaI6kh9hCMmHJKPUPJWRfpf6aZb1MOCaA/opO4hgdQ7V4m3ZtnODWzCIGCLjzaPX
         8pch32l9fJrzyx5tHBR80+hjG6gWW502dJ5O6nBV6jv+wteAuFr6DruQCRQ44Q7mlt0o
         yQp/0bUYoYSK3/5I6s8OVvcmzbUB0SR0uAoaemIRpTrOX7Vp8Q7iZY+iMwRGautRQehC
         2LFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=64ujAZGCy+wXFieA5/Bj8ZqtpVN9eii19Jh2KoGa8VQ=;
        b=kLE9Cx8JM9xL1YfjeyC06CzKD9r3H2/ZtUoLElsrlRFJsimY7K/2dMKPZW1UiNgr9w
         okK8g8Hk0LUT3dp3UV3y3u1Wqcg7Xu3vEu0A8fjoY0MWJTxAcAlSQYlr82wmRgpAniTn
         iBKI6JJ9+o3UvPRUdtbBRXK7nShu2nOC0YoAyxezsbY18dpF8Kq4tNwWhMYbTytGneuJ
         yrsMZi7j7A9BslAeeaTYR0mlBZ0NnuJnXZNH7iU7FjI8YSw3bxT84LD8VPw1u+KOBauW
         c7vZlG7fzwze58n/34R90xHTa5KvN/RIS3/0H+sy+aDb8KYmeosJ42DLL/kq2ZD8whRA
         KyyQ==
X-Gm-Message-State: AOAM532aa5UfvxwmU+rk5FlZnMzB2ydLyRN3/6I3f4EBOUik+xg/YDDd
        Mzg1H5e95+2WysxAhxh2VkZxYe3Mt0CTDRL3Ic7lBGTAKc9Zy68F
X-Google-Smtp-Source: ABdhPJxt7DoTqqlSMnPR20BUAU/D51eBUmhuL5qPMitPYI1QjXmZpvB3HO4dQNvSBDK/LIrFk4jiPFqroLEgJdBXdCk=
X-Received: by 2002:a5d:47cf:: with SMTP id o15mr3959105wrc.412.1644944811535;
 Tue, 15 Feb 2022 09:06:51 -0800 (PST)
MIME-Version: 1.0
References: <20220213150234.31602-1-thomas.liu@ucloud.cn> <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
 <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn> <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
 <42554FCB-9180-4B32-B5CF-6D3236237D99@ucloud.cn> <CAF=yD-+1RSj_o8n5LDOLVyn_dvVQvmDQo5pacSoDFPOR3M2g5g@mail.gmail.com>
 <CANn89i+T=Ny7pfUomSsa1ub77u8LfYtRZPzmp_0-=oWKt0abLg@mail.gmail.com> <CA+FuTSc9ZeuLE7tqNT-GnqHb27SE7UAtVRVsZHR+dV6ua=UKPA@mail.gmail.com>
In-Reply-To: <CA+FuTSc9ZeuLE7tqNT-GnqHb27SE7UAtVRVsZHR+dV6ua=UKPA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 09:06:39 -0800
Message-ID: <CANn89iLtXW-MFJ74UhP4WyC3a60LrevAxddBjJ1nGu78eSG1DQ@mail.gmail.com>
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Tao Liu <thomas.liu@ucloud.cn>, David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 7:46 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:

> > Stuffing state in the skb has been a mistake I think.
>
> If we could unwind those skb inner_* fields (and reclaim the skbuff
> space!) that would be fantastic.

Not sure we can easily remove the space, many networking drivers need them,
we probably do not want to dissect packets in their ndo_start_xmit()

>
> Immediately for this bug: perhaps it can be fixed by resetting the
> network_header on the gso skb if segs == NULL. As the offset is stored
> on the stack.

It seems correct. Any other fields we need to take care of ?
