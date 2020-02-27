Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44020172AF1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgB0WO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:14:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgB0WO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 17:14:29 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RLwhjW090823;
        Thu, 27 Feb 2020 17:14:23 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydq6y1p7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 17:14:23 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01RLxYp2092805;
        Thu, 27 Feb 2020 17:14:23 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydq6y1p6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 17:14:23 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01RMBrKV027117;
        Thu, 27 Feb 2020 22:14:22 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2ydcmkrkpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 22:14:22 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RMELmS45875524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 22:14:21 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F0D811208E;
        Thu, 27 Feb 2020 22:14:21 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FCBC11208A;
        Thu, 27 Feb 2020 22:14:20 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.160.52.65])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Feb 2020 22:14:20 +0000 (GMT)
From:   Cris Forno <cforno12@linux.ibm.com>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH, net-next, v6, 1/2] ethtool: Factored out similar ethtool link settings for virtual devices to core
In-Reply-To: <20200226161248.GC22401@unicorn.suse.cz>
Date:   Thu, 27 Feb 2020 16:14:17 -0600
Message-ID: <m21rqf65l2.fsf@Criss-MacBook-Pro.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_07:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1011 mlxscore=0 adultscore=0 impostorscore=0
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002270146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Kubecek <mkubecek@suse.cz> writes:

> On Tue, Feb 25, 2020 at 03:41:10PM -0600, Cris Forno wrote:
>> Three virtual devices (ibmveth, virtio_net, and netvsc) all have
>> similar code to get link settings and validate ethtool command. To
>> eliminate duplication of code, it is factored out into core/ethtool.c.
>> 
>> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
>> ---
> [...]
>> +int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
>> +				       const struct ethtool_link_ksettings *cmd,
>> +				       u32 *dev_speed, u8 *dev_duplex,
>> +				       bool (*dev_virtdev_validate_cmd)
>> +				       (const struct ethtool_link_ksettings *))
>> +{
>> +	bool (*validate)(const struct ethtool_link_ksettings *);
>> +	u32 speed;
>> +	u8 duplex;
>> +
>> +	validate = dev_virtdev_validate_cmd ?: ethtool_virtdev_validate_cmd;
>> +	speed = cmd->base.speed;
>> +	duplex = cmd->base.duplex;
>> +	/* don't allow custom speed and duplex */
>> +	if (!ethtool_validate_speed(speed) ||
>> +	    !ethtool_validate_duplex(duplex) ||
>> +	    !(*validate)(cmd))
>> +		return -EINVAL;
>> +	*dev_speed = speed;
>> +	*dev_duplex = duplex;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(ethtool_virtdev_set_link_ksettings);
>
> I didn't realize it when I asked about netvsc_validate_ethtool_ss_cmd() 
> while reviewing v5 but after you got rid of it, all three callers of
> ethtool_virtdev_set_link_ksettings() call it with NULL as validator,
> i.e. use the default ethtool_virtdev_validate_cmd().
>
> This brings a question if we really need the possibility to provide
> a custom validator function. Do you think we should expect some driver
> needing a custom validator function soon? If not, we should probably use
> the default validation unconditionally for now and only add the option
> to provide custom validator function when (if) there is use for it.
>
> Michal
I agree, we do not need the custom validator function pointer parameter
in the set_link_ksettings function since it is currently not needed. The
parameter will be removed in v7. Thanks again Michal!

--Cris Forno

