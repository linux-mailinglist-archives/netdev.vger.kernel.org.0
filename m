Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83F84BF74D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiBVLfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiBVLfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:35:42 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1E8134DD6;
        Tue, 22 Feb 2022 03:35:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645529707; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fEKzDU/Q0F4Nbi0WEddMnznIQ/x78KwUd7Iv6DEQiAOk5Yvq47N4tQxTodcqtK6/uQIU39aemRUjQb02Sr9BlfQ4fVCy2afYkqhuCcvLx9ZRhLOvtcdJzku0NUXwk/rQFXinM52aDucspEisr1yZ8NwOM1oFF0GR29fLWb3VkEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645529707; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eNoJ9GB2trVuiIwO/BLfBx6vYt1aPBHxeGABKqFQJOw=; 
        b=btamNQPR7JdQszRjlmu2KPwQ22C5/WTTy4AqP6hREy0VG2RG1fh1CaxUvefIoj7Oj4QSR6UsndxIVTZugm2IWAFOE1tm9M3qThl2e0LkXgXovmzMTZpAD4PGDCJuZt/CRFI3DELnjZJoFoA1DRl/RxT72dELDOOZpUH1qyMvY08=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645529707;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=eNoJ9GB2trVuiIwO/BLfBx6vYt1aPBHxeGABKqFQJOw=;
        b=tcmIPl/l32BxhmynD9ft66kRR2Z0CsZvazzodXNINc5w7RHCQAT6EltYeIen3eUS
        WIwgqap8QoQGR8kYlFk/+7f3jd0kdxShzrz+/iOGrbxTSN6mg+aaeeqp3z5wS//4eYN
        XstOPzEQPorBRUlTVvqqaowg/jXdvhcx75x0NbzI=
Received: from anirudhrb.com (49.207.218.248 [49.207.218.248]) by mx.zohomail.com
        with SMTPS id 1645529703723645.9746206531503; Tue, 22 Feb 2022 03:35:03 -0800 (PST)
Date:   Tue, 22 Feb 2022 17:04:51 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
Message-ID: <YhTKW1auC8nXuQpn@anirudhrb.com>
References: <00000000000057702a05d8532b18@google.com>
 <CAGxU2F4nGWxG0wymrDZzd8Hwhm2=8syuEB3fLMd+t7bbN7qWrQ@mail.gmail.com>
 <YhO1YL0A6OjtXmIy@anirudhrb.com>
 <20220222100556.GM3965@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222100556.GM3965@kadam>
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:05:56PM +0300, Dan Carpenter wrote:
> On Mon, Feb 21, 2022 at 09:23:04PM +0530, Anirudh Rayabharam wrote:
> > On Mon, Feb 21, 2022 at 03:12:33PM +0100, Stefano Garzarella wrote:
> > > #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> > > f71077a4d84b
> > > 
> > > Patch sent upstream:
> > > https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarzare@redhat.com/T/#u
> > 
> > I don't see how your patch fixes this issue. It looks unrelated. It is
> > surprising that syzbot is happy with it.
> > 
> > I have sent a patch for this issue here:
> > https://lore.kernel.org/lkml/20220221072852.31820-1-mail@anirudhrb.com/
> 
> I wasted so much time trying to figure out what this patch fixes.  :P

Sorry! The new patch is here:
https://lore.kernel.org/lkml/20220221195303.13560-1-mail@anirudhrb.com/T/#u

Thanks!

	- Anirudh.

> 
> (It doesn't fix anything).
> 
> regards,
> dan carpenter
> 
