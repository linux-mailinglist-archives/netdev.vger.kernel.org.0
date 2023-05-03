Return-Path: <netdev+bounces-153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3DFC6F57F5
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 160F71C20EE0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E278F5D;
	Wed,  3 May 2023 12:32:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801AB321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:32:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB8059F1
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683117156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gi64OX3Of2seO335Lxc+tT0UY6TwkdsRC//xSV8lTrE=;
	b=CsxpmawxutyNthI9x4bsvdxcrca1hiSs7kLx7rmGo1xFFaT7CCvm3/iQp47IaV/D4FaotC
	+ixpfusaqf/Vh9uYZ1SC1hlPpsrylwz5enqfdGeYms1M+m9IdM61iI97Ka7Mu4Bni49tYN
	hn/dPJj2jYL31KuGhpIcvmAfOEgY/us=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-QeBUEEkIONCq2gO6fi7vDg-1; Wed, 03 May 2023 08:32:33 -0400
X-MC-Unique: QeBUEEkIONCq2gO6fi7vDg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-61b64cb44c7so30243176d6.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 05:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683117153; x=1685709153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gi64OX3Of2seO335Lxc+tT0UY6TwkdsRC//xSV8lTrE=;
        b=bB2xgtsCDsRqXyCnFkCsL/vVYCyDJ32ZLnkA2HgbtCo0/7DKWMH5ZpHaBBJzYIQ4C8
         JiTdLzj8m/Fmc/90eJ5aUMWQBfO3XgpWuKpZ/g+s4fyRCeePU0cPS7cNdd1rBEvyVuT1
         EN0j/ui9N7e3Bu5S8y4MVoI34vaE9KHEUlr4yUAi0WehwWkuBfOK1AfIMKy/7VFdOb2j
         Y5D6WpK9DeJb10AAFArCEicAlU0HuprMY1F5lhzwTbKW9fP0T9G6iNw79vIhWxjlCDS+
         7BxkSb9UpQ47YvfyITRcwW1+5LYbgm8pxwhmBSkS7McFaX0ElIqFbM7Ft+FZHRM341G0
         zrQA==
X-Gm-Message-State: AC+VfDzAsQWQQ41qQ8Eg57fzrRwGorh9vw+O96pXXJEpp5oLsHjyMnK0
	dzCzwAi6jNCd0iUbHUyYCdU4G5P0Ur2KUhe0n81wVuUkc+/Tjv2cmW41H/8cR0Ff6DSpJxbcm+R
	5ObeB86Ph9L9iTY1re0xCjQ8X
X-Received: by 2002:a05:6214:2b06:b0:5b5:9c2:8c29 with SMTP id jx6-20020a0562142b0600b005b509c28c29mr10558694qvb.12.1683117153213;
        Wed, 03 May 2023 05:32:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7gD3DZqKFg22wLfhmmFhk3KWfQV1G/GfCVYnFgmZALN4tXOUdfnVs05JyYA1d20ExjdNJAIw==
X-Received: by 2002:a05:6214:2b06:b0:5b5:9c2:8c29 with SMTP id jx6-20020a0562142b0600b005b509c28c29mr10558669qvb.12.1683117152962;
        Wed, 03 May 2023 05:32:32 -0700 (PDT)
Received: from [192.168.1.31] (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id l17-20020a056214029100b005e8f61012e9sm10300002qvv.26.2023.05.03.05.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 05:32:32 -0700 (PDT)
Message-ID: <e0d252e7-a025-511e-22b3-c46f1f7ac054@redhat.com>
Date: Wed, 3 May 2023 05:32:29 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH] pds_core: add stub macros for pdsc_debufs_* when !
 CONFIG_DEBUG_FS
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>
Cc: shannon.nelson@amd.com, brett.creeley@amd.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230502145220.2927464-1-trix@redhat.com>
 <ZFIO4FixTx1HC1RJ@nanopsycho>
From: Tom Rix <trix@redhat.com>
In-Reply-To: <ZFIO4FixTx1HC1RJ@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/3/23 12:36 AM, Jiri Pirko wrote:
> Tue, May 02, 2023 at 04:52:20PM CEST, trix@redhat.com wrote:
>> When CONFIG_DEBUG_FS is not defined there is this representative link error
>> ld: drivers/net/ethernet/amd/pds_core/main.o: in function `pdsc_remove':
>> main.c:(.text+0x35c): undefined reference to `pdsc_debugfs_del_dev
>>
>> Avoid these link errors when CONFIG_DEBUG_FS is not defined by
>> providing some empty macros.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>> drivers/net/ethernet/amd/pds_core/core.h | 12 ++++++++++++
>> 1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
>> index e545fafc4819..0b39a6dc65c8 100644
>> --- a/drivers/net/ethernet/amd/pds_core/core.h
>> +++ b/drivers/net/ethernet/amd/pds_core/core.h
>> @@ -261,6 +261,7 @@ int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
>>
>> void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
>>
>> +#ifdef CONFIG_DEBUG_FS
>> void pdsc_debugfs_create(void);
>> void pdsc_debugfs_destroy(void);
>> void pdsc_debugfs_add_dev(struct pdsc *pdsc);
>> @@ -270,6 +271,17 @@ void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
>> void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
>> void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
>> void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
>> +#else
>> +#define pdsc_debugfs_create()
>> +#define pdsc_debugfs_destroy()
>> +#define pdsc_debugfs_add_dev(pdsc)
>> +#define pdsc_debugfs_del_dev(pdsc)
>> +#define pdsc_debugfs_add_ident(pdsc)
>> +#define pdsc_debugfs_add_viftype(pdsc)
>> +#define pdsc_debugfs_add_irqs(pdsc)
>> +#define pdsc_debugfs_add_qcq(pdsc, qcq)
>> +#define pdsc_debugfs_del_qcq(qcq)
> Usually this is done using static inline stub functions. Any reason to
> not to do it in the same way?

I do not mind changing the patch if that is what is required.

However I believe Paolo said the change was being handled by another patch.

Tom

>
>
>> +#endif
>>
>> int pdsc_err_to_errno(enum pds_core_status_code code);
>> bool pdsc_is_fw_running(struct pdsc *pdsc);
>> -- 
>> 2.27.0
>>


