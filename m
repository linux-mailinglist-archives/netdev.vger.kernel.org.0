Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09606C1F25
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCTSKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCTSJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:09:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3EF2ED7C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l14so7465507pfc.11
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679335414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=By2HrF+dM2uC+wyLVH9+FbeO86XwO9j1poAl1RCgQac=;
        b=D9nni/ZkYdHGKJGNf51fnrAMn0LyM5XEiY1jJuMPNQ7k+8PrCpjH+aMAAyU4RTWvkH
         6zxVVZ2NoBsPGnYCLOMkh1bXey38NtCKrFHx6NEAtHm3mVsHHmAYpBElyfmGzXVJELoB
         eH9/V+fVhrOcmTfqH1TpjFGKrgexSMaraAf7fRj/YaRkHMHTjh+myLQ2K7mQ3k9xqn6L
         KbERBrR+jBdcOZeTewGqrRuZV/RR/uJ1dcu5VQh7oUtPugAIlOOz847J/wI/MlA1E7/O
         DiP20dqJEmTPQdp+Ix5EgeHHcSy6wTzZr7ikPQbKul40DLvbsRFuwOs7HyOfR22NUdeJ
         XtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=By2HrF+dM2uC+wyLVH9+FbeO86XwO9j1poAl1RCgQac=;
        b=B0uZPAaeLv6hxPsLYb3YRDyDptrdORMKrcg+Cmsyk9vbgg31jhvCNCuODMX0uuSsEH
         sZ6qoBOEWNeeEGdQOQA5F7AGlO3bz6X8mNF3ginM3fnJNlG+6pxgwtwnLDtQfwWeJHre
         KHcNV8EeYJ5L82MVjPDm2V7VxLlkAQignLQ6x5gwhsGqC5P6Crzt+DhVXJNJT1L9t2ar
         cnEi96LNK9cozDYWd0p8MdZG+pPfjQaON3kg3WHp8SkD2yDX+Vipt+ceJrVAVSHkQDOp
         pZBq6Us2rjMJobLhMrV3y1bCwX05Sl5cyLmvqjm6yaGD/Zf1dAEgcz+nd8+XVHEITOSo
         Reug==
X-Gm-Message-State: AO0yUKUHzhK4uiTQxj4PE456sIlFTHkloEcfqb0rNN+qXk+DHmYG5AaK
        KSloKItSWIgVk//ae2Y0YnrEW/myUBFbEfL1cWUEYw==
X-Google-Smtp-Source: AK7set+mx5lPPV7pBciUwZy/GuxSLHRwM9NA7uJSZz5TSEBYf7x5+OOICdGNOfxddJfzI5wHIN/pTKGOC8WO+i/Ojw4=
X-Received: by 2002:a65:51c3:0:b0:50b:dca1:b6f9 with SMTP id
 i3-20020a6551c3000000b0050bdca1b6f9mr2130186pgq.1.1679335414505; Mon, 20 Mar
 2023 11:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com> <20230318002340.1306356-2-sdf@google.com>
 <20230317211814.0092b714@kernel.org>
In-Reply-To: <20230317211814.0092b714@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 20 Mar 2023 11:03:21 -0700
Message-ID: <CAKH8qBshpLzi50Ps+yerbjU06JgKq8uDW7jJLLtv28Mb4Q7Avg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] ynl: support be16 in schemas
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 9:18=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 17 Mar 2023 17:23:37 -0700 Stanislav Fomichev wrote:
> > ynl: support be16 in schemas
>
> https://docs.kernel.org/next/userspace-api/netlink/specs.html#byte-order
>
> byte-order: big-endian
>
> Looks like it's slightly supported in ynl-gen-c but indeed the CLI
> lib doesn't have the parsing, yet.

Didn't know about this, will try to convert.
