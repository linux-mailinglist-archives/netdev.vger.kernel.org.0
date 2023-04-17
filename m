Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAF96E4845
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjDQMwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQMwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:52:01 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2107.outbound.protection.outlook.com [40.107.100.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45C691;
        Mon, 17 Apr 2023 05:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uen5gc5QQ9Qem39nXW/++4de/lJVDjFuDO5tKoAkdahyMpD7qEcfuG4KByTqdXIBPMLg+2ZPAedDzb9nPeR6ATGIscdPW+NJ+rWv7P7jpkEapvGmgPxj4nfp5S7HI1Zy9jAS+oOsly7ph8479Tqn4xfBcGDXzc/0RFN3T6pXZyxwB7DYGx9ioQRg3SNMtxTO+QzGWTUqr0uZiHUEjD98ebdvfyQbzBH0tZHa4tdr9MTF4kbgTNel31i8uaV2FNdL79jd/hJAfIH++L68U0MJWSUqoGmBkwFh26QQGfbt55CmkYYejf5+VqmMkGLG8Yd+gYkBfqmLLq4AKzkZDKTp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9dWBWKrh3JJHpO/Zf/amaC3aTZTo7s8D2k+onwnY1g=;
 b=ZAGNzvr6dP0klu8eMlEczchkOrDaK8mCYf5Ds0I7kFCxqAQVs/Vm1/V2pmCkvkluc7ytJG3pihsmJvrgToI50GdFaoMCz6D/r5FyHxKm1bt3rFzqYJ86KToe1NvbyRMoIVua7bRK6HS5OF4+aHiU1VUk1BBTnT0ZX3zMU1Fx2LiuS3QzUHvncS7t5RV/s8Jx6Cy+Be0lzQ1nZObukEyZaoTrcOSobpPnRbd3cyFuTvhpE4oBZ5Ke2U4+7kSa3rtSsXbZpr5i/TUvGo1iz/9+vO1IADU2yehr8qQ2iRjEhfMuA5aSdkoGhjX3T3Pu/4w1DUCAjNqJHqGTWMFiypxPoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9dWBWKrh3JJHpO/Zf/amaC3aTZTo7s8D2k+onwnY1g=;
 b=lcjuLxN2HtsruW+EUidM7rNg+YQ9IYeQPbnL/HXpQH7z1XZEAcS0fi0QQkPpFK+5vXZV8d3Jz4PSrdYxk+m4LMm/Qd8F1u5yGk0Q3CvnmV0t7QljusptRxXpEJ4NfIshz4bzEGP5/qcGaF/3TIP48pgPNUvN9qCEivPNxU4JTOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5757.namprd13.prod.outlook.com (2603:10b6:806:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:51:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:51:57 +0000
Date:   Mon, 17 Apr 2023 14:51:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: mscc: ocelot: export a single
 ocelot_mm_irq()
Message-ID: <ZD1A5lz63dNEUj7D@corigine.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415170551.3939607-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR05CA0124.eurprd05.prod.outlook.com
 (2603:10a6:207:2::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e51a57-c812-40e6-5b2f-08db3f428708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQMAI9OF7DlrdKv2JaZeEBTO2zqhzutHXZT6wVT7szaYs5m5P8k9J2RXesmCqSK+vc36tg30m4b+ZWwqhQ0ZkP9GbzQPBDEGOF0XP7+uctjDLu2ux317s3bBTiblW4RENcnxEYrghTIAN1nVq7GFJpHgfuNAn+OdAEmhLDeKWR6ktr0EJKcV9RpvRWxDZRN2ZleWJiQfkTigUGbbJ6mT8Z1p8wOcmeDtZCIsnKSms0aWFwXcnIGbgkzW22wEe1Xe7hMpsV40I7D1AfaQlFaAPXxJ9a7jyr9l3aKja0+fLUTODSr8pHMC42GZ7ILd3BBLZn4s7DDdRB9MTLcK90+TJP45xe7MAq9Dl8K36PWexGO+7fK1brsbWIpOtLAfXU3Qa1OM03hiJxxPWMPcVYLYgTq3yI5MR+XsNu61Rw8XFHSoq2sgbR0etqwEZONkx8biR77paUsrMMF1Fz5k9il9oJHezwZzGMJxBA9ecK2Js3bII3kRgK3jEn9INeLU9xgus249l9/dRMPcqe7OmNbXx/iiJgaikDMb+4G9fOEOU5dcnlvureagYSlUaLY8hvzk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(39840400004)(376002)(396003)(451199021)(6506007)(6512007)(186003)(6486002)(6666004)(2906002)(4744005)(41300700001)(44832011)(5660300002)(6916009)(4326008)(66476007)(66556008)(7416002)(66946007)(316002)(8676002)(8936002)(2616005)(54906003)(478600001)(38100700002)(86362001)(83380400001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wg7IPPOebr2irYSH3JzSv3dB+HqQESUmjk2v2AUFLzp9Z5HYe53ypnOmPv1j?=
 =?us-ascii?Q?hm/dNuBiPX6eqm9Tqu489Aeu9JoAP9BXOE6Shs3xMVyi6CGJ7T79wXPjg55w?=
 =?us-ascii?Q?191KWo+LQlc/VcuadR4UGx0QKNbAhf4OS6t3CEr6yUCCRm3sMJucW20CdgO8?=
 =?us-ascii?Q?8HtpBKA0Q1FoRzccJ0BmUypUqMekbnLTOpFNRsxf2Bi9ns7Qm+SHmmUYBRU8?=
 =?us-ascii?Q?hjpzMWSqZ9p5b9nhIfk2R0TjtVN4zv2ppB1YVQtUYMVLR5QGFUyOSdgV4Jrc?=
 =?us-ascii?Q?77aVo7NCU6zRVMvEweSAyWaAmwHWp2sqr7fgHLxZjqNCrYdibqfILN1Dg8iq?=
 =?us-ascii?Q?U36ACdE0M4BScibaK9ee92oA5yqui8tgfZJNCbohbmBjJDfne0fgHFQyJpPa?=
 =?us-ascii?Q?9gZJlB1BmxLYupRaLah4gyEcRmMk4l4xs1wmUzYAgL6p2Cm7Cepw3TPwwVUE?=
 =?us-ascii?Q?q3Bl7ABywGjdD3W0fbxiSxD96tdHNoO9E/RDJpHpqHG24PhI5jlU+sVSkIE8?=
 =?us-ascii?Q?mcLan7ZTgvyH9LE1AnJVke6/hT9PClWJ81oRx/Z8NTS6F/AzU36t2w12/ywI?=
 =?us-ascii?Q?jftDLNZfAfYkhik7Ve+z1mVUrS3MzuUgdt0UnowY7KpPGno6iljOcq2Xry6Z?=
 =?us-ascii?Q?DRqTreGqKBwIK9gndvIGDo05tgcP4b1zaewXDiCDRhpP2puanEjKqSqSUcpc?=
 =?us-ascii?Q?FvEsuecHgyh3M0pVWjBvq2iRFl/Va6pAnQSWlyLVtphU5721f27ef4CbtLLT?=
 =?us-ascii?Q?VUDygoiPvVVvQYlBQhZ0KYgnGGrX+ayBFXTUBlpmYcLK2mUDZw0d3M3JP/tr?=
 =?us-ascii?Q?ZzD+wKvpizggvAYklOjzOgUfIVsbDtGqdp49PqPl4Lk2YPZ+bqx5IniLZw12?=
 =?us-ascii?Q?Qr9imdFnAbO7sDF9dWbax5htGkjcbbSXbKBF5bfwx9YPvaSs8FMrBTqYF1J1?=
 =?us-ascii?Q?+DLzUACwJ1G+oU0dtU+C5dctV3qf3HJj/L3BPaFrO0bpEKH4PCm2ZNOyr1Jy?=
 =?us-ascii?Q?y3oS29dRLkVoECer5AZ9Qrf4FTv60OaH/95/wWLRXeb215bvxiqvqJdzIcK5?=
 =?us-ascii?Q?psvQLv/9e7tFdD/nu/OwLhXku7G0eRluqDy3Zvq6ghFZFu2ROKa1T7i8W00w?=
 =?us-ascii?Q?99tEYTyZCeI+VjQDe2wkJAP4xKqNn4CSC2FpHkS+fO6saCzQ07T05glQiRnA?=
 =?us-ascii?Q?j3Ysn7DCElQ9GFRbtgY/KzTqjp90qnIZ+z+zGIUqWPaMz/M08EZFiyuwGt0P?=
 =?us-ascii?Q?cXjfzHjKpF1nOOyc+AUZriPpsgZGA2Y8XsRHKMsH5aK7ajnj+Kj8WoPT2xlH?=
 =?us-ascii?Q?AkVTGKr9cCiF19HhdMNkQGZqDQnxDSTKpptm9Z0hnyXrfJ1cvA+UoSbMEwet?=
 =?us-ascii?Q?zY+j0tQypRQOCoGHTigNhoKrOpU89uMDc4h0qCH/ZNGWj2BHHNVsJsn9z1CL?=
 =?us-ascii?Q?2w3l4UcMa0G15dLmvCEdv/WPbxFxdGk5ly4Lg9Cp5Rf96XlCLHUmcyyAIAqA?=
 =?us-ascii?Q?VWLAyvYiM5BHJtSoYJE8PIlSrH6adIrCw8xVVuY5AK7T/Lv+ea1HlHECa7FL?=
 =?us-ascii?Q?30BclCfB0EGjhChFugaFObWlgvPK8cT7Q9+L1u3z3qgzomjC+KMY0rrkB+Uz?=
 =?us-ascii?Q?gGw6U2Iq5dEDOrnP+DkDgIRV3LWrlZC10Op1YRSr5X8MJroY7b8sUcm6MqRY?=
 =?us-ascii?Q?wXKmtg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e51a57-c812-40e6-5b2f-08db3f428708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:51:57.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqTW+O0vl2vgOC2QEJZeoYPJT+yPZ89VRH0lHgWmOG+UV1dcl5AabzkAKVPTpRxZD6kauQH3Sx+GucHVagO+tHodf0P/LbaAhrF6B9c759M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 08:05:45PM +0300, Vladimir Oltean wrote:
> When the switch emits an IRQ, we don't know what caused it, and we
> iterate through all ports to check the MAC Merge status.
> 
> Move that iteration inside the ocelot lib; we will change the locking in
> a future change and it would be good to encapsulate that lock completely
> within the ocelot lib.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

