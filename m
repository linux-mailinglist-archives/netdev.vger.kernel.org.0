Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCF7309455
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhA3KUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhA3A3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 19:29:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8634FC061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 16:29:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id p15so6627771pjv.3
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 16:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FS2Z6H7D1rPEqMxKSVP9YO4OgZlBJqRElVFF5wjxHPQ=;
        b=DVpbCvQP00FOLt7jeDPUZ0w7ussE/f+AKzBG5zXG1t2JG2qCM3xGhpUxnBluusSoum
         41v0VpcNU1FkzuEd35dqcA84xQ0k8iXDbx7ET1FltL3w0aGycAOzaBcXPgbg0lpWV4VO
         rsk+XiSblo3HxezS7zzOi5WqYjrS9DF7saKJTfl/kZhua96BcKu7IvL/7fvZGUgSWHJz
         w0SQHZPqQ3b0aJmInIB/BzTcuc9EiSBDOuKVWxHRGo6GfJRTEUDsP52tjDRqoxBBpbnA
         SkGNfMXrxf3oUbDzcsFmy7aTtqBpoMEeaBRnWPQPcd+E2Feoemg1R2ZxHypYOadLybYp
         uo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FS2Z6H7D1rPEqMxKSVP9YO4OgZlBJqRElVFF5wjxHPQ=;
        b=otOedNABnvrTFW7tZaVHi9akFa8ZoT/2DUrkGF9dpo7EzrOJUcpOByRNzs/JQXdtgW
         e4NnREeHLwKGd9DkJCegCpSCSMfZO43P6oVifIw3aApEFxoiXJ5LC+wFltOKg6UNU0PW
         o/LRVRQTMYrNjZ2gpxILcZyUpakkEQO3yKCDKqs0eSpQ2tF3TgdCdHAepd5A1VnPWERi
         GbVkafIEL7XkgUGVQuOEGZSudUJz9VahFjW1Fmfh5kxJs+HMg+quHdhFhUtugAbdBvWK
         V7BR/e51R1oGxt4NbZMBZUpoDR5qV/AzAxt4YVMp2Dgs3c48W4/yKYcy96HEqTDU8z6S
         Uk1A==
X-Gm-Message-State: AOAM5329sdDW48YtP/yv+fs3Yp/YbI6xb9UIeKjBf4u3XE5jjPlbTI8A
        tEWeXe0w4BJnu4jZH4Wp22BAp7NYgxHbSK4G65c=
X-Google-Smtp-Source: ABdhPJyGXzij+gCRDBK8DeivIFPmFk8jZtgVN+BlO1Zr/iaU/g+xXZf7zQywfwf10g05V1azAA9h3ilk01EruACJttc=
X-Received: by 2002:a17:90a:f98c:: with SMTP id cq12mr6629638pjb.191.1611966543590;
 Fri, 29 Jan 2021 16:29:03 -0800 (PST)
MIME-Version: 1.0
References: <1611959267-20536-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1611959267-20536-1-git-send-email-vfedorenko@novek.ru>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Jan 2021 16:28:52 -0800
Message-ID: <CAM_iQpVu7duRR=KXp8F209qdKj7W6u02icATdRcMtL5Rh8Sv-A@mail.gmail.com>
Subject: Re: [RESEND net v3] net: ip_tunnel: fix mtu calculation
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Slava Bacherikov <mail@slava.cc>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 2:30 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> dev->hard_header_len for tunnel interface is set only when header_ops
> are set too and already contains full overhead of any tunnel encapsulation.
> That's why there is not need to use this overhead twice in mtu calc.
>
> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> Reported-by: Slava Bacherikov <mail@slava.cc>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

I have no objection, just please double check this does not break
other IP tunnels as you touch the core ip tunnel code, especially
those using ip_tunnel_header_ops.

Thanks.
