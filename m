Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D471C06EF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgD3Tr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:47:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgD3Tr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:47:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UJWK2k097567;
        Thu, 30 Apr 2020 15:47:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhc410ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 15:47:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UJUcMF016879;
        Thu, 30 Apr 2020 19:47:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu738v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 19:47:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UJlntH57344092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 19:47:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 574765204F;
        Thu, 30 Apr 2020 19:47:49 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.152.63])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 08C875204E;
        Thu, 30 Apr 2020 19:47:48 +0000 (GMT)
Subject: Re: [PATCH 1/1] net/mlx5: Call pci_disable_sriov() on remove
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
References: <20200430120308.92773-1-schnelle@linux.ibm.com>
 <20200430120308.92773-2-schnelle@linux.ibm.com>
 <2409e7071482b8d05447b8660abcac15987ad399.camel@mellanox.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <36de00e7-cccb-7de8-bd93-84cf647d6d39@linux.ibm.com>
Date:   Thu, 30 Apr 2020 21:47:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2409e7071482b8d05447b8660abcac15987ad399.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_12:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=804 phishscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/20 5:58 PM, Saeed Mahameed wrote:
> On Thu, 2020-04-30 at 14:03 +0200, Niklas Schnelle wrote:
>> as described in Documentation/PCI/pci-iov-howto.rst a driver with SR-
>> IOV
>> support should call pci_disable_sriov() in the remove handler.
> 
> Hi Niklas,
> 
> looking at the documentation, it doesn't say "should" it just gives the
> code as example.
> 
>> Otherwise removing a PF (e.g. via pci_stop_and_remove_bus_device())
>> with
>> attached VFs does not properly shut the VFs down before shutting down
>> the PF. This leads to the VF drivers handling defunct devices and
>> accompanying error messages.
>>
> 
> Which should be the admin responsibility .. if the admin want to do
> this, then let it be.. why block him ? 
> 
> our mlx5 driver in the vf handles this gracefully and once pf
> driver/device is back online the vf driver quickly recovers.
See my answer to your other answer ;-)
> 
>> In the current code pci_disable_sriov() is already called in
>> mlx5_sriov_disable() but not in mlx5_sriov_detach() which is called
>> from
>> the remove handler. Fix this by moving the pci_disable_sriov() call
>> into
>> mlx5_device_disable_sriov() which is called by both.
>>
>> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
>> index 3094d20297a9..2401961c9f5b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
>> @@ -114,6 +114,8 @@ mlx5_device_disable_sriov(struct mlx5_core_dev
>> *dev, int num_vfs, bool clear_vf)
>>  	int err;
>>  	int vf;
>>  
>> +	pci_disable_sriov(dev->pdev);
>> +
>>  	for (vf = num_vfs - 1; vf >= 0; vf--) {
>>  		if (!sriov->vfs_ctx[vf].enabled)
>>  			continue;
>> @@ -156,7 +158,6 @@ static void mlx5_sriov_disable(struct pci_dev
>> *pdev)
>>  	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
>>  	int num_vfs = pci_num_vf(dev->pdev);
>>  
>> -	pci_disable_sriov(pdev);
> 
> this patch is no good as it breaks code symmetry.. and could lead to
> many new issues.
Ah you're right I totally missed that there is a matching pci_enable_sriov() in
mlx5_enable_sriov() haven't used these myself before and since it wasn't in the
documentation example I somehow expected it to happen in non-driver code,
so for symmetry that would also have to move to mlx5_device_enable_sriov(),
sorry for the oversight.
> 
> 
>>  	mlx5_device_disable_sriov(dev, num_vfs, true);
>>  }
>>  
> 
