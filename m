Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1017290E14
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411008AbgJPXRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393118AbgJPXQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 19:16:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9426EC061755;
        Fri, 16 Oct 2020 16:16:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so2053758pld.5;
        Fri, 16 Oct 2020 16:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x6hSFVlaJgCB8hg2RJUELUmJfgX8zfnwtAOEG3X8KRk=;
        b=GmE8xczXXqnrMh3MsLpg+HZZ9Er+EYhFt4ttU688FcVbfAZWL2aUg3lPGDBItpw2oR
         el5T7eKC2o05aL0HbiSPsPh/XKeedj7iQPVheNZ1SgVUlk5d5lgSeMi8n/hC2sQKgXZR
         +xMLQFwgJRI1t/UjNTsRl3q9uPKkzO9rElgGeKIhQsWhIl7/QBaRPg3UJg4MY5PnDP/w
         +5/GF9W5QGBoPHSwLaprExL/4ZjYM1LwZMa2FYKKkfy6pjpHEcPXdtvYLcuwV1j8UiVt
         WoXTqzwHLOSxZgUAmHgadE2iFEO9GFjv5ltQgjdSIMdZp2BtPJhF5HLXrO35APqf/xn9
         zn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x6hSFVlaJgCB8hg2RJUELUmJfgX8zfnwtAOEG3X8KRk=;
        b=XrEr4igDYZoJEvt0rubdMkkpI4Dft3SuEaKNacRm0o1UuF37fpy2ofJ8CgzrQmwKnH
         DfMy9rJ6UJbOcAMZXoj7zXEjLWcwe/tl+N+PSMbX2jlGwXMHg/BxXnyJgtxLDeNrgBpt
         SePc+T6FPArfg5kUr3YXlmiGGPuojkpzLU2bZ8TpAD3Wz+7Ip3eP750v0wITSRTHh9rr
         aFvsL+lIkVVxsYF1m0uk/fHDstqVjYf1n4yQeGXUA98uXrq9Syn7WPa/IPFqkhRid3y0
         nfR1Sx5k3UrvFhPyd8tUURgT1/5/JW1z8ysD1xJh9sLl/GOEwPvUIAiEnHetVZmAWGdn
         2xKg==
X-Gm-Message-State: AOAM533VQX1ZbuA76JNTkYQ9pnWqww/kEY0mYbxgvxXH41VudtDP+6Tm
        6SEperwUQn69ZAzM2Bed2RI=
X-Google-Smtp-Source: ABdhPJyQi7b1KBOmbhj++1AhiYXfPqOsE3wSaoA35psvMQoboX5Xz1e04PbFQtYG9v9LtdvsL1bfPA==
X-Received: by 2002:a17:90a:f0ca:: with SMTP id fa10mr6196925pjb.130.1602890214147;
        Fri, 16 Oct 2020 16:16:54 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id z12sm3928887pfr.197.2020.10.16.16.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 16:16:53 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 17 Oct 2020 07:16:31 +0800
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
Message-ID: <20201016231631.efwu5a4a5f3jnrzv@Rk>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-2-coiby.xu@gmail.com>
 <20201015010136.GB31835@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201015010136.GB31835@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 10:01:36AM +0900, Benjamin Poirier wrote:
>On 2020-10-14 18:43 +0800, Coiby Xu wrote:
>> To avoid namespace clashes with other qlogic drivers and also for the
>> sake of naming consistency, use the "qlge_" prefix as suggested in
>> drivers/staging/qlge/TODO.
>>
>> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/TODO           |    4 -
>>  drivers/staging/qlge/qlge.h         |  190 ++--
>>  drivers/staging/qlge/qlge_dbg.c     | 1073 ++++++++++++-----------
>>  drivers/staging/qlge/qlge_ethtool.c |  231 ++---
>>  drivers/staging/qlge/qlge_main.c    | 1257 +++++++++++++--------------
>>  drivers/staging/qlge/qlge_mpi.c     |  352 ++++----
>>  6 files changed, 1551 insertions(+), 1556 deletions(-)
>>
>> diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
>> index f93f7428f5d5..5ac55664c3e2 100644
>> --- a/drivers/staging/qlge/TODO
>> +++ b/drivers/staging/qlge/TODO
>> @@ -28,10 +28,6 @@
>>  * the driver has a habit of using runtime checks where compile time checks are
>>    possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
>>  * reorder struct members to avoid holes if it doesn't impact performance
>> -* in terms of namespace, the driver uses either qlge_, ql_ (used by
>> -  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
>> -  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
>> -  prefix.
>
>You only renamed ql -> qlge. The prefix needs to be added where there is
>currently none like the second example of that text.

On second thoughts, these structs like ob_mac_iocb_req are defined in
local headers and there is no mixed usage. So even when we want to
build this diver and other qlogic drivers into the kernel instead of
as separate modules, it won't lead to real problems, is it right?
>
>Besides, the next patch reintroduces the name struct ql_adapter.

--
Best regards,
Coiby
