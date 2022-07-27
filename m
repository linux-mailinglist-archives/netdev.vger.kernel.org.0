Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E165824D4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiG0Kvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiG0Kvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:51:50 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060.outbound.protection.outlook.com [40.107.21.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D1B3ED67
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:51:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO5/Wx5fXT1J0d1i4PvMn7lSBCcbhAwuA3M5fmwquiGoo3SSHe9xM6d9EqyzQLbMCKAZmBNmzLdb5zZvfVopPZ24/+QxFFp/cL/Pn4VRYqvhzDNSeCznNPHcubs1dMPXMabcpDh+4oiqLVG9GL4l3JKwFOji7ajSpEsk9tay15kotfEu8FeVXkwth5TdmVL/TPw67oYGh9YmM/4Z6o+xrqL64cpiLBIh+FuKmcFxVxDtkjrVfJxUlCQ5BNprrsBg4ypKeu4t04xaZLK5hpk4Ijq/VJrkDuU2djyAfEEK3fudWdZuS12gsQqjCeuRo46v989EddaHJXmtC0y3Kdrx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqypnH3oXmh6Q9h0FylI8G3Hup9zU2oym4Bpcvcni7U=;
 b=hXi74c+l3+nfCjvpi92b9GtX7g9x12EUCKB9GbkW6TrAsfkww2B45roWEr3UAZKqMDBAdN5BD4/PSlWSyWO4bQgvuo58Q4jYJozjrnKlw1V9OVr5UpC+nzvNN3Y0/Fr9yHtjzPXijppSIdUs2hGkLkRyZa2EKoIokJZfgI9Ohr3+5liBA3XOWF2hKwKwzdOT3XY27UwvDAEHauVBGoVH3ydJhEuICyMdPNga7PMWYp1vB9k0aCr31mArDPhPG7gtfEfY/7R7+KRCH+eRRlXHNSL5hameEBlvFpXbtEJLsTk1gR+cqI+fPXz0y9/5LQwFzEQ7kMVxGiUShAtQRkx3fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqypnH3oXmh6Q9h0FylI8G3Hup9zU2oym4Bpcvcni7U=;
 b=14kjkvTl6t+F6/LDk0j14Q0CZP/v5tku1gYwwYu9rJU+B5aI8hrNU79tW5Ah/deXPp0unp+BR+3S8d5Y0OK7dOwI04ycBYAqJsc+Vmc48rUPP4I2faIL8j6I9y8Ac1DxQfyh6lUX0Cq+7kZ7rOwvDGSEG2KlTEzvlWz6LsHa529aOfEHJOntOm/0YeOuOwXZp+dz5dlbLiiAkJ+eFcBdgxFYq9he7wyRVpyrTcFlZmL7OzXrwFyxQWM7zsvh6YDwGg3VyF5Fnx3/MkGWBiXclH7F4lcTaVuDJXksIl6pGsn4onRRRl2LOZv51a6a7TnGhweSfMEYKs9/9dieRtWGPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DBAPR04MB7317.eurprd04.prod.outlook.com
 (2603:10a6:10:1b3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 10:51:46 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5458.025; Wed, 27 Jul
 2022 10:51:46 +0000
Message-ID: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
Date:   Wed, 27 Jul 2022 12:51:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: question on MAC passthrough and multiple devices in r8152
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0009.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::14) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b4e8c5c-9bfb-461d-5ce2-08da6fbdffd4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7317:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vwv3I+pekSFx71Hm6nvdEEJUEUUvmHnaRGDzrF5deT4CHsmG890de1NYD8XMrnSfpz/Ict1VhwmfiZSWf1CXttErlKZQwBPFjzrbqTRXtUVjxWqvnNHK9b0bgV9l5VZYZ/UF3DHadFjU8nwV/xVG44rJW0kRGO6aF9QzDBXehgCWGFjjB/fxrQQ0hwXsmm/2F0fNKT9AnnsUyo01CZLVWviie3DIGOQ6s/kInWKYtq4SFqojRLLvLxY2GL6raSLVojw4Pc9O8gxBISaI82eBjCJanp1uY2vDnUuXILVaVoFDn9e328dnS6EDIklK1ODjrntEDwUCQ4AQvCOH0BXL53nOrczgchxJc7NFBjA5mVwUu5VUcSFtQBxf8MA9iVDi6MUYFCHr233COSzk0dGpOV/8TfWCcip/dYWpaUQ3hEg52ZRQpaPpFOCkdKMCXE1WdINFYgAUd5BSXSiBOGL8QWXiiqgfTUtQDDeJTJn4xkIRVZkpxIijSofvl6m4WRj4a7RHb6Hz09pcaLYTEnVhfSPyiMyN+5ToQQKnXhz12vpg90hnvJTQloYVgRj97o8IaSw/NzV/IyIZ0e7l9wC0QvdprXAHnzfIavM//WDczZVwnGZm6FEdcoCPNi+CgTQd7QCM3ymaggiqDq/BNXZOMSgcOYXCXq06xVGEKyS22VOwWVEYLXeq2im+K8CzDvs26U6doT29GdeFaQ8IDzeEeRkdg7FLnzQ2jEVdtciywZZfZOCWLt3vb3+ztMLk7UH2NbxjPi5VjPaqIw5IPdthGIULvG9pXQFgYNooN3zVS9lc5I/DDx9qXly3nFnl7IQTkxtg8DIgDG4VCDy/1+KkCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(136003)(376002)(366004)(36756003)(4326008)(8676002)(66946007)(66556008)(66476007)(186003)(6486002)(6506007)(6916009)(2616005)(316002)(31686004)(38100700002)(478600001)(86362001)(6512007)(8936002)(2906002)(41300700001)(31696002)(5660300002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGgwRG9PckphV0VhVXZmRDJ6OTl6WDdmR1pEU0FsK21VSkhsbzJvbmNuUXh0?=
 =?utf-8?B?VnhhQ0NIUGxOT3BERlE1WGc5UERiSUNQR1FjNXJGV3Fzck9EbHhmMk9QdnNC?=
 =?utf-8?B?MHBrby9EdWhrdmp4ai95b0graXhTY0J3VlZvdkh1NmJObmgrMnV6ZWFwcEEw?=
 =?utf-8?B?UWRoaTArLzdhZWVOQjhhdUZFTmI2dkw3UEVCRnpzUFk2VVZKRWNvUFhKNjhi?=
 =?utf-8?B?dmY2M3RBazEvZUREai9Yb0FPNHVaWmxpSisyK0Q4ZXFKSzNnV2g5b29Qd0Zp?=
 =?utf-8?B?M0lPNTFpM3VnSmJZS3oyN1dOM2tqUGVZQ2JHRkNwZjNVWldrcm5JdE1iNFAv?=
 =?utf-8?B?VkZTN0NRbGNjNFRMeHI0OEJMTG5RMFpGQlJaTGR3NkRuMWxsRE9IbTBBUGo4?=
 =?utf-8?B?ZjE5UFljRXZGNG8wa0hORkRCYkkyUGlGODNCczZYdVRWM2JQRUVacFRBNHRv?=
 =?utf-8?B?bXFiVldaM0IrUVpudVN5ZmhHdGdHdk1xK1pibmxCMys3aGhWblRQTE5CSkgy?=
 =?utf-8?B?ZUVHNm9jdFIyTDJIMS9na0NSTUtpWUIrQ2FKVGVNTWpMR1E0VlBtYzVER1RS?=
 =?utf-8?B?RnNmdU9Oelp1MU11KzJuUUkwMGg4bXZraEp4cisxalpCeEtvVFdVREtrZ2Nw?=
 =?utf-8?B?U2w4T0dSZk9yTHUxSFNDazhBeTFLK3Z6aDUyOE9scUxBV2k1dUhyRVlVZkxL?=
 =?utf-8?B?ako0Zk5wb0taVFQ1S05CSmV3NkxBZHR5aWtJMURjYW5rSkpLN0dhWFhNL010?=
 =?utf-8?B?VVROb2J2NFFUVFNqaWtGNW1OWmlSRzBwSWtMMCtoWXNyRnJKYlRyYlhFMnNo?=
 =?utf-8?B?SnZoOHExUXNiZWpXWXF6cG9kVUo3VExMNzBRU3JZeldkVisvS0FEM2F2YWtm?=
 =?utf-8?B?cW9TZFlxS25Rc1RDQkRvT0dVcjk2b3lLVEVIT244R0VPcGI0MGRZZGh5dkJk?=
 =?utf-8?B?RVBDakdPcno1UkVZeGxKaFlsTUtHSW9tVmdVcHpuRS91SnlaOFpaaVZQTGVI?=
 =?utf-8?B?U093c1RvS215N0pvS0g4KzhQeTRlZ2cyRjBSZ244TVRKZDdZV2lHOVVnQzVI?=
 =?utf-8?B?WitlZjNlRFltMThVc0VITVlpd1hZdGJpTWZVOVQ1UlhWbUhVSWJDN2s0MVRn?=
 =?utf-8?B?M1Fqc0VBcmVrSlFsdXJtRWJjWXl2bXRDbDhWYURkSVA1dlpKaGtxRHhCcG42?=
 =?utf-8?B?b3FPaER3SEYyTGh1bmVGVGhoL3lBOXJZL2tIZVhjTW91QWd4bVVQdG5jVlBN?=
 =?utf-8?B?ZUYvTXhWc0U5cE81WktEOWU3c1VIR0F4UGRzaXBMVWxEZmV0MmNWeDZkN0lu?=
 =?utf-8?B?UVR5VmRtMjlQQzZIeTROU3F6U0tFRGpSRVRhWDJIVFJUNzlCcTNUZW5mTElm?=
 =?utf-8?B?TllCbXJudUt6QXZIZzlyNE84S1VKSUs4V0dPQVZHR2lTQXI4TVB4K2VBUWdq?=
 =?utf-8?B?Z2d4TFlBNkdpcUhmNTZ2WVUvNTdZQUttREVEUXlWMWpZazQ3UmpmVGhBcHh1?=
 =?utf-8?B?RlByVldGd2VNQU1ybzlOVHdhSm9XZ2t4NW9sTi82cnVGRlFqZ3pJelFaQXk0?=
 =?utf-8?B?UzAzdXphQmt3V3hGeFVKUlZpNDdXeEljTEpXMDFPSHBVTU1YVUlGVDRmTEZY?=
 =?utf-8?B?MWp2WHZkVTdNelI5SnEwaUJJSzdUTnhodXJPRm1KQjJqQS9kMndBKzdhQ1Za?=
 =?utf-8?B?bkFKNmdaRFV5YlB4K1RIbEhxMHJENjJHVUt5S0FYa2RLb0lLb09Ma0VEWmdl?=
 =?utf-8?B?c0hGRUw1T0IvNGxBYTFsNFNEUnpiTHRPOVVCUGh2cXByNFdvT0o5Q3hoSDA0?=
 =?utf-8?B?TGZIL2lKZmhycUV5Sk1VVEJQL3F6ZG1SRzNsK2x5RE9DYXhYK3pwSjdRZEhY?=
 =?utf-8?B?aFIvWEdwc2tKR1Jra0kyaXRiR1hkVnRod3UwSnFNNkVrREU4elFWVHUzZWxI?=
 =?utf-8?B?NXQ3eUs2MTdWVzl4WWpXUWRzb3BOYmtTd1dtcEpkR3JVMjdDT2FKb3hEdzlU?=
 =?utf-8?B?WVZBeC9NWnJQcXlzUm5UeEgralhqYmdIUDZia1A3bEtFdTc0NEJKbUJpckQ2?=
 =?utf-8?B?N1hxSFB1SFE1bG5JL01WZk5GLzBNR1VySURtMS92aWh4V2tyTHBzKzVRWmo5?=
 =?utf-8?B?VHVYTDlqQ3RyNHp6SGFheXpFL3pzL1BFckNqdGtuNjgzQ2swUkN1MWFpRnJK?=
 =?utf-8?Q?7fdBOMYVRdpwSw8qcqpcCIHvZuf4906YV9p95+n3B0RU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4e8c5c-9bfb-461d-5ce2-08da6fbdffd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 10:51:46.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLuZtAxBbITdSNpMLaUtV0YaWE7lEHkSa040HlsixDWj+idwcNV5vWY9gCFsxcPaJGWayHKpX6wncMl3JuDZXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7317
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am looking at the logic the r8152 driver uses to
assign a pass through MAC and I do not understand how
you make sure that it is passed to one device only.
As far as I can see the MAC comes from an ACPI object,
hence the driver will happily read it out and assign
it multiple times. Am I overlooking something?

	Regards
		Oliver
