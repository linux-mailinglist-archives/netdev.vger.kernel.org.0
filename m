Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8E02D85C1
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438662AbgLLKK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406561AbgLLJyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:00 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3C2C06138C;
        Sat, 12 Dec 2020 01:02:54 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id p5so11115681iln.8;
        Sat, 12 Dec 2020 01:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MF8Qpp6oAIyzdJjFXDLgg5mQAJADM65GySy+Sj/Tbz4=;
        b=OiChpZ7eSxcW/vDX5u8qE3LbgdjkUKXWROaXZ6p/d3gCBkGoEzIrY2DF637Vbj7I1E
         tve41JqQ8V6F0T71K4ysi1LG87MTjiHUlHcRYQvLqfFjh4PrwbQzKxiyyq44EQfXgkVN
         mx0AgnKgIAcCH04vpEe05KqVFw9HXjW+GzU0jdrP8Xih5Vho3uD+aFQ6vIzq1yxPnxHo
         LOia1sDztj5u5xh8fuw1egc8UGDG5/Q/HWA7gtw5Nn9JczDFvZ4mFSVVHlPaohz76qQI
         jHeVPRTMPqEYXCeO2s9NyV7RBij1eXobpV2gj4BO66PPssZjEZUHqByL3vBx7aM5jcI2
         V21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MF8Qpp6oAIyzdJjFXDLgg5mQAJADM65GySy+Sj/Tbz4=;
        b=Nw0/4cs2Wx6dlGH9SFDZqSLt6BG+T7IJOsbiHYGNy2ailouoBnMoiA/APOAH6zm9T1
         tJ/T2MIw0IZlr54cmsenC+NXE85kVkOC3aWP/69tAdtVg0sxKiN7JHdCK8ILuKUUlPlm
         RbzHwdIFo0wQ1yXH7Rm+E8QZmPt2Jgb6d931TBtlSJctsOXDZlGrvWTQKXoAKw8mT47L
         /MVmBwCV0D4GKnOJ9iTHMyNILj/CGE3hYs61B2CtFJ8nizrKAKQWC4LPL9/IZ/rB0DTh
         X7y+XStTvCvAp8zrszyZ4S3tADZtftQH2DMrt5Qd+PcWn/A1K7xmKe9LgZlFyDsirAhy
         aH8Q==
X-Gm-Message-State: AOAM532nwPLoO/A9trjeXO93A/6fxvK8N+VrchRDNrM1OP2zmf8eDWZw
        vZxXhBTiElfCme2aVOXonUeRyUveCGbo8S4V2MhqvAfElFA=
X-Google-Smtp-Source: ABdhPJwyY4XbP0XKbLoF2RsE+g4IgwSOrX668gIlEAAoxD1UJo9nk0PT14lsy9vsFpn1/RKwpuQzlvuJ/y9OlSNG3J0=
X-Received: by 2002:a6b:93d5:: with SMTP id v204mr20199242iod.155.1607762383583;
 Sat, 12 Dec 2020 00:39:43 -0800 (PST)
MIME-Version: 1.0
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
 <20201211163749.31956-2-yonatanlinik@gmail.com> <CAK8P3a0_AwRxTsYuK4p-vv61H34ERDp7od3C2c45u+0QyR+uhQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0_AwRxTsYuK4p-vv61H34ERDp7od3C2c45u+0QyR+uhQ@mail.gmail.com>
From:   Yonatan Linik <yonatanlinik@gmail.com>
Date:   Sat, 12 Dec 2020 10:39:32 +0200
Message-ID: <CA+s=kw28NJK670ZsMmE3zW-9gP6uzcQKV+dY7OcS6xSgVOye_Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Willem de Bruijn <willemb@google.com>,
        john.ogness@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Mao Wenan <maowenan@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        orcohen@paloaltonetworks.com, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:00 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> Another option would be to just ignore the return code here
> and continue without a procfs file, regardless of whether procfs
> is enabled or not.
>
>        Arnd

Yes I thought about that, but I didn't want to make changes to the way
it behaved when procfs was enabled.
If you decide that's a better solution I will happily change it.

-- 
Yonatan Linik
