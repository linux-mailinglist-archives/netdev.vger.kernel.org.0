Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91A6EACBB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjDUOVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbjDUOVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:37 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535BDC677
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:21:33 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-325f728402cso695825ab.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682086892; x=1684678892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5+C6NfuJNAhAxOI6zMo3D7L7jfA43YGoHVKgeW1YBY=;
        b=Yfzy9wOR7Pi7eDwQXwjXgisJJYtH1mZ/Xi07kQ84EF6nogfkh4g3Q+mbztQRcRA+pZ
         4u132+L5PppeRLDFuFMPGVVtjWgCujTt4PGwWZSnAplhOzzfluX/YXEpfGFaGS3//4pI
         x2h4xB159pU7pmfGk9/fRAXLuxkedJNbLzNZYoY3JOXwazd5JewQieGKgdmMvjgbfThq
         ScgJapQPDCcJIV30AFY9L0RiYzuduU0uvNLPdGmXl1p5Zqz1Ljy9gvueEXhVmYzhe8fL
         ick1JJaJXC/vkxhgxTP0uim97CR54h78AO38OwNuAAwpnyRaEHdjR4PdDBUqluN0vTdZ
         qdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086892; x=1684678892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5+C6NfuJNAhAxOI6zMo3D7L7jfA43YGoHVKgeW1YBY=;
        b=kyyNQudC2BWmFaSrcyfXkprFUj2UUgWt0QJ1GvGNqIHoxauC2ekBpde9Lx/0sPhbT8
         puvAx17wB2/XW9h2ai/d0NfIB/2SZzk3NCTQZPkVXeOc85B1BVptRvzoHG30XB3E0ovw
         O/nvxlMNLNSmhbN17tvMAlN0u3nOx5gfp2KQnmiDfAbvo8kDPPead8oetvI5dizx4Au9
         Rcf/EwRdgPZRypiTIR5Jgi99x7GgRjbKo0Awf0CpmtN9T1bMIgOHPHVGC+jhC/OBTkGi
         9dPq8/bSW6N/MqI6v2HqJPKrIIuBvp406Bwjy3Rj39wkgN3bSjNfObzKJ2o7Pw6taz7c
         5+lQ==
X-Gm-Message-State: AAQBX9e0g+C+XWci8+qBwnShlZCq9GiGIpZaOHTVtyK4/q5b7t3d59Cc
        RGDNxEHKFIAXZJ7EnpX5fi5JazKl5X6LGQzNhh1wJA==
X-Google-Smtp-Source: AKy350YTrFDjDEmxCbEslekk40tuImwCYrEPDoUtsE+dPH/6N52N9wgGQJYDTPKdtGGFL+QYkILnSuzIBSWjWbVD3lI=
X-Received: by 2002:a05:6e02:18cb:b0:32a:db6c:d51d with SMTP id
 s11-20020a056e0218cb00b0032adb6cd51dmr327630ilu.12.1682086892452; Fri, 21 Apr
 2023 07:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com> <20230224-track_gt-v7-2-11f08358c1ec@intel.com>
In-Reply-To: <20230224-track_gt-v7-2-11f08358c1ec@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Apr 2023 16:21:17 +0200
Message-ID: <CANn89iLUDXz9VAtCQ6Gr2Jkxogdu_5g0tN9iCkAB0JD_B_05Gw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] lib/ref_tracker: improve printing stats
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
> In case the library is tracking busy subsystem, simply
> printing stack for every active reference will spam log
> with long, hard to read, redundant stack traces. To improve
> readabilty following changes have been made:
> - reports are printed per stack_handle - log is more compact,
> - added display name for ref_tracker_dir - it will differentiate
>   multiple subsystems,
> - stack trace is printed indented, in the same printk call,
> - info about dropped references is printed as well.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> ---
>  include/linux/ref_tracker.h | 15 ++++++--
>  lib/ref_tracker.c           | 90 +++++++++++++++++++++++++++++++++++++++=
------
>  2 files changed, 91 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
> index 87a92f2bec1b88..fc9ef9952f01fd 100644
> --- a/include/linux/ref_tracker.h
> +++ b/include/linux/ref_tracker.h
> @@ -17,12 +17,19 @@ struct ref_tracker_dir {
>         bool                    dead;
>         struct list_head        list; /* List of active trackers */
>         struct list_head        quarantine; /* List of dead trackers */
> +       char                    name[32];
>  #endif
>  };
>
>  #ifdef CONFIG_REF_TRACKER
> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> -                                       unsigned int quarantine_count)
> +
> +/* Temporary allow two and three arguments, until consumers are converte=
d */
> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, =
_q, ##args, #_d)
> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d=
, _q, _n)
> +

We only have four callers of ref_tracker_dir_init() .

Why not simply add a name on them, and avoid this magic ?
