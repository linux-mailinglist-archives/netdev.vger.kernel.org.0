Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FDA41959D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhI0OBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234645AbhI0OBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D7766113D;
        Mon, 27 Sep 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632751185;
        bh=1hp8qFDQ8yPjRo6lqUmnO1LLloukCmviTPPP63/he9k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V4J8G6Zyb2WmImS9SMfWVn5CwMbimsGXU4BItbY19fjJ5NgUvb18pN3whaKoCr6vx
         DwOfWAunSvo/tTkMsJSlfccIJ8rdtp7YEYxkhVXetcHObFa93qo65w6vsaZA3uKh7R
         Iy2zMLkSt0mClHJWcOjhuvrg5aUMO+zKqz17+JPY8kR2MzOgfCFkY7zhPGHOCyueEe
         rDbGkGa8xv6Y/Ds2MEPYXT22AWSdwmo3gYhkdUHWu6jugu1zdsMwZTgmLUFEMqX8Os
         enRTnUULyaqjw1OH2N49fxJDZ1RvnzpVmCoUdqeaSAZJP7EP1AR6xMJcCILilbaQVh
         zEFsnX5KW9mSg==
Received: by mail-wm1-f49.google.com with SMTP id r83-20020a1c4456000000b0030cfc00ca5fso663634wma.2;
        Mon, 27 Sep 2021 06:59:44 -0700 (PDT)
X-Gm-Message-State: AOAM5314jIOA8UHRPF7zGvczfpEO53oPMF7/PsbACE9n6utZZLx6UChT
        DEAjYD1OkSYOzNQC8a1lymi+C41V+0LIjtz+MHA=
X-Google-Smtp-Source: ABdhPJxMeKVH4sQon/ecdBbNijA9Xm0b+90wcNq7ScahjsPgLSJwg7t7Z63er/fbRqri7KZ1vZu9yVldXsQ4wyh1uhQ=
X-Received: by 2002:a05:600c:22d4:: with SMTP id 20mr3768656wmg.82.1632751183501;
 Mon, 27 Sep 2021 06:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210927100336.1334028-1-arnd@kernel.org> <YVHGblt9rYg7kbWR@shell.armlinux.org.uk>
In-Reply-To: <YVHGblt9rYg7kbWR@shell.armlinux.org.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 27 Sep 2021 15:59:27 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2-F-vAL5-gewVh3JvnD1a9yXWYLKN9fi6CEe86Hnhn+A@mail.gmail.com>
Message-ID: <CAK8P3a2-F-vAL5-gewVh3JvnD1a9yXWYLKN9fi6CEe86Hnhn+A@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] net: stmmac: fix gcc-10 -Wrestrict warning
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 3:27 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
> On Mon, Sep 27, 2021 at 12:02:44PM +0200, Arnd Bergmann wrote:
>
> This looks rather weird. rx_irq[] is defined as:
>
>         int rx_irq[MTL_MAX_RX_QUEUES];
>
> If "i" were to become MTL_MAX_RX_QUEUES, then the above code overlows
> the array.
>
> So while this may stop gcc-10 complaining, I'd argue that making the
> new test ">=" rather than ">" would have also made it look correct.

Indeed, thanks for pointing this out. I have sent a follow-up with
that change now.

             Arnd
