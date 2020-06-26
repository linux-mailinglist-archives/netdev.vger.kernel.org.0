Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0421C20BD4B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgFZX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgFZX5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:57:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14842C03E979;
        Fri, 26 Jun 2020 16:57:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so4860393plq.6;
        Fri, 26 Jun 2020 16:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rsEV3VWlPvkhUXAUMqPfLhxZXBvMiVayXQJsZCVog6Q=;
        b=qaJFgFOqAcU29/5kD0f06Npxd2Dlxs2CofOxWIM1ri/KxJeD3CMMJ59rQmHzFucJ8B
         nh+vDWWb+BZtfjTYdIbBpJMUOu030FU6Y+BhUOavRYl3MX0jA7NtmJIIxBGfckqOL/pZ
         kGNCyhm8AjNr+poSF74dgm1gYnHVvWwFl6PRIPz/nC9ezwCvaDSGHLApTFGq4E3djAey
         yUqEr0GP9DqRyggZnLAydyoons0pEOwnqNWJ18syoG1G3wnz8VxgY5IZ6Vtn3vNhFbSW
         Uv2UMMCUu0B/IhXD3Ex/l0STcGim+cHLqzPyHuLLt/r3fWRgJ4wjhZFK77Xhna4/Ftor
         QMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rsEV3VWlPvkhUXAUMqPfLhxZXBvMiVayXQJsZCVog6Q=;
        b=X1p8S+hgHTmk6FTKnopDzLegYSjIRabpXS1qzKFnrINTs0c3DYoEw99iR8rg0ox1jJ
         itEWrypZufcN4JLa8+GR/H5eWL0G8KD9Clpd9a3bc8MWJ8ce3L04bOHJ+B12mdBUn2ye
         nFrnwUGL6MlfwUo3zVvoEtoSGbtNfescsyuWF8F393U1EeIUw+8kykMwOfVGLllkqt+d
         QrubsaCW+j2/qCGvq090BtNB8xR96KcY/ZOS1WYx3uHvJsKJCpFpMwQe0HxdtnPSZejB
         VopmY+4wE+vpo22LqB5lIAak0NVcRdH3mItvlV/xxTLD1idbC+cmo0hqpwSOU4IvlJF5
         HaYg==
X-Gm-Message-State: AOAM532o7Jp7rhXEKl23hfUyy1VVuHxYajoye6m59tKk2YN1ZHZezjfl
        eVmIDk3h/jnj//6NEVC85Yg=
X-Google-Smtp-Source: ABdhPJzVai7R7S/T4iw8i1jkT9aJDWWEaEIMVs2EARAOFCaoDxYnib5o0dCMspzPd8YqYik5vgix9g==
X-Received: by 2002:a17:90b:50d:: with SMTP id r13mr5872471pjz.94.1593215854419;
        Fri, 26 Jun 2020 16:57:34 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t5sm5081758pgl.38.2020.06.26.16.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 16:57:33 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 27 Jun 2020 07:57:25 +0800
To:     Joe Perches <joe@perches.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
Message-ID: <20200626235725.2rcpisito2253jhm@Rk>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
 <20200625215755.70329-3-coiby.xu@gmail.com>
 <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 03:13:14PM -0700, Joe Perches wrote:
>On Fri, 2020-06-26 at 05:57 +0800, Coiby Xu wrote:
>> Remove unnecessary elses after return or break.
>
>unrelated trivia:
>
>> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
>[]
>> @@ -1391,12 +1391,11 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
>>  			pr_err("%s: Failed read of mac index register\n",
>>  			       __func__);
>>  			return;
>> -		} else {
>> -			if (value[0])
>> -				pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
>> -				       qdev->ndev->name, i, value[1], value[0],
>> -				       value[2]);
>
>looks like all of these could use netdev_err
>
>				netdev_err(qdev, "etc...",
>					   i, value[1], value[0], value[2]);
>
>etc...

Should we also replace all pr_errs with netdev_err in
ql_dump_* functions? I'm not sure how we will use ql_dump_*. For example,
ql_dump_regs is not referred by any kernel source, so I guess it's for
the sole purpose of debugging the driver by the developer. But one
pr_err in ql_dump_routing_entries which is called by dl_dump_regs doesn't
prints out the device name whereas the other does,

> void ql_dump_routing_entries(struct ql_adapter *qdev)
> {
> 	int i;
> 	u32 value;
>
> 	i = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
> 	if (i)
> 		return;
> 	for (i = 0; i < 16; i++) {
> 		value = 0;
> 		if (ql_get_routing_reg(qdev, i, &value)) {
> 			pr_err("%s: Failed read of routing index register\n",
> 			       __func__);
> 			break;
> 		}
> 		if (value)
> 			pr_err("%s: Routing Mask %d = 0x%.08x\n",
> 			       qdev->ndev->name, i, value);
> 	}

--
Best regards,
Coiby
