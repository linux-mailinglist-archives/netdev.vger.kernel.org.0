Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313F3B1181
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfILOwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 10:52:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37580 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732777AbfILOwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 10:52:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id u184so21855464qkd.4;
        Thu, 12 Sep 2019 07:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4TYD+cMewnYL5z3ieEOxCFAZpD0FvyxKAgBZKpsQKLA=;
        b=GyqcPE4/EQBaVHpCqx2y3ZULViVFVL8tffo3OyPRfyuexXAahJ07HdkYnsrFM4+Cb4
         mvyCnZyx37tY7lxrXcZ+G6iXswOE12khIZ6PgJNpmrNcFd0mqeZhatW3hbubKYuDuNED
         9AqqRDHLKy/PvNSE7RvUFkEIwurppFR70hMCcanG1PbPfs2M5LNRgSH1MTTT3765f7Zt
         kQALaE1WvCoZkRSESWnB5HYlEIBDHqJ7OZ2b67QTo1HsxzckrBnS+GmwO4p1xkumgexT
         2DnZYC6XURzprpCttbU2uKTQ+joNI0HKRU0JimpA7mRFi9DksFfFtNgQb4fRNTXGRUsz
         XRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4TYD+cMewnYL5z3ieEOxCFAZpD0FvyxKAgBZKpsQKLA=;
        b=f+ZtiHI5X8lgUYYQzXfj9kWJKYEMu6cEv/o6WTBudwWotEQOmvMk1J3heltKUr6HnS
         JmhlBTUjxxhXnY43PMPGN11Pb8dFaAbGwRj64cAAWdVSMeN5kCWfLcAz+dKyHcaOOczC
         /2++bq/CqZGcfpD7tzDzWXH+EKuyPYB418yJtMgBsw/U2Nyzb3f0mow7wFqdbMB2JA4F
         mO4pMkZX60KTFiXgbQyrud2mtYXcUl3YKmEvR6jMjWD4FuP5EmKO2iCgXIYGGO6Af1xi
         YSp48O4xm7wudfISzwIByilT8koHdSb+ayMdwjUIfph9ICfRICjqLMbSfHZxMK3T+vIw
         yYQQ==
X-Gm-Message-State: APjAAAXZmiHHwf4wr+HXQAerSQT6c7MbO9lwd/6nzSH0vyuAfKD4UjwF
        bSCCS7cHHAzt/bIa0/EGLqM=
X-Google-Smtp-Source: APXvYqxQjjKFbfTR+SpYcWqcPiDQhipECrd3HCTLf8/FABccUvYHLTIU8NhZGCKAE4FLtRF7Vcvv1Q==
X-Received: by 2002:a37:6681:: with SMTP id a123mr39180452qkc.499.1568299941468;
        Thu, 12 Sep 2019 07:52:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e600:cd79:21fe:b069:7c04])
        by smtp.gmail.com with ESMTPSA id m19sm12221716qke.22.2019.09.12.07.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 07:52:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5B906C0DAD; Thu, 12 Sep 2019 11:52:18 -0300 (-03)
Date:   Thu, 12 Sep 2019 11:52:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH v2 net 3/3] sctp: destroy bucket if failed to bind addr
Message-ID: <20190912145218.GT3431@localhost.localdomain>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-4-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912040219.67517-4-maowenan@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 12:02:19PM +0800, Mao Wenan wrote:
> There is one memory leak bug report:
> BUG: memory leak
> unreferenced object 0xffff8881dc4c5ec0 (size 40):
>   comm "syz-executor.0", pid 5673, jiffies 4298198457 (age 27.578s)
>   hex dump (first 32 bytes):
>     02 00 00 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>     f8 63 3d c1 81 88 ff ff 00 00 00 00 00 00 00 00  .c=.............
>   backtrace:
>     [<0000000072006339>] sctp_get_port_local+0x2a1/0xa00 [sctp]
>     [<00000000c7b379ec>] sctp_do_bind+0x176/0x2c0 [sctp]
>     [<000000005be274a2>] sctp_bind+0x5a/0x80 [sctp]
>     [<00000000b66b4044>] inet6_bind+0x59/0xd0 [ipv6]
>     [<00000000c68c7f42>] __sys_bind+0x120/0x1f0 net/socket.c:1647
>     [<000000004513635b>] __do_sys_bind net/socket.c:1658 [inline]
>     [<000000004513635b>] __se_sys_bind net/socket.c:1656 [inline]
>     [<000000004513635b>] __x64_sys_bind+0x3e/0x50 net/socket.c:1656
>     [<0000000061f2501e>] do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
>     [<0000000003d1e05e>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This is because in sctp_do_bind, if sctp_get_port_local is to
> create hash bucket successfully, and sctp_add_bind_addr failed
> to bind address, e.g return -ENOMEM, so memory leak found, it
> needs to destroy allocated bucket.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
