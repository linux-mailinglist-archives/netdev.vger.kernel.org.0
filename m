Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1D134005D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCRHoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhCRHnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:43:46 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D16C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 00:43:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso2748506wmi.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 00:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rkflrBl13OLl0FnUXx5RNj7pmM2ecbghJMJzEDew8fM=;
        b=TiuG5r/36BxTGMSLU9p232O87WcS5w1UMtOTfZVPj5t+MhfTND6FXYClxINKJV0VB9
         LbrDW46Rn0W/FIegtC1ZlOXYhP4o8LN0Av9i0UO5PXYeWi3AP1pSMW11VcK6f+RhvT8D
         wav8silR+3OrIF4FJllGYQOBQwLJIiDIG5oDOKaf7Y7aqCU2eZSKpdUiXsheZzFN1riG
         w7mhEwNJj1BMt8VoiFUpW/RUt6dwP5K2COYkPaq1asf0b+l4q50mHJGmu1Y/pcrEzbQn
         ITUoEl7LY9UlCdDWt4nYqgimw57tt7ldfu90icdXA783A/Olt2bamHinzc7k73UQkZfI
         RDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rkflrBl13OLl0FnUXx5RNj7pmM2ecbghJMJzEDew8fM=;
        b=EwMTDoLMgCGElXIKVEoHtCUAvIr+eIxoLTEKJHHfkHbo3AJQUjDqFMKIJ2ZvBS970C
         FvU/wpS5gIXcEVw/lpxDg2Fm5IM9hsT/7hmySnRzC9O73bpRUaG4EUSsom4+rIdaRZAa
         ZlG9PqT/jfGQ7atacHXHlYq5PWmNGqMMfhQ+hdtKidD91MSZaw2Wuh94NcICKCiFL35y
         d+94MXntGFdYRhE+l5PRJ9CLeNLEcMTjfRLfEWE+eSZZnuN4W0P4k9x+85H9xhHk0DXO
         UhYPteXvdu4lv5WX45QIsK3eb6GZK/4zye6k/K7n86OMpXZcj0uiIF1FrV3StGyhJ71X
         OjOQ==
X-Gm-Message-State: AOAM533j7Hr9+G4NQfZi9X5Dcfu+mAEEwXgN1ifiwXgiIwi1NQz0G5eU
        o9surc3zPtILX8i6ycxDg78hU+vEgP5jwJSw
X-Google-Smtp-Source: ABdhPJwuTZwNiTA9vVC4EUP5/KnsiwyU7Jmeyc1HCv3C6Af2v58JiNDL+s0IKk0U80DEPvubSv7OGg==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr2251433wmf.136.1616053424577;
        Thu, 18 Mar 2021 00:43:44 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f16sm1725603wrt.21.2021.03.18.00.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 00:43:44 -0700 (PDT)
Date:   Thu, 18 Mar 2021 08:43:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <20210318074342.GQ4652@nanopsycho.orion>
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 18, 2021 at 04:42:53AM CET, jbohac@suse.cz wrote:
>__dev_alloc_name(), when supplied with a name containing '%d',
>will search for the first available device number to generate a
>unique device name.
>
>Since commit ff92741270bf8b6e78aa885f166b68c7a67ab13a ("net:
>introduce name_node struct to be used in hashlist") network
>devices may have alternate names.  __dev_alloc_name() does take
>these alternate names into account, possibly generating a name
>that is already taken and failing with -ENFILE as a result.
>
>This demonstrates the bug:
>
>    # rmmod dummy 2>/dev/null
>    # ip link property add dev lo altname dummy0
>    # modprobe dummy numdummies=1
>    modprobe: ERROR: could not insert 'dummy': Too many open files in system
>
>Instead of creating a device named dummy1, modprobe fails.
>
>Fix this by checking all the names in the d->name_node list, not just d->name.
>
>Signed-off-by: Jiri Bohac <jbohac@suse.cz>
>Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks!
