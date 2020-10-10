Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4228A026
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 13:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJJLOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 07:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729310AbgJJKZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:25:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F1EC0613E4;
        Sat, 10 Oct 2020 03:00:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so9419311pgl.2;
        Sat, 10 Oct 2020 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I9AHl5bp5WPLKmxh/1O3ggN7nM3m0zYYXn5K7tm55Tg=;
        b=Fzygsyj9HGxWtMq/RnjXUGsalngSdHOTFRRv+WAKcop2NmXGD03TrHiPfZHCHfeSDj
         Efo2CQmVRt1E+BCn/R7xqsYlcdwDw3T+mQMHkfGT0IT7CRQAlRU3XJgDF34dSdmX68w/
         4x7yc0HAy/DoCMBsX1GUZHI+PjHFvqllqb08dR6dpWbH/bjA0dXsWlUMsA6ZLImftgI3
         Q0cxevsy4k8VoUU73jYD0qOaJbwUu7MosYtF5W+8wZ3/FjLYF+0RmRrzq69YYPSjepIa
         FGYGwVmkzWctVC9XNcpGzZepguKSNWe1WgEOqZ8GX9gBVWc+UfFJfVazbsBxcVyu4tdy
         I0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I9AHl5bp5WPLKmxh/1O3ggN7nM3m0zYYXn5K7tm55Tg=;
        b=XCZtqU3qYfUqY5XxboS0GAiIyI4OG5/VzoVPKJcKk54Y3EAXZZwfsvR5FHLIGNJmt/
         yAX/EtX/5yIZNjPhksTGP9Bqrea7nI+QbnD8KnCC6OOH49DWBRonkkuRB7HkcvtEeUwG
         Kta6xoeUsvTH0N1rRJf7gaIvbhS3/yCoEndz+DAN4d5defKanv2ouV7Xq6HRncGwogoV
         cxYRTkDRIZjXrZMGmVSGZCPktcBNhfqY7SLQtbTxujmoMq1cafNpODgxRc6KNpG8B00A
         usiT5P1LvrmDxZL6RjLtjJe7D0SWIPYbjm5T0JgdAp3yhKGD4O8MSJ502xJzzyVbXjok
         DwmQ==
X-Gm-Message-State: AOAM530QJ5oBNEv3zXxitjaBOAlibJ4Ug33Vg7NFWJfZRj59aWfPASIO
        lEI3GogadQ5oYjYMOnUm4Y4=
X-Google-Smtp-Source: ABdhPJy99sRp2/6FtliyUxTv0c9pvD+eJMJ2dVrAf4fS97haV/vaZ/6lN2mDWGt7h8WXIc2rlbswyg==
X-Received: by 2002:aa7:9358:0:b029:152:b349:8af7 with SMTP id 24-20020aa793580000b0290152b3498af7mr15526536pfn.18.1602324010493;
        Sat, 10 Oct 2020 03:00:10 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id b4sm6961319pjz.51.2020.10.10.03.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:00:10 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 10 Oct 2020 18:00:02 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 5/6] staging: qlge: clean up debugging code in the
 QL_ALL_DUMP ifdef land
Message-ID: <20201010100002.6v54yiojnscnuxqv@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-6-coiby.xu@gmail.com>
 <20201010080126.GC14495@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010080126.GC14495@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 05:01:26PM +0900, Benjamin Poirier wrote:
>On 2020-10-08 19:58 +0800, Coiby Xu wrote:
>> The debugging code in the following ifdef land
>>  - QL_ALL_DUMP
>>  - QL_REG_DUMP
>>  - QL_DEV_DUMP
>>  - QL_CB_DUMP
>>  - QL_IB_DUMP
>>  - QL_OB_DUMP
>>
>> becomes unnecessary because,
>>  - Device status and general registers can be obtained by ethtool.
>>  - Coredump can be done via devlink health reporter.
>>  - Structure related to the hardware (struct ql_adapter) can be obtained
>>    by crash or drgn.
>>
>> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge.h         |  82 ----
>>  drivers/staging/qlge/qlge_dbg.c     | 688 ----------------------------
>>  drivers/staging/qlge/qlge_ethtool.c |   2 -
>>  drivers/staging/qlge/qlge_main.c    |   7 +-
>
>Please also update drivers/staging/qlge/TODO accordingly. There is still
>a lot of debugging code IMO (the netif_printk statements - kernel
>tracing can be used instead of those) but this patch is a substantial
>improvement.

Thank you for the reminding! To move qlge out of staging tree would be
interesting exercise for me:)

--
Best regards,
Coiby
