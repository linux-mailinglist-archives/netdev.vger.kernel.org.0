Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D52AC46
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfEZVPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:08 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:46782 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEZVPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:08 -0400
Received: by mail-pf1-f177.google.com with SMTP id y11so3494396pfm.13
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Scq12LQW6mJUbWkwAO5MA9SKwGBF6MNR1jUBbX1Wnog=;
        b=fbOmpGbPIuAIrXyKWHeXHjDVRNif7seJN4yz0oG2nxTkGSnDHuTM8PwDONqP6S3A3H
         q7uGgrLnWH9Hn/newEUeR+OIoMFgNpF8CPubVlsDH6QVH0lY7sakzu5dV2Eyma3cb0m0
         TM+Jm8iBFA/vlIU0nzDrXqVaK69Olj4rvM592/bHQj0xGRLNTDEJZHrIN8+qSLk7q6RO
         JpDlzxpqK829IkV8oflEpFwB5WAiowpzjwDTVLIb7sUNR6PbUb8jLroSfP6EXbiYfZ52
         lFJJvYcAFAmOJT7/vO152KpMZV5Os3wmMGgR6YXyZZoYaiT1qNYtfG8Icq7fHdGNFE44
         xrng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Scq12LQW6mJUbWkwAO5MA9SKwGBF6MNR1jUBbX1Wnog=;
        b=k4cJq6K3ZTqhnlAY5zDKnQL17/l+9j9cx8gKLqcl2YAqQ4GwRwhJsQ3Q8WaZlUbJge
         2JLc9svIYrSBcSPrcGqvD6LuGumhnra3EkPwP3666ewqbYwi27CKN+iQMzdhc95I6Jql
         rLRNpveK2seGeh7t1Bi1DoSX+7Nd2WdaeuItb2+Gh/biylDZL4+X8F5h85VKpYK2kTdu
         5QMBZO26Uu8ZvhEvW3X6zPaSkLIeTjAxHvG90PnYPyeY8v7oJSA9guHfUZ9uMyTinW+M
         gv+ONSkmysxMlImqMu+ZEMlW1cpOJ34O5a3XSnV3tD1okTkU00lSHCB14jgKFrXgE6KL
         jYrw==
X-Gm-Message-State: APjAAAWYPdxX3qSraDcrBSEs8rCYwMZdBZD20t7/SJSIf2uKdcZozQAc
        KohGXiwmBjzxMP8ApvKCObBUFAS8AwpDC3WHFDE=
X-Google-Smtp-Source: APXvYqyjbgr2nzopH1eEVZ0cCVR7GJ2M7NNPN1DCOZEGrbkNmvVRVCNPOelJqateqiYpoAr2R6A78zvcXSU7DPGqg5I=
X-Received: by 2002:a63:1d05:: with SMTP id d5mr12216705pgd.157.1558905307796;
 Sun, 26 May 2019 14:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <4ff639cacefe15fac417ac1a485dd895650176d8.camel@gmail.com>
In-Reply-To: <4ff639cacefe15fac417ac1a485dd895650176d8.camel@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 26 May 2019 14:14:56 -0700
Message-ID: <CAM_iQpWEbCw=__gXetNjaNzx8ggwXiPO4te0FC1xts=OegnVog@mail.gmail.com>
Subject: Re: Having TIPC compiled in causes strange networking failures
To:     bepvte@gmail.com
Cc:     hujunwei4@huawei.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 5:27 PM <bepvte@gmail.com> wrote:
>
> Hi! I build my own kernel, and I set TIPC as enabled long ago thinking
> it was something many applications depend on. After I upgraded to 5.1.5,
> I noticed lots of errors in my systemd log and that Firefox couldnt
> start any of its subprocesses:
>
> NET: Registered protocol family 30
> Failed to register TIPC socket type
>
> rtkit-daemon.service: Failed to set up network namespacing: File exists
>
> The "Failed to register" message was repeated many many times. Many
> other strange problems occured until I set TIPC to compile as a module
> instead. I believe this is a bug related to one of the recent TIPC
> commits.
>
> If you need any other debugging info or have somewhere else I should
> report this, let me know.

Probably this is caused by the same offending commit. So make sure you
have the revert of the offending commit:

commit 5593530e56943182ebb6d81eca8a3be6db6dbba4
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 17 12:15:05 2019 -0700

    Revert "tipc: fix modprobe tipc failed after switch order of
device registration"

    This reverts commit 532b0f7ece4cb2ffd24dc723ddf55242d1188e5e.

    More revisions coming up.

    Signed-off-by: David S. Miller <davem@davemloft.net>


A rework of the offending commit is commit 526f5b851a96 in upstream.

Thanks.
