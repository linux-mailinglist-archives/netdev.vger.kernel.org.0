Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA022FFF1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 05:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgG1DNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 23:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgG1DNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 23:13:05 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE6EC061794;
        Mon, 27 Jul 2020 20:13:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so19244056iof.12;
        Mon, 27 Jul 2020 20:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hz8xM5EG8YqCl30H84RX4Zce87vdHqx8q6aTfAYbNMs=;
        b=GYq4C1ayueu3YaNY7Q29/QMADd+OnfFRbkYgQdzY2xYHw24Q5vxPc7cTlnABNycv7A
         3ghH4tyQe288lCG/sdL/4wqq9iRX/btMuXB4kvpjJziC4yNlWMI76o/Fu7odOOXBb0BJ
         2IvO8Dp69DXU2lyoZ/wUp2kq4nDgQV86cjWVg5K3YBu3SyXFc9CUYgD69v5XSE2zWpAy
         C4qOe91qKjTI3MDp+yZxEAWJQLCS5ZHw7I/9P4VK7sdhEHcwpi35UwS/sd1uB1gtjwcM
         j6soCuJtM2T3yamDa4n7+1dYMgoo/DJdlGpWKNecJVG/0pEm06zWWG/YdllKhp4zabPC
         hJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hz8xM5EG8YqCl30H84RX4Zce87vdHqx8q6aTfAYbNMs=;
        b=sa3FA/37/QTibXS91eH2tQgmwOV48ckP/U88nusQ+Vn2FAUQgA9nQYJajuqvesk6hn
         qRHke/vpSs0V1+QcEoKVcsVF824DFBpsrnYVDiNeUNgRcPTH83KOJJiOsHv8dYjIoJ0N
         V/WcJB7UsFxh1kKkMG9PVRkbxAzo3zSjAQ8Va70C5jHTgszpLAkrX18haJIlrKll3w/P
         9f7ZmBXtPDkTjvndsHoyNj0IQngzb0abRGxlTn45CFYjQn/OTrnsINhZ8GVwehlSDKb2
         FAAjaZ6ql5ImiaucsSlD3FgVyx8shLBsReXXmuRth8oUGvLmtyjzdXxGKl5kU0/itEfb
         1VzQ==
X-Gm-Message-State: AOAM5305LYeUlLT+k5BEeWCZhm2J+ZnCwk7XkRztuu3RhjfDpzwSSNH8
        9BGEldUckysORtzaAZIWkP4f8Mj8acfMUmSta+yuqgXr
X-Google-Smtp-Source: ABdhPJxgByQf1Qeq05PZtZfnw/SNvK3nfbcBGTp9JuGmp7+rwgTypLX3I9z+0qlPrytghjzXash3tCfTaQZ9S0YOybI=
X-Received: by 2002:a02:1d04:: with SMTP id 4mr30893707jaj.16.1595905985110;
 Mon, 27 Jul 2020 20:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200727033810.28883-1-gaurav1086@gmail.com> <20200728021348.4116-1-gaurav1086@gmail.com>
In-Reply-To: <20200728021348.4116-1-gaurav1086@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Jul 2020 20:12:53 -0700
Message-ID: <CAM_iQpWbT18cRfDc2f1wVUrS6QpOmPrZwBqaitD7545-itijfg@mail.gmail.com>
Subject: Re: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 7:14 PM Gaurav Singh <gaurav1086@gmail.com> wrote:
>
> Add return to fix build issue. Haven't reproduced this issue at
> my end.
>
> My hypothesis is this: In function: ip6_xmit(), we have
> const struct ipv6_pinfo *np = inet6_sk(sk); which returns NULL.
>
> Further down the function, there's a check:
> if (np) hlimit = hp->htop_limit

This check exists before git history, at that time 'sk' could be NULL,
hence 'np', so it does not mean it is still necessary now.

I looked at all callers of ip6_xmit(), I don't see how it is called with
a non-full socket, neither 'sk' could be NULL after
commit b30bd282cbf5c46247a279a2e8d2aae027d9f1bf
("[IPV6]: ip6_xmit: remove unnecessary NULL ptr check").

Thanks.
