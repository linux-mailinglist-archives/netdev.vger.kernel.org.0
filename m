Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41572276FFB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 13:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgIXLbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 07:31:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgIXLbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 07:31:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600947096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clUvTAjWxOKB0zT0eA1ARy5x1LjR+x7YhgaXafvUhy4=;
        b=VxAGt4wUGV/PfYiprAcyAstOnKD3EWlzpm56hGOesIFqUrJFqUqRCCy6LvrYDwNAFpIMPH
        JSQrpwXV0rlQUzxDUi6T2a/WGJfrhqI0C8w4uOJJOrx77fkLCpilVATvMO0V1LSfSrakL7
        unytmJKc/h6lLIXMRqIyOX4vFfMpx2o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 98802AC85;
        Thu, 24 Sep 2020 11:31:36 +0000 (UTC)
Message-ID: <2f997848ed05c1f060125f7567f6bc3fae7410bb.camel@suse.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
From:   Oliver Neukum <oneukum@suse.com>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, yuehaibing@huawei.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Date:   Thu, 24 Sep 2020 13:09:05 +0200
In-Reply-To: <20200923144832.GA11151@karbon>
References: <20200923090519.361-1-himadrispandya@gmail.com>
         <20200923090519.361-4-himadrispandya@gmail.com>
         <1600856557.26851.6.camel@suse.com> <20200923144832.GA11151@karbon>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 23.09.2020, 17:48 +0300 schrieb Petko Manolov:

> > This internally uses kmemdup() with GFP_KERNEL.
> > You cannot make this change. The API does not support it.
> > I am afraid we will have to change the API first, before more
> > such changes are done.
> 
> One possible fix is to add yet another argument to usb_control_msg_recv(), which 
> would be the GFP_XYZ flag to pass on to kmemdup().  Up to Greg, of course.

Hi,

submitted. The problem is those usages that are very hard to trace.
I'd dislike to just slab GFP_NOIO on them for no obvious reason.

	Regards
		Oliver


