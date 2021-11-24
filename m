Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD3045B0D2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 01:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhKXAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 19:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhKXAsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 19:48:07 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA45CC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 16:44:58 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v7so2379285ybq.0
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 16:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2YtgHia9Sw9DfTyO8v7g3XHaQG8doTao15GUlWEZ80=;
        b=XFNQmD2ohKJWO0F3Q0CKWFkvBa1zF+3S+y2FFFVBVhUPRgU8+UFsn592EFZXjleGyY
         t6r0d1nmo7GuWzPQZeyOul/CydaZ9MLaSXAF6WPx5ydPwPEmBR98+YGRz06SiVLiCXbz
         DDW/f150AZxmzIWZ7e/jUXylP3u39N0JLigkGVwktHUlhzXjdqtHHLqAIr+ThvWvPxYl
         LgrLb3hjRnnN7rnUY691dnzPew4hc/YQaw+Vvy4C3zlPDkcRYSK4WN/ixTKGSC9LWGFt
         nJ8YHf44lhDYd7CoAnYpVErwW72T7HEp6I60Ee20QCDL6IYdiq8+j7/r5zTFncd7voOy
         FfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2YtgHia9Sw9DfTyO8v7g3XHaQG8doTao15GUlWEZ80=;
        b=N1n/bAofooVykKwmzu2W76p+n3Cpoxk/NrRSSb8pvuQlm21pZZFAaSTu009ezRV/zx
         W0Y5ZBru11amz6/j7e4KTdoFtD4pF+8boRJJEUjbf3P8QyRgoScmccTP9QXWoTsEr8bw
         fTd2Mt2tRft7zWxNKDxccE0m2KDgXYKzz4vTEcZdyXPJWjoqi7He9Rvwn6VRaZXrHsSb
         1YRrs0F5bqDcZKyALnEa/MBDAtmpZRO/1RmUaWs55DJJlrV7Hp18Q2pd5atjocY8rJ4G
         aKpb6RCIYkBuj+nLpowNlcHLtQvrgusDJbnnUe9OHvfb7aPiVUJrbVWh0kGwqSaUebI2
         J6zA==
X-Gm-Message-State: AOAM5307mk4em2VWJq6KoPvIkwZ5EL0Qi4D6m5MTu7crP+5PlYUAEROn
        q3tPt8ZnBIYeek7/fr2Ypu4PxQlzKPbA69P+ERc=
X-Google-Smtp-Source: ABdhPJyjOhjpuMkn+F4aGL3Nz+eOvtwyKZv6yEr3Yc6v4p/jMZ4Dm0AQJ8vg8EFKQ+Tgrb8c2taArCG0o2uBSHFR37Q=
X-Received: by 2002:a25:2d67:: with SMTP id s39mr11993149ybe.140.1637714697422;
 Tue, 23 Nov 2021 16:44:57 -0800 (PST)
MIME-Version: 1.0
References: <ed47959b3abc0d03cb98d65581ac2541fa27b16e.1637674769.git.dcaratti@redhat.com>
In-Reply-To: <ed47959b3abc0d03cb98d65581ac2541fa27b16e.1637674769.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Nov 2021 16:44:46 -0800
Message-ID: <CAM_iQpWFx_LXCE7YSY4NZdjkyhuhCmngXRqrn1Rze82o5Ffb9g@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: sch_ets: don't peek at classes beyond 'nbands'
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 5:54 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> when the number of DRR classes decreases, the round-robin active list can
> contain elements that have already been freed in ets_qdisc_change(). As a
> consequence, it's possible to see a NULL dereference crash, caused by the
> attempt to call cl->qdisc->ops->peek(cl->qdisc) when cl->qdisc is NULL:

Where exactly is it set to NULL? In line 688?

686         for (i = q->nbands; i < oldbands; i++) {
687                 qdisc_put(q->classes[i].qdisc);
688                 q->classes[i].qdisc = NULL;
689                 q->classes[i].quantum = 0;
690                 q->classes[i].deficit = 0;
691                 gnet_stats_basic_sync_init(&q->classes[i].bstats);
692                 memset(&q->classes[i].qstats, 0,
sizeof(q->classes[i].qstats));
693         }

If so, your patch is not sufficient as the NULL assignment can happen
after the check you add here?

Thanks.
