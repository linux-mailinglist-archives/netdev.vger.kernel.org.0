Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BD956005A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiF2Mp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiF2Mp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:45:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34F2EA14;
        Wed, 29 Jun 2022 05:45:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e40so22055270eda.2;
        Wed, 29 Jun 2022 05:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F9B2/GHylPEkzk+guQHu18FKr2nBvjpNRS2pF7eaeSA=;
        b=mkktxYdmYW96695r03bgzKcxp8DF0CntoClY1Zor4PQe/ZlQqsfRMOw12mpMSqjcAr
         ayTFgRHl56lUgMvUeVKDOi1qH+pWjbhHFl6d2AGIxiONc0j8ml07f0lwkI7GdVNbJqB+
         nKKdUh+8lCjAZ+4M1YdXsjQ+rKMxaGdO3OfYZlE6FFeZIyFNGkHUpnGSp51Bz9TXT5g9
         E+4ccz5Alo6VBKjOW+R5UHlAiyud8w8ocTzWZ6whzAK+y9DvngVT6fpavwAI/oAClWiA
         GlsgTWaFjB+tzCwS1w0GT0Cj9Id+rbKHGnAufUlYaUWbdCz//ulWcdCpewv5JQhjCYd5
         dOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F9B2/GHylPEkzk+guQHu18FKr2nBvjpNRS2pF7eaeSA=;
        b=MlfUefYL7Uq7Dv/PdpOpUqHQvLZOZoD3srQ68TCaYvL8SbhTJr/5PlYLQ72G4Oo5bg
         seqRDccn/Mfy5VgJvkWwjTdBVBvjzJIstu7flVpvR0CmBeUdRIG7fG8jT5I0kvHbXheF
         QZYnW+E3Nlbq06RTs/pRnAebhlIflgDUgDDkfXCiBL9iAZOL66JAUO560fqx1I5Y22n8
         0nQt4uEVM0vDCJxHSLHQbajv4X6dOYEMJN5awnx15TkKXmuZTVTxtKMT+kczWDLWl3Z/
         ikXi3FbIoRasGVdQzD+eyzEUpwiFgGtfsxxENCA2x8T4/ULb2smStIt2GSJMT/CYYpzJ
         /e6w==
X-Gm-Message-State: AJIora/xSuk5cTTLhkHQveyik2EuE2cjKSfesfSPUyQiO+kjHjwhQNPf
        JXP4jnZUDcW/iKCoSm+KnOC2JcbOABgsa6RVVfbNHBBieOI=
X-Google-Smtp-Source: AGRyM1uUrUyhumzdXveovgxMe8AZGnrP5uQWW6CcJ+1Lbm2AzN6Ywg1CU0XgHzkbJiPrZPvUgXr+H5bvRMx3+ekdu0U=
X-Received: by 2002:a05:6402:f14:b0:435:7f82:302b with SMTP id
 i20-20020a0564020f1400b004357f82302bmr3987124eda.57.1656506723926; Wed, 29
 Jun 2022 05:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 29 Jun 2022 14:45:11 +0200
Message-ID: <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
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

On Wed, 29 Jun 2022 at 12:58, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> When application runs in zero copy busy poll mode and does not receive a
> single packet but only sends them, it is currently impossible to get
> into napi_busy_loop() as napi_id is only marked on Rx side in
> xsk_rcv_check(). In there, napi_id is being taken from xdp_rxq_info
> carried by xdp_buff. From Tx perspective, we do not have access to it.
> What we have handy is the xsk pool.

The fact that the napi_id is not set unless set from the ingress side
is actually "by design". It's CONFIG_NET_RX_BUSY_POLL after all. I
followed the semantics of the regular busy-polling sockets. So, I
wouldn't say it's a fix! The busy-polling in sendmsg is really just
about "driving the RX busy-polling from another socket syscall".

That being said, I definitely see that this is useful for AF_XDP
sockets, but keep in mind that it sort of changes the behavior from
regular sockets. And we'll get different behavior for
copy-mode/zero-copy mode.

TL;DR, I think it's a good addition. One small nit below:

> +                       __sk_mark_napi_id_once(sk, xs->pool->heads[0].xdp=
.rxq->napi_id);

Please hide this hideous pointer chasing in something neater:
xsk_pool_get_napi_id() or something.


Bj=C3=B6rn
