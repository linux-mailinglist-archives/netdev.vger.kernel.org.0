Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CEC63F96A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiLAUs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLAUsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:48:52 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479B42FFE8;
        Thu,  1 Dec 2022 12:48:48 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id d131so225757ybh.4;
        Thu, 01 Dec 2022 12:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N1ZEAITnlnIL0uo/MUd+4DILu+xpsXxa/BaZ4ECfnM8=;
        b=WyGkdNpHa5CRQ5od0hODlgB8PdqXLsW8QvZyb/PaoclhgigeVtDOtN3/X+MjBBohPg
         fAJKbCobXRt3kSOEwjShwxBMNCPezV9rp4jM/kmfzc7b2Kso9dzEd2GjJ4+k4TqzbDXn
         ozHUKBovZ6ntjxxLR1pV0xur7Dffp4PLACtNFsBUzWrvDrYYYLYcmeaar6OaIPUwnoP+
         vS2K7SzKVUydrVDxUaSB0Rt7Y1BxY1qOPkiVrDwtSCKir5Bc2kdzy+htVqDfWiHKLkqt
         +YvUdaRoOmkfsSTIDs21vTleziVaktQZe8p5el78FMqxdiRP9Es1xch6rk8FzLv5vCLs
         f4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1ZEAITnlnIL0uo/MUd+4DILu+xpsXxa/BaZ4ECfnM8=;
        b=YlFbJolxQgY/Vcoqha2jjI2+/yJ7y3Bz9h4ajNINnN7MS+ZEszoMXUmkH8hBS7ITUn
         aFs2orqRTLqp8MNI3Sr0Pdn1ZIaLOMVGELzId5Iu6DaC+l4gzjzMX2CgsocSgfa9o8Rv
         ZEbxs+0sTuTpcLAspWPTw8xnQfyWfxpHDtH3wc5d53GACI9Z50/YvMh8hIZNYrUqxQsH
         3IIjSBMKf3As4AGkiIs3hlDvsnlA2BxIKXye4v+21IvYXqYQE3t9P5lw+4xyrBRdZldH
         GbjkFvidb1Hj9K154hMiny0AO7JYD97WARSd3lgqR2kHgC+vNSbaBxRHoZT7NK0yZKZ8
         u3nw==
X-Gm-Message-State: ANoB5pl7MkfyPm8sdSeb0MN8SVA6MZ2iQ4UkTI9Ve1zPuuYthmmZhyf/
        s6IRHsXabHNWZJENGj4JoG+OfFJZ4v2HJKEmt/I=
X-Google-Smtp-Source: AA0mqf7P2XR9ZGUdtibT6H1IotM1KHS20VYF48xyhV/t4p4fXyyfUbMrklp5zCu94hmcsSe0Hctv2TNHJldLsNDIvw8=
X-Received: by 2002:a25:401:0:b0:6fa:8a4b:40b6 with SMTP id
 1-20020a250401000000b006fa8a4b40b6mr8671751ybe.230.1669927727147; Thu, 01 Dec
 2022 12:48:47 -0800 (PST)
MIME-Version: 1.0
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com> <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
 <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com> <917db515-072c-31d5-1cd2-b28bc40f7bd4@linux.dev>
In-Reply-To: <917db515-072c-31d5-1cd2-b28bc40f7bd4@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 1 Dec 2022 22:48:35 +0200
Message-ID: <CAHsH6GsDmw5qNv-9u-DfOXaUgtaGhOesEveOvX5cVcnYmjtonA@mail.gmail.com>
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

On Thu, Dec 1, 2022 at 10:26 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/30/22 9:34 PM, Eyal Birger wrote:
> >>> +
> >>> +struct {
> >>> +     __uint(type, BPF_MAP_TYPE_ARRAY);
> >>> +     __uint(max_entries, 2);
> >>> +     __type(key, __u32);
> >>> +     __type(value, __u32);
> >>> +} dst_if_id_map SEC(".maps");
> >>
> >> It is easier to use global variables instead of a map.
> >
> > Would these be available for read/write from the test application (as the
> > map is currently populated/read from userspace)?
>
> Yes, through the skel->bss->...
> selftests/bpf/prog_tests/ has examples.

Oh this is very useful! I tested and indeed this works perfectly.
WIll use in v3.

Thanks!
Eyal.
