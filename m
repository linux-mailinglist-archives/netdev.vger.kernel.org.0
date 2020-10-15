Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE24428EC4D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgJOEcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:32:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D38C061755;
        Wed, 14 Oct 2020 21:32:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t18so918403plo.1;
        Wed, 14 Oct 2020 21:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AXmRyhdS0GmnvBNnxkJbmQYN3zA7PGYdeJKou+GYMoo=;
        b=mpMjdv6mT4g/VsBLWkdSiBxftUd526VNielRQ0VQfG1pt+L2u5osaPA22YbWSfKXva
         OdKP7BfLnt3IguqnNSQoeJmM0eMpgns2wNIJLNqfBVDVa5NbrMhmW0UL5xqGCXJVfJmu
         XahafWswVwfYcpw0D9+3YNvMHlPXSToq/Xm44PMTBve5HNV2/3SRQOOIOjh0pD2AtGja
         JJogbjyO/6h2vAS+DEtfK7Q9+zduqvUp9BEh9Tq6zNFmo7okMjyHnOOlNZCtD9H1wJXA
         TdgFc5ClyLzr9OvaCQGnalUcwPjgyKcG5Gws+qMA5JM2G7BNnLbv4fT/E+J7kQ0Exeu3
         c3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AXmRyhdS0GmnvBNnxkJbmQYN3zA7PGYdeJKou+GYMoo=;
        b=FvCh0fEr6wBtY2ba7n9tpkIPBHDfyuLuWu/PnoWJIGI5KX16IfcC4Gq43T6gJ0DXje
         izZlG3pVwtmJ8/Gw/t8JAiRsh4ZpIp/M54pCVJ+WCLMTsWac6r3woA/xp/zaeshC7csj
         NySUnZleP/KuGH30Go+dEVVwm35alK8a95zsN9huEuSHDPjthzMNF2ZkaQEO85xAU/+g
         Qil6Pv9j9D+YVJ3G+9RFP4pcYiifCH8HENoy34a37e5OL+x5XW8Q3/LRLTea3LYO+VkL
         OsCuN+Y9KDe8Ka/7lzWs01a8H5sn9GNz5hNIHXeJbnzp7XldfgG1dz6ORv2/Hb8d8QlK
         lH8w==
X-Gm-Message-State: AOAM532NknpYQEj99MmhwwwVP6te85AiLmHCg2y6Kusk7xmiX0vTssnH
        a8Z7f9uiZ6Ejo0lWromzNXU=
X-Google-Smtp-Source: ABdhPJyyxNTCxrERuQhJUbuIfefATua/xJ5SaZSMGoJ9xBYOsLupMChuptum8AWnVLJ+XujWyr99Fg==
X-Received: by 2002:a17:902:bf45:b029:d5:b36d:56eb with SMTP id u5-20020a170902bf45b02900d5b36d56ebmr2177589pls.28.1602736364265;
        Wed, 14 Oct 2020 21:32:44 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id w187sm1309176pfb.93.2020.10.14.21.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:32:43 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 15 Oct 2020 12:32:29 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] staging: qlge: replace ql_* with qlge_* to avoid
 namespace clashes with other qlogic drivers
Message-ID: <20201015043229.yngmk7h32plk5kkn@Rk>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-2-coiby.xu@gmail.com>
 <20201015010136.GB31835@f3>
 <20201015042628.42evgens2z47x3d6@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201015042628.42evgens2z47x3d6@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 12:26:28PM +0800, Coiby Xu wrote:
>On Thu, Oct 15, 2020 at 10:01:36AM +0900, Benjamin Poirier wrote:
>>On 2020-10-14 18:43 +0800, Coiby Xu wrote:
>>>To avoid namespace clashes with other qlogic drivers and also for the
>>>sake of naming consistency, use the "qlge_" prefix as suggested in
>>>drivers/staging/qlge/TODO.
>>>
>>>Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>>>Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>>>---
>>> drivers/staging/qlge/TODO           |    4 -
>>> drivers/staging/qlge/qlge.h         |  190 ++--
>>> drivers/staging/qlge/qlge_dbg.c     | 1073 ++++++++++++-----------
>>> drivers/staging/qlge/qlge_ethtool.c |  231 ++---
>>> drivers/staging/qlge/qlge_main.c    | 1257 +++++++++++++--------------
>>> drivers/staging/qlge/qlge_mpi.c     |  352 ++++----
>>> 6 files changed, 1551 insertions(+), 1556 deletions(-)
>>>
>>>diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
>>>index f93f7428f5d5..5ac55664c3e2 100644
>>>--- a/drivers/staging/qlge/TODO
>>>+++ b/drivers/staging/qlge/TODO
>>>@@ -28,10 +28,6 @@
>>> * the driver has a habit of using runtime checks where compile time checks are
>>>   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
>>> * reorder struct members to avoid holes if it doesn't impact performance
>>>-* in terms of namespace, the driver uses either qlge_, ql_ (used by
>>>-  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
>>>-  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
>>>-  prefix.
>>
>>You only renamed ql -> qlge. The prefix needs to be added where there is
>>currently none like the second example of that text.
>>
>Thank you for reminding me of the second example!
>
>>Besides, the next patch reintroduces the name struct ql_adapter.
>
>Oh, there is still a left-over ql_adapter in qlge.h (I renamed ql->qlge
>after initializing the devlink framework earlier but did a git rebase
>to make the order of the changes more reasonable). Thank you for the
>reminding!

Btw, is there a way to configure kernel building to let the compiler
discover this kind of issue automatically?

>--
>Best regards,
>Coiby

--
Best regards,
Coiby
