Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E81132D60
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgAGRqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:46:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728434AbgAGRqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:46:03 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007HelEa005623;
        Tue, 7 Jan 2020 12:46:00 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xcu56r062-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 12:46:00 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 007HfRRs008543;
        Tue, 7 Jan 2020 12:46:00 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xcu56r05q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 12:46:00 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 007HhrHX010027;
        Tue, 7 Jan 2020 17:46:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2xajb6d5cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 17:46:05 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 007HjvPV56951196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jan 2020 17:45:58 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6C696E052;
        Tue,  7 Jan 2020 17:45:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 303646E04C;
        Tue,  7 Jan 2020 17:45:57 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.24.11.154])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jan 2020 17:45:56 +0000 (GMT)
Subject: Re: [PATCH, net-next, v3, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com>
 <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
 <CA+FuTSeJ_3T5K3NrZnqcG6qadOHsoqKRt_ZMPM=fqUqJknDP_Q@mail.gmail.com>
From:   Cristobal Forno <cforno12@linux.vnet.ibm.com>
Message-ID: <87200f46-b04a-2741-dbe7-fa9260adfb79@linux.vnet.ibm.com>
Date:   Tue, 7 Jan 2020 11:45:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeJ_3T5K3NrZnqcG6qadOHsoqKRt_ZMPM=fqUqJknDP_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001070140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestions Willlem. I have a question on one of your 
suggestions for the ethtool_virtdev_get_link_ksettings function below.

On 22/12/2019 15:19, Willem de Bruijn wrote:
> On Thu, Dec 19, 2019 at 3:54 PM Cris Forno <cforno12@linux.vnet.ibm.com> wrote:
>> Three virtual devices (ibmveth, virtio_net, and netvsc) all have
>> similar code to set/get link settings and validate ethtool command. To
>> eliminate duplication of code, it is factored out into core/ethtool.c.
>>
>> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
>> ---
>>   include/linux/ethtool.h |  2 ++
>>   net/core/ethtool.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 60 insertions(+)
>>
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 95991e43..1b0417b 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -394,6 +394,8 @@ struct ethtool_ops {
>>                                            struct ethtool_coalesce *);
>>          int     (*set_per_queue_coalesce)(struct net_device *, u32,
>>                                            struct ethtool_coalesce *);
>> +       bool    (*virtdev_validate_link_ksettings)(const struct
>> +                                                  ethtool_link_ksettings *);
>>          int     (*get_link_ksettings)(struct net_device *,
>>                                        struct ethtool_link_ksettings *);
>>          int     (*set_link_ksettings)(struct net_device *,
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index cd9bc67..4091a94 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
>> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>>          return 0;
>>   }
>>
>> +/* Check if the user is trying to change anything besides speed/duplex */
>> +static bool
>> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> If called from other modules like drivers/net/virtio_net.ko, these
> functions cannot be static, need a declaration in
> include/linux/ethtool.h and an EXPORT_SYMBOL_GPL.
>
> Also return type should be on the same line.
Good point, I will incorporate this into the next version of the series.
>
>> +{
>> +       struct ethtool_link_ksettings diff1 = *cmd;
>> +       struct ethtool_link_ksettings diff2 = {};
>> +
>> +       /* cmd is always set so we need to clear it, validate the port type
>> +        * and also without autonegotiation we can ignore advertising
>> +        */
>> +       diff1.base.speed = 0;
>> +       diff2.base.port = PORT_OTHER;
>> +       ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
>> +       diff1.base.duplex = 0;
>> +       diff1.base.cmd = 0;
>> +       diff1.base.link_mode_masks_nwords = 0;
>> +
>> +       return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
>> +               bitmap_empty(diff1.link_modes.supported,
>> +                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>> +               bitmap_empty(diff1.link_modes.advertising,
>> +                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>> +               bitmap_empty(diff1.link_modes.lp_advertising,
>> +                            __ETHTOOL_LINK_MODE_MASK_NBITS);
>> +}
>> +
>>   /* convert a kernel internal ethtool_link_ksettings to
>>    * ethtool_link_usettings in user space. return 0 on success, errno on
>>    * error.
>> @@ -660,6 +686,17 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
>>          return store_link_ksettings_for_user(useraddr, &link_ksettings);
>>   }
>>
>> +static int
>> +ethtool_virtdev_get_link_ksettings(struct net_device *dev,
>> +                                  struct ethtool_link_ksettings *cmd,
>> +                                  u32 *speed, u8 *duplex)
> No need to pass by reference, really. Indeed, the virtio_net caller
> passes vi->speed and vi->duplex instead of &vi->speed and &vi->duplex.
Agreed.
>
> More fundamentally, these three assignments are simple enough that I
> don't think a helper actually simplifies anything here.

Although the function is simple, it does achieve the goal of this 
version of the patch series which is to eliminate duplication of code 
throughout the virtual devices. I think it's best to leave it like this, 
but I am open to more suggestions.

-Cris Forno

>
>
>
>> +{
>> +       cmd->base.speed = *speed;
>> +       cmd->base.duplex = *duplex;
>> +       cmd->base.port = PORT_OTHER;
>> +       return 0;
>> +}
>> +
>>   /* Update device ethtool_link_settings. */
>>   static int ethtool_set_link_ksettings(struct net_device *dev,
>>                                        void __user *useraddr)
>> @@ -696,6 +733,27 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
>>          return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
>>   }
>>
>> +static int
>> +ethtool_virtdev_set_link_ksettings(struct net_device *dev,
>> +                                  const struct ethtool_link_ksettings *cmd,
>> +                                  u32 *dev_speed, u8 *dev_duplex)
>> +{
>> +       u32 speed;
>> +       u8 duplex;
>> +
>> +       speed = cmd->base.speed;
>> +       duplex = cmd->base.duplex;
>> +       /* don't allow custom speed and duplex */
>> +       if (!ethtool_validate_speed(speed) ||
>> +           !ethtool_validate_duplex(duplex) ||
>> +           !dev->ethtool_ops->virtdev_validate_link_ksettings(cmd))
>> +               return -EINVAL;
>> +       *dev_speed = speed;
>> +       *dev_duplex = duplex;
>> +
>> +       return 0;
>> +}
>> +
>>   /* Query device for its ethtool_cmd settings.
>>    *
>>    * Backward compatibility note: for compatibility with legacy ethtool, this is
>> --
>> 1.8.3.1
>>
