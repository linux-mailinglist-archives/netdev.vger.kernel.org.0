Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D440F68A9D5
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjBDMyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDMyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:54:46 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2127.outbound.protection.outlook.com [40.107.220.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922A425967;
        Sat,  4 Feb 2023 04:54:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRow4utWl8EXY0E+F/DRRJFrMds2r4oiF/lpG8R/zrNNeg6WsrXKhIjYgqEJHkCJYd1qdJkH+dmLLsy8JobRK+3+NDeuP8dQwUR4zpqlYlyqpL1J2bKO1FzPCUdbB3K/cpVInpNxI8BApY5PuMMSVse2Pr3VxEtHxsDPcLTDlnKIPdKRyvUPXnOwns0Jh5qDDg23RCCrbPJeLlFRgxF8pf8y3ctWWOXzC/+ctF0A4EJ3F6e6r8b9N08/9dsTe2jBrfLvvx/SKSL72ItKBaqC852+iRnqVO56CM9uqiL+dL5eLxpN13giVsXfMkNd6wh6Ps1IKgGtO/H603f9isSIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cxy6HsICIsnuu6FeF7UNY7C+wPMCWqb4Zw6J9Jt+6Dk=;
 b=FUz91/Jj3gXxI3ZWgAyQMzatW2HW86jHFUFITPPWwm/g9WeHLWgtc8006Hg9OmnY1dQK738DUpvg+RP124LRgFZQ6q2IiRH6nRc2BRswKIzOayZTP9yNBtvFT12cCYLBr4N6LTcNX/uigTmHBJ46jIl8PRY659Qopt8Uo6q5MexmcHcJQx85e8MJvep9wjX5O432fBF19w1fGDSOYthvmpISvaM0Mgd0pp9gsZrPSBUTGDtcbR8JVj/ZDkvazl991/PgLtrR7rZsWwtb6g8Cf6DgMglzJeN8dLLy+bCtEf5S39Zx7ApuiGwTf7ZHxuBPKlE9WYd77/QNLME4DEAXZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cxy6HsICIsnuu6FeF7UNY7C+wPMCWqb4Zw6J9Jt+6Dk=;
 b=Yem6g+qJynANWlBBjQ0a4ZFB6aD7Mj9VzObA1BH0sC8M6z1LQEB88RfwrNNQUHFn2CH9JjxKuJyOVzNZWIBT85PTrrdLs/eiz6vkXs6C0ACKJj5zpzlaS6/NuZe6K2f10hhP1GsP25qbmOVBGaH9VW54VUayt1DVtdDx3F1HQVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4675.namprd13.prod.outlook.com (2603:10b6:208:321::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:54:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:54:33 +0000
Date:   Sat, 4 Feb 2023 13:54:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 05/10] net: microchip: sparx5: add support for
 PSFP flow-meters
Message-ID: <Y95VgO5wm6Fc8aPf@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-6-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-6-daniel.machon@microchip.com>
X-ClientProxiedBy: AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdc176f-947a-4382-a149-08db06aef636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7omhM31gn/z5JvC4pYWYA1X8wteqTJx+TZAidsguOKngNfZvyDNreGLzWpvZ5JJgF49KrtiJLJcq9cMFGRo5IhZqWE0cC8YgfKgFswfhPb92+/burfKUu53dMOv+GcBSfjcd1dE8Djjb7axXnwvyCOWsutuRKkNiFiVbxL28vh4Gk7zTUiPmf8reUSJ/YuK/gPYCY09FNjaIanE8FRFyyPC3kO+ZY5U/d9lohWA5XiVmsDbSWbUIUz901gldsMKn2HZ8uV4xe4g8pGC1pMVTXHxyZ+NEGbb3i0WltO1qSpNzasu5bjGfsBShI1jYE9I9YkhYEDYZ7cFe/Ac885MhD2cp/x4+zEXz40+oJfBE08aLUIhnK1XtiDf3VvzJv5x6c+VMKdZv19y5VQl3DapbByfz+yiRuH8vGfJJATbKs2qYuHTfJTh7H17/eiYxr680YoH9aE1iBNVxT6QxvyJXQ8Yp+iqYyEywPrrfKwrL5xAAOR3OfN7RVv5xaNOcaZi0MlodOi30acOoYcAAVIebzde4+tid/EHHb0eq/dL/1j3lZvBy8Sueuk1Dto8RDjvClOTtN1/ptGgc7klxKzkgbtGeRLxlQXSrr3xRpkQJV07QmRTrdMvQ1ykbt2BH29Gu9NmlwGczvA2jC+akJkon7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39830400003)(136003)(346002)(451199018)(316002)(8676002)(66556008)(66946007)(6916009)(4326008)(5660300002)(41300700001)(8936002)(66476007)(36756003)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(44832011)(2906002)(4744005)(7416002)(2616005)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?13sZEEcBZSUf9gZfhZwwqEC0BAklsBJLctiFp2OteygT2Hc+tcCQisaCisZI?=
 =?us-ascii?Q?WrpFgCp8rq6LsrUkp54COx2tCQ0EJSO0B0MImY7n7X4/T1FcuE81qHMRTZZM?=
 =?us-ascii?Q?a5rkcs2yu4AftAvS3cwYlhRP7YivzeeknDW+AD7j1//COua+XSQhFUB4h8/1?=
 =?us-ascii?Q?jBU+oc/ukbsryD3bd/d/LkydrLIn4RcEbL//l3iZTV6Lu6xDRScrqQ4YDFVH?=
 =?us-ascii?Q?AQKr8jycznLVI2LiPPE5vffaZJ6Fj8o7ZPUE7IciRV1lgT1FRepP6Ghd2EBd?=
 =?us-ascii?Q?aqU3EkunaViXxjJfl1Kl3aOf7/i9bgoUcJm5tjUyDmu0KY5hKRFBAgArao4T?=
 =?us-ascii?Q?9yC3NaOJeCByNiz76B3ZGJ7Ka8QsGjvWdFR+L3krX6wpSS0quC6q20BsAjAQ?=
 =?us-ascii?Q?K6432mRFSWUEisM8C9K4WKg6ROZWB8fRGu1+mOVti8EQalyF4I3BwiSKx/SA?=
 =?us-ascii?Q?FRxu/B2Zvigc5vTK/X8hF71/gvD/qdveWoeqX+7AbaihM9ZOwz5QBzrkIYR5?=
 =?us-ascii?Q?c1FLf13kSMjWwnhScbxt05C0wEv8H0Oy3tUvlpe08w5kNVpz1MBYIX8cDmHj?=
 =?us-ascii?Q?QGFBbHSMwG3KFsrNLWZnqIei9fG2frTIYQr380vXm4DOUGmZMUrg0o5L2OtD?=
 =?us-ascii?Q?hXClZHivhSK1uVXbabNbtHYYiLZ4ipEWC7cB5stjei/NaiPKEmVGnwErAm2k?=
 =?us-ascii?Q?3+mqN5QpI34C4QLec5vQqROPW1AwiiXsSvTQpPjPHN2LBDYL3YoYJbER8VdF?=
 =?us-ascii?Q?v/243DSw8WSbvKla6zQueCeptdg4NTNeOATbDDKGX5fReQ+MuTQtPM7yG5iQ?=
 =?us-ascii?Q?/V9OalOfkBv5OcmlctuI7shXgOHeoT7ijv7Ez9TEBtauXHzmETPfcJmXr420?=
 =?us-ascii?Q?X+ZifHlMpVjCAj88oLb7cNbfN0y3O3InJg7v6FGRvplGT+94YAoh9KqkRuNW?=
 =?us-ascii?Q?JxI2d/OkG8x3yGfGoC8cauFaHesk2MVHPfuzEaPHzo3ivxvHkNLzxdf7uUQg?=
 =?us-ascii?Q?3d8EFabGy23rsH4Lk0BrWq0LPHRxtB+ykU8XUk49vcHQ1gDesPy75093ruI0?=
 =?us-ascii?Q?b/govbshbFO/KEVfHlZUNCSiz8Zz+KlemNS3oFcIk8vHZD6ehbt13a35viiA?=
 =?us-ascii?Q?OLWpbYtCFPzR4e9EWGk2c7U4Vt3pwQSnxMG2ryv0SvG71Oc2GOvYRE9YBSr2?=
 =?us-ascii?Q?dtq6nXoiiMV1CY3HfyBLuy1Rs3tAolQI2aKVXnCaSTNQEwluD1t5SEKMVGev?=
 =?us-ascii?Q?/Nqr9aj1L3XQ07kCTrK57I/ASxfMLCvDRBcMxyyh/chjZxuw2TxCiNbmdhW4?=
 =?us-ascii?Q?rrlIYAt1FbulHPRtIjJJNm5kA5yTZadUbJzucI+QxwxLEPdj4Ils7GXbE7DC?=
 =?us-ascii?Q?sn3ML4fVnoQvSO027B+uASzLz8S5RkR+WZ0l6HSoRRmTVhQYOQ61wVwUWlKQ?=
 =?us-ascii?Q?IezampQVk9jTCtyDwWOXLDOt3qCCty5o0I3hWhXevB7nY/ZhvGpmZnW7XWw2?=
 =?us-ascii?Q?G4/Db14MUofZFDU/q1vOmtK1DQVZ/sbOuNLv8h20ea77pDR+1e6NpCCA7wCk?=
 =?us-ascii?Q?pcnwVojlXIO8SgEEZrQJC8foJvYe5xM2u/mTTWkl8JTtnSt0PkL6uXNMICne?=
 =?us-ascii?Q?rX4XzkuDg0NcID/u2CliaNCilxrqZrnvgahN829en7739AWy1usmEUC42C8V?=
 =?us-ascii?Q?iK0xKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdc176f-947a-4382-a149-08db06aef636
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:54:32.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMwFoPU2iBshmG66oL4ie3UxBCmnN3beXPfoAUxjaw0/PEUg9FtXOIpa/bG+k16I863xM2xCFT8DTBqFCyUttO5EgAFzR0iQ5i+LuAlT4xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:50AM +0100, Daniel Machon wrote:
> Add support for configuring PSFP flow-meters (IEEE 802.1Q-2018,
> 8.6.5.1.3).
> 
> The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
> identified by ISDX (Ingress Service Index, frame metadata), and maps
> ISDX to flow-meters. SDLB's provide the flow-meter parameters.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

