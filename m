Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C22213092
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 02:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGCArf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 20:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGCAre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 20:47:34 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028B5C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 17:47:34 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c139so27427586qkg.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 17:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lqxRlxOzCUZTldRmMHcYelr3ZpKjSXudll2PIqMKh8E=;
        b=uOWIj15f5AiYdPrMWl2ZOKeJCihcIH9ouOC93SCyfycjsXpOOlryQCKv/Tvq/R5Uva
         RLjxFmPtpIr2SvrxA569k6achOT88EQ38OPe13bL55X4tPOpLYXzwQtSN6KR7N/wokpH
         xrGhmG+TD8NFW1zHOwAyi1j8lj+qoBkmzc+gQYQgF6qP8RZbTMky1LZlFDCS4TWa+MkE
         qfk00mthAZEDhD7LwAfR3FyWBjPMSR7WHy2TsEDsOIzREmQgbN+u3vQ8z1jx+POJu3DT
         cjxOtAWzWxeXjPlnOygMX8gUXeEVmhSI+6vsx5zISOKbgg5kKDZwFcu5W/zP6Q+V8kUw
         driA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lqxRlxOzCUZTldRmMHcYelr3ZpKjSXudll2PIqMKh8E=;
        b=gEwT++iBuBn1iFV3b+XtGDWxjGi9nAf6WsH2S7J16L2n7HbqRLNbugE1ir1eZj6t/j
         Ud5EVgwaxdJIqjCblZ10UeYZ24/LGEiG+QvgB2XInJceaX+y52NTW9/SqdkGMzROupfw
         DIgJ3NW+j1WY+NcfJgphHj+mHiCBaTfwBgR3kQolTzzF8zm/Qazb4L8Wm4By6og1ZcNg
         Z3K89PAM2qsz9NKgXRVYstePAD7Mcc4w5rdnxZOmNeKNKFcBkLSo4t2qQljKZ2Mj5qKO
         1I72EiKvsUkX8F4uLtCUsnhRrt8Gmj6TuypMV0Jl2kIb6kGBcmvWka3aTrUGKjqnXEwL
         cpeQ==
X-Gm-Message-State: AOAM532Z/IBJOVhoRelT+clrHB5cTqWY4Io86NVH5DW3RtsCboplM0cD
        wyFChomkxzNyvf5oe2kvx1k=
X-Google-Smtp-Source: ABdhPJyQplPT2s/gutS99XFLEn6deqnSN+zc1mAV2mo1JxBWm1JT9i9NH+TClizwoq4b7QSZKS/F5A==
X-Received: by 2002:a05:620a:6c3:: with SMTP id 3mr32403533qky.400.1593737253042;
        Thu, 02 Jul 2020 17:47:33 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.66])
        by smtp.gmail.com with ESMTPSA id u124sm9414746qkf.83.2020.07.02.17.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 17:47:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 41ABFC0DAC; Thu,  2 Jul 2020 21:47:27 -0300 (-03)
Date:   Thu, 2 Jul 2020 21:47:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
Message-ID: <20200703004727.GU2491@localhost.localdomain>
References: <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
 <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
 <20200702173228.GH74252@localhost.localdomain>
 <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 02:39:07PM -0700, Cong Wang wrote:
> On Thu, Jul 2, 2020 at 10:32 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Thu, Jul 02, 2020 at 05:36:38PM +0800, wenxu wrote:
> > >
> > > On 7/2/2020 1:33 AM, Cong Wang wrote:
> > > > On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
> > > >>
> > > >> On 7/1/2020 2:21 PM, wenxu wrote:
> > > >>> On 7/1/2020 2:12 PM, Cong Wang wrote:
> > > >>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
> > > >>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
> > > >>>> Same question: why act_mirred? You have to explain why act_mirred
> > > >>>> has the responsibility to do this job.
> > > >>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
> > > >>>
> > > >>> the act_mirred can decides whether do the fragment or not.
> > > >> Hi cong,
> > > >>
> > > >>
> > > >> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
> > > >>
> > > >> Did you have some other suggestion to solve this problem?
> > > > Like I said, why not introduce a new action to handle fragment/defragment?
> > > >
> > > > With that, you can still pipe it to act_ct and act_mirred to achieve
> > > > the same goal.
> > >
> > > Thanks.  Consider about the act_fagment, There are two problem for this.
> > >
> > >
> > > The frag action will put the ressemble skb to more than one packets. How these packets
> > >
> > > go through the following tc filter or chain?
> >
> > One idea is to listificate it, but I don't see how it can work. For
> > example, it can be quite an issue when jumping chains, as the match
> > would have to work on the list as well.
> 
> Why is this an issue? We already use goto action for use cases like
> vlan pop/push. The header can be changed all the time, reclassification
> is necessary.

Hmm I'm not sure you got what I meant. That's operating on the very
same skb... I meant that the pipe would handle a list of skbs (like in
netif_receive_skb_list). So when we have a goto action with such skb,
it would have to either break this list and reclassify each skb
individually, or the classification would have to do it. Either way,
it adds more complexity not just to the code but to the user as well
and ends up doing more processing (in case of fragments or not) than
if it knew how to output such packets properly. Or am I just
over-complicating it?

Or, instead of the explicit "frag" action, make act_ct re-fragment it.
It would need to, somehow, push multiple skbs down the remaining
action pipe. It boils down to the above as well.

> 
> >
> > >
> > >
> > > When should use the act_fragament the action,  always before the act_mirred?
> >
> > Which can be messy if you consider chains like: "mirred, push vlan,
> > mirred" or so. "frag, mirred, defrag, push vlan, frag, mirred".
> 
> So you mean we should have a giant act_do_everything?

Not at all, but

> 
> "Do one thing do it well" is exactly the philosophy of designing tc
> actions, if you are against this, you are too late in the game.

in this case a act_output_it_well could do it. ;-)

Thanks,
  Marcelo
