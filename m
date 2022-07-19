Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1357A759
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiGSTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGSTlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:41:13 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130041.outbound.protection.outlook.com [40.107.13.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D481A04B;
        Tue, 19 Jul 2022 12:41:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ez9y51jlXdVC+4b25TuuUbebBoAOOaWuoKDYXG9z62QANAUm3ecg4NyV4wHdbqYQ4X2NFrMVswK/gcp7h19mRw1BcX8/OpwoOU++izHf+dMA482HDXajHLrKJS3KWJvin3lOoilVTIvLeD963wb/ynvkZKy4fwVBPfK6SYBab+BymVD6qCd9Bv0ay5aZLLP09M7nLjHJQceQfVdmAb+8NFc6K5nhI3zewLF+0wyuk7gs1PmATcXW4hLpSWY7Yz03TlwekuSUZgdVG2k/UkrA1k2Qguswx7HVIHVbg/jTXXZ38hwzqhejOPYIsEs6Rz+EfVYbU4q6YdF7n/89MCzGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1tkZDg7i48L7YL/vUAuiMsrlbgFrgcQN+UOstHZzhk=;
 b=cztzi/UI4Jf+1dqF3Hwig3175PguVka6yqLfG7tvKJ3pf2MfrWmR59H7tFmec910lCRQ8csgMWJ3lIblCeyYL8r6jWiypsS60u/qvJWXhcm6pghcyeIPLertqCOQO5TyH6r/UBieGUPLi/eRNPRcT7zVPg06uesmPKgbZcjIq+l3a2WVbLZ9QUGPUQmp0+cB/bt7c+1Gd/nHic2UPu7tf1OWTvNurKECC6gCnIakJlyjKw6hiEYkj8+9W4m4VoKGtneJ99l99E1SHVE0S0kZW+4tAfzK9LoOUs0eHDpeul9v/FPK83toYevx3RoCOsvEUPZ+aF4Ygb9rFLGbpqWTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1tkZDg7i48L7YL/vUAuiMsrlbgFrgcQN+UOstHZzhk=;
 b=rdSr7Yw+vyLzRLy7jMrjo7rA5ixDaJwT8EZzch74oM8Hpvw7ESN1naKdPmv3ZpCXTUo0BO74HPGbXBzmc/4bIKlX7mHlTd/rx7xn22M3NuMIzXI+qHv/wd5FVyNZcpAFsXN5JDVWwsh9d52R/fTbrKCHL6rJLVfZ8l4NJ+flfifsJF7e4txTxWPvl3ZLoy8WZBmCmPFp1HNJ2wVN4B4divqKAo1tC1Ii7ogIbbrdELnhasyzwRCYakWeoUZErkPhwQDl+ZGl071DRQBRYRrwb0V9uyWJCMmJjiJdcY8PHBxQFbU/xaTRY6zpwE8Vdl8MKgloScHG2eHkhYCLUPTvTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3916.eurprd03.prod.outlook.com (2603:10a6:5:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 19:41:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 19:41:08 +0000
Subject: Re: [RFC PATCH net-next 5/9] net: pcs: lynx: Use pcs_get_by_provider
 to get PCS
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-6-sean.anderson@seco.com>
 <20220719172628.vkkrarx5zkiyumze@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <7ff1cb04-fc3b-853e-ea8f-0c0b62bbd8c9@seco.com>
Date:   Tue, 19 Jul 2022 15:41:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220719172628.vkkrarx5zkiyumze@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0021.namprd12.prod.outlook.com
 (2603:10b6:208:a8::34) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2432b2d-2af1-42bf-0d7d-08da69bea03c
X-MS-TrafficTypeDiagnostic: DB7PR03MB3916:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iHX8+yCAqy6rgodMCZNgqHtrBbkHgeWDHqTmnUrRqY1BKfNk02bS3UhiUr099pxf3Xei5hercSbf5Y2zB9NS/o69sD8zI+S5tGyRN6SsFlyNjNgaj6zl+3YuFxdOSHSf6oVe4THe40eE1Yla/rSSov8WZ9I9KN70sDPCsqQ/DhKq5Ge0XrUPCJTOHIMEVAStaShsY5q0L/xNKaKN81j7mtcGnBqONM1zM3eK+5MtzQelP487NQDjCbk/8YM+yIDy0FWq+BUN5DC2kOZDS6KDckLjM8AxIV+T2MO41RWPuv3n93riZrCC7yKJrIvDFQq+bjCcpTjneYqVI4iKs/Rnyuvsp/TSqZBJnnkbrKB6ZgPQzTQOc9RURLPcmEWzw8YT3b23b0ACA9ag+3vDAeDZIkbfR+nlqop9TlFCGL3pfwwusrjZtRtmau3LcBx2yyadwBFRBB3uIAEz0bu8vX5gTEArHBlEVJxpIrSh5+LkWqfTyFtm+LsDdQuwEXqw/UepqdTbSxGmab2RGApqGYqekB9OYaSqrjXVBd5bywazFjChUrC+F38gIYxiWU+xSxVY7K2uGv5Z2I3isLyZVajZoL5ovkLwsStJlhdcT3TRLV6+U28s3kFGwaNyjuL8MecbyPOQLmQVKMsxdhC0CWkBftqjUFtgNSKABz+KiZ4z0yqwDx2ZUNB6sNwBJNRyphow6h3s+6yJX/NEj2spi9oPddu5FEiM+WVfikrX1RpfenJIVCShmpavIF3XJ3c7wFR1jK5qJUNBmB8OH74j3XpOqaPxVVIPvEukvgkLDg5AXE8SHYL3l6FKVmiAcxroyeSOM+16TASvIqT0fgVcQDqv3NHWw/uiUipF854yozjuFtnMFP++FtIT4CVWgXWjU+45
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(366004)(346002)(39850400004)(6506007)(4326008)(6916009)(5660300002)(66476007)(7416002)(54906003)(8936002)(316002)(66556008)(44832011)(66946007)(8676002)(83380400001)(2906002)(86362001)(31686004)(38350700002)(31696002)(38100700002)(36756003)(6666004)(52116002)(26005)(41300700001)(6512007)(53546011)(6486002)(478600001)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHNtVFA5RzJqN3FxVTE4ZHd6MFRIak4zV3E1R0F2WG1yQkUyUHg3djZ2aHVa?=
 =?utf-8?B?VUgzcngxa2l1OTE3UVMxWE1CWDdIVTZiY3Jsc3pYckJqMk4vY1dkSkRHNHRX?=
 =?utf-8?B?T1Z0cmIvVit4emZGNzhXSHZ1ZEpmUlFwSk5PcEhsN0RxK1R1SXlXai9xNlN0?=
 =?utf-8?B?cGtZekJUMHJ5ekEwZnBQdjRBQWdWMEZQVHF1dHBIRXpKVy9jZmUzK3BhdHhY?=
 =?utf-8?B?Sm1JRlY3cWROaW1pRkdjdFlQcVVyNTJhUitRUXhGcHdsUXpTbTJETXNBT2Vu?=
 =?utf-8?B?aktESlNxZHlOT2F3REdWTWNIaWpNcWZvZEZ1M2ZyTkdmY0lNckNaWWJBUXBs?=
 =?utf-8?B?NzZjb01RTDMxamRuaDFsQnZNNHR1Qkg2UjBTZW9GVDRhdGsyYVRXdUJPQUlG?=
 =?utf-8?B?RVZTeVJlWFdZcFdmUkN4K09tUmJvMDhjZnJnSWlwakNTbWVkQlhQZmFCUlFD?=
 =?utf-8?B?N2tBUDk0VENGU1BiZVh3UVRXYUx3dkRxQ3FtekppdmkrSVhpME5heFp4NGFM?=
 =?utf-8?B?N1RJaDBHaFdFV205MjNYYVhydkM2MVovVzlxZEt3dUtoRVZKaDJwaThOakMv?=
 =?utf-8?B?UHFDdVRydzZiaDg5OElWK0IyaVh6RS9kSnlJODVNYWwwVUdUbHZpbWxDbHFu?=
 =?utf-8?B?MTFHc3RMa0lmb3g2OWo5dUVsalJMd3hBL2VocHhyVC9HUktpNkI3RWxFUXNz?=
 =?utf-8?B?THMyUmxSU29lbkFiL0MzdFJNNHpDdE9IRml5OXowQUxpSHdFMnB4dmtFam8x?=
 =?utf-8?B?MDFFRDExaDdrem9sbWsyVCtaQjcxelRJT0NWdTZlZGxtb0R1ZnVkY2llTnJV?=
 =?utf-8?B?T1F6M0ttdVUxdjYyUFJ0WW85dEZBcWJFb0REdVNpS0lPUmdlVTJiVEFWa3pG?=
 =?utf-8?B?ZmhtY3YzOHZ2Q0VDMzZqN04vRDlnbURLbUFmbFM3NnpqR3lJOWZrcXAxYWVC?=
 =?utf-8?B?NCs5SUNNRnZNNkN0c04xMjhTUWhyaXY0T0owb0xNeFc3djdjbHZaMU9hMnpR?=
 =?utf-8?B?ckFjZFhEbkJ1OWJ3Wlk1K3hncGVWSU53ZDN3SFluaEhKa3h6UTUyQWdZSkNX?=
 =?utf-8?B?UDJYKzA4ckN2UGYraHlrMG12L280NDJXM2VRT0RDUEVkSjY1Mm5rY0FwaWhq?=
 =?utf-8?B?TDlrUXl3TGdBL3pvczhxZXYvNTc2NU5lcVBqN3JZdUwwZlk0aTdhT2h3WFQw?=
 =?utf-8?B?a0xtMjF3WUpobGdMbmtyWkhEbElnNm9VRUFZRGx2bEtKMUp6WWRlRmltSTVs?=
 =?utf-8?B?bWJWS1p2bUNhc2xYUGdyZXFyOEhTNVhxVUJzTXd1K3lnVk9sKzhXL0QyWVBx?=
 =?utf-8?B?MjdOSkNjcU1nb0Y5LzRtY29yNVJ3cVF6REdIUEV2eTVYSUxwUWFWQW9PeENL?=
 =?utf-8?B?cW5ENWRTNEFONmlXNnJvSGszRTQ3QVhzMG5QUlBpM2tHSU9HR0lSbnFtb1FI?=
 =?utf-8?B?VzdmRGppaStvNWpKNEg0UUlvWkludEwyQjg1QTJTQTQxL0pxL3VOR3hDV1Bo?=
 =?utf-8?B?QysrTWpKUHRVNnJyaHdkSzg2RDJ2RXpldmtBdDFrQUZsOFMrQ2U2dVkxV2Rj?=
 =?utf-8?B?SkEvRys4bi9naVJ0dUVUOERlZWt5WXp0Wm5SZWh3RS9DWUx3eFZYN3ZldnJF?=
 =?utf-8?B?VWhwYk1veTU0Q1dEeExIT1ZzaktJeU5wZmpDM0RuYllHSit6MXl5QWtnREg3?=
 =?utf-8?B?ZWI4UzlhZTQzamZkU2cxUVc1NmRYYVBIYlM5TkZPbGsvdnJTOTJad2VHMjBk?=
 =?utf-8?B?WkVwLzNETzdRZkNGdnhLUW40YUNjK0dXTXZrdFh2Uk01THlLZXRGc1c1K2Q2?=
 =?utf-8?B?K3F2OGFsL3EyWURkYTk4aHI5dlJqRlV6MXhaTDFCV2pzNTNFd0FjNTlEMVVR?=
 =?utf-8?B?ZjBzdGhsVEJncitoVU1OcmdPbVpZUGhCc1FVMEhWZ2JVNldTQmJJQTgwRUJJ?=
 =?utf-8?B?NnZWb1lnSktlRHVKVkd1S3VLUlMyOTh5MjRkWXluMUdpNnhDTUtRemFUdFZl?=
 =?utf-8?B?MEtqbWVFMjJaTmZPekc3QXphWkJLamtCbkJvL1FaRkI4bFNqVUNsSTM1enRL?=
 =?utf-8?B?a0VNSWdkSzBvZkNtMjZ4RzRrcXNsQ0F5L3BCN3k4NlgyS1MzU09YRGVSR1g5?=
 =?utf-8?B?S09sdFQvVjVwQlhBTEo2VlpzYlF1eE15SkhwK0pqUGhaajN0V0FCamlIVkJC?=
 =?utf-8?B?MVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2432b2d-2af1-42bf-0d7d-08da69bea03c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 19:41:08.2307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae5HRXCJs7q0/NI77bADSeDkBO2cFeZolk4vE0yIxkN9WmEuBouAGYTHkhmPXTWf/Ww7ZUpcZfDQA5yueLYr8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/22 1:26 PM, Vladimir Oltean wrote:
> On Mon, Jul 11, 2022 at 12:05:15PM -0400, Sean Anderson wrote:
>> There is a common flow in several drivers where a lynx PCS is created
>> without a corresponding firmware node. Consolidate these into one helper
>> function. Because we control when the mdiodev is registered, we can add
>> a custom match function which will automatically bind our driver
>> (instead of using device_driver_attach).
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>>  drivers/net/dsa/ocelot/felix_vsc9959.c        | 25 ++++---------------
>>  drivers/net/dsa/ocelot/seville_vsc9953.c      | 25 ++++---------------
>>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++-------------
>>  drivers/net/pcs/pcs-lynx.c                    | 24 ++++++++++++++++++
>>  include/linux/pcs-lynx.h                      |  1 +
>>  5 files changed, 39 insertions(+), 57 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> index 57634e2296c0..0a756c25d5e8 100644
>> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> @@ -11,6 +11,7 @@
>>  #include <net/tc_act/tc_gate.h>
>>  #include <soc/mscc/ocelot.h>
>>  #include <linux/dsa/ocelot.h>
>> +#include <linux/pcs.h>
>>  #include <linux/pcs-lynx.h>
>>  #include <net/pkt_sched.h>
>>  #include <linux/iopoll.h>
>> @@ -1089,16 +1090,9 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>>  		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
>>  			continue;
>>  
>> -		mdio_device = mdio_device_create(felix->imdio, port);
>> -		if (IS_ERR(mdio_device))
>> +		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, port);
>> +		if (IS_ERR(phylink_pcs))
>>  			continue;
>> -
>> -		phylink_pcs = lynx_pcs_create(mdio_device);
>> -		if (IS_ERR(phylink_pcs)) {
>> -			mdio_device_free(mdio_device);
>> -			continue;
>> -		}
>> -
>>  		felix->pcs[port] = phylink_pcs;
>>  
>>  		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
>> @@ -1112,17 +1106,8 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
>>  	struct felix *felix = ocelot_to_felix(ocelot);
>>  	int port;
>>  
>> -	for (port = 0; port < ocelot->num_phys_ports; port++) {
>> -		struct phylink_pcs *phylink_pcs = felix->pcs[port];
>> -		struct mdio_device *mdio_device;
>> -
>> -		if (!phylink_pcs)
>> -			continue;
>> -
>> -		mdio_device = lynx_get_mdio_device(phylink_pcs);
>> -		mdio_device_free(mdio_device);
>> -		lynx_pcs_destroy(phylink_pcs);
>> -	}
>> +	for (port = 0; port < ocelot->num_phys_ports; port++)
>> +		pcs_put(felix->pcs[port]);
>>  	mdiobus_unregister(felix->imdio);
>>  	mdiobus_free(felix->imdio);
>>  }
>> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
>> index 8c52de5d0b02..9006dec85ef0 100644
>> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
>> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
>> @@ -9,6 +9,7 @@
>>  #include <linux/mdio/mdio-mscc-miim.h>
>>  #include <linux/of_mdio.h>
>>  #include <linux/of_platform.h>
>> +#include <linux/pcs.h>
>>  #include <linux/pcs-lynx.h>
>>  #include <linux/dsa/ocelot.h>
>>  #include <linux/iopoll.h>
>> @@ -1044,16 +1045,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
>>  		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
>>  			continue;
>>  
>> -		mdio_device = mdio_device_create(felix->imdio, addr);
>> -		if (IS_ERR(mdio_device))
>> +		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, addr);
>> +		if (IS_ERR(phylink_pcs))
>>  			continue;
>> -
>> -		phylink_pcs = lynx_pcs_create(mdio_device);
>> -		if (IS_ERR(phylink_pcs)) {
>> -			mdio_device_free(mdio_device);
>> -			continue;
>> -		}
>> -
>>  		felix->pcs[port] = phylink_pcs;
>>  
>>  		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
>> @@ -1067,17 +1061,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
>>  	struct felix *felix = ocelot_to_felix(ocelot);
>>  	int port;
>>  
>> -	for (port = 0; port < ocelot->num_phys_ports; port++) {
>> -		struct phylink_pcs *phylink_pcs = felix->pcs[port];
>> -		struct mdio_device *mdio_device;
>> -
>> -		if (!phylink_pcs)
>> -			continue;
>> -
>> -		mdio_device = lynx_get_mdio_device(phylink_pcs);
>> -		mdio_device_free(mdio_device);
>> -		lynx_pcs_destroy(phylink_pcs);
>> -	}
>> +	for (port = 0; port < ocelot->num_phys_ports; port++)
>> +		pcs_put(felix->pcs[port]);
>>  
>>  	/* mdiobus_unregister and mdiobus_free handled by devres */
>>  }
>> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> index 8c923a93da88..8da7c8644e44 100644
>> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> @@ -8,6 +8,7 @@
>>  #include <linux/of_platform.h>
>>  #include <linux/of_mdio.h>
>>  #include <linux/of_net.h>
>> +#include <linux/pcs.h>
>>  #include <linux/pcs-lynx.h>
>>  #include "enetc_ierb.h"
>>  #include "enetc_pf.h"
>> @@ -827,7 +828,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>>  	struct device *dev = &pf->si->pdev->dev;
>>  	struct enetc_mdio_priv *mdio_priv;
>>  	struct phylink_pcs *phylink_pcs;
>> -	struct mdio_device *mdio_device;
>>  	struct mii_bus *bus;
>>  	int err;
>>  
>> @@ -851,16 +851,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>>  		goto free_mdio_bus;
>>  	}
>>  
>> -	mdio_device = mdio_device_create(bus, 0);
>> -	if (IS_ERR(mdio_device)) {
>> -		err = PTR_ERR(mdio_device);
>> -		dev_err(dev, "cannot create mdio device (%d)\n", err);
>> -		goto unregister_mdiobus;
>> -	}
>> -
>> -	phylink_pcs = lynx_pcs_create(mdio_device);
>> +	phylink_pcs = lynx_pcs_create_on_bus(bus, 0);
>>  	if (IS_ERR(phylink_pcs)) {
>> -		mdio_device_free(mdio_device);
>>  		err = PTR_ERR(phylink_pcs);
>>  		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
>>  		goto unregister_mdiobus;
>> @@ -880,13 +872,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>>  
>>  static void enetc_imdio_remove(struct enetc_pf *pf)
>>  {
>> -	struct mdio_device *mdio_device;
>> -
>> -	if (pf->pcs) {
>> -		mdio_device = lynx_get_mdio_device(pf->pcs);
>> -		mdio_device_free(mdio_device);
>> -		lynx_pcs_destroy(pf->pcs);
>> -	}
>> +	if (pf->pcs)
>> +		pcs_put(pf->pcs);
>>  	if (pf->imdio) {
>>  		mdiobus_unregister(pf->imdio);
>>  		mdiobus_free(pf->imdio);
>> diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
>> index 8272072698e4..adb9fd5ce72e 100644
>> --- a/drivers/net/pcs/pcs-lynx.c
>> +++ b/drivers/net/pcs/pcs-lynx.c
>> @@ -403,6 +403,30 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
>>  }
>>  EXPORT_SYMBOL(lynx_pcs_create);
>>  
>> +struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr)
>> +{
>> +	struct mdio_device *mdio;
>> +	struct phylink_pcs *pcs;
>> +	int err;
>> +
>> +	mdio = mdio_device_create(bus, addr);
>> +	if (IS_ERR(mdio))
>> +		return ERR_CAST(mdio);
>> +
>> +	mdio->bus_match = mdio_device_bus_match;
>> +	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias));
>> +	err = mdio_device_register(mdio);
> 
> Yeah, so the reason why mdio_device_register() fails with -EBUSY for the
> PCS devices created by felix_vsc9959.c is this:
> 
> int mdiobus_register_device(struct mdio_device *mdiodev)
> {
> 	int err;
> 
> 	if (mdiodev->bus->mdio_map[mdiodev->addr])
> 		return -EBUSY;
> 
> In other words, we already have an existing mdiodev on the bus at
> address mdiodev->addr. Funnily enough, that device is actually us.
> It was created at MDIO bus creation time, a dummy phydev that no one
> connects to, found by mdiobus_scan(). I knew this was taking place,
> but forgot/didn't realize the connection with this patch set, and that
> dummy phy_device was completely harmless until now.
> 
> I can suppress its creation like this:
> 
> From b1d1cd1625a27a62fd02598c7015b8ff0afdd28a Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 19 Jul 2022 20:15:52 +0300
> Subject: [PATCH] net: dsa: ocelot: suppress PHY device scanning on the
>  internal MDIO bus
> 
> This bus contains Lynx PCS devices, and if the lynx-pcs driver ever
> decided to call mdio_device_register(), it would fail due to
> mdiobus_scan() having created a dummy phydev for the same address
> (the PCS responds to standard clause 22 PHY ID registers and can
> therefore by autodetected by phylib which thinks it's a PHY).
> 
> On the Seville driver, things are a bit more complicated, since bus
> creation is handled by mscc_miim_setup() and that is shared with the
> dedicated mscc-miim driver. Suppress PHY scanning only for the Seville
> internal MDIO bus rather than for the whole mscc-miim driver, since we
> know that on NXP T1040, this bus only contains Lynx PCS devices.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 4 ++++
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 6 +++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)

Thanks! I'll pick this up for v2.

--Sean
