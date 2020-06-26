Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C320B0B4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgFZLlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgFZLlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:41:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896FC08C5C1;
        Fri, 26 Jun 2020 04:41:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cm23so4837013pjb.5;
        Fri, 26 Jun 2020 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QP1W6LTqb3HrT7UeS27vyFiMv8Qdl9CewxQNnYMt6JQ=;
        b=bznUaDar0g9khomHuRgTnGoqDP76X5CaZIYsjxDjZw/+nxZeubAUWj+ak/AQex7eFH
         N0pCNrWEdMeLKjkg+Wa/oqdPycEJVFZpdmGdurIYc7H3kI6Ea/gqJWUhc/rYTQDGzbDA
         xR8n+CSvpn+LCEykMMU4T3eXQ7sdCpHvPXa+rlJ8vBi6iLXyZ9f4ltI02/KAIdcir+cu
         WDkMlz63kzFy0i+PR3TWNoiQu1KgfCnK/PG+R/lX1cRgwIC9mviETAhBUpDcGO03hU/k
         v5DT2FJ6a+DJf3XHWDkPju2Mbk48IkuW15kT17+WjnRoWBoShSNQavJ7PEfAc2u3HYnh
         o7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QP1W6LTqb3HrT7UeS27vyFiMv8Qdl9CewxQNnYMt6JQ=;
        b=N6ba/PRZ8UNgs4PzSJlFYQ+t4Q4B9kLN8KggBYF1DQUvvic9Ne7RTxU/zqcfLsKACN
         b00I6Y8FIH9dB0RurhBOyLndxr96kF0/zwMX4GXJ2gZUWwmjz1CW9o5bh9JlVsQ+MUnY
         NYp+fi5j61zNBgKpKyInC3sg8fY/YIB1KcuSgu0epz2Wt8aM3YGrarCYSovzjJySfYlZ
         x+1yeqbo5nmXxr5gZKorAS2oRXvmk1MeUNdZ1RWtQOG6XvPHhgnkaZfKvNvjN72WOzK4
         NJpzFORekVFF82o4YQ2Cjgl0Sf+8y34vPm89Cpw8UYSgYAKeOEY6UiXOuqExzIacf52F
         ub7Q==
X-Gm-Message-State: AOAM531YmDCQ+1Pr/1fz+hiFRRZ7aafkgncOv440MFxj01VTK4zbEGq4
        frJedFsyAiwO3dYqcm0QQAc=
X-Google-Smtp-Source: ABdhPJz0eY6Y6F4elZnSER9ALuIHX/WgM2RzhCQHvumXJyVAiDZ+oZ8s0y0/QAtEEyT6e8dy8qlBHw==
X-Received: by 2002:a17:90a:de18:: with SMTP id m24mr3158430pjv.49.1593171672566;
        Fri, 26 Jun 2020 04:41:12 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 4sm22490829pgk.68.2020.06.26.04.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 04:41:12 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 26 Jun 2020 19:41:04 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
Message-ID: <20200626114104.pst7b2yplsblmw6k@Rk>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
 <20200625215755.70329-3-coiby.xu@gmail.com>
 <20200626083436.GG2549@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200626083436.GG2549@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 11:34:36AM +0300, Dan Carpenter wrote:
>On Fri, Jun 26, 2020 at 05:57:55AM +0800, Coiby Xu wrote:
>> @@ -1404,11 +1403,10 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
>>  			pr_err("%s: Failed read of mac index register\n",
>>  			       __func__);
>>  			return;
>                        ^^^^^^
>> -		} else {
>> -			if (value[0])
>> -				pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
>> -				       qdev->ndev->name, i, value[1], value[0]);
>>  		}
>> +		if (value[0])
>> +			pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
>> +			       qdev->ndev->name, i, value[1], value[0]);
>>  	}
>>  	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>  }
>> @@ -1427,11 +1425,10 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
>>  			pr_err("%s: Failed read of routing index register\n",
>>  			       __func__);
>>  			return;
>                        ^^^^^^
>
>
>> -		} else {
>> -			if (value)
>> -				pr_err("%s: Routing Mask %d = 0x%.08x\n",
>> -				       qdev->ndev->name, i, value);
>>  		}
>> +		if (value)
>> +			pr_err("%s: Routing Mask %d = 0x%.08x\n",
>> +			       qdev->ndev->name, i, value);
>>  	}
>>  	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>  }
>
>This is not caused by your patch, but in these two functions we return
>without dropping the lock.  There may be other places as well, but these
>are the two I can see without leaving my email client.
>
>Do you think you could fix that before we forget?  Just change the
>return to a break to fix the bug.

Sure, I'll address this issue in the next series
of patches. Thank you for bringing up this issue!

--
Best regards,
Coiby
