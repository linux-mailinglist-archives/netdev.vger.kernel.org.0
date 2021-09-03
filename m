Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E76F400101
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhICOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 10:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhICOJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 10:09:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD53C061760
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 07:08:14 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id h9so12357870ejs.4
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 07:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cdPH0RUrZjKAXah7cowHX5Y+IopONEnkhgKNCSY3VPw=;
        b=Vf1l0IL5pe3MFxiQdNRXIyLZxAIBZiZdFrcYZ+LpU2j6vhQiUbAlXd4yfIpm9/1SZV
         VY1GK9B71BNVjo49ax2WMFtEeTRLW8B8oo7rgRpy3VGigfjw3xO3lXqP0YJjrwOILgDD
         TTrxgbeKlQGdbXYvykcCoNHtka7KLU+8jYrpz/98gHHt6gw3WSvrC8vA0B6pF98ixq6o
         WuKf+ulUvi+z1mYpANjUZ/pK8/Nzdgoupppl11Vfug12v7Y3c3x3/HDYZrmK6uTqrZwr
         1z/3orDN8UUCrN4wQY3fGV9CLl+hArzm6XKOrCAcExRm5aFg0kTGaQaLRQGUwcbo0GYO
         bdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cdPH0RUrZjKAXah7cowHX5Y+IopONEnkhgKNCSY3VPw=;
        b=kFrmYYpfbp4gbiKdy4lf6J319CRNrTl7qanX0LEELfRJwFjXjNtOei6/q7x6JQyJ+y
         ARD6kK/UB1Fji9FfI6FA7/n/ZwrTHAAyBCb3dAst6gXW768eKkur9wfnH8fgzrv6uH0e
         PxQ1/IOnBFcgVYKgUIMnOa1pvSPU8ml4q6MtamrjlZ/GdrgeXSoZN8YGtVvqg+H1vMMy
         xA9zDmvMQ8LuQ16snPr2JhYdB2VsxWTfIgYE9xKwHkL5WY3RDUlGKt6NELN1xQUwjPsy
         DgAojV7eou6AREQcPv0Jlw3O9sYibs2C/WMMH8FqqyO4oJhobw+9ZvWJFjbusXPKkKSR
         FIhw==
X-Gm-Message-State: AOAM530qv8r1pc4rSAqAHbOHb+K3fCZsQWhSJT+SsZ7cdFLrkj7SuKFz
        h6JNm2yXoztXhU7C6Vzew0Ltksf0PtI/JZyIdA1ilCWJzA==
X-Google-Smtp-Source: ABdhPJwbSl4jRpGYOLS5AmybLrWXMIoT85h9FP8yaT+M2JBwaP3KkPlqliaddTmXQhWSJzuTbtqTa3Yxk7ZFssRzTlc=
X-Received: by 2002:a17:906:6011:: with SMTP id o17mr4325477ejj.157.1630678092913;
 Fri, 03 Sep 2021 07:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com> <53f6b3fe-dde3-c35a-5ee1-ff480936b356@linux.alibaba.com>
In-Reply-To: <53f6b3fe-dde3-c35a-5ee1-ff480936b356@linux.alibaba.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Sep 2021 10:08:01 -0400
Message-ID: <CAHC9VhSR8ETPaNVv6506z-wji9KCbRkrgzw0bC9uNtK7nSgzbQ@mail.gmail.com>
Subject: Re: [PATCH] net: remove the unnecessary check in cipso_v4_doi_free
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:27 PM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.=
com> wrote:
>
> The commit 733c99ee8be9 ("net: fix NULL pointer reference in
> cipso_v4_doi_free") was merged by a mistake, this patch try
> to cleanup the mess.
>
> And we already have the commit e842cb60e8ac ("net: fix NULL
> pointer reference in cipso_v4_doi_free") which fixed the root
> cause of the issue mentioned in it's description.
>
> Suggested-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> ---
>  net/ipv4/cipso_ipv4.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)

Verified that the v2 patch is in net/master so removing the v1 patch
as this does is the right thing to do.  Thanks for sending this out.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 7fbd0b5..099259f 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -465,16 +465,14 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def=
)
>         if (!doi_def)
>                 return;
>
> -       if (doi_def->map.std) {
> -               switch (doi_def->type) {
> -               case CIPSO_V4_MAP_TRANS:
> -                       kfree(doi_def->map.std->lvl.cipso);
> -                       kfree(doi_def->map.std->lvl.local);
> -                       kfree(doi_def->map.std->cat.cipso);
> -                       kfree(doi_def->map.std->cat.local);
> -                       kfree(doi_def->map.std);
> -                       break;
> -               }
> +       switch (doi_def->type) {
> +       case CIPSO_V4_MAP_TRANS:
> +               kfree(doi_def->map.std->lvl.cipso);
> +               kfree(doi_def->map.std->lvl.local);
> +               kfree(doi_def->map.std->cat.cipso);
> +               kfree(doi_def->map.std->cat.local);
> +               kfree(doi_def->map.std);
> +               break;
>         }
>         kfree(doi_def);
>  }
> --
> 1.8.3.1
>


--=20
paul moore
www.paul-moore.com
