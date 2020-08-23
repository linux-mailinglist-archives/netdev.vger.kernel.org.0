Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE424ECEB
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 12:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHWK62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 06:58:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbgHWK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 06:58:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NAucYZ007724;
        Sun, 23 Aug 2020 03:57:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=jIiVWmyi+xyrVUpGq+nsWcpiyoSIOxjoarrOL6+28es=;
 b=SiqIJJnV+XTzt0ZP9KlS/aU0CO+u2Dvc5jHHQsIVykFG2ID3gT2qwnj3E+14+WkpIckO
 Ym0kKAroQNGukVqgItdVUOVAjL5+U3oEXIvnnxaAl7Lb1616GyodtpQz1ns/FPegm8ph
 Iaq2vdw+2EHUStTCt8hsjPwzVgY1Q2krmC+piEqHO8PRpl7JxDxWg7WiXOIDOhoQg7jh
 mYqf6zWWfHtVoMFL5CDqPwxQFzHKuVy2ANrKO/hWeYPOXOI9TPLTaIqViPcEgpq76XHl
 trkJldJJF2CCAb1rDEF5XcQjernZ4EvX5Ins+RZwuVxIk0z0cjvjY06bYv1OGR4YQZHF gQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpb7rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 03:57:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 03:57:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 03:57:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 03:57:55 -0700
Received: from [10.193.54.28] (unknown [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 2532C3F7043;
        Sun, 23 Aug 2020 03:57:52 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v6 net-next 04/10] qed: implement devlink info
 request
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
 <20200820185204.652-5-irusskikh@marvell.com>
 <20200821103218.6d1cb211@kicinski-fedora-PC1C0HJN>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <f6d5d039-420a-21d7-2796-0d54292744dc@marvell.com>
Date:   Sun, 23 Aug 2020 13:57:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101
 Thunderbird/80.0
MIME-Version: 1.0
In-Reply-To: <20200821103218.6d1cb211@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_14:2020-08-21,2020-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> ~$ sudo ~/iproute2/devlink/devlink  dev info
>> pci/0000:01:00.1:
>>   driver qed
>>   board.serial_number REE1915E44552
>>   versions:
>>       running:
>>         fw.app 8.42.2.0
>>       stored:
>>         fw.mgmt 8.52.10.0
> 
> Are you not able to report the running version of the stored firmware?
> The two sections are used for checking if machine needs fw-activation
> or reboot (i.e. if fw.mgmt in stored section does not match fw.mgmt in
> running - there is a new FW to activate).

Right now I think its not possible.
Will investigate more later, when we'll dive more into FW related
implementation of devlink APIs.


> In general looks good:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 

Thanks
