Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52A3B0302
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhFVLmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhFVLmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:42:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEA9C061574;
        Tue, 22 Jun 2021 04:40:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g4so11947888pjk.0;
        Tue, 22 Jun 2021 04:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HH/ge+eMrkI7gGPeXjozVQm3lW9YsdJEBaU1NSBzDEY=;
        b=T7rbUj7MqHJXFfLgrMO1X6JfbXHaQpgA/bvETfzOgfuGwg7HvZH9Ess43hMV9/IThr
         YgXK3kYoNcvYTkOe125V0VNx7VIZs4y2CoS0EXsd5Yr0FnT3TzEbJP1IkBQe+NHwfpnn
         vG+LJwjuKaykwGHBNlNkt9YEUpgZoSZGNLQgf2Avsw1Nt2wwjdYSIOOgJ2bn0xQvpP8f
         cWld3jjMc90Ix8DuRNLoR4sdLo8XXxur02mHIWI38nbWKsGXjUzuIK2JpiD7P2qOthRm
         QngzHmbeBuvKO46JBNZOmzX9yGh4lSXGImSH5L+v9KlhzdtEHJHJAeiQqxCsxuWgRzNW
         5bqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HH/ge+eMrkI7gGPeXjozVQm3lW9YsdJEBaU1NSBzDEY=;
        b=VCXxh7I/bg4SYulXISukODLng+/53fHYWxxWsQMZGuha40/XxqRsHr7pw+zLtoi5CH
         vLE5Zpgel22176Ax5sLXoWgNnUF7BCo06+f7sQ4ERMbQKa9vpJcvH7UAo1slO8/xGki8
         98Rc+g71/mSJRMuh+tZL5sjdHw84vbZhDFxfKI20PDGOJ5qcX5uiJFg0CRfJ6p2OU/Tk
         OhoSP40NXw1JdBSgLxg0EMCY5T+eC7okL5a1E11RV0oDh/LPTlj0NA2/FA5Xk+lQC5MG
         BXItl6CPEa5mt7gzRTJQTWGiyztHISdbTbN9AEvXdDErlAsUu/0tLm9UCxAV9nb6sZ/P
         lxUQ==
X-Gm-Message-State: AOAM5315JC8cY/t6TBw8O1+JgBsVjU6FbgfUPjKMxz8ujSp5/sF4JyM9
        DGsDdVH0XrgoUr3Hfkq6czY=
X-Google-Smtp-Source: ABdhPJwXO0UgLKcWBreB/hHKSLZgnt9eKVXVcy8zLXqeS7m6km9vHcCy07fVRg48ZLwMkWxu3MT8zQ==
X-Received: by 2002:a17:90a:66cc:: with SMTP id z12mr3633506pjl.93.1624362030077;
        Tue, 22 Jun 2021 04:40:30 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id b5sm16408990pgh.41.2021.06.22.04.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:40:29 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 22 Jun 2021 19:36:49 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/19] staging: qlge: fix incorrect truesize accounting
Message-ID: <20210622113649.vm2hfh2veqr4dq6y@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-2-coiby.xu@gmail.com>
 <20210621141027.GJ1861@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210621141027.GJ1861@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 05:10:27PM +0300, Dan Carpenter wrote:
>On Mon, Jun 21, 2021 at 09:48:44PM +0800, Coiby Xu wrote:
>> Commit 7c734359d3504c869132166d159c7f0649f0ab34 ("qlge: Size RX buffers
>> based on MTU") introduced page_chunk structure. We should add
>> qdev->lbq_buf_size to skb->truesize after __skb_fill_page_desc.
>>
>
>Add a Fixes tag.

I will fix it in next version, thanks!

>
>The runtime impact of this is just that ethtool will report things
>incorrectly, right?  It's not 100% from the commit message.  Could you
>please edit the commit message so that an ignoramous like myself can
>understand it?

I'm not sure how it would affect ethtool. But according to "git log
--grep=truesize", it affects coalescing SKBs. Btw, I fixed the issue
according to the definition of truesize which according to Linux Kernel
Network by Rami Rosen, it's defined as follows,
> The total memory allocated for the SKB (including the SKB structure itself 
> and the size of the allocated data block).

I'll edit the commit message to include it, thanks!

>
>Why is this an RFC instead of just a normal patch which we can apply?

After doing the tests mentioned in the cover letter, I found Red Hat's 
network QE team has quite a rigorous test suite. But I needed to return 
the machine before having the time to learn about the test suite and run 
it by myself. So I mark it as an RFC before I borrow the machine again to 
run the test suite.

>
>regards,
>dan carpenter
>

-- 
Best regards,
Coiby
