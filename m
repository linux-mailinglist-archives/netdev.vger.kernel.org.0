Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7695733225F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhCIJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhCIJyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 04:54:02 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107B5C06174A;
        Tue,  9 Mar 2021 01:54:02 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p21so8413843pgl.12;
        Tue, 09 Mar 2021 01:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F8WddIIudwuJ61pKa+W6PjZ144FyjkUIPXeQD/ma1qE=;
        b=CVVcHI+fJnpAH1S/RCqbtBrgX3/XJnpBTRnwG4hOHCLelbU8TWSxzQjW/gx7ocYyyI
         TUaoNq4VZzeMIkaJchXyBKY0kEcwobsfPLZKjc4V2pNWr81fF5J0qrp9P3ZSVdTq33em
         Pnn/QrLEevm1sodLUM+FQeyfAam55uJEFwRHAdIGePqCYjmw6/JuHXA26eymVoYRZaPf
         gb0kveaIq4/gO54jTM48ZHZbZea3/xviTI8SzM3b6nDioutFcgpHP2lxp+weN7mfiHs2
         jZUUIoY4VkR3T9ZfHIRIbfjuCDWjHZOdUaV+zeTF4ok1XEtL1e6VwyQf6QVo9qMKQE9V
         gNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F8WddIIudwuJ61pKa+W6PjZ144FyjkUIPXeQD/ma1qE=;
        b=s87ppxNkBwNgjWCEtpA78W4k+8Iao1LJv5QeA4OkZ1zJk023/mc9AKfkjABQGu6NWU
         slVWUToWAz8e7etyes+iNI4kOfXryTa82einWCpbXM9vNjG1afd2BjcB+aqB/fO1AZdG
         eYXnJ1K1G66o3kM1zTDi6UWbITLwxbA2IgQF7+v5lkbL3p4JtBlgfMwYrRo1vmH014NC
         2DHNhol3M1ltz0sgAfwj1s3jYCqnaK6nk+oNhTqCBTzoRI3p1bZOK8+tTvLtngiumd2P
         QUZqEVnYtfLUqQ56JsM5j2eipl8Ieewa0yJZFV/zrpGux9UsTXwsq68NyjX0RsQUVi5p
         RT+A==
X-Gm-Message-State: AOAM533ASNd2PoXblImLVOYU72LYEE+A1VlQ4g2gUlaLd2R4JeVl/RKe
        bywg7HO88vzlb+gviLhUGcQ=
X-Google-Smtp-Source: ABdhPJy7KFEkjn45gBVKdgPTFz2yDq6DuP8b6pajrTO6hEQx7IaayM4aW74x622TxDYTIXEaFsWoqQ==
X-Received: by 2002:aa7:9418:0:b029:1f7:de99:9a29 with SMTP id x24-20020aa794180000b02901f7de999a29mr6518273pfo.69.1615283641666;
        Tue, 09 Mar 2021 01:54:01 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 134sm12941763pfc.113.2021.03.09.01.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 01:54:01 -0800 (PST)
Date:   Tue, 9 Mar 2021 17:53:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel test robot <lkp@intel.com>, bpf@vger.kernel.org,
        kbuild-all@01.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast
 support
Message-ID: <20210309095349.GX2900@Leo-laptop-t470s>
References: <20210309072948.2127710-3-liuhangbin@gmail.com>
 <202103091607.YXhmDMeL-lkp@intel.com>
 <20210309085530.GW2900@Leo-laptop-t470s>
 <5dfb1386-3369-47b6-7c07-08bd44d02e47@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dfb1386-3369-47b6-7c07-08bd44d02e47@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 10:09:41AM +0100, Daniel Borkmann wrote:
> On 3/9/21 9:55 AM, Hangbin Liu wrote:
> > On Tue, Mar 09, 2021 at 04:22:44PM +0800, kernel test robot wrote:
> > > Hi Hangbin,
> > > 
> > > Thank you for the patch! Yet something to improve:
> > 
> > Thanks, I forgot to modify it when rename the flag name.
> 
> Sigh, so this was not even compiled prior to submission ... ? :-(

I usually do compile the code before submission. Some times I may skip
it if only need a small fix..

I compiled the code before rename the flags. After renaming the header file,
I was interrupted by some other works and forgot to go on...

I will fix it and re-submit.

Hangbin
