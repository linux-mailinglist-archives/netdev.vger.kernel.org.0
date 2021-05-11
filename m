Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB1A379C2A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 03:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhEKBl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 21:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhEKBl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 21:41:29 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6327EC061760
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 18:40:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s7so16240889edq.12
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 18:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UewUIUnZEU+WLxgt73DD3mXzDpZZk6Udya01I4ZEHrw=;
        b=kswNC8BfZzTXjrd6CNTModmWLgnAvrz8jFPHApeblmQg6rKJTfpByfO00OR0Pz90U7
         j1h5wLO98+mXFSkHIGaBBPFlGFIlVgszWA4z5S//jxNs7j6V5k7SvxLs2BACJNEA6cY6
         DdJk9F38VUmJZBUbe9y0G/3gP+BARMhWvICBTY4L0I+bRubNxCVz0PQMxcRQKAw3iRiO
         9MY1YMyzrEx57GDbBf8hCIEs3/VeMBEt//BpG/7jKlbyR/3VUWpUVsq//ToDHX33Pe2D
         UrYTX7tsSokm+E8dtjV5qW0tm9osyXnMLHx2HdZLyQm8oWzBGAc9Z9pL9D7wg9NU6CQ0
         vTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UewUIUnZEU+WLxgt73DD3mXzDpZZk6Udya01I4ZEHrw=;
        b=m5GAp5xKEUEyg2avOvso+XcsI9NhX3wABwN7mcVhVp4jXOhaeH6SymYQETExXu7q6p
         L6F8CbE/wlxlgA958DWcUmVvXJY306TWcRfzVzX6Fn5WRxU+JrqioP4jKn1+38SgglcF
         rrB1a4rS3CbfHCjytEX0oateJve+xhGCn0mgHuKdoSm4CmUtc5wyXZiumn+jUth2QBA7
         QlRr2AsIi/hBhjW6L+arT6bNdfW6ISnm1UP/esSEWS1wDesozctpA+IbWYBqdKS0LMK8
         xp+hqpNlUCb04gd6W3iS0iVfkBPG2xRg958lNwC7WcbjyLoHnjE+4xlqdoanzNMpWJVi
         pw/A==
X-Gm-Message-State: AOAM532Si5bd2HgfYdNb/tOY+7LnVbnfh53FLu3f6x3ckwbrs/65WU4G
        VmsO6fyrH/5THC1RHNeBOWyk6Scu3TaDLK0ZtHiu
X-Google-Smtp-Source: ABdhPJyiTl7fBwjdXCS+1nwJylc1lzHYHwN8ZdaJRSyBufr+LfV/BQ7QX/iNclrk81EQS7LWDc/1AEQHqAIC14Mt+cY=
X-Received: by 2002:a05:6402:177c:: with SMTP id da28mr32267501edb.135.1620697221981;
 Mon, 10 May 2021 18:40:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210409054841.320-1-hbut_tan@163.com>
In-Reply-To: <20210409054841.320-1-hbut_tan@163.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 10 May 2021 21:40:11 -0400
Message-ID: <CAHC9VhT8+DR0jvY8SO=HArhjcTfxsZxaoqy-1ufcOQEcD6qOXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selinux:Delete selinux_xfrm_policy_lookup() useless argument
To:     Zhongjun Tan <hbut_tan@163.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        kpsingh@google.com, dhowells@redhat.com,
        christian.brauner@ubuntu.com, zohar@linux.ibm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@yulong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 1:52 AM Zhongjun Tan <hbut_tan@163.com> wrote:
>
> From: Zhongjun Tan <tanzhongjun@yulong.com>
>
> seliunx_xfrm_policy_lookup() is hooks of security_xfrm_policy_lookup().
> The dir argument is uselss in security_xfrm_policy_lookup(). So
> remove the dir argument from selinux_xfrm_policy_lookup() and
> security_xfrm_policy_lookup().
>
> Signed-off-by: Zhongjun Tan <tanzhongjun@yulong.com>
> ---
>  include/linux/lsm_hook_defs.h   | 3 +--
>  include/linux/security.h        | 4 ++--
>  net/xfrm/xfrm_policy.c          | 6 ++----
>  security/security.c             | 4 ++--
>  security/selinux/include/xfrm.h | 2 +-
>  security/selinux/xfrm.c         | 2 +-
>  6 files changed, 9 insertions(+), 12 deletions(-)

Merged into selinux/next, thanks.

-- 
paul moore
www.paul-moore.com
