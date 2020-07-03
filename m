Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4BA213EF6
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 19:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGCRvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 13:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCRvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 13:51:02 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D745BC061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 10:51:01 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e11so29504030qkm.3
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 10:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VxDT3rTHGIgTB+CwdOyLgZUCZlMXgCowLWA31+W31ho=;
        b=ElPkmbKlQ9ISLtd9gUDFbh4a85n6/l4L9s5x0f8yop/I80zXe0qlq3x88+nUcAKkSj
         qzU+5sgoL6qEA3ujTEmWnKArVze7n19CPjkniY/4NnQqnFKmQ+23GVYb9gdR+2Xk53Nq
         /X7x5LfUU3oFh8DijgOkDglIUBRVrikOfi0tEYRmKGDeM1ZdRhbj6ajwZl4jwtxaBivM
         PjMoZMBj3jrs0j8Qe2jijn+uK2av7Hcj0LzlSpULf2sxni1tx4erlcY/MxvT5Q1sRm/N
         mr+j0WN2iteY1O3llRYBgUYj9dnwC1l2XkmTnLIM6TPb4o/MYLCMvzJeGHtgjK+srJBK
         9spQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VxDT3rTHGIgTB+CwdOyLgZUCZlMXgCowLWA31+W31ho=;
        b=fztturAjS5Zlx56YAmmf/hqJ69wTENeWhRrP3zXd2hmNU4fsd6DpvXGNXLz/Zu4ONy
         nQDzOJbFIc0It+Yyx2PT5YYJGjV70tIFLEwsfbTgGfnpkoalRuctde5DmTC1bwG/FvzE
         LJUL39TwAyA2OQx5anrHC2mu7sBGIzcgTcumMvCh1XT1UCsmmkgJqTacjSutVXelSksn
         pBGlTYkGwqboP8kZF0QzjxbGpM1sLm4PXzy4DoxoJ5uPsS4Tzt5SqRcRiC0tZkf7XMLg
         DbFKuz1JNQyfPc3nas8tGixEi7XlmCsO7rS/jtrcAmXAw2bXa8uEjCgKr2T1d2F8nZQX
         Qj/g==
X-Gm-Message-State: AOAM532snk9be1Z78uboSih0+aRl06YUACVQp1Zf7GrIEU9KajscaWQ5
        WaEz8b1fzHiRHZvaJguH+o8=
X-Google-Smtp-Source: ABdhPJx6dYEvNLdHSgdQBJb/BPtgcPkoVT5oA23Yar4mPxNA/eZNXH1HOI8qs/x2yymszKGAFLwB0g==
X-Received: by 2002:a37:46d3:: with SMTP id t202mr34605453qka.483.1593798660869;
        Fri, 03 Jul 2020 10:51:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:99b0:9721:6a72:5c18:41d5])
        by smtp.gmail.com with ESMTPSA id f22sm14833828qko.89.2020.07.03.10.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 10:51:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id BA725C0E41; Fri,  3 Jul 2020 14:50:57 -0300 (-03)
Date:   Fri, 3 Jul 2020 14:50:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
Message-ID: <20200703175057.GV2491@localhost.localdomain>
References: <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
 <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
 <20200702173228.GH74252@localhost.localdomain>
 <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
 <20200703004727.GU2491@localhost.localdomain>
 <349bb25a-7651-2664-25bc-3f613297fb5c@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <349bb25a-7651-2664-25bc-3f613297fb5c@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 06:19:51PM +0800, wenxu wrote:
> 
> On 7/3/2020 8:47 AM, Marcelo Ricardo Leitner wrote:
> > On Thu, Jul 02, 2020 at 02:39:07PM -0700, Cong Wang wrote:
> >> On Thu, Jul 2, 2020 at 10:32 AM Marcelo Ricardo Leitner
> >> <marcelo.leitner@gmail.com> wrote:
> >>> On Thu, Jul 02, 2020 at 05:36:38PM +0800, wenxu wrote:
> >>>> On 7/2/2020 1:33 AM, Cong Wang wrote:
> >>>>> On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
> >>>>>> On 7/1/2020 2:21 PM, wenxu wrote:
> >>>>>>> On 7/1/2020 2:12 PM, Cong Wang wrote:
> >>>>>>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
> >>>>>>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
> >>>>>>>> Same question: why act_mirred? You have to explain why act_mirred
> >>>>>>>> has the responsibility to do this job.
> >>>>>>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
> >>>>>>>
> >>>>>>> the act_mirred can decides whether do the fragment or not.
> >>>>>> Hi cong,
> >>>>>>
> >>>>>>
> >>>>>> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
> >>>>>>
> >>>>>> Did you have some other suggestion to solve this problem?
> >>>>> Like I said, why not introduce a new action to handle fragment/defragment?
> >>>>>
> >>>>> With that, you can still pipe it to act_ct and act_mirred to achieve
> >>>>> the same goal.
> >>>> Thanks.  Consider about the act_fagment, There are two problem for this.
> >>>>
> >>>>
> >>>> The frag action will put the ressemble skb to more than one packets. How these packets
> >>>>
> >>>> go through the following tc filter or chain?
> >>> One idea is to listificate it, but I don't see how it can work. For
> >>> example, it can be quite an issue when jumping chains, as the match
> >>> would have to work on the list as well.
> >> Why is this an issue? We already use goto action for use cases like
> >> vlan pop/push. The header can be changed all the time, reclassification
> >> is necessary.
> > Hmm I'm not sure you got what I meant. That's operating on the very
> > same skb... I meant that the pipe would handle a list of skbs (like in
> > netif_receive_skb_list). So when we have a goto action with such skb,
> > it would have to either break this list and reclassify each skb
> > individually, or the classification would have to do it. Either way,
> > it adds more complexity not just to the code but to the user as well
> > and ends up doing more processing (in case of fragments or not) than
> > if it knew how to output such packets properly. Or am I just
> > over-complicating it?
> >
> > Or, instead of the explicit "frag" action, make act_ct re-fragment it.
> > It would need to, somehow, push multiple skbs down the remaining
> > action pipe. It boils down to the above as well.
> >
> >>>>
> >>>> When should use the act_fragament the action,  always before the act_mirred?
> >>> Which can be messy if you consider chains like: "mirred, push vlan,
> >>> mirred" or so. "frag, mirred, defrag, push vlan, frag, mirred".
> >> So you mean we should have a giant act_do_everything?
> > Not at all, but
> >
> >> "Do one thing do it well" is exactly the philosophy of designing tc
> >> actions, if you are against this, you are too late in the game.
> > in this case a act_output_it_well could do it. ;-)
> agree, Maybe a act_output_ct action is better?

Ahm, sorry, that wasn't really my intention here. I meant that I don't
see an issue with mirred learning how to fragment it and, with that,
do its action "well" (as subjective as the term can be).

> >
> > Thanks,
> >   Marcelo
> >
