Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522C4362BEC
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhDPXcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhDPXcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:32:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40C6C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 16:31:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so17212008pjb.4
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=l48M/QMDspJnBcNTzRjP/JwL4bGGo5kI26PkRqH0ytY=;
        b=vW+++J1IE+KtMrtN0XwzJT/e4H7s3RDQlxT+Ce9smLSv6qGjBnFb6/VB1gDweTBmj3
         ISiCwVYKAEyqIJ764MhniYOeichkw5vepx8Rrd1BBKuKbfPgLkTN9Wfs78D+o4/kU3C5
         Cm4SjcuN7dei3VyncmU/jdG2WgFsvtRLl4U4vmDomC2qYMQVJco874RiVM/u9wc8DD2P
         mVASV/b64wF9Ydpmbdts1gqPulilhAWSnX5fAKisiIWCmcUKWADm9cWLH+IXLro6tfoH
         X4akNDJB+EKiHkoOp/TPzqAmmFD69a6Oxy43RIM6aeyrpk4zedqIxy29KtWaUdyh7ouY
         1CEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=l48M/QMDspJnBcNTzRjP/JwL4bGGo5kI26PkRqH0ytY=;
        b=ajDMFueXf2SzilguWDIF4TDBIjI0Un+e7aaQ6f8ZH/dne5jbaPWfEhK0gk+PcTC+8E
         ILVxVjHQ0AQI4NkqybRpdlp+Owp++x1VhGnIQrA1YCiJjte8Nlr5NY4Z0ZnsnRlW+EG7
         U1aVRQqui+5vczDRcvPtqYWsIgiY7xe7A2oaAuDdB/fsn31nEJpVVas14md7MkkjNHX6
         jcdCBIBng0G54exKmlQdwce8EH4l7o5+uqE0EMTnngXpnHYSGT0bp2WuoCx0Ti0YrKlA
         EOLCEZjXH91BNHfi+jNKMRssAuPFSDvjkYAuMRZY/VdkX6AbYt1y2jkcC0BU3LUrrqu8
         qDug==
X-Gm-Message-State: AOAM5322qR0DJ6sX5KTK5MdjB0zz9TyyOvkd4O/UCFJEsv+WadJ/KF0r
        AY6AGYgTbpkKgXAtXwGUt4I=
X-Google-Smtp-Source: ABdhPJwLllf7nQxJY2ejoxyuynWywhPB66eRUIrb9NgtSO4nCWYvw9OWHAA2Nqz+D3ySP1umbg98EA==
X-Received: by 2002:a17:902:9345:b029:e7:4853:ff5f with SMTP id g5-20020a1709029345b02900e74853ff5fmr11892076plp.74.1618615909536;
        Fri, 16 Apr 2021 16:31:49 -0700 (PDT)
Received: from nuc ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id m3sm1309790pfh.155.2021.04.16.16.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:31:49 -0700 (PDT)
Date:   Sat, 17 Apr 2021 07:31:45 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] net: sched: tapr: prevent cycle_time == 0 in
 parse_taprio_schedule
Message-ID: <YHoeYVPhsgLZ6gA1@nuc>
References: <20210415231742.12952-1-ducheng2@gmail.com>
 <CAM_iQpWs3Z55=y0-=PJT6xZMv+Hw9JGPLFXmbr+35+70DAYsOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpWs3Z55=y0-=PJT6xZMv+Hw9JGPLFXmbr+35+70DAYsOQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, Apr 16, 2021 at 10:14:52AM -0700, Cong Wang a écrit :
> On Thu, Apr 15, 2021 at 4:17 PM Du Cheng <ducheng2@gmail.com> wrote:
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 8287894541e3..abd6b176383c 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -901,6 +901,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
> >
> >                 list_for_each_entry(entry, &new->entries, list)
> >                         cycle = ktime_add_ns(cycle, entry->interval);
> > +
> > +               if (!cycle)
> > +                       return -EINVAL;
> 
> Just a nit: please add an extack to explain why we return EINVAL here.
> 
> Thanks.

Hi Cong,

Thanks!

I added extack and submitted v4. Please help me review.

Regards,
Du Cheng
