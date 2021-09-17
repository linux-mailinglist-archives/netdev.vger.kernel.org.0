Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF9740FE23
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbhIQQth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244635AbhIQQtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 12:49:31 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E44C061764
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:48:09 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id bk29so19320702qkb.8
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wR3Cge17MmW0C/wFwIkuwW0vhWinSIKQL4zslzCVJSM=;
        b=TOyudvBR6pecijFVuc93gHbV2tInqmXi3fFOhiyk9nAFHgfcdCUf6txaS6yXwW6HUV
         bjgGfwKhJJj1s6kfMqeskkE8bbGqmCmAbaxT36donNMXIeJK5+J/F1OWXCiGFW9TRGJf
         vNpNstshLKA/Yo+AnV1PHZH+gDLdnH9DSRLAjtbWf2WFXxG4dQyivSKCelFPBOxUM0OT
         JQuzgWRfA16AlA7sBF1DXoPPHW3NBVY7b4eKRSPyjGhe4SwkeVY6MuapeFCqsnKSRzAm
         FrUKGNTnk/ijKT3SJBDf9hvx3YKBeoIhxbq8DUrd/E0yMkjdI4HFGB+UR51qfBJwMVG5
         DR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wR3Cge17MmW0C/wFwIkuwW0vhWinSIKQL4zslzCVJSM=;
        b=iBOHGhWO+81KX9vcTij1XEZ6d8Z2DDy5KawpbNWbVFBMyCTv7ZHfo7R+NxbgzpaMhx
         z4a0UDvByPNtW5o5P9Zd8ionrWNJx+4b0YJdXe06lgsMII38AiMgzW6KTyviSftg16RG
         6rj33VkMqCGf92VLsACtJeKyYzQ4tlwcj90W3jfOhd06x+uHBJfh7ZlJSaJ7+qkl/pW3
         dtJ8WbZbbnZu/9sAvX3acMVuPAwJFOzybatupbl5KQ9scTXPoABiY7fFZD6cDqZtuk4a
         n7Q24XeztV2VbS0qAtRTHlMb6MfV6wDQ1q+xePb00T2U7uVMKrCIuzzmfV+g+iT7QB2L
         CAiA==
X-Gm-Message-State: AOAM530fHRDB1Z4pM9Bx2z+mu6qB++YtiPpoqt3ESVJIaZqet/Trt5cJ
        vvtGl2iwtVpNf+3uLO92liON2cSjEbbJAO+SeB6TYw==
X-Google-Smtp-Source: ABdhPJx/RMx7Jy1FxwshuCXU4vaskb7Aw4Mde0Qdeag3JDzQ+DzMXYmk4uDor8koAs0zFuRQ4d4o3QjbgAkCsNhpO2M=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr15755593yba.225.1631897288414;
 Fri, 17 Sep 2021 09:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631888517.git.pabeni@redhat.com>
In-Reply-To: <cover.1631888517.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Sep 2021 09:47:57 -0700
Message-ID: <CANn89iLOL0er35k=G=BeDKtOcA6Rn3n3k+pgVQX8bVFdA1w_Dw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] net: remove sk skb caches
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 8:39 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Eric noted we would be better off reverting the sk
> skb caches.
>
> MPTCP relies on such a feature, so we need a
> little refactor of the MPTCP tx path before the mentioned
> revert.
>
> The first patch avoids that the next one will cause a name
> clash. The second exposes additional TCP helpers. The 3rd patch
> changes the MPTCP code to do locally the whole skb allocation
> and updating, so it does not rely anymore on core TCP helpers
> for that nor the sk skb cache.
>
> As a side effect, we can drop the tcp_build_frag helper.
>
> Finally, we can pull Eric's revert.
>
> Note that patch 3/5 will conflict with the pending -net fix
> for a recently reported syzkaller splat.
>

Thanks for working on this Paolo !
