Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A46C212B4D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgGBRce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgGBRcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:32:33 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8DC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:32:32 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t11so10994171qvk.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=I3J7T9wFCT5dwUROnH09H+eMFRH5RIrA2klCbLD2YG8=;
        b=vQsxpu1n7Li+ff99BNBFOF9R3i9GYBokv/LKDu22Lzcsk8Saba9kiq0lh765Ep6Ktg
         bky786OKgjqeSosfsSZltP5fB2JMmOXECYCHklXSkW/2K3DeUFWIYvnOicRTf5vgddGe
         pa9QXeA5caAhJxhAS0rhx6E9tEs6B28mQ/UVjjhmHwDbRArUYhVqoIqdf5UAPRO3Q9kX
         RJ9pi5iqazHM6AQWdM5GF5zlPLwC+D/F8VV6muJfcVDydyXZd7w+uxwJ1EujRA327LQj
         jM4/UbSO5LY3mIPkBp762UQC6e5mxE/suLYhy799UzZFnCeMnJCZGZEm16Ocx5eRyUwA
         xmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=I3J7T9wFCT5dwUROnH09H+eMFRH5RIrA2klCbLD2YG8=;
        b=TzFBOJCIjozJpyfxsZik/W7PLjV0Jc1245o5k8nnTe6jMiNsiM/CAHIwfpcneRN6wc
         FEUNsfrHxMZdxNwkESFhv0wZbReZbg6UR1GjTlx7x+h7SJbj68lL+QYnrfzDQhv6zZt+
         rbmj2VjizcQA2r56Xk8brQ1hzcv7L2cz85m2BcxJ7VhKevgBkTHk+KIKD/t1OknQcvQc
         CxOf7bKNBLugOBcWw1iQf5TY1q7zn4dXQXk0NFoYn3Eo2t+IBQQiN5U1Cj6y6QIiTryl
         DbrF5KbZdFqTlI7PGmxIa5SoPTl8nH1yd6Bjy/cv/f8FkRo58BhLKYO3J9n4ThkNT84j
         85VA==
X-Gm-Message-State: AOAM533eReY9/p6pQHkw/R/7IMGT02WsKAw5FO3zjhq8soo6lHpsF8R7
        Ky6NAeZ7iEMN29TVlgB+Wz3GGVTv
X-Google-Smtp-Source: ABdhPJy3tJOHOSx/B5fJidtuamwonGJ1IpPLEnB0DTzeua4IbYctUa+j1flGPsmbhLsYakcK+3J62g==
X-Received: by 2002:a0c:a002:: with SMTP id b2mr14999188qva.173.1593711151287;
        Thu, 02 Jul 2020 10:32:31 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.66])
        by smtp.gmail.com with ESMTPSA id m7sm8935192qti.6.2020.07.02.10.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:32:30 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 22723C0A80; Thu,  2 Jul 2020 14:32:28 -0300 (-03)
Date:   Thu, 2 Jul 2020 14:32:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
Message-ID: <20200702173228.GH74252@localhost.localdomain>
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
 <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 05:36:38PM +0800, wenxu wrote:
> 
> On 7/2/2020 1:33 AM, Cong Wang wrote:
> > On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
> >>
> >> On 7/1/2020 2:21 PM, wenxu wrote:
> >>> On 7/1/2020 2:12 PM, Cong Wang wrote:
> >>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
> >>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
> >>>> Same question: why act_mirred? You have to explain why act_mirred
> >>>> has the responsibility to do this job.
> >>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
> >>>
> >>> the act_mirred can decides whether do the fragment or not.
> >> Hi cong,
> >>
> >>
> >> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
> >>
> >> Did you have some other suggestion to solve this problem?
> > Like I said, why not introduce a new action to handle fragment/defragment?
> >
> > With that, you can still pipe it to act_ct and act_mirred to achieve
> > the same goal.
> 
> Thanks.  Consider about the act_fagment, There are two problem for this.
> 
> 
> The frag action will put the ressemble skb to more than one packets. How these packets
> 
> go through the following tc filter or chain?

One idea is to listificate it, but I don't see how it can work. For
example, it can be quite an issue when jumping chains, as the match
would have to work on the list as well.

> 
> 
> When should use the act_fragament the action,  always before the act_mirred?

Which can be messy if you consider chains like: "mirred, push vlan,
mirred" or so. "frag, mirred, defrag, push vlan, frag, mirred".
