Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3193D5157
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhGZCB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhGZCB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 22:01:57 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18755C061757;
        Sun, 25 Jul 2021 19:42:27 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id o185so9276190oih.13;
        Sun, 25 Jul 2021 19:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztv+vaeNFDWFSj27feVlmDxlPGi8rjcvHx09kepNWQs=;
        b=WX1kg+xop5RCpBXFHd/MVWMNkNc+JntZGtx7xxx3BuRz+d/ZonJmvNi9ee9zyoNTbh
         5B0KmFuoTXUs8bEptPWWgX1XV+YQJKj3MSAzmC4blje54QNe5jekUzFCXiCg9eG3vLpP
         5VzoOnhTQva9WZsM2qbi5NBmAF/zBUcT35aT+aBuaxbLy0cPzFTH0JMJhSto2UtrU/Kf
         YHy2jowYkjnTfU00IfyiB/0X2t/D1cbrh3ym/bLs0YUpTHZgh9puiyGW6SwpA2sDMFhG
         FS1mUyY7l9bMBSB9Br+ssqoE4G++o3TxOV7eUqN2/gPStPAg42tr3oHmPkM/MpK0TzLl
         sOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztv+vaeNFDWFSj27feVlmDxlPGi8rjcvHx09kepNWQs=;
        b=hcyRf5AqZGWgLT6oRyg+Q1RttJe6M8KE2UJYrl+/HKOpDqw22IjHWgCZ8QV4yYmQlC
         jEbdPxSA8nbfKCsIgOO3yG2vr+aSm8zjYRieeq8kjF7uKyCpAEnJB2EluOEqem1OYlb4
         0jy+cbUesmrxKULKIdhllaBCX73EHCmI0w8LCihhyR3+xbt0onURDxazXTrCYPXw2SiC
         n1Ava0bLq8pwkvQczssF4tmtMbnDV5AzpWbKDNmfF8FS1ovcpgjWe6hwAZC6hzDjT+M5
         suivUVv/YaOVMUOIIqzaRNF/ugtDEmNrO/yGwbgNzNVkukHHc5Fefmja4WqOeUc8VYCb
         yX5g==
X-Gm-Message-State: AOAM532InHZJu/FAG7z04VW3DTMV3dDBd2oP0pEkwmP5z1QjWCcmFguu
        DqZyB00RrfdH0h4uOrlNpeJbUByJ+Y1FqARkpmQ=
X-Google-Smtp-Source: ABdhPJx3Uz5w/BUgxXpHkxpDqtXzcSycOHCp0aEZKLiuQYVgvi8noh6Sprs5LzJYrgAJAlHZsku6YdvzSBwZZul3yRE=
X-Received: by 2002:aca:da02:: with SMTP id r2mr9376423oig.141.1627267346487;
 Sun, 25 Jul 2021 19:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210707094133.24597-1-kerneljasonxing@gmail.com>
 <CAL+tcoCc+r96Bv8aDXTwY5h_OYTz8sHxdpPW7OuNfdDz+ssYYg@mail.gmail.com>
 <03b846e9906d27ef7a6e84196a0840fdd54ca13d.camel@intel.com> <CAL+tcoAtFTmFtKR2QLY_UdQWkc9Avyw3ZtaA_cD_4cXAGXRBDQ@mail.gmail.com>
In-Reply-To: <CAL+tcoAtFTmFtKR2QLY_UdQWkc9Avyw3ZtaA_cD_4cXAGXRBDQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 26 Jul 2021 10:41:50 +0800
Message-ID: <CAL+tcoBk=s_QZv08wetLG8jeUCX-ECddOWeOgeLnPB_X41juvw@mail.gmail.com>
Subject: Re: [PATCH net] i40e: introduce pseudo number of cpus for compatibility
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "hawk@kernel.org" <hawk@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "xingwanli@kuaishou.com" <xingwanli@kuaishou.com>,
        "lishujin@kuaishou.com" <lishujin@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anthony L,

Do you have any progress or any idea on the final patch? Or you could
point out some more detailed method to rework the calculation of the
queue pile.

I think it's critical and has an impact on all the old nics, which
means thousands of machines would crash if xdp-drv program is loaded.

Thanks,
Jason

On Thu, Jul 15, 2021 at 10:33 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Thu, Jul 15, 2021 at 4:52 AM Nguyen, Anthony L
> <anthony.l.nguyen@intel.com> wrote:
> >
> > On Fri, 2021-07-09 at 15:13 +0800, Jason Xing wrote:
> > > Oh, one more thing I missed in the last email is that all the
> > > failures
> > > are happening on the combination of X722 10GbE and 1GbE. So the value
> > > of @num_tx_qp  the driver fetches is 384 while the value is 768
> > > without x722 1GbE.
> > >
> > > I get that information back here:
> > > $ lspci | grep -i ether
> > > 5a:00.0 Ethernet controller: Intel Corporation Ethernet Connection
> > > X722 for 10GbE SFP+ (rev 09)
> > > 5a:00.1 Ethernet controller: Intel Corporation Ethernet Connection
> > > X722 for 10GbE SFP+ (rev 09)
> > > 5a:00.2 Ethernet controller: Intel Corporation Ethernet Connection
> > > X722 for 1GbE (rev 09)
> > > 5a:00.3 Ethernet controller: Intel Corporation Ethernet Connection
> > > X722 for 1GbE (rev 09)
> > >
> > > I know it's really stupid to control the number of online cpus, but
> > > finding a good way only to limit the @alloc_queue_pairs is not easy
> > > to
> > > go. So could someone point out a better way to fix this issue and
> > > take
> > > care of some relatively old nics with the number of cpus increasing?
> >
> > Hi Jason,
> >
> > Sorry for the slow response; I was trying to talk to the i40e team
> > about this.
>
> Thanks for your kind help really. It indeed has a big impact on thousands
> of machines.
>
> >
> > I agree, the limiting of number of online CPUs doesn't seem like a
> > solution we want to pursue. The team is working on a patch that deals
>
> As I said above, if the machine is equipped with only 10GbE nic, the maximum
> online cpus would be 256 and so on. For now, it depends on the num of cpus.
>
> > with the same, or similiar, issue; it is reworking the allocations of
> > the queue pile. I'll make sure that they add you on the patch when it
>
> It's not easy to cover all kinds of cases. But I still believe it's
> the only proper
> way to fix the issue. Looking forward to your patch :)
>
> > is sent so that you can try this and see if it resolves your issue.
> >
>
> Yeah, sure, I will double-check and then see if it's really fixed.
>
> Thanks,
> Jason
>
> > Thanks,
> > Tony
> >
