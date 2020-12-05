Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45E72CFCE1
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgLESTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:24 -0500
Received: from mail-eopbgr80103.outbound.protection.outlook.com ([40.107.8.103]:24563
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727757AbgLERoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:44:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhyVzT6SrZsFe8ujnP9eOPn1D/yZ+XQtKXlN5eO351YPu1XZ0/jFseKUPgSSjKl72lV3v3FPtmbkzSbEUnkiDZQNjzL2Eh5yvH0RHe3p0BLajCYBNGrOULt65/ghp1mjgzR3xrK6DffqAIXmhIfZjYXhUaAInK7Io9OSbpQLwCyerJFRPWxjmUrPRFTdkFtah+oAYhjGJ6S1Iur67rEa4xaeITZ2g+8Uzh5BfIIgIw3bQE17VjCbUSQ8xsps+xoo60XZwN4fk26RTGrei0diuWugoYJFwIkMoxtNjxCpXlXgMNyR4sCzf1BbO48L6KareVVd8YgPzWINmtdsI0RoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oJ1eIJKVDoL6Lb8TLMBghVQ4WLIkqh5EZQi3y63V5Y=;
 b=WPZvBtdyT5Kp4MKAudzsRR1I29WNoxGyUB7hmnKs63H7ALbLmUbFAMLRAYqWAqLcaqkUwehiMEc6NApy5kdvPmx9OMiuBrs6WA9n3TshLmRcKEp4xU2fn+5SZ6RiyztlaD+dzZ7a38gcLq1luEOGAMm8o/duy2ePzhUskV2dYuwP+8muWHCl+Qv9WsgeUaUWuEBCBt2g+7azcEx0pi6i7GPSno0k3NKzyps+fki8sLM7x5SRpFQFAgRttyWeZrvOfJzkOzcYW2rx2p9jmvAp90ZjVdBYSfsMFIiNoAB1HFJZngW1xkkw6lk/maB9tJNvOWmHKq0MNjP6IuoD4Hhq3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oJ1eIJKVDoL6Lb8TLMBghVQ4WLIkqh5EZQi3y63V5Y=;
 b=BH5xvxYsMbMxBBUBZ3o2Mzgby++bgMvcvm3VVMhW4Eac9J+1x+erO+xol3GHi0g9eKvQR90wDDEyP9mZvMoyNyXUP/tBPKcjiWk8zkZPN0l4Ji4LQTljEmDy+KSeC+U96oMyeK/DuVqe86OX7mRiZAmwFRajZqTPwa0aY7CaERQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3553.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sat, 5 Dec
 2020 16:02:28 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 16:02:28 +0000
Subject: Re: vlan_filtering=1 breaks all traffic
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205154529.GO1551@shell.armlinux.org.uk>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <5edbf8fb-f5f3-b3b6-7b96-6a41f25cbfc8@prevas.dk>
Date:   Sat, 5 Dec 2020 17:02:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205154529.GO1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0060.eurprd07.prod.outlook.com
 (2603:10a6:203:2::22) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0701CA0060.eurprd07.prod.outlook.com (2603:10a6:203:2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Sat, 5 Dec 2020 16:02:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d1140cf-1db6-4919-d484-08d8993729f3
X-MS-TrafficTypeDiagnostic: AM0PR10MB3553:
X-Microsoft-Antispam-PRVS: <AM0PR10MB35530B8C40D9835A737E509C93F00@AM0PR10MB3553.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivQV8ZVwnpIWRgLq/UBTuVzOQ3SlCdbNHoC7nlUiMMW0+0iidmAXtNRZHn+4j1MhbTozAyYvNgcZ/Jx761Q31t9pBN8vomZWBHP+Jh7GLatYdGaVpLyM+8fV3CmLHxUJ+Ph7T2z3CTICUEZtqq2MrWtryhor5POdeimlS4Lhbcv9NggKaIwRPXYSSlVzCD60GWE9j5vJmB8OOtQI63lt/uZoJ/3miXe0fu3hZf5JNONa50TOZDhS2rXw3MBOerDUbg4k2XTM2+jWgxb6+HeAEBP6sHHOu3OhhtIzC/LlmzVv2WxhXQoHfVK734k3PIMPzIzToVanm6ZqvEoCeprRmDICHh1v2SbPIKVZHqnJ+j/eOgnIkY0m1qYcy/DMt7OPftF660WU38+F2yqFDY1jYYFKuqHyQAe6c2zNmTPxgJlTYR7+nhh70k7fgUzGawf8rMjrRRwxQmeHimT96jPpLgdFp+m4LadasYOof7QEGHhU47rNAZ4KMWYIM0m8/D7P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39840400004)(366004)(396003)(4326008)(66476007)(36756003)(2616005)(66946007)(16576012)(6916009)(478600001)(44832011)(8936002)(8976002)(316002)(83380400001)(186003)(956004)(66556008)(54906003)(16526019)(52116002)(5660300002)(26005)(31686004)(6486002)(86362001)(31696002)(2906002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?vOelrGDKVSGZEF4INBS9WRvNQOoOI0qTBxciWDmzmSpOUKsMLs1m06EK?=
 =?Windows-1252?Q?PCKZ2jcRlIs0pzppHQI23VZ4w23lqu7RIqg8dSsbaTpV0e0SJ69mL2YL?=
 =?Windows-1252?Q?jz4bXIKKYIU63eUQDREOiyTlrVlBqlFCzjsc4lp7hsviHlVS8ztSJ6Ja?=
 =?Windows-1252?Q?iEPGDoxFUedIUWqq0v5Y2cHZJbOqW6sRNy2RuQZkiXAOlZ8oHLOlIzIR?=
 =?Windows-1252?Q?FAv09vGyKCGiBy1kpwkEzWbzYTtf4duFn1042USMStbHuFbAtaR5NmX4?=
 =?Windows-1252?Q?v8l+3+fyK7SwrnLYDwdELDuhLh3Hs3AkIDLM9qiJ/dzvq38eFuzmlDdp?=
 =?Windows-1252?Q?91Ovwd9j8T+OtdRMvJ/+8v3nAab2Qc4PpJ4ACRKHgH3vXLx3U892640v?=
 =?Windows-1252?Q?1nNjj51R9xX2nzqsVEQ0b+dhOKY9GcvqJzb8zXtRvE8sAJSG+RbUuLwO?=
 =?Windows-1252?Q?nNwaa21j5lOyZzi4UYf0d4Bd4r0kfJDIGZdH5Mx6wjMZUENogF1MEeHg?=
 =?Windows-1252?Q?C2yhpf+P7tromJB8RWgXpgsJL+YmqOlw+tgauNlrmSuL+9gDBAo/GVR2?=
 =?Windows-1252?Q?uAzoGEGZt7p7BeaH07KNPDQQyjwooGRduPk1+F3GDBUTm0Iwa2E0pZbQ?=
 =?Windows-1252?Q?oEr52rOlrX1/BzGnxXkq/Yl8KsJd8gfSSX5nIa86rXlD7mpajDEY6uUx?=
 =?Windows-1252?Q?SN+4XXjO1JM0F/NktmUDW3FOcjuhbEvACb4e+q4LuBPV+bzKEgCPaxU5?=
 =?Windows-1252?Q?oaltvBYukY4JcuWAdFK3COo28aU5deqx3HowKUhZnNP5u0EjpQZgpW/W?=
 =?Windows-1252?Q?9eCsCupuehkgAYkoMI5oUYVlHXhjRCcMTErVPcA9z6EfjRy+jT0Y5zA1?=
 =?Windows-1252?Q?xoroOWwkslfQakzKsTdIXA6RBTy10Ei38hamob9yXneBRi5S5bELA8Pi?=
 =?Windows-1252?Q?I8aI0CDsORfl8pdwW4DV/iEpTbPpTTHLlEEqhGOduC5mUGkra3hFHiDS?=
 =?Windows-1252?Q?EPtLTKMZ4GvmVnHVeUozXxyNlz5bGZjnOZXyYyRrxRwFksYDGlVcUOtG?=
 =?Windows-1252?Q?Hhf1grs1TLu3/uA9?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1140cf-1db6-4919-d484-08d8993729f3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 16:02:28.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITppPRcIP9GJTTSMr3AkmP99C7EK9nWOup2mL0QjaapLBBuHxJXv1ARSys7wsYcEoX9uXI2QZqti//hN2r4WQf14A20Ylr80ODSnBbfYnJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 16.45, Russell King - ARM Linux admin wrote:
> On Sat, Dec 05, 2020 at 03:49:02PM +0100, Rasmus Villemoes wrote:
>> So, I found out that the problem disappers when I disable
>> vlan_filtering, and googling then led me to Russell's patches from
>> around March
>> (https://patchwork.ozlabs.org/project/netdev/cover/20200218114515.GL18808@shell.armlinux.org.uk/).
>>
>> But, unlike from what I gather from Russell's description, the problem
>> is there whether or not the bridge is created with vlan_filtering
>> enabled from the outset or not.
> 
> No. My problem is where the bridge is created _without_ vlan_filtering
> enabled, and is subsequently enabled. That caused traffic to stop as
> soon as vlan_filtering was enabled.
> 
> Note that if the bridge were created with vlan_filtering enabled from
> the start, there would be no problem.

That was what I was trying to say: I see the problem whether or not
vlan_filtering is enabled from the beginning (hence the "unlike..."). So
since disabling vlan_filtering (or never enabling it in the first place)
makes traffic flow, the symptoms look similar to the problem you
described (and that was what led me to those patches).

>> Also, cherry-picking 517648c8d1 to
>> 5.9.12 doesn't help. The problem also exists on 5.4.80, and (somewhat
>> naively) backporting 54a0ed0df496 as well as 517648c8d1 doesn't change that.
> 
> I'm not sure what 517648c8d1 is - this isn't a mainline or net-next
> commit ID.

Sorry, I mistakenly took the sha1 from the 5.4 branch I cherry-picked it
to - I did indeed mean your subsequent 1fb74191988f setting the flag for
mv88e6xxxx.

> You will, however, find that the problem was subsequently fixed by
> 1fb74191988f on top of 54a0ed0df496, 

Unfortunately not. So either it's simply some completely different
underlying issue, or there's something else going on in my setup that
prevents the configure_vlan_while_not_filtering patches from fixing it.

Thanks,
Rasmus
