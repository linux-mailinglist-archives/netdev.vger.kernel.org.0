Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17656EFE24
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbjDZX7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 19:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbjDZX7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 19:59:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E200269F;
        Wed, 26 Apr 2023 16:59:20 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QGx4pT005088;
        Wed, 26 Apr 2023 23:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Tjhwuk9zpqwmJDwpqp13b5ukm70ttuIwBtiUUTZKe/w=;
 b=rS1VIBTUhkWX8Mm5wGMEhRJQMQhLRvywR5Wewwlp0MQFAvf+euYjxTLsJQs6B/RG6Ok4
 BRbc/XOAKgm8fnEjZ4B95EhG5INXbolZ4O1ytoOym9/Vh1aTOXPEWd0dqJfy9s6OGupl
 GDv9FCSVVlBOcazChghmHKyF5+is8XYXq6V0ZfsG6YuafGArEoAnhRSYo1hrqpCCfL+y
 uBHn55eTh4Mi8vvkLaGpbMMBkAvxYTTya2dikDvqA0I5ydeZrwy1nMk8cuA5VY720ey6
 lGZgAYX40n6lxTuQK8ujMpgxlufljqNDWdSy+tzs4uGwpXqneYZEpXnp5Ha3+VtO5OrT oQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q46gbts8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 23:58:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33QNg9Co025085;
        Wed, 26 Apr 2023 23:58:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q461ew1am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 23:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhPkQamb6Hy5MftM7s/cDRogE+pCpQiIZavvzz96iIz1Azj4voxSP2ibuTcVAL6ONUKsZzEjfcd4nmRfrWnkB8Rj+BwepSC/XaLaj9LJSJ/1ooGRZXuAPEbciecMZF4eLsyqGr8Fs8hSBf3U+XBfcpEUp5Qsd+Qa0cOePsue2ZUwbGKbo8O/sZ3MCqWTGG5wPyjBVZrh6IiGU6xTQfUpeqslAx5Ujk58j68BFr5QhIP8sTegEK7EXAKAk9/H0LgtWW6IP5MfxD11jIyhcrkn/HBedWTlEENZDYvaPiKZWUiR2d9a6EcQ2MfhL4yTirst+eimT2KiS71GKBvFa85wog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tjhwuk9zpqwmJDwpqp13b5ukm70ttuIwBtiUUTZKe/w=;
 b=CUbv3hJtDPMrzJTkxGGtHsZrQMEpkG1/KwYY7e1ogvhkbJYZBojLSHYNmvG9XrTi82e/ndD5K35X17h7F9AoYTEQttkX3xeWcKtmpb5HHk3zFY1D9A9hfxzEcR3Gnei95RyRLrCR0cPKpqSc7Z7uGtwUx7zVB9/wAgS4x+pAE5lg+aoF9xpGl3aPo6DmcPeY+7scqR/GN0X6SzbGKlWXSvq4qG+Ah8xMTAGUeQxcRYqJFPmz+SIuXlMigm47gmqJCTrazWs1CfBx7JB8dQLOJjaDWnZnn55GiimTEJDv2f+1uBEG1GuQNEwneaZbGPOavsgJE493qaGB875WmM1yNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tjhwuk9zpqwmJDwpqp13b5ukm70ttuIwBtiUUTZKe/w=;
 b=CO62JpZw3EypOic7nYtaLwFJCsx4X4Dfp+6TGdiJCMNae3NyPvUSlBeOEkm6pg2aicD7XZhUEyggpyMD5k0wpnidQtMUPFwBFj5hOZ1JPuK0zJazNW/T02ZLD6EFLi0jjyg2QoTBUhiw+ir3A/Gxa6C9XdqvxV6ur+47zHWax4M=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by MW4PR10MB5725.namprd10.prod.outlook.com (2603:10b6:303:18b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 23:58:55 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19%6]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 23:58:55 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAJFpdAA==
Date:   Wed, 26 Apr 2023 23:58:55 +0000
Message-ID: <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
 <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
 <20230403135008.7f492aeb@kernel.org>
In-Reply-To: <20230403135008.7f492aeb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|MW4PR10MB5725:EE_
x-ms-office365-filtering-correlation-id: e20fa715-d507-42c2-ae33-08db46b23176
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tPXUuxVsPtidglwpQp8GAmm1Ji54RaFg3P96/ntLC5XglAYHQqZ2QcejFgqxwy8LjmIV1prByFlmg6HV+AoEIBvjeErq6KDFpROGyw5t8ztGQq41HdreO/PrG7G4yOBEt+L7xrOY4H9jv4K5TvRgSC2f9aI0tYjYuqgK3d2Sok9fEqyQXisuf6UiaupYr3a1bYn9g7ToB82ob/BTXXm5tWovfi6KLYVoYvt/2jqWIu0p5q127IUEvoAnyDF3hGT1vm2hbqP9IgCo5SjhEhGcaGTIeqXf2dJ+FL6NUczNS+/MFfkZw7PFeHbdAYt3E24RQ6/R0ItL4x6W5UE3ZtkYd/4kYXLixgTtVm3hqW3rrcqGWp4wid14jM9E2EgxxFkiPWqshVxgiWbi9DZcwLiRlbOrGG1/AvYm0MC423TASbsb5uBNGnSGc83wsNiV+wsSNI2ojizBTQ3zXzUAsMSQkIzYxYCVMGPKo/qEiY8sCnH7zlCFQ+q7VgOqBH5+mTglJGPboC0hCbPL7T9iGDnE13p7CZBDLJ5IGMc+W7JWjEnoy1td1/aT69KGG2Oe0wGYQ7lPFmXzMp3aTP8S0TiAg9RWKSsNCa8joQzvZIYTROMZ3LnCqYIV5q/Z6DLBriQ4h/QG4QCxidDfmlGKkoeyeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199021)(2616005)(122000001)(38100700002)(5660300002)(2906002)(6512007)(6506007)(53546011)(41300700001)(38070700005)(83380400001)(7416002)(8676002)(8936002)(4326008)(316002)(66946007)(66476007)(76116006)(66446008)(66556008)(64756008)(6916009)(66899021)(36756003)(478600001)(86362001)(186003)(33656002)(54906003)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+ObnbZvMQOK7RBB3cZZ5uumJTQPD3ipiQ7ofg0nhuZUV4y5U/GQEAdPuUfI9?=
 =?us-ascii?Q?WtckLkEJkXaRYsE0M+R9MgAmaD9+QAjtG5ThCz9momC8xZKPJqSJe5mHOZYx?=
 =?us-ascii?Q?wUy46nD1/+kdcwgpCfPyHWBm0vXD6kiOPKSDTb2uebskEsRrz9Jf8myYd8Gp?=
 =?us-ascii?Q?Z1Y7kmd8e/AUGith5Pze/zVTVhddVkMshoHUNuBKMtUUp100ZFhddI2FjtLo?=
 =?us-ascii?Q?gQQlFyrGo4uCpdX5YTN5NjdZRfXUOcZpXTbS3z8TUGQo9WakXoaEKJ8mF9+n?=
 =?us-ascii?Q?lTrVzgdtY9Q3HUxcji5Phrmd4S/2mkPPgC3QIZq3axcI2GYkKoz7rLgAxGYW?=
 =?us-ascii?Q?MHW785rW1uTSdxQw6F3vkgIwREpmcQp+ift+cG83peJwN2TZCvQ47UUTpyCl?=
 =?us-ascii?Q?epEeYU8+wFRvgTKmq7aNEaLLEN3P2N78/XL1MDUwXE/vR9LxvcK7OR6cc+TW?=
 =?us-ascii?Q?luZlhkeY1+qSTsiSn7erDnOngkF8CZ5VFuRtQuAJuPfiiPmDs2+RfKTcPEku?=
 =?us-ascii?Q?4GSqJAovQfHgK8ZdXSP5+48sYHnRMhjYMjtzr4czujmyZVudiS5G2MvdGq+L?=
 =?us-ascii?Q?WoXv1PeSHXRGMZzfZotxzpdo6sZTD9jkXi3YKJWnI04CA1isGE9u3dfJQwye?=
 =?us-ascii?Q?rcBEKBZfZFWttmuf9j3FtIUtZgJq2ASSv2FBcvZgYSjXBrmMpQr+1LX4uH7W?=
 =?us-ascii?Q?M4CBXN+T2k3KpfXJDb2Aj9hfNpnBJ58VfgyawTQq2I+KjBICj7k7jelO7MTV?=
 =?us-ascii?Q?qunjvxfaEN4MeLz5uayxSDR5eHApGYJsuJYdLbzkkwDN/U8/fhEZ2UvFlp/N?=
 =?us-ascii?Q?j/HibIC9W5oFtRk9OEZBglAJTQkANaxTT8fCXAVONMA1YIRTqLnfB2DJbtBP?=
 =?us-ascii?Q?fVu2i8/abvNopgOxv38eCCK99rpMGEEBsFaQG+8IBa6mLP917ftdAm3lKfut?=
 =?us-ascii?Q?T0gY+1nkyYpWTfKk8rYDQo/Xznme78u0WKj/fpXxlakeMzAFiUVPDsBuEh8u?=
 =?us-ascii?Q?OReyhhr5BNQbPbI0Ce1TO+XBCPJHIrnpWZqdgJXFOiEkkRhYtl3bHTDYM3bz?=
 =?us-ascii?Q?pMIrwPGp0rkqHhmvyTCoZjRo1dAFs0BtQHqSi/h3LO/CHhgv1me74pk1X7Nk?=
 =?us-ascii?Q?Sjx3eArdSCcesOyAS3+57TGp4Yjyg0yOqe25hLWtdzadLiycg/C8S7FvyPw7?=
 =?us-ascii?Q?xBUgPd0Y7/oLOf/5NLbdAgEHsL3MDQiwZkdWyRBDfoPsLzQu+tlksYtWQpEw?=
 =?us-ascii?Q?n+U9SshVgmwAdXyMF+YItw9zyMIHTWlZjwWTWqvd+Vrr07X0bB74+ZXzXnEo?=
 =?us-ascii?Q?pKdSpEL4g2HEYYeszxbcTS1yjVmp+Bc5857Yfs6UiUq3912XTdmgZf15mCZv?=
 =?us-ascii?Q?b6t+6c1VjTLdnDI0fkCaPXBfNFWXvz4hE/T3lnD+PWCUHLNJe/C0Dw7m2t9Q?=
 =?us-ascii?Q?HCI9Kl+zZc6LkimGuO32vgm6Lu37v1BerlWuNInXIBlctdTSugOP+IxXZMse?=
 =?us-ascii?Q?twIXekx85PdcaJXiH5jg/rDi6jjPJtmc/7eFAQg+BjMozmYNWVjgSP8w1PBp?=
 =?us-ascii?Q?vUbj+RT/8lNR3FbMy8HWiT9oS1n2q1oSO72WUyAOAQSs97JOSyf3KtT21U1X?=
 =?us-ascii?Q?N6lWNmbUjnMpDraC8ogDx7XBJlT13ZjS+Hd/oPb9stdEQAxir8rasH16ujpd?=
 =?us-ascii?Q?nyyAtA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F8BA959F2B52F40B30731273EF5B72D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?CjGNsfkvHy8dV6bBu9K705vPoCVPC62gSmtE2bxBoP8NcBeSgWenDxVz/eSK?=
 =?us-ascii?Q?FFKDaNRghX+LLYCoy7o13Fn0Py3Aw6+f+t6ruV0nNts7LeyXOYHQov65pwSI?=
 =?us-ascii?Q?eHaAflUXyTXAH2FuCi4nXqK64kDnCbSopshG9sAtmNLOLUu9ECwyNkdcxLrq?=
 =?us-ascii?Q?jr7TmuYvKiDOTdP7Dbr7KQsXJT+BF6/KAqGuUcn0Tn/AADVSieu/tuSqDkQC?=
 =?us-ascii?Q?RAc5bfXuGaMmnA3H3IkbE6OtSMREn0gzSfLwUrRYoJx/AtR4yAj//PnO6/6x?=
 =?us-ascii?Q?Lh9udt8r6ELM8ZCwxm5AHNgwXMrFMtHbsk0epK3RPilakRauIpOuR36KXNfj?=
 =?us-ascii?Q?NvTkNoImPOMUR50rBNDBRDOovBbakP0CAbxNc7ZaXf4Hol66WJkMGIKk6/yy?=
 =?us-ascii?Q?ytuerwl9itwAj0wX02MtDAMIdEZIZjbb5H25S2wLYK/Les74nC/kFqgFnRiU?=
 =?us-ascii?Q?hGU/qVf+7psRIWj/or58Wm9SIjvDlYdSfl33L2rjLEZQ3r6JkZnDM6oXYlxR?=
 =?us-ascii?Q?8x06NJdlFMgN7IdvNdYkQSczJUzcxPnZLxGZb5Qwmnq4X9f+WGXfQSu9VVvb?=
 =?us-ascii?Q?18jJ5W0kwma4VUIlyRINIvza304e00078KFD26mJKIACfg2HQirZU19pvNTE?=
 =?us-ascii?Q?ya36pvypl3xWhnso1eFUdfVzcFg6ZvyL7K9bMvGU/TS5GHMwPsqgy7z10PsF?=
 =?us-ascii?Q?9W6z1XFJ1BnsFCoLFp73N0Bcf96/IpbnWVcTyPXPcLVbfRabtVDqON9R4MfR?=
 =?us-ascii?Q?yTs0kHgSUn4GPWz+f8D67Y9rlAUXMh/NCw/ryVAdHpfARsfGgsJj4rrcmH/C?=
 =?us-ascii?Q?+cDZF33cgy5V5HOrcqkIMz6rcYXaJx2tiA9DX5U/4ALxk4cGRURRuZ23awKe?=
 =?us-ascii?Q?YbTWB2bDXbtFxMfgjBIS0Cn37Y7ynKR9A9JeXpaXZRrCNbXoq0y5g3lGegfh?=
 =?us-ascii?Q?3TsLpG+ckUcZYSd51FadFYDohfcw2p/9vz37NMcm1iQWhRUII2GnmJsVbArr?=
 =?us-ascii?Q?/Fns41vTjXlYBcczfOwNQYpOlvDyxhy9f9pYx4Hm4htZKuXIHnVtsV69aSTr?=
 =?us-ascii?Q?rkCyu+htsbxvptvhkwHaX/p7524OBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e20fa715-d507-42c2-ae33-08db46b23176
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 23:58:55.0759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUHd0JzXh5iJUi66NSj68hIW1tSVYs3md2Joc8osmNv39m9tYahAtxuusUJ7AV21wtZ04pxk5eKwqoWpjc3TUiD1CgVM7+afMTCj+BHnmgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_10,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=878 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260207
X-Proofpoint-GUID: DtsxfCIuetzQP7qzgXOC_FnrGEVwa7bp
X-Proofpoint-ORIG-GUID: DtsxfCIuetzQP7qzgXOC_FnrGEVwa7bp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 3, 2023, at 1:50 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sun, 2 Apr 2023 02:32:19 +0000 Anjali Kulkarni wrote:
>>> Who are you hoping will merge this? =20
>> Could I request you to look into merging the patches which seem ok to
>> you, since you are listed as the maintainer for these? I can make any
>> more changes for the connector patches if you see the need..
>=20
> The first two, you mean? We can merge them, but we need to know that
> the rest is also going somewhere. Kernel has a rule against merging
> APIs without any in-tree users, so we need a commitment that the
> user will also reach linux-next before the merge window :(
>=20
Jakub, could you please look into reviewing patches 3,4 & 5 as well? Patch =
4 is just test code. Patch 3 is fixing bug fixes in current code so should =
be good to have - also it is not too connector specific. I can explain patc=
h 5 in more detail if needed.
> Christian was commenting on previous releases maybe he can take or just
> review the last 4 patches?
Christian, could you please look into reviewing patch 6? This just deals wi=
th who can get the exit notifications.

Thanks
Anjali

