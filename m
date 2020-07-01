Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D653211203
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbgGAReA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbgGAReA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 13:34:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF41BC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 10:33:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so25929381iof.6
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 10:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/DkySfqviSpFvHuK+YsiVlI961Sgb+W2NMsoO1nNRs=;
        b=bnFmI2NT2P881LSvp3htUwpdDQR4y5sVwkhPk90SIK1F2XwRl+/XfXXtTQl0G/BERG
         Ss/RuPE6seC9XBlFsZm6LSaBUWdJHCDIqha13WuVU3WHeFo5OW9egpGa+TPVbv2WE7fM
         k9Sq1SZPtOcc9yXGYwSdLzmSvEQiAVhr38KmxYoBzANknBOouL45p8+ePkuFBTTT1uvr
         GTNrWxxlDYt6jMQIxCfEK5Dg1yncdsIk0kQjdGn7ETMQCYRqYPDxcnAzMS2IX73hXbdE
         JlpcHd5gZndgpXBT0BlpO6nAc9ODrc2pvsjbDCHY53Fg54JvrPmE5S9vb07OEWSxNXbG
         V4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/DkySfqviSpFvHuK+YsiVlI961Sgb+W2NMsoO1nNRs=;
        b=qFaKC6BpuXcahhrxe8sYfBrFx6uHrjYAs/BOMVwmWdKN6cQ9PCfQiA2UZpPPomuXuz
         2MXPbUdg4xCHq4zywmNveGcJxGZAOVDuV8RFIswM/PhfBAcc+xI3gH/tJiSyirjF8oxe
         yfs65UrPy+zroG0WO31D9FHn4lG352lWOkf+/A/IF3TElz0h/BrH/I7uovuXP/O4/uqn
         S4GdBr9KCyZYfXDDE0vRGeqe4pZR8n+cLrImdBjrI7W5SHBwenD010pmOu9+IuyryfU/
         fzMxRlAv3HNCqbLJDKuBSg8ML8h8ecgkF/erCJHx89+f3ADCAqALAro9lm5scQXB7WcJ
         p3mg==
X-Gm-Message-State: AOAM530jzRhtdxVWf8IV4Ajwe7osLnIXJSBCKNkVxV96TjfzqsC1NrIK
        ULDeqZIweRiGpWU8uaUKuW2v91c+PThNDe0ZTpiqpPj4
X-Google-Smtp-Source: ABdhPJzwumAEbnS7lflnmV+25F7kvFRyyUa0E3hpGvUNojlHMxl8F8Z5xhOd6CVHCoi5LwGoMVQ4fAcGShib+/e/SN4=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr3227630iol.85.1593624838992;
 Wed, 01 Jul 2020 10:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn> <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn> <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn> <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
In-Reply-To: <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 1 Jul 2020 10:33:46 -0700
Message-ID: <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
>
>
> On 7/1/2020 2:21 PM, wenxu wrote:
> > On 7/1/2020 2:12 PM, Cong Wang wrote:
> >> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
> >>> Only forward packet case need do fragment again and there is no need do defrag explicit.
> >> Same question: why act_mirred? You have to explain why act_mirred
> >> has the responsibility to do this job.
> > The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
> >
> > the act_mirred can decides whether do the fragment or not.
>
> Hi cong,
>
>
> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
>
> Did you have some other suggestion to solve this problem?

Like I said, why not introduce a new action to handle fragment/defragment?

With that, you can still pipe it to act_ct and act_mirred to achieve
the same goal.

act_mirred has the context to handle it does not mean it has to handle it.
Its name already tells you it only handles mirror or redirection, and
fragmentation is a layer 3 thing, it does not fit well in layer 2 here. This
is why you should think carefully about what is the best place to handle
it, _possibly_ it should not be in TC at all.

Thanks.
