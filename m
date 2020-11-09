Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924452AC943
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgKIXYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:24:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32792 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbgKIXYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:24:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id p19so883041wmg.0
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4fYW7atqTCFeV0ZwbZO6DpnGkO9+ntK7D4Qq/lKRBTg=;
        b=MMdZucHxDPRdFxXyt75AC2FqNADGz11hUlOCuudse6DULXqZ2rsyIcrxl0ufqz2anv
         25/RDZwmfWmg8iHlDWHSSIJT7s8oJF+3m58T5SMv+R/vTEKmm1y6KmyjGWjM8aFR5+sr
         C5bdrxPrpjNvWJ6+kbyFFsYMvqn+Er9AGkH95afeWQxYURhNCyN3a34RHYI+ICtBDtZl
         jT6LNrUEOkiAPSBzpUKRO3yi9wLEP2WQVsEbcEdJR6wr6TTv5E4gmo/s6PPS1EoML+F2
         OLkA7f13gd/z0+VbwXYQdcaUuHawRAESrLH0qJA6giRl6pU7NlGAGYUp6I6AXYKTmxsD
         gsrg==
X-Gm-Message-State: AOAM531HwupYyQUVozhgtFCThDz1YLaB59g5XaTuIqpQPnQaBFSccARy
        g1F1xc+nEigDMeZINAYXQ6g=
X-Google-Smtp-Source: ABdhPJxKUNNNYEHSscPU3HUyYSJ6LMGmPpaINmiRwm48+WreFKTG2CAqaCODa8p9/VQ92nXG9L2dWA==
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr1605094wma.68.1604964239722;
        Mon, 09 Nov 2020 15:23:59 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:f26a:270b:f54c:37eb? ([2601:647:4802:9070:f26a:270b:f54c:37eb])
        by smtp.gmail.com with ESMTPSA id u195sm971656wmu.18.2020.11.09.15.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:23:59 -0800 (PST)
Subject: Re: [PATCH net-next RFC v1 05/10] nvme-tcp: Add DDP offload control
 path
To:     Shai Malin <smalin@marvell.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-6-borisp@mellanox.com>
 <c6bb16cc-fdda-3c4e-41f6-9155911aa2c8@grimberg.me>
 <PH0PR18MB3845430DDF572E0DD4832D06CCED0@PH0PR18MB3845.namprd18.prod.outlook.com>
 <PH0PR18MB3845CCB614E7D0EC51F91258CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a41ff414-4286-e5e9-5b80-85d87533361e@grimberg.me>
Date:   Mon, 9 Nov 2020 15:23:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <PH0PR18MB3845CCB614E7D0EC51F91258CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index
>>> 8f4f29f18b8c..06711ac095f2 100644
>>> --- a/drivers/nvme/host/tcp.c
>>> +++ b/drivers/nvme/host/tcp.c
>>> @@ -62,6 +62,7 @@ enum nvme_tcp_queue_flags {
>>>    	NVME_TCP_Q_ALLOCATED	= 0,
>>>    	NVME_TCP_Q_LIVE		= 1,
>>>    	NVME_TCP_Q_POLLING	= 2,
>>> +	NVME_TCP_Q_OFFLOADS     = 3,
> 
> Sagi - following our discussion and your suggestions regarding the NVMeTCP Offload ULP module that we are working on at Marvell in which a TCP_OFFLOAD transport type would be added,

We still need to see how this pans out.. it's hard to predict if this is
the best approach before seeing the code. I'd suggest to share some code
so others can share their input.

> we are concerned that perhaps the generic term "offload" for both the transport type (for the Marvell work) and for the DDP and CRC offload queue (for the Mellanox work) may be misleading and confusing to developers and to users. Perhaps the naming should be "direct data placement", e.g. NVME_TCP_Q_DDP or NVME_TCP_Q_DIRECT?

We can call this NVME_TCP_Q_DDP, no issues with that.
