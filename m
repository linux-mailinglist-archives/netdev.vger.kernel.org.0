Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780726F012C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 09:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242981AbjD0HDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 03:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242994AbjD0HC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 03:02:58 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3058F420A
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 00:02:32 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64115e652eeso2799911b3a.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 00:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682578951; x=1685170951;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AA9076PBQGQ1CvqVfefKSv2pXhUG01wTMuMnD2nJkG8=;
        b=jLGz1o/gOy7lZRmOeyA5yuMty1mAQ/iuWvCjMifOWvm0j4uLkXKiOgf9UM1A0iY5JH
         CwSyYAno6AlIplzeAwPsF10c4guM+QMfKhDDGeNLbz5axGI+qayc62rfYQLVXOkRS6vN
         HRaP5zRygf5AmKRpuXW3wF9qIEGE467ueDrsqFtcdGx0ucZ3hiZEtLGhV+JwGxEmmYMf
         ZIKCh7PIBKsUj37Sj9sgJd4gVxEP+II7OV/QbY19ys/2EgKPzMo4v8hQxdEkzENsEBOo
         duNOArJk+4/NimQH712r1Q3q6ldJcpe5y0uOnWQ1EIzf3i0jywK2ozryHq8GVamcGd1+
         tArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682578951; x=1685170951;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AA9076PBQGQ1CvqVfefKSv2pXhUG01wTMuMnD2nJkG8=;
        b=PmwDOaKUKdKzVx9zqwVym7IysikhlGMWHLS5UpKM9AxNT4U/2mzHgZo3xal6LkgTlf
         oeeosBv9SiN7e7E+FO4V5HdRnJmxLC4JMjFONq4cdS3BLNidpONzbZfu98lSmnfaM9WB
         doKq1h9xP9pXdAJBGcKe4KeJhlzYwW2tx0TI+a4utlMp2VK8CKAoFkRaAR0Df9HBvB8y
         tb0P1SJpZcHw0LqzPMtKJ7jbh27C8kFFzqAG71R4rPk1z4R6g7mfg4XIGERhnxBRy1x/
         Gakiu4fLqz6wc+YgDTJZd5BAa7UzxJ2VUF1kX1RKJnzCc36cH0xGKjBKDTdY9Y8UEy/w
         hhNQ==
X-Gm-Message-State: AC+VfDy3z63gkj9I5Vr21FS6A8sTicEjIQ/OFwD0/DVekFvjH1JbE7c1
        haGTL6JiQ+LySk96nMOD00lqjQ==
X-Google-Smtp-Source: ACHHUZ4gfWqDcWy7wjY90zhe6r/Xd5isZr7xM2oIdHs8gM9tlk4CDiQIOcPsD79B4M6XWvGZs4Ze8w==
X-Received: by 2002:a17:902:d484:b0:1a9:68d2:e4ae with SMTP id c4-20020a170902d48400b001a968d2e4aemr6110340plg.2.1682578951633;
        Thu, 27 Apr 2023 00:02:31 -0700 (PDT)
Received: from [10.2.195.40] ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902eb4d00b001a5023e7395sm10942150pli.135.2023.04.27.00.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 00:02:31 -0700 (PDT)
Message-ID: <252ee222-f918-426e-68ef-b3710a60662e@bytedance.com>
Date:   Thu, 27 Apr 2023 15:02:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
 <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
From:   Wenliang Wang <wangwenliang.1995@bytedance.com>
In-Reply-To: <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/23 2:20 PM, Xuan Zhuo wrote:
> On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
>> For multi-queue and large rx-ring-size use case, the following error
> 
> Cound you give we one number for example?

128 queues and 16K queue_size is typical.

> 
>> occurred when free_unused_bufs:
>> rcu: INFO: rcu_sched self-detected stall on CPU.
>>
>> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
>> ---
>>   drivers/net/virtio_net.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index ea1bd4bb326d..21d8382fd2c7 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
>>   		struct virtqueue *vq = vi->rq[i].vq;
>>   		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>>   			virtnet_rq_free_unused_buf(vq, buf);
>> +		schedule();
> 
> Just for rq?
> 
> Do we need to do the same thing for sq?
Rq buffers are pre-allocated, take seconds to free rq unused buffers.

Sq unused buffers are much less, so do the same for sq is optional.

> 
> Thanks.
> 
> 
>>   	}
>>   }
>>
>> --
>> 2.20.1
>>
