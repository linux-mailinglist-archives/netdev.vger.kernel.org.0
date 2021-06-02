Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93F398FF0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFBQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFBQaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 12:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1806197C;
        Wed,  2 Jun 2021 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622651310;
        bh=ym3BhES639iZHefP/a/KoEYjxWioWEK1emlID8aS13o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bOsoN+tVW0saMH88vcIVp0E/Dvsx2otzQyMvCxf7gIlWFtRbavufvF1MfuSlpa/kG
         B9pcBgUr1Xkl1akir38jE5sq5RFJ1PxTRCc8CK7J509YCWF9bGHtXXVrRFdNQYqKXQ
         RauoG54tu3oD5Cd31Tk141tJIT8/4+08/P0UugxiqEqlZzPGAWUtPSfK9ngMBQUB6q
         GhHvJCGIH7EZsq5EAvrZaV/HqDJt/wzRKFkGDT35sNbvuP7mb8Abd7vFWqty7CEQT9
         FH7Od/yFs9b7o1PbshhFnkzgIePNnkeT8L7DnzbZrAmyQvn3FgpgynR6l4eYHBK00O
         57hfSfTFUzGeA==
Date:   Wed, 2 Jun 2021 09:28:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Yunsheng Lin <yunshenglin0825@gmail.com>, <davem@davemloft.net>,
        <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [Linuxarm] Re: [PATCH net-next 2/3] net: sched: implement
 TCQ_F_CAN_BYPASS for lockless qdisc
Message-ID: <20210602092828.21d30135@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20e9bf35-444c-8c35-97ec-de434fc80d73@huawei.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
        <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
        <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
        <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
        <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
        <20210530132111.3a974275@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3c2fbc70-841f-d90b-ca13-1f058169be50@huawei.com>
        <3a307707-9fb5-d73a-01f9-93aaf5c7a437@huawei.com>
        <428f92d8-f4a2-13cf-8dcc-b38d48a42965@huawei.com>
        <20210531215146.5ca802a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf75e1f4-7972-8efa-7554-fc528c5da380@huawei.com>
        <20210601134856.12573333@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20e9bf35-444c-8c35-97ec-de434fc80d73@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 09:21:01 +0800 Yunsheng Lin wrote:
> >> For the MISSING clearing in pfifo_fast_dequeue(), it seems it
> >> looks like the data race described in RFC v3 too?
> >>
> >>       CPU1                 CPU2               CPU3
> >> qdisc_run_begin(q)          .                  .
> >>         .              MISSED is set           .
> >>   MISSED is cleared         .                  .
> >>     q->dequeue()            .                  .
> >>         .              enqueue skb1     check MISSED # true
> >> qdisc_run_end(q)            .                  .
> >>         .                   .         qdisc_run_begin(q) # true
> >>         .            MISSED is set      send skb2 directly  
> > 
> > Not sure what you mean.  
> 
>        CPU1                 CPU2               CPU3
>  qdisc_run_begin(q)          .                  .
>          .              MISSED is set           .
>    MISSED is cleared         .                  .
>    another dequeuing         .                  .
>          .                   .                  .
>          .              enqueue skb1  nolock_qdisc_is_empty() # true
>  qdisc_run_end(q)            .                  .
>          .                   .         qdisc_run_begin(q) # true
>          .                   .          send skb2 directly
>          .               MISSED is set          .
> 
> As qdisc is indeed empty at the point when MISSED is clear and
> another dequeue is retried by CPU1, MISSED setting is not under
> q->seqlock, so it seems retesting MISSED under q->seqlock does not
> seem to make any difference? and it seems like the case that does
> not need handling as we agreed previously?

Right, this case doesn't need the re-check under the lock, but pointed
out that the re-queuing case requires the re-check.
