Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE45467D4DB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjAZTBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjAZTBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:01:16 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B9949946
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:01:15 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 123so3192213ybv.6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MmfZmgf9pKore6xMNZcJawKGGPuM9sLHIv6x9yMP/Jk=;
        b=Djyyux2TcREMm0Rl3FGdokLt1HsVlFSO1iMWBHLIRiXr6+gx25+vVpm5B9D/379794
         WUP3MYYiv6X8+PxCM3teVnzIqn4m8FmYL/mM3B0hOo9SDA+fSzYOyZ518Rj4eIM6Glr6
         Pbls94thwCOCom8lPOs+BhgGeOFQKcuUrnDFWBpLP8D5pibNpGfjch94BUsz7mGbbVGZ
         kAaH93pJb99aQ0VaBzhkMOWZLx1CJInHex/SiRMVxltLkszY2fetfVNhK1TV5yJqgjfP
         PjTMU/ePwv9AEoSbtekegI6rx4BDEolPHH0WA65xqew54zpZbvnVWTXgzcoa5TVpV7XC
         SVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MmfZmgf9pKore6xMNZcJawKGGPuM9sLHIv6x9yMP/Jk=;
        b=bpi5rzXomC40p8tXFIIUk2oYT8fFBi6viGWDxH7VAAHBjlquh8Cl/sY3rvqACQGMo3
         /Y5yUERA2OADjGEdJNJW2cqG3Po1PTgoNrQjklrR/M+QXfy5dInJuFnfuWBfgbtUnG/y
         KQtKPH+FFYUKXwo2vo//LggLEXQ6roKCjldBTxXxjX4+KRiBuP/8xGOkasflWmD90sOb
         CmJsiA/5EnpqU6ZZfm128uDJ42eXMqKmaWbpilfTDB1wF72qUHXBCplYFwMdpXIMMc5I
         BQ/BCZdST4dp/XGNG4nskuyIRDqqMiDJuh6Ppq7BeG9XezwdGeyYXEBiFZyBXk4EFHmu
         zD3A==
X-Gm-Message-State: AO0yUKUnCxwwi5BYxEiHu7V9Iq/xC9mTNVqeRcgFkYbEjd74D5wUeL2B
        l2ng6uY0XQXsH16peavUNz/yeffOAqizpKo7t/E8nePOxPN26J1a
X-Google-Smtp-Source: AK7set8RG+icC4sqrZquIQW9CCfgn3bBSfzS4PJRa718wPO2zqcjNyeKhpJTYjTa9b8w0jzaTan/QdY1fMlwBVdtNxM=
X-Received: by 2002:a25:b98d:0:b0:80b:cdc5:edf with SMTP id
 r13-20020a25b98d000000b0080bcdc50edfmr392030ybg.259.1674759674608; Thu, 26
 Jan 2023 11:01:14 -0800 (PST)
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <20230124170510.316970-19-jhs@mojatatu.com>
 <877cxacndc.fsf@nvidia.com> <CAM0EoMmgSWqvmvuN-Qv+cf8pf=Mtzp7d70+5C1DfjUKb5w6+GA@mail.gmail.com>
 <87cz71fcib.fsf@nvidia.com>
In-Reply-To: <87cz71fcib.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 26 Jan 2023 14:01:03 -0500
Message-ID: <CAM0EoMmHpd+MXr3OmfHks6WVkVo1o9SP_r9PhJiQgM_4rLHN_w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 19/20] p4tc: add dynamic action commands
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 12:10 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>
>
> On Thu 26 Jan 2023 at 07:52, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > On Wed, Jan 25, 2023 at 4:31 PM Vlad Buslov <vladbu@nvidia.com> wrote:
> >>
> >>

> >> > cmd set metadata.myprog.mymd metadata.kernel.skbmark

> >> The comment explains why the lock is required, but doesn't address the
> >> lockdep off/on. Could you elaborate on why it is needed?
> >>
> >
> > Note: we can invoke actions from other actions.
> > Reason it is needed is there is a deadlock false positive splat in the
> > following scenario:
> > A dynamic action will lock(dynact->tcf_lock) for its data and then
> > invoke a totally
> > different dynamic action (with totally independent data) which will also protect
> > its data by invoking its tcf_lock.
>
> Is the ordering of recursive action execution while holding the lock
> well defined? Is there anything preventing action A from calling B
> (maybe indirectly via some chain of actions) and vice versa resulting
> ABBA deadlock?

Yes, it is well defined - we dont allow recursion (action A calling action A)
even indirectly(ABA).  We have explicit code that ensures action
topological ordering;
see patch 15 (ex function determine_act_topological_order()).

> > We will add more description as such.
> > Does this also address what you said on "doesnt address the lockdep off/on"?
>
> Yep.
>
> > Unfortunately this is in the datapath - not sure how much cost it adds.
>
> I would assume lockdep_off/on doesn't result any performance impact on
> production kernels that are compiled without lockdep, just prefer to
> "cooperate" with lockdep by assigning classes where possible instead of
> disabling it outright. Not sure whether it is an option this case
> though.

We are going to look at getting rid of some of those locks altogether.
One other small tidbit:
Note: in P4, actions dont have counters embedded - so we are also leaning to
not even hold a lock for the counters by getting rid of stats
altogether. Essentially
we will create another P4 object called "counter" which can be
optionally bound when requested.

cheers,
jamal
