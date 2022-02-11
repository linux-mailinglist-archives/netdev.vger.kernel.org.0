Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D864B1EF0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347392AbiBKHCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:02:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiBKHCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:02:19 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D85C2634
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:02:19 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v47so22208840ybi.4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x0mFidHwyLVbXU77f+YHMUrmRyUflVaHt4msBymNHwY=;
        b=JTOVkgZCTi6pC/X8jKPB0j3P+jRLvr8uvd20IFT4j2rrOKcEJyyZ0LYw01jZEcx0Dz
         osClj5jOFbC9iHL4/3imverEeWirjSbcIVoJPMMuq6iVenteaH2QpTjaik0SQBw09IZm
         DJmzM+47KznyNVkZOwNwML9LtNmAwpZZfo8s4upVmdeoG6HCWyomrQZxhmButlyLZs+L
         WnigTPNB1ANvjhybHFMQauIu9nuP9tncwZOhlOqOraKomo82W5I9zngpG2BlPhJX6a4r
         FLrr4eiVTWs5vY38mqF4AgohpyC9+aec6GTb0erTheLEPlLhCDAF/FF73f5ZJguA1hgO
         sdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x0mFidHwyLVbXU77f+YHMUrmRyUflVaHt4msBymNHwY=;
        b=jmoL1pa3t3qcTOQFPY6Q92+UIGN+VpmMWu1q1Z5Y9f2YfrBRB5hCoHR8eYATJyI7TH
         x4WIi/XISW4gDeEUGPqTaiXx5PbQG6W82AJ4PMKhHn9f/DJ51kk5bCxUu710hj80B+PC
         1TC8OMlgYqZCgcdOh3s/WzA3kQBRhz803JbV2E4jsQWjJN1RMDBkpqUlViG6iuDrbV7q
         UOZ3P1Z+6bab5fahQEcOBabEB5VHY+M9wbVvd0EA8js1mtGNynDhgnTKb6uH5YxcRff6
         JFbIT7oUHRPRlnWsqWLcb3tP+oE+UIRA2uE0cyAWFQXo3v3uYUFRgrPCipjh2DlK6URm
         /JNg==
X-Gm-Message-State: AOAM531Foso9D9tHNaParbeSZvgtpHoJBtrbTV8aV3LvPCmoJEUNiFUd
        NtyfZM+QMBlK1BAZzhBN/9qlj23t1Xoq7YtP4ag=
X-Google-Smtp-Source: ABdhPJwNeFYyzcm57U4GVXDGdFH3J0okg94cP9VwvwD7c4GAUUakoC8kzts4mtpmRYTHzOA0gMXGo/aBSAGTLIS0XjY=
X-Received: by 2002:a81:7603:: with SMTP id r3mr375601ywc.176.1644562938527;
 Thu, 10 Feb 2022 23:02:18 -0800 (PST)
MIME-Version: 1.0
References: <20220210162346.6676-1-claudiajkang@gmail.com> <b147e095-4c02-61a0-4cca-18c570eb7d9e@gmail.com>
 <141d43cc-6b66-2fcf-4703-70db51859960@gmail.com>
In-Reply-To: <141d43cc-6b66-2fcf-4703-70db51859960@gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Fri, 11 Feb 2022 16:01:42 +0900
Message-ID: <CAK+SQuS7zGpAz4cUBfXUKOdgaPDK2y97-vUx=0mxOFp0iN9pJg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: hsr: fix suspicious usage in hsr_node_get_first()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 3:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/10/22 09:47, Eric Dumazet wrote:
> >
> > On 2/10/22 08:23, Juhee Kang wrote:
> >> Currently, to dereference hlist_node which is result of
> >> hlist_first_rcu(),
> >> rcu_dereference() is used. But, suspicious RCU warnings occur because
> >> the caller doesn't acquire RCU. So it was solved by adding
> >> rcu_read_lock().
> >>
> >> The kernel test robot reports:
> >>      [   53.750001][ T3597] =============================
> >>      [   53.754849][ T3597] WARNING: suspicious RCU usage
> >>      [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b
> >> #0 Not tainted
> >>      [   53.766947][ T3597] -----------------------------
> >>      [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious
> >> rcu_dereference_check() usage!
> >>      [   53.780129][ T3597] other info that might help us debug this:
> >>      [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
> >>      [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:
> >
> >
> > Please include whole stack.
> >
> >
> >>
> >> Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head
> >> for mac addresses")
> >> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> >> Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
> >> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> >> ---
> >> v2:
> >>   - rebase current net-next tree
> >>
> >>   net/hsr/hsr_framereg.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> >> index b3c6ffa1894d..92abdf855327 100644
> >> --- a/net/hsr/hsr_framereg.c
> >> +++ b/net/hsr/hsr_framereg.c
> >> @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct
> >> hlist_head *head)
> >>   {
> >>       struct hlist_node *first;
> >>   +    rcu_read_lock();
> >>       first = rcu_dereference(hlist_first_rcu(head));
> >> +    rcu_read_unlock();
> >> +
> >>       if (first)
> >>           return hlist_entry(first, struct hsr_node, mac_list);
> >
> >
> > This is not fixing anything, just silence the warning.
>
>
>
> I suggest replacing rcu_dereference() by rcu_dereference_rtnl()
>
>
>

Hi Eric,
Thank you for your review!

I will send a v3 patch that applies to your opinion after some tests.

Thank you so much for catching it!

-- 

Best regards,
Juhee Kang
