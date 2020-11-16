Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E752B5079
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKPTBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgKPTBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 14:01:41 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9FDC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 11:01:39 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y18so8990805ilp.13
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 11:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BOpXeuasyQ7d9LUFS/ml3Mw0lG26dofP8O3nBKoqKqU=;
        b=dokgeDeg8ga+yl9YB7oFJMFINgPlPDaAFjo+qhGvJnIdf0jGLWBUqG33TP/Cv/UibU
         91PEU0j07QqjndpE5+En0RW566fBgWD72KySMNDoR5nuKzIOViHW1YoxRYuFbvLKKaUy
         BA63UCRcw3ETfq2HtLenuwdGNNlFv3oLpYqI/PtNYfuGMyGkCEw+H1FcGvcVuRkrxc5G
         v0rstT6jGCtHLxkiI1OPs6fl0NgBda/i2hTTDMEoTuTklUcRbbRbZhNmfNVe4yyfKO85
         J5Ipq1Y7C6rFHJtMi6wwh7LRmAcLWSZ67l3B5VWm3VBQbZGY3YMcRrFbSzASUUR5kPA4
         cR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BOpXeuasyQ7d9LUFS/ml3Mw0lG26dofP8O3nBKoqKqU=;
        b=JqxWzeQczTYYf/etsHZU58syOK6Xh2U56Vi8B5v3LvZ48awaM4Rvovio4aooWz+thn
         TCYZwtSdAyM0o6tBvRkqf5FZqSozEaeA6/V0CTLoGoF/CYK6J1+SId6LA6cz2ZKoDxi0
         uNvzaR8iRizXqRh1zHnhCfMs7X6SxX/bPA4phMVanb2QJ/piGnEzisAzqcR/m29zNgW3
         D+NifOXTI04oey2HW4YJYQ3nJhI9hHB1eoLxD2ymOXyP9GmuXevxJd1b2l7zh7pbzLUC
         cY5BLvJNHs75YUOOZbLiTg4Wjv89wsSCy5972GUm55RwYl+LIqSvjpu7PApuZTC7tXee
         350w==
X-Gm-Message-State: AOAM530esdAgoP2PExkuMEWv9f4GiZYgmbqR6Hk7eDRYvqC7qAyPRuIj
        8dMD2mGtLr1vpMS3lVFFKFxCYatTWvZGtk7oWgU=
X-Google-Smtp-Source: ABdhPJytsywfx/8gGcZrxJLe8cq3VyOsxf717uJUUKVrY99J8Y1OD0mizLyXptJn+2L4dzq1aLmXy9hlpMwZWm6gpKY=
X-Received: by 2002:a92:2a01:: with SMTP id r1mr9804787ile.22.1605553298692;
 Mon, 16 Nov 2020 11:01:38 -0800 (PST)
MIME-Version: 1.0
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn> <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
In-Reply-To: <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Nov 2020 11:01:28 -0800
Message-ID: <CAM_iQpXDzKEEVic5SOiWsc30ipppYMHL4q0-J6mP6u0Brr1KGw@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 5:06 AM wenxu <wenxu@ucloud.cn> wrote:
>
>
> =E5=9C=A8 2020/11/15 2:05, Cong Wang =E5=86=99=E9=81=93:
> > On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
> >> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
> >> new file mode 100644
> >> index 0000000..3a7ab92
> >> --- /dev/null
> >> +++ b/net/sched/act_frag.c
> > It is kinda confusing to see this is a module. It provides some
> > wrappers and hooks the dev_xmit_queue(), it belongs more to
> > the core tc code than any modularized code. How about putting
> > this into net/sched/sch_generic.c?
> >
> > Thanks.
>
> All the operations in the act_frag  are single L3 action.
>
> So we put in a single module. to keep it as isolated/contained as possibl=
e

Yeah, but you hook dev_queue_xmit() which is L2.

>
> Maybe put this in a single file is better than a module? Buildin in the t=
c core code or not.
>
> Enable this feature in Kconifg with NET_ACT_FRAG?

Sort of... If this is not an optional feature, that is a must-have
feature for act_ct,
we should just get rid of this Kconfig.

Also, you need to depend on CONFIG_INET somewhere to use the IP
fragment, no?

Thanks.
