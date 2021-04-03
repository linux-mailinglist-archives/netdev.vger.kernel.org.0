Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD663531D6
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 03:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhDCBQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 21:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhDCBQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 21:16:06 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE3CC0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 18:16:04 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso6296620oti.11
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 18:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5k5sb3CSMxJH27w8zOtLdfdpPEt+zJypD6kRJDViD58=;
        b=sVKUoVpI0biN8qAnWSrPgtKUL8d/wolp/yn8XNI8CCpwTtjIEp4egolCiUl9nCOv2g
         vgeZqk3hKKxgFrXmzXoH38muKhngv+dE5OIlsOr1ZH3MhpcMh8W/4uZVyK+p9qnIs2ug
         OJYbIczk5Z/BuIjlaW7bI7NOJbpxVWpO1rE9yRD28u/0diSpMPZZ42VQLuiY6EMS4qgg
         Ad5B713l96mcD/owi/VXHIg+OIp6WFRXtQXj82LmKx23RK8oAGKgo9hbwOWjSXcUhC02
         JZj37wtm/6Kb5pB/rZDa5Ub6Y4jrYZS1rQKYsTZygtKxFp8qaaXoLdsMJ7Xk5jymf1A0
         L1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5k5sb3CSMxJH27w8zOtLdfdpPEt+zJypD6kRJDViD58=;
        b=CaLWA1seClVsykorDhbssDfLWhcJFR35Qlt/rpxbQdmHRlwFWFSG6hCXh30VRTNoVh
         1lxsoqCW/PsZSEw3tCea6PUz6/8PkdG5F914zKtA2Uh27cVaMHsgfz4rYWWUra53VjnK
         bU9d0zPvcYiMbtJg93EWY7R7AYbAhcSCH4ZcJem4StzlZqnxTIGHPlbTag/NyoNawrzS
         STURB4nT89Lol2OmtWbeQxJnTqZdTApTc7Au60EXQrc9tq164wvN5M6vy+hzdhOQ/nVK
         2ycIWwFwlKBxBHJEMEzu18iwKzZyl01lJ5WTm9+UdXEZ5PY98U5OeMKZLgOjGmpZOx98
         QRnA==
X-Gm-Message-State: AOAM531CGSO5hPK1/0xRPOsCTjhNN92uaAFbQNMBqK2W7tlzHrx2iegB
        qhfJ3TO6XNlz1is9FqPp6g4gmHlZ9qA=
X-Google-Smtp-Source: ABdhPJyVb6hTzU3+I+CaRcy5roo+2D2xQ9DM4s4CDowx1UekqW999dFebnURmuGQsJnAtceU1EjGOQ==
X-Received: by 2002:a05:6830:225b:: with SMTP id t27mr13008201otd.73.1617412563603;
        Fri, 02 Apr 2021 18:16:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id g22sm2098214oop.7.2021.04.02.18.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 18:16:02 -0700 (PDT)
Subject: Re: [iproute2-next] tipc: use the libmnl functions in lib/mnl_utils.c
To:     Hoang Le <hoang.h.le@dektech.com.au>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
References: <20210401023409.6332-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6d124a86-6474-77da-c3e1-cfc6dcf43903@gmail.com>
Date:   Fri, 2 Apr 2021 19:16:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210401023409.6332-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 8:34 PM, Hoang Le wrote:
> To avoid code duplication, tipc should be converted to use the helper
> functions for working with libmnl in lib/mnl_utils.c
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  tipc/bearer.c    |  38 ++++++--------
>  tipc/cmdl.c      |   2 -
>  tipc/link.c      |  37 +++++--------
>  tipc/media.c     |  15 +++---
>  tipc/msg.c       | 132 +++--------------------------------------------
>  tipc/msg.h       |   2 +-
>  tipc/nametable.c |   5 +-
>  tipc/node.c      |  33 +++++-------
>  tipc/peer.c      |   8 ++-
>  tipc/socket.c    |  10 ++--
>  tipc/tipc.c      |  21 +++++++-
>  11 files changed, 83 insertions(+), 220 deletions(-)
> 

applied to iproute2-next.

