Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C395240FE0C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhIQQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIQQnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 12:43:11 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572A8C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:41:49 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id y144so19302639qkb.6
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aBN/qteeDyWq3TS58wIG7jkerkKlW6l9HEuk/o/IJuw=;
        b=r5mpIFNZvGulvdrw3rSLgYXpkDniFlpqk5vIULMa+KB0DSjC28smVp6qRCp2hx55KZ
         C4sTR9D7nkm8LoE9ZXEqyiL7m2oIlikhWrHvuPrW8t73lOOGv29onrZwgMYuDfgG6G51
         QUnP3bJlu6rxqfxLYJVgkB1SdeBqcNVzWBUooCooS2O+eVHQat+mW4JxvG36gYoGErEK
         AulBCrYlpJTodeN2Z9BvVIB24MYOZnJv36Kcns6HJWf3FDP5iUYcae97ZrJ2j6liyXp7
         YpSVbh+ZLL8UK4jj+BK4JmxMhc09hMRnUzTvpLwtnsVSRD+PW3axVnyOSV1/ekEg4ud2
         M/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aBN/qteeDyWq3TS58wIG7jkerkKlW6l9HEuk/o/IJuw=;
        b=Xwu+/hqJq5pRA1acifLrVCVoROU2t1Upu1xgtGukUZ6LyXM8n2IF5rGWgVEePY7i1T
         kKiaFgsrDiNb56I6yByp1y5Aa+ehgkTinPIAmAFBBte6ZAQaY/A56aw4LaHNJSbIfdiB
         iyiGjLyJZzDtqFgsZQvLhgZ3duhaSE0E/INdQ5pOVC0isP+pr+A6IUxsZWtL8aXrGj/p
         9P9Oeamogl7LsOfqKLNfqUdgaxJAYs1D+Iho/lQU0wl3CXaFjsYu62BBHH8+WD0/fNIg
         7J4Ndx9qo9JzTSQade+4SQKsd09TJ/FSqKZo7n+DDpdGOd8rJA6rJePoMiTrQ5bUoHVL
         AVGA==
X-Gm-Message-State: AOAM531zJd8ZH6cxVqvGvAqlIWsMcIi3AS1dq6sPhRmkGMLm/3CJTPiY
        mxq+bKfd6dZUsq2lxqk6hc1SJd7KV527IM0NrWrCOA==
X-Google-Smtp-Source: ABdhPJx8xbbL5om+QcGPAEAT3lJo4fDv/2nif/i01ZdnYHpFl6YANYMunB9IPePN6HRZD/WUU4luVE20BYE6hg38u5A=
X-Received: by 2002:a25:c011:: with SMTP id c17mr14015458ybf.291.1631896908105;
 Fri, 17 Sep 2021 09:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631888517.git.pabeni@redhat.com> <aa710c161dda06ce999e760fed7dcbe66497b28f.1631888517.git.pabeni@redhat.com>
In-Reply-To: <aa710c161dda06ce999e760fed7dcbe66497b28f.1631888517.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Sep 2021 09:41:36 -0700
Message-ID: <CANn89i+e7xVLia3epGLpSR70kxuTMyV=VtKGRp3g0m56Ee30gQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] Partially revert "tcp: factor out tcp_build_frag()"
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
> This is a partial revert for commit b796d04bd014 ("tcp:
> factor out tcp_build_frag()").
>
> MPTCP was the only user of the tcp_build_frag helper, and after
> the previous patch MPTCP does not use the mentioned helper anymore.
> Let's avoid exposing TCP internals.
>
> The revert is partial, as tcp_remove_empty_skb(), exposed
> by the same commit is still required.
>

I would simply remove the extern in include, and make this nice helper static ?

This would avoid code churn, and keep a clean code.

Thanks !
