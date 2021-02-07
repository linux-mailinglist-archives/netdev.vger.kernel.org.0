Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2EC3124AD
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 15:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBGOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 09:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBGOZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 09:25:33 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72B3C061756
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 06:24:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s26so9347105edt.10
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 06:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HbB/FXTzI09kyJuyCwUrYmeuHtf2T5FGWb7rJ2ZR5F8=;
        b=W4+UC/HohousM95ZIFtzMKsW5CYsQ0CcYdvLzLlTY/sKYXObjacj2Hyp/xcGCAqzLK
         4V5NqIqRK4fRYRak92eEKi1l2jApPlFosOY0xIiX3xvQ7vgvS+zgA81v6sm+3HQ7mKmf
         ku03yJpj0I2HISdK2AoMFla48mT0pHVyiu9rUxFzJMYftfYFcRAdrlElZVpk/r9SfnP+
         +Z4tqs+w0K37+llJ8tsOH5IhD4p3JEYRjIIUAb1JtMibWgli82RDxo9yXhvgNS7fwCnN
         olq/YvlqUvRDIesforqY2PPJI/25OMJo1PGzpsffAP40osK9KulCWNM6Crn3XJy57LFB
         bnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HbB/FXTzI09kyJuyCwUrYmeuHtf2T5FGWb7rJ2ZR5F8=;
        b=LahU91Ec9osQhRFsm6tQS7Hgbjzt2Hz7VcUXdAIl2trcvC25X2SKi5fXvTVs9o5mRh
         cFTjnkMSBcpwpUZ6CbOaUmhAiskU77jYevhAgT9C9Os6QyqKncffYsgj4RByLXL7pepd
         3EoXC53Jg7y43Ga4QOkybHM6urCyePwOPNHGMR0T4HC9MjNP4V/qu9weZ2HOsxCqsxIV
         hmbiSWyRd+PbM6t438tkaUEAqvEy44xcovlm2HygekVgBuUobhiHTPPEAU6/1KMoQkOh
         QJlU6SimEhGIZyYNZqMBG2H+fTFg/obutOr460ajykSF635bqpKgd/htnsjZnDh/qT2q
         EvYQ==
X-Gm-Message-State: AOAM532dKgte7XVBp+A5jI4ILqVgR3pIRH49VG1H/9zYZlcAdaZV1tzk
        fMsP5SD71HAbIchNrNJ87PI=
X-Google-Smtp-Source: ABdhPJw1tBsdjlf1a+IKr2w1PwOxDawwUzqyhRcghXLa/z+58ShyHO6E6GMhf7p5E3kdT+xcVV/BTQ==
X-Received: by 2002:aa7:d692:: with SMTP id d18mr13054264edr.327.1612707891637;
        Sun, 07 Feb 2021 06:24:51 -0800 (PST)
Received: from [132.68.43.187] ([132.68.43.187])
        by smtp.gmail.com with ESMTPSA id hc40sm1165122ejc.50.2021.02.07.06.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 06:24:51 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/21] iov_iter: Introduce new procedures for
 copy to iter/pages
To:     Christoph Hellwig <hch@lst.de>, Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>, smalin@marvell.com,
        Sagi Grimberg <sagi@grimberg.me>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        axboe@fb.com, Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-2-borisp@mellanox.com> <20210201173548.GA12960@lst.de>
 <CAJ3xEMjLKoQe_OB_L+w2wwUGck74Gm6=GPA=CK73QpeFbXr7Bw@mail.gmail.com>
 <20210203165621.GB6691@lst.de>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <736bdc2f-8073-6d34-9509-182ed1ab2b4f@gmail.com>
Date:   Sun, 7 Feb 2021 16:24:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203165621.GB6691@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/02/2021 18:56, Christoph Hellwig wrote:
> On Tue, Feb 02, 2021 at 08:00:51PM +0200, Or Gerlitz wrote:
>> will look into this, any idea for a more suitable location?
> 
> Maybe just a new file under lib/ for now?
> 

That doesn't work unless we copy quite a lot of code. There are macros
here (in lib/iov_iter.c) that we rely on, e.g. iterate_and_advance and
friends.

Instead, I propose that we place all of the new code under an ifdef to
reduce the impact on object size if the code is unused. We'll also
improve documentation around this commit.
