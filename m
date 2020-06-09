Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD01F380F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 12:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgFIKZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 06:25:29 -0400
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:35136
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727005AbgFIKYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 06:24:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gf0m9cHuULj6TbTovD9tRnOoifc1mt3F4CURkJlO0iP4c7CUzUwJ7znZol8Rv9ch43zpmYIzTYHuAhTrgrTUZ9nb5+gOglw8MkPhykErs8QHKcxH73a6//EfRltM/0MGEIE9EN5WPJZP+X3DDVauvKi8si96/c3k2YDtue6P78JQd2sIhkDUegeGvYRC7zhX9LzcWQo3Y2cT/Qqlc7soZzTsiCj1LRRdjxVL/hGfLx/hvHbnO6JV5SOh4KeZRSAUyHp2wxOP0+5TsP4hMNQxPd8uxkYkz/VHkYyre43s8ObiVLc2Dv4buIyEaT2aKVMwgbnt6xzqy8aDmDdHHMTskA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pcau/R/sOQ5paeaxLUz/+UWvYXwVCPchZhPYxlkeZ2s=;
 b=aTqlryPQQNYF6uLNYXZ2GcZ/vTmENgaPOchLdwfAwTGqKGNlOl4Rin689FvDxQIDvQO6OuI8qj43vJU1Qg/rWMcDb67wqO+QI8jKy1wSHDRaJXPaSWUq+R3cISFj89LZOvMfh72dWOxJtP7VrURjL3QF2XY8s+OffKLP27NLioRKhi4HmFlUpcno1OE7s/JRemb/06SF+DWeljDLgHrz2Ghnhwxmuv68gdUKirGJJ29RyZ3YCm66mw+MSt066ie1++ncD6qqhG6jgMx2OoQQDPx4/zm1pHt4IMREPFI8bAFxfX1sS8+Y528QBJa5Am+ZdMShYChwy5CT66ALVlQYQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pcau/R/sOQ5paeaxLUz/+UWvYXwVCPchZhPYxlkeZ2s=;
 b=DbsE8mER10TIoYKkoMcg9OmJOduWNHca5pV1RxC5iXn4eA91MZu7YrqNT6DG40K2ARTBFNtHgYwp4m4Pi0qzF4FvTkEze6kdKVwAQAuDJ3XIcpYtfjVHEgzDtdLsMi539atEO7j/dJoM2/DcgSRBHv5HyOoTzPAxPKAF/R1I0Aw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB3843.eurprd05.prod.outlook.com
 (2603:10a6:208:1f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19; Tue, 9 Jun
 2020 10:24:29 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 10:24:29 +0000
Subject: Re: [RFC PATCH net-next 04/10] ethtool: Add link extended state
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
 <611379f0-b4eb-d3b3-383d-57d6e1373320@gmail.com>
From:   Amit Cohen <amitc@mellanox.com>
Message-ID: <0057669a-ff3c-f44b-00a5-276244527968@mellanox.com>
Date:   Tue, 9 Jun 2020 13:24:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <611379f0-b4eb-d3b3-383d-57d6e1373320@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::22) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.7] (87.68.150.248) by AM0P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23 via Frontend Transport; Tue, 9 Jun 2020 10:24:26 +0000
X-Originating-IP: [87.68.150.248]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4923e4a-94be-4f15-397d-08d80c5f4aac
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3843:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3843B8B1CD2E6BC8EFD19FAED7820@AM0PR0502MB3843.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 042957ACD7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0nfs1yrO//rTiLqhE7X69Z6bq5EMgiXrGpw1BrjXTNTsvPcgHiRRPnuJ3QwNhXTzj0zHT7HewGe1EpKlEvyrreERSYB4O/u9L27THp5TLmaXYB+KrAaMNDixiPQtGJiwrHr1KGVHXXw1EoQr97E19orUuCOXs4xv6maX+FiVlWXchktgEEHEKCzH4JSr0qs991h0U0KG6B9oacxWZ0fuw3/X+zwgCmzJ978AXfC8kSlKl8hvK2DfGlI3qNRYwarYTUZ38ycVFepNsrVZR+LylHiPVGdVBK+x3U1sYMmDT3T39gbLCarHYxX5kuQPGSAIRH+cpswn7Nh3s+X0GVXKG8D3VajimMs6M1Rp5GtkaLiwz6WwwvXvHh41ZCf9nUN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(52116002)(66946007)(478600001)(5660300002)(2906002)(66476007)(53546011)(316002)(31686004)(31696002)(66556008)(16526019)(86362001)(26005)(8936002)(16576012)(6486002)(8676002)(186003)(4326008)(83380400001)(2616005)(36756003)(956004)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OLN08M0j5TrixDwPvKfpItpeLR+fxHzCT2cn5DknSjAmRlLQsXjX5HXWYpQ02w/aWgFBanA1LoeAzmvZ8N1I3sZkXxvl759RwbcBG+MeDai5F+sNOwhI/51K9Uka86InS5QAY3zvObI/7kHxOf8P9Su0/QsyYeTLEmBbXZ7aNHLiEnZN0LY+MM7mKXJeRN5Id01IneTjQDZMGPmic5bVVQL9tqtQ3qU7jlgoxY3F/z+qVv/YmMlucDR2sSynTieYWyfxGgrP7VmEuezieuY45/AyxPIBr9+iIGgStesPvq1+XEAp93bFjHl26FJWvQK2pw8csEaA8/uS5BRv834lDPO6XIWPnaiYXmSfHMVPRMPdJc+S/UyPHBL3GoNyYxz/Oi1tuScEyyobd7SFCqqbmwsPkMcDlJLxf/OLk+O8vGN2cO1fwsaAJbpO9qBaOP/oXdoyyIS8cJuLr0Z+w1ar0Nvn/WiUTTb3gA1QGJ6/LWKrIhJeep/0zZKZnncB/8oM
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4923e4a-94be-4f15-397d-08d80c5f4aac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2020 10:24:29.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzKU6RATYhYoZwOvq51kJIUQFPGv+E6w/Z7cO0nqPUqQV3ihWDDgkq9kD5s2iVOp4GKDGOKzNEsVmZ3AbPPW4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3843
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-Jun-20 21:17, Florian Fainelli wrote:
> 
> 
> On 6/7/2020 7:59 AM, Amit Cohen wrote:
>> Currently, drivers can only tell whether the link is up/down using
>> LINKSTATE_GET, but no additional information is given.
>>
>> Add attributes to LINKSTATE_GET command in order to allow drivers
>> to expose the user more information in addition to link state to ease
>> the debug process, for example, reason for link down state.
>>
>> Extended state consists of two attributes - ext_state and ext_substate.
>> The idea is to avoid 'vendor specific' states in order to prevent
>> drivers to use specific ext_state that can be in the future common
>> ext_state.
>>
>> The substates allows drivers to add more information to the common
>> ext_state. For example, vendor can expose 'Autoneg failure' as
>> ext_state and add 'No partner detected during force mode' as
>> ext_substate.
>>
>> If a driver cannot pinpoint the extended state with the substate
>> accuracy, it is free to expose only the extended state and omit the
>> substate attribute.
>>
>> Signed-off-by: Amit Cohen <amitc@mellanox.com>
>> Reviewed-by: Petr Machata <petrm@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/linux/ethtool.h              | 22 +++++++++
>>  include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
>>  include/uapi/linux/ethtool_netlink.h |  2 +
>>  net/ethtool/linkstate.c              | 40 ++++++++++++++++
>>  4 files changed, 134 insertions(+)
>>
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index a23b26eab479..48ec542f4504 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -86,6 +86,22 @@ struct net_device;
>>  u32 ethtool_op_get_link(struct net_device *dev);
>>  int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
>>  
>> +
>> +/**
>> + * struct ethtool_ext_state_info - link extended state and substate.
>> + */
>> +struct ethtool_ext_state_info {
>> +	enum ethtool_ext_state ext_state;
>> +	union {
>> +		enum ethtool_ext_substate_autoneg autoneg;
>> +		enum ethtool_ext_substate_link_training link_training;
>> +		enum ethtool_ext_substate_link_logical_mismatch link_logical_mismatch;
>> +		enum ethtool_ext_substate_bad_signal_integrity bad_signal_integrity;
>> +		enum ethtool_ext_substate_cable_issue cable_issue;
>> +		int __ext_substate;
>> +	};
>> +};
>> +
>>  /**
>>   * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
>>   * @index: Index in RX flow hash indirection table
>> @@ -245,6 +261,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>>   * @get_link: Report whether physical link is up.  Will only be called if
>>   *	the netdev is up.  Should usually be set to ethtool_op_get_link(),
>>   *	which uses netif_carrier_ok().
>> + * @get_ext_state: Report link extended state. Should set ext_state and
>> + *	ext_substate (ext_substate of 0 means ext_substate is unknown,
>> + *	do not attach ext_substate attribute to netlink message). If not
>> + *	implemented, ext_state and ext_substate will not be sent to userspace.
> 
> For consistency with the other link-related operations, I would name
> this get_link_ext_state.
> 

ok.

>>   * @get_eeprom: Read data from the device EEPROM.
>>   *	Should fill in the magic field.  Don't need to check len for zero
>>   *	or wraparound.  Fill in the data argument with the eeprom values
>> @@ -384,6 +404,8 @@ struct ethtool_ops {
>>  	void	(*set_msglevel)(struct net_device *, u32);
>>  	int	(*nway_reset)(struct net_device *);
>>  	u32	(*get_link)(struct net_device *);
>> +	int	(*get_ext_state)(struct net_device *,
>> +				 struct ethtool_ext_state_info *);
>>  	int	(*get_eeprom_len)(struct net_device *);
>>  	int	(*get_eeprom)(struct net_device *,
>>  			      struct ethtool_eeprom *, u8 *);
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index f4662b3a9e1e..830fa0d6aebe 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -579,6 +579,76 @@ struct ethtool_pauseparam {
>>  	__u32	tx_pause;
>>  };
>>  
>> +/**
>> + * enum ethtool_ext_state - link extended state
>> + */
>> +enum ethtool_ext_state {
>> +	ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
>> +	ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
>> +	ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
>> +	ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY,
>> +	ETHTOOL_EXT_STATE_NO_CABLE,
>> +	ETHTOOL_EXT_STATE_CABLE_ISSUE,
>> +	ETHTOOL_EXT_STATE_EEPROM_ISSUE,
> 
> Does the EEPROM issue would indicate for instance that it was not
> possile for the firmware/kernel to determine what transceiver
> capabilities are supported from e.g.: a SFP or SFF EEPROM, and therefore
> the link state could be down because of that. Is this the idea?
> 

We get this reason from firmware if the cable identifier is not spec compliant, missing or was not able to be read on time (I2C reading issue). 


>> +	ETHTOOL_EXT_STATE_CALIBRATION_FAILURE,
>> +	ETHTOOL_EXT_STATE_POWER_BUDGET_EXCEEDED,
>> +	ETHTOOL_EXT_STATE_OVERHEAT,
>> +};
>> +
>> +/**
>> + * enum ethtool_ext_substate_autoneg - more information in addition to
>> + * ETHTOOL_EXT_STATE_AUTONEG_FAILURE.
>> + */
>> +enum ethtool_ext_substate_autoneg {
>> +	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
>> +	ETHTOOL_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
>> +	ETHTOOL_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
>> +	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
>> +	ETHTOOL_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
>> +	ETHTOOL_EXT_SUBSTATE_AN_NO_HCD,
>> +};
>> +
>> +/**
>> + * enum ethtool_ext_substate_link_training - more information in addition to
>> + * ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE.
>> + */
>> +enum ethtool_ext_substate_link_training {
>> +	ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
>> +	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
>> +	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
>> +	ETHTOOL_EXT_SUBSTATE_LT_REMOTE_FAULT,
>> +};
> 
> OK, so we leave it to the driver to report link sub-state information
> that is relevnt to the supported/avertised link modes, such that for
> instance, reporting LT_KR_FRAME_LOCK_NOT_ACQUIRED would not happen if we
> were only advertising 1000baseT for instance. That sounds fair.
> 

