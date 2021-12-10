Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C047036D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbhLJPFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:05:16 -0500
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:17661
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239485AbhLJPFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 10:05:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTnRiU4I9b0VemuC4GvhMiwjo5AuIfVtEIzIy6OYFPXsJY4moLEQtCS89AC14ykDa2fitXRQPs6u08zVRJbxiCA+Vx/Dx0iNCtw+OIzL6jRnIWEr7AeDeze3tebF5gP0DR3QFchFKHkmUQZaV5mFSa0LolgFfgVh7+sadQ1Pxg/dUX2L30gDZFZAfe1CZfbKUjtmLw+imMcABGOm+vibmA8yFM+WG6T7CttZLhBg1m+OHGapNTLatWN/Ug4P2RGNg2WpxSwmRhNZpmlb+9QWJ97JOo0U2Id+yvx4Fftwgui8vLP7hfDKTx9802U/q0zEwp62uiR97e5cIuRfZ7MDDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9DX9VfoAzOjs0TzbaKmRWVIdf48qpG5BCRJ2NIe/Xw=;
 b=iFsb4mua1PKnJ148cBnLrioaomUBPKudB79MGuL4dDKbu6gZEpJyPvdCC4Do1uX/FFsI1oq0zFhI3vdXdc/1fOgUf1SsRteCWt4BCEfEcEDNUU1V7SaGxVF5s7LR9gKTItpsp7fycBHc9xJ3a9tCOF0CUsQ3reDAl44CHyN1MbMwDAIuw3TXJhVcs7Zgs/hd9/qILum7KfWOK0cHRdF7r3PD0eTBx1NNgO9x7lSYTBCd/kaZUOnZot3RTgIn3XCGN1yBr4C/wAqdj4DFare06dS5XYHE1dGVdUC0J3M97Bhkvm+dReHXRsF463LdNXMXjT4w5vTEk+9nyZ5Jtca9jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9DX9VfoAzOjs0TzbaKmRWVIdf48qpG5BCRJ2NIe/Xw=;
 b=EKBm33rnvy8oPTO4r1w2c7EEbQrE+8YWGeqc5FDAEtlCH6sjp61xjpybs6gRHFnlp6lzeRDQPfjyG/f8+ndeRE0PDvs3tfXIUCPpvjqDTyiy6kbIhtNq55Ebp0r+JZRsti8T4xxE2yX5FE29xpMqM1tvd1SfyvkIVrdV/wdeB0M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0302MB2821.eurprd03.prod.outlook.com (2603:10a6:4:b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 10 Dec
 2021 15:01:37 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4755.024; Fri, 10 Dec 2021
 15:01:37 +0000
Subject: Re: [PATCH net-next v3] net: phylink: Add helpers for c22 registers
 without MDIO
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20211119155809.2707305-1-sean.anderson@seco.com>
 <b0b80264-0a1d-f67b-b1ca-204857352b31@seco.com>
 <YbKnypYPOdhjsywn@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2557a874-4d3d-f9ea-3549-2e6dd351f6d1@seco.com>
Date:   Fri, 10 Dec 2021 10:01:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YbKnypYPOdhjsywn@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Fri, 10 Dec 2021 15:01:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c4e6fdd-2c01-4b6b-c13e-08d9bbedf685
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2821:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0302MB2821FFE2711611153FD2CAF996719@DB6PR0302MB2821.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5r3eWPYnNB7QnlTEqAT6LyELTcbrLrOPhC5IXs08uS0KGMFT0D0OddIkW36sDtQ0UpXQU1DV20OhDHX6uuIWMy9Resi29vgnTlBzCLIdHvsCvVb+jrJCWVbj82M6RBJpjk18B6hiM7y41Ywxu+yACtNCmFh7Eq4fhY1scYqROG7S6/BWxcKtjYdI9vp6Dr823sWC0RzSi7RQlyk8NiLNGXcWl6/kf1x3wsOUqeWvKZ0GYDztpwz3fWqZhnwADSmWtjvUtBYFXQAjZ9XpSJ0+aw7Y3Mh+WF3AmS/WZKXp+2GR7J9crP/xXyhlBp6D/oJFhn5ZQcMKjO5Dwzoe7B8glhMctuTss9flrOOyhflucG5uV8ReFiUmSjwMST4BaKkTids0WwQ3oZV/QQFobl/ieUVxd8PN3dAUuL+LJLdVJF8XlHZOnJU5+9ytgzADWbf9WH7gdnUmEKJohN9UKJmmcUyiob9OGzeiPsNkwKsriE0pJ9tCH1qT4B5QYBv5D3ktx9dDuzmQkWW/xf0f24EvqiUSEm1u+MS3YmBS52zQcQoPb7QHcLtLiulc/DsL9DggEQneqVhR8XB4GeqYOReLG+WSd2X5HzrVSEPD4QNGRvN0sLgphCiwFnnLWU0FEM5+H1upqIu7B7Tt+NcKZQTTsuFcZLpnqyfbQi8DALB77/JBif3u2FmsI8HaBjhhm/aoeTgAZ9H4DUgR2cQuLMX7sb72RrjLVogyBoY7oqUm8RMcshAKvk6RMM4j7ibKfBxWsFmt9aYB6mmwCLF6mwxPiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(4744005)(44832011)(86362001)(6486002)(66946007)(66476007)(2616005)(956004)(38350700002)(66556008)(38100700002)(16576012)(2906002)(54906003)(186003)(316002)(31696002)(6916009)(508600001)(26005)(6666004)(83380400001)(5660300002)(4326008)(31686004)(8936002)(8676002)(52116002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0ZQSmVCTHZIWnJFU3B6SmZWbGNYQ3RsMWtGaVhqbDVaREFST0dob05rWWZq?=
 =?utf-8?B?TXlacmxVbitMVGF4TDcvZTRodGZDUUdMaFBxMktxUzBWSGdFdTAxZG5LWXN6?=
 =?utf-8?B?Q29oeUdyNXNsRUh4Q3o2cjZlRTlKS1hkM2RCL2xCYWZDYitBcEZ1N2VUYXcv?=
 =?utf-8?B?SXdXU01HYnpwQU1paVBTRFlDU3NKM2hHc2Z1NEJhdktCNmJDd1FyUXptV3NP?=
 =?utf-8?B?R1hjTzFMVnZrYklJMTVGVlJxcFFhZUFpbmQ1bjNPWUVzRXRxMno4aEZoZTAy?=
 =?utf-8?B?V1ZlTTQxKzM0M0ljd1kyd0tqMnh0UVVQUUgra1M2R1FrS0dZSTczS1JQd3Ux?=
 =?utf-8?B?UUxmNHhxUzNWRFVpNkYrdnhneFlicWNqRnB4cUo4OTdQeHMyZjRsRXY0YzBk?=
 =?utf-8?B?Nm1Ybkw5SmtEN2ZyZG10Vk15bE5mQ1lsRzlUcFlkVGptcSswQ3B6ZkZtMjlY?=
 =?utf-8?B?cGdFcGpCLzhNdE5wc0UxOFV2UVNFeUxMNVZudms1TnJmcVJQYmdOYkNpV2lZ?=
 =?utf-8?B?K3NwaFJrYm1Sd3B3aFhhNlBqbUlZbFI5eUt4ZXFzRlRSZjZsclVvVFg2NmR6?=
 =?utf-8?B?S3VqLzVaNXhkYzB2WlA3aElnMitocW8xb3Jnc0ZES3VTVGo0MDVZUGJmTTV5?=
 =?utf-8?B?a3MyWElHNzkxalAyTzg2U1ZQSkJiaXAvSkpjMFV5ZlpxTW9acTRNdEZpZzM1?=
 =?utf-8?B?WFZ6TE1VTlkrOGp6ZDJRYXJjT3RSd01FTm4zeHd6Mnc1bmFOTDdTR0sxdVFR?=
 =?utf-8?B?U2l1MjQ2YkFNcjBTUFcwNGQ5RE9iLzRtMll0YXUxbWFNekRoNStTQmJ3aGI0?=
 =?utf-8?B?TnNqNFk3WGhDQk5HcXY0RUpGZTVMdVpZY3ExcXBFNHFtTXVrKy9IVllYSHdO?=
 =?utf-8?B?K3dmdEJJUkUybUtwN1FIOGx2cUp6c0x0UmE3YXdFQTBWaHpzZFozbXFNOTht?=
 =?utf-8?B?SnFEb1JZOWcrQS9zay9tSEw1SUlBZlRvTjNoNnMzTmhjT1AxQVBNOTlKQ05Y?=
 =?utf-8?B?K2FKU2xzaUNISVFsNXZvc1NQUmg4c3ZBS000NnMvYXM1eEVyMmEyLzl5RTVC?=
 =?utf-8?B?RmZiajkzdWhhbXRRS202dDBnRnlUK2FHMlpaQVptVkZGS0JYYjNPZE9vZWJy?=
 =?utf-8?B?NlZkeVdNaDFNSEROc0RLeU9lVG9QNDdhR0xyZVZNMXRIQmxvRXNsL2VnVkxu?=
 =?utf-8?B?azJVTjRHVElsUkJSSzlDcllZUGU5R3dzcHMzbWFrZ3Q5YmJISEhuYWJZcStq?=
 =?utf-8?B?a282RXZWdk45dnlHcGxlalo4VWVEOWpUZnI5TVNjZllIbjZhKzlVRWEya1NH?=
 =?utf-8?B?STQwOGZKSFBCNVpYejRpN3VXZ0pqMG9PUDg4NFBzS3o3YWVGTFBIakNaOFIx?=
 =?utf-8?B?cmRZU3lDTkt1VWY1WnEyelhuSTE2WWt5ZkhQdnhuQU43MDZYeXJ0cnVYaTB4?=
 =?utf-8?B?OGErK091U29LV2cwQmpLNXRhTG94RnViWk1acHFGSGpHK2poaVhUVmc4WEdx?=
 =?utf-8?B?ZkR2aENKMVRMcjZpMVQ5NzB4anR5aDNUSGF2VURRY3ZFdUl3bHpSZmpwZGMv?=
 =?utf-8?B?bHJIWEpubG14UmpIWEVkNGUyRTdpY1hLTjJvY0JzNFF4ejdlR3FDUGFYejJi?=
 =?utf-8?B?RFFVblA5akYveVNiMUF0K2VuRnd2Z3hUdzFvUFdFVDluVG81cVBEZ2VkbFpN?=
 =?utf-8?B?NjVIYks5ZUJPSXlPM2F5aUY1Q3IzNWVUTWZpZEZlL0ZhZlFvMXpuOEdOTmp4?=
 =?utf-8?B?KzBCaStGNG9PdWV5SHhCT3NndWZkZWNXeE1pdVk3d1N2NFJBejZzOHM2QlJi?=
 =?utf-8?B?dmU5dnpRbFpBSGJWU0I3YjVFcUFYdVowQzQ1SDNwK1R6RlBlVndndnFWaDRq?=
 =?utf-8?B?eFh2Wnl3czREQUtEYmlUK2JPUWpNcVIweTNEM3p1bWR3Yml6enNSdkgrWW5W?=
 =?utf-8?B?eHhGUjRqZ29FMnJKb1RENXV1L3QydkQ3UnFld2NWTGtjQ05oRk1ubTNtNk96?=
 =?utf-8?B?cmRRYmpwM1R1a29mNUxRSmQyek9COTFsZEJOZDJPb001R05BQUhLN2NRdTlD?=
 =?utf-8?B?bml1Qm9RMThIc05RTWRzT3NrQlYwQW93QlEwdmYyOVJjWXVPYTlKTWZHZk9I?=
 =?utf-8?B?UDF0ekZUMlVETFd0ZnVGT041aTN1L0Jkd0ZkRkp4cUxlOFo2Mks3ZjgrbktX?=
 =?utf-8?Q?+5V0eXetIJY596RVkuHkNds=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4e6fdd-2c01-4b6b-c13e-08d9bbedf685
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 15:01:36.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVNDEQfQnytkV6PCtjGQrjqWwEjbRfNdiy9w56f6fOjwA4bMw+ZrgNrDhKPQoeb4kX1/oN1QN/XsXstEsmk3Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2821
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/21 8:05 PM, Russell King (Oracle) wrote:
> On Thu, Dec 09, 2021 at 05:26:16PM -0500, Sean Anderson wrote:
>> ping?
> 
> Hi Sean,
> 
> There is a version of the patch that is in net-next:
> 
> 291dcae39bc4 net: phylink: Add helpers for c22 registers without MDIO
> 
> Looking at the date in that commit, it ties up with the date in your
> v3 patch, but patchwork has been set to "Not applicable" - I think
> someone didn't update patchwork correctly.
> 
> I think we can assume it has been merged, but incorrectly marked in
> patchwork.
> 

Great, thanks.

--Sean
