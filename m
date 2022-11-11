Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298A862634B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiKKU6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKKU6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:58:33 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70079.outbound.protection.outlook.com [40.107.7.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F1413E3B
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:58:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTHaLOH/TNL2TxeGCecT9GxQa2hoveK66nu8tqy+7ajfZMxtSTjDjJJzAd6tQCwlzPEJ/peYdfgoTxO5G72nE3UfohUPNp50ia7uDDGRjT5sbI9fmGBClYPyXd+wDboMiTq4mLucXlcb3lYmEkda250AKTFTy0M2/Pb4TE03Sj9gpmMMvdA4Jkt+VfJkyhe7aAQbMLaoW5qrYTfwnUQZrS4ui1Nu5MH0jntNYB2UXnXSvJm8+CeA+vcLe7uDxFqVKAV70Wcqkp+EjHwtFcZTf+uD2kVjHd0Y+028ftm00BgZCgnmyV/zZER0hu06E1WNsKnSuACnU/x2EyY/e7Wsgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zlsof9ZxCCIVTGCyybqidadM+ccqWsbVdfyYQk5oID4=;
 b=cARJCGy15rWSTd4i+MP4NqJ0uTcQdF7jTxMe9ibkX+oDp2rMOfqZBP00SLnvJgnZa7SXlh9hh7e+t5qi+d2j4sSmjLfqN21YpcCNyb7MVBmjQkh4J48ceD4rtKcPuSdM5hz98k7P0OixEwp5VvScuNcIMJAKMKc2ZHy+g/+w3uJsusV5oOaD/8gcVkxhpzQ0zFhFO94n/wkHU6Ba8fhCOsz+RgVkbmdEHBerY0C8za4Yrji7nf2DICU9/ynHeIr2A58OE5ag45CDX6AI9c19HsQ+tgWBmlMlcoDEt0JzDcToO5tH3ZuYF0Oc3fv1dXYxTOPlZSRO14ZCJXIg26sTjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zlsof9ZxCCIVTGCyybqidadM+ccqWsbVdfyYQk5oID4=;
 b=RBgszvdFllGDMFxX/JYi4vac6yM1PZubwSYJlBjfJYMkwpW8lKJCy0D5KcP4ex5cKDkeurus81e8PKpICNdGG7eQ+NmDcsK6IY7v4kx79k9KeLlNOPwILIoyIVSht4FLZ5aIoG+fLt/XqGv1NdmUxN59hYRMXzIIBqNqoqm2wm8MVmKHHGZcmnCNdH8i3FCd37UfWhpujfJgpeCcPQgSW/dXq5CsaFbMFbu/bS3ocfW+I5Nwh2wxMUCJ2tiPzRmL3nSEMt8r6wCs2TsX0BzWvAcFlUaXkNUuhrOxxBAEryXusRlZgZyJLxj2BmGWunL8U64/f1rTxeZUczXB57vChQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM7PR03MB6499.eurprd03.prod.outlook.com (2603:10a6:20b:1bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 11 Nov
 2022 20:58:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 20:58:26 +0000
Message-ID: <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
Date:   Fri, 11 Nov 2022 15:58:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
From:   Sean Anderson <sean.anderson@seco.com>
To:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
In-Reply-To: <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AM7PR03MB6499:EE_
X-MS-Office365-Filtering-Correlation-Id: c92a7d80-dcaf-4664-dff8-08dac4277a6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RgqSBUxB7Q9aeMbvP80SSz7EButWbD0MNBr1vVZdG+xv0+m2LFbpNndOXhiYmJ216zdAWwO+OwmTcogmlYWyFLR6Kob2SEJdEW+emmXCyNAl0jAHs04JF8Zcpa+yS53eU2Z83IuXXzyB/GrVuTYKg4XlVtiiX1a2UA/DIgWRUyFFzdYlsH3ncM3YtFRb10iolp0wfP+gvK2QyBV1/z2cfS/k6VPfDQe71SDH7HR1a0SkYF/IFM6/kzCaeSssJy9v9zsM2iLaL/IFWGujciuVu1JIJ2XMxdbDWjCRG+iJvUNO1zxhXpUVCawOe/fuvob/N9/rPQ2PQ0sYbWS2rVM1QqJE6FgffgjIuWfA4VfyxoEVi2VdmK8rtEwK+VFdhjfnAQDSdGCt+3Ujc2bjix6+/ntk/tZqZ5/UgpJluZxNZEWt6/xNTGh5qelIaKq0EhpEr35Cela0qXjpnzdgg31qMyJkuoiCu/OcLvsE/QBWahqlcGKcpxWfTNt1Hw6Lt0SFBW6DqBe4q0C9U2RoldvQHoZMT4SkPMV6ZyAh9tyJdSv/BHaDEVxeaavtBn91OtZhSaA9aqu55klPvFvsqJhweNIo91QczKAROSQ9fWRMmCTlP10N1rGJWvIeEUHdiv9vIoN9m/aU4TIoZRZRJz535IaOSw/jrcQbhpjbx1iJoOTciIXb8Ocxm9DgMHKA+aMIwBeC2w4Zdt6DLbuhl4Au/nXeleMGaHjjaJ4zzsVFNDnZybMr6dodpquvifqJw/i6RotyQ3jmZJlHrz6vYuoQAexH4Lphw3GvVaCdsJIq7K7+CdCdMom5BocxMYN2KasK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39840400004)(376002)(396003)(366004)(346002)(451199015)(110136005)(316002)(53546011)(52116002)(41300700001)(8936002)(66556008)(6506007)(26005)(8676002)(66946007)(6512007)(66476007)(6486002)(6666004)(478600001)(2906002)(44832011)(36756003)(5660300002)(3480700007)(38100700002)(38350700002)(86362001)(31686004)(186003)(31696002)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTJ4QVFPRlZ1cWhIbFd2VjJXYnluVmx1Qm9oY0VDZGhWTzVkNzlHdm9YM3lO?=
 =?utf-8?B?NUV6Sm5GRnBhS0YxQTVGSnJxaUlPZm9lUHZrdmxqeXhPRFJ4bEV2VC9HeFBG?=
 =?utf-8?B?cmVpaElRWG1rVnRGWUNmQ21BTzRiQVV6ZDZRT3d0TGlUVGRPMHFlbFc2VjVo?=
 =?utf-8?B?TUpQQ1ZOUTErRUdNU01SazNIdnYzYWsxbmxtSkZlSW9STERSc0FHb3JLUG1o?=
 =?utf-8?B?QUIzV0xjWnJoRW9zQUwxKzhFbXNCMFg0Z0t1MisraTlSaVF6OER4S2x1Ynhk?=
 =?utf-8?B?ZWkrdGM2bi9CWUNtcXpwSEpXdlljTkUxSC8vd3l6VC9UQXExeGlpVXZDaUt4?=
 =?utf-8?B?T0ZNbVFpeVZ1ZmhlbDBDbDE1VytPTVBIRWo1MHhUZThVN01GczlyRjlQTWZR?=
 =?utf-8?B?Y2NnZFQrYUJPL0N1TkJmMDU1Vkxjd05Pd2JSYVdKRkRoQ2JaZ0lvcUJ1QUVt?=
 =?utf-8?B?empjY0NJbm1JSExGSmZ0WVZISkRZZWlwbjAvNzVqaVhMNm0xV0tQcE1pVVNU?=
 =?utf-8?B?N0R1Uk90RVFLV0dHZTRWaWRIdVZaSFI3L2MycW0yd1FQTWh3SWRNd2Q1WC9N?=
 =?utf-8?B?eit1N3B2bithNW1WMzMyWS9hTTlWYncwbi8rQ3BRUnRMcjlubFM4T2hIeHAv?=
 =?utf-8?B?aTZvNlg1L3pTUDBLQUZla0xjWFBIdUU1MlJLdlBvNVBFc0t2dS9YN0s3UGxP?=
 =?utf-8?B?em9QUDR6N3lWMnJNbGNMdTBxVmVyM1RkTDZKS3FzN1RCbEZualFBdEJwdTE4?=
 =?utf-8?B?Zkhud0t2SUZQb0hnQzM1WWs5TzJVRjVKbXU0bFF1K3BiclVBWkYyMlJTSzNi?=
 =?utf-8?B?aUdmM2s5dEF2QmZMbHhpMzBwaFBwOTdUZXp6NWovbkwxNVRlUDJ2WVVKZzJa?=
 =?utf-8?B?Mnc3eXlhcDI3OWV6ZGh5N0xFazdOUDdzUFhybUo2WTUySG5vY2pzQlkzRE9T?=
 =?utf-8?B?dWt1a0N1MnhNVlREYW9rYlU2MllRTlRBVUxrVEs1Y05ZVzZqdUwzMjJJTFRl?=
 =?utf-8?B?SHhkeXFFWUpOa1p3TW5JTlpFK0Z6VVkrbmFmQjNteXBRRDhkOUVtUjVTdDdj?=
 =?utf-8?B?aWRrVGFDYXdmM2E2WTFzdVlhNEtUR2lpVVlTdlBVL1c2ck1wLzZzRnVReUlk?=
 =?utf-8?B?WGZmSU1tV0pkZDU2a1VBeE5XalNtMHllVFhYVjhVQW5zWG5GY2tyaXBmVkhk?=
 =?utf-8?B?OC9qZDczVmFhV2dYMXdxbmF3aUgvQ2FvY3dKNlRPcHI2VFNDQnFXaVJIK2RV?=
 =?utf-8?B?dmg0a0hoeURYUGdOMTNyZ1dMalpIRUFTZSsyVzhHNjEwaFB0WG1qbmVNVGo1?=
 =?utf-8?B?Wjdma08wSFlmQ2F5ZE9JOVhWK2xOWGt4TDB1c05tK2ZRcUk5b0tGaVJlajc4?=
 =?utf-8?B?cGhHM3pSNHlnTEVUR0hQYjdPcU40NEtsMGl5QjRuTE9kRWFOVDVUVFJSUGVV?=
 =?utf-8?B?VnBxa0M0bFlXZ3czUmNYYTR3MnBDeUt3TW5ZZ0p0dVlMb2pCN3RjQmh0cTJx?=
 =?utf-8?B?LzBJVlh2UFJNbnpmdHlCcmtoTzdXQkkxSHBxNmVUZE9KQUFGMFRBV1A2STRr?=
 =?utf-8?B?cXFueGtwK24rWlZKekl4Vmg0Z0UrV2xCblltaEhMaDh5WTJXUkR5c3E1OE9X?=
 =?utf-8?B?RWdPSjVUMFg5dWJrWTdDTWgwMGUwb3BQTndJNFpzNXVZWDN3YjdFVERIcW5H?=
 =?utf-8?B?QWw2WlY2SmVmaFdGVkRqak9iWFNJdlZaRVQvVFJsWHE4NWt0a0ltOUtWS0wy?=
 =?utf-8?B?VFlEVGNVKzdld084bTRXaHFCckpUYjZzaTE3eVhxK3JGdVIyQk42WFZlUDNr?=
 =?utf-8?B?bHh1YW5KWUthU2VmajFMS2FHV3gySzcwU0lwWXNuSXJCeVVPN0E4ejJyaXQx?=
 =?utf-8?B?OUozZjE0VTl3b2w0eEFvcW9aYS92alUzL2tHdGFlblBkZmYzRmk4SHZYeDJo?=
 =?utf-8?B?UkptSTZ3aStENWw2R2xWR3dNaXRGa084elhNVkVlVkR6V21rUlhmTW1ORmls?=
 =?utf-8?B?M3l6NFRJZU1Ub2xYQ3VYYkI4MEZvc0kzcU1zc2tjSHBkMnhabHhlSzFUTDk2?=
 =?utf-8?B?TnF0dmZLdFpRYzBnSWJoVmVoSFdZekZ0dW9lOUsxKzhvWlAzRUJhSGpHZ0oz?=
 =?utf-8?B?RG1wT1RDalhsTUM4OTgyb0ZuTHlhY0ZPSzRzSHhpMllTTG9rVWhSTFFNU0FM?=
 =?utf-8?B?b2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92a7d80-dcaf-4664-dff8-08dac4277a6e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:58:26.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmxbEGbGAe/C3rFtctBWrNZiy6U7HBywmqr0F23x+cgyXiL7qGZbvo0O9aJvHtETQCFGsDgv05AM8DS6wul4Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 15:57, Sean Anderson wrote:
> Hi Tim,
> 
> On 11/11/22 15:44, Tim Harvey wrote:
>> Greetings,
>> 
>> I've noticed some recent commits that appear to add rate adaptation support:
>> 3c42563b3041 net: phy: aquantia: Add support for rate matching
>> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
>> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
>> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
>> 0c3e10cb4423 net: phy: Add support for rate matching
>> 
>> I have a board with an AQR113C PHY over XFI that functions properly at
>> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
>> 
>> Should I expect this to work now at those lower rates
> 
> Yes.
> 
>> and if so what kind of debug information or testing can I provide?
> 
> Please send
> 
> - Your test procedure (how do you select 1G?)
> - Device tree node for the interface
> - Output of ethtool (on both ends if possible).
> - Kernel logs with debug enabled for drivers/phylink.c

Sorry, this should be drivers/net/phy/phylink.c

> 
> That should be enough to get us started.
> 
> --Sean

