Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7077F1E8DE0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgE3Etz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Ety (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 00:49:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13BEC08C5C9;
        Fri, 29 May 2020 21:49:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d7so1591069ioq.5;
        Fri, 29 May 2020 21:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HFOR/RijELuUtw6za5Yk5rxfLgJ7l4/sChLeCcGwqMU=;
        b=GjOgESc6gghXhC3dT/OUuxPzmJfhu4TmN2rq8Nm1FIDZGXqTwEtcqo4Yupf7DmjbPi
         tLcv56dhLFClty7Q0pI5zYzxZSNvegz2ApkxqDyxykttPsDtXCjK/7+oR4SGEwF8YeQb
         VrNHl5Qzdro9wMLVMkFJU3vH4+q8HrjbAd1wWB1JCzGrvXy3IFvTkFIKNlOU9rnutNK0
         oTVdT76kXKCz9wlxmxrHS9q9BuYmNEW+CDds+ShtSz8N87pOZHoOCzowkeKh1NVl8XXb
         yInJ2dTjUWgZBAQiTWDM1nQGJO/6MNRRvaHggvqhl0Dh5qD8z4jehlKmTEPaPnXYz0Q3
         kUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HFOR/RijELuUtw6za5Yk5rxfLgJ7l4/sChLeCcGwqMU=;
        b=pL1/fM9JZPi2k1nQ3vBcZi7qy9AcLoIkP+t+iTja4YH3tUvqiNzU+/gDnXKL1A20oq
         BKIzE2DJMCCn9d1r+TvebkDBNDHMZ5ky5Ful9j3QOc5eUyl99hKdjQ7tCpXWuL1td28W
         5G+JF4K00FESlGk4cfje+9WbOVeIHnn2aFzrcyAWpzPgtAnrYS9Hdd98+592qX2UZn7y
         LITglBtdDae9J1FEfJAAPgZqhk7HVxnZvcvYFLpl+tqv1DOIX4vz7HrRKNXhWrH7JbjH
         p59OCxk/StYoAdggyl+UvOeSDFYCP2AkGV0Ze2KCCQ86ombapDNNqV0lwI7ADQTtvWcV
         wI9g==
X-Gm-Message-State: AOAM533qh+FJY9EyRvB6ieNqM2DRLI0FM+hpuxPk9LliXdT0j+/SuKsY
        +GNCeKwcej3EW4xjpokwK21bDd+iISESAx0lwNU=
X-Google-Smtp-Source: ABdhPJx10VafEVlXNqwH5P6nufV34sjcQcu1/3cT223kzsOOXogss5J3YtxZ+BGxegWaZOiIgKi+qYRTYBNAcbFK/Uw=
X-Received: by 2002:a02:3b4b:: with SMTP id i11mr10731659jaf.16.1590814193121;
 Fri, 29 May 2020 21:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200529201413.397679-1-arnd@arndb.de>
In-Reply-To: <20200529201413.397679-1-arnd@arndb.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 May 2020 21:49:42 -0700
Message-ID: <CAM_iQpWp7_CytqF9U4b7i7TYNytVPztpm-P+=9dBBdiy_nScLA@mail.gmail.com>
Subject: Re: [PATCH] flow_dissector: work around stack frame size warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 1:14 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The fl_flow_key structure is around 500 bytes, so having two of them
> on the stack in one function now exceeds the warning limit after an
> otherwise correct change:
>
> net/sched/cls_flower.c:298:12: error: stack frame size of 1056 bytes in function 'fl_classify' [-Werror,-Wframe-larger-than=]
>
> I suspect the fl_classify function could be reworked to only have one
> of them on the stack and modify it in place, but I could not work out
> how to do that.
>
> As a somewhat hacky workaround, move one of them into an out-of-line
> function to reduce its scope. This does not necessarily reduce the stack
> usage of the outer function, but at least the second copy is removed
> from the stack during most of it and does not add up to whatever is
> called from there.
>
> I now see 552 bytes of stack usage for fl_classify(), plus 528 bytes
> for fl_mask_lookup().
>
> Fixes: 58cff782cc55 ("flow_dissector: Parse multiple MPLS Label Stack Entries")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I think this is probably the quickest way to amend this warning,
so:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
