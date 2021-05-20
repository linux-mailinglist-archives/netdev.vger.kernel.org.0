Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89C38B051
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbhETNsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhETNsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:48:18 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85BC06175F;
        Thu, 20 May 2021 06:46:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i7so7566038ejc.5;
        Thu, 20 May 2021 06:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aFmQJac4iuxwmbF46KvAyNCQors8o3Kv89Ax85e/fSk=;
        b=gfp3n9YGxa7K7QrH/kG5G7lPmDgckjSFtBzbP7QN0LXBdbrlGj776BLliSEBgqM95/
         m/IVG5AhFHf/oP+kzg/Upa9G/dl1UnuvaWRyhzyOMKk7VfECGaMSpKbe1nC1Emw7exAO
         Drridg9cymRj9v09HdxOQON2wpAvoKYewwipxAyzmA11kIMIHIOh64BUJwxq34PRbgov
         jPqXLEfv4KLHy7CnBDA42vhhV7VTi+NayC1OW2U2zYTH194RMbGWaIAIg+/xY+W898w3
         e7kd5O1rs3FG2qI6zalGvnOBAAP62K6MkPVpuuSI13hJj2UtoPQH1lEEkHFiJX/ZcoiM
         i3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aFmQJac4iuxwmbF46KvAyNCQors8o3Kv89Ax85e/fSk=;
        b=F3raFBVbuKxz+LJOIyPuOzBukXlfmbJL5U87IlOPexanUqKCFQt9ysUj51st7A7QAj
         wsgo7IexMXv2b+NlA3/V5qivEjfDp63rqWT2oi3QzGLANP9kdcQAVOvskQU5S5gwyn0G
         0t9fR5m3JqERZIl7DmgZH9Z2E7vqQFvQMEFf7lZtQ5SC/0Yxy1I4JMqn3HuM8RO7ANy9
         mCFaofALclSJU8Opx1XONxKeNuIpMzKQ0lOLKdXyiMUGfzhiRcqWaVPx2cuKgCHN6aju
         J05mqTRukyzmCYxf158J60ofTYiNFyP13J/GbJFnOcBxtFgpdyGSW6wQvha7pAOsn240
         0BVA==
X-Gm-Message-State: AOAM5317cH2esWaJnInoyC7olp3crVTUwGjGhWionXlE6xzVID+gZVgy
        s2oVRitAtAQ9FmfxxLqIwDY=
X-Google-Smtp-Source: ABdhPJyEghuZf4q6DPfhgET8q0IkDmgbGMyM7NDdSatnuXlqzH162qSD+d218cYgpqK4TrAH2uovmA==
X-Received: by 2002:a17:906:5210:: with SMTP id g16mr4915987ejm.116.1621518415727;
        Thu, 20 May 2021 06:46:55 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id bw26sm1419379ejb.119.2021.05.20.06.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 06:46:55 -0700 (PDT)
Date:   Thu, 20 May 2021 16:46:52 +0300
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
Message-ID: <20210520134652.2sw6gzfdzsqeedzz@skbuf>
References: <1621502873-62720-1-git-send-email-linyunsheng@huawei.com>
 <829cc4c1-46cc-c96c-47ba-438ae3534b94@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829cc4c1-46cc-c96c-47ba-438ae3534b94@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

On Thu, May 20, 2021 at 05:45:14PM +0800, Yunsheng Lin wrote:
> On 2021/5/20 17:27, Yunsheng Lin wrote:
> > Patch 1: remove unnecessary seqcount operation.
> > Patch 2: implement TCQ_F_CAN_BYPASS.
> > Patch 3: remove qdisc->empty.
> > 
> > RFC v4: Use STATE_MISSED and STATE_DRAINING to indicate non-empty
> >         qdisc, and add patch 1 and 3.
> 
> @Vladimir, Ahmad
> It would be good to run your testcase to see if there are any
> out of order for this version, because this version has used
> STATE_MISSED and STATE_DRAINING to indicate non-empty qdisc,
> thanks.
> 
> It is based on newest net branch with qdisc stuck patchset.
> 
> Some performance data as below:
> 
> pktgen + dummy netdev:
>  threads  without+this_patch   with+this_patch      delta
>     1       2.60Mpps            3.18Mpps             +22%
>     2       3.84Mpps            5.72Mpps             +48%
>     4       5.52Mpps            5.52Mpps             +0.0%
>     8       2.77Mpps            2.81Mpps             +1.4%
>    16       2.24Mpps            2.29Mpps             +2.2%
> 
> IP forward testing: 1.05Mpps increases to 1.15Mpps

I will start the regression test with the flexcan driver on LS1028A and
let you know tomorrow or so if there is any TX reordering issue.
