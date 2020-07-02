Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D677212EF6
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGBVjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBVjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:39:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F349C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 14:39:19 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so16797204iob.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 14:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HgsEloKwehAlSlgXlOdH+K47+nzRvXA6WvP8QBwidY=;
        b=gVn8W3pnzidcObanF+efZDlt91QxfNdVa8MzIhIhaa2pvIogqY9pPxbT29Srh055fG
         J8aF91UzBTpyVhRW+ZO3+JnI+rGcBlLqrSnWEVHt/VMj6UPcs00w9UZxlzafbF8dbyDx
         r3QNqvYUIHz49/GRIIGmg/cgDjr5WmhEw7nDtQOgzlKjbMRqtvgXFk8GeZm0ggUuw+61
         OW6ir8dQDaTHrrZcSTogVmj1doXYPVPLb4jS10b3DfJeSdO4yWRpiqocdRvrzmHmwJrl
         8pQlsVIm9utUTEjRmd3s7mHtJ/gyr/NCWQrhIIEmnzrNijnGnUwjtJ+do6WOrjjSHijt
         6VeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HgsEloKwehAlSlgXlOdH+K47+nzRvXA6WvP8QBwidY=;
        b=sc7L2PhJ8LrT+7nD/dkAHPmBSZbJ4Aja19utL1mNrsNwPLL1ORUKWDVVezZhNAXO64
         MUDiYInXJvkVI/FDjFRnWQA8NfcZdtub3R0pOTJ1CvXSbf+KlY1P90ivkQV+vtRbpg92
         rigbS/stoJaVM5PGkwC/Ke1DskxAbvCKDyyLq3Zb6GnH2GmsD4hyhDFk5sWo7S7DlS0f
         P2JhjroPHxGpfumrkH1PIHF8zBk3UA8YAcWJaw13Mq9Q/Joc0BMH2in7PZwNv+2SrlKN
         xgvDIExE9B8DUE6bgz0CaSFzd7PygeEAnwqe1wg44PJX/mW+TO54K4cT9l4FNFnV1grB
         M8fQ==
X-Gm-Message-State: AOAM531yEQYg1pZxS5AQ2tT8hZkV5e5P766hYgY29ahIh7e4f95ATQdt
        QSgU9+2+YS05Jq920Yj1oPz5auPcUXcuPHkRJyA=
X-Google-Smtp-Source: ABdhPJxDxEszkoZO4tpsis09zqFRMnMHByXagXI+dB4K80YWnvZVGKCzN0b/Wo7yEBuLJEgYTz2mxfG4AWk0njc9l4g=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr35017747jai.124.1593725958728;
 Thu, 02 Jul 2020 14:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn> <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn> <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn> <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn> <20200702173228.GH74252@localhost.localdomain>
In-Reply-To: <20200702173228.GH74252@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Jul 2020 14:39:07 -0700
Message-ID: <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 10:32 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Jul 02, 2020 at 05:36:38PM +0800, wenxu wrote:
> >
> > On 7/2/2020 1:33 AM, Cong Wang wrote:
> > > On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
> > >>
> > >> On 7/1/2020 2:21 PM, wenxu wrote:
> > >>> On 7/1/2020 2:12 PM, Cong Wang wrote:
> > >>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
> > >>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
> > >>>> Same question: why act_mirred? You have to explain why act_mirred
> > >>>> has the responsibility to do this job.
> > >>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
> > >>>
> > >>> the act_mirred can decides whether do the fragment or not.
> > >> Hi cong,
> > >>
> > >>
> > >> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
> > >>
> > >> Did you have some other suggestion to solve this problem?
> > > Like I said, why not introduce a new action to handle fragment/defragment?
> > >
> > > With that, you can still pipe it to act_ct and act_mirred to achieve
> > > the same goal.
> >
> > Thanks.  Consider about the act_fagment, There are two problem for this.
> >
> >
> > The frag action will put the ressemble skb to more than one packets. How these packets
> >
> > go through the following tc filter or chain?
>
> One idea is to listificate it, but I don't see how it can work. For
> example, it can be quite an issue when jumping chains, as the match
> would have to work on the list as well.

Why is this an issue? We already use goto action for use cases like
vlan pop/push. The header can be changed all the time, reclassification
is necessary.

>
> >
> >
> > When should use the act_fragament the action,  always before the act_mirred?
>
> Which can be messy if you consider chains like: "mirred, push vlan,
> mirred" or so. "frag, mirred, defrag, push vlan, frag, mirred".

So you mean we should have a giant act_do_everything?

"Do one thing do it well" is exactly the philosophy of designing tc
actions, if you are against this, you are too late in the game.

Thanks.
