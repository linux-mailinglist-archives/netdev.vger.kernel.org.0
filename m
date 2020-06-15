Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991D71F9434
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 12:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgFOKC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 06:02:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728833AbgFOKC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 06:02:58 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F84Cte005797;
        Mon, 15 Jun 2020 06:02:56 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31p54p38pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 06:02:48 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9pEHL014957;
        Mon, 15 Jun 2020 10:01:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 31mpe81b0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 10:01:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FA1WJi42598536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 10:01:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE3E65205F;
        Mon, 15 Jun 2020 10:01:32 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.75.207])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5CDCB52050;
        Mon, 15 Jun 2020 10:01:32 +0000 (GMT)
Subject: Re: [REGRESSION] mlx5: Driver remove during hot unplug is broken
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com, raspl@de.ibm.com
References: <f942d546-ee7e-60f6-612a-ae093a9459a5@linux.ibm.com>
 <7660d8e0d2cb1fbd40cf89ea4c9a0eff4807157c.camel@mellanox.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <26dedb23-819f-8121-6e04-72677110f3cc@linux.ibm.com>
Date:   Mon, 15 Jun 2020 12:01:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7660d8e0d2cb1fbd40cf89ea4c9a0eff4807157c.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 cotscore=-2147483648 mlxscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Saeed,

On 6/13/20 12:01 AM, Saeed Mahameed wrote:
> On Fri, 2020-06-12 at 15:09 +0200, Niklas Schnelle wrote:
>> Hello Parav, Hello Saeed,
>>
... snip ...
>>
>> So without really knowing anything about these functions I would
>> guess that with the device still registered the drained
>> queue does not remain empty as new entries are added.
>> Does that sound plausible to you?
>>
> 
> I don't think it is related, maybe this is similar to some issues
> addressed lately by Shay's patches:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20200611224708.235014-2-saeedm@mellanox.com/
> https://patchwork.ozlabs.org/project/netdev/patch/20200611224708.235014-3-saeedm@mellanox.com/
> 
> net/mlx5: drain health workqueue in case of driver load error
> net/mlx5: Fix fatal error handling during device load

I agree with your similarity assessment especially for the first commit.
These do not fix the issue though, with mainline v5.8-rc1 which has
both I'm still getting a hang over 50% of the time with the following
detach sequence on z/VM:

vmcp detach pcif <mlx_fid>; echo 1 > /proc/cio_settle

Since now the commit 41798df9bfca ("net/mlx5: Drain wq first during PCI device removal")
no longer reverts cleanly I used the following diff to move the mlx5_drain_health_wq(dev)
after the mlx5_unregister_devices(dev).

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b658908f044..63a196fd8e68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1382,8 +1382,8 @@ static void remove_one(struct pci_dev *pdev)

        devlink_reload_disable(devlink);
        mlx5_crdump_disable(dev);
-       mlx5_drain_health_wq(dev);
        mlx5_unload_one(dev, true);
+       mlx5_drain_health_wq(dev);
        mlx5_pci_close(dev);
        mlx5_mdev_uninit(dev);
        mlx5_devlink_free(devlink);


Note that this changed order also matches the call order in mlx5_pci_err_detected().
With that change I've now done over two dozen detachments with varying time between
attach and detach to have the driver at different stages of initialization.
With the change all worked without a hitch.

Best regards,
Niklas Schnelle
> 
>> Best regards,
>> Niklas Schnelle
>>
>> [0] dmesg output:
... snip ...
> 
> Shay's patches also came to avoid such command timeouts.
> 
> 
