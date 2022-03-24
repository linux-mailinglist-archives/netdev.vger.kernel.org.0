Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943A74E6A77
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 22:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353252AbiCXWAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 18:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiCXWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 18:00:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476A220C5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 14:59:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c11so4889152pgu.11
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 14:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P98EhcKlXlIoxjs8lUpPIr0xnMSUtUyiRS9iVnjcbyE=;
        b=O41y2ze/U6Vpqs7adbkoUxMD8XLOCfhiIIaXq7rhRYPvmxkGkMim3d2fF618kL9HOf
         vAkrkAzSlHKwyNyF9j637VbIl1qEsthq17MbaZ+3SWawM/5xryuI02LXlJfBpYSxLlw5
         jr8w2Vs8gA3CBzeY26HTHD4skCSziuGSQ7i/5c3bZBe9W2Vw6BmlInasUn0/EHqV9qMv
         6B6JtSMX+58nTY5PE1ZyJIpzJXKRBc+WDlZdaVnHyeAdxT1KD0XqSthKI/yGSW6mC0/V
         Grdgf+MVNkU8CeJyjvEdEtNw1PKvaWMpgvIToIyxVswDd2JFOKDGbbuUfnE2iENEVfFd
         1+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P98EhcKlXlIoxjs8lUpPIr0xnMSUtUyiRS9iVnjcbyE=;
        b=ecHSCvVlfjREi042Hb64QL3Evxyp+rZr8k1YLTbS4XXEg23f8HMvSDFDwwuLFoUvkm
         GAkroJ389nJFJLZfkXN7eI+Uoir0EKArWU0ETuLwioTk/WgZf7gYTH/DsCm2PaRElULb
         wzttSsqTfHUUnuSLSakwLXx8LDJ7JFACalV+h8BpXXzrvhYaxCM9GjnON5pADF8TfqpX
         z8DDChFhZwxaUGKtJLkgour732UZuKA5L2hBewQ8jomnH4unupZv/d7c4LvCp1GPKvph
         0MCws/zDAvq9d4gjd1MaaD9V1q/IA4KfOlTd1lOLoz2nwJTPJXufm13+NBxfGrfZlDrL
         7+sw==
X-Gm-Message-State: AOAM530zN/zCbwL3yYOgJuBhZfn3k88y0+aXOduBpJrmn/mDolHy+PNa
        rpmwe9Cgy5mX3Fffg9mvHnADtg==
X-Google-Smtp-Source: ABdhPJyHxALxcXi0BFZ1RSTlzh1UKAlx0XXHZ8OWZMhP1ldReBEfj6C5ZgJP8dx3aW5WfTvwxQ1JaQ==
X-Received: by 2002:a65:6855:0:b0:382:59e5:b6e5 with SMTP id q21-20020a656855000000b0038259e5b6e5mr5524859pgt.586.1648159143727;
        Thu, 24 Mar 2022 14:59:03 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id cd20-20020a056a00421400b004fa7d1b35b6sm4260979pfb.80.2022.03.24.14.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 14:59:03 -0700 (PDT)
Date:   Thu, 24 Mar 2022 21:58:59 +0000
From:   William McVicker <willmcvicker@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <Yjzpo3TfZxtKPMAG@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
 <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/23/2022, Jeff Johnson wrote:
> On 3/22/2022 2:58 PM, William McVicker wrote:
> > On 03/22/2022, Jeff Johnson wrote:
> > > On 3/21/2022 1:07 PM, Johannes Berg wrote:
> > > [..snip..]
> > > 
> > > > > I'm not an networking expert. So my main question is if I'm allowed to take
> > > > > the RTNL lock inside the nl80211_vendor_cmd callbacks?
> > > > 
> > > > Evidently, you're not. It's interesting though, it used to be that we
> > > > called these with the RTNL held, now we don't, and the driver you're
> > > > using somehow "got fixed" to take it, but whoever fixed it didn't take
> > > > into account that this is not possible?
> > > 
> > > On this point I just want to remind that prior to the locking change that a
> > > driver would specify on a per-vendor command basis whether or not it wanted
> > > the rtnl_lock to be held via NL80211_FLAG_NEED_RTNL. I'm guessing for the
> > > command in question the driver did not set this flag since the driver wanted
> > > to explicitly take the lock itself, otherwise it would have deadlocked on
> > > itself with the 5.10 kernel.
> > > 
> > > /jeff
> > 
> > On the 5.10 kernel, the core kernel sets NL80211_FLAG_NEED_RTNL as part of
> > the internal_flags for NL80211_CMD_VENDOR:
> > 
> > net/wireless/nl80211.c:
> >     {
> >        .cmd = NL80211_CMD_VENDOR,
> >        .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> >        .doit = nl80211_vendor_cmd,
> >        .dumpit = nl80211_vendor_cmd_dump,
> >        .flags = GENL_UNS_ADMIN_PERM,
> >        .internal_flags = NL80211_FLAG_NEED_WIPHY |
> >                NL80211_FLAG_NEED_RTNL |
> >                NL80211_FLAG_CLEAR_SKB,
> >     },
> > 
> > So the 5.10 version of this driver doesn't need to directly call rtnl_lock()
> > within the vendor command doit() functions since pre_doit() handles the RTNL
> > locking.
> > 
> > It would be nice if nl80211_vendor_cmd() could support taking the RTNL lock if
> > requested via the vendor flags. That would require moving the wiphy lock to
> > nl80211_vendor_cmds() so that it could take the RTNL and wiphy lock in the
> > correct order. Is that something you'd be open to Johannes?
> > 
> > --Will
> 
> Thanks for correcting my understanding. I concur that it would be useful for
> vendor commands to be able to specify that a given command needs the RTNL
> lock to be held.
> 
> 

Hi Johannes,

I found that we can hit this same ABBA deadlock within the nl80211 code
before ever even calling into the vendor doit() function. The issue I found
is caused by the way we unlock the RTNL mutex. Here is the call flow that
leads to the deadlock:

Thread 1                         Thread 2
 nl80211_pre_doit():
   rtnl_lock()
   wiphy_lock()                   nl80211_pre_doit():
                                    rtnl_lock() // blocked by Thread 1
   rtnl_unlock():
     netdev_run_todo():
       __rtnl_unlock()
                                    <got RTNL lock>
                                    wiphy_lock() // blocked by Thread 1
       rtnl_lock(); // DEADLOCK
 doit()
 nl80211_post_doit():
   wiphy_unlock();

Basically, unlocking the RTNL within netdev_run_todo() gives another thread
that is waiting for the RTNL in nl80211_pre_doit() a chance to grab the
RTNL lock leading to the deadlock. I found that there are multiple
instances where rtnl_lock() is called within netdev_run_todo(): a couple of
times inside netdev_wait_allrefs() and directly by netdev_run_todo().

Since I'm not really familiar with all the RNTL locking requirements, I was
hoping you could take a look at netdev_run_todo() to see if it's possible
to refactor it to avoid this deadlock. If not, then I don't think we can
call rtnl_unlock() while still holding the wiphy mutex.

Thanks,
Will
