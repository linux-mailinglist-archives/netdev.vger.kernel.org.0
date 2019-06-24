Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB2451937
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfFXRDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:03:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53517 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbfFXRDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:03:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so91793wmj.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0C2e1A1aXVp8J6zVjc9tXUTAJcFU7AL/DG7qB6u941o=;
        b=NdwV/mIfMiC13hnlsDmxa3A9e4BdR437jykUHpAvUwNktsFbmfg2+mXgojOeXxqm/K
         SacJQ1s+zF5+YWj454NaavpJ0iZaNabohE5OL5vxIbBOzTDcJIY7ckRygH01nIjSGrUC
         nmCdaQmZCb+sTys3K4KQvBxKxTCNzEBbgAL6jmafbSEhih5cKFgN3V+pkm23gh5aTM/z
         v0j/X/FiED/3hpY8DfJZXnDTGNUai07Zi+ZSRmK+jV2ny8w65MmqKMDVpU0NajgJ7Oti
         BY8MI6QHKFaybP7BJ2qdpODNBlgUbB22612CwdwRALyj8kE8rkqKMj08QM6WMlFwpjPB
         gFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0C2e1A1aXVp8J6zVjc9tXUTAJcFU7AL/DG7qB6u941o=;
        b=Xn03+CrhaNv6h98GM2602u38EhZRjQ5nPPgwdsptaMKC1LuYmwaBBHAxjDwGsk0O5r
         9X7pjrubALqz5Wo30bp7Pbf9ObrNMzD7NEalVsZ9YwOxlBVh8w8HTENQwNSSBLMkyw1Z
         UqxlTcuTZB0kvwW/viwZ3sS1tQrucAWtX1V1ZbWdVDHWPbwQ4q0hOiKigo/q9e5BwBpC
         QabgKOFhRJTqcQtg+KKS4xiLNDLdYoYd+2OkUvmXKG0j6Hh40lvL3Fgq9e0gUT+d6A0O
         w3M8yIk5vscHEo8ZQqF22UeYIFs8MAknl5lDkskyiDW+b03PYNrepyoSK62KGNzS8m8K
         hjFA==
X-Gm-Message-State: APjAAAVF8IAvTClCFkhVvg/efiv99cnk+RF7opgZyfVHhx8tQXzB5eNv
        BmVquKwygNPtXCpUxmxmB8ICs+aoD6c=
X-Google-Smtp-Source: APXvYqx8hs9mDTHsoZYA0LY5tJx47I7TbUNJ6KTA5eE2Gt3MkpvlCrIShJDJjtUw+KyXch/6+BXcoA==
X-Received: by 2002:a7b:c398:: with SMTP id s24mr12061681wmj.53.1561395791429;
        Mon, 24 Jun 2019 10:03:11 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id r4sm9774901wrv.34.2019.06.24.10.03.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 10:03:11 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-13-leon@kernel.org>
 <20190624120416.GE5479@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <a076a050-871b-c468-f62e-95bb4f0ac2c2@dev.mellanox.co.il>
Date:   Mon, 24 Jun 2019 20:03:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624120416.GE5479@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 3:04 PM, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:15:40PM +0300, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Add DEVX support for CQ events by creating and destroying the CQ via
>> mlx5_core and set an handler to manage its completions.
>>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/hw/mlx5/devx.c | 40 +++++++++++++++++++++++++++++++
>>   1 file changed, 40 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index 49fdce95d6d9..91ccd58ebc05 100644
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
>> @@ -19,9 +19,12 @@
>>   #define UVERBS_MODULE_NAME mlx5_ib
>>   #include <rdma/uverbs_named_ioctl.h>
>>   
>> +static void dispatch_event_fd(struct list_head *fd_list, const void *data);
>> +
>>   enum devx_obj_flags {
>>   	DEVX_OBJ_FLAGS_INDIRECT_MKEY = 1 << 0,
>>   	DEVX_OBJ_FLAGS_DCT = 1 << 1,
>> +	DEVX_OBJ_FLAGS_CQ = 1 << 2,
>>   };
>>   
>>   struct devx_async_data {
>> @@ -94,6 +97,7 @@ struct devx_async_event_file {
>>   #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
>>   struct devx_obj {
>>   	struct mlx5_core_dev	*mdev;
>> +	struct mlx5_ib_dev	*ib_dev;
> 
> This seems strange, why would we need to store the core_dev and the ib_dev
> in a struct when ibdev->mdev == core_dev?
> 

We need to add the ib_dev as we can't access it from the core_dev.
Most of this patch we can probably go and drop the mdev and access it 
from ib_dev, I preferred to not handle that in this patch.

