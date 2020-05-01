Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E651C1EBD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgEAUjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:39:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57924 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgEAUjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:39:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041KVfZB015252;
        Fri, 1 May 2020 13:39:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=amCExj2ydGBsvQL/29pjzcRjp+HWiJ2vJuIJ56OPGRA=;
 b=S6J3qBnIWFJLPIDXLJLZql2J9DFHN+TNMTbr+bwDC9DLAWp+2p+us8RPuf/MkAKwC+Dc
 qeyTFRwL90Q63FOP5wTVmUlW+P7DhHwGYe4muBeE0xmwT6EVzlSixMqWf6EMr5a5Oa8I
 BGxTz9xpdnSVRz1ZIacDjOT1rfAagwmcrTfMGHj7cn/e8ypOC/xxGzlId3EK6LZLyMqK
 CfKMRIn4x2GQJdJqk2HVn4cxDJPUJeYeHXWUBaSgJcg7bZFbE/AP9UWlbj+HOz/iPJ7m
 KGURvrSGrZF5lwDz4sFXKtGPkUYUDBW/nnRRhzHjjNYei2AWn2xnInhHIXKuHtf5a0gK Xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30r7e8ma7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 13:39:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 May
 2020 13:39:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 May
 2020 13:39:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 May 2020 13:39:13 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 53DC93F7040;
        Fri,  1 May 2020 13:39:11 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 net-next 15/17] net: atlantic: common
 functions needed for basic A2 init/deinit hw_ops
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
 <20200430080445.1142-16-irusskikh@marvell.com>
 <20200430143037.6e063414@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <afa628eb-80c2-889c-4dc3-0fe4cd9cf80e@marvell.com>
Date:   Fri, 1 May 2020 23:39:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200430143037.6e063414@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_14:2020-05-01,2020-05-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Thu, 30 Apr 2020 11:04:43 +0300 Igor Russkikh wrote:
>> +	if (hw_atl_utils_ver_match(HW_ATL2_FW_VER_1X,
>> +				   self->fw_ver_actual) == 0) {
>> +		*fw_ops = &aq_a2_fw_ops;
>> +	} else {
>> +		aq_pr_err("Bad FW version detected: %x, but continue\n",
>> +			  self->fw_ver_actual);
>> +		*fw_ops = &aq_a2_fw_ops;
>> +	}
> 
> nit: I assume that setting fw_ops to the same value is intentional here.
>      FWIW it seems more readable when dealing with multiple versions of
>      things to use switch statements, and the default clause.

Yes, thats intentional as we assume future FW versions will be backward
compatible.

> 
> Series looks good to me otherwise.

Thanks for the review, Jakub!

  Igor
