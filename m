Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3228EC3D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgJOE05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOE0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:26:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D9C061755;
        Wed, 14 Oct 2020 21:26:52 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o7so953390pgv.6;
        Wed, 14 Oct 2020 21:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iNHVFd5PlmYNkQaZe4PpF7uyhE4h5AcVhJcsViTjG4s=;
        b=mkrqoz3vvDN/NMvvhVzk3DaTdtwjh8PG2ub0JPFYkF6/Jrxiy+XvCBt9WGb5dW+2UF
         UAkFTaLyrwC3kuuKbVrM5QzCHn8l/VZ7D9J2EjjtxFshy3RZTEQVKchrCE1s87LB9QBo
         VdruAwYXBzttt/EvywxQg55de302N6nvGE50UK8+gBub4GiPwmIRTVJ0nVxxwDPrB6tc
         4Wm/AMoN/hUgaVCtpGNHmVKjooRvSsFlzqvtxJhBQT87xGQCroPDJPwJb8yKK+39AOzZ
         JSpBlS7+z8aNWmFwTWuNPyVYI/eEoG/8omjZVJG3BWglDc3GTfdSnY2tzz5HN7t4hGXI
         hY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iNHVFd5PlmYNkQaZe4PpF7uyhE4h5AcVhJcsViTjG4s=;
        b=AUfQDJyVRSPZGXN4mU8zeNMnhPeMc/8JbRcyetxFzZitSj6RZAzMZcefE9iA6ie94n
         MAAZ5hlP2/hGb6Fz+YAD8ncfumfP6jhq3PNZOh1Q/fiS3nGfc2m50FbSlkqYbZIPkXHn
         S8kwPkBkT7i4gxIoVJSuou9EmOSS7U0PA3dZvMfXbWcvTyfTxFV3DTLn4NCZU2lz2n8P
         19Ml/Pkfrr6LMq6PgiqHNr+zs98HG0PIrWTodCN8IRUsPuZBzlfUXvR9u7EpW08u5bt0
         usFYfvJNX2hee9PaSWPeoGBcv1t1OSK1UaKeY8zkPhAWkswmGkwLXb/8Q+TZJl3VBr8p
         vPkQ==
X-Gm-Message-State: AOAM5323nSS+nSeSHBH6yC3Gw9gvxXxEMpnFq5W7A6PtSuTLTgSgyJ6D
        HB+ISMeaKLWcIDBsrKAEiGE=
X-Google-Smtp-Source: ABdhPJx+azL3ac6FwTk5uZqWdTaTc/lgmXZS7FZPyYt5I7pOC7d4UxouNE32nRvJZEVgyR4JlJUelg==
X-Received: by 2002:aa7:9a4a:0:b029:155:323e:adae with SMTP id x10-20020aa79a4a0000b0290155323eadaemr2407909pfj.70.1602736012489;
        Wed, 14 Oct 2020 21:26:52 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id e4sm1230371pgg.37.2020.10.14.21.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:26:52 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 15 Oct 2020 12:26:28 +0800
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
Message-ID: <20201015042628.42evgens2z47x3d6@Rk>
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
>
Thank you for reminding me of the second example!

>Besides, the next patch reintroduces the name struct ql_adapter.

Oh, there is still a left-over ql_adapter in qlge.h (I renamed ql->qlge
after initializing the devlink framework earlier but did a git rebase
to make the order of the changes more reasonable). Thank you for the
reminding!

--
Best regards,
Coiby
