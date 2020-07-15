Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B72206A0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgGOH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:58:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbgGOH64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 03:58:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F7ubEC007561;
        Wed, 15 Jul 2020 00:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=WTLHZrb53HRZUoiQ9CWX8wli+9EPk5Iro6ky11Kv4OM=;
 b=f3rVunWYFVJcli3m+mkXTv2flkfOTJdoXo+0lgCQRsmQkgrPBBmVZgt/RQg2E8Tr5EvG
 QjgZOFIrMkZcp3/DgaBO0NHHU2471RbzL9trbICzvgwCtMzqmmvUyfFW1LAa3kA4kz9o
 BBZa3wrZQY9q7HgF6bsy9sN9Lsrqvlf/VD7mAUxKa7zvGN4dQK3xhU1vnnm6ROe9XV+r
 wIVhwmkU+zgBgbczTvL0EYX+xPgtrILYtGOc9o66SIAcJ4/hrPwKsSsEfFdZxeMJv9n9
 HVBJK1sou20rZ3LsN5weHHiCWkQuYtjjnz5HtGYvrLdKW557t3bRqRRvnKtNaBSafwTT SQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhsr7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 00:58:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 00:58:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 00:58:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 00:58:50 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 91AA83F703F;
        Wed, 15 Jul 2020 00:58:48 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 03/10] net: atlantic: additional
 per-queue stats
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
 <20200713114233.436-4-irusskikh@marvell.com>
 <20200713150323.2a924a86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <a4b9349f-2f3b-e086-a2f6-74e83275741e@marvell.com>
Date:   Wed, 15 Jul 2020 10:58:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200713150323.2a924a86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_05:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review, Jakub.

>>  		for (i = 0U, ring = self->ring[0];
>>  			self->tx_rings > i; ++i, ring = self->ring[i]) {
>> +			ring[AQ_VEC_RX_ID].stats.rx.polls++;
> 
> You need to use the u64_stats_update_* infrastructure or make these
> stats smaller than u64, cause on non-64bit machines where the stats
> will be updated 32bit-by-32bit meaning readers can see a half-updated
> counter..

Agree, will secure with stats_update.

>> @@ -314,6 +316,7 @@ irqreturn_t aq_vec_isr(int irq, void *private)
>>  		err = -EINVAL;
>>  		goto err_exit;
>>  	}
>> +	self->ring[0][AQ_VEC_RX_ID].stats.rx.irqs++;

Indeed, looks like some leftover debug counter, will remove.

Thanks,
  Igor
