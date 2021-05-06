Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB77375CA9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEFVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEFVNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:13:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF51C061761
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 14:12:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a4so10400698ejk.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Bo72AhzB7+YSm7P0FOaU4jBEaqpN8AUfQcj2KwnpSs=;
        b=EmQm6WP8xnBarAmW0tbVcq2guRKhMynQBssqW77oYTTdGxewJWfZVDB7LniaaCTfDn
         3bFKOxj88KY6VTLGpdEY2lh/ra0Vn1rJemjOg7n3rVimIDr61OB/Z2pY+HRawUccNXgg
         fiASLFCrI9IPpv07Oi4CW8zxL91BVT+bcVcPaQoEWcB7Wi1fk1cj3JklcQOQBcgj4JTL
         24t3DafoFc7WEltRLDt/ou3CNVV4DoH+mi3LzP7upvhVpdz+YIFEUOu1b7nA27X9Zi5J
         6Svj+cRemnJEIyuoBreK8bch+ytTxgYqxfEg1BzU7fJGeBdMDLy57hL37qwjTAFrgTMa
         wuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Bo72AhzB7+YSm7P0FOaU4jBEaqpN8AUfQcj2KwnpSs=;
        b=RjDwncM59MMuSNs8F5QUzGUEcf8MC6oCSUYjDHLVxpbZa0L/kWVC9bIm8LeN+3WgPY
         tu6sNaT+H0502j0qcm0XZ3IBzpHgVRYoPFUm9mPp80JSg6PnsWLqcShaQzpF7I5A2+wU
         +01OpepuJy49xph59it8SLdSNlH5UAWPIL+Oit2LATdqMt1kHseiRrZi+AQ/DLjhV+9i
         fsx+8Kus8KkybnW3ML8fW1m56jWfC715bvtmI41JoQ0PgirYW54aeYaJJt5DoSbS/a4G
         sLaeq5SkXtG2fk4i5g7Kx+j6YwrX2Nsf1+y6ligsimeTV01oV/jYyRxlxOCKlDuKYqxR
         O+3g==
X-Gm-Message-State: AOAM532HC/4nmCXpuDlBNrD5vu1QvvyV9wGUR/SY0XV73EtEYBXoMeRA
        nSBkUUOt0Y6HiCslJOXfXhvrVaQzs5vni1QEg8AktA==
X-Google-Smtp-Source: ABdhPJyRbsDtuDRJDSnnFr/ZTy4qRioqxLMO9sbJSoNwal2Fa23tpqV1RXhjMDeUEmMOfv1ttwnH7JanY0o40ElFWAU=
X-Received: by 2002:a17:906:e206:: with SMTP id gf6mr6430277ejb.434.1620335527095;
 Thu, 06 May 2021 14:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210506180530.3418576-1-wdu@google.com> <cc2f068d6c82d12de920b19270c6f42dfcabfd11.camel@sipsolutions.net>
In-Reply-To: <cc2f068d6c82d12de920b19270c6f42dfcabfd11.camel@sipsolutions.net>
From:   Weilun Du <wdu@google.com>
Date:   Thu, 6 May 2021 14:11:55 -0700
Message-ID: <CAD-gUuCt5ugOyo-9Ge5omTgNJu26OORZFEZ2tSnQEiNLZN9ZyA@mail.gmail.com>
Subject: Re: [PATCH v1] mac80211_hwsim: add concurrent channels scanning
 support over virtio
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@android.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 11:19 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2021-05-06 at 11:05 -0700, Weilun Du wrote:
> > This fixed the crash when setting channels to 2 or more when
> > communicating over virtio.
>
> Interesting, I thought I was probably the only user of virtio? :)
>
> johannes
>
Hi Johannes,
Actually, Android Emulator uses mac80211_hwsim for wifi simulation
over virtio and it's working. This patch fixed the crash when we set
channels=2 to speed up scanning. I am trying to see if it makes sense
to upstream this patch since it's not Android-specific. Thanks!
