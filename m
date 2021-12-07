Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78146B7BB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhLGJqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbhLGJqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:46:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDA2C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:43:13 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id p13so12949785pfw.2
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 01:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FzDW6JacTQj2bqZeEczZbqjuOv9uOmLcLIymVuDQTds=;
        b=hh9JgG3MpQkyPC9wvVPdgfCYd9Mxp0KNxiyPxiUNRIZn4UBncb/s4kBAOT5ImKZkye
         j7q96hyEy6k5iy7TO4fQ+1Mdt24aKJMudeb9E+/BDUj+6fhpC7gEFDB8M1FHxhON06vD
         4CeNTWvGWl+ZF29oYchJI9rAkqhUZ7wqIs/IQ8+3pvyFAO8bHydr6Qe1BYeE7N5gWPsR
         Tt2rAlUWGBNrcIEtimAoQCRBp3ZuBf63Vc77qtzJ0oPdcMLyhBZgtsz/djrBpO0oKDGm
         KMAxEx7w9AxxOgLSs5y9oWZsSvV346Lol7IIYYAduNpOnpUMYPFsx6wx6jsvUyUk5Mig
         IjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FzDW6JacTQj2bqZeEczZbqjuOv9uOmLcLIymVuDQTds=;
        b=HD59qwKvHqxaJ5IMeuWVloS+lr+6Lv5lpgkXlbMgjz/tEkrSOa3/YheORu4+lOothj
         lMkdR2T5L2DBxrFhrzfvAcobVPwSzRs5TZxukhFvG7twOcIlP6dODTfUHtLVpo93f1Md
         tBR6K4e5cRUMVUtap/s2A1qdP9AEeHhrFdmWsrcjR8LyieXv4PMUyH9kjVqsQus45CY6
         tEpP7txK73bgvm3zDKdx/nLLNaCqix/f88xqIJOPvZUwdklLiJQRnvzfscHEuxQIlJjN
         0e9g3gOT+PPm7BaAWtQduuPZmgp+Ks4prHaUAjmwUeu6X50ip4KZLt4FQaB1xKmaQPUM
         tMBw==
X-Gm-Message-State: AOAM533S7WdU3UhkKZxKBXBSDj2fpjQuS/YFaocNOX9nzlyrOxHymoCJ
        yAPe2Bk4+Q5waBx5hTsbGjlj2iT/t/AFzBI5gU1n/Q==
X-Google-Smtp-Source: ABdhPJysjiECCka2Dfa97QcUJk5DR9PW3cLcB3RGRq2WMBqndhmb/5A673mjhOxKQ+xgPkBBYwKtp7Nc6DmVIzo4emI=
X-Received: by 2002:a05:6a00:26ca:b0:4a8:3129:84e with SMTP id
 p10-20020a056a0026ca00b004a83129084emr42599615pfw.74.1638870192920; Tue, 07
 Dec 2021 01:43:12 -0800 (PST)
MIME-Version: 1.0
References: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
In-Reply-To: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 7 Dec 2021 10:54:46 +0100
Message-ID: <CAMZdPi_yk_W6Fn3pXeRBH-YB+Y6yOKMKUOrQ8nv=WOBDKe6XaA@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 at 10:21, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Resent after dependency [2] was merged to the net-next tree. Added
> Leon's reviewed-by tag from the first V2 submission.
>
> This is a follow-up series to just applied IOSM (and WWAN) debugfs
> interface support [1]. The series has two main goals:
> 1. move the driver-specific debugfs knobs to a subdirectory;
> 2. make the debugfs interface optional for both IOSM and for the WWAN
>    core.
>
> As for the first part, I must say that it was my mistake. I suggested to
> place debugfs entries under a common per WWAN device directory. But I
> missed the driver subdirectory in the example, so it become:
>
> /sys/kernel/debugfs/wwan/wwan0/trace
>
> Since the traces collection is a driver-specific feature, it is better
> to keep it under the driver-specific subdirectory:
>
> /sys/kernel/debugfs/wwan/wwan0/iosm/trace
>
> It is desirable to be able to entirely disable the debugfs interface. It
> can be disabled for several reasons, including security and consumed
> storage space. See detailed rationale with usage example in the 4th
> patch.
>
> The changes themselves are relatively simple, but require a code
> rearrangement. So to make changes clear, I chose to split them into
> preparatory and main changes and properly describe each of them.
>
> IOSM part is compile-tested only since I do not have IOSM supported
> device, so it needs Ack from the driver developers.
>
> I would like to thank Johannes Berg and Leon Romanovsky. Their
> suggestions and comments helped a lot to rework the initial
> over-engineered solution to something less confusing and much more
> simple. Thanks!

Looks good.

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
