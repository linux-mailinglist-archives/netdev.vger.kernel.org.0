Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445974823EB
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 13:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhLaMOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 07:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhLaMOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 07:14:21 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863F4C061574;
        Fri, 31 Dec 2021 04:14:21 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id co15so23280099pjb.2;
        Fri, 31 Dec 2021 04:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s4ZIgRJxA/bJpK9EGNpz1Frs6UgnAptCBgM4W8Ra484=;
        b=QzWESQ6syjOkTbO9iMpSAzXF2zK6Dng8Gp7fLynIjU7Mj+W2iPVrZDumnxmamx1YzW
         TPIl7XCvUmjXUnfE3QLPTCJh1j8zh4OaATJ902E1Nppf8GBY8e+IhHuYlb6QpT1GAHNk
         hk6SgrVVt1nsgibikT0Fe3oSTjJBJannf8EBpw5OjY1gFpE5IGtuQmR/nW8Tj/A5D+lI
         lOSQkBf9zxe4/yjYiY+TjpdInKRj7woJV2UJLH5jk2CjVVa3HEoC3XTov+J5dnByqz7/
         2F8pE7yGsHgBuoF/wXgwnlYK/qH0eStOSViYivce+1Hzs2ksANXZz1O+VON+yW8lKPpM
         rbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s4ZIgRJxA/bJpK9EGNpz1Frs6UgnAptCBgM4W8Ra484=;
        b=TyTx5D6xWRyAb7I9IWYocwAZZYIpi5yYjHQMYAJXfTVvW6sf1DaYJEJC72RMlXP2Rz
         EaEB8cAU0UO75XAvB5fnzDsdSwZTHD8x1T9UXU6GpzQnPAGW3D5tm5w6yUueVtMjrih7
         SWmpYLaitopq8/gD/xyHXsXO4DltnxDRw5o9mVv6aGkZZszj5ibspxn9H85AW9biNkbZ
         YqJGw54buH6ZbhyoLM7Gy7DA+u4BW4GmjK8SHfzg6uHDwobpHsf8wsJ7aAjfHT+NUYG2
         ZyOplWu4oZg/w3HmhiO0YjezGOaRxqqbI0O6CE3dmzRQJWCJ5btmJ6odBS1CSKzvxfSk
         wbMg==
X-Gm-Message-State: AOAM533HvUD6FZNon0iSJ9CaREsoPB0vK5uyzwsy+7V5yYMwpWqNbUs/
        4PdS7tRC+LhnaaSsrpW05mdhjtpNsM9vz6YA5Tc=
X-Google-Smtp-Source: ABdhPJz66ZSi21NgcqNFU9hPth58xFztXy4cZk5KcxZRUT1egh/2Xxd38wiHDKKHAlWk+WJ1xoyq+g==
X-Received: by 2002:a17:902:7294:b0:149:64f4:bdba with SMTP id d20-20020a170902729400b0014964f4bdbamr30801058pll.48.1640952860999;
        Fri, 31 Dec 2021 04:14:20 -0800 (PST)
Received: from [192.168.0.105] ([45.116.106.186])
        by smtp.gmail.com with ESMTPSA id rm3sm25280515pjb.8.2021.12.31.04.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 04:14:20 -0800 (PST)
Message-ID: <65c90674808fc0a93c7d329067bf3e80736a003a.camel@gmail.com>
Subject: Re: [PATCH] mctp: Remove only static neighbour on RTM_DELNEIGH
From:   Gagan Kumar <gagan1kumar.cs@gmail.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     matt@codeconstruct.com.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 Dec 2021 17:44:15 +0530
In-Reply-To: <e20e47833649b5141fa327aa8113e34d4b1bbe15.camel@codeconstruct.com.au>
References: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
         <20211230175112.7daeb74e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <e20e47833649b5141fa327aa8113e34d4b1bbe15.camel@codeconstruct.com.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy and Jakub,

Thanks for the response.

On Fri, 2021-12-31 at 11:33 +0800, Jeremy Kerr wrote:

> Hi Jakub & Gagan,
> 
> > > Add neighbour source flag in mctp_neigh_remove(...) to allow
> > > removal of only static neighbours.
> > 
> > Which are the only ones that exist today right?
> 
> That's correct. There may be a future facility for the kernel to
> perform
> neighbour discovery itself (somewhat analogous to ARP), but only the
> static entries are possible at the moment.
> 
> > Can you clarify the motivation and practical impact of the change 
> > in the commit message to make it clear? AFAICT this is a no-op / prep
> > for some later changes, right Jeremy?
> 
> Yes, it'll be a no-op now; I'm not aware of any changes coming that
> require parameterisation of the neighbour type yet.
> 
> Gagan - can you provide any context on this change?

I was exploring the repository and wanted to get familiar with the
patching process. During that, I was looking for some TODOs in /net for
my first patch and came across mctp.

I thought `TODO: add a "source" flag so netlink can only delete static
neighbours?` might be of some use in the future. So, thought of sending
a patch for the same.

If I were to think like a critic, "You aren't gonna need it" principle
can be applied here.

If you think it's ok to proceed I can update the commit message to
include the motivation and impact as a no-op.

> 
> Cheers,
> 
> 
> Jeremy

Thanks,
Gagan


