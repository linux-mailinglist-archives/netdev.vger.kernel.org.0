Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560B86D00AC
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjC3KJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjC3KJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:09:10 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5906E93;
        Thu, 30 Mar 2023 03:09:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U6f0O8005361;
        Thu, 30 Mar 2023 03:09:02 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pmhc4d0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 03:09:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbIJMxS98rk/YSwbZrsHRoataEcjEZHe2G5aJOKq5fJ8AJa+8EaiAa6iWKQglZJurytB4maqkI4HE9wErrWPGPTsnPnpnym0FSa4HJHtUVSNKiAbdl1eMikvrj8l977qmpRX5QGmnNGUF2DpB7mbitpedVC6TYm7cVgrs9d4MltYtO2wdlulvtHk4pENiM1KU6kQVCJXd5R6juMWsbez9H+L6M/WvUYCKLll+OEYYyXeUS2bBF7cCyvEnTxSn6X0r5eC+QwkONzjcUvh8EVJAJCUSpJRMtAln3aaJYKscNNo4G9kS2qd60S2JoHRRcwAilqoot+qONOZ8s7wn2q84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiwQ6P0LbvPPsnUkMUzEx3vgciy3yYOsebCKfh2Y1Rs=;
 b=PJFXjCGqFUTA1aQ2k9JNNF5EmIkbTZUFFPMWHhNzDk2QP4vYxWATd5nCPHt6u4cW1z09nTAnCRIRO9RRPNj0qqM4rpUzUiyaPhYrQI00+d1sA+hfxD56FtzslEAXvwpsPFlY0w74VCEWS7NFzaMwUftunERbNN53RzbjIoJfy6WIepGJnHhvOZspDEaNdpn02fv/O4ErZCf/HZjEhBUIg2exLDMaMSFX8kSfFCyzrjzsS73b3iAhXQZjtAowlG1CvqhBMZjsFGVZN7Iz24SlvEjO5LvvbekYopDr+F+PerRk4auc8zY5GX3nodMsfEnG35ZI/+v+CPhB5oGtJ4TRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiwQ6P0LbvPPsnUkMUzEx3vgciy3yYOsebCKfh2Y1Rs=;
 b=OKPCpFLlBKyGdUr/wzh60AJNdCuiwE3pTGfx9ntWLkYyq+n/4CI9CeX/2iY34Vz2vNVdcuDqpOSy5BPo61xRnYcxmwxtHiGN0EesfW1N8TtiKMQgUoO5Y4MpUy6hwIvqJh36ePFRvZ+9tzKYs0AIDmg1LvmpmoQ/+f7MeEMmYrY=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by SN7PR18MB3919.namprd18.prod.outlook.com (2603:10b6:806:f5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 10:08:59 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251%3]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 10:08:59 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: [EXT] Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac
 type
Thread-Topic: [EXT] Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac
 type
Thread-Index: AQHZYmDeXzOo7CyzoU608CFuRZt47a8S2i4AgAA9ijA=
Date:   Thu, 30 Mar 2023 10:08:59 +0000
Message-ID: <BY3PR18MB470786C30C037BFD519147C3A08E9@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-4-saikrishnag@marvell.com>
 <20230330061840.GM831478@unreal>
In-Reply-To: <20230330061840.GM831478@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1lMGRlM2RjYi1jZWUyLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcZTBkZTNkY2MtY2VlMi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzNDg3IiB0PSIxMzMyNDY0NDUz?=
 =?us-ascii?Q?NjA0OTY4MTUiIGg9IkRoZ09tL1gwbGdBSW0ySTVUazZsTGdHOVRpTT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQ3Z3RXVqNzJMWkFZMENXbVFEdnloeGpRSmFaQU8vS0hFTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRHdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|SN7PR18MB3919:EE_
x-ms-office365-filtering-correlation-id: 2dbf4141-c78c-4fe8-7362-08db3106c7c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O/3tcki14kBPv2pI+MkPm9efP7/ScKh/PTJtFqWxPK/uakNbQOZUwVKzY1zK5HeakyRYYkZJachrn2Yz3AWgiVzrkFQfFAg7DNogFgPTPer7bh/6rFwAkKy0aL5n/5+i3WHLv6F/xYwgL6tPlc4iuziGyegVs4FYgHVom5WeeGOYumNyyjDnV9AewbAGVYarHX6I0OWJFjxr5ifHZGpZ2nKOF8OGMZs/EAD9M2X6bUaMdh8os2pv3EnEMpwlfSbtt5h6hzCGDo/Z2HvLINNjg8zxMqL+qidGMTN+F7emMVGmStZh0MiSn9C95pou7RhgrlBcdHm2BP9fhEn4Ge1ZYB3QIkhklLjhYBgwFfQsvULFGuIXqPBEW7dKn48/F9xmo2CyFjVamF8JDPsZrIzsXDbkExRJDc7+UWhI1+uRttjHgZyk+Ke53LyGgoAdplTKhhGgu/b4lGmCKD5MF8Vz2WK+cNmZlMlrU96qkDK8pLjFFmxbksEJ3XNfnT3gC0AiH3GtfB/F7Rq6wrGL4w29uesYRD9OwJW7jxtElYcBo0gjVfowJ+ev4G/BRmNUG4cyPqUWxZ1HttE9BH8fOPvl4g30DzPRCeErzw5455OI02lBOlIhg/n+4cwN15+1/AWK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(5660300002)(8936002)(52536014)(41300700001)(2906002)(86362001)(66476007)(76116006)(66556008)(8676002)(66946007)(6916009)(4326008)(66446008)(64756008)(316002)(478600001)(54906003)(45080400002)(71200400001)(7696005)(107886003)(9686003)(6506007)(26005)(186003)(53546011)(122000001)(83380400001)(33656002)(38100700002)(38070700005)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R7aGBCUwzNmLNfSr4keOtqRJ7JUBTUDeeZQmmmVQKaw/aWrOaI9mgqFCOnnk?=
 =?us-ascii?Q?2bvg4M+92XKl1uDnkzDJ+YsPOT8dMk/a8Rmml+QCcmKwSeYIU6tQG3NqILxh?=
 =?us-ascii?Q?Vu4CDszorUVw3sCYNsiysx5FIwVi4zkU/BqrvGXgtdtlOIrbCg7rCuaWiNTw?=
 =?us-ascii?Q?vxmgo8x+oM9B09NtnWnssXWAIVbYbZ7Jx7Ux2rP4cLaFEUKfwL1mCLmzVFXE?=
 =?us-ascii?Q?sifm9AuXIp4r7dVo4uf29Q19AURSQXn7nWETeuPeIKOp05akyY3kTOrULy1c?=
 =?us-ascii?Q?vVRT+wNgcTgIqniojXYDoiyxNTiPmFcywVqW7+J52HzoPFgQ8XrGW33L0u3N?=
 =?us-ascii?Q?Fq+7tAyXbtRQnDZFiTC5lr+v2ji5T5M4O9CZN+oKyyjNEebBHvelKnX6OyEc?=
 =?us-ascii?Q?riohYLLRljZUG2n15wCCBvA0CVb89xnnzqRlGvPCTyeT9oenayLyZA3Yo9aQ?=
 =?us-ascii?Q?YeCxvTNO5Y9hpSxCSUGbtkIxQ9SDm8IfsvT0Cr+/PLp7fNbEzSdyucDzqkO1?=
 =?us-ascii?Q?Jg6s35uYFZ9Fe5l+olEhEVFeamLUMlaH4c10ANMB99tnGtsR0gaZu7Ls/mWL?=
 =?us-ascii?Q?EBXme6gO48HysGO9YNVI1BnzNGkAvfDCm0UFTOjRGfmXFBVG/DMh4LZDc7XS?=
 =?us-ascii?Q?JBC09Z+uH+bAJgUqXpDurBdZhy2+WMCQKshl+mZMvcAJb7+mwjl0iPGcPMl/?=
 =?us-ascii?Q?UTT0i773gLZJ9HCpNoOoUloH7N/o222jFJwM46+mtWUg+9cMkty2hQK5mKh2?=
 =?us-ascii?Q?DDxVQDMlKABjDoBcjN8j2nznPo2j6XpyooOQHhEfe0jcD03AJKgP/CU6ibON?=
 =?us-ascii?Q?4QpGdLAm9IJRcFeVHFSjyrmrkHGFovf+Wznx0fG8vFgzbxmvyCqtZ1vEDzZP?=
 =?us-ascii?Q?C0ehHS1HNnMUVMSzLya4iozMhnzRCCgEjCkTSOjTv2Og9kYMhPbBgjMDHhVd?=
 =?us-ascii?Q?kki/RerSVCf82omRqC9dKJt+7jhn4KVVDC8ooODUC0qDW1Nbl/yDcaWb0S45?=
 =?us-ascii?Q?R8bw6sFzHAIUFK9NgHOpRzFf0DOq3Xql9J0gPVmUb5zoz0vLJ3rE1oZAnEZ7?=
 =?us-ascii?Q?BZW4PvB6wUdEOLF6OiZIk35Jbq4DnPxo60t9UxSuTPAoz9sslTNfiu5JOQut?=
 =?us-ascii?Q?rWARLL+T2VehiWGV+LWRYRmfUBBrZF3aFSLO3b54ds7ZgVtx6UXQFB3ecOe8?=
 =?us-ascii?Q?PJXKk16wJLrlRG3RfNeElFk4pUqs6s7lSJEaL7bJOXgrKlfCIgCSMSDPpOi6?=
 =?us-ascii?Q?jzwqt5OMgQRHUVNvEv2vrJ/8rNKDgeskHbvvSFYY9PPdKKUN9qPv8djeWpgk?=
 =?us-ascii?Q?gP/g+xM9pUYgJEXFMHh2vlX/NV2OkucHQ3PxiG+x8Nmg4ujQ17JVqNJR2yYa?=
 =?us-ascii?Q?whDignQbB/QROlRUNWWuzZSKQrbk1Zt3KoozhUrNAG8YdIT6bplmt/yo58ix?=
 =?us-ascii?Q?QRA6mdYaVY8kQVko0sw8wFNvM26dlEdS/AbFdJ4M3fUtw5v0aIFZ3ElrqL9V?=
 =?us-ascii?Q?YrtE4dBmVp8C9OiCYTsbIzJKC2th6ZFPEmY4AX+qvvwsPrJ7f0cZtkd/dQ3I?=
 =?us-ascii?Q?uJBwFnaD7H4ebL153IV17UahTerSWvUI8YUyv9PH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dbf4141-c78c-4fe8-7362-08db3106c7c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:08:59.4106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B+KIycUjQWSnQI07jF4Tb9N8ZYfb0KFHHbeL0cCEieCk+DIylelY0N3mizUohL4YLqTmuv7Z3sLUEzrNQllI1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3919
X-Proofpoint-ORIG-GUID: eAM2zbAwG2YQr0eAOr3jfSDJcfBhpVNl
X-Proofpoint-GUID: eAM2zbAwG2YQr0eAOr3jfSDJcfBhpVNl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_04,2023-03-30_01,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline.

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, March 30, 2023 11:49 AM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> richardcochran@gmail.com; Hariprasad Kelam <hkelam@marvell.com>
> Subject: [EXT] Re: [net PATCH 3/7] octeontx2-af: Add validation for lmac =
type
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Mar 29, 2023 at 10:36:15PM +0530, Sai Krishna wrote:
> > From: Hariprasad Kelam <hkelam@marvell.com>
> >
> > Upon physical link change, firmware reports to the kernel about the
> > change along with the details like speed, lmac_type_id, etc.
> > Kernel derives lmac_type based on lmac_type_id received from firmware.
> >
> > In a few scenarios, firmware returns an invalid lmac_type_id, which is
> > resulting in below kernel panic. This patch adds the missing
> > validation of the lmac_type_id field.
> >
> > Internal error: Oops: 96000005 [#1] PREEMPT SMP
> > [   35.321595] Modules linked in:
> > [   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
> > 5.4.210-g2e3169d8e1bc-dirty #17
> > [   35.337014] Hardware name: Marvell CN103XX board (DT)
> > [   35.344297] Workqueue: events work_for_cpu_fn
> > [   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
> > [   35.360267] pc : strncpy+0x10/0x30
> > [   35.366595] lr : cgx_link_change_handler+0x90/0x180
> >
> > Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to
> > PFs")
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > index 724df6398bbe..180aa84cf1c3 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > @@ -1231,6 +1231,13 @@ static inline void link_status_user_format(u64
> lstat,
> >  	linfo->an =3D FIELD_GET(RESP_LINKSTAT_AN, lstat);
> >  	linfo->fec =3D FIELD_GET(RESP_LINKSTAT_FEC, lstat);
> >  	linfo->lmac_type_id =3D FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
> > +
> > +	if (linfo->lmac_type_id >=3D LMAC_MODE_MAX) {
> > +		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d
> reported by firmware on cgx port%d:%d",
> > +			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
> > +		return;
>=20
> You are keeping old lmac_type, which is out-of-sync now.
> Why don't you do something like that?
>=20
> if (linfo->lmac_type_id >=3D LMAC_MODE_MAX) {
>   strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
>   return;
> }
>=20
>=20
We will add the proposed change (Unknown). Since we need to know the firmwa=
re reported lmac type ID is proper or not, we will keep dev_err also.
> > +	}
> > +
> >  	lmac_string =3D cgx_lmactype_string[linfo->lmac_type_id];
> >  	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);  }
> > --
> > 2.25.1
> >
Thanks,
Sai

