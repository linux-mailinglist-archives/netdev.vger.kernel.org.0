Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC4393614
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhE0TPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbhE0TPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:15:18 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1363FC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 12:13:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id z130so827820wmg.2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 12:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xqHm5PmEmn4kS0tpoFuAk5vI4YyFyKoPNWUsH93hldk=;
        b=qllcABXWJg19wGSYr2quIafpUMxAiy6jiQwzbNgtNXLcbupQ9oFITUp0gQs4BRKPkR
         WiWVBNMvju7PL1imF5CWs4pQi3h3KgRtNG1lU/jx48pyh21yPvZ+fdzEnnNvDdQYDmQI
         KEKpE4+2LAzY3L7EnPZU0vJ5LZa5l06LgdH+9H5LCEBlgvVECgiBk9bNnjIMdUwRBu8h
         YYNDKD7GpQw5xwVUhge8NGdmTSEALlsaTTyT2F4WA+9od1RZQ2rqDK/MpJ5LUGIszznD
         ckeX8n9hKMiY3YSc5VkFsj8HtjvK01CPKmCF5GMIQNCi7OigYRDZf/P8WDsngv2RDb5t
         TO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqHm5PmEmn4kS0tpoFuAk5vI4YyFyKoPNWUsH93hldk=;
        b=Y/jaO0DaUpLkBSbmW8Z1aTjt4IeRt7KIkGDq3K3Uqs3odByDF1TpB20Qqx7wsw0Cj1
         2++t9s3cAjRkhcaP4xYPIsFZSH+rhaimM6YAd1GygnQJ4Tjgb3wnCSAjigEInNGcJnpe
         k7Fhe5/TH3F96C9Kqs6Sfxe4sZTwwB47WDUiLjMK34zZu006O7jbCMtWn83KXqeCO9w+
         PsoW1ni762XCqEowO0UUAkx05hhxxtNgSwI53UCme3HgMaF4KEOXJexF5hzXdR1cnvfR
         NYzhx9/BV1BvXWKDr4gzxSzRNPvam7O8Q+KC7SSlFTB/xLkLhFWggoeal8r+5C45mmEc
         zSTQ==
X-Gm-Message-State: AOAM530BXWjlLB3e0xEzXgUrgc/y9DViGdzn/FmSdsHmgl+x0qW87+YO
        /o+BLWQXPgSrPl7pMszPo4Kbj37Tl1WiIwn1mlbdBWcUTfEorTRf
X-Google-Smtp-Source: ABdhPJzmC4Tz4f1ytKYV35LFP+WfSlsTjp3ZyiXPPwD6EJmm5QKFRnlLIujDGGiPLHpgp0tKIQOK3iX2PFkCvaguNLg=
X-Received: by 2002:a1c:8097:: with SMTP id b145mr3559634wmd.12.1622142823432;
 Thu, 27 May 2021 12:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
In-Reply-To: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 27 May 2021 15:13:32 -0400
Message-ID: <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 3:12 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Currently, when calling UDP's getsockopt, it only makes sure 'len'
> is not less than 0, then copys 'len' bytes back to usespace while
> all data is 'int' type there.
>
> If userspace sets 'len' with a value N (N < sizeof(int)), it will
> only copy N bytes of the data to userspace with no error returned,
> which doesn't seem right. Like in Chen Yi's case where N is 0, it
> called getsockopt and got an incorrect value but with no error
> returned.
>
> The patch is to fix the len check and make sure it's not less than
> sizeof(int). Otherwise, '-EINVAL' is returned, as it does in other
> protocols like SCTP/TIPC.
>
> Reported-by: Chen Yi <yiche@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/udp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 15f5504adf5b..90de2ac70ea9 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2762,11 +2762,11 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
>         if (get_user(len, optlen))
>                 return -EFAULT;
>
> -       len = min_t(unsigned int, len, sizeof(int));
> -
> -       if (len < 0)
> +       if (len < sizeof(int))
>                 return -EINVAL;
>
> +       len = sizeof(int);
> +
>         switch (optname) {
>         case UDP_CORK:
>                 val = up->corkflag;
> --
> 2.27.0
>

Note I'm not sure if this fix may break any APP, but the current
behavior definitely is not correct and doesn't match the man doc
of getsockopt, so please review.
