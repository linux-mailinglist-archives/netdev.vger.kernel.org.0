Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CC2AAB36
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 15:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHN7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHN7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:59:07 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E50C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 05:59:07 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ay21so5962148edb.2
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 05:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FQnmNPDubMBv3HYHLbOC10CgBLSVUI3pQ2wqAzGb2Ew=;
        b=sttzqSuLPnrmagzPMxuxIBnQMX8d3xfKtfVJvz+GT8+uJPLvrAkwnvh4ugE7qYSoh6
         etzHCCm0qeY8wmRUAN+0UhE+BE5znMVguVmMGU+nFc8M71Ny12RvvsFn8Kafn4oPic5/
         6hZppZgp2tZOrI+mCmxN6GXpH/HrJLDmR6oOeLYDrWGV3EgkK13TYp/NMiwjgHx9jwKp
         Pr7+53NSKrLXjbB5IzOx1Psa7EggSzuyCpW7ittRHDKyDY8prrhZGdyiISSvsGAj7rBG
         Vf5fD65M/geyWduUOhAPoV92HFGJ+aEfOTf65WIl+qAAf+VbvrOfkE7YctK55soCzhbN
         zLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FQnmNPDubMBv3HYHLbOC10CgBLSVUI3pQ2wqAzGb2Ew=;
        b=KST7r86H0WfzC7ySgea9R/nPflOKj1xTq15zOBO/qfEI8wye4I+mM71s1L3gzziwAe
         dseruUoCnO+C0fJNGB0FRMVH56aAfJzwb9PDI6yIZnWwBWb2Uef+M9bA/LJSw6cNE+Qc
         Q03Wr2A/WvEm3aOtry2qkDS8hsoEGM3aOWQDDbiHtXmvdvJA7OqEMntfq6f0BoVzC9NW
         XX5NFkAVtF9XlMzkarCH3MOR8rZJOOyW5eoTTBWvlv3pFI7N5aDvgFFfwBk2y3mp81gA
         SuYsl/BYgnFDywzbHt3TVvseUc1f1IDcRaip3YNf5XAgP0uZPGPUBjSz2v9BOiD0tqgm
         fq2A==
X-Gm-Message-State: AOAM533jDXmjIFKhgIntm+n88Ioa5VsVzcvw7TqP3mpwexRBAvfC2Wlw
        CQk1aH8gnVpvv7dkgZJsUJw=
X-Google-Smtp-Source: ABdhPJz1sUCthpNfMXgX4a/E4Z1JjGrvjHMjXnLmg+P+qGYLK7QPagBQjjdjUH+XVvuJ/Jzld3GIiQ==
X-Received: by 2002:a50:99cd:: with SMTP id n13mr11031795edb.10.1604843946073;
        Sun, 08 Nov 2020 05:59:06 -0800 (PST)
Received: from [132.68.43.131] ([132.68.43.131])
        by smtp.gmail.com with ESMTPSA id s21sm6127093edc.42.2020.11.08.05.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 05:59:05 -0800 (PST)
Subject: Re: [PATCH net-next RFC v1 06/10] nvme-tcp: Add DDP data-path
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-7-borisp@mellanox.com>
 <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
 <24ea956e-40a2-8b7b-cf8a-b604e7cd5644@grimberg.me>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <6551237d-104d-1e3f-00a7-a3b479786344@gmail.com>
Date:   Sun, 8 Nov 2020 15:59:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <24ea956e-40a2-8b7b-cf8a-b604e7cd5644@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/10/2020 2:00, Sagi Grimberg wrote:
>>>   static
>>>   int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
>>>                   struct nvme_tcp_config *config)
>>> @@ -630,6 +720,7 @@ static void nvme_tcp_error_recovery(struct 
>>> nvme_ctrl *ctrl)
>>>   static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>>>           struct nvme_completion *cqe)
>>>   {
>>> +    struct nvme_tcp_request *req;
>>>       struct request *rq;
>>>       rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
>>> @@ -641,8 +732,15 @@ static int nvme_tcp_process_nvme_cqe(struct 
>>> nvme_tcp_queue *queue,
>>>           return -EINVAL;
>>>       }
>>> -    if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>>> -        nvme_complete_rq(rq);
>>> +    req = blk_mq_rq_to_pdu(rq);
>>> +    if (req->offloaded) {
>>> +        req->status = cqe->status;
>>> +        req->result = cqe->result;
>>> +        nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
>>> +    } else {
>>> +        if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>>> +            nvme_complete_rq(rq);
>>> +    }
> Oh forgot to ask,
>
> We have places in the driver that we may complete (cancel) one
> or more requests from the error recovery or timeout flow. We
> first prevent future incoming RX on the socket such that we
> can safely cancel requests. This may break with the deferred
> completion in ddp_teardown_done.
>
> If I have a request that is waiting for ddp_teardown_done do
> I have a way to tell the HW to never call ddp_teardown_done
> on a specific socket?
>
> If so the place to is in nvme_tcp_stop_queue.
Interesting and indeed, it is a problem that we haven't considered.

