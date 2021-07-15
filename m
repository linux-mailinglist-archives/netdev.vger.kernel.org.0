Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50BA3C9602
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 04:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhGOChM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 22:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhGOChL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 22:37:11 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE76C06175F;
        Wed, 14 Jul 2021 19:34:19 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o72-20020a9d224e0000b02904bb9756274cso4633350ota.6;
        Wed, 14 Jul 2021 19:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7hIjlSBVcaNYjNod+L81MaSkTH8TYHb/gTtAOF6jJo=;
        b=ZBsljYwRuvhrbEDuxSsBZPJHvWQRDU790+yd9diu9bhjvcbrjCs11eAzPFwb8sAFc1
         l3Tlzy6JZAHHvgx9yXMydp6838LmXocEvHEV+tVtZFTF10JLyqZcXT8GZa3ci0N1nGsA
         VJjQQFP+wIHf+C0M0xRXWe3WlJrTqafl4+iXBvcnRaQRaLsE10asUcqe90hWO0RDmPp6
         vahPIDk0H6y6LWPi9BBc/kciHPuLaDHfZvPzODOztVU+n8fAvl7yTSy+pXnhOEAbh0No
         ki6O7XMSL/FcqL0XiU416e9EGI/CRLa33iqZdMGlY79zHHIDLFQHLd7Q5/fVyU20mpso
         7bXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7hIjlSBVcaNYjNod+L81MaSkTH8TYHb/gTtAOF6jJo=;
        b=PSX4U6NofSb/Lw92g01Y4+Cemc3qhM0hVfyNjQ0lDakXMZec4rosAGmQc82OG0YCgi
         LdST87KnSoL1GwpteWIijHMpUp9XXn+k0JQfWaolhtz9vCyU96MClwPbYXosEFxXmtNH
         9vWGj18Mc31+cK/b+vGPrClpSRbCzK9JD3S4qsTCYzpm6Iq3Spp2Fcrn2bYAKywnyuuA
         oj6k9Pr5RfCQwqeo63Kq+Xqqx/omNCaV4LgVFCrHlYpquKnupKtsGMsvc3VSlBXPM4lk
         KYPvhjZf1p81QmPQ+f8hxvBqKQrC0KpoQj7ORJJJIokFEcuj1TlQej6GmSsZR6A5Fyyr
         U0Cw==
X-Gm-Message-State: AOAM530Wx3kUgEcPuF+21uAe8OiDrb+ew4NqqrVxvxtzmWFRlH+FEBq0
        BVBnWCjvMA6izxZe8qikY5pGrrsvau20OQP9m44=
X-Google-Smtp-Source: ABdhPJwQ4c8bBGOr9cTjRZ00J0YonoK1W5QubqFUgsmrA/tzA8zeo3mQv8ePNTcI9kGkhFWfkFkZXmAhnKuBTBaJMHQ=
X-Received: by 2002:a9d:4c9a:: with SMTP id m26mr1217555otf.110.1626316458173;
 Wed, 14 Jul 2021 19:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210707094133.24597-1-kerneljasonxing@gmail.com>
 <CAL+tcoCc+r96Bv8aDXTwY5h_OYTz8sHxdpPW7OuNfdDz+ssYYg@mail.gmail.com> <03b846e9906d27ef7a6e84196a0840fdd54ca13d.camel@intel.com>
In-Reply-To: <03b846e9906d27ef7a6e84196a0840fdd54ca13d.camel@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 15 Jul 2021 10:33:42 +0800
Message-ID: <CAL+tcoAtFTmFtKR2QLY_UdQWkc9Avyw3ZtaA_cD_4cXAGXRBDQ@mail.gmail.com>
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

On Thu, Jul 15, 2021 at 4:52 AM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Fri, 2021-07-09 at 15:13 +0800, Jason Xing wrote:
> > Oh, one more thing I missed in the last email is that all the
> > failures
> > are happening on the combination of X722 10GbE and 1GbE. So the value
> > of @num_tx_qp  the driver fetches is 384 while the value is 768
> > without x722 1GbE.
> >
> > I get that information back here:
> > $ lspci | grep -i ether
> > 5a:00.0 Ethernet controller: Intel Corporation Ethernet Connection
> > X722 for 10GbE SFP+ (rev 09)
> > 5a:00.1 Ethernet controller: Intel Corporation Ethernet Connection
> > X722 for 10GbE SFP+ (rev 09)
> > 5a:00.2 Ethernet controller: Intel Corporation Ethernet Connection
> > X722 for 1GbE (rev 09)
> > 5a:00.3 Ethernet controller: Intel Corporation Ethernet Connection
> > X722 for 1GbE (rev 09)
> >
> > I know it's really stupid to control the number of online cpus, but
> > finding a good way only to limit the @alloc_queue_pairs is not easy
> > to
> > go. So could someone point out a better way to fix this issue and
> > take
> > care of some relatively old nics with the number of cpus increasing?
>
> Hi Jason,
>
> Sorry for the slow response; I was trying to talk to the i40e team
> about this.

Thanks for your kind help really. It indeed has a big impact on thousands
of machines.

>
> I agree, the limiting of number of online CPUs doesn't seem like a
> solution we want to pursue. The team is working on a patch that deals

As I said above, if the machine is equipped with only 10GbE nic, the maximum
online cpus would be 256 and so on. For now, it depends on the num of cpus.

> with the same, or similiar, issue; it is reworking the allocations of
> the queue pile. I'll make sure that they add you on the patch when it

It's not easy to cover all kinds of cases. But I still believe it's
the only proper
way to fix the issue. Looking forward to your patch :)

> is sent so that you can try this and see if it resolves your issue.
>

Yeah, sure, I will double-check and then see if it's really fixed.

Thanks,
Jason

> Thanks,
> Tony
>
