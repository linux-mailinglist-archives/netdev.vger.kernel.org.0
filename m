Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B262E017
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiKQPjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiKQPix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:38:53 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70077.outbound.protection.outlook.com [40.107.7.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281B8165AD
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:38:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8h1vwX9+BHEYsnJGunlFL4q8XwfhVImbUlBYEpyDn3+vBo/FOV2qkuRKoe+DSeewVRVxg0tLH6eRT7Zmn+XlrTdjMEEjZaqESzWKCWZ6y2zMdqdKccEBABwPe30ggzrl/kEhXDueGnf919gOojaEFI4YMOJG8QkPydMz+N4OVJet8DgaMr4G1uGrMZ1vnAS5waEtclC2rdHGWiKM1X/Ga9WwSSrU2Ayi5FPRMo2Y0Ns/TeJNf8vaPwV5h2frUbQMdYav0uaoJc3qpi7kOUFVWq++pi4f3wSyLFN+U0jYrdrBNB9DBiE7eq+YsB88982IkfBLSpWx9bIue1xkV6K7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8jSVVER5OzIJSKdcSr7QhP3yvkKb2+qtncQ7K+7fX4=;
 b=Tjpq+7Xe2y5ATwn+PgbAX9gnrej8GFmvWGUtKTHJajOI+esm9gYaWtvoOG5culwAbkoDW5chbhX8NUIradiKilA/PFyEjp8mjedVWagwozVqdsvqcBiOTpJDO5fV2izFcA2bo/PkkesOaZ0RDHZFQ652wcpOpVmNMTLlSGl3iMDbAk2bW8sk9c5dMqywGLfoACUyUg1zoi2HAMxYFJnYo7JwqoaZYovWRy31qf9I17C+nuWLDLVyU99DzPE2f8Pf+EF9L9cHGLqWZO+d0n4TSuQ9GuoTB1n1QPcSxxtd1P4en8qxSsxEBl3Mo0ZaDFLSOSz0+qM5QdpuGFC22jY1Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8jSVVER5OzIJSKdcSr7QhP3yvkKb2+qtncQ7K+7fX4=;
 b=CxLP16G/BSChvYGmpNvHpwOSngSpwmqsuCFRqX/uSxz2SdxbJmMIdKEBjdV43P5jSxuFwo71KdUGD/n4dbNpEt3noMu9BlZlBCKBiWhunwy5eHQrWNah0sBYavLoyXHAWaaBHPXvHH//TcqN11fJUKGNXCPHbiPDX/UOhh10Opo5vwjZpYsRRUxnPnD+zy538D2KwQblDb5teFe5I/dWlQPr8JRaNsr47uK1zQZx2AQwi2Uxxeou0s1Qztf5VFvZR4kMPLeONtzjLmR0i0I8lVwuL0a8rzYkDOr5b3k0IYNojObPXr4dUTb4ml5sYe98oFjCZ5oz8F+TR3cowOp70A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by GV2PR03MB8850.eurprd03.prod.outlook.com (2603:10a6:150:b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 17 Nov
 2022 15:38:40 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 15:38:40 +0000
Message-ID: <af134bf0-d15e-2415-264b-a70766957734@seco.com>
Date:   Thu, 17 Nov 2022 10:38:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
 <CAJ+vNU1-zoug5CoN4=Ut1AL-8ykqfWKGTvJBkFPajR_Z1OCURQ@mail.gmail.com>
 <CAJ+vNU2pzk4c5yg1mfw=6m-+z1j3-0ydkvw-uMgYKJC28Dhf+g@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAJ+vNU2pzk4c5yg1mfw=6m-+z1j3-0ydkvw-uMgYKJC28Dhf+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:40::21) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|GV2PR03MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c826e7-d710-4139-13ca-08dac8b1cd1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ITRgaAa+T1zXO3eVcrWvDSSPruicaa0JySP9WUZHEqzTiRyAtTJ4j1egEyYjYnuz7MJX4XFrA8ouQrUlaqOPftEVvqyRqzHxVfY0dWFsaWvzaGBE2+YqVmpzaFRSofmj6QwGaTqub7YKk1LsM5JjDRGRKEr9z96/6t2snXFThsWmTiHwfPESUPrQ2T3fp2qwVM51/zG3sMPoezjT8g6Ybm1jXHDyTP7JP3KFOzXRREwq+pfXUI6gUxHSmQcKDpHH3j2N3FHDUgWeOlVSKP50pZRa2A4SeYUabTla1v2vzpLnC9PluVJBCF1lX7njsQGXaA9uLVxM9O8OrAunCzbAy0wbSXrgLbdUxLEQEKZEK59B/CVg8O4WYBARJQluYirYY/Z3TS+uag9j+pxcEk6DUskTcD3os7j3eJ6LYtsC9tTRielNGI9gGoPyJtaxdpGeS823yfoCw5Y5HaA+Fw5ouHYrWGhafXUnsN9ZTCzql6MbkCEgJaKctrZGpFYe8Ieycq4yvSztqQIK/XJnF0EPBs4SG3MzggTpq+2ytpIMoTQzzrlmJrQDM/I58TPSubQup2ajp3pIy+T4DBvrr7XCHg3+1Kmk33yx8oMZwcZFGZ/XdNvGAqnnMkNRc5JUgeGtyqx5XgHJVbmOqIOwUWwG3zjfJYiBGmZlv3r3NzuBlOvpa53q1KQlHCObYz6qKSmt4Xn6pD2ObYlUKQEjxENhUnU8ICung9DbFzM9YxvMRRhuLgrf4/SzMJzUTGIOrM+vqxHVEmfHMs9ET/Ldfe0etQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39850400004)(366004)(376002)(451199015)(6486002)(3480700007)(31696002)(86362001)(38100700002)(83380400001)(38350700002)(8936002)(53546011)(5660300002)(30864003)(66476007)(66946007)(4326008)(8676002)(66556008)(41300700001)(44832011)(26005)(6506007)(316002)(6512007)(52116002)(186003)(2616005)(54906003)(2906002)(6666004)(19627235002)(478600001)(36756003)(31686004)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHpYRW1xaVVIY1crbmR1WUlwZFV3STZURHJIaVNRSTZqLy8xa1pBTGZMeW95?=
 =?utf-8?B?VldFQUNmamhjM0VYS1Q5M01teUFVRlpMY3RGbFdlL1hLS3hQUXJGQW82a2wy?=
 =?utf-8?B?Uk1CTVcwcHZYSW9vZDVQVUxKZGp0cEliOGxnbFVhNzVGcjA0VU4yT1ZDdlJr?=
 =?utf-8?B?RUd0dTZMTmU2S2JTbmtNMXNoWGlhdUYxMHk0UnJpWjViWUtRQXdrdXI2cVpE?=
 =?utf-8?B?VmNlSU1qV3ljcTh0Q3BTZjFJNHZIVjN3SDNZcjRCUDhjajF3d1daa0k0R0xZ?=
 =?utf-8?B?bnRISmVKSDV1WWJVLzNPM2o2RkQwd0pWMlNFMWovei9aRDRhcHhydHlrM21m?=
 =?utf-8?B?S0JPTjQzRFhjZE5FTnlsNGtPbnRKWCs1azB1a2dlSnhxZS9sYUhOcUdLeUNX?=
 =?utf-8?B?aTh6V3RNNStGUGpQSldmdDFJZFMvZVZzNTFrTTZkQXJ1Y0NsMjJ5MG9LWU9P?=
 =?utf-8?B?T3lKVkd4V0ZCQmVtb1lLaFJEc1JDcUJqdUdaeTBxNFNWdEtRTitmUU5VUGlQ?=
 =?utf-8?B?ZTNQM3M4MWorR2FmczdTOXlUcFJ1Z1BySlVQYTJhTVY0R25mOVd6REFEUHM1?=
 =?utf-8?B?VlphZk43bFR0ZEF5cE96NlArU3NjQVhidTlyQkRmYkUxSmwzTW9oVXlHaHJV?=
 =?utf-8?B?ZkJzdWpRK3NCbjdxZzR2Zy9UeC91NDkreFZGV3JFdmtFT0xNUzdLdXh1K1ZS?=
 =?utf-8?B?YUVaUVpNeXdIbXJRdXRGSERCT20zSjA0ZU0wUm0vRmV4b09semRoV0h6dXBs?=
 =?utf-8?B?WHM0KzhIanQvZHhQaWNDbkZvejRlczNpY1NjZksxc0RiNGw4akt6cWMzek5s?=
 =?utf-8?B?ampJZ1Z2VTk5WExXSXlsNUpsd1hZSURLMVkrbEFYZnl0cEc3cDMxUzYxc2tX?=
 =?utf-8?B?aGxuUmJMN01QdFhBVmpieWJ2TE9KWEQ2NGgwRDJZeFo2bkZhTTU4Uk8wMUdw?=
 =?utf-8?B?a0dzS01FZnZpdWF6VFFlSjNRYWxUZkRORnFHaDNyUWpFNHRsRVZweW43ejlL?=
 =?utf-8?B?QUdGOW5sZVlDTGh1UThVcVFMdjF6aTQzdkZOcnNmNjl4ZG1xUWtPMWIzaGtZ?=
 =?utf-8?B?aTRxWklDN0o5ZlNpbmlEbzRtT1ozUEZtK3Axc2lnKzZhMXNyNkZ5QUJnSCtC?=
 =?utf-8?B?UW1oNlVDcnJqRU96MW5tUXE4UzV6RHVFdkJSTHZxTHNHU1NLOVZkUktlV0VG?=
 =?utf-8?B?UTFoSDhqeTFlUyt0bDlWVkU0YUc3cW9QbVdvWkJ0dC83dU8wVVpDdWNaWENw?=
 =?utf-8?B?TTA4bnVGTWR4SVFibEJTWFVUS1ppZTZFNHJycVFRZVhOOTFTUXlkUkxCZm5N?=
 =?utf-8?B?Q0VYQ2RnczBhT01IOFoyZmVtVFd0NzJpQis5amcxSEh1YWQwUjBuU0N4c3dQ?=
 =?utf-8?B?Q3ZpVlI5MDNBYS9yZmhaREppMVVQTTJ5L0wvaGl5T2krYmZ3OUt2ZmJtaHd4?=
 =?utf-8?B?a3NQb2tQeU1qa21KYk15UGtJM1B4Tk5WNlBaSGRnR0l6Nmw5RkZsZWlrSjVE?=
 =?utf-8?B?NllncVlvaEdUQTVyczVVNVduVVJ2dFhBNVlTR3Z2dFU5cEtReGlMOXZVdy92?=
 =?utf-8?B?eVVPZGVQUFgweVlpRHVnaktmRSsxNVZHY04zcVNHc1UrQnV6NENBOTBnLzh5?=
 =?utf-8?B?ZWxxd25RK2NSRWxVVGxXWFdEQXFmcCs5VHIzSHluU3VVWkdmalluWkliVURK?=
 =?utf-8?B?cEc3amg5YnZ4NGdZb3lOTmhkYmh3ejYzSDBFZndNK1pBM29UdFNDdEp5Ylls?=
 =?utf-8?B?VUF5VHNBTE9GRHVjY1pQZHdlTnFjS0YwbVgvVmNEYy9rR3Q4V0xKa3B4MVNX?=
 =?utf-8?B?RWpPUUVHRlhCNHdNS2UwczhTTnR4eGh3QVZReXNPbmNONTZnb1R1aStva1ln?=
 =?utf-8?B?K1U5eDk4NS9ac2xOSm4xVjhKaEYyUnVld3RCMjczSStacTFpSE4vL2paOXpV?=
 =?utf-8?B?NFByVjZmdWhtMUJYN21JcUlTSHV5UVpWT1BIY3VqK043VklPeEI0ckVJZ0F2?=
 =?utf-8?B?b3RTU3E0TDJJMmNGWCtVelNmQkNKZi9scEp5YzNXc0o0ZUZpT1piSlZFUmtX?=
 =?utf-8?B?TW5uZnY1WHZHWnhESUdxLzByU1o0Uy8vcTdUYkFtVDZGSEVWV0gxTkZhZmhY?=
 =?utf-8?B?RnZuWGR5TVV5ME1GYkdYQkk2NGtzQVg2VE1GanRxYXZPOWdSNmI1YlJnZU0z?=
 =?utf-8?B?WXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c826e7-d710-4139-13ca-08dac8b1cd1d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 15:38:40.4535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5mEmgxAMEnxxq9iI6cmcuqsAy4N9aXMC6cbAaAJVSCcygmuRVB17zp/iWpXsOzkNZ7VvA5wal2cTGFp7C1P6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8850
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 17:37, Tim Harvey wrote:
> On Mon, Nov 14, 2022 at 11:33 AM Tim Harvey <tharvey@gateworks.com> wrote:
>>
>> On Fri, Nov 11, 2022 at 2:38 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> >
>> > On 11/11/22 17:14, Tim Harvey wrote:
>> > > On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> > >>
>> > >> On 11/11/22 16:20, Tim Harvey wrote:
>> > >> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> > >> >>
>> > >> >> On 11/11/22 15:57, Sean Anderson wrote:
>> > >> >> > Hi Tim,
>> > >> >> >
>> > >> >> > On 11/11/22 15:44, Tim Harvey wrote:
>> > >> >> >> Greetings,
>> > >> >> >>
>> > >> >> >> I've noticed some recent commits that appear to add rate adaptation support:
>> > >> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
>> > >> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
>> > >> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
>> > >> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
>> > >> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
>> > >> >> >>
>> > >> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
>> > >> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
>> > >> >> >>
>> > >> >> >> Should I expect this to work now at those lower rates
>> > >> >> >
>> > >> >> > Yes.
>> > >> >
>> > >> > Sean,
>> > >> >
>> > >> > Good to hear - thank you for your work on this feature!
>> > >> >
>> > >> >> >
>> > >> >> >> and if so what kind of debug information or testing can I provide?
>> > >> >> >
>> > >> >> > Please send
>> > >> >> >
>> > >> >> > - Your test procedure (how do you select 1G?)
>> > >> >> > - Device tree node for the interface
>> > >> >> > - Output of ethtool (on both ends if possible).
>> > >> >> > - Kernel logs with debug enabled for drivers/phylink.c
>> > >> >>
>> > >> >> Sorry, this should be drivers/net/phy/phylink.c
>> > >> >>
>> > >> >> >
>> > >> >> > That should be enough to get us started.
>> > >> >> >
>> > >> >> > --Sean
>> > >> >>
>> > >> >
>> > >> > I'm currently testing by bringing up the network interface while
>> > >> > connected to a 10gbe switch, verifying link and traffic, then forcing
>> > >> > the switch port to 1000mbps.
>> > >> >
>> > >> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
>> > >> >
>> > >> > #include "cn9130.dtsi" /* include SoC device tree */
>> > >> >
>> > >> > &cp0_xmdio {
>> > >> >         pinctrl-names = "default";
>> > >> >         pinctrl-0 = <&cp0_xsmi_pins>;
>> > >> >         status = "okay";
>> > >> >
>> > >> >         phy1: ethernet-phy@8 {
>> > >> >                 compatible = "ethernet-phy-ieee802.3-c45";
>> > >> >                 reg = <8>;
>> > >> >         };
>> > >> > };
>> > >> >
>> > >> > &cp0_ethernet {
>> > >> >         status = "okay";
>> > >> > };
>> > >> >
>> > >> > /* 10GbE XFI AQR113C */
>> > >> > &cp0_eth0 {
>> > >> >         status = "okay";
>> > >> >         phy = <&phy1>;
>> > >> >         phy-mode = "10gbase-r";
>> > >> >         phys = <&cp0_comphy4 0>;
>> > >> > };
>> > >> >
>> > >> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
>> > >> > some additional debug in mvpp2.c and aquantia_main.c:
>> > >> > # ifconfig eth0 192.168.1.22
>> > >> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
>> > >> > speed=-1 26:10gbase-r
>> > >> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
>> > >> > [    8.898165] aqr107_resume
>> > >> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
>> > >> > duplex=255 speed=-1 26:10gbase-r 0:
>> > >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
>> > >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
>> > >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
>> > >> > supported 00000000,00018000,000e706f advertising
>> > >> > 00000000,00018000,000e706f
>> > >> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
>> > >> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
>> > >> > phy/10gbase-r link mode
>> > >> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
>> > >> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
>> > >> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
>> > >> > pause=00 link=0 an=0
>> > >> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
>> > >> > [    8.976267] aqr107_resume
>> > >> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
>> > >> > 10gbase-r/10Gbps/Full/none/off
>> > >> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
>> > >> > duplex=1 speed=10000 26:10gbase-r
>> > >> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
>> > >> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
>> > >> > - flow control off
>> > >> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> > >> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
>> > >> > 10gbase-r/10Gbps/Full/none/off
>> > >> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
>> > >> > duplex=1 speed=10000 26:10gbase-r
>> > >> >
>> > >> > # ethtool eth0
>> > >> > Settings for eth0:
>> > >> >         Supported ports: [ ]
>> > >> >         Supported link modes:   10baseT/Half 10baseT/Full
>> > >> >                                 100baseT/Half 100baseT/Full
>> > >>
>> > >> 10/100 half duplex aren't achievable with rate matching (and we avoid
>> > >> turning them on), so they must be coming from somewhere else. I wonder
>> > >> if this is because PHY_INTERFACE_MODE_SGMII is set in
>> > >> supported_interfaces.
>> > >>
>> > >> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
>> > >> should support it. I'm not sure if the aquantia driver is set up for it.
>> > >
>> > > This appears to trigger an issue from mvpp2:
>> > > mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
>> > > 00000000,00018000,000e706f and advertisement
>> > > 00000000,00018000,000e706f failed: -EINVAL
>> >
>> > Ah, I forgot this was a separate phy mode. Disregard this.
>> >
>> > >>
>> > >> >                                 1000baseT/Full
>> > >> >                                 10000baseT/Full
>> > >> >                                 1000baseKX/Full
>> > >> >                                 10000baseKX4/Full
>> > >> >                                 10000baseKR/Full
>> > >> >                                 2500baseT/Full
>> > >> >                                 5000baseT/Full
>> > >> >         Supported pause frame use: Symmetric Receive-only
>> > >> >         Supports auto-negotiation: Yes
>> > >> >         Supported FEC modes: Not reported
>> > >> >         Advertised link modes:  10baseT/Half 10baseT/Full
>> > >> >                                 100baseT/Half 100baseT/Full
>> > >> >                                 1000baseT/Full
>> > >> >                                 10000baseT/Full
>> > >> >                                 1000baseKX/Full
>> > >> >                                 10000baseKX4/Full
>> > >> >                                 10000baseKR/Full
>> > >> >                                 2500baseT/Full
>> > >> >                                 5000baseT/Full
>> > >> >         Advertised pause frame use: Symmetric Receive-only
>> > >> >         Advertised auto-negotiation: Yes
>> > >> >         Advertised FEC modes: Not reported
>> > >> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
>> > >> >                                              1000baseT/Half 1000baseT/Full
>> > >> >                                              10000baseT/Full
>> > >> >                                              2500baseT/Full
>> > >> >                                              5000baseT/Full
>> > >> >         Link partner advertised pause frame use: No
>> > >> >         Link partner advertised auto-negotiation: Yes
>> > >> >         Link partner advertised FEC modes: Not reported
>> > >> >         Speed: 10000Mb/s
>> > >> >         Duplex: Full
>> > >> >         Port: Twisted Pair
>> > >> >         PHYAD: 8
>> > >> >         Transceiver: external
>> > >> >         Auto-negotiation: on
>> > >> >         MDI-X: Unknown
>> > >> >         Link detected: yes
>> > >> > # ping 192.168.1.146 -c5
>> > >> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
>> > >> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
>> > >> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
>> > >> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
>> > >> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
>> > >> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
>> > >> >
>> > >> > --- 192.168.1.146 ping statistics ---
>> > >> > 5 packets transmitted, 5 packets received, 0% packet loss
>> > >> > round-trip min/avg/max = 0.267/0.416/0.991 ms
>> > >> > # # force switch port to 1G
>> > >> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
>> > >> > 10gbase-r/Unknown/Unknown/none/off
>> > >> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
>> > >> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
>> > >> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
>> > >> > duplex=255 speed=-1 26:10gbase-r
>> > >> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
>> > >>
>> > >> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
>> > >> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
>> > >> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
>> > >> and the vendor provisioning registers (dev 4, reg 0xc440 through
>> > >> 0xc449).
>> > >
>> > > yes, this is what I've been looking at as well. When forced to 1000m
>> > > the register shows a phy type of 11 which according to the aqr113
>> > > datasheet is XFI 5G:
>> > > aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
>> > > link=1 duplex=1 speed=1000 interface=0
>> >
>> > That's pretty strange. Seems like it's rate adapting from 5g instead of
>> > 10g. Is SERDES Mode in the Global System Configuration For 1G register
>> > set to XFI?
>>
>> 1E.31C=0x0106:
>>   Rate Adaptation Method: 2=Pause Rate Adaptation
>>   SERDES Mode: 6=XFI/2 (XFI 5G)
>>
> 
> The SERDES mode here is not valid and it seems to always be set to
> XFI/2 unless I init/use the AQR113 in U-Boot. If I manually set SERDES
> Mode to 0 (XFI) in the driver I find that all rates
> 10g,5g,2.5g,1g,100m work fine both in Linux 6.0 and in Linux 6.1-rc5.
> I'm still trying to understand why I would need to set SERDES Mode
> manually (vs the XFI mode specific firmware setting this) but I am
> unclear what the rate adaptation in 6.1 provides in this case. Is it
> that perhaps the AQR113 is handling rate adaptation internally and
> that's why the non 10gbe rates are working on 6.0?

The changes in 6.1 are

- We now always enable pause frame reception when doing rate adaptation.
  This is necessary for rate adaptation to work, but wasn't done
  automatically before.
- We advertise lower speed modes which are enabled with rate adaptation,
  even if we would not otherwise be able to support them.

I'm not sure why you'd have XFI/2 selected in 6.1 if it isn't selected
in 6.0.

--Sean
