Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE568691B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjBAO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjBAO4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:56:01 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA3969B36
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:55:56 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id x4so22653294ybp.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 06:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ImenvlSZqiGev30iuxYAHjcK6h9wKIIw7n5ZxJIaiEE=;
        b=XeYXkN6WVPXsft03P0rMvKPq+E3BcQJujz9ahCDeXJBQojMzmpke9ee/87gOlo6R+q
         AmNxvXXdhLC87eMDUNSg3txvpXPxMeib8k2Y9ZyQ+dmk4v7QEwFDRke3YOqJvucAFyzZ
         zGg3YIVSHfwIf49BxGmb/55XB+JwJG8oytXS7u7T/BLDj5XC9nVHvgDWR9CYFtcIUD8q
         H8BU/LggqhsjFbPz55oMTrWNJEP750/83iHW7wfaMigIvRvzNLLfryQF8ijoB0OgOIL+
         p6m1DQchPAWBha99z8H4nnQxaKKlKFvPIq8cS/h4IbK71RUZMsdkOz2uWDYUqR6OiX8h
         mRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ImenvlSZqiGev30iuxYAHjcK6h9wKIIw7n5ZxJIaiEE=;
        b=ENfnEfHmRzww7AVG1SSMlCwXnIcm00/iVkEaR+hxxcmFjf5XLoBjHUX44hF8cuNDuY
         ly+OZBKVhsdBcCq2RVAWFRbMVN8u2oFMUFZCBFBGGIvN86b2eyJarY8miYyHX8C3J5Ff
         HnuIZUIainsSRy32b9GORkXlBJUTILAUEcO2+F5X6H+lrwyKTw6cYDSykYUytDWUaLt6
         8a2Q5SI6D495cxr5v99Cq1IqoOgw14sYOPW1jUbvmQQ11AyN3d9V/5luiJshOtYmoyj+
         Us9Y5ZrzXAn2lnvsnBo8evD8rn38c19F30TzzDFWYBU2FnI4jxJzUjN3u+r9QC5EXtQF
         pEJw==
X-Gm-Message-State: AO0yUKUVPybNIlb/rJbshVQJxM7FLj/WJmJAArNOw1RIz6UZP+TNFk7S
        fTLvHBltFwpDRIzt1p+aQS51BSFn5MfrHpjteBzb9Q==
X-Google-Smtp-Source: AK7set9/L7JjIO4yxEh5pQVxm13Hxl0z5wGOlkXzvLASyBLSIuKlydGv98i7nshVimvXehTYwx4AW5qTxPMuo+Zvp5w=
X-Received: by 2002:a05:6902:181a:b0:80b:8d00:d61 with SMTP id
 cf26-20020a056902181a00b0080b8d000d61mr407295ybb.180.1675263355464; Wed, 01
 Feb 2023 06:55:55 -0800 (PST)
MIME-Version: 1.0
References: <20230201001612.515730-1-andrei.gherzan@canonical.com> <20230201001612.515730-2-andrei.gherzan@canonical.com>
In-Reply-To: <20230201001612.515730-2-andrei.gherzan@canonical.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 1 Feb 2023 09:55:19 -0500
Message-ID: <CA+FuTSc3jJmupMuFvZs=nuKr4dask3D5CsxBtjnzUBMkeTVo-Q@mail.gmail.com>
Subject: Re: [PATCH net v4 2/4] selftests: net: udpgso_bench_rx/tx: Stop when
 wrong CLI args are provided
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 7:18 PM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> Leaving unrecognized arguments buried in the output, can easily hide a
> CLI/script typo. Avoid this by exiting when wrong arguments are provided to
> the udpgso_bench test programs.
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
