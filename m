Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D64F677D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiDFRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbiDFRgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:36:14 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2114.outbound.protection.outlook.com [40.107.117.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B0B1F6;
        Wed,  6 Apr 2022 09:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odbd/GdpX/jk8J2DZjrOxX1128Iu5XvnYSTCNPZqGa0Rt5pz7xCQ1YtaNcj0PtJNy7Qj+WL0vMe0kEo9tVCooWuh+SCYFNPNzX2OE3HofA4jEnYj0lXDhJfZq5Pn43L7hnYJXPHjKwK03wItDU4wjEFyntkdEpRlVbvyKDZEienk1tTnrMFVBUJwxR+5mr0hKmkuyV/eO+NUarR7wNv5NbgspVckLV+1/PnGltQceHJcZjQJz+cijQsV8l8zXxEKGeAlkgzxER6IT2DNQZOGZG/EDRPodnE0u3rDFjzyb1MsLgHvV+rDsap4KT5HlE1ODRrJ4ukl2MfMLuoyp5YEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO9KVfrdTBlxsBO+WqLc1AemDp3ooFkdF5f6IPfVY4g=;
 b=TGnNjbwp6B5pS5vPtNrutDXTolj3tRT1tSQzuVAKmHm4js3I3zw6ZIeYqtojHJhGsc1q/wERq3TnJOD/pmS8GZKyumPzj77SiCSLpfLvAK6LKCbFX4Ygaz/z+JIpOUyMhQ9G1xhwB+nSLZo9v3N6lRK/1ceN/RqdvPny1sJgSX3oGQgr1S0B4LfC/OnzhIgu22DWMjyhm+AD4J1eWZh1xQyIwy5Gjz3iEij2ak9CidRlNORy83Aw5nl+9QHyFXDaEMzVAq5exdMB3yRE5O63SBgc6Eyc5Uk1kOoW6r5KHJKyluQZ1/33Uu9mbapPrsIyJQR2LCMDFouK/GO7BoyhzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO9KVfrdTBlxsBO+WqLc1AemDp3ooFkdF5f6IPfVY4g=;
 b=RWpswDtMGuMN/ZWRi+UJ7Bhim/2WjF4XIZYysYtayeViE5oaBFFMCDMdxrKF6m5XFqX2qG/vL4AHbpbUBKJnAs1229D4A3hKNNmmrP264B7pmREux2bCZDnWgItCpN4suLEhuipOZLY7p0xdl4lbtQLkCYmd8bmpDmRrKRGnj+s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by TY2PR04MB3439.apcprd04.prod.outlook.com (2603:1096:404:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 16:34:15 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:34:15 +0000
Message-ID: <9dce42c6-3a10-7772-ab6a-3a1947cfb9fc@quantatw.com>
Date:   Thu, 7 Apr 2022 00:33:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/3] net: mdio: aspeed: Introduce read write function
 for c22 and c45
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220406012002.15128-1-potin.lai@quantatw.com>
 <20220406012002.15128-3-potin.lai@quantatw.com> <Yk2E3X7MaJhWi32O@lunn.ch>
From:   POTIN LAI <potin.lai@quantatw.com>
In-Reply-To: <Yk2E3X7MaJhWi32O@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR04CA0074.apcprd04.prod.outlook.com
 (2603:1096:202:15::18) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecfea996-6ea6-4798-365a-08da17eb49c7
X-MS-TrafficTypeDiagnostic: TY2PR04MB3439:EE_
X-Microsoft-Antispam-PRVS: <TY2PR04MB34390374949F03206B9F64A98EE79@TY2PR04MB3439.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3a3pBckseEBGlv0vW0r4jdiaChDtO5/GzeH4qAkW9uPoWlA5JiCGD7QIESuNKKP/wGadt08/WIro4lTNrXGlquwlZZ/ovADVzE7OQVAgxIPFzct991vdzECoXQ1NML7Wkkqz0KR1jzCuHYgeVlYAwMBLicofxGMXZJR48t4OR0VoJmS0mXsfrLS2PTMmOIDF8JFtqpt2G1QCuNCgQghujVeWmlcqqYdaWoNssbiPxjlYMg9spYEpf/uD5XVM4OX8kz0zaVLw8csFAISPC5iq5K4uUQCpwbmNsM7puPZhwxfdh4reICfSIll1EMcQ9ppBOEjY5nMEm54e50zoG3nqbXQd/pPlcRZCZUX6uyw5+njmldjmDhHlD8Wuv2tpQEjd7udP5viMPDOw5Vo4x6mNA809SMlUqCVInBQvZkvVkwAzpPSbxW6AJlGi/e+xNaJMunxjcuSJ5X4yW6ktT8auU0DRk8M8QXQpUTtsCjzY6qTV3pftw5V6pLkupYDEUTp43dnNDtwaSqiIZoxSkEkbQC/4WnlHATJR+60A5GwH8yjBtAKK3vNHNQs4b+ilMYWnsyxkqG1fSgXpemToMTyPPEoI4tV3cv1geyHdlKp4nIQD1cYPZZpwwXET88phlkITUT6pPQaGYEJPseAldYrcfZzgjYjB/BjWrtxQ7VYJ3VpZjDXsjjhUZFSthbSY6U6hXXzazxfqirszjdNhGfenlCnJTfqlp71kgRilgxlC0ibxa0mXFeVTqo++JuJjqpSQLh48YxQhDc+Cf36+WbT05A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(7416002)(5660300002)(36756003)(316002)(2906002)(31686004)(6486002)(83380400001)(8676002)(508600001)(26005)(186003)(6506007)(6512007)(6666004)(2616005)(52116002)(31696002)(86362001)(38350700002)(38100700002)(4326008)(66476007)(66556008)(6916009)(66946007)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2lrRlV0NGozSTVZazYybFloMEppSElTM1Bhb0xLaHRmeExIS2p3c01DWWhw?=
 =?utf-8?B?RGw5amxPeS9QdXNuNk1TQzJiaVF3T2RzcXdCcnUzRWlEVWdnKzJYdWl5eXhP?=
 =?utf-8?B?ZWVnYTJVZlhiSEptd2JBcDdBMWlOa3VsZUdlZWlKdy9FVDFqWGt2d09EcmV6?=
 =?utf-8?B?YzNjaFUzeG5odGVzNWxlOXB4WGNwUEhIUWlyOFg1MlhGSlRxeElMNDJwc0U1?=
 =?utf-8?B?aGIxc2wveEpxZWhrZ0ZhRVVWd05idzRINHMrS0Yzbzc2OEdPbFJ2bWtTc0Z5?=
 =?utf-8?B?d3EvU0ViWGJ2emlFNWl0SFU5OG5QUDZTMzVMZ0x1VE5iT2hUTzhCMmhRNGtQ?=
 =?utf-8?B?WUk4c24vejlVQ3FuaXAzQitKU3gwcGZIR0kxbzVELzM3SFMvcnRRaTVUU1Nv?=
 =?utf-8?B?UDkydXFPUk5SREpNRkFNTTdCRUc1bEtVUTdoclZCdmJ4cjlCM1pEV2FicERM?=
 =?utf-8?B?bkJJZ2hzUFR0dUd2aTA5YXhpRVArVDFEeXpndmlJQlk2RmQ5UlB6T2RYVXFi?=
 =?utf-8?B?WXdCY0hyZy82VXcyNlYwN0ZUa0xqUjJTd3d5Z2N0ZnBBcUoyckZtbnBTaUdr?=
 =?utf-8?B?MXVDa0dIOFVkRUNuMHN6R0ZYdkZWM3lSN2hBTHJXWW1ZUDdYZ2RNalU0NWhs?=
 =?utf-8?B?eFhlOUdaaDZoWEc0NWlGcWV6RmhhSDkxMkZ5R25BYTZMUHA1dE5VTEhJRnRG?=
 =?utf-8?B?ZVpDOUFCZlN5RWFoZEpVeGUwS25YZk0xbk9xN3dWa09LQURZamU0VGZyT04r?=
 =?utf-8?B?L0JxUW8wS0lpUGl6REloLzhYOHRSTm1QZGphRXVwZlJFM0ZnanBXbzJNMzVP?=
 =?utf-8?B?TUl0eTkySWtRRW1LcTY2anVra3MxcGxaNlk5VXBEUXV2L0lNY1B3N1YwVTJF?=
 =?utf-8?B?ODJPVHRuYjRKdk5yZHptU0xuSld0SnZsdTNUOXNBdFdCY05ISXYyMytSSGpF?=
 =?utf-8?B?bWl4V3hYeGU3ZndxQnd4dHNZc3phZFNxOUE2bEZEbXZzQk02bXd2Umx0OXVT?=
 =?utf-8?B?M1NHcEdEMkcvV0tVaCtyaGI3REJJU1d1QWVNNFFvRkl5K1JzeTlzUE00eXlD?=
 =?utf-8?B?eXQ4bU1zQnd3d29GK01RbUkrSDBaREczeVBsc1B3UGJrTm4yNVpZcXJmU3Yy?=
 =?utf-8?B?bGgwOC80OGxRVDdDR255QnczRlBXbkhtTGx5MmhGWHN1UU1TdGpBTGxDSGty?=
 =?utf-8?B?NUtWZmxrdjk0RnBFL1k5VnlPbFA0YkR5TEpnWVR6cHhiMnhvM3lmMk1aSGpw?=
 =?utf-8?B?OGN5S0dXeDkyV05XMWZVME8vanRYd3A1K25HUExYRmt4R1hBUHlxZTRPSm45?=
 =?utf-8?B?cFRjVlk5Z25EV2UyTkFBSTB3WW9CRTY0NU1OWHdFSkpKZUdQR1BTdjI5MGZx?=
 =?utf-8?B?MHpmVzNWQXB1L3RXL2cxTWJYQnAxd3FhODJNbDlWK0Rud1gyMG9YU05vK2Nq?=
 =?utf-8?B?OUFJTGptNVcraHFrZjhlNEdEYXdUR2VJY2oxMmhsYUltL2JldUVyNWFWL1ZP?=
 =?utf-8?B?bE1pOUF0VDB6VmNCaTlOd0NmcHJKbnpTYkRzSG9ueU5MakNMa3R2cWM0YjF2?=
 =?utf-8?B?ZnIvR2UrZk9EeERyR21PSXpoWlcvK2NPaTZGRitoY0FTVXVRUVBSeXpqbm9J?=
 =?utf-8?B?ekFEQjVRVHlNYlViendwNDZFazZPampCSll0UllMdEk1cFUzaUJIQ2FhS3JL?=
 =?utf-8?B?NlA2aXhzMUR1dWxIR0ROeDVXQjhDcTdLczBkMktqQ2F0emJJemRDZk1wM0R4?=
 =?utf-8?B?ZkdhcjVmL0k0algvb1huYW9MNU1WSkNOajZxbWpwb0Z4MDdrQ1ZwYXpwckZ3?=
 =?utf-8?B?RTFPdEZVT3dsOUN1Y25Md0VMMWJjeXhwODNYcmNnQzFsOXNLd1g4Y2hVZTNK?=
 =?utf-8?B?RncrQmpKWWw1YmZSSzBMRVdxWlRzbDluZUF1V1hia205TUJxSEFSdEtUUXJY?=
 =?utf-8?B?Y3lLUVNsSWt1VWVYOE9peFgwUmJtVnc3SDJwR2RxMlc3SGg2dVcyOTl2NGxm?=
 =?utf-8?B?dTFSek5PM2xLaVp4WHJIL3JiVXdJUjdSY3hBV1h6S2ZpVXBjUGk3MzhnSEhw?=
 =?utf-8?B?Qjg3MENNblkyK1VnMjQwUmFEOHhVSFVjTjRsL0NEOHRoUXY3S0ZMbjhyb3lt?=
 =?utf-8?B?YXZGYXprUCsySm0wanVxeGVBQ1p2akVVVlQvTmovREl0ZFAvSmNXZE1FYUxZ?=
 =?utf-8?B?ZmRNeUhCVHV5ekZKSGNRSXEzS1N1dndwRmI4Q2lQZDBiWG9VTmlRYmNIbUtz?=
 =?utf-8?B?bUJOTjFxSzVUZDRSQ3hPZmFWeHN4Q3NtTUk0NXR5MmlWT05ST1p3NmVMS29Z?=
 =?utf-8?B?SU01c0VuYmtCREJmUGVpUDZVTVgyZVlGdTRyOEY3K01GN25SR2lQVGZraUEy?=
 =?utf-8?Q?uf+jHFbpdr4MMzkw=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfea996-6ea6-4798-365a-08da17eb49c7
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 16:34:15.2329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uOBCFl99tNiBV+WPGIVDov6D2392G3yWrQcpLTpzdsuCr9+DijU0i7nT7jQfRKFHRLWr4Pxyf5Nfkr46RalLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR04MB3439
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn 於 6/04/2022 8:17 pm 寫道:
>> +static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
>> +{
>> +	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
>> +		regnum);
>> +
>> +	if (regnum & MII_ADDR_C45)
>> +		return aspeed_mdio_read_c45(bus, addr, regnum);
>> +
>> +	return aspeed_mdio_read_c22(bus, addr, regnum);
>> +}
>> +
>>  static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
>>  {
>>  	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
>>  		__func__, addr, regnum, val);
>>  
>> -	/* Just clause 22 for the moment */
>>  	if (regnum & MII_ADDR_C45)
>> -		return -EOPNOTSUPP;
>> +		return aspeed_mdio_write_c45(bus, addr, regnum, val);
>>  
>> -	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
>> -			      addr, regnum, val);
>> +	return aspeed_mdio_write_c22(bus, addr, regnum, val);
>>  }
> Hi Portin
>
> Nice structure. This will helper with future cleanup where C22 and C45
> will be completely separated, and the c45 variants will be directly
> passed dev_ad and reg, rather than have to extract them from regnum.
>
> A few process issues.
>
> Please read the netdev FAQ. The subject list should indicate the tree,
> and there should be an patch 0/3 which explains the big picture of
> what the patchset does. 0/3 will then be used for the merge commit.
>
>      Andrew

Hi Andrew,

Thank you for the notice, it looks like I missed sent out patch 0/3. I will resend whole v2 patches again with tree name.


Potin

