Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B26186954
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgCPKp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:45:26 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:34311 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730478AbgCPKp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:45:26 -0400
Received: by mail-vk1-f193.google.com with SMTP id w67so4707767vkf.1
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 03:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=kgbi861lSDfgvA0Jv9kuIk8R6n+FSg3oBiHyjm9Try8=;
        b=zJYn2LRh9FeKxyeD4OkUeIseW5Rbsf48IABA16AGgQuzsUhAFzJaC+yfE2BlPxV35i
         ar6i1hJlbrjHzcDwUjKppJiC8ofv3tPZjn6z1+EFAhDrhXcm/N9RNPWbbDnaqXOmyuU+
         5XK2Ds8+TD92xISJcA1rXkhuQoyJ44IQyusfmnzjG72slwdD9uL8a3VQ6oigp7iKkRVC
         ftthtSJgE3mmcxucY6v38grdf1H7eQWWJZP2M4iGFECN4ar3iar/0qE82Ubolg28C2oz
         6bcJD6vAopGCx/xn3IUbobRDewFOAlgXN0ELmbP+qaAqAJAQVCO2dEQAO8IL2IzyhgIV
         2cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=kgbi861lSDfgvA0Jv9kuIk8R6n+FSg3oBiHyjm9Try8=;
        b=cWuR9QVczu4L/ddVklIfxYCy3i92N87Sjan2PTE8SwvrDH1/yq/mCkTi38yiEm3ULx
         3H04HF2iDFLjqseIAA8FMQyW76k/zhBrnSeGSGS+V3E8CE3K0u9a7zOcO0VpPlKyCLjO
         TKCNT0LdlEfUywaVGVQhc2NRip6xUxHddCXCkWOEpeRPYNui48c5OxCovMzjC55xLPwN
         IUlzTKPTOQGTPXbXrpBcq0S2dzkephpEX4ycXMWfLXa758ATjtaETHHMOjNpqmkRi/iP
         CxpBsho29klFhEOgJc7DXrxqwSfhNoz0McsmvUPc9Ti1xWcgGFi1/MgAXhY/tl5HXk0X
         3vxA==
X-Gm-Message-State: ANhLgQ3qXw1lXy2PrD2p9sx5R98dAz/ZaFzBuQoXdSrygnAuaym1fVi5
        SlMfBSLVVnW+B0wrcdLj0ZJlwuwdMAWC58G0os8yvg==
X-Google-Smtp-Source: ADFU+vsFTJ171xqPQH+5cp5Ng/Nx0EP6BETw21Ydp3StuzpM32d43/UEx8M6hRdiOd5B0MML31cGZyjQQE5ScBdwuDM=
X-Received: by 2002:a1f:b2d6:: with SMTP id b205mr16438521vkf.80.1584355524269;
 Mon, 16 Mar 2020 03:45:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Mon, 16 Mar 2020 03:45:23
 -0700 (PDT)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <20200316113515.16f7e243@carbon>
References: <158410589474.499645.16292046086222118891.stgit@firesoul>
 <20200316.014927.1864775444299469362.davem@davemloft.net> <98fd3c0c-225b-d64c-a64f-ca497205d4ce@solarflare.com>
 <20200316113515.16f7e243@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 16 Mar 2020 13:45:23 +0300
Message-ID: <CAOJe8K2BC2ABk9SdUm5236iPk=f4BNMsHQxFPsQy+Wc8+QjTSg@mail.gmail.com>
Subject: Re: [PATCH net-next] sfc: fix XDP-redirect in this driver
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, mhabets@solarflare.com,
        cmclachlan@solarflare.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Mon, 16 Mar 2020 10:10:01 +0000
> Edward Cree <ecree@solarflare.com> wrote:
>
>> On 16/03/2020 08:49, David Miller wrote:
>> > Solarflare folks, please review.
>>
>> This looks like a correct implementation of what it purports to do, so
>> Acked-by: Edward Cree <ecree@solarflare.com>
>
> Thanks for the review!
>
>> It did take me some digging to understand _why_ it was needed though;
>>  Jesper, is there any documentation of the tailroom requirement?  It
>>  doesn't seem to be mentioned anywhere I could find.
>
> I admit that is is poorly documented.  It is a requirement as both
> cpumap and veth have a dependency when they process the redirected
> packet.  We/I also need to update the doc on one page per packet
> requirement, as it is (in-practice) no longer true.

Hi Jesper,

that means that's on-going work to add multi-buffer/page support to XDP, right?

Thanks!
>
> I'm noticing these bugs, because I'm working on a patchset that add
> tailroom extend, and also reserves this 'skb_shared_info' tailroom area.
> The real goal is to later add XDP multi-buffer support, using this
> 'skb_shared_info' tailroom area, as desc here[2]
>
> [2]
> https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
>
>> (Is there even any up-to-date doc of the XDP driver interface?  The
>>  one at [1] looks a bit stale...)
>> -Ed
>>
>> [1]:
>> https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/design/requirements.html
>
> This is my old and out-dated documentation. I didn't know people were
> still referring to this.  I does score quite high on Google, so I
> guess, that I really need to update this documentation.  (It was my
> plan that this would be merged into kernel tree, but I can see it have
> been bit-rotting for too long).
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
