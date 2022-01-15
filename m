Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC13B48F462
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiAOC0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:26:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54962 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiAOCZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:25:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA43061828;
        Sat, 15 Jan 2022 02:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9254C36AE9;
        Sat, 15 Jan 2022 02:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642213558;
        bh=Yk4Y6G2HryH0ZQKBp7+/9ICuGW+ToukcMKhMZUl37xE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M6K3ylKXCK885VCvOCdzru+Wdq6dpiQaxgW/wpb7s+WGtzCGP3uW72L2KJxxMuJ95
         UFvgHCA+Hq9xXUSKUQS3Ka5kBv57oEFINnyGH8tOgp1sZJ64manfneWEuvvCd1hiux
         3NHd0RQ20IZHWrAarq+p2QnSzlGhszdjONAWSFk4q9YeBcr9zUrTZQCqGv+ai/NPtz
         6PqeNwL3OY9+tllY6HGbkjjyFYKLt1wPWSh6ZrG16lLXa8+9d19rhOXRjy8WG+eh0E
         /0uRDBM367p/JTPBZMBWYUnWavh/tUyOgAWbIj0RYMYt6MmZcuqqn6mx4qdTGlX+jc
         Yhudlb332Empw==
Date:   Fri, 14 Jan 2022 18:25:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Xu Wang <vulab@iscas.ac.cn>, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/qeth: Remove redundant 'flush_workqueue()' calls
Message-ID: <20220114182556.373a159b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <45b2b8d0-b913-20cd-62ca-e6014505632c@linux.ibm.com>
References: <20220114084218.42586-1-vulab@iscas.ac.cn>
        <45b2b8d0-b913-20cd-62ca-e6014505632c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 12:58:38 +0100 Alexandra Winter wrote:
> On 14.01.22 09:42, Xu Wang wrote:
> > 'destroy_workqueue()' already drains the queue before destroying it, so
> > there is no need to flush it explicitly.
> > 
> > Remove the redundant 'flush_workqueue()' calls.
> > 
> > Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> > ---
> >  drivers/s390/net/qeth_l3_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> > index 9251ad276ee8..d2f422a9a4f7 100644
> > --- a/drivers/s390/net/qeth_l3_main.c
> > +++ b/drivers/s390/net/qeth_l3_main.c
> > @@ -1961,7 +1961,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
> >  	if (card->dev->reg_state == NETREG_REGISTERED)
> >  		unregister_netdev(card->dev);
> >  
> > -	flush_workqueue(card->cmd_wq);
> >  	destroy_workqueue(card->cmd_wq);
> >  	qeth_l3_clear_ip_htable(card, 0);
> >  	qeth_l3_clear_ipato_list(card);  
> 
> Thanks for pointing this out!
> 
> IMO, this can go to net-next as it is not a fix, but removes redundancy.

Agreed.

> Acked-by: Alexandra Winter <wintera@linux.ibm.com>

Please keep Alexandra's ack and repost in ~1.5 week -- after 5.17-rc1
is tagged.
