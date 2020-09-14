Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3726950B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgINSiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgINShu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:37:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC8C06174A;
        Mon, 14 Sep 2020 11:37:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so298117pfn.9;
        Mon, 14 Sep 2020 11:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cIjnkNboqpSpjKpr5bq8lUzIhrcoSiXnXhmqYN4ei3c=;
        b=AafhezfwbH68K+RdqYxFPc1vR/a0IPjGkG+E9FLkVV/sAW8WWA2tWv2LkHWbhH54eg
         aT6l3xw3ZSGubZ4Vn8U7NMCoaxBLUe+a7WDwDsTjTDF3Z70v2/SJWfdcAC16TIzj6w98
         ssZ9YuPz7yaoVBPrzIsIOWSZt4Ua+hYjFqeWwSEUgVD3003lc0zQsOiN2WFufdp7OxMj
         S5ieMvoGp5u17M4Kr6xdPhx6qOItpgoYPviJq5c97rdWid5GiQoOqMgHrTHJJaxpr7yk
         khD2PorC+YRbeBtFTB172VG91hPad9ue00nFRfrgBhEkGxKV+ZbjUcPNnmorQZf0Iwuq
         4q2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cIjnkNboqpSpjKpr5bq8lUzIhrcoSiXnXhmqYN4ei3c=;
        b=jmMSv7VU3C/oM9eav8WGbyDZTSC0oHzsliBnpioAfFyjVcxqONdJomVj7mw7B66+73
         b3txwADX4h6fsbha9Yo7aGYTfaNJkdq3e/QZZgjZybghrNVUUmD28ceWoIfq9gqi/73z
         6aYOdEG0OkbkmRaPyLudItwgjZzmvq+rpXur6eduRiAtYSsMYuLXM9oCre5CyTq+Xbpm
         NQCbUw3vLRx3t24+rvOjYs9dbj/5+o/nGW17NnOi05tfyMwjzP4Gewh4M9fRXHDUtmum
         jCFD/lmRt6VPDKj44uw2i9ZLRXw+G+tdCtVSCltjQ/nhUWuKymnwXtcElmvSKfzX9YVm
         SLiw==
X-Gm-Message-State: AOAM532THpfzrAmImm+2fjbudAR9wHsbxw1yAr8mxi2HU5eTvL+XagDH
        JyYlK7mPPsMzLLa2JgGXd2EtKTPG1LKpG/eL
X-Google-Smtp-Source: ABdhPJxd+HIKMi83DPmS+Gm/5/k9uEYuw6a1koLz6/IjZhZtYPnN26smI7fZ5TQp37DTMyGAWcSAQg==
X-Received: by 2002:a62:864e:: with SMTP id x75mr14212709pfd.60.1600108662974;
        Mon, 14 Sep 2020 11:37:42 -0700 (PDT)
Received: from Thinkpad ([45.118.167.207])
        by smtp.gmail.com with ESMTPSA id r144sm11769496pfc.63.2020.09.14.11.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 11:37:42 -0700 (PDT)
Date:   Tue, 15 Sep 2020 00:07:34 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 dereference in hci_event_packet()
Message-ID: <20200914183734.GA213347@Thinkpad>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
 <20200910104918.GF12635@kadam>
 <20200912091028.GA67109@Thinkpad>
 <20200914154405.GC18329@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914154405.GC18329@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sir,
 
> > I have looked into the Bisected logs and the problem occurs from this commit:
> > 
> > 941992d29447 ("ethernet: amd: use IS_ENABLED() instead of checking for built-in or module")
> > 
> 
> That's just the patch which made the code testable by syzbot.  It didn't
> introduce the bug.
> 
> > 
> > Here is a diff of patch which i modified from last patch,
> > 
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..6ce435064e0b 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4936,6 +4936,12 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> >                 return;
> >         }
> > 
> > +       if (!hcon->amp_mgr) {
> > +               hci_conn_del(hcon);
> > +               hci_dev_unlock(hdev);
> 
> I have no idea if calling hci_conn_del() is really the correct, thing.
> I don't know the code at all.  Anyway, do some research and figure out
> for sure what the correct thing is.

I have created my patch on the basis of the already applied conditions handling
in this function, i.e whenever NULL dereference occurs, connection cleanup is 
required hence, hci_conn_del() is used here. Will see if anything else could be
done.

> 
> Also look for similar bugs in other places where hcon->amp_mgr is
> dereferenced.  For example, amp_read_loc_assoc_final_data() seems to
> have a similar bug.
> 

Sure sir will look into it.

> regards,
> dan carpenter
> 

Thanks,
Anmol
