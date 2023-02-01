Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EE26865C8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjBAMOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjBAMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:14:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2418A47EFD;
        Wed,  1 Feb 2023 04:14:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6NEWnauS/P2XfWiq3hKoaXACJH1CjeFHviiYAx7SlroQrfUvA5TMF8tDby5CNAuqfcCbjFc2ucRdVDlDgk7A++NmB6LSik0zsT6h4JG5QAg3Ex34VWbP6tLAo9Ew7YmcqMAbBKyTHMkWMiP+VloVpsSP6quuKEGfJ/voKSE+f7d10ijhQ0x/QutTR2Knk8nb6AJRdoSI6owhyPXSVvVjj/qtcoY29UC9Ip00wg+oOBTLmtnZW0j27ZFf1hTv9ti3iIe1TIVWtRkEjgNG06eqIhp7S5C9IR5lv3R5Hd/2pupzknEpx3wH1C2E/auZJI6dd6zqAURsOvhsDIWNbl0DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cc9hGRqc2sW7UreJ6uJTsJdbEJKBV9rwEL90R/2Xp/o=;
 b=XTOJUbyQ1wBH3HCMoKHHQ4ESdEsglf7A62FEDDf3u5YJWIL5DbMWJ7V36ru6R+/uqY457tjlwnYTM8dFHWkiwnIEN4NMtdjQzN0EhGoANMtijxxvth+w+2ndBEG+PQJwpF9DrvGzes8ODwIzBCsD4ffsuoY3bRQ4H0+QqeYbpemBpnlk8fYz51xH7619fTrCzPeWQGYA8wbKEv8YPCJ80ej1KuauI1dZTJiRq3svoh4nAZtucmsgesm/mTrcBzYl1jzGcYdzESQmvIoLoxupQ/C/8Q/jr14Zd6S5omNoIdkhfHUgzwkcsgrArOxwqM3t4UEeXZ92KvJdpPjX3ZVydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cc9hGRqc2sW7UreJ6uJTsJdbEJKBV9rwEL90R/2Xp/o=;
 b=VmHqN2cAitIgPqlNZQK4rScMsn5yxjizUq1Gt7+rcXNH50KJLM4tsyayTljpHBydraU6gqLnPxlv7S9p3wyN8EO3uKTM3ONhniGIm6tiR/3hHWJ8M7YEZR9l6XPBhS9dp1dsNXJMDddZEYURlGIamrfLQb5Sdin4dtA2kNaNC9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 MW4PR11MB6810.namprd11.prod.outlook.com (2603:10b6:303:207::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Wed, 1 Feb 2023 12:14:24 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119%9]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 12:14:24 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Marek Vasut <marex@denx.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Kondraju <Ganapathi.Kondraju@silabs.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Angus Ainslie <angus@akkea.ca>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Narasimha Anumolu <Narasimha.Anumolu@silabs.com>,
        Amol Hanwate <Amol.Hanwate@silabs.com>,
        Shivanadam Gude <Shivanadam.Gude@silabs.com>,
        Srinivas Chappidi <Srinivas.Chappidi@silabs.com>
Subject: Re: [PATCH] wifi: rsi: Adding new driver Maintainers
Date:   Wed, 01 Feb 2023 13:14:16 +0100
Message-ID: <2096561.vrqWZg68TM@pc-42>
Organization: Silicon Labs
In-Reply-To: <DM6PR11MB44414FABE676E37C7F6FA0A0F2D19@DM6PR11MB4441.namprd11.prod.outlook.com>
References: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
 <22ab680d-cb57-74ab-1a37-c7d7b5c29895@denx.de>
 <DM6PR11MB44414FABE676E37C7F6FA0A0F2D19@DM6PR11MB4441.namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P192CA0018.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::23) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|MW4PR11MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 058afe40-2327-472c-148a-08db044ddb52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJqRiQbGKoeVeV6D4fDYkC8zqqhjToGUUw+F6hEu/t2cmZ+tWNIvAmDuuA908dOdiHFsvd4Jjz0WMM+IXvVQyBBodPcfotNBWivzq+gWJCAMkoDf4aKhzvXL3ma/dVaz79vBYbbqAH7kMd0ylVtKFU+Pfc//fsQEMKYF2lKxluv9b2Xo8Hwe57KqL5/ytNyxv4nv3F/Cclerj9NjuEDJOCkTKwHGGHD+DPVCPJUnpqnwHXIQEjp4NIqdk/jXRFtS1BWZAk6fInmPe2zc2uDskCWFv7IqgjEcrPDGYYqI1aSjd3ArU6q8hn+o0yl7QF0UxwntLhTWaTSVf96jK1p0tTLFydnwS31DXgYA91sgKHtPQQr7TDFHFBbTCXKMHmmaK9TzkNRzKrYSO46jE34ZQJzhxkdm0h1HKw+JxfEnS5zZvU+dN+ufbexz4wDv950VTh9RLIONvRUidRrCjGsLPED94L811aPZ2RGIwQr/f4zBMNh9Ob/d3hvjtLo4q3AUmH/UfOHnZ97sGesyF8wTja/z2H85gdwvUEUOQ9kFEbyOyT8rFKH0p7WMpVSVB9Yf56yNGSKFDDZ5ImFTLUxdCrzF/RmzoMzqDCUUwuwYkGH+gRGx0DCn26btafc8QFuQqMD6avaPBZceoqNge5IvzVQ5U0mZKRRCkYiLOg6zb0/G5HwcXc5bseh5Mf2bV0gsmEqyoYa8hhJ4dZNR26LeBgxZwVgl2ynyilwxkavfNh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199018)(36916002)(6506007)(186003)(9686003)(6512007)(66946007)(4326008)(86362001)(2906002)(66476007)(66556008)(33716001)(54906003)(41300700001)(8936002)(38100700002)(8676002)(66574015)(110136005)(7416002)(5660300002)(6636002)(316002)(478600001)(6486002)(52116002)(966005)(6666004)(107886003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?tPtmk0HAFZSsYvQgpsg9NI6aLR4kl7s+mpt7JNLvl4nztOKv3UdbSmlVZN?=
 =?iso-8859-1?Q?dMCwt/OSswBDpH9VZNeYY1fgbl9KhRcd/LKmhAIPGtrhDFOj3A07ghrFsQ?=
 =?iso-8859-1?Q?aBLdak9+DXLrzPi9LWEJHjW1Miinh6DNuCmaGJSfe3Rq72hhsDXnPHFOF3?=
 =?iso-8859-1?Q?g1GyW2VUIFk33a0yHZ8lDaKwvlopmE1WsZ5d2f5ESUI1yBM0RYxP90uM7k?=
 =?iso-8859-1?Q?OigxbVweRmKsgcTXpN6eEhlUdjl79jQSFJnTSQuKNgTJRe+/TzYC0v2Z/i?=
 =?iso-8859-1?Q?heOvbqVCUhDKuDv1W4wEkShSMyDzYPxiY1SlZH7+zJvPJQ/0ZMBLFVSTUU?=
 =?iso-8859-1?Q?pqVP8IO9Ve0u65luAPt9toh3jEmAHe8rVXMEP/zSPf+csDP66M1wty7Kll?=
 =?iso-8859-1?Q?eCJ0bYDySGS9AClC8oajSh+3QnUcznGXszSsK/fcBtPxdRCyOj6dSCEVj9?=
 =?iso-8859-1?Q?hS1+r8B7eiXpC+PIcCsjMtrV/0iRzRoVTC/igJ2LAFWTcH1d3I4P+os3Pj?=
 =?iso-8859-1?Q?tJTLca0a3pV0aQoPwJ8zaGcDQbBH4kZkoH5Ih4qMgGWjVICig12QAi3a22?=
 =?iso-8859-1?Q?letxE3zfL/BTeO1CkGikS5OPb8baG6mpFXE9ZEUufnFk9kJ+JLjy8+vcEH?=
 =?iso-8859-1?Q?41dV65YfBSChFbCYWaEZG+fJKZ/92dsyLyeIebiaIDpHoSbDkFpFrkU5MF?=
 =?iso-8859-1?Q?ceXv9ggi2YbQY92vOFFLLQOMxqKm8HKkPdvIpi3zj5uTo7g0+K5Ne6PB9F?=
 =?iso-8859-1?Q?cDOX+m+T+XFmszP7Qu79+FC19YiibnFHy895nZ6y6CWgAoadmeCVu+bPIN?=
 =?iso-8859-1?Q?XyGWeYRPgIrQNg4DaJlcCVfHOj8yHqTrRKMIKulNCGVg1BAel9ipmoX5kH?=
 =?iso-8859-1?Q?//t5f9gzcUON4CUGsKGWTGpOuojuL8D5VNIEuGvEbqpDImQxkUql7Rkx4k?=
 =?iso-8859-1?Q?OImLybGIdbTxQlHy0WIh/C2DUfqMpqH2ZMNcB6HRK3++dmaiKU3a9a7HpR?=
 =?iso-8859-1?Q?E+IwrqPsh+UNoaTP/bhjpBTFK6o/Chk5PMTkqvMLfkamNRocETLIdvxCBS?=
 =?iso-8859-1?Q?ezp/nvALMUg2ah8qnti2lu0dapC6J4q9o5GZbfG1IUdjw4QJvJnwajxj21?=
 =?iso-8859-1?Q?7se+7U5Q5glu0A7RP8svDoeoHxRJs8U7VRcyxyP/2btMKh6FDt0X8O5T32?=
 =?iso-8859-1?Q?bSTCrhKuzBIowWeGZwYC2XkwXGp6cFAQd2rX0aixjUe76NV41JnRKJMeIp?=
 =?iso-8859-1?Q?4sJJc6GB35ekGbLphwwja73ROlLgpgM4FLKM6keFiMhtFVjBS49KdzxkAK?=
 =?iso-8859-1?Q?ojU8SBuT2Rtkm15SfenH6/HX89r3gG7n9WowEa8IeGzyo9dHix/olz2CIp?=
 =?iso-8859-1?Q?dKazTeX7LaNibjsXR8h1TH7iBaB3suuIVs7fCfR6QQ33pWURUPWEn9azON?=
 =?iso-8859-1?Q?SPXzbAEYtmQa9YBZ9YEdMaWInZ3XosY7kBjLEJjMKXs7a8cpAaI2I6V0GK?=
 =?iso-8859-1?Q?NuMQXz9XKP4qhlqEDHkPAGDZ9AdQqszhzbeDH9A4s9oVCslw74B4n7CEsq?=
 =?iso-8859-1?Q?QcPyDiwDIjPe9HaQcPqrCKB857Xk9FTCQr4o75Ema9LxmnqA5ggqZC4vJ0?=
 =?iso-8859-1?Q?CssE7neDziq4dULzIGQgOWRf8QSAD8doRKdqvHTYEQZ7xt/lCqtDURs5Vq?=
 =?iso-8859-1?Q?pnS+KnNz8xsnVOrTtxV1Flhp0cSe06KgEWf5N7ZZ?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058afe40-2327-472c-148a-08db044ddb52
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 12:14:24.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABV4zuSAohiANl5F6hVHfNcp1KQutQS1+8bUWQfyvtFrj1sR6mX+sNez37NXSB00oWLVxEmA0skYps7PCOdaUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6810
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 1 February 2023 07:41:51 CET Ganapathi Kondraju wrote:
> Sure @Marek Vasut<mailto:marex@denx.de>, I will send V2-patch with your s=
uggestions.
>=20
> Thank you,
> Ganapathi.
>=20
> From: Marek Vasut<mailto:marex@denx.de>
> Sent: Monday, January 30, 2023 7:32 PM
> To: Ganapathi Kondraju<mailto:Ganapathi.Kondraju@silabs.com>; linux-wirel=
ess@vger.kernel.org<mailto:linux-wireless@vger.kernel.org>
> Cc: Jakub Kicinski<mailto:kuba@kernel.org>; Johannes Berg<mailto:johannes=
@sipsolutions.net>; Kalle Valo<mailto:kvalo@kernel.org>; Martin Fuzzey<mail=
to:martin.fuzzey@flowbird.group>; Martin Kepplinger<mailto:martink@posteo.d=
e>; Sebastian Krzyszkowiak<mailto:sebastian.krzyszkowiak@puri.sm>; netdev@v=
ger.kernel.org<mailto:netdev@vger.kernel.org>; J=E9r=F4me Pouiller<mailto:J=
erome.Pouiller@silabs.com>; Angus Ainslie<mailto:angus@akkea.ca>; Amitkumar=
 Karwar<mailto:amitkarwar@gmail.com>; Siva Rebbagondla<mailto:siva8118@gmai=
l.com>; Narasimha Anumolu<mailto:Narasimha.Anumolu@silabs.com>; Amol Hanwat=
e<mailto:Amol.Hanwate@silabs.com>; Shivanadam Gude<mailto:Shivanadam.Gude@s=
ilabs.com>; Srinivas Chappidi<mailto:Srinivas.Chappidi@silabs.com>
> Subject: Re: [PATCH] wifi: rsi: Adding new driver Maintainers
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
[...]

Hello Ganapathi,

Please avoid sending HTML email. Top posting is also discouraged.

I suggest you to read this reference:
  https://kernelnewbies.org/PatchCulture


--=20
J=E9r=F4me Pouiller


