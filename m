Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABA3163F1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBJKfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:35:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6234 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhBJKc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:32:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023b62d0000>; Wed, 10 Feb 2021 02:32:13 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 10:32:12 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 10:31:55 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 10:31:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK7FN2f3HMtfG6CGPXsHOlYLq3FtZ/AMdDBR3otXPl477KB5+AXwp25qU9SYDB+Bmh9AqqZacO8bbvlk7bkj13a+nLA+zzSVLqCf1Kc5hsuF1y6JhUIk6y/w4xgdZhsECas5Vve066BAdEZcxY5noD9W9fD+yejTaCvDYSC1JRZ1oDUyqDNGBWLxwDuxdmvevIRRxNiTC+HzEzS+7MiFprLfE4nwW+A8VXd318GsDQX93TDKPbEpYTN/h7ggUKQkxaa0VsAQ2q3nT1J19hGedAfF6hxNhUAk8xliCzbSx6uADFFeDjzSywI5kgpvcXP4zP0p0XfV0gCGvAxrpAvS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLTHAFomU+Mg/TCDgh9di6anHsIucD8bjG1LXW1Y+8Q=;
 b=DYubxz64qUHW6/WE7bWTc0O3/bj9k5STctflES84KP7BOEErHZPrt3NrEHZfr2qbDmqSzEBJYyExin88pPdTQJnMME+SVefqV1LIX+Ich0D2c44xkv0o8FibwG1GRZOtZa/rg7kSrOFFZ3jk43vO+8LaDhd6cXrF49FnL8IUdClltIkiLrEiLLeiEYAdVMxJ804gbTSC+OyxCz/6TAPQtC4nuMVFufDCKMe5EkaKlyKWcg6K0O0QYz9tksPRPPCc81CEBlskLTcf7Dufu48tAvnsA+Ispq+no9v2ZIfeT2S4vnzRnmS8GQqLNK4i+wdwomosUQKeeW008t7nKCHsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3049.namprd12.prod.outlook.com (2603:10b6:5:11d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 10:31:52 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 10:31:52 +0000
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210210091445.741269-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
Date:   Wed, 10 Feb 2021 12:31:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210210091445.741269-1-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::17) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZR0P278CA0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 10:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06f2a207-adc7-43a9-eb6a-08d8cdaf14c4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3049:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3049A1FA949091080F20D2C1DF8D9@DM6PR12MB3049.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZf8tE39hFXxjqU3xXxwg5XZH2jGClf49umcZ2joh0zbpXn2rzX4lT+nnFImORmoltO6AS/z+60mv908S3EHTd7IH/SS8F/Ht4Kd9MC8FF8Jy/SOpss8BW2vJ8ja+08Yf0cAxQCxFdF+cTvRQ3EU7iNQCMeCVLVGQixA8CyI53RzfGsETjjO+HP93qf6Cpeom5vsH+mHJbd3QxdY5YaELdPHYZaOF7W52xNkBRlo966iSwz5NOfCt7RXdU3Fd5kbjUxFEzLUZdCq29geu/9qUT1HCeixVJlWbUDDf4MgMsrcayVyVsSLw/egkHJPCrboH+cEm841xkd6V2iu+v9Wag5NGptE3kLgvdOSI/nrXrk47AMXA4wcQnK1Geh7IayN4TK+IUbZnNyX2JGqeFWBq5Zujzy8EDl9hM3Vt5blOaTOUmi0LELaUP7xvmJE4BQFMCv4nt/4O0PMtITDNYBx7NiRqzdq13xEWvcLLFto7jISX50yJrvmv2q2ue1TgeATUKpFmGzANFuxaVIZEoB2wrp/Dya9tGMxS5c8ds8090b36To+MpHHWJWgjsIvYOg+SbvFAG07RbIZYZLUYOvohrzn6iT73+Lz6AVFdYL83QY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(16526019)(6666004)(8936002)(53546011)(66556008)(26005)(83380400001)(36756003)(478600001)(316002)(186003)(956004)(31696002)(86362001)(54906003)(7416002)(4326008)(8676002)(6486002)(16576012)(66946007)(31686004)(2616005)(5660300002)(110136005)(66476007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aG45dzNES0FhbUl6Q2ZOK0FJL2ErcGxUVlF3RmM2MlFsMDUyVXlEeVZWOURZ?=
 =?utf-8?B?RVJ2UGtHcDRFUWtDQ29EamR1cFprUTNQMnJHdHQ0bnVjVC9RWG13RjZnOWRT?=
 =?utf-8?B?Q3JxVzN0Q3k4NmdoTVNnbTdIcjZrM1VLOWdJN3BURXhGZ3pCWkM4QTJ6R0lJ?=
 =?utf-8?B?ZHZDRVZadXpNYTJHZ2JGZ0c2UHdYUVdLeHI3aERYN1JiMVRUQ3BaT0lTTGpZ?=
 =?utf-8?B?WW5YOHlkQmc4MVE2b0lreTRlQWlsUkFQS2ZOODdETk5QZ2pqUTJ4ZHdRc3A2?=
 =?utf-8?B?WEJENE1OcEhFbUQ1Q2lDSGwzK0E1dE15RWdjL2hRcHc2MXgrQjYzZVVPRTJO?=
 =?utf-8?B?NE1KV21MVHc4SVhvR01xa2FBT0xqQnphSFpHb0I3KzVWOGhOUnF3ZlY2a3RG?=
 =?utf-8?B?Yllhc1grcHhCVGZDR0JZeVBvNXlRREtxN2lRU3kvRFJoME1EY292OFY0V2xl?=
 =?utf-8?B?QlRHSU9JWFZJRkhPVndBbUhEdFVpWE52dW01azNzcmlkZEhJdHVYOVEzR0Vv?=
 =?utf-8?B?bmwyOVZpTzdkWnpLSmRQemNWaXlNa1FRUXFMWTRTU2F0SE8vcGZXTHNNb3Zm?=
 =?utf-8?B?NnE5YXRrNXd2VCtFemt1LzZxaStXUlZIS0VDRE1wU0Q2Z2RPa256ZDA5UUp6?=
 =?utf-8?B?MnlWd0FCeTB0WlArb2Q0c1EwRGlrYlFXbHRvdk9IWGM2aldiNTJUeWtwdWV3?=
 =?utf-8?B?ZEkrVDM0Y21hSWRvMGFrSVQzNXBBY1FjMDFPWkNyc3hDTmtiNTA0NS9JMitU?=
 =?utf-8?B?dmFLTmU0cUpMTS9LQ29Dbld1Z1czMGxxWnViS1I2NzNrOWgrZlk0N0JJWndV?=
 =?utf-8?B?OTQwN09lVGExMWh1NGhRSUNyRGFRcTI5Q0lVMjhINWhWd3R1aHZyczZhN2VU?=
 =?utf-8?B?N3JFbUJsTlhkb1hCZlYrSnVDcDNkeDlHeGF0OFN4dnEzaHZUK1FoTlFEZjN6?=
 =?utf-8?B?WVF4UXRiTS9SQVZtQ214QkRDajZQWEtmbHpPTkdHMW1teGVFN2l5RkJQMUNh?=
 =?utf-8?B?RDREVGdhdE0xR3FjZWZ0bFp4eGVCeGxVZ1Z3VHI2NlR4aXNDNnJ2dGd3WVpz?=
 =?utf-8?B?T3hQL2tsanJwaVJhRzdUTTBuSmE4ZHpxNmE1VUhGaWc5UndmNDVZNEJ6TGtP?=
 =?utf-8?B?cnAzVGFXeGJETDNaMEZFaU9RWGZVcHp0bTlhaXA4QS9ONmJ0UzJlN3dDRGsz?=
 =?utf-8?B?dUR0YWkzVW83WElCYUlOQjFKMlduM1JHaHhUVVZXRzhFNXVROVhuVVlhVDdD?=
 =?utf-8?B?Y1VJaHRWek5Od2J1VzBLclZuMXZERHVtMzM1bWVxZjBYS2NFMUlrT0xiZEoz?=
 =?utf-8?B?d004UEl4TTFvamJENnE0RENRRzlQNUlQT3VZUVhOOWFBcXNMTnlxb20yRURx?=
 =?utf-8?B?MTBjQ09pSDB1Y1VYNzQ0ckRsdk5GSW1RTjltdEZiOFVJSGdsZGZvYXM0L3g2?=
 =?utf-8?B?UmprMEllWTJLWC9HbWtIbkJyUWttaDMvN1pnNGs5bzRWbDlpR2Urbm1oQ0Nt?=
 =?utf-8?B?eHQ3VmRQY2JnUGRSTUxhV29nQy9TRVhmWms0dStwckdORndXdHZyK1ZiYTZ4?=
 =?utf-8?B?c1VTSk1UeUV2UjhMQitWbTNLMFIrZk5BNnFpc2UzeGh1ZkpDaGNkR3gxTmYv?=
 =?utf-8?B?TTZNU1h4NXlmb2x2azA2eEFmeDV1ZmZLRFFtWnJlWGR6NTJ6QW1hWFZNVk1T?=
 =?utf-8?B?dDcycUQ3TkRwRkM1akpXN2ovaVRDdmRwTWdmNFgxekNlQTlidHp5YVRXNVlx?=
 =?utf-8?Q?tQ6hSfr0sv2Iq0YqG82LL0jDLtlyeUgoPmeoRyr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f2a207-adc7-43a9-eb6a-08d8cdaf14c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 10:31:52.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SI5eUvanbAbY8TXqk4QlJxoZXEw7SiQuwC4Y4Ug5mLGnOSWa9sn/Fjc2ZldtphO/toRQXIG+d4WMX3D8EyoBGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3049
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612953133; bh=KLTHAFomU+Mg/TCDgh9di6anHsIucD8bjG1LXW1Y+8Q=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=RvWsLAc1VzBgLcTIAoBLNt0HOG/go2uVVHpIePMQJoaELyh6cfswvVWyT3NqVfoCB
         Xzs8Idkrxkx1YKOALISdTKCu/uXoM20DUkvNeKQP0T/SrkE6zv9FiEdgSe6WpP5Yax
         YxHuUY84z/z9V4QDr542VHU2/iGfLjs1sda9xgJuzMOCRaa5B2vsjJzmCzlgX/t+ed
         wFA9TfkublGR0+91HtvaICjJwBJ82ocm50aoJoOPDPqV1BzRXMl7CZSbYVd0ZDGCZX
         OffFkyJF69+JCvpzvWROgHkxMtV92bNQnaqwKp65WAuahWT34St0MsTya3GaWY+8eM
         ww9dM/udbZikA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2021 11:14, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The initial goal of this series was to have better support for
> standalone ports mode and multiple bridges on the DSA drivers like
> ocelot/felix and sja1105. Proper support for standalone mode requires
> disabling address learning, which in turn requires interaction with the
> switchdev notifier, which is actually where most of the patches are.
> 
> I also noticed that most of the drivers are actually talking either to
> firmware or SPI/MDIO connected devices from the brport flags switchdev
> attribute handler, so it makes sense to actually make it sleepable
> instead of atomic.
> 

Hi Vladimir,
Let's take a step back for a moment and discuss the bridge unlock/lock sequences
that come with this set. I'd really like to avoid those as they're a recipe
for future problems. The only good way to achieve that currently is to keep
the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
after the flags have been changed (if they have changed obviously). That would
make the code read much easier since we'll have all our lock/unlock sequences
in the same code blocks and won't play games to get sleepable context.
Please let's think and work in that direction, rather than having:
+	spin_lock_bh(&p->br->lock);
+	if (err) {
+		netdev_err(p->dev, "%s\n", extack._msg);
+		return err;
 	}
+

which immediately looks like a bug even though after some code checking we can
verify it's ok. WDYT?

I plan to get rid of most of the br->lock since it's been abused for a very long
time because it's essentially STP lock, but people have started using it for other
things and I plan to fix that when I get more time.

Thanks,
 Nik
