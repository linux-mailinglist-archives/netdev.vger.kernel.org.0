Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B69275D5B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgIWQ0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWQ0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:26:38 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836A3C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:26:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q5so220678ilj.1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qVbJ+Q7S5rZYSgdPzyINzBlDbSl2uBRr2T5CsignpY=;
        b=qJRGbH4FYNsW91IQdALPhHL9/n6ZRCxntu330WJrmBgRWSVs6jjnXOE1lCZ75qDb84
         dg+cE2qGS1XQvk1+VJX/tMc5CUNboZtqc2QJqFErC3kXxSGaV54cPQviU5LRV5TyijR7
         eFlxMw6Ndz0mGLdvAFTy/RXc1R/ESJOTfw8o9bze8A8Jc/sq6G7Gu3Hh4007vhBOKiMs
         05jn9NLJyU3W7JAGpLM8cPolc6YSn/GbLeRe+WHzCfSr3TlkbaMb9NUXzl33ttTsb6sj
         6IFXV03l9VCFKIBo5lBlsEPmuIA3rszcKB3KEzTehV9QpQ2kqzGZgIf2WpMpjyqAEcY2
         AvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qVbJ+Q7S5rZYSgdPzyINzBlDbSl2uBRr2T5CsignpY=;
        b=SFLzgI/uIdT/A9u9mK8T3/bPlNLdSm6x0wiLTUwyUvMd7LBS7z2vIjbVn6Ts7LhNZG
         nYZtMoYidyABh6vj3v/UalgM1LIrkrXipF52Yt799Ou2pGkRAqk2qgmEAWeA7ZSdVVhW
         I/FDUe8ZfSsEu747Isv0PZ3guV1Q/64Qo7KV4JVPG+dhdx8VTodUhqzMOLnM0x+7iVMU
         RL82WztHUaeFdoPrx3kXM1a+S5ZsnYbRDoaUL5WRZ3N78N4CUVNwJoM0yQGo6BW/uuc4
         bOOmFtAkcu3iwqCF8inPWc7VbLoUInAvm2FTfBy5tcXif0KBHobcFbKYx4t9IHgl3MDd
         hrhA==
X-Gm-Message-State: AOAM532sXmrwgOvifnCkXQowhdVDIg86lE0CSODAoIgh/Y1G+YwVE1Gt
        qQzYHciqjSzgu3B/wdjw295b7bBy2PqQ0Ng4fSIJBw==
X-Google-Smtp-Source: ABdhPJzlFs0m4W6XgcSBxKoqzx4vM1Se6Xk7l+WYg1enGzGmvMyA04AWPwzo5F2x9Lr7mZmR5DkNBAMxYECM8GQR8fw=
X-Received: by 2002:a05:6e02:df1:: with SMTP id m17mr499960ilj.276.1600878397101;
 Wed, 23 Sep 2020 09:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200922155100.1624976-1-awogbemila@google.com>
 <20200922155100.1624976-2-awogbemila@google.com> <20200922103226.1e8b90e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922103226.1e8b90e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 23 Sep 2020 09:26:26 -0700
Message-ID: <CAL9ddJdgZSktSBA+nDrM6R02Z1Gour+apEbuz+QOoZnFVtrKXg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] gve: Add support for raw addressing
 device option
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 22 Sep 2020 08:50:58 -0700 David Awogbemila wrote:
> > +     dev_opt = (struct gve_device_option *)((void *)descriptor +
> > +                                                     sizeof(*descriptor));
>
> You don't need to cast void pointers to types.
>
> The idiomatic way to get end of structure in C is: &descriptor[1] or
> descriptor + 1.

Ok, I'll adjust this, thanks.
