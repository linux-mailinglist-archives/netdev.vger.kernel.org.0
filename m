Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0863038C902
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhEUOPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhEUOPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:15:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD775C061574;
        Fri, 21 May 2021 07:14:10 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lz27so30687757ejb.11;
        Fri, 21 May 2021 07:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nqRwQlClWrSCEOn0RjHe1V2/QBqk87xD6ByHv3kJbQY=;
        b=oXrPFbj/F4QzgIwh7EPXBwVXmfNwLpxjxJ8zrD47PK9mL/aHImNzJakNOsj+lGlnC5
         3uvms4VIUXbLD2/aJUKzTO+6SmVuoulZAZfLa5N1xjjxPcy2sK/uf4S+IRe3qhJILdlu
         YjTA1/odtMmIxzvxB9P/5iRtIkrEfCTJP7Yuz8XL1rTjNriUSXwPmNGuKgYhxUrFe3DN
         nIyLv/kpqyTzM0FaOgwdKS3byWirSTBnkxmy4pygSkYHlI38+MkO/2rRx/G6pamrlRxq
         lCKtZE0xXNXtE4WWdgtADhO4iPu+fJZnfuWDcaDBxMC8jKiVRdHDKjKhEk+dcNUfPZBs
         V+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nqRwQlClWrSCEOn0RjHe1V2/QBqk87xD6ByHv3kJbQY=;
        b=oAKyS2WabClHUe3hBWwHdBKsPOG+yp/g1Ko/Tfi9jv5sMhBq6tAYHsOTgx2fRQkyHb
         iSN6viIw4whQ5U3L2tz0aS77CqW+ktyq72ps7pjqG6wyVZvfscc+up+VUl5Q1AMcqzh6
         avUFJ0mfBW3p63x5kat3RbNzu0wpmFvoOMhdKxkKfh4N7S3I+HoA0OFsSFCeojbWMLOo
         1Y2qLoqUHrkUWh9X3D0PtbkJ4df3mWnS0RA8b2OEqUgfsh3vd39TksT6Ezc0QQ/XqbEn
         Kb031jub8m3Fc+VBpl7yG+qSTz8KPg7t1swD99WHbJcyPzdKXVNrjhlHA9aRdyZD9IVV
         Y/WQ==
X-Gm-Message-State: AOAM531Gn+DzwpkO2dxKedVMAKhw9rx6zDjytyokGlkf+j0XsuWNTVzb
        76sV4wyQGKjx/Gg/HtwT4SY=
X-Google-Smtp-Source: ABdhPJxlz9dC5l2beVI0RR8Y4plsZ6zJ1KUqmT/4uqPHe135qkehopOjM9gv55t4tHtyvNX8lBqRuQ==
X-Received: by 2002:a17:906:c9cf:: with SMTP id hk15mr10403984ejb.445.1621606449227;
        Fri, 21 May 2021 07:14:09 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gu16sm3610416ejb.88.2021.05.21.07.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 07:14:08 -0700 (PDT)
Date:   Fri, 21 May 2021 17:14:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, a.fatoum@pengutronix.de,
        vladimir.oltean@nxp.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        atenart@kernel.org, alexander.duyck@gmail.com, hdanton@sina.com,
        jgross@suse.com, JKosina@suse.com, mkubecek@suse.cz,
        bjorn@kernel.org, alobakin@pm.me
Subject: Re: [Linuxarm] [PATCH RFC v4 0/3] Some optimization for lockless
 qdisc
Message-ID: <20210521141406.mmxv4ikfp4zfkcwo@skbuf>
References: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
 <829cc4c1-46cc-c96c-47ba-438ae3534b94@huawei.com>
 <20210520134652.2sw6gzfdzsqeedzz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520134652.2sw6gzfdzsqeedzz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 04:46:52PM +0300, Vladimir Oltean wrote:
> Hi Yunsheng,
> 
> On Thu, May 20, 2021 at 05:45:14PM +0800, Yunsheng Lin wrote:
> > On 2021/5/20 17:27, Yunsheng Lin wrote:
> > > Patch 1: remove unnecessary seqcount operation.
> > > Patch 2: implement TCQ_F_CAN_BYPASS.
> > > Patch 3: remove qdisc->empty.
> > > 
> > > RFC v4: Use STATE_MISSED and STATE_DRAINING to indicate non-empty
> > >         qdisc, and add patch 1 and 3.
> > 
> > @Vladimir, Ahmad
> > It would be good to run your testcase to see if there are any
> > out of order for this version, because this version has used
> > STATE_MISSED and STATE_DRAINING to indicate non-empty qdisc,
> > thanks.
> > 
> > It is based on newest net branch with qdisc stuck patchset.
> > 
> > Some performance data as below:
> > 
> > pktgen + dummy netdev:
> >  threads  without+this_patch   with+this_patch      delta
> >     1       2.60Mpps            3.18Mpps             +22%
> >     2       3.84Mpps            5.72Mpps             +48%
> >     4       5.52Mpps            5.52Mpps             +0.0%
> >     8       2.77Mpps            2.81Mpps             +1.4%
> >    16       2.24Mpps            2.29Mpps             +2.2%
> > 
> > IP forward testing: 1.05Mpps increases to 1.15Mpps
> 
> I will start the regression test with the flexcan driver on LS1028A and
> let you know tomorrow or so if there is any TX reordering issue.

14 million CAN frames later, I did not observe any TX reordering at all.
