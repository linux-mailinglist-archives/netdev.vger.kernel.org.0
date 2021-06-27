Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE2E3B54A3
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhF0SZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 14:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhF0SZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 14:25:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7C6C061574;
        Sun, 27 Jun 2021 11:22:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so8852941pjo.3;
        Sun, 27 Jun 2021 11:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2oqWrvLVeisdHXpfSUKFvof9edib3eSGfHzCJaMbWuU=;
        b=rdvc9BJ5WxN3O0YKNDyMbv58qQ/0YCcCwhoagQlhN02JwkrIvAirnSefnxAXeI84vK
         H8GklaTIxXrmSBC9TlIOUcx+84zwuMIWj6zuhBgAL18tIQwMeHKOdqDSICsaU6gy8qvq
         rH4/cAV1Qt/1PLkkJKmyJNDvZ3Fe7HymEUEg5Rq4xW7xiux06zRFSKdkvvUid7i8mPwc
         hRW42VCMd7EGrqkGCRfX49/qjoW/I9F4n4MLpPbfwiqaoGiCibvfRIIJ13uyJCdbG2AF
         T3t9Ri1l/1f5igeSUsHXGpwtoDSOVNwKnApv9IM5bmOvfAIQWOKVU9T0AdD0M8unvlsg
         oF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2oqWrvLVeisdHXpfSUKFvof9edib3eSGfHzCJaMbWuU=;
        b=LT4nfePDDBq/AX3w3WGSUkmGg9MZ+GqoSBW84X9i2lAqF/MyD4ZIGx1fBB3zLH4u8b
         h1NFCSzCtHt3f0qR03jel2FkVcPQRTvOwiklDiA9vNNDsZEaK0co3Ih7a4ruNJpVrY7E
         iE8kiBcME2ixukEyqZLH5DjEIHNYNWplhBFjRDqKlqjgxsS6xENz+tMNDL85ZRcUkymR
         lB64ahcYv6FfuBbzB+UYyo9lUnbJOrUaslY32a9pHkfSs/jeYNlz9TkGD6bQjCtiS7Rb
         5A9ZwkUfyRHpHEt5qKr2OlnPoOdoezMg2gumJJhi3sMQD9xI8WsmNvdOWMwYLinqdpwB
         V4ig==
X-Gm-Message-State: AOAM530jXghpO3iUN6WWFsMkc91HjiWGG2pj9HusJd7CVFLlhFJM0uK6
        U3Um4NayFX1zdseccZeTFNd/c+hPyPanBaq+L1c=
X-Google-Smtp-Source: ABdhPJxg4Qq4E8NCSgtTuW4XVArlJ5FRKxraek2iS4oFybo/dSSkCsIwxlOr6AS/RqVjlSsvo/qcYgxW1Qli9asYGME=
X-Received: by 2002:a17:90b:1e0d:: with SMTP id pg13mr13707009pjb.56.1624818162637;
 Sun, 27 Jun 2021 11:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210625202348.24560-1-paskripkin@gmail.com>
In-Reply-To: <20210625202348.24560-1-paskripkin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 27 Jun 2021 11:22:32 -0700
Message-ID: <CAM_iQpWtncQbhfkrBNCU3iMKYfYCvhKzxTwoo0WWtDKpKbMe3w@mail.gmail.com>
Subject: Re: [PATCH] net: sched: fix warning in tcindex_alloc_perfect_hash
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 1:23 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Syzbot reported warning in tcindex_alloc_perfect_hash. The problem
> was in too big cp->hash, which triggers warning in kmalloc. Since
> cp->hash comes from userspace, there is no need to warn if value
> is not correct
>
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Reported-and-tested-by: syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Looks reasonable.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
