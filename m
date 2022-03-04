Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6C4CDFA4
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 22:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiCDVOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 16:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiCDVOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 16:14:20 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E55013CA2B
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 13:13:29 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id z11so879900lfh.13
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 13:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FhAw6s/ZDBzFaLO+5qA2AUiMTy3oDy4zAgPP2+mMM6w=;
        b=K5CKs5nw6XbYQA+OWJHeC6/+m0eYn1u5EEnhysHc94DkKsitLS1zOGLWO0IOE8RZg0
         MDFsCR/7gRfUUWtMIc02DrDUKgTyPMPkvzSpxm+pUCYS8un0MgAp4lwB3YdOO882AYIT
         eM969HIFQ8vVAHe/oeJ81d4ORRDl6RdQ7vyKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FhAw6s/ZDBzFaLO+5qA2AUiMTy3oDy4zAgPP2+mMM6w=;
        b=5CD3ebRIT627tG8HVfmOrjgm2fd7Zptw3fPX4Zfwpug9jjA2D09y4tEsj0jPTe20/N
         +uGwOlYZitidjy43QBV+WKBSB4pQMRN6vk0mk4z7y72PGego7VSowMmvqFQyzCqOLOfK
         UFgzosZ3aFMdGQw3EJJh0Yz0T41Gd4GQ/PeeQbzZ/ZBa4haTuwHktwGwNZAJ0dwsWjtk
         22gQ+FtvmYxu15G5GQcSo9NvQBQa59BrtztKWKvrN6j2lfu2yGfS+VZlmbnU1+wUTTv4
         Tnm9XZY0Rfu9Lx25fP/aZp8eG8EtWmuFDch0PBU9OIvbe3Y/lZM5kwHCirXi66/WovkK
         qPOw==
X-Gm-Message-State: AOAM531db1i2jABMjg8fKA3oDoVh/93cWEfYcY5rqqtmEHqTd3dt5V4J
        8Mp8AKjy1HZcv1nC5suARhcYLGQET7puPfE+
X-Google-Smtp-Source: ABdhPJzjU2kA+F5P+W0XMunLtm+GTLvZXsNT1b7r/lpIE1x2aRcY29WGQjvDsfGNt4x7srnfn/GKxA==
X-Received: by 2002:a05:6512:3402:b0:448:c29:ce8a with SMTP id i2-20020a056512340200b004480c29ce8amr388158lfr.633.1646428407720;
        Fri, 04 Mar 2022 13:13:27 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id k11-20020a2e920b000000b002463777bbb9sm1321572ljg.24.2022.03.04.13.13.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 13:13:26 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id v28so12626693ljv.9
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 13:13:25 -0800 (PST)
X-Received: by 2002:a2e:bc17:0:b0:246:32b7:464 with SMTP id
 b23-20020a2ebc17000000b0024632b70464mr323667ljf.506.1646428405700; Fri, 04
 Mar 2022 13:13:25 -0800 (PST)
MIME-Version: 1.0
References: <tencent_B01AAA5AC1C24CDEE81286F1006CE27B440A@qq.com>
In-Reply-To: <tencent_B01AAA5AC1C24CDEE81286F1006CE27B440A@qq.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Mar 2022 13:13:09 -0800
X-Gmail-Original-Message-ID: <CAHk-=wic8ind8nY5fea+otfkmjBuMwgiXY6idbtrXZcig3yDaA@mail.gmail.com>
Message-ID: <CAHk-=wic8ind8nY5fea+otfkmjBuMwgiXY6idbtrXZcig3yDaA@mail.gmail.com>
Subject: Re: sendmsg bug
To:     1031265646 <1031265646@qq.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Appending the full original email - converted to plain-text - below.
Note that the "comments i marked red" are no longer red, since the
html has been stripped out ]

Dear 1031265646,
 please don't email me in private about bugs, much better to send them
to the right person and mailing list (see scripts/get_maintainer.pl in
the kernel sources).

The bug seems real, although mostly harmless. If ip_make_skb() returns
NULL, it's true that udp_sendmsg() will return a misleading success
value since 'err' will be 0 and it will return the length of the
packet that wasn't actually ever created or sent.

UDP being a lossy protocol, probably nobody has cared, since
"successful send" doesn't mean "successful receive" anyway.

I'm not sure what the right error should be for this case, and whether
it should be fixed inside ip_make_skb() ("always return a proper
ERR_PTR") or what.. Or whether it should just be left alone as a
"packet dropped early" thing.

I'll leave that to the network people added to the participants.

            Linus

On Thu, Mar 3, 2022 at 10:23 PM 1031265646 <1031265646@qq.com> wrote:
>
> hi=EF=BC=8C
>
> in file udp.c, a function named udp_sendmsg has a code like this:
>
> /* Lockless fast path for the non-corking case. */
> if (!corkreq) {
> skb =3D ip_make_skb(sk, fl4, getfrag, msg, ulen,
>  sizeof(struct udphdr), &ipc, &rt,
>  msg->msg_flags);
> err =3D PTR_ERR(skb);
>
>         //here IS_ERR_OR_NULL is expected, instead of !IS_ERR_OR_NULL.
> if (!IS_ERR_OR_NULL(skb))
> err =3D udp_send_skb(skb, fl4);
> goto out;
> }
>
> but function ip_make_skb may return a null, then err will be set to 0;and=
 out like this:
>
> out:
> ip_rt_put(rt);
> if (free)
> kfree(ipc.opt);
> if (!err)
> return len;  // return a positive value
>
> the ip_make_skb failed means the send operation failed. but a positive va=
lue is returnd here. finnally, users regard the operation was success, but =
actually it failed in kernel.
>
>
> the comments i marked red is the right way i think. which i think is a bu=
g.
>
>
> 1031265646
> 1031265646@qq.com
> =E7=AD=BE=E5=90=8D=E7=94=B1=E7=BD=91=E6=98=93=E9=82=AE=E7=AE=B1=E5=A4=A7=
=E5=B8=88=E5=AE=9A=E5=88=B6
