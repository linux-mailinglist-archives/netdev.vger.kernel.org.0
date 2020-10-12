Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47A028B3DA
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbgJLLeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbgJLLeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:34:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99F0C0613CE;
        Mon, 12 Oct 2020 04:34:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d6so8403501plo.13;
        Mon, 12 Oct 2020 04:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IRuRu6d50EbSzR6eJn8zTFBIpVvHOPQss0OJFKbt4rE=;
        b=PdEG7lRfdR0pUwVfHV6Jbh+x9P1/KCp8yGwD3CMccR/aPvV/BOf5ChBDI2nSGCaQ8N
         4IUaIBdJYTcm7lE98ugQbg4LqFFjbSKY+kZ2FMDlyNtwoOoZ+APcLL22gnmPlUGTBq1D
         mmjtT6gDVB0cAtMIjWpRhj0+7eEAV6tIe9t331u1SBekgietglZTE5BZJy5JotQw8eqa
         if9gOtwGn9m9PzDQm1f62uNpwSWCUytjacxb2Gwb9TL3umgNGKPlIk5XrANBJcr3rhnk
         vSppL5yDDND8GB4Egs6SMovu1EKi06NaK5c9eFhfqOo8vBrz8HJqeNSuWfueWKzaVnTG
         cW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IRuRu6d50EbSzR6eJn8zTFBIpVvHOPQss0OJFKbt4rE=;
        b=rpz5/IKS+eptHQf034BEb94Ipr73fUR99bz157dBE1Fa+gc6pXNZxtwZyTfvaNUoss
         f7vixFHrr8mfwMiwyt4KC9iKOZg7Hy3Kynj7MugJxNBrTgWdB/DY3oZrvlmDTzapqfh9
         t4l94uJLGwtA7LHRBJwoo4GicBCuSCoU7q5flOds0wPQwmjXdohqMnKT4tZtDQb/iuwc
         pE0s/gdkEFFFhAd6VSJWOtnkIU9s4DsPA3ZB+Kxu6HY5WrMtPmwt5E25I9HgCJN+iOdH
         kMbq1oyyXzASZiWtWfDLZfii7cUND/aOrJbRTSgrRSfVYUockWo8O4/VFB8Tj74ZUBrA
         IOcA==
X-Gm-Message-State: AOAM533JKRxb8u7HRUBQAnxtNiuxYGI5hmnvCkYe25NMY7miDWOxdLo9
        AMb3BQI2zoXbA0RAITG36qpSrcHqn7VfBbQr
X-Google-Smtp-Source: ABdhPJy1FSos1brD4v41UJOTnL3tEdAi/pK60RCz3MBlNzcAJQ2WAXzqsUO/JE+GHFQ+oP4XQWnOJQ==
X-Received: by 2002:a17:902:7242:b029:d4:c719:79ce with SMTP id c2-20020a1709027242b02900d4c71979cemr11851730pll.26.1602502461436;
        Mon, 12 Oct 2020 04:34:21 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id z6sm20350965pfg.12.2020.10.12.04.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 04:34:21 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 12 Oct 2020 16:08:43 +0800
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201012080843.7kh4xdk4ymaetza6@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+FuTSdEK+0nBCd5KAYpbEECmSvjoMEgcEOtM+ZKFF4QQKuAfw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 08:22:44AM -0400, Willem de Bruijn wrote:
>On Thu, Oct 8, 2020 at 7:58 AM Coiby Xu <coiby.xu@gmail.com> wrote:
>>
>> Initialize devlink health dump framework for the dlge driver so the
>> coredump could be done via devlink.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>
>> @@ -4556,6 +4559,13 @@ static int qlge_probe(struct pci_dev *pdev,
>>         struct ql_adapter *qdev = NULL;
>>         static int cards_found;
>>         int err = 0;
>> +       struct devlink *devlink;
>> +       struct qlge_devlink *ql_devlink;
>> +
>> +       devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
>> +       if (!devlink)
>> +               return -ENOMEM;
>> +       ql_devlink = devlink_priv(devlink);
>>
>>         ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>>                                  min(MAX_CPUS,
>
>need to goto devlink_free instead of return -ENOMEM here, too.

devlink_alloc return NULL only if kzalloc return NULL. So we
shouldn't go to devlink_free which will call kfree.
>
>> @@ -4614,6 +4624,16 @@ static int qlge_probe(struct pci_dev *pdev,
>>                 free_netdev(ndev);
>>                 return err;
>
>and here

But I should goto devlink_free here. Thank you for pointing out my
neglect.
>
>>         }
>> +
>> +       err = devlink_register(devlink, &pdev->dev);
>> +       if (err) {
>> +               goto devlink_free;
>> +       }
>> +
>> +       qlge_health_create_reporters(ql_devlink);
>> +       ql_devlink->qdev = qdev;
>> +       ql_devlink->ndev = ndev;
>> +       qdev->ql_devlink = ql_devlink;
>>         /* Start up the timer to trigger EEH if
>>          * the bus goes dead
>>          */
>> @@ -4624,6 +4644,10 @@ static int qlge_probe(struct pci_dev *pdev,
>>         atomic_set(&qdev->lb_count, 0);
>>         cards_found++;
>>         return 0;
>> +
>> +devlink_free:
>> +       devlink_free(devlink);
>> +       return err;
>>  }

--
Best regards,
Coiby
