Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B19824CB2F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 05:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHUDOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 23:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgHUDOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 23:14:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA56C061385;
        Thu, 20 Aug 2020 20:14:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 128so336348pgd.5;
        Thu, 20 Aug 2020 20:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/YxLwfqRT0LzVr6sU/PoWPx80Kd+H0Hr2LJri5kk/Pc=;
        b=FSf5Jpl9/IFj6kOf3jntWnnXmVi0fLzyoVNQd9Et5l837ZviEz5bE51u7MyzY6jN8t
         1g9QNe55Es1Nb1JFpV+rTReUp4PBLd/w1e4Ub0VahG7xJ+3rH20rvqP+0UXh/87EGoFO
         pL9rqZH508dmmnpYu4gIA3rrQ50GklgzWc9//pBTGS/krgazkAdC/0lb83YMtgVqQ1DB
         yubYb7m7vreAwvGmz3sBZwhPm2//3l7q5G3aB2LawHC+oVLKanL0o7S0sPo1KCEkTwav
         soByUFvv+zRuPOu7B0Wy1d2ItNz2SDssVb/rRDupRH1JyZXec7eTt3BvN3ni3zpq0kn6
         coxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/YxLwfqRT0LzVr6sU/PoWPx80Kd+H0Hr2LJri5kk/Pc=;
        b=mpjSOZ6GzqJtBTU6MH4CbNhgAWRTHWy5zPTOQ6IhXx4zNGtG1KrIUBLmGppJMCS8Cj
         KuwffJoviuwVZ00Lvgf39tg901sVKrEbbN6G9BmcmlrTTlIGIYIvkN0PfNinrYasRjyC
         usG88kWEgx954Q0UB4apc73qWQuXDK+GMbnh7mAirsNNQwuytUydMkP5eVyQT2N/fD/0
         S+kyj3cZ4Azo44as+rR29+Dl1iW/vgcUdyFQ7IeP952lea5wLoZcMpzVEyZ5qxZnJz9g
         XLRybjg6z/Q6uvI/L1N0sTCobNjZA6Lw/6oJxYN7YfSlQiMo6J7PYkpkT4KfHMVVeTSC
         eY+Q==
X-Gm-Message-State: AOAM532RAo7pOnUqKKF20kyDQh3yqOMK2f+5ee9e7rr4n6qc/xLSog2Z
        PLOyxhFJUgb2X5MVy2X6Wsp6tl40Vzr/REn1GAU=
X-Google-Smtp-Source: ABdhPJz4sS4YBiY4YgsXDfQAOA6FAJKd3JDRxKn3w9h0Gc1psHawgfUEVTaUUsVEuEbrx9ShztbGLA==
X-Received: by 2002:a63:5a0f:: with SMTP id o15mr839105pgb.187.1597979657741;
        Thu, 20 Aug 2020 20:14:17 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id np4sm376656pjb.4.2020.08.20.20.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 20:14:17 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 21 Aug 2020 11:14:04 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/3] staging: qlge: clean up code that dump info to dmesg
Message-ID: <20200821031404.mjlqgcvvz3htxoj2@Rk>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
 <20200814160601.901682-4-coiby.xu@gmail.com>
 <20200816025717.GA28176@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200816025717.GA28176@f3>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 11:57:17AM +0900, Benjamin Poirier wrote:
>On 2020-08-15 00:06 +0800, Coiby Xu wrote:
>> The related code are not necessary because,
>> - Device status and general registers can be obtained by ethtool.
>> - Coredump can be done via devlink health reporter.
>> - Structure related to the hardware (struct ql_adapter) can be obtained
>>   by crash or drgn.
>
>I would suggest to add the drgn script from the cover letter to
>Documentation/networking/device_drivers/qlogic/

Thank you for this suggestion! I planned to send a pull request to
https://github.com/osandov/drgn. This is a better idea.
>
>I would also suggest to submit a separate patch now which fixes the
>build breakage reported in <20200629053004.GA6165@f3> while you work on
>removing that code.
>
I'll send a single patch to fix that issue before preparing for v1
of this work.

>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge.h         |  82 ----
>>  drivers/staging/qlge/qlge_dbg.c     | 672 ----------------------------
>>  drivers/staging/qlge/qlge_ethtool.c |   1 -
>>  drivers/staging/qlge/qlge_main.c    |   6 -
>>  4 files changed, 761 deletions(-)
>>
>[...]
>> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
>> index 058889687907..368394123d16 100644
>> --- a/drivers/staging/qlge/qlge_dbg.c
>> +++ b/drivers/staging/qlge/qlge_dbg.c
>> @@ -1326,675 +1326,3 @@ void ql_mpi_core_to_log(struct work_struct *work)
>>  		       sizeof(*qdev->mpi_coredump), false);
>>  }
>>
>> -#ifdef QL_REG_DUMP
>> -static void ql_dump_intr_states(struct ql_adapter *qdev)
>> -{
>[...]
>> -	}
>> -}
>> -#endif
>
>This leaves a stray newline at the end of the file and also does not
>apply over latest staging.

I will fix it in v1. Thank you for reviewing this patch!

--
Best regards,
Coiby
