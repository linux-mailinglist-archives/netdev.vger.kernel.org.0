Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDF263CE7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgIJGCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgIJGCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:02:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBC2C061573;
        Wed,  9 Sep 2020 23:02:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s2so2502090pjr.4;
        Wed, 09 Sep 2020 23:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1p1Yvpbl2hUtzS0Tbph8bRvhvEzrq/brMLlo+7qJTmo=;
        b=g88HRhuzR/tEUwOcTqCszmjAXNiJCm0J1vOe3sumDx3uHfUPjReXHmKT0PJpUGjbxz
         bCaYFJiGreJYRkyHL7n7izvSJPMLq9/tKv/Fqq09cLPKqrLyLl3sB3HdaMyemi2IV/Gy
         T40tnjziOVI/j7zTSWEHdgu0WxCDRfgpoyiImuf2W6fpRSq+HdIhR6CFtHVEJrC5ybbQ
         hyc2e9t+l638olaiw54lHUFjKF2O9wVjDtN5dn01LQ9PlWyOlQDEVgbty1smMbVcSgPk
         Fnc/gjwFzfa22dmde9gU0EoLkuvAOMEJmxubwlLBrgWXojL6oNGAZnDlepN0gjKmQwbe
         I7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1p1Yvpbl2hUtzS0Tbph8bRvhvEzrq/brMLlo+7qJTmo=;
        b=N65G8WEoUZD/9u96DjWvoPsBXiOpb+uxl838TbCOWWQK4+jwzXOtSLsgZQpjMOHiKN
         FjpBJNU6vYb78/DAXLJyRxRU5eak4fSY0n5Irre0conrtxSQ+EbK3R1HeBDR89fyNjMg
         ijzdjk0lVLJFXizDgQgVVTnV4ejaNETzB8F9Drwvrxi+TqNh6MPMGP/1J976I+oNlOFR
         WYqXiatwHqsqqdtCYg4wL/IWHKcwYrG5ybqwuITOE0/O+AYYm5jkfRZyAjLEU5HqCsan
         GJQ8xBblAozAP4CLl99xZzesCTsHHH52LiBn1BINjgNQoH9IisS09wkaXgt24TV+RQOU
         dq2Q==
X-Gm-Message-State: AOAM532O6UJoEKVdtlk3q7FdHciDcTZABK8qG9X968ezb8z+MFbMhFK1
        ejAR+gOnyUShBQqVgo63Gqw=
X-Google-Smtp-Source: ABdhPJzZ/CS0vTHPATpbUVEI5Yr2tYgH4VeZ6BMrwtFl2Cq9kNkZf1EdtQhp3tBvECFs97TwVRV6BQ==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr3938065pjr.229.1599717737265;
        Wed, 09 Sep 2020 23:02:17 -0700 (PDT)
Received: from Thinkpad ([45.118.165.156])
        by smtp.gmail.com with ESMTPSA id l23sm3831070pgt.16.2020.09.09.23.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:02:16 -0700 (PDT)
Date:   Thu, 10 Sep 2020 11:32:08 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: bluetooth: Fix null pointer dereference in
 hci_event_packet()
Message-ID: <20200910060208.GA22165@Thinkpad>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
 <20200910050659.GD828@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910050659.GD828@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 10:06:59PM -0700, Eric Biggers wrote:
> On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> > Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> > as NULL. Fix it by adding pointer check for it.
> > 
> > Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > ---
> >  net/bluetooth/hci_event.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..871e16804433 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> >  		return;
> >  	}
> >  
> > +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
> > +		hci_dev_unlock(hdev);
> > +		return;
> > +	}
> > +
> 

Hello Sir,

> In patches that fix a NULL pointer dereference, please include a brief
> explanation of why the pointer can be NULL, including what it means
> semantically; and why the proposed change is the best fix for the problem.
> 

I will surely add more explaination in v2.

> Also, why IS_ERR_OR_NULL()?
> 

I used IS_ERR_OR_NULL() to check if the 'hcon->amp_mgr' is a valid pointer or not, 
and unregister the 'hcon' and signal error, but will make changes in v2 with only
NULL check included, if you think it's incorrect to use IS_ERR check here along with
NULL.


Thanks,
Anmol Karn
