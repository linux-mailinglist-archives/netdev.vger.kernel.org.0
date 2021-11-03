Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5514441CD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhKCMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhKCMqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:46:35 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA446C061714;
        Wed,  3 Nov 2021 05:43:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o14so3329001wra.12;
        Wed, 03 Nov 2021 05:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=90K7h1vadNvDApkPIeu9bZ3f4TXBlF4ZUifSLTiW4KY=;
        b=Y3aeSAxzKr+wlBlyxEumnYVVH4/dPwRP+VIztBGO1BA9KgA4qe+lXR1hiibl24iV4R
         9BULyfeEGsH+b/+IBjKJjcwyXItTPKd4D4B14HprUNxI4115KjzueXWLrvRUJf8XlXOK
         ai/lYIxvgh/tdtyS/1Eq95kiZ6WAhvACitupAMWtw2y0JJTvxtslflq63HAiJogCq9Kc
         3bQqRt2E84XYTLssYtI/+0idicVw5CxZXKCFxRfAezWWTSoKh0Us2oFzMBXhIhY2nElF
         EvCDwdh40+0+pZhi9xb+0ik6I/ZdAmSH8rtYTedrvPY/IteRGThC1vFw7rUsHS4QV4AE
         XQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90K7h1vadNvDApkPIeu9bZ3f4TXBlF4ZUifSLTiW4KY=;
        b=nINGs4bpFXfyPT3lfFIw65UJrdWbXomVnqXAUXh9djJzbglitfP+iVs19s77d77Jpx
         UjbOWuqK6E475sCbL4HOOOPRBgzcC0RPP2uDwCpBoBY5dxn5INckH/GFNv/PC7iQKJER
         x8bs9WQ1G+vQrGEgG2m4cgMFvindEJJDeYB4EC4jZlwAE2PneEpzR909+BJ2RcQqtH7y
         66q+c34G+LjnhquCtlXzmTFE8lFrYdlYSF9VOApoLpYMZio4kh7pOvOyXA3LW7wCQl1/
         jTcM6dRqOdWeM7w/AWctQecJ4G6KFi0hHBRkvx2F8GJOsnwr//m+srYwzC4ogHUoOk+h
         j/pw==
X-Gm-Message-State: AOAM531hAK1J58QaNiyubD+j2z8dod3bnfzTXL7AVOtdxrL3Ij86J2rM
        754Wi+BOQaGC1WYKkgQgKr79FcP6gfZ+BNABLpE=
X-Google-Smtp-Source: ABdhPJyltS33f36MXJQ02mrMxSEGkedcKr0g9cvUzlZh2XpWAUO+CWqfV4YaBIm4SDCW4w7AWk0Wpwf1MCmM6dN0vhI=
X-Received: by 2002:a5d:47aa:: with SMTP id 10mr24412405wrb.50.1635943437431;
 Wed, 03 Nov 2021 05:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <1635884824-28790-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1635884824-28790-1-git-send-email-khoroshilov@ispras.ru>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Nov 2021 08:43:45 -0400
Message-ID: <CADvbK_fTmu4MWdwk5uTd_FEnny=_=OD=iqrq-3McQ5mgw1JnKg@mail.gmail.com>
Subject: Re: [PATCH] sctp: avoid NULL pointer dereference in sctp_sf_violation
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 4:27 PM Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:
>
> Some callers (e.g. sctp_sf_violation_chunk) passes NULL to
> asoc argument of sctp_sf_violation. So, it should check it
> before calling sctp_vtag_verify().
>
> Probably it could be exploited by a malicious SCTP packet
> to cause NULL pointer dereference.
I don't think asoc can be NULL in here, did you see any call trace
caused by it?

If this was found by a tool, please remove the unnecessary call from
sctp_sf_violation_chunk() instead:

@@ -4893,9 +4893,6 @@ static enum sctp_disposition sctp_sf_violation_chunk(
 {
        static const char err_str[] = "The following chunk violates protocol:";

-       if (!asoc)
-               return sctp_sf_violation(net, ep, asoc, type, arg, commands);
-

Thanks.

>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Fixes: aa0f697e4528 ("sctp: add vtag check in sctp_sf_violation")
> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index fb3da4d8f4a3..77f3cd6c516e 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -4669,7 +4669,7 @@ enum sctp_disposition sctp_sf_violation(struct net *net,
>  {
>         struct sctp_chunk *chunk = arg;
>
> -       if (!sctp_vtag_verify(chunk, asoc))
> +       if (asoc && !sctp_vtag_verify(chunk, asoc))
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>
>         /* Make sure that the chunk has a valid length. */
> --
> 2.7.4
>
