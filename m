Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB21BB95E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgD1I6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:58:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgD1I6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:58:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S8vo65032458;
        Tue, 28 Apr 2020 01:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=CR7U3CAU9J6wyPo4PQ+sFcVVxaTFq9B6fDbsqy6hFqM=;
 b=H+E5BkrrPpFdevJvB2teO2VT7nXiJ7Mj63wENHHh068Z/rvzsNVfHEbsAByJKPYy8NMY
 2CHnHvrceHELJBUsPPjKyCns5MeXhCjFxlyPDk9fWJrwPowOEpKr+PXOqperlSP3gZA0
 BqzJ1W/s81KwJquh5fi7czxkYfJOQ6oqqPUd7FuJ0OYL7yXzBmkRc3S2EMIW5EA1BPSG
 ia7p4kU6q1JD0/S/AGSV0BXQhv0C+3/DHSQ29KBuBBh+Fzw3nPuAvFWS5x0kpPrZwODH
 309tlXDpsrH2IGhgySUh5I2j6ZGg0sDU1+6x4ZdJId2Qo13ULxVU2xoIl4G3fMeIh93m 3g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30mmqmk5gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 01:58:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Apr
 2020 01:58:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Apr 2020 01:58:45 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 4D9113F703F;
        Tue, 28 Apr 2020 01:58:43 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
 <20200427120301.693525a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <be1461d3-f87e-0bfa-0b37-6eef4a2519e6@marvell.com>
 <20200427.132009.1387378104495053173.davem@davemloft.net>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <485772dc-ffeb-ab42-66ee-5c5c61d60cba@marvell.com>
Date:   Tue, 28 Apr 2020 11:58:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200427.132009.1387378104495053173.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_05:2020-04-27,2020-04-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

>> I also see a lot of code through the kernel using pack(1) for the exact
> same
>> reason - declare hw sensitive structures and eliminate any unexpected
> holes.
> 
> Your resistence to this feedback is becomming irritating.

Please don't take this as a resistance, thats a first time we pushing hw
aligned bit structures in driver.

Trying to understand the best practices here and the history behind the
pack(1) backsides.

> Just because something is used elsewhere doesn't mean you are open to
> do the same, there is a lot of code where issues like this have not
> been caught through reivew and the code still ended up in the tree.
> 
> Using packed arbitrarily is being lazy and will result in suboptimal
> code generation on several platforms.
> 
> Fixed sized types have well defined padding on _all_ cpus and targets,
> so if you use them properly and pad up your structures, there is
> absolutely _nothing_ to worry about.
> 
> When I was very active writing hardware drivers with many HW defined
> structures and whatnot, I never once considered packed.  It never even
> crossed my mind, because I simply defined the data structure properly
> with well defined fixed sized types and padded them out as necessary.
> 
> So please stop pushing back on this feedback and get rid of the packed
> attribute.

Surely, already doing a rework.

Jakub, thanks for your feedback as well.

Regards,
  Igor
