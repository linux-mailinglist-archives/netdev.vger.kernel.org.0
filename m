Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533F36F3910
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjEAUSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEAUSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 16:18:22 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE010F8
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 13:18:21 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-55a14807e4cso32537727b3.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682972301; x=1685564301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+d2uH7xxq4P/Ev1fuG+f0cbaiUvowKMv7JujrUwlseg=;
        b=a6rl5xWK9hAEvtA547Z+F7Fp4KFQfsw8wjM4cQYVcWO2W5Ja6Dcr7qC1MPQAx8kaiN
         7UjIuhl8OWp4KyA5d2N55+3PuAj6Cncpv1jizgV8AWd5jrc4v6pFh2DZofJeMEPLnmNI
         GGzhSrRqgzbYKYTurq7y1hLjs/bkb4jDeMFi1uKAUHh5CQnTGzmI431A1+HOOdlMgitG
         v1n1QXnPhPlc1TVWvy++nvsqPnYSfr0VNkJxPUASdJSRLo5o/Epi7kbWEJTGpl9EwECb
         4XaMZ2v0je35iceORLQAbX37BB+ABJ2zcYvQVkPavtivd7DA1Nl4aLNRI8TiXj/YCoue
         wXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682972301; x=1685564301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+d2uH7xxq4P/Ev1fuG+f0cbaiUvowKMv7JujrUwlseg=;
        b=I0XFs6NGgjy5fVn7K+8KVQAQ/NpfQFXoOsqhhM7lFumR5horvfcxuEKSRKadxdSmEk
         RALg0is+F05X6+m6IhvWqKgxtVGfv3hiZY+ql4VaeUYRkkaYiIXBWC0zEKHdqayFE7nX
         oa7u3OeADrol/VDor0+Co8pS+WJCY+L8tGMdUhuGgM5bP4hykqV/MAbUXZvLDIOfpi2I
         kSEKhtfKxdjinbZoBTefvIrLVyrVh/eJWEQBfry94BV5MkTZDQ2fMxvkVK7rX2hK5aE7
         9Ge0Q7V9Sh8E4lpYvG7nOILRtNt68P9Tex+e+jBWHzLEAzJXsAYN3QnuPx4PgijPXFWD
         Ut8w==
X-Gm-Message-State: AC+VfDywO1KFk7Yb8arHKBcsodYFCp5GEolwS7HbHDOPsZF7NX6/iOVA
        tJys8fbsX/TfRTFtNxSavR7I43T6rk+2l7r/yoaCy/QnvFEvOQ==
X-Google-Smtp-Source: ACHHUZ4fW6bvqiisNIRA8xy2C8bI7j52JhDpWCchThIK1yKqmVxzvbXWzhsapvd25y1+qyG7lFEVa3eBR8rlpBIVi8o=
X-Received: by 2002:a0d:db86:0:b0:55a:2fbb:4790 with SMTP id
 d128-20020a0ddb86000000b0055a2fbb4790mr5679761ywe.12.1682972299373; Mon, 01
 May 2023 13:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1682807958.git.lucien.xin@gmail.com> <b73c0deb97ca299207d2197db28f78d3992fbdbf.1682807958.git.lucien.xin@gmail.com>
 <DB9PR05MB9078A5939A8D21C278136820886E9@DB9PR05MB9078.eurprd05.prod.outlook.com>
 <CADvbK_cbgUh4XN2C+xQuM6PKSXEW2LLyE0E2QtePeTce6NdP-g@mail.gmail.com>
In-Reply-To: <CADvbK_cbgUh4XN2C+xQuM6PKSXEW2LLyE0E2QtePeTce6NdP-g@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 1 May 2023 16:18:00 -0400
Message-ID: <CADvbK_fB0NqDuo_ObELfqDGrTxZShVXxyg6FLfeHq1NoKE7zTA@mail.gmail.com>
Subject: Re: [tipc-discussion] [PATCH net 1/2] tipc: add tipc_bearer_min_mtu
 to calculate min mtu
To:     Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     network dev <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 1, 2023 at 11:35=E2=80=AFAM Xin Long <lucien.xin@gmail.com> wro=
te:
> On Mon, May 1, 2023 at 1:21=E2=80=AFAM Tung Quang Nguyen <tung.q.nguyen@d=
ektech.com.au> wrote:
>> >@@ -760,6 +760,7 @@ static int tipc_udp_enable(struct net *net, struct =
tipc_bearer *b,
>> >               else
>> >                       udp_conf.local_ip6 =3D local.ipv6;
>> >               ub->ifindex =3D dev->ifindex;
>> >+              b->encap_hlen =3D sizeof(struct ipv6hdr) + sizeof(struct=
 udphdr);
>> tipc_mtu_bad() needs to be called here to check for the minimum required=
 MTU like the way ipv4 UDP bearer does.
>
> Agree, especially after commit 5a6f6f579178 ("tipc: set ub->ifindex for l=
ocal ipv6 address"), we have the dev there.
After taking a second look, I think we should delete the tipc_mtu_bad()
call for ipv4 UDP bearer, as b->mtu is no longer using dev->mtu since:

  commit a4dfa72d0acd ("tipc: set default MTU for UDP media")

The issue described in commit 3de81b758853 ("tipc: check minimum bearer MTU=
")
no longer exists in UDP bearer.

Besides, dev->mtu can still be changed to a too small mtu after the UDP
bearer is created even with the tipc_mtu_bad() check in tipc_udp_enable().
Note that NETDEV_CHANGEMTU event processing in tipc_l2_device_event()
doesn't really work for UDP bearer.

I will leave this patch as it is in my v2 post, and create another patch
for net-next to delete the unnecessary tipc_mtu_bad() check in UDP bearer.

Agree?

Thanks.
