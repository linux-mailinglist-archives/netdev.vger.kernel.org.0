Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655CD3432C3
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCUNaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCUN3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:29:30 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57117C061574;
        Sun, 21 Mar 2021 06:29:29 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l18so7958088edc.9;
        Sun, 21 Mar 2021 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GuAWlAF2bT8Mgtc5jOOUTrqg7FBDtINFPE74GD25EJ8=;
        b=NxOi+EHdZRSZsjazmYXnsSU+yMcq1fTXmCqrepBwly6kUbR9vISJ83nHKEmcngnoFH
         5wzVJvOgcbZjmPBuHoArq2nPlZBXi1HY1raMHzdR8/pi+i748yEt8GHk14zhTqk+DmyU
         kH2WDO3a3RWwWrfUGNc2PG0dIcaA/oDLoXfqEbgozDlqibYAasDtcqf33iedyAr9Msho
         cMa9RYhjBn9orfFckwqog9iyCOyYJMBHM4x+lHl8lPUewpJeCu2fZ6ZrN0FEhsYZhZN9
         YiLDrHIAv18cK1edMstw3QoXUa07YFq7ZL/88v4yF0L/Q3ps1BoXFNyD79pp8V30Doqk
         9sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GuAWlAF2bT8Mgtc5jOOUTrqg7FBDtINFPE74GD25EJ8=;
        b=LM6P2RJglpGGtALFdlHDOJEzcaGeCGjY1p1m44jtLgPO2epqLj5SGYuZN3kkgzzOSu
         vQDPKrJ+uZFenaBOKTKMRqouCMDNZFd3fuaoC50hF4k6/VWva+KglMj1PEVDcitr/zna
         RJOqcUjSUkTlqlEwZFPtznT1G39u2jpuZ6xJyw/fBYsVkAtpqUDFY/12EdHt2u6Plmqe
         4cOBIFxQDV3kpZ9JjeP6VS3ZqhCezHCP0eVWNqaszq8Kn0HOJTltqLkycgb+hStOa1y3
         KxLU/sWUj3y9wL9FjcxNr/kRFFbRp2DKjJeelzi3jOTBmIkYPDKSr4vmNJmiwpf19tsN
         +9Zg==
X-Gm-Message-State: AOAM533DS5sqHIJaE5FDnj+7Nhc0RbgtC54X39gNTRGrOGged74Ng/j/
        u6tYN9/ftuQx1Febt7hiMqbVdAlvW9cAU3SCjeU=
X-Google-Smtp-Source: ABdhPJziX5gSPZd9I8FB4IjkrxZO5ahLPT5+FnPQdPzmOT5Z36y6rmaV/vbgIzhYG2q3aN+YQzX4lqvpWEHQSTkA6oo=
X-Received: by 2002:a50:e80c:: with SMTP id e12mr20755699edn.229.1616333368018;
 Sun, 21 Mar 2021 06:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210321123929.142838-1-dong.menglong@zte.com.cn>
 <20210321123929.142838-3-dong.menglong@zte.com.cn> <20210321124906.GA14333@gondor.apana.org.au>
In-Reply-To: <20210321124906.GA14333@gondor.apana.org.au>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 21 Mar 2021 21:29:16 +0800
Message-ID: <CADxym3ZdOiGuJUE_t0mXrUnDsvRPsNOhWx+qE3okOuf7w6NVxg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: socket: change MSG_CMSG_COMPAT to BIT(21)
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 8:49 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
...
>
> Shouldn't you add some comment here to stop people from trying to
> use BIT(31) in the future?
>
> Thanks,

Yeah, I think it's necessary. Thank you for your reminder~

With Regards,
Menglong Dong
