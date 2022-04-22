Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6867150C0C3
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 22:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiDVUoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 16:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiDVUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 16:43:59 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF77B16C22E;
        Fri, 22 Apr 2022 12:41:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p12so10460805lfs.5;
        Fri, 22 Apr 2022 12:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=lJJBFt56R7/LV6qOU2z7Q3rUmY3lVFuPnYXDX2dxxhQ=;
        b=QD7uEPIwb+9FYvU/VPSEAmhebgEE43naJCLEPrC5G9+77tcWuN+k0klIL6fPlgTCRr
         BnabyalhFNdtvUbr00s3UyHI44vteLSunmOZkZx146Z1ZD+XT/Cm/L6wYNVkacTB013W
         pt6HuM+gnUyaNx3BJGqeFiGh5jQv7bhyBhtrHwGWf1TLOJdmZyY5cSZrYKnYhRon6AH3
         MAebJ/mXFjLTm9lMs2oJkzNrregUaTpCqL+IISV8vHuehHeyF0zekxXeIYaDtV6pAbbx
         g3IGVnzSNTzuxqzj9DWAY5TjrX+gG9XN+f6eL6qNS+Ucly1AupD/MnHhEPbxgeNtmbt1
         Dj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=lJJBFt56R7/LV6qOU2z7Q3rUmY3lVFuPnYXDX2dxxhQ=;
        b=jrcDH70VlkK8Y01A0DRLbZXs1b38jO75zqzKqCTDPW6QKPmG+plmAITe8g+Gb4nexj
         QqxSgG2SKpeETppGjHC3mAzpPCTnfRHnEDiWyXpa78FvfMkjpXA36uXX8bhbT4KXtK1l
         q9K1RozJFdH/eTX+3j7aVXZfmqTyxkzrQl4CDXs4FpWWa7UvJw5H9JvzUANwiZMXni9O
         YzBFBnfaPZMg4/NzWNYBcECIritvJTUEDmXqGf/KwifuvL0Wjerirt8Ck/pCbzOGMtPu
         rYI40TbGPbimgoeo8VAp5dYpfyTG5o3i5RhWjfmDsbmMHj/bVtjMwBTv7WT5fK4VRKKr
         83pg==
X-Gm-Message-State: AOAM533B0AkZSpj/2St/db3lhtZo0W8Xd/SyCfK7p4jaeMBUxBQkXrHp
        YwrBqH/iG92C0YYidPvyffaeDRSi/VF9qAzZPnyJVAez6D8=
X-Google-Smtp-Source: ABdhPJwYdNw2jakv/CMKEnZj7tXyx7+mTqjFSQxLupjlpj+XaZSYkRknmFR+h7RjxdRd471uPqB/HqDXvqrT7Jke0VQ=
X-Received: by 2002:a2e:878d:0:b0:24e:f3cb:ad74 with SMTP id
 n13-20020a2e878d000000b0024ef3cbad74mr2751548lji.357.1650655541301; Fri, 22
 Apr 2022 12:25:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab2:6308:0:b0:138:fd0a:136c with HTTP; Fri, 22 Apr 2022
 12:25:40 -0700 (PDT)
In-Reply-To: <CAMhUBjkWcg4+YYynsd90jX1A+zp95tUUcLgYrTPAqSmbxM7TJA@mail.gmail.com>
References: <20220409062449.3752252-1-zheyuma97@gmail.com> <CA++WF2Np7Bk_qT68Uc3mrC38mN5p3fm9eVT7VA8NoX6=es2r2w@mail.gmail.com>
 <CAMhUBjkWcg4+YYynsd90jX1A+zp95tUUcLgYrTPAqSmbxM7TJA@mail.gmail.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Fri, 22 Apr 2022 22:25:40 +0300
Message-ID: <CA++WF2MFwtKs8-uy+e_77P0ySsN8y6W_8+Z8AdxBKsutcYK-ig@mail.gmail.com>
Subject: Re: [PATCH] wireless: ipw2x00: Refine the error handling of ipw2100_pci_init_one()
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     kvalo@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zheyu,

On 18/04/2022, Zheyu Ma <zheyuma97@gmail.com> wrote:
> On Thu, Apr 14, 2022 at 2:40 AM Stanislav Yakovlev
> <stas.yakovlev@gmail.com> wrote:
>>
>> On Sat, 9 Apr 2022 at 02:25, Zheyu Ma <zheyuma97@gmail.com> wrote:
>> >
>> > The driver should release resources in reverse order, i.e., the
>> > resources requested first should be released last, and the driver
>> > should adjust the order of error handling code by this rule.
>> >
>> > Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
>> > ---
>> >  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 34 +++++++++-----------
>> >  1 file changed, 16 insertions(+), 18 deletions(-)
>> >
>> [Skipped]
>>
>> > @@ -6306,9 +6303,13 @@ static int ipw2100_pci_init_one(struct pci_dev
>> > *pci_dev,
>> >  out:
>> >         return err;
>> >
>> > -      fail_unlock:
>> > +fail_unlock:
>> >         mutex_unlock(&priv->action_mutex);
>> > -      fail:
>> > +fail:
>> > +       pci_release_regions(pci_dev);
>> > +fail_disable:
>> > +       pci_disable_device(pci_dev);
>> We can't move these functions before the following block.
>>
>> > +fail_dev:
>> >         if (dev) {
>> >                 if (registered >= 2)
>> >                         unregister_netdev(dev);
>> This block continues with a function call to ipw2100_hw_stop_adapter
>> which assumes that device is still accessible via pci bus.
>
> Thanks for your reminder, but the existing error handling does need to
> be revised, I got the following warning when the probing fails at
> pci_resource_flags():
>
> [   20.712160] WARNING: CPU: 1 PID: 462 at lib/iomap.c:44
> pci_iounmap+0x40/0x50
> [   20.716583] RIP: 0010:pci_iounmap+0x40/0x50
> [   20.726342]  <TASK>
> [   20.726550]  ipw2100_pci_init_one+0x101/0x1ee0 [ipw2100]
>
> Since I am not familiar with the ipw2100, could someone give me some
> advice to fix this.

Could you please rebuild the kernel with IPW2100_DEBUG config option
enabled, rerun the test and post your results here? Also, please post
the output of "lspci -v" here.

Stanislav.
