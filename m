Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC25519791
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345042AbiEDGtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiEDGtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:49:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A677C1DA74
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ph47NrsxdHXowlLdgbW1OYoxRIIh9YHX066nb7+AiTyJ3qjhB9zGFnz35Q0A8U3y0x2q2qV97l1wUQw6Ux7REXrWfpKYRuXhZ0Tnz0mYSIFWDIykuuOfpNszR3i3cg4rY2uMHPpyEKVwhc0iC+GMoX0pfxEYn/kGWbZ7cIbgjLjgQK4dHKVzilqNd/oWlG1zTore2Ot+l0cx0KAHfximcalRE409vHJeS2dTYfRWq6iKwibMoNBKn0RZNKDv7CMycOc95Mi+6WlHCDP9jvBP5mzQpMLD3Rg7b21ByaKRAZ2SWqiVcHnUBdZ01qvoSRAUC3ZorWSQNV7BJ1P/R8sigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8q3lI5avSla4w7do97k2j5T2Lz37BMUnr9OrIO8YqI=;
 b=Ot9kvaQ7T96K0dXMSFoG8x9YN9vhrWylETtep5maMD9SigNGs9aU2cpBGtBcdaiKchXB2N/FqLtPv9jHpZngqAOgFg65lUffuoaUXD92svwwxNq2d1rMwDPucare1Hq0RZ0I0erkVxWTBuYEGy8NQnp9C2mJ60eSQhdX8l/c6uXkTAThzCoVCvDk8bMbfUZBFX5P7iKvi1J9q3NqrZo6GqZP2geRo4ObzmWOYeD7JJhfA26QkH7M7tHKitaF7gGQLjf6iPGfwK7Ag7V2DR2P86trqKZKOCqYDPMQ20Ide/usMCRgy2kXaH13Gyngu0aByvsv1RGUcMjAGQe5OBMyLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8q3lI5avSla4w7do97k2j5T2Lz37BMUnr9OrIO8YqI=;
 b=kclGVZ3ejuYmeUYZtLafXD8AoAh91Edqj/6tCnYb+3lPGTsWn2/6GlFOkA/jfxmnzbkQQn9NtCKW5jcWXeP1yfAEjQkUWG++k4uEn0Yd42euPdNYiGkSfTeeyWa4MKWKfQmMzknw8jvmf1HKdgz9fErsoomiDaf9z2Fk3zIafDs=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 BN0PR20MB3912.namprd20.prod.outlook.com (2603:10b6:408:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 06:46:05 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493%5]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:46:05 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYX4JgQ9a90BuNG0u1i9lIsMx3tg==
Date:   Wed, 4 May 2022 06:46:05 +0000
Message-ID: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca3c9742-133b-468c-6685-08da2d99c345
x-ms-traffictypediagnostic: BN0PR20MB3912:EE_
x-microsoft-antispam-prvs: <BN0PR20MB3912E81DDC74569399009E0BAEC39@BN0PR20MB3912.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rP1UNe+kGQz1QY41B+ddc19J+2DKqlSCNcAkj512MrYMXyJG6L5xg+QpxewyguIQCo30qGS9x3+6f4HcrgDohHr09q5xwBclfbfuqiFT8Cle8a9hFpXOrafTiKRlNUtEaqK3uJABA8VMx+TKV3CiKBa4E7pccWeT0Sy1K2+rWPHfu8IuYD/PmaeeZsDFztVQ71UagxuMglimyLRkjC+t60UwxLS7QOJqDJ04QI9KKNT+B8vFPEJxdCsZzpMlpCzfqbjIK14+mbc5dKIgNNw1zkVitY071SdjWERduaMRw7bdeO5TGc59bxVku2svV23yM6pgfU9I1sXLIxsewbDS8xZ1FtALo6yCl/WTzowl5pKksZ8fJyoRyRoo4g6Ibb2q/CZAlKtl50uTIDtCw8+onao0FuRNvbh1x6LxEvehaFXWtiPlpvdPXzazzV3MZk+p4g9GPnsS6zt+gEtqzKkxrZn+PIHj6nX9ygXT9Hj5d9MCOoHQEH02Clfq2Gqd/+bbu65bktOBGBZK6QeZAhEGbo/4lEahQX30RPwRoa9MfyUOPe7tbrZgTAhZtrghoWwSNToKfyivNjWC7Rw2jHhxzv+IGoI5gD5FhXBrItMU90S8iyDadduIMkv2jQ/l3owfBK0uCneo39dW1tbpEvAbbSBSmQ2Ze+0pa27HKrMGlwvEOFe2pOvyQ1479WNziM0HCPxJ3c5OsixCE0B+AvAkUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(346002)(396003)(366004)(376002)(136003)(8936002)(4744005)(38070700005)(52536014)(38100700002)(33656002)(122000001)(8676002)(5660300002)(7696005)(55016003)(186003)(71200400001)(6506007)(9686003)(508600001)(64756008)(66556008)(66476007)(76116006)(66446008)(66946007)(91956017)(316002)(26005)(86362001)(2906002)(15650500001)(6916009)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rXjsc9Wqb1tmq+NUrsznQRpPqiHxH8ceuKaRtcdEY4ut6ul2x63XQr+bnf?=
 =?iso-8859-1?Q?imI+A5UF3mCDDdqr6GEhsTcVZxhh5a1F/bA8zoJaVm4KPfKahGTszUGlIp?=
 =?iso-8859-1?Q?mNJbn3IpuBdTw1dH1HOxnHlieOUeDHxm9+rpnrYotkA/XhHMD13CkwY5qv?=
 =?iso-8859-1?Q?vqZEsGSumTg73pehzeOUcLQAEd89A2elGy7K2sEKhiiBrJdy+kcefm9T6H?=
 =?iso-8859-1?Q?Qh3nuvxZ1Qry+xvUmdkOgtuebUk73fMnfFpvjtXApfvL6mmgQHlwX37Pd1?=
 =?iso-8859-1?Q?stUzMsi1fofvBgQ3zXGfd7Tj1NP/a0T+940IOuDxZD328t0w7QcFVGnsdz?=
 =?iso-8859-1?Q?RsrONdM7bqAdQPYramSNPPybkR25hXIiTOGJnbc4X5wxFRpLL0sya/lg6Z?=
 =?iso-8859-1?Q?gvrVWGAwizP3Iz448XHTpmuY05iNjVjBaKqwwzBFQo43Fs+9BWLC/kNOad?=
 =?iso-8859-1?Q?HD5GpnU7RtXmTPeMN4yA2MHSdda77KgRNu+9O387bsh7iu2Cl1iKMQKayS?=
 =?iso-8859-1?Q?3dy5wAN5pQvhzlB7YctGSYllnF39XMsjo8AWduUh7BMDOlqGPtXe0QmnPb?=
 =?iso-8859-1?Q?u8DQAJSG/iy4fhfK4P0iCb3w8BlDyG1tuXyKvgr3Vi6tJ0qIx6fN/kuHzP?=
 =?iso-8859-1?Q?xlZO/0vrNfcoICktsYW35mogQ+aC+gvBEz3A26nBb8mzdWlZvzi4YdIgpn?=
 =?iso-8859-1?Q?j5F6ILq0hVsg1iDF6NkaKJ+3t6Qu6eIWn+RrBKi6LpSOtcVhemEa6IIZ5g?=
 =?iso-8859-1?Q?f982RgA71HEg8B2BsG5+7Yf/Sts2jmGB5MwB+I5aw87hbILv449+7Cbysg?=
 =?iso-8859-1?Q?WLRdCISlfAK2g2/mQgDlQ287NICLDusGEq4H3dA9C2Tx2ucEaGvYhxGC6U?=
 =?iso-8859-1?Q?ZYxHKxWscvQZSW3WzYFlfnjQ5W+5fWwV9cKtbkTfs8kmaUSDojCD5YxKqo?=
 =?iso-8859-1?Q?5pm0doP3SzchmZEVNHRCr2WLLgJrWVn896V+YL6m5RI1W2AC8Ufh/6KXHS?=
 =?iso-8859-1?Q?GzkS66jsXeX3jfsvNNsrGivbHjOdWju3L+0xzwpfOLNclwodQhXGAIl2Rx?=
 =?iso-8859-1?Q?JIHJUwCc2ymz6sekNTcPfB4nAral+ae3qFTYLyiJqD4Bsu5K8t+avpKaCk?=
 =?iso-8859-1?Q?ITYokWtVVW162O/cbxQMOA9ssUry5ltDZZuUFQddqV8AcifrGdmjVw0Wu0?=
 =?iso-8859-1?Q?Tf482sM3AG4HJcMDTJQy0NVZwAkZsItVd4jQMZfT6HuBtDsCEkR0Gn9ujn?=
 =?iso-8859-1?Q?BZVUglS8J5+Q0rj/7/Rvp2hVRQ+Ssj+JlEWGUGNP2ijAareJRyfwxV5HuG?=
 =?iso-8859-1?Q?q5CQfIBYEpDUP/Zv8t2z3d0BMb0Mw3kE35hQonV55xkPX+kociJv4azek1?=
 =?iso-8859-1?Q?nx02wY1xh0snMGKRAhqaiVK9ZwhStsxXlpORght+wA28f5YT13rIVykAWj?=
 =?iso-8859-1?Q?LaTn3CaIEczKeWhCiHG5Zy5RWdYeCZpBliHI0Ugd9bXCKq/rwcfvvWjZas?=
 =?iso-8859-1?Q?x4P4m0Ayp/pM78ILELUUsJOxImoegA1vIQyPGJhnnvO5HzpNH7GL+wJNsz?=
 =?iso-8859-1?Q?DNp8M1GTYCpXxhHUbvsUZD0dUTzR7x7hy181hoB/FlF9fN90lQVwnKcYE5?=
 =?iso-8859-1?Q?j1p1BpaUriLHGVbRnim7Ttlpk7iuOaVDO31UUUX/Abw1naxYN48/v5bR5D?=
 =?iso-8859-1?Q?nH155mR2rP/Gh23E4iQP8tW1kCKBjf9O1YlXH8ggpEmN1N4GZOQjcpFEQ1?=
 =?iso-8859-1?Q?EzYpPjsq7N4tQefFQky74dVVZRqQgrTIyNJY/Nmwi/8Kwokm8UZmpmrCCt?=
 =?iso-8859-1?Q?GEQ4/yuONA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3c9742-133b-468c-6685-08da2d99c345
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 06:46:05.5385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/PHvAiJ4l0lq+jOKR9P9uJtdEkXDK2i9G7wBPap06QgwBjWAyHKg4s5wFgBJ5wQeVNzVpA0WoSYYY6Ba8FQorqJANAj5WPMlboJ+LVFPj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR20MB3912
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi=0A=
=0A=
I am trying to configure dual gateways with ip route command.=0A=
=0A=
Ip route show command shows the dual gateway information.=0A=
=0A=
I got a vpp stack that is running. The communication of route entries betwe=
en Linux kernel and vpp stack is through netlink messages.=0A=
=0A=
On parsing the netlink message for the route entry with dual gateways, we s=
ee that the message carries only single gateway. Is this a known bug ? Plea=
se suggest a solution to resolve this.=0A=
=0A=
Regards=0A=
Magesh=0A=
=0A=
