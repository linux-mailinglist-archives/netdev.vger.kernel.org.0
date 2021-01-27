Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056333063AD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbhA0TCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344102AbhA0TCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:02:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15655C061756;
        Wed, 27 Jan 2021 11:02:03 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g1so3764004edu.4;
        Wed, 27 Jan 2021 11:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yaDcEekbrYEPokj0JRuFpunrJ0wSRd/M2Y1owft4C8o=;
        b=TLBHtxthK+H5w44/SV3d8y4ZsgtxLsbAHXYqH7W/fN7tVncWFUFYmebGjIkdD6GuhM
         VKRoQOwRg9tQ2Ot0AxXhn0yAW2zpOWPe+zrjYyeC+9KXIVp+a3ArdrkOJcAoNmD5YYxl
         aHzUxJpQiHMoKCxgwAccDwQ7zdldW4lkFBt9TCvIwnMNYPmFQKdZV76n74vdBFtHlZwI
         bWR8VI9DO9SqXJUsKTPXWedmVeIhOOY9Xn8DBvsb4A2psdm3SZOqhf5PDteYvx9kpD0v
         DUuCjzwHpfXuh0HUe1KiTXwkrR2w2QhKr5gQ16jLquJqZI5Ds4SjGxwRE2T8jAUsiOQF
         V0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yaDcEekbrYEPokj0JRuFpunrJ0wSRd/M2Y1owft4C8o=;
        b=JMLJZt6v3pBzUHw0sqoYTbw2mrxL1kiXPSFok6YL+apHAaBUW3z4IR1YxXkZOuwIUx
         9K4M5GBlcbL2c0FXDqe6r6Oj8kHCY10F4HXu8G+JaLXDk+F3R7n4DXULNYq0Nsr/Hk/J
         ESvvGO2WrwzufZSqsRLdSRzc6+qg8Klr4aRNDjodKqe1zzFZGDkopqBi9B58Q60bEaRU
         6CDo14n6A6OStVftU3W6qs43ES2qUN0kM3utl1XFCsoYH+ICwM3/hVab1GfgqId2nWcR
         TaGJtDQ05yOidBk5wEaZ+Q8lMXZAFcH1c95ASZQ064LOtVMWxWMuf0jjbot7i5rXw9rP
         p1Kw==
X-Gm-Message-State: AOAM531xjkIgjMhseD7I0/XlqY9yBOQUMKw4vqS4ydW6A+GbURig2D7f
        hx77jTXk+9J4gawUckhSKt7FnKD3EZc=
X-Google-Smtp-Source: ABdhPJyhA5Qh5kAbrOv6fEoykOOte3KIUvtjPCuBwdYn/biXtX66Vat4eYA6Xyk1goZ/uDe275Y2qQ==
X-Received: by 2002:aa7:c485:: with SMTP id m5mr10221896edq.320.1611774121843;
        Wed, 27 Jan 2021 11:02:01 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id w14sm1232367eji.85.2021.01.27.11.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 11:02:01 -0800 (PST)
Date:   Wed, 27 Jan 2021 21:01:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210127190159.s6irvdej3fs4cdai@skbuf>
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
 <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 02:06:32AM +0100, Lorenzo Carletti wrote:
> In the rtl8366rb driver there are some jam tables which contain
> undocumented values.
> While trying to understand what these tables actually do,
> I noticed a discrepancy in how one of those was treated.
> Most of them were plain u16 arrays, while the ethernet one was
> an u16 matrix.
> By looking at the vendor's droplets of source code these tables came from,
> I found out that they were all originally u16 matrixes.
> 
> This commit standardizes the jam tables, turning them all into
> jam_tbl_entry arrays. Each entry contains 2 u16 values.
> This change makes it easier to understand how the jam tables are used
> and also makes it possible for a single function to handle all of them,
> removing some duplicated code.
> 
> Signed-off-by: Lorenzo Carletti <lorenzo.carletti98@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Some trivia to read for next time:
Documentation/process/submitting-patches.rst
Documentation/networking/netdev-FAQ.rst

I'm saying this because you should have used git-format-patch with a
--subject-prefix of "PATCH v2 net-next" so that the tree onto which this
patch is to be applied would be clear. As things stand, the Patchwork
tests added by Jakub have marked your patch as "Target tree name not
specified in the subject":
https://patchwork.kernel.org/project/netdevbpf/patch/20210127010632.23790-2-lorenzo.carletti98@gmail.com/

Also, generally, when people give you a Reviewed-by tag in v1 but you
need to resend v2, you should copy those tags yourself below your
Signed-off-by in the new patch submission. Otherwise, if the patch is
going to be applied, the maintainer will pick up the review tags on the
latest posted version only. When you make significant modifications to
the patch and you're concerned that the reviewers might no longer agree
with the updated version they haven't yet seen, it's ok to drop
Reviewed-by tags. In this case, you dropped Linus's review tag.
