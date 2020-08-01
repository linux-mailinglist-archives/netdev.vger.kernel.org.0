Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD92235124
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgHAIWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 04:22:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbgHAIWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 04:22:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0718IqgI004542;
        Sat, 1 Aug 2020 01:22:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=XqEtR3x1VPexE1EnmCDj+BCx4QraJTnq71uao4TBCjA=;
 b=y6dLE0bte4enUrc9OMnY77g469ErfmbNr0DwanAIHzjjx7fXBBKU1dCc5Ak5+q7GLHKY
 5C2EEBr2ZoRa2x/wv7hdQqqjJWTDdWE7nuYBTrDlLfjdBZ6Q0MvMbc+ZFaxbb5iqsI3y
 WtaQA2wuwUIxJIhRz1f5hNH+gKGvORR4FboZ7D8bCoeTy0u+roX9dhxH6j0p9pxTr9LA
 EPUvwEWuwIVot1ZdFauSSw1bP+bN2RTYCEpXf/YawxljZw2nOwcD1c7xcUOOQ5ontUYB
 OfDBny8YkIcENOCGwgAAt3nPWQpYRvJFLKS76SLPBL0fBRiMUirunYd21DjkKGeisEDa fw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3re3kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Aug 2020 01:22:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 1 Aug
 2020 01:22:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 1 Aug 2020 01:22:30 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 040053F703F;
        Sat,  1 Aug 2020 01:22:26 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 04/10] qed: implement devlink info request
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Alexander Lobakin" <alobakin@marvell.com>
References: <20200731055401.940-1-irusskikh@marvell.com>
 <20200731055401.940-5-irusskikh@marvell.com>
 <20200731130402.2288f44a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <1a454a82-98a8-d08a-7769-f4dd02658e51@marvell.com>
Date:   Sat, 1 Aug 2020 11:22:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <20200731130402.2288f44a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-01_07:2020-07-31,2020-08-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Thus, here we create and store a private copy of this structure
>> in qed_dev root object.
> 
> Please include example output of devlink info on you device.

Hi Jakub, will do. Here is an example:

~$ sudo ~/iproute2/devlink/devlink  dev info
pci/0000:01:00.0:
  driver qed
  serial_number REE1915E44552
  versions:
      running:
        fw 8.42.2.0
      stored:
        fw.mgmt 8.52.10.0
pci/0000:01:00.1:
  driver qed
  serial_number REE1915E44552
  versions:
      running:
        fw 8.42.2.0
      stored:
        fw.mgmt 8.52.10.0


>> +	memcpy(buf, cdev->hwfns[0].hw_info.part_num,
> sizeof(cdev->hwfns[0].hw_info.part_num));
>> +	buf[sizeof(cdev->hwfns[0].hw_info.part_num)] = 0;
> 
> Part number != serial number. What's the thing you're reporting here
> actually identifying.

From user manual and configuration point of view thats a serial number.
Existing internal structures name that as part number, double checked
the documentation - in this hardware manual these two things are the same.

> DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
>> +	if (err)
>> +		return err;
> 
> Assuming MFW means management FW - this looks good.
>> +	return devlink_info_version_running_put(req,

Right,

> DEVLINK_INFO_VERSION_GENERIC_FW, buf);
> 
> But what's this one?

This one is a fast path firmware which is being loaded from driver
dynamically. I can put this explanation to the patch description.

Regards
  Igor
