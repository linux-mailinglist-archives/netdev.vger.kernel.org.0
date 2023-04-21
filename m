Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6CE6EACC0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjDUOWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjDUOWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:22:11 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1050B12593
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:22:05 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-329577952c5so693595ab.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682086924; x=1684678924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRE0WrMWpFap+y3dmkLyk4ksWv38PiYMbGEKVJWOWPE=;
        b=AnE8soA78cRTw/z6Mdl8v01EinY7b2zJC51/fkhvnxo5uCo0UL/jUJ5eGG8GHlK3q9
         /jEMi5cgCHXZY96W4+enSewpX/ixcLd+iCK8H+KhRTShFuwJT3LuyCk0JPDeGtQ0Pmvv
         HLI/WEYqsS8jVqiZz2E49H83PQPUgyz0+flfFchksW2GqE0c8RYZXnKJtBWNfwLf1LnU
         aE91dPOB9Vg6lS5Y+qM7c8I8fkR7pIyxcKyOPDs/EKeMZonyVcq3hu/VOJVghmjH3PuO
         McGPKBxcpjzc8u3VaiQw3aQhPKqqVbE5FZQcONugpSeuIDR7c0orO03m5TP30Nxd6Gbj
         vySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086924; x=1684678924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iRE0WrMWpFap+y3dmkLyk4ksWv38PiYMbGEKVJWOWPE=;
        b=RJ0izUL6PnTo7lpw85tEc1pAcqEyetluQT/caN/5GBN4D3oKbGv+6veXEtTQP+LeUc
         /KklWO9BsodwSym9cvW2bxFohWv3z97dbq1vfTOPL/jxz57Z1+ve0n8gYdCT4GyTWQLQ
         FNwrMhqacvDgV7rRQMB3F+4X/X4Sm2t/ImqSlOsyn532srmE4df3ezbb59JX5jvVj8Uv
         9QLmSXFGkLr+yelYWh1iHH6xPV/7xhfOcItQ3L5+4OiXJCCdnwZrktGLnPmeAN2sksxs
         QTJvgrxnrReXGspU4LTxEltFEgUXdckplDjOCBuychgcl8GC5IJvvT6YT+f7EA8c0cfD
         NsQw==
X-Gm-Message-State: AAQBX9c/4zqhtfCgS8Bg4M1K/p7465gxIBb45Gpz/ZSt3/TAbg1Cxvxf
        /Wd8tYtfiT3o1ie0j6eDuguZh0V+/EoC+M8yi7nX9w==
X-Google-Smtp-Source: AKy350Z5Y1EuWQtA/tAHv2ZVhpFhudRKTHIxZvAilofNgLnO6LpBNA7CYSqGbpfNSM/qyCZvw+VVotb7Zt5JQ8D2KA0=
X-Received: by 2002:a92:ca05:0:b0:32a:baa8:2253 with SMTP id
 j5-20020a92ca05000000b0032abaa82253mr322511ils.8.1682086924161; Fri, 21 Apr
 2023 07:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com> <20230224-track_gt-v7-4-11f08358c1ec@intel.com>
In-Reply-To: <20230224-track_gt-v7-4-11f08358c1ec@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Apr 2023 16:21:50 +0200
Message-ID: <CANn89i+1UML+p1N+bHFXG70V_AqOTQA7fh10_ASvThNK7gvUMw@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] lib/ref_tracker: remove warnings in case of
 allocation failure
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 1:35=E2=80=AFPM Andrzej Hajda <andrzej.hajda@intel.=
com> wrote:
>
> Library can handle allocation failures. To avoid allocation warnings
> __GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
> replaced with GFP_NOWAIT in case of stack allocation on tracker free
> call.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
Thanks.
