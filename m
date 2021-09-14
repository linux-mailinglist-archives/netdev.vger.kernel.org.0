Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE93940B5EF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhINRde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:33:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11136 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230019AbhINRdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:33:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EGhd4g029046;
        Tue, 14 Sep 2021 13:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aIo1TaDICCdei1g5dVPm7EpGYyAVvfgdhezR0Ptp5c0=;
 b=s7hXSBA/32Y5ktAMPYe7jo9025Kjck+fWN6v/EzWvTwx3VGbrZ7VPw/zkFshlWQwU28A
 /CZHT3M3LfXH6tc7ThNn7FIWAgHhTAmJrMfd4hy5L7VCkjf3xzK1TyhW76AB4f57CvE6
 yZHVAt47J4mbivuUfXLlgLl6ZLbGvSSGUTg1YnIvQNV1lUSTJX2sQec8YkfhSEDEpc2u
 UBhUgRqRIvp/UcEM4R5EQXkAg8+3YZP4AwCXdjE/wSck4HkMfHv9YyZWy7vdnYvzoCJM
 D1tWCAdJ4CrbxsB7S49+1NG8YJDn3FK0+gNWTNxtm4gLNP48n8QOELhpTjrhn9I2I0g7 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2ygt19er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 13:31:38 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EGhuYX029606;
        Tue, 14 Sep 2021 13:31:37 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2ygt19dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 13:31:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EHCBga013667;
        Tue, 14 Sep 2021 17:31:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3b0m39dj50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 17:31:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EHVW7T46399848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 17:31:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AC59AE051;
        Tue, 14 Sep 2021 17:31:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBDB0AE053;
        Tue, 14 Sep 2021 17:31:29 +0000 (GMT)
Received: from [9.171.20.178] (unknown [9.171.20.178])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 17:31:29 +0000 (GMT)
Message-ID: <a366c691-fb81-8e30-3853-3260ceabf080@linux.ibm.com>
Date:   Tue, 14 Sep 2021 20:31:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
Content-Language: en-US
To:     Yufeng Mo <moyufeng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, shenjian15@huawei.com,
        lipeng321@huawei.com, yisen.zhuang@huawei.com,
        linyunsheng@huawei.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, salil.mehta@huawei.com,
        linuxarm@huawei.com, linuxarm@openeuler.org, dledford@redhat.com,
        jgg@ziepe.ca, netanel@amazon.com, akiyano@amazon.com,
        thomas.lendacky@amd.com, irusskikh@marvell.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        rohitm@chelsio.com, jacob.e.keller@intel.com,
        ioana.ciornei@nxp.com, vladimir.oltean@nxp.com,
        sgoutham@marvell.com, sbhatta@marvell.com, saeedm@nvidia.com,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
 <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J9Eh5isQci_ecwaFFb4ZLD-60nRzRzVL
X-Proofpoint-GUID: wCqWvBcAe21rS4r3kVmKye1GiH9Vqur8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.21 10:35, Yufeng Mo wrote:
> In order to support more coalesce parameters through netlink,
> add two new parameter kernel_coal and extack for .set_coalesce
> and .get_coalesce, then some extra info can return to user with
> the netlink API.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---

[...]

> index 81fa36a..f2abc31 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -1619,12 +1619,14 @@ static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
>  						   void __user *useraddr)
>  {
>  	struct ethtool_coalesce coalesce = { .cmd = ETHTOOL_GCOALESCE };
> +	struct kernel_ethtool_coalesce kernel_coalesce = {};
>  	int ret;
>  
>  	if (!dev->ethtool_ops->get_coalesce)
>  		return -EOPNOTSUPP;
>  
> -	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce);
> +	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
> +					     NULL);
>  	if (ret)
>  		return ret;
>  
> @@ -1691,19 +1693,26 @@ ethtool_set_coalesce_supported(struct net_device *dev,
>  static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
>  						   void __user *useraddr)
>  {
> +	struct kernel_ethtool_coalesce kernel_coalesce = {};
>  	struct ethtool_coalesce coalesce;
>  	int ret;
>  
> -	if (!dev->ethtool_ops->set_coalesce)
> +	if (!dev->ethtool_ops->set_coalesce && !dev->ethtool_ops->get_coalesce)
>  		return -EOPNOTSUPP;
>  

This needs to be

	if (!set_coalesce || !get_coalesce)
		return -EOPNOTSUPP;

Otherwise you end up calling a NULL pointer below if just _one_ of the
callbacks is available.


> +	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
> +					     NULL);
> +	if (ret)
> +		return ret;
> +
>  	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
>  		return -EFAULT;
>  
>  	if (!ethtool_set_coalesce_supported(dev, &coalesce))
>  		return -EOPNOTSUPP;
>  
> -	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
> +	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce, &kernel_coalesce,
> +					     NULL);
>  	if (!ret)
>  		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
>  	return ret;
> 

