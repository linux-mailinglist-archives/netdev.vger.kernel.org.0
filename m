Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75AD6EE208
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbjDYMmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjDYMmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:42:40 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91B15274
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:42:39 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-325f728402cso65795ab.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682426559; x=1685018559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0R1shJ74GFraG54ZrBarpqRCUuus8sKdN1oUXtaP84=;
        b=Txr1tOrk3lncYAjQ+XMeFFNMCc+1J+OALg7JKpiQBoGjaklUAoF7naIJRGimpawtAT
         sBwfNg3ShbonS7fAYTnDKd8acfn0g/kxsYXUTGtlCL1Qy6BR5MBLMh0HlczwgLCPU2UM
         hxqOojx9hcV2PtMT9EIJLQ0BoQlNx1RJRftyusZek6lsTVIinhBDP/0Zxi1jPHE5QdnY
         QoEQNPmaJTOFlqVpP3501bAnYvcxZ2DD1GTLGJP/h5vMhnexw+5uaUIRpWAf51qdrBCJ
         9aLV2IvA5Lwlnxp9mJM1IvB38YgGaO/bvvaTwj9D7rbiJpNsaOyKEFreNarahBZxQ7x9
         KjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682426559; x=1685018559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0R1shJ74GFraG54ZrBarpqRCUuus8sKdN1oUXtaP84=;
        b=chhvvURcTVY3pnu3xwaXzheMtBNKDc2LB/mKMUvZNEXzdJkXe9MCUUSg0Jfl3vsFfF
         L1CR9qgEFFSrOGSgzSwvKOwM0o8E6TA0hFHvoMezgJT1kVg2YZZ+5U8oJPJuAX+30uwK
         DZkbowmzZyl/+MgMkwk0Kxi5xdKAAoO7NzSmeka8LQY/7EJak5ZzQynQfAO89sQMvguB
         SS7OqA7s4bmeO2XurH+RKCiorVv3eK2BTPlWEg1eHgFiqVXJNl+ZCA1eKsLpWyggC5r9
         5r6UrERnEbDAICkn0eex86WbGHP753EaW/BMu2Ca1Cvm66/wEl7/lTEENfP3pfLLhddx
         iEaA==
X-Gm-Message-State: AC+VfDz/lRik/B/zB37JUO+JBCjVvHkJHCgAvGjkMiSK8JWtqTg0TG6n
        NQJ2rrm7OSb6LztZdqqnlNTEER2BFSwlgf/eLtfbCQ==
X-Google-Smtp-Source: ACHHUZ4GKysEbVSQRjtwRSfZ4ZLt12ToKr+xCMJTS781tmsqaX3mnDD1C2HU71jSpdl2+drmKJQM6Rb/08AWXEtz4SE=
X-Received: by 2002:a05:6e02:1aaf:b0:313:93c8:e71f with SMTP id
 l15-20020a056e021aaf00b0031393c8e71fmr174325ilv.19.1682426558867; Tue, 25 Apr
 2023 05:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com> <20230224-track_gt-v8-2-4b6517e61be6@intel.com>
In-Reply-To: <20230224-track_gt-v8-2-4b6517e61be6@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Apr 2023 14:42:27 +0200
Message-ID: <CANn89i+yGztnfz-ZMwcpPTVrQ_bxvmKC5wrJ70WUZvwAAJqJzg@mail.gmail.com>
Subject: Re: [PATCH v8 2/7] lib/ref_tracker: improve printing stats
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

On Tue, Apr 25, 2023 at 12:06=E2=80=AFAM Andrzej Hajda <andrzej.hajda@intel=
.com> wrote:
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

Reviewed-by: Eric Dumazet <edumazet@google.com>
