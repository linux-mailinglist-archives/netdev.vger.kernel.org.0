Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC53476156
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344105AbhLOTJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:09:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238618AbhLOTJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639595389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/QiYL8Zdx7tWy1t7wncXYCdbSScry/EwDPkj5f12pLM=;
        b=YxLI00fns+hoRTn+syS63T0StMEjNAxHLyO8Na1YM5YBsG1aVZE7lARFHivP6xq58s1vkR
        aq1/CaMVeU8bDblwHg7sLek7mzOfxh7PGbVu4+fALhK1TxK/ZHnahM0Su6ZK4IoL/hmEsh
        2597v3M4q5s0uWOFig79fVffE8rDYeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-GJvRsitqMQWJbqPg04c7LQ-1; Wed, 15 Dec 2021 14:09:44 -0500
X-MC-Unique: GJvRsitqMQWJbqPg04c7LQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B89A801AAB;
        Wed, 15 Dec 2021 19:09:41 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.2.14.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CDE0196E6;
        Wed, 15 Dec 2021 19:09:14 +0000 (UTC)
Date:   Wed, 15 Dec 2021 14:09:12 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Leo Yan <leo.yan@linaro.org>, codalist@telemann.coda.cs.cmu.edu,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        netdev@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        coda@cs.cmu.edu, linux-audit@redhat.com,
        coresight@lists.linaro.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 6/7] audit: Use task_is_in_init_pid_ns()
Message-ID: <20211215190912.GU1550715@madcap2.tricolour.ca>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-7-leo.yan@linaro.org>
 <CAHC9VhThB=kDsXr8Uc_65+gePucSstAbrab2TpLxcBSd0k39pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhThB=kDsXr8Uc_65+gePucSstAbrab2TpLxcBSd0k39pQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-14 17:35, Paul Moore wrote:
> On Wed, Dec 8, 2021 at 3:33 AM Leo Yan <leo.yan@linaro.org> wrote:
> >
> > Replace open code with task_is_in_init_pid_ns() for checking root PID
> > namespace.
> >
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  kernel/audit.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I'm not sure how necessary this is, but it looks correct to me.

I had the same thought.  I looks correct to me.  I could see the value
if it permitted init_pid_ns to not be global.

> Acked-by: Paul Moore <paul@paul-moore.com>

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 121d37e700a6..56ea91014180 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1034,7 +1034,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> >         case AUDIT_MAKE_EQUIV:
> >                 /* Only support auditd and auditctl in initial pid namespace
> >                  * for now. */
> > -               if (task_active_pid_ns(current) != &init_pid_ns)
> > +               if (!task_is_in_init_pid_ns(current))
> >                         return -EPERM;
> >
> >                 if (!netlink_capable(skb, CAP_AUDIT_CONTROL))
> > --
> > 2.25.1
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

