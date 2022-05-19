Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23252DC04
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiESRx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243409AbiESRxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:53:40 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15860275DD
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqw+JKjVIHoYAFrCNzb8YjVWZHb54wpjnk0NohTnRiMBM238BWu7gslw85azIP6HBzMnzG/fqi8vV2VQsqATpwAWu6FTK+ogE7lzxbkIk3u623adqrhJ6M0LHmFrbBo4IPKbYVZ6Df2A4ZWbUCoaM+JxCRrWe4RiT6noTpSrLzka8CQb2M+8MXoS/+vDH+SPUbss+3sI0kJL6RdxOq0LmiSNLtGGnTZiGGpL4F6026NKhwDrUouu42y/A+URapwrKX00mXl4a0kfnRyjmcuHSR83rXqu2megKRt4odU+Dz1uWTm28eMeQvJG7xSlxtWImAvpErFL/ibHNz785vs3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObX6rW1xSuOGBq07xloFWnf0LqHwYRXJzTWbpWGDAPE=;
 b=WgyH5KpYCkQP+LTphxZzDMmQ207trX3IosIT4iZW3ff1iIpRhT1TaJmlO47H0Vjf9sSaNNZgsI4KZ+Hk37nxdpQlxYdcFoTrvDmcgUUGiAt65d0Wzdb7nB7Myc0cRY6yzSFAskyHOeoXXJSsENUZFp7+wJ3ne0GGQYhsoeRreXeC3ykhlasE4ZFYaX/pML8OlNs1cz+UAXHPuB/uGUqdEEgGCkVfqVs2ycDOg+fz5LBpZIKnrV8poTnnE+PJeUH7mxu+mnkmKxJefMCHOh0vaWJm8G2UTmzrVJ+H0S3lLh2oddmfXcyxC0K54e8H2co93/0ziM3jdPqxY2Xwy+8UjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObX6rW1xSuOGBq07xloFWnf0LqHwYRXJzTWbpWGDAPE=;
 b=K++hkIrexYyK/QCi0njdRnaKb/w2LalrZGvHHfL1xET91cF/KBexuK+qruGyM4BocBff17TNhq+gsgb6Risb9Sg1WR5LW43b4rzotE4hMTjrmXbdAv+PMC26SzwM1TftykADYLB3llwfd6AnwSRnakInZnA7/gYhpUmbP2wYT6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB3248.namprd12.prod.outlook.com (2603:10b6:208:a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 17:53:14 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 17:53:13 +0000
Message-ID: <6477b374-ae73-8cbb-566f-25751025e434@amd.com>
Date:   Thu, 19 May 2022 12:53:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Content-Language: en-US
To:     "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BN0PR08MB6951015C28F25C9B7E011ADA83D19@BN0PR08MB6951.namprd08.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <BN0PR08MB6951015C28F25C9B7E011ADA83D19@BN0PR08MB6951.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:208:23b::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf0a0c3a-5942-4cfd-c318-08da39c071e5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3248:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB32481751F712C06CD1D43049ECD09@MN2PR12MB3248.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hMj2lupj8E8pjCAQsfmaTO7fSYjfnbs4EdcWEj1msy/IvwfeE1FT8sNJlTlhNLLYz/Vtjb5Eqn+eVyV+Y5YdtpdAztxz9Ie/VEjqg51LvAyG7tQ56lfobxYJbMnEJl1grluywzfkbxjcezSk4mtg9nVhqQpgnb8uDC6/IiteIFxwvGRyY67c6qfuxALPExPdLcN4tW7WwFtMXObcMcwglAlxAHXcmfBUn7l54HpVu/i0cqu3qW7hFHSCRB1KX0+oxN9nb2tTKvVj22z9i6MLD009o+7nOc6AOH2WhcJ2uUSXBGxu7m6Nbr8gSk6X93fOwo4HXtaTjppNhdONUH15JcIi9TGymMtxFVhQNIIOAFpHD+yfldsRVDPOIXbYXjifLPIsFWnu1SBd4VCzMa5FCNiWvaanZyMA4u8SRBc27pTXT6MGujMYKnsXYYjQ5Mbz7mSJ5EtjSpj5GF/cV1jXfqrkZVXCzbaQ6xHyB0DSsQirfHwQxCYRbyceqRI+P8d+CCC6xE0Au9MwmMuj4MC2imjezWt0YYrPnsZbsLJLQicXKyXTTcnc67kC46hamD80b1DHyYl1cobFwL4hB3V5tfj8wzuIqtDABZJm8SLI+eCG5MSDLapouWzDlp9lhxZEzRo3HxahBvtpsbiTTiOt6cr3JkyURy90bYPr9XGyI+kZBqc8D3YscqcZcj6EHQ0j2X3kryWGZXTNiMj8RERxIFIaDbt6vpw/5DpLvGG6t1rkobnJP3nUqQvyRBzMbrvh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(83380400001)(110136005)(508600001)(8936002)(316002)(6636002)(186003)(38100700002)(53546011)(2616005)(4326008)(296002)(86362001)(36756003)(8676002)(66556008)(31696002)(66946007)(2906002)(6506007)(5660300002)(66476007)(6512007)(31686004)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhJU1F3M2xlaDlvQVBtSmdZNWV0eEdZN2l1aXpXQVBkSG5DcW8xOS9tZVNw?=
 =?utf-8?B?Z2hCZy9JdGNaRWFMOW5UZThBZzBmbllFWnZaR0RBTUJUc1BvRlcvS1IwYlpI?=
 =?utf-8?B?TCtYZDFIUUxNU0FTem0zQW1yZ09LNGNYekJydC9DVmJYSU40TjZvQ04xZG8v?=
 =?utf-8?B?SG5nazN6UWMranFMQis4RDJtblpJYnJTY1Y0ZXNFQUk5OUp5dWJmSVI5VVhY?=
 =?utf-8?B?Qy9vdXJ6RzZxcVdrUFRiZ0tSczZrS2lYck55Y2hOZGdNQllZbUplZ3FRZGZ4?=
 =?utf-8?B?V0lKcHUvblNrK1hERllrOE93RzZGNGlrVEVwWVE2S1lFUEFRUTF4MGsrdmZQ?=
 =?utf-8?B?bXJyWTRqdm0rUW9nNVdHdDBveVJwMktQWU80QStkTnlZdDhKenpaOFpkS3ox?=
 =?utf-8?B?QVNzOUNuUGp1Nm5yc3A5T2tzYm1PdUVTajFmTW4rd2dFK1Vpa00xSUZvL0RD?=
 =?utf-8?B?Qkl3N0tCaFRsREM4RXhHZGxKcXp0WS8wamJDMW1HZnhXbFpFQzJSWW9SWE0r?=
 =?utf-8?B?WmE1RTkxZS93TExEQWpiTzBTVjl2RkRTOUhwVzZnWTZoQnM5TE8rWGMxNlRn?=
 =?utf-8?B?OHN3Q29leWJXUHViNUQwWElFby9US1Z1TWc3MkdMdFlDMmF0VXJLV3hzeWdT?=
 =?utf-8?B?c3lVcjBZN095ZnB2cVRmRVhkMWFyQ0NUb0I0SVZEMmZhMkxjMHpla045OFVJ?=
 =?utf-8?B?eUN2M1RkM0ZtRTVCM09HTGRRUGh0THFBMHI4b0x6bjZ1VmwyT09BQUJCdmVQ?=
 =?utf-8?B?RHl3NitNN2ZaWk9jdzJvY1IvL08yN3FZN2krVmd3TDJBUFhzU21abFJ0eEJ3?=
 =?utf-8?B?Vm9UbzJpamdRTkxYQkxZNDdNU3g3NXVHdVIwR1UrRkNFVjErUnk4SVNBc3Q3?=
 =?utf-8?B?TTVBdXRuZEdkWnpzUlFKTlF6ejBQYjlab3g5dmNQRlI0R1E0c2VaTEs0NEh5?=
 =?utf-8?B?Q21QbWJHaGFJaXErUGh3VlZVblc2QlpvOS91UUhGZXY2UVhVdlBaRVV5dlVu?=
 =?utf-8?B?YXB6MHovQzZwMGxpdEw3Nk5aT2twd0FVUHE0WXRGNFJDelJlUk5rTmVDN1Iv?=
 =?utf-8?B?cGlKajNxSnRwcm40alZjNzcxV3d2aG5WMnBVYThqUGJPQSsyR1ZQWUVJcXV3?=
 =?utf-8?B?ejI3U2I4c3E4ODg2NGFoWitPUWNreDlad3ZNVlNLN1dMazZWNGtlRjViUUJz?=
 =?utf-8?B?NzM5NmpaV2h5c0g0M1dvN0lkZ2lsOUpHZWJkdDVZSDg5V29BQXgvWjhlZFJT?=
 =?utf-8?B?T21qcWQvL0J4TldIb2VqMXBENUZvQkJobGtLNjk2cWhrMVJsS1lLbHZIZytL?=
 =?utf-8?B?ZE55dmhUSnJBUTI5RzJUL0RjRDA5Q09ET2dBMnpqT2ltUHI3WDFtOWJnbFQr?=
 =?utf-8?B?VHNIS0I1dENTWGNRTE1aUDF5WWhIRndld0JBd0ZFbHBCYzF2UFZUSTZtclFP?=
 =?utf-8?B?c1JEUjRpT003UHNkczAzUThhL0JWNW10elFuWmpIRlR0OXl5N0dFVCs2ZTRt?=
 =?utf-8?B?VnRzb0NUYkJoYnZycWNqRjYweDR2UHJQNWFHak5TSkpWTXV3bHRaVXBsV1Vl?=
 =?utf-8?B?NzhMcjFyVmo3bkhVK3pRa0h1Um90V296dzBZREJPU0JTTUQ3WjhsTEVFSUFB?=
 =?utf-8?B?U2Rlck5LRU5lR1pqYzZqK3pQODJqMXhVTE1sdUtOVUlxRDNqWmVrbUJST2pr?=
 =?utf-8?B?M3N2Tm5EVkJlRzNPUUNWZCtxdGlWN1VlSVE2ZWdobzRQTVMrTG95SUY2UXc2?=
 =?utf-8?B?T2p3bUdlV0V1ZzVYaTVaZHNzOWlYYTVPNjdZaldvYWZrVWdTaW1ZdSs2SUVM?=
 =?utf-8?B?VW43bFFIVExZdVNHK2IvN3cvUUJqSUd5QzVINzhqM25JVTRIaUVKWmFITGZK?=
 =?utf-8?B?cFZxNnpTTG9kY1F2RHhvSkFEQlpjajFrNGxFbjh1eFVNeW1Yb1Q4a3RDOGxK?=
 =?utf-8?B?NFJUNEYrYVpuMk9idDFCM0IveUJWN1hpUHBWbXNqdFQ3bmQ0SU15cWtGd2Q0?=
 =?utf-8?B?NGNWMzZjR0o1SWYrcDhnR0RHTDlaSXhEMWVFRTZZWUd4clROaGNXa3lpK3ho?=
 =?utf-8?B?VlJqMCsvNUVSSCs4c1RFWTlYZTUwSUd4cm01U0NpcnRKYzhWUEt2UkFsSDZN?=
 =?utf-8?B?U1gwZVIwWnppUFVhV3l6QVBuanRMYjk0c0d2YVZKN2hjaHZJbnArNnhDdG1V?=
 =?utf-8?B?YUNaK0kyM1hXUU9CS3gvVXZnMEFsU0FFcHJYWmd3TjdoOXpzL3B2TE5reUdl?=
 =?utf-8?B?dDczRENQMjVlZFZUcWJzU1RkcGYzRTk3S3RKT1MyT0djNVRIVWRaTW5hbklT?=
 =?utf-8?B?c2VRTHdQaG44TXVmTnAxcjFmb1RTeHlLbHFyWDJTK1BtMkswZnhrUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0a0c3a-5942-4cfd-c318-08da39c071e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 17:53:13.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lqt6pGP8aWGAA2E0xqkNROWks9VvVekDhO7cgtcKHP185bWz7zQ6el3LV5LWVK10HpA1nA+5ghz7XE9An19VeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3248
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 13:58, Pighin, Anthony (Nokia - CA/Ottawa) wrote:
> Tested on Linux 5.15.22.

Can you supply some additional information about the system this is on?

Adding Shyam, as he will be taking over maintainership for this driver (I 
just need to get around sending the patch for that).

Thanks,
Tom

> 
> Step 1. Force (both sides) of the Link to advertise 1000baseKX/Full only
> root@localhost:~# ethtool --change bp3 advertise 0x20000
> root@localhost:~# ethtool bp3
> Settings for bp3:
>          Supported ports: [ Backplane ]
>          Supported link modes:   1000baseKX/Full
>                                  10000baseKR/Full
>                                  10000baseR_FEC
>          Supported pause frame use: Symmetric Receive-only
>          Supports auto-negotiation: Yes
>          Supported FEC modes: Not reported
>          Advertised link modes:  1000baseKX/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: Yes
>          Advertised FEC modes: Not reported
>          Speed: Unknown!
>          Duplex: Unknown! (255)
>          Port: None
>          PHYAD: 0
>          Transceiver: internal
>          Auto-negotiation: on
>          Current message level: 0x00000034 (52)
>                                 link ifdown ifup
>          Link detected: no
> 
> Step 2. Bring Up both sides of the Link:
> root@localhost:~# ip link set bp3 up
> 
> Result. Link stays Down:
> root@localhost:~# ethtool bp3
> Settings for bp3:
>          Supported ports: [ Backplane ]
>          Supported link modes:   1000baseKX/Full
>                                  10000baseKR/Full
>                                  10000baseR_FEC
>          Supported pause frame use: Symmetric Receive-only
>          Supports auto-negotiation: Yes
>          Supported FEC modes: Not reported
>          Advertised link modes:  1000baseKX/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: Yes
>          Advertised FEC modes: Not reported
>          Link partner advertised link modes:  Not reported
>          Link partner advertised pause frame use: No
>          Link partner advertised auto-negotiation: Yes
>          Link partner advertised FEC modes: Not reported
>          Speed: Unknown!
>          Duplex: Full
>          Port: None
>          PHYAD: 0
>          Transceiver: internal
>          Auto-negotiation: on
>          Current message level: 0x00000034 (52)
>                                 link ifdown ifup
>          Link detected: no
> 
> Step 3. Change one side of the Link to advertise 1000baseKX/Full and 10000baseKR/Full:
> root@localhost:~# ethtool --change bp3 advertise 0xa000
> 
> Result: Link comes Up at 1000baseKX/Full:
> root@localhost:~# ethtool bp3
> Settings for bp3:
>          Supported ports: [ Backplane ]
>          Supported link modes:   1000baseKX/Full
>                                  10000baseKR/Full
>                                  10000baseR_FEC
>          Supported pause frame use: Symmetric Receive-only
>          Supports auto-negotiation: Yes
>          Supported FEC modes: Not reported
>          Advertised link modes:  1000baseKX/Full
>                                  10000baseKR/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: Yes
>          Advertised FEC modes: Not reported
>          Link partner advertised link modes:  1000baseKX/Full
>          Link partner advertised pause frame use: No
>          Link partner advertised auto-negotiation: Yes
>          Link partner advertised FEC modes: Not reported
>          Speed: 1000Mb/s
>          Duplex: Full
>          Port: None
>          PHYAD: 0
>          Transceiver: internal
>          Auto-negotiation: on
>          Current message level: 0x00000034 (52)
>                                 link ifdown ifup
>          Link detected: yes
> 
> 
> Logs during initial Link up failures (when only advertising 1000baseKX/Full):
> 
> [  581.429431] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.429437] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x03000001
> [  581.429722] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.429724] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x02000001
> [  581.542950] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.542954] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x00000001
> [  581.661399] xgbe_check_link_timeout:1292: amd-xgbe 0000:0d:00.7 bp3: AN link timeout
> [  581.661403] __xgbe_phy_config_aneg:1214: amd-xgbe 0000:0d:00.7 bp3: AN PHY configuration
> [  581.663591] xgbe_phy_kx_1000_mode:2160: amd-xgbe 0000:0d:00.7 bp3: 1GbE KX mode set
> [  581.663602] xgbe_an73_disable:422: amd-xgbe 0000:0d:00.7 bp3: CL73 AN disabled
> [  581.663618] xgbe_an37_disable:381: amd-xgbe 0000:0d:00.7 bp3: CL37 AN disabled
> [  581.663639] xgbe_an73_init:1051: amd-xgbe 0000:0d:00.7 bp3: CL73 AN initialized
> [  581.663650] xgbe_an73_restart:412: amd-xgbe 0000:0d:00.7 bp3: CL73 AN enabled/restarted
> [  581.763656] xgbe_an_isr_task:695: amd-xgbe 0000:0d:00.7 bp3: AN interrupt received
> [  581.763672] xgbe_an73_state_machine:847: amd-xgbe 0000:0d:00.7 bp3: CL73 AN Incompatible-Link
> [  581.763676] xgbe_an73_state_machine:907: amd-xgbe 0000:0d:00.7 bp3: CL73 AN result: No-Link
> [  581.763682] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.763685] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x02000001
> [  581.764848] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.764851] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x03000001
> [  581.765865] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.765867] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x02000001
> [  581.766258] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.766260] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x03000001
> [  581.767364] xgbe_phy_kr_mode:2132: amd-xgbe 0000:0d:00.7 bp3: 10GbE KR mode set
> [  581.767593] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.767596] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x02000001
> [  581.769699] xgbe_phy_power_off:2053: amd-xgbe 0000:0d:00.7 bp3: phy powered off
> [  581.772065] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.772068] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x03000001
> [  581.773534] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.773537] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x02000001
> [  581.773593] xgbe_phy_kr_mode:2132: amd-xgbe 0000:0d:00.7 bp3: 10GbE KR mode set
> [  581.773604] xgbe_an73_disable:422: amd-xgbe 0000:0d:00.7 bp3: CL73 AN disabled
> [  581.773619] xgbe_an37_disable:381: amd-xgbe 0000:0d:00.7 bp3: CL37 AN disabled
> [  581.773626] xgbe_an73_state_machine:913: amd-xgbe 0000:0d:00.7 bp3:  PHY Reset
> [  581.773628] xgbe_an73_state_machine:847: amd-xgbe 0000:0d:00.7 bp3: CL73 AN Ready
> [  581.773723] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=0x00020000
> [  581.773726] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=0x00000001
> 
> Anthony
