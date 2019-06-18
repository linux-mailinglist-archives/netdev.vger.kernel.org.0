Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3834A2C1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfFRNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:48:57 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:45986 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbfFRNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:48:54 -0400
Received: by mail-lj1-f178.google.com with SMTP id m23so13176726lje.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2XSUCZ0hfV9Jy2YXAPU07DGuQS9VkJpn8ZDKakZw2ao=;
        b=cASq4s6Irpuqsm1J7nwJT7suGd1mR7SsCqPxbgqfLHz3r6dlgh+sCVe6aq4kqSwyEc
         OGG3WC9/vfgk4W/hK7FoMiSEifobC97HrUiBEdVo11onVr6lf2B4RLIi1P7BPDaQuCJ+
         rsL0A/hP5CGzqhZnxUgD9XGsRw43SbnbHXohQey8m7Hrfv6KFFz3tez+WKNErUacVo6Q
         fNWdQtiT7ZG5AMxLGycuojysK+x3Bwj8RESZ+sb22HlxRg9IjX2Gvbp5ssDgM3bemYWF
         7GqTRCZBlXobX9PPmAUkLLra+ksk1Ycz/QD1z1C2/txKwUSPVzgC5hKaLU8tAVjt6OLW
         zLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2XSUCZ0hfV9Jy2YXAPU07DGuQS9VkJpn8ZDKakZw2ao=;
        b=rUAnVXrWcdyGaK/+2d06n0S8SbrSaYv6JHPX1B0dgCpro1n4SuSUNbGSDvi65cIYoI
         xR/+ZaHOJSFw46WLyACDXPswMmI0TZOSJNsG9EZvSCdU3nNE6vkLKLp2rr14DX8IoMbx
         MFYvO6eOts5v3ovN2lo6ivYUK1xGAxp+GnPFViNi1Lv4bVFJKlP3oY14YvGGu7lXxLjO
         26ocl1IJv6YglyOZasHYAoHnZYbobp9FuIRyZA1g6Lx2eSpBUZdQV3BhLV0Iv8Wmb6iW
         RDf97mqXK/OH/xcgvkZJju/nTMaDsMSOo8YE1CmxeK0jj6FkZP9XmS74NOpWCcXabotR
         SVEg==
X-Gm-Message-State: APjAAAXjoV5Va3KJ85IlFLPcGh66dQs3+l+KAAejbLV1XCuNS5Zt7UpX
        nzJrrbh4kTlmnOc5yMwPgi+VfQ==
X-Google-Smtp-Source: APXvYqyDrnN5bUCguopNTb2f/GS5rs55WE9t5MJPLJAtnkbadfnsVPkvC+fjWOAKn272gXV3CY3/yQ==
X-Received: by 2002:a2e:8195:: with SMTP id e21mr40998966ljg.62.1560865731560;
        Tue, 18 Jun 2019 06:48:51 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id k4sm2635569ljj.41.2019.06.18.06.48.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 06:48:51 -0700 (PDT)
Date:   Tue, 18 Jun 2019 16:48:48 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190618134847.GB5307@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
 <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
 <20190618125431.GA5307@khorivan>
 <20190618133012.GA2055@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190618133012.GA2055@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 04:30:12PM +0300, Ilias Apalodimas wrote:
>Hi Ivan, Tariq,
>
>> >>>+
>[...]
>> >>
>> >>What would you recommend to do for the following situation:
>> >>
>> >>Same receive queue is shared between 2 network devices. The receive ring is
>> >>filled by pages from page_pool, but you don't know the actual port (ndev)
>> >>filling this ring, because a device is recognized only after packet is
>> >>received.
>> >>
>> >>The API is so that xdp rxq is bind to network device, each frame has
>> >>reference
>> >>on it, so rxq ndev must be static. That means each netdev has it's own rxq
>> >>instance even no need in it. Thus, after your changes, page must be
>> >>returned to
>> >>the pool it was taken from, or released from old pool and recycled in
>> >>new one
>> >>somehow.
>> >>
>> >>And that is inconvenience at least. It's hard to move pages between
>> >>pools w/o
>> >>performance penalty. No way to use common pool either, as unreg_rxq now
>> >>drops
>> >>the pool and 2 rxqa can't reference same pool.
>> >>
>> >
>> >Within the single netdev, separate page_pool instances are anyway
>> >created for different RX rings, working under different NAPI's.
>>
>> The circumstances are so that same RX ring is shared between 2
>> netdevs... and netdev can be known only after descriptor/packet is
>> received. Thus, while filling RX ring, there is no actual device,
>> but when packet is received it has to be recycled to appropriate
>> net device pool. Before this change there were no difference from
>> which pool the page was allocated to fill RX ring, as there were no
>> owner. After this change there is owner - netdev page pool.
>>
>> For cpsw the dma unmap is common for both netdevs and no difference
>> who is freeing the page, but there is difference which pool it's
>> freed to.
>Since 2 netdevs are sharing one queue you'll need locking right?
>(Assuming that the rx-irq per device can end up on a different core)
No, rx-irq is not per device, same queue is shared only for descs,
farther it's separate queue with separate pool. Even rx-irq is per
device, no issues, as I said, it has it's own page pool, every queue
and every ndev, no need in locking, for pools...

>We discussed that ideally page pools should be alocated per hardware queue.
This is about one hw queue shared between ndevs. Page pool is separate
for each hw queues and each ndevs ofc.

>If you indeed need locking (and pay the performance penalty anyway) i wonder if
>there's anything preventing you from keeping the same principle, i.e allocate a
>pool per queue
page pool is per queue.

>pool per queue and handle the recycling to the proper ndev internally.
>That way only the first device will be responsible of
>allocating/recycling/maintaining the pool state.
No. There is more dependencies then it looks like, see rxq_info ...
The final recycling is ended not internally.

-- 
Regards,
Ivan Khoronzhuk
