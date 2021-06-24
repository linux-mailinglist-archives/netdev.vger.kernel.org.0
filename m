Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727923B2E30
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFXLwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhFXLwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:52:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D75C061574;
        Thu, 24 Jun 2021 04:50:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so3324320pjn.1;
        Thu, 24 Jun 2021 04:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NBhOpdFrFXN612ppL4gJ9nkWeOTOGB0kA5VL7u3oI0=;
        b=poPjKalCBQbjajhtmSRxl4/nxS8RFLQFavYUQuNpzfQby3SCFgcBVtspZVCRxUFRWm
         EW7x/UsNudzFXvhAFMXzdVhfCDKO7GvKHLjD9r4Wh4T4Ro0+/c8ngHl0uzKqybfLdgXW
         GJroG6k4oPOaClgQP+K6zo/FN0X32tv8IxqZuW1FCAWrCTEztTfRkUNZdF2nWlx4OeiR
         o7twtfpKzgqS3itVETbnV8BpuO5S9ZKyMyd2qgJiV4n7eBPWJOp7O+s14EC0auBnWF5k
         A4qtW4UefVkXq/cLv295UDphoDtgZL612pxhuJsYEWaryHJdu6x1cyb16kEoRU7eh9Xx
         Y94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NBhOpdFrFXN612ppL4gJ9nkWeOTOGB0kA5VL7u3oI0=;
        b=ManJi1dhEwgcF1OHuLr9K52Yy9HvXcseK8FA/K7E3qe+WtzURFCHMyPad4YBbDRbLQ
         TpcziqzvOTPMRe8Wak0oLPCK6dgwsYbPGIDIZPhtR4CTz/g3Ul/qn450o8nlG/uRFNZe
         LbUuGSLVbV+NkMb2mleBc9OE3SrYy5AhC2pgUz0SnKKp2astShJ3I1BG77jwgy7MuKaO
         SyWD5B7xbW2H9tqVSP7YhedKxQplJ+rIyJMNUoK1k7Ped/x+Oq/8Ahus+n1OKGlG4MDn
         KhCipa9hFSjFG3aEZPzUEuVfNLjSYOCznxmQxqc7gUR5WmLc51pZbxotXkxLSQ66V0/q
         zG3Q==
X-Gm-Message-State: AOAM531qZZZF6t31lMw3hiNonfS7QUwLbAJV9qygT+BIrzNCkplUog0l
        P9qBT+T694UHHkYrfovYy+8=
X-Google-Smtp-Source: ABdhPJwPgS8I8F1fTQGFGwHpoDuOE97EeXTfhOLfTiMi1HfyWVc/nTAfT2T7hVJ2hTriMsxou8L4PQ==
X-Received: by 2002:a17:90b:148f:: with SMTP id js15mr4960088pjb.182.1624535435076;
        Thu, 24 Jun 2021 04:50:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm2278206pgw.67.2021.06.24.04.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:50:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 24 Jun 2021 19:47:05 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/19] staging: qlge: fix incorrect truesize accounting
Message-ID: <20210624114705.ehmzmysl3vdylg3x@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-2-coiby.xu@gmail.com>
 <20210621141027.GJ1861@kadam>
 <20210622113649.vm2hfh2veqr4dq6y@Rk>
 <YNK+s9Rm7OtL++YM@d3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YNK+s9Rm7OtL++YM@d3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 01:55:15PM +0900, Benjamin Poirier wrote:
>On 2021-06-22 19:36 +0800, Coiby Xu wrote:
>> On Mon, Jun 21, 2021 at 05:10:27PM +0300, Dan Carpenter wrote:
>> > On Mon, Jun 21, 2021 at 09:48:44PM +0800, Coiby Xu wrote:
>> > > Commit 7c734359d3504c869132166d159c7f0649f0ab34 ("qlge: Size RX buffers
>> > > based on MTU") introduced page_chunk structure. We should add
>> > > qdev->lbq_buf_size to skb->truesize after __skb_fill_page_desc.
>> > >
>> >
>> > Add a Fixes tag.
>>
>> I will fix it in next version, thanks!
>>
>> >
>> > The runtime impact of this is just that ethtool will report things
>> > incorrectly, right?  It's not 100% from the commit message.  Could you
>> > please edit the commit message so that an ignoramous like myself can
>> > understand it?
>
>truesize is used in socket memory accounting, the stuff behind sysctl
>net.core.rmem_max, SO_RCVBUF, ss -m, ...
>
>Some helpful chap wrote a page about it a while ago:
>http://vger.kernel.org/~davem/skb_sk.html

Thanks for the explanation and the reference!

>
>>
>> I'm not sure how it would affect ethtool. But according to "git log
>> --grep=truesize", it affects coalescing SKBs. Btw, I fixed the issue
>> according to the definition of truesize which according to Linux Kernel
>> Network by Rami Rosen, it's defined as follows,
>> > The total memory allocated for the SKB (including the SKB structure
>> > itself and the size of the allocated data block).
>>
>> I'll edit the commit message to include it, thanks!
>>
>> >
>> > Why is this an RFC instead of just a normal patch which we can apply?
>>
>> After doing the tests mentioned in the cover letter, I found Red Hat's
>> network QE team has quite a rigorous test suite. But I needed to return the
>> machine before having the time to learn about the test suite and run it by
>> myself. So I mark it as an RFC before I borrow the machine again to run the
>> test suite.
>
>Interesting. Is this test suite based on a public project?

The test suite is written for Beaker [1] but it seems it's not public.

[1] https://fedoraproject.org/wiki/QA/Beaker

-- 
Best regards,
Coiby
