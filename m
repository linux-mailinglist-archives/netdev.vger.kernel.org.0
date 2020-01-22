Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3B1145B4E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAVSEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:04:10 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44166 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVSEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:04:09 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00MI3K5X119400;
        Wed, 22 Jan 2020 12:03:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579716200;
        bh=+z/nBp5AZOV+zwEI+CSuqzfzPjfcbX5qgF2oJgMn8hs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=aOmDNrSM419XdFPVXOV+68wugT8QM6hPaAdpMWjldpw84tBqsSRh/m0BTBfP8IKYV
         sgEaOw9ljB76JysadaqqeqXvxSlJ+dWaeddxK4iH4HsGRTUa57rek0jZt4mpPySBF+
         FmBKGatHw9ajb62BnVAioaUJBtIw65KxJWs6kt3Q=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00MI3K8v004928
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 12:03:20 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 12:03:20 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 12:03:20 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00MI3Htj114002;
        Wed, 22 Jan 2020 12:03:18 -0600
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87v9p93a2s.fsf@linux.intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com>
Date:   Wed, 22 Jan 2020 13:10:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <87v9p93a2s.fsf@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Vinicius,

On 01/17/2020 07:03 PM, Vinicius Costa Gomes wrote:
> Hi,
> 
> Po Liu <po.liu@nxp.com> writes:
> 
>> IEEE Std 802.1Qbu standard defined the frame preemption of port
>> traffic classes. This patch introduce a method to set traffic
>> classes preemption. Add a parameter 'preemption' in struct
>> ethtool_link_settings. The value will be translated to a binary,
>> each bit represent a traffic class. Bit "1" means preemptable
>> traffic class. Bit "0" means express traffic class.  MSB represent
>> high number traffic class.
> 
> I think that we should keep the concept of 'traffic classes' outside of
> ethtool. Ethtool should only care about queues (or similar concepts).
> And unless I am missing something here, what you mean by 'traffic class'
> here is really a hardware queue.
> 
Agree.

So this is my understanding..

Once driver support FPE, then drive accepts tc gate operation,
Set-And-Hold MAC & Set-And-Release-MAC. Otherwise it can only offload
SetGateStates.

So candidates for ethtool command.

Set

- FPE enable/disable
- framePreemptionStatusTable of Table 12-30—Frame Preemption Parameter
table of 802.1Q 2018 which are defined as Read/Write. This is an array 
of Hw queues and if they are preemptible or express.
- Additionally 802.3br defines Min fragment size that is a candidate
   for ethtool command.

Show the following:-

  -  holdAdvance
  -  releaseAdvance
  -  preemptionActive
  -  holdRequest

There is also Table 12-29—The Gate Parameter Table for taprio. These
related to taprio schedule is already part of tc command. However there
are below parameters that requires configuration by user as well.
Can we use ethtool for the same as this
  - queueMaxSDUTable

Below is what I read about this which is also for hw queues AFAIK.

==== from 802.1Q====================================================
A per-traffic class queue queueMaxSDU parameter defines the maximum
service data unit size for each queue; frames that exceed queueMaxSDU 
are discarded. The value of queueMaxSDU for each queue is configurable
by management its default value is the maximum SDU size supported by the
MAC procedures employed on the LAN to which the frame is to be relayed
=======================================================================

I have question about the below parameters in The Gate Parameter Table
that are not currently supported by tc command. Looks like they need to
be shown to user for management.

     - ConfigChange - Looks like this needs to be controlled by
       user. After sending admin command, user send this trigger to start
       copying admin schedule to operation schedule. Is this getting
       added to tc command?
     - ConfigChangeTime - The time at which the administrative variables
       that determine the cycle are to be copied across to the
       corresponding operational variables, expressed as a PTP timescale
     - TickGranularity - the management parameters specified in Gate
       Parameter Table allow a management station to discover the
       characteristics of an implementation’s cycle timer clock
       (TickGranularity) and to set the parameters for the gating cycle
       accordingly.
     - ConfigPending - A Boolean variable, set TRUE to indicate that
       there is a new cycle configuration awaiting installation.
     - ConfigChangeError - Error in configuration (AdminBaseTime <
       CurrentTime)
     - SupportedListMax - Maximum supported Admin/Open shed list.

Is there a plan to export these from driver through tc show or such
command? The reason being, there would be applications developed to
manage configuration/schedule of TSN nodes that would requires these
information from the node. So would need a support either in tc or
some other means to retrieve them from hardware or driver. That is my
understanding...

Regards,

Murali
>>
>> If hardware support the frame preemption, driver could set the
>> ethernet device with hw_features and features with NETIF_F_PREEMPTION
>> when initializing the port driver.
>>
>> User can check the feature 'tx-preemption' by command 'ethtool -k
>> devname'. If hareware set preemption feature. The property would
>> be a fixed value 'on' if hardware support the frame preemption.
>> Feature would show a fixed value 'off' if hardware don't support
>> the frame preemption.
>>
>> Command 'ethtool devname' and 'ethtool -s devname preemption N'
>> would show/set which traffic classes are frame preemptable.
>>
>> Port driver would implement the frame preemption in the function
>> get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>>
>> Signed-off-by: Po Liu <Po.Liu@nxp.com>
>> ---
>>   include/linux/netdev_features.h | 5 ++++-
>>   include/uapi/linux/ethtool.h    | 5 ++++-
>>   net/core/ethtool.c              | 1 +
>>   3 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 4b19c544c59a..299750a8b414 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -80,6 +80,7 @@ enum {
>>   
>>   	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
>>   	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
>> +	NETIF_F_HW_PREEMPTION_BIT,	/* Hardware TC frame preemption */
>>   
>>   	/*
>>   	 * Add your fresh new feature above and remember to update
>> @@ -150,6 +151,7 @@ enum {
>>   #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
>>   #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
>>   #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
>> +#define NETIF_F_PREEMPTION	__NETIF_F(HW_PREEMPTION)
>>   
>>   /* Finds the next feature with the highest number of the range of start till 0.
>>    */
>> @@ -175,7 +177,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>>   /* Features valid for ethtool to change */
>>   /* = all defined minus driver/device-class-related */
>>   #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
>> -				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
>> +				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL | \
>> +				 NETIF_F_PREEMPTION)
>>   
>>   /* remember that ((t)1 << t_BITS) is undefined in C99 */
>>   #define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index d4591792f0b4..12ffb34afbfa 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -1776,6 +1776,8 @@ enum ethtool_reset_flags {
>>   };
>>   #define ETH_RESET_SHARED_SHIFT	16
>>   
>> +/* Disable preemtion. */
>> +#define PREEMPTION_DISABLE     0x0
>>   
>>   /**
>>    * struct ethtool_link_settings - link control and status
>> @@ -1886,7 +1888,8 @@ struct ethtool_link_settings {
>>   	__s8	link_mode_masks_nwords;
>>   	__u8	transceiver;
>>   	__u8	reserved1[3];
>> -	__u32	reserved[7];
>> +	__u32	preemption;
>> +	__u32	reserved[6];
>>   	__u32	link_mode_masks[0];
>>   	/* layout of link_mode_masks fields:
>>   	 * __u32 map_supported[link_mode_masks_nwords];
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index cd9bc67381b2..6ffcd8a602b8 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
>> @@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
>>   	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
>>   	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
>>   	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
>> +	[NETIF_F_HW_PREEMPTION_BIT] =	 "tx-preemption",
>>   };
>>   
>>   static const char
>> -- 
>> 2.17.1
> 

-- 
Murali Karicheri
Texas Instruments
