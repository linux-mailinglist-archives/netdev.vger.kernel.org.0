Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7063F1AF
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiLANdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiLANdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:33:53 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3104BA9EBA;
        Thu,  1 Dec 2022 05:33:53 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id j196so2060148ybj.2;
        Thu, 01 Dec 2022 05:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mgBru6opZm5dT+bc8YJUW5z7lC11NxW3glA+KWJ3dmo=;
        b=eMXCzoG700EfPDc+sO7wQFVVoCOj1gfoj5vE0GsKr7ccrbx/ac9S4f/+lk0CRIx415
         SHEuLON4SYa8+2G0/263PqOtVuisaXRIfSSGFH83EapUgdq6CcLjBUv0N6nqpudKTcUl
         ma0TwghTnHsVMSgwz9S6NmxUFm/ASQ0zw+XtXDVVhjK1T9aKxonfNBTEF+I7uml6ck0b
         o8zLCR91HMcm+6RkSY8CePEKrF1Lvcd3JZxQYNRKXkvB3AkR2Fx2/0gVobteAPjIoAUB
         ZdATWoJ3eLbk2LiAMO78CMxq2trw921mdWB5+ZD7OnsDYNABdKp3Vtjhym/ynPd/0Gsz
         J2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mgBru6opZm5dT+bc8YJUW5z7lC11NxW3glA+KWJ3dmo=;
        b=VhUcd8aQ7kppgytxQVi50aijjeejFDAtP78cR5A/kbjK3pQLWUcEZW8rABfj6XCesd
         wIy4UfvhRMWU1E6rcAZXxNwpI1ke2KeFYRtghAL9xlhzx6TZjiF6bf3p+Dp1jD+tkFGK
         dQhjU9i/uDTiCNqu0iAonijRxHERNhcYA7iwWgxn0sCc2OaAfwH/Twr+bmXVwiKh5TuM
         FZHRoiSfAgjLAMEZsUH3+JwHR/DeELRAnDJuQC0Y/oZ480tV1ufwYvnlY53W60hLVprt
         hs+4N4e6IXyBtsSF/hsTlosSdADZm/Mu21XhB2yaklTnpbr1H18TN1bOE01vJ0t016c/
         fc7Q==
X-Gm-Message-State: ANoB5plHb3OAzUNaVC0ZRQ+DA4fHRrSlspQWEXI95/usCHBZYTHam4ka
        FQDV/jYmS1sETC7VNtW/f3sb0oTBVcnPrMCHJI4=
X-Google-Smtp-Source: AA0mqf5C5YFcQc9O41EMxCBC8NKruFzddcPKTY4dXIGh/HED1HS9XnoUbs9MMCFAcFba7Gj7hUXsQHWx1SXO9Rp+pAE=
X-Received: by 2002:a25:9b81:0:b0:6cf:b1cf:2a97 with SMTP id
 v1-20020a259b81000000b006cfb1cf2a97mr64907849ybo.235.1669901632124; Thu, 01
 Dec 2022 05:33:52 -0800 (PST)
MIME-Version: 1.0
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com> <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
 <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com> <add18909-4e5c-26e7-a96d-5715aba18219@linux.dev>
In-Reply-To: <add18909-4e5c-26e7-a96d-5715aba18219@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 1 Dec 2022 15:33:40 +0200
Message-ID: <CAHsH6Gt3tRqGDG5ssGZMzxB+1xToFk5-RZn319KOnB4cLnC11Q@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Thu, Dec 1, 2022 at 9:33 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/30/22 9:34 PM, Eyal Birger wrote:
> >>> +static int probe_iproute2(void)
> >>> +{
> >>> +     if (SYS_NOFAIL("ip link add type xfrm help 2>&1 | "
> >>> +                    "grep external > /dev/null")) {
> >>> +             fprintf(stdout, "%s:SKIP: iproute2 with xfrm external support needed for this test\n", __func__);
> >>
> >> Unfortunately, the BPF CI iproute2 does not have this support also :(
> >> I am worry it will just stay SKIP for some time and rot.  Can you try to
> >> directly use netlink here?
> >
> > Yeah, I wasn't sure if adding a libmnl (or alternative) dependency
> > was ok here, and also didn't want to copy all that nl logic here.
> > So I figured it would get there eventually.
> >
> > I noticed libmnl is used by the nf tests, so maybe its inclusion isn't too
> > bad. Unless there's a better approach.
>
> I wasn't thinking about including the libmnl.  I am thinking about something
> lightweight like the bpf_tc_hook_create() used in this test.
> bpf_tc_hook_create() is in libbpf's netlink.c.  Not sure if this netlink
> link-add helper belongs to libbpf though, so it will be better just stay here in
> this selftest for now.  If it is too complicated without libmnl, leave it as
> SKIP for now is an option and I will try to run it manually first with a newer
> iproute2.

Looks like it doesn't turn out too bad imho without libmnl, basically
needs a few rtattr helpers.
Will do it that way in v3.

Eyal.
