Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446765F4764
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJDQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiJDQUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:20:52 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00061.outbound.protection.outlook.com [40.107.0.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0974B4A7;
        Tue,  4 Oct 2022 09:20:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fot/fUyRdKu3YP7VpW82267fli07w26hmwotF4qP4xiBUn5g1v25Tamzzkob3ALvv4WflXppeMnE5VN+7fSfQaYEBTLqpqweZPi1r0IDrb/7XqoEkAzHWzyJ3+AADC4kZAeAKMUnkBRLvvhes+4W6HQRlV2wHD/FDiRW7vc8vUhq0hdjc+BeEFefUHhtwdECzHPtW6K796QKA/5jO3A/bCXvkuQzRY1qTFBngRuE7i9uPwrd/QtPrjVsYlgx4yRcVde8wSNFpaBHRnQePQGNXLtEcL5aOP19Rrbw6KSC5Zhv+7tZLUaKyx6YotL+GjtFb0iVIzB9Hw9sTgKu8cHTXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3ZVStALZWArsxlRo0pF166F4kaw1mXs2EbNZZT1czw=;
 b=DkQi+FzT5McWBVYleWC/E+xKTES0TcsdweszsYqESoMvI9tx23iqoaQUO9ufnfY3nMTG7LvDnISgRdr4XVQbh2MB+KYdEgvP+zdPN08UkX+JWITJ1tW5DbvSpQkfgN/4s4s0wMtRLNUd67rvV9BZSlZmCKW4i6Rv5/caK+OaGyJ59l6/LbDW4sMW/EYJrzIqbiytHyftRgbNDXtWLEh/AiXyIQhIjiZd9WwqSCpRMpz80kouNgyPH/EwX776mZiQV7ZfKK9z7Bx6gbrkednNRnqVadgJTP65e8CKaXDSoVG7nHMAqUGmloSU4Imj/UXUweVBgzLCNDRAgjJhiCezGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3ZVStALZWArsxlRo0pF166F4kaw1mXs2EbNZZT1czw=;
 b=yaAGTVMc61zREC5fT6oe09ug+AGT/yGB8Gkb2K8fut9F/ZkMZidOD8mqwP0z4/M3W9fX9Hzih9WyR8rayL1EpnohCJiYRWjuO7TAVuNjQznBjCIxvnjQAwWDm6jz/HtGGyJeJivEw2b1m8Bd83O0JuCFdJKkoiMAcWMMju8xLZVWmP48QtJrLKeCt6CZdOGDl4akJPTEaDBnpHeH5V4xlV4ZWvSH06Xfq+oSosfKrpIcT8Wy37Ag6WsZRiNeR60O9Zzp08wSLMA/hJmvqee+Jw5hKHZvaCmycoqO+j4AuysXqtKqXwmPuikSdoGfIfxytMXms0MyYdEYB7DBjfT/Kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV1PR03MB8126.eurprd03.prod.outlook.com (2603:10a6:150:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 16:20:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 16:20:31 +0000
Subject: Re: [PATCH net-next v6 6/9] net: dpaa: Convert to phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <20220930200933.4111249-7-sean.anderson@seco.com>
 <YzxbogPClCjNgN+m@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f5fec474-095b-2727-c0dc-878d4cd34d06@seco.com>
Date:   Tue, 4 Oct 2022 12:20:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YzxbogPClCjNgN+m@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|GV1PR03MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 48293118-49c5-488f-cd5c-08daa6245bd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qtkj5cdxqaDsv3oloY1f+RkkmvjbxfJHnwEuMu2u/+gtpC03wOWGepex55XLtUhErXRY0Vy9oZcxEwORzl0bzpNcv/Nn15A6t1jrD4+jy9X/WTyxCX4iRWFSzBJMkZHlHjcvIy3TvcOmxJaVEaqXCG1IbxyU7vu9TQzQ+4UwOAQV2bTrOZvAj3UPstqcjBUcV4m7PEsbikVBB+pLxtSFG28IciPyTVTyg3CyRJDnnaHpoSP/6cCeJimDVHKEyrXqVfob7fHRnPnjOd56PPldQplzLopAMwcjtck+meuEi2gUUGQcpJnV/ZQppmgQPGTddmPr8l1VQl3TSzLnNX82tEUywgzq/RlkRHtvcxDEfGg1IJbFOoTe75vozeSRr+qP4pPokGkiuSDZsSmxvKyBXydyvW9hJHOvtp+3R1hFDESZezD2eq5ayKSLHBiAX14/AnDJ1eHr22fVEfdOHd01hN0LZwaxf9DvQrzKpxl4/SzRoJcSK/+5dejPisEo0l4Kag4p+CTYAkK4hFuFOSOunNTeEGH1np5O9Uc4WGGqdUsbJOciT/v2bmcLx3QorTJDQGzgRMG3Vd8vHsj/xI4/Txlt05+x+0Ewv4vVSoM+UPOMDuY1jVj5XdISRjEKwbWzzHzZXfiALLa29Ba9ozV3LeRQSH6Y0hJx8uomCoPDt5+rxcQsfbDC1oW7ZKVTaWs7vtutDUKom2zrkFw+WWGHUKZMGoEjxXWvOv2fxdD+I+GYNMaMXwp0lgFJlOqkeOsQ/XPo6ueSpjkfzYNKqLxoiSfRci/R5qisuLhZmE/nE9Sjbsvk1RfvkvlwSSU4vIidtLfRO7V4Jyq8TBsfEJMMEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(346002)(396003)(376002)(366004)(451199015)(6486002)(38350700002)(86362001)(41300700001)(83380400001)(31696002)(54906003)(6512007)(38100700002)(26005)(2906002)(316002)(53546011)(6916009)(52116002)(186003)(66476007)(6666004)(36756003)(4326008)(8676002)(6506007)(66946007)(7416002)(2616005)(66556008)(44832011)(5660300002)(31686004)(8936002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MS9zZ2JVcHo1c3NFWi9sUHUyUHBFSkV4ZE94N1krdFZVMFVqU1FuaDExMlNM?=
 =?utf-8?B?dkwzbk40Skc1NzRSeVJkQ2o2SlBpT0VKZ1Q1SGVUVnVGWVNFL0xERWs2K2VS?=
 =?utf-8?B?RmFvYjh3cTBZQUpuSHhOUnFDa2tYU1FKZUpVWUJtSDdKMWQwZi80QVBLTzNs?=
 =?utf-8?B?WTRWKzJNNERKMmFPQTczcFFsajl0T1Q4SkpDd0NSaWJjdTEydTJyWEFkcUFl?=
 =?utf-8?B?SnFjVFFZc2pSRVRlanBDUXlGQ2VESEIzdXR1bncxc1NtbUxLSGNaM3BsSE4w?=
 =?utf-8?B?bDJWOWpjWE9iTE8zSlRQcUlkaFJJNDU0RWtVZTk1ZlMwNGVYeC8zaGdsQXU5?=
 =?utf-8?B?ZHZVZ0R1R2oxZmRYMjI3SmwrcmVhK3BzYTZBOHFkUEJ4TzdOb3VFVmJlRkZz?=
 =?utf-8?B?eW5jMHgyZmU3NzRERDFVd0dNcUZtdExCWXFkZDI3RzBub01RM2l6UUtORHkv?=
 =?utf-8?B?Q245YVNFR05aZGE1b2YyQWhOTW83b0ZybjAyaUVtSURWTldVcWJsVE5hTkdY?=
 =?utf-8?B?SExQc2s5UTZjTVRjaWtUNE52eFk2bisvcXRwQk4wTXFCemxHYmM3Yk9BUGZr?=
 =?utf-8?B?VkhTZDF4K3IvblhiRmxJZkZXYVgwc1daQXdrWnMwNUdPMGd5MndjRVhpM0ZQ?=
 =?utf-8?B?OWhkYUh5SWx1dlU1NUptWlRCT2k5amFCWVhSZTJMQjNCR3M0VWx2d0pDcUVs?=
 =?utf-8?B?dS9CS0t0aUsyTU1OU09Fbm5JSFVlM1hvVFBmcFpMbFM0bXZCOGViT2NFdElK?=
 =?utf-8?B?VXBEWVc4cnlsc250UVl4cmJhWWQ4M0h5NytTUXBPTWRYalh5eTM0K245a3ox?=
 =?utf-8?B?T1A2bXZmeWdUWTl5eno2cThTNXlvbVNueksvZTdQN1g4c09qZjVOS242NmVn?=
 =?utf-8?B?alo3SklRNlBwQkJkVVJiaWJLZy9pQVVzOTBaYVRTVWpDNXVpUGVTSERXSTNJ?=
 =?utf-8?B?Nm93MGFENlFrZCs3ZlZIWEhBUDFRSS84RzFLMVFMM08zUkpNVCtLNTlUdXdB?=
 =?utf-8?B?V0djUGlEQ3pxeDVuQ3VIdzlGYjZHemZ2blI2Y2hnU0tCTTRRMmZwZVMwdlVr?=
 =?utf-8?B?Q3JSTWdmQVhrQXh1Uzlscjg1cVc4cTNGYVFwQmFuNFpuVy9JZlhsNm9FdVNX?=
 =?utf-8?B?RGlvWC9kdFd0N1JFVkUxYzBOaHpndlJNR2VWRmVxZUpnZXJ6Skg0RGdBeTd3?=
 =?utf-8?B?NDdqbHUzd0ZHMjVrYVBvZWRCdXpLWTl0dEp2TnN5bU9vTzNQVnIvUGFkUGd2?=
 =?utf-8?B?OC9IdjRjOVhHd1VmYTFJQk4vZnh0dkFaVkVjMXMxMm02MmxmelpnMXRISW1F?=
 =?utf-8?B?c1YvdG1oQjN5YXk2eVJBaTFJMW1PVktXQVVqSlREakdrelBRZVUzc0t2OGhP?=
 =?utf-8?B?aEc5L1RRWGVTdlNuN1dBTTBZVkh4RmxoNkF2NWtiUWYxaUdvVkJLMG5jYWd3?=
 =?utf-8?B?czdNSThNT1pYK25seHA4YzNNMVNkL0p1bTR3N3JXMURSR084MExndmpMSUFV?=
 =?utf-8?B?N3kvY1d5TUxqZXZCcW5SOWQ0MzZpZnJBVkphYW0zeGp4SVkrcDFBMnlySmtl?=
 =?utf-8?B?aUgrUml4dnJOenpoUGNNUXhicEJtSGpTKzFqWDR2RmtEd3M1ZW9xRmhpVHBz?=
 =?utf-8?B?a0pSVy9IemZhRkdJcEhFSWV5V29CREhKUXo3NmtYc3Y1TGNKeFA5bDBCRnBX?=
 =?utf-8?B?Znk2MlFrZUtKa040SmRLOS9YR0E5R2wzT2tiZVJwWHVsK0JZSE11REdYdVZP?=
 =?utf-8?B?aURoWG9CRm9UUUYvemxZa3B6Yno4REtnQXNZWXdBeFhoM0hlWEJmVG5UTkd5?=
 =?utf-8?B?aVhBeFF0VU8vSjY0S2h6VTNrVVFZMmVoRXRJOFFMMWJRY2p4YWxqMG96OGs2?=
 =?utf-8?B?cmdaeWJjaWYySGxxTURGSXVyWVZhWG1KVjRHa2lObHh2ZjVnQ2FiTFRlcVN0?=
 =?utf-8?B?dkNtM3ZKdnZHeVZOZ2h1UjNRa2ltazNLb1M3SStYWFo4ajhIeXQzRGxWZm1s?=
 =?utf-8?B?eGhPZDh3Znl0YzhsaWZFK2JaV29MQ0RuWjNORlQ4VXZlWVdZdEZXdTF0VlpE?=
 =?utf-8?B?azYrREZTUEV4NEdtYWF5dHN1T1ZiRzVqMVdURHh3aWJFcGhMVFpsWlc5bm82?=
 =?utf-8?B?SVpRTXR0L1ZjZUI4QXdRRzBWcmFQcUszS1FzdDRnWVVrZzVnS3ZoL0xYaHNM?=
 =?utf-8?B?S2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48293118-49c5-488f-cd5c-08daa6245bd1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 16:20:31.6949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8nacqgj1N2Vm9RBZ4w3pCnblamTLGi5smMjHha8vHnSTGAPNNU0bjfXv6T7yDLVpDcKuBkkgi+Vrl8uqfMJ67w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8126
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/22 12:13 PM, Russell King (Oracle) wrote:
> On Fri, Sep 30, 2022 at 04:09:30PM -0400, Sean Anderson wrote:
>> @@ -1064,43 +1061,50 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
>>  	return pcs;
>>  }
>>  
>> +static bool memac_supports(struct mac_device *mac_dev, phy_interface_t iface)
>> +{
>> +	/* If there's no serdes device, assume that it's been configured for
>> +	 * whatever the default interface mode is.
>> +	 */
>> +	if (!mac_dev->fman_mac->serdes)
>> +		return mac_dev->phy_if == iface;
>> +	/* Otherwise, ask the serdes */
>> +	return !phy_validate(mac_dev->fman_mac->serdes, PHY_MODE_ETHERNET,
>> +			     iface, NULL);
>> +}
>> +
>>  int memac_initialization(struct mac_device *mac_dev,
>>  			 struct device_node *mac_node,
>>  			 struct fman_mac_params *params)
>>  {
>>  	int			 err;
>> +	struct device_node      *fixed;
>>  	struct phylink_pcs	*pcs;
>> -	struct fixed_phy_status *fixed_link;
>>  	struct fman_mac		*memac;
>> +	unsigned long		 capabilities;
>> +	unsigned long		*supported;
>>  
>> +	mac_dev->phylink_ops		= &memac_mac_ops;
>>  	mac_dev->set_promisc		= memac_set_promiscuous;
>>  	mac_dev->change_addr		= memac_modify_mac_address;
>>  	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
>>  	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
>> -	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
>> -	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
>>  	mac_dev->set_exception		= memac_set_exception;
>>  	mac_dev->set_allmulti		= memac_set_allmulti;
>>  	mac_dev->set_tstamp		= memac_set_tstamp;
>>  	mac_dev->set_multi		= fman_set_multi;
>> -	mac_dev->adjust_link            = adjust_link_memac;
>>  	mac_dev->enable			= memac_enable;
>>  	mac_dev->disable		= memac_disable;
>>  
>> -	if (params->max_speed == SPEED_10000)
>> -		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
>> -
>>  	mac_dev->fman_mac = memac_config(mac_dev, params);
>> -	if (!mac_dev->fman_mac) {
>> -		err = -EINVAL;
>> -		goto _return;
>> -	}
>> +	if (!mac_dev->fman_mac)
>> +		return -EINVAL;
>>  
>>  	memac = mac_dev->fman_mac;
>>  	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
>>  	memac->memac_drv_param->reset_on_init = true;
>>  
>> -	err = of_property_match_string(mac_node, "pcs-names", "xfi");
>> +	err = of_property_match_string(mac_node, "pcs-handle-names", "xfi");
> 
> While reading through the patch, I stumbled upon this - in the previous
> patch, you introduce this code with "pcs-names" and then in this patch
> you change the name of the property. I don't think this was mentioned in
> the commit message (searching it for "pcs" didn't reveal anything) so
> I'm wondering whether this name update should've been merged into the
> previous patch instead of this one?

Yes, you're right. It looks like I applied this update to the wrong
patch. Will fix for v7.

--Sean
