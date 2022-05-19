Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771CC52D607
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiESO3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiESO2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:28:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2095.outbound.protection.outlook.com [40.107.220.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EAEBDA1E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S18qj60AtKqgZ/a8O1n1Iq1MqG88cIIpYDrPpjqGB4w+Kt/zHoULTOor7+eckGzkMd+0U+1RcCAVs83wrihz4uLyTzznK4hR8CFItpsBFhOgaIPXTr4pV9qUOVIfFxIalm3/vlufvTlSie41YCNTQGYWUJRObybWpKeaO8NqQ5KRRTAPORddGVV/G7ptZXlKoUzgqE9Vp57H9PCxs5mYfqfDa+bAr3SGqKKnVnZNIDBUkPob2+etE3Lk6AHRYxVCnhkkV3+tSbspnMVdRZ5/LxMIxO7is+QtBnPxLsORt5QeqGoN8RRdoMZ4uGQK+qO4qEJSe/kfbKrPTGpRNL1rNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1LeNEN4B3dpWVZcp8788Kd7KFP7fZ3rxmDPgqwb/Gc=;
 b=Doqpc7T0nSsxormucXRhtID6CxM46re+bRTp5HZmjpL64E6WIi1IGobdqHoe8RhWRDBTYHxntIHlLmD/gbApW30ley3L007EigZACFxrINE26BvTyq6QIsIJ6XP1NRMp3zBZHZakPHh6mS0V2SIPkueh/Hx76KMx/uIkZYczYuQ+N2U1ASsoohYETtMArPHDN5w5suQ8F4276ogONdQVzMarUpQDWsqMogKaCXTBqUFKNVmuGN1Jv85rDI+OUqhq4233NKF/Gm+wUt/N616LESg+hR4hmnH2h75kST0kOZEM5rT4A3VQhWgEvpyNfB2GP8gduNx+zNlnkuJsgBqw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1LeNEN4B3dpWVZcp8788Kd7KFP7fZ3rxmDPgqwb/Gc=;
 b=xR8Ah41jrcyL7pmcPX/iQxpfNdanzlhGJHpqcoH3rcdJ+iU8Z9tZg/REtmlkFivYcoX8F/mil4KjDCk2N3umxA3FPa7PL4b9p3oeBYO9sCxr4UxHp2Mb51AKMuxz8WCqxEPDsyrzt1iEe2nEQgtaarYoekrjiWQTlVQ3RS3HgeY=
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by BN7PR08MB5172.namprd08.prod.outlook.com (2603:10b6:408:2d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 14:28:43 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03%9]) with mapi id 15.20.5273.017; Thu, 19 May 2022
 14:28:43 +0000
From:   "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
To:     "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Thread-Topic: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE
 KX mode
Thread-Index: AdhrjAazHSLwEJcoR7O1fBWd4mB1pQ==
Date:   Thu, 19 May 2022 14:28:42 +0000
Message-ID: <BN0PR08MB6951AF51D58150007BA7C46C83D09@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45ab9a0b-fc94-4300-b98f-08da39a3e035
x-ms-traffictypediagnostic: BN7PR08MB5172:EE_
x-microsoft-antispam-prvs: <BN7PR08MB5172F770EDBD7802BD839AAD83D09@BN7PR08MB5172.namprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MmXkLMslUuw202LQkrxEXPM9loF873J3ptg7bwSCQoPBDm/p9tF94YgNX7ESl9Q0f5UbijR8GsFTH9VwRPoyoh7wzKuBI86hgl64EZuTA2AJVP42VfA8UMn7a5e94KyF1ihV7NHaBfGe0WjAllTCuLYO9I80Q9Xhmoi46jB4QMZnmuVEN1t/cgCGPhxL48XYKEQuh5Ru8Rmw1545BiUq+6jCCQKOZ6buCSnMBJvC8EbpxjSLdpwrOc7zrQ41UmyNEq8cDRBUy/fdrs2r0A55/jjF18Xh/Gu0nuHHZGVOJzDCf2rYknYFABcoI3I9mJ6io4XeZiQFMW+17MxHsPHe4lWHJusKXJNNdmMIx02xerJU39LI5NMFwxyBgz1XJSot5KE7me7cpE03Yf2iUo9BOcZowRDdwXS2Cc8g6karWbDi9fK3GlKCiy+3yRgnPBltqIxZhq32BYT5eeHFbuIeZsBoyBY6H5F9s5T8NkjFG7iuu7bQeTqOD4TpzygAURR/4Syv4s+R2L9DLeZ223RH6bKU+l/JIlBgUxfefwNfVmmA/nnw7WreWCN7lekt//5O0UA3ZmQnS8L8t4bQKTr8prwLwWHr2IKCCd0XuGBxsBle8dOH0lgGSd2dPt4NSZ3Yf/H6/vH+qVf0FJoVRGXAzzWpY0IuuFW9n4WcjnKrDxs0hzvhhzwNISBXdFUznVSaBzL7Ma62Qi5dVTG/wCXHWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6200100001)(66946007)(66556008)(5660300002)(4744005)(64756008)(66476007)(66446008)(8676002)(6862004)(4326008)(71200400001)(55016003)(6506007)(2906002)(76116006)(8936002)(186003)(86362001)(38100700002)(26005)(508600001)(38070700005)(52536014)(316002)(54906003)(122000001)(82960400001)(9686003)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n9gZ/07AFhnb5LtmRXUXeBMJpwvjf8Rf7UBV8dNNrzrLVpV7M1u/Q94ZMuMi?=
 =?us-ascii?Q?J3wLNP1gU1AJCqJlyyAr4kxvLM1Y+JYGVRqVsG6KzDzrs/6ePAlGwV2dzqmi?=
 =?us-ascii?Q?ol3M4dllotFKk99USv8AZkNAf3MK6yAA/B9uvnxwxQE4+pvOAHp2QJyaWfpb?=
 =?us-ascii?Q?OtZvOn3rojmUiDvrDnuq10ehJJ6t3HB9g6NHVd6I4QVTey8D/I20Fx3wP1bM?=
 =?us-ascii?Q?wgzxxqJl9ZBmSoVfEZRDHHTsr5eN+OL57CExiYLKyiMICfhusNLSHCO4rAEr?=
 =?us-ascii?Q?K2fz5bDF1h4xAP9lK1KbHwmm3W3JgIWTX+/QhHYILSTlU0Qroiay/KzAUux1?=
 =?us-ascii?Q?jOeXfalfkoZGGYcK+ieyLjWq0JFV4iN+TbP5mRhjDcW7IBxYQLdtl2cR6AoA?=
 =?us-ascii?Q?ad6exNURXrca5+pvCn/0g4dBKt0fgryz5x1G37OT8aawwjwDWz63hebGp3zM?=
 =?us-ascii?Q?TwVL4WVYxhJ2nGZjBifpFVSAU8EpudzTdw0maN0B3Vs7TPZmhzTic7Z3UyAL?=
 =?us-ascii?Q?7xteYoBb8ec2H1L0TXGCxGJKQXGtADxn0OlOokAo/VUvQ+nXGzX+pejwL8mY?=
 =?us-ascii?Q?k6PghWq9gTB2tKxhkWJY1/kTNxndFNR6FTslgDm75cHT+9xyNHklSmQ9LtVX?=
 =?us-ascii?Q?bjKJNFsJ+liuG80yNsxW/wkGlMEzQ5qZdkj1ARUiOWrTUUpH/EhJ2Fxpu4yn?=
 =?us-ascii?Q?JkcjwACVqCFRPU08K/R6o0WQyoGBfH+rInLaqSMRXaSkdoAs/JzhUFz7DcW+?=
 =?us-ascii?Q?YKtuf8DRqYLW8o5wPkfwJW9VZsqEkmxGr2Ngw5qZgLBzxdcO3J8WYjenm8F/?=
 =?us-ascii?Q?CZ/gFDf9H9eeegSYDM61xhhCsezxXKSGS/HveAM7yLyDJIGIU/2PYEUwgC/C?=
 =?us-ascii?Q?BK0eAiRhjrYSoaD4PBM2rU7YjvGVWXBa8PSikvJCzB4onc2PL6tAIgQmOUHK?=
 =?us-ascii?Q?UeLsNTH/F3CwogvpYQehIbMpimpVixf10c3rcMsH00SCfwV9I+7x6XEV5TP8?=
 =?us-ascii?Q?Zsrg3Wd4EsQwdPS7urodw2h4//AlWTKKDAUKhR0WKKo1Tp9DkBRL0F0muDNH?=
 =?us-ascii?Q?qzkjswezRjWakbeMZHbuyPalAyNKIo6XCODFvnfukWt0bb8TIKohMgstPuug?=
 =?us-ascii?Q?qHPCjCLPDiAiiy3rjNlGENpNTUpZ/Ka9jgTr++u5JXL65WlbvcskYrDUtekx?=
 =?us-ascii?Q?iwMA42X9IHd6Fqs7enHYfviEq5ROIRdqIsFfD+NwDyUfiQ78nwmMSvRWoDwd?=
 =?us-ascii?Q?jTdQkxQrRwhslsIq2uG6WJSOWgHTEcRIgU3ZS4DuhqTGU5NaeTN56KkJK+X5?=
 =?us-ascii?Q?wyzEA1CJ4m4kkzBDw+7aMmvAAFbQkWjRtjuDS+jXCqUrPpX4iglBpmdlPmKc?=
 =?us-ascii?Q?j5yv/9kPzhb1Kjq/1lX2GXgYmRyRZHep1BzFNNcKHPuNo2kDZpu6SfsJiq7n?=
 =?us-ascii?Q?4abCarDNlrckM9EpNSIBCLYxoN77NiajdQ2oj9j4wG+8G4f0PST6Rchu0w3R?=
 =?us-ascii?Q?5GR47qH94UZgXYcn67pHoXybCIwfbJzdDb3wbPiJHOyRBoHaNVhT1tP4ahvf?=
 =?us-ascii?Q?i/wUpwghpq8kqG+3zO8PvKL7QBe4C7SsnINy3JM8BMtsDVPnkcSPOHnsvEJc?=
 =?us-ascii?Q?FaIJ2e9t7ft1c52pn/EK0k0p3M0q7LahDTcEjDpwhOa642UesatfNflAhVKa?=
 =?us-ascii?Q?xRMHsoisPvJhsnnD4H1t0fUTNSZACFOoA5gPaqu/7GeNDzWJGUKoD0o8QyZy?=
 =?us-ascii?Q?9ixZwpehssGOzj5Meb7fCLMf3wXl5kU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ab9a0b-fc94-4300-b98f-08da39a3e035
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:28:42.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dXog0+mDSO2HurQmnV1nJ1b7tubmL5+mxnP4J4X6KWLxpR6j4jwokitNSm4VS7Y19b+vPhBOvCYeir0vsazCinNF/ijoKHKQjcO3uTQcubo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5172
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Additional information:

I performed an asymmetric test. One side has 'ethtool -s bp3 advertise 0x20=
000' and the other side of the link has 'ethtool -s bp3 advertise 0xa0000' =
(ie. one side is advertising 1G only, the other is advertising 1G+10G). If =
I bring up the 1G-only side first, followed by the 1G+10G side, then the li=
nk properly comes up at 1G. However, if I do the reverse, and bring up the =
1G+10G side first, followed by the 1G-only side, there is no link up. I nee=
d to bounce the 1G+10G side again (ip set link bp3 down/up) to get the link=
 to come up.

