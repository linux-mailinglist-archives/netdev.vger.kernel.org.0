Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF0A611ADB
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 21:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJ1TZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 15:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJ1TY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 15:24:59 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CF8AD9A7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:24:57 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id u7so4681034qvn.13
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 12:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvkPsmKadsl23ayZLbCxYHhSY58toKAFltLWM5QGagM=;
        b=IRGGX52cZteevnA7JuNSD6huuAYt2HaQdR2F7+6ZD1zIXJuD7L1QWVa7YdZygrZqnb
         4qXZTKr9oKSC37mICAgMDXH4uJcvuyfIAs+W7lGC4dbai1SsS3fylefBK++LGrETDxNk
         hMQfXC7QtfPROhKQ7byaobq40VNW6qnqfxd4rv3DwuGPmaLgj8jbh6QznICI603ofVyc
         8Dvvsj7a5T2fvmk+fj2/p/8jpd5bwbNfQa3JElzk+yWhZQ6exA4H4aEZua8e0qzSXQVg
         9n5gDUhYaS5hxKDRobxVU29hw5GqakHdhZ/sv6wkVt6H5Z9KQjsBkJMayO32lG4iS+S+
         A8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvkPsmKadsl23ayZLbCxYHhSY58toKAFltLWM5QGagM=;
        b=y8EnUuQe8IeF/TpsmBLCYZUAUona6Sow9fwVJeB5y+uKJ6nOYoFUdQiwimGCeVC7dD
         D/ivueHIoQUy4mkZVoycqBWehkaYMY13wNh7sa7pElryBrpWFhSVPBzdLGiqa7QM/FWz
         fh0lssbuGnlHcuyUgj958nKSQLIGE51vErx/0LYvi4ULGcWTWxL+RRoZk6dCa39Y4Qqq
         7kMG9ArJtbqjDTvCIvuqqJFYQlaqi5c/YYMZw8ORUM3iHii73j3Rb6tmJxS6OLrJegE1
         aqfdns2k7Ic8qk+aibTuAWgMEqEihlTAx2YnBhGRtu8bY2Osb4YOtFFTHwZjDU60ccJP
         DKwA==
X-Gm-Message-State: ACrzQf2tlA78IBQRHf4/kqfVukaR/Hbvvp8ApskOAwfv8hBAklQ/u1Zw
        N7ytZwk+UvEbMiBEJ2IWyfQ=
X-Google-Smtp-Source: AMsMyM7iR1yJAcI5iQOfFfrEID4JqXBs+Pu5784EjX7acoxQ8QFwjlJXRjVlX95NI+v0pRMx1AwO+w==
X-Received: by 2002:a05:6214:400e:b0:4b4:3f86:b38 with SMTP id kd14-20020a056214400e00b004b43f860b38mr914856qvb.17.1666985097119;
        Fri, 28 Oct 2022 12:24:57 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:309e:e758:a2c9:d68c])
        by smtp.gmail.com with ESMTPSA id de13-20020a05620a370d00b006f9ddaaf01esm3546694qkb.102.2022.10.28.12.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:24:56 -0700 (PDT)
Date:   Fri, 28 Oct 2022 12:24:55 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Message-ID: <Y1wsh66c7693OV/D@pop-os.localdomain>
References: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
 <20221025160222.5902e899@kernel.org>
 <CANn89iJr+RdwnyoBmFmtc0m7KDSOg-5GboBpCOc4Diut9W8W6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJr+RdwnyoBmFmtc0m7KDSOg-5GboBpCOc4Diut9W8W6A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 04:49:48PM -0700, Eric Dumazet wrote:
> On Tue, Oct 25, 2022 at 4:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 22 Oct 2022 19:30:44 -0700 Cong Wang wrote:
> > > +                     spin_lock_bh(&mux->rx_lock);
> > >                       KCM_STATS_INCR(kcm->stats.rx_msgs);
> > >                       skb_unlink(skb, &sk->sk_receive_queue);
> > > +                     spin_unlock_bh(&mux->rx_lock);
> >
> > Why not switch to __skb_unlink() at the same time?
> > Abundance of caution?
> >
> > Adding Eric who was fixing KCM bugs recently.
> 
> I think kcm_queue_rcv_skb() might have a similar problem if/when
> called from requeue_rx_msgs()
> 
> (The mux->rx_lock spinlock is not acquired, and skb_queue_tail() is used)

rx_lock is acquired at least by 2 callers of it, requeue_rx_msgs() and
kcm_rcv_ready(). kcm_rcv_strparser() seems missing it, I can fix this in
a separate patch as no one actually reported a bug.

Thanks.
