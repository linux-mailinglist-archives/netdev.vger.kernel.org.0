Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE62B5062
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKPS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgKPS6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:58:10 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C90EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 10:58:10 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id g15so16220610ilc.9
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 10:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3GOoCIP7NeWS4lTjIDYnexVr32s7S2QtavAfu1ednm4=;
        b=kXFaAopMx6rO1GX06Yvy/Er2QJbp71OSOYt/dEFzTqIIb7YoHoHdRvjBWWpw/2dfcX
         IM0ySL7vABDnghk3lP+5/06OetVmkYMj6ygMp1LBQR8+2jwMlcrxrL27DyhJ/copcpmY
         Uw7LbrfEZ0PTdezzR5M6rj2T6aF901+YB/rIzSBHdqVzn7WaLIjhTtpGJosjtfRAaRMB
         tVDzYpN3L5x/hJtuuWLqVd4VWTB0gczNT1DipA5H8QhV1bcjE2/D7KCJsVorwxFqIY46
         qPUoSvXPI3ZsUHSS2McXajVdnu/IafqgsXyI45FVLde953Vq//NDsocc7dfOwNqbW/3F
         V9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3GOoCIP7NeWS4lTjIDYnexVr32s7S2QtavAfu1ednm4=;
        b=UoQt9PY/9fmQRIMXVMR+o/eFQ/L3/gs6VbOEsw30V3i7DjfCvG2V196ZKBxb8CHydL
         Ua3SJjXL95DwzXjdI45IcxoQDRRITGfz9alGoXJ6WzYOPKDTc719iuys6KRHe2rWrViw
         Gt8ghgOMEu0tpA1QufMsPvjVt/8/BerUoy58nivartmXi11AT52VyZXtJwHAFpwVTEXc
         7SQRjEODgtEv+avDuhmq7jCg8BWf1sJoCtGqMjhDIFm7PauSyOCIg/DkUSGOK7743XVc
         4EPGplD5y3wCpVoBiwL894gYkFBMhgXIMcTGP3wZNk2kDmAEfs68ATnwoeezDZ7vWaiU
         kBhg==
X-Gm-Message-State: AOAM532ge3AFQBqvd9gC4qsNiU48qlGgjOTphmu2vtW4lsEiwudWPd70
        /6j76OE2zXi7fi2km+klleTKr97Od2+UdfiQsAI=
X-Google-Smtp-Source: ABdhPJxyZZ7npyP1/lsEnAq39X4QC0VtppFTqHTegEvVlryOmuu9Gxl03w2flO0O0N4+RZHxo7cutplij/5KZxBdnkA=
X-Received: by 2002:a92:2811:: with SMTP id l17mr10100648ilf.238.1605553089827;
 Mon, 16 Nov 2020 10:58:09 -0800 (PST)
MIME-Version: 1.0
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn> <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <20201114224617.GK3913@localhost.localdomain>
In-Reply-To: <20201114224617.GK3913@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Nov 2020 10:57:58 -0800
Message-ID: <CAM_iQpVQM3rdGk91oaSMUSf48CgPcMFB+bYETQsuOnkx8pEfUw@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 2:46 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Davide had shared similar concerns with regards of the new module too.
> The main idea behind the new module was to keep it as
> isolated/contained as possible, and only so. So thumbs up from my
> side.
>
> To be clear, you're only talking about the module itself, right? It
> would still need to have the Kconfig to enable this feature, or not?

Both. The code itself doesn't look like a module, and it doesn't
look like an optional feature for act_ct either, does it? If not, there is
no need to have a user visible Kconfig, we just select it, or no Kconfig
at all.

Thanks.
