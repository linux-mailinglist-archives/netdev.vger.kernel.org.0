Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013256BBD0C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjCOTOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjCOTOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:14:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8AE1286C;
        Wed, 15 Mar 2023 12:13:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHndEo012118;
        Wed, 15 Mar 2023 19:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ydtdektcbTsPnMzZO8QazAz5QMooK0MsLAzru1+Ib20=;
 b=GlRBq2N0vf89lgSGMzvJrvmB/zdQ2KChWu8jxBISJnay8Xcmy2Hv5bG3XffhnQj/SimJ
 kFytAsT0aqFLe9eiDMHffEPUvQxvKwKDn3OQPZCnhb6qSH/1YbbG2aNU2EzIz0fxH8Ru
 tsXaJKy7ZVH5R71YdcbomIMWxieeCzXnIgr1bBDVUToe315jj9u5PDkJErmifNd9O1bn
 nNAJ2gy/Grc40x8cU9g1ZzsCWmcsOFyGE1AwAbGLFEOGrBWdEommYEXnnnwYbCaYAdaH
 OKCtaVeFXDodLAQPQvfWyCcI37yIvK+ZfQDfO9RsekbvnWenNG3JYUCvSOBix2FGWlBP Ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2xpj86d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 19:13:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FIbDiI030347;
        Wed, 15 Mar 2023 19:13:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2h2k4kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 19:13:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGfxOSQSP2RuYp4iIYScSveEcQx3e5SzxXAagwrETbe1jMBoiUnmQWhnKLoZdFX3GerrFE3y4yjyBvSREZgg7iE5SRBBqW2ZdVCx9JnW22fJk9qnLSG4FPZKaOzOgyCEsUFt3qiovFg/zKiCgBJzucP4vDxJBpZBiRHmd3ygtprtX9A06KL4QVhXOaxk5mT8/AbNJ/gBmCDDnUT7iKwG6aeI1eiww0hJqPoc7mFuSfoG1FwRhChCbEK2WgDPHuo7zXiC+5aCifcmozsg4XiL/zzYB5cNKlSB1OwBY5x3foLrYdNvuOveB61j7gfYP+PvHwhSZkWUjJouYQiGgxpn5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydtdektcbTsPnMzZO8QazAz5QMooK0MsLAzru1+Ib20=;
 b=l+xlWt0ZK5pWN40LIaXphOt6B6K30UFKveplJHDQcRVV1osCXYxZO9Nx1RPW3oIP4T3ObP8nYDPjyO2qv/BImVJXsYxFe8pRtWHCOXa5ZQej72TuRtG+EVKXIHPGNZXNryNL6jKiBHWjZcvJnlBqFoSuoFecquzqDCc/iSn99/0m576mNgx1j0ALJi5gw7SVOq2yh2htGJS5X97aaEYUZU1hck/ccNA/o0c6Zcdxyru1eqJoi1Rx1hEvTTkQCxLjeAy8KXpAkjiWBUtHNwKd7vMZxh1NGnsA48g/968LPqo/AB5VTyAWIfmnafs8xNmZlpGDFykeE5XSvjLrCCFgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydtdektcbTsPnMzZO8QazAz5QMooK0MsLAzru1+Ib20=;
 b=aED/Vf5IdG+KzlUo75mH5orME/DgFZs7AF4usDLZUs6e7JA/aKir3pKWcVgwgNNFm/+lJk43qZy3IPCRLHIAMR2HBCeyyDQPGtzLy9BV5OcCNDLb8kbiP0xtjL78bUxvjerG1Oc8pUE38pchRQUaFeUD7oUaSzDc8zppE8btdSc=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by BY5PR10MB4227.namprd10.prod.outlook.com (2603:10b6:a03:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 19:13:30 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 19:13:30 +0000
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
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgAAhVuCAAb3ZgIAA7SeAgAABYgA=
Date:   Wed, 15 Mar 2023 19:13:30 +0000
Message-ID: <3086A7C7-12C4-4D36-B04A-D444E4EB9A8B@oracle.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
 <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
 <20230314215945.3336aeb3@kernel.org>
 <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
In-Reply-To: <F553A86D-966E-4EE4-83FB-DB42CD83E81B@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|BY5PR10MB4227:EE_
x-ms-office365-filtering-correlation-id: 0573bd73-bc24-4842-5342-08db25895d3b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G37clKVP/EISpCSBnUSdcAlWCwtK4jyi+FHHQ6uQIkLtAnMeCwSqAlpzSpoPmjE5gXwSF5CeGjEZoXODz40l+DuOwaia+TCFaRq5xz8+ZqqJ2+bttQwUtUQsjV+csRlOAeI+8PDfdNGZCdsDDN+9PnVw+hSZMFx7MF0VlnEDK+CBcS5L1Tdlea+ox7wtt1ycuNJlf+X5xC37x7u73uwVRNHGWs17aJ+NVD5/XE9I1hux7Cr1nQORjSsO6dLvjFlbZTSvXay++uMoyYCnRpTIQYbNzXDtixXn5cjYVMrB/nMj6fHPDHTS4nr+M0AfrwNYBxGuyCf4y7RtisXQ7uOG9Agmu8iVXTsWj4IoLD1fZnucSM/5iuxrxUUyMcsc95tW/0zVss/XvKoF8KRmbkTdGVcQx8QaZn/B7e9an65PF9yTfvsqu596gDVt2r15xxm0ANZqbDQkyKfmCZaxOUQmB9RzE9wcwQj6Jt63HL0vK9lqWzlIL0JZFufPtF89cO6pwtlrjOHDJ5Z5rxHYOdR5Z6ww8nFgfuh0OsjhOw21vUrQ2p9pTKvusdI+tcSgKsJhF4zoFO0Vzl+1Gz7NVbJDQxmNUcfwXNmgEuscbRt/EneWqA7iOg5rW03zWW2IVhm6LaAY0Y78SGf1Yi//N6FhiH8CPm9hvAklv6EEJHyWerLHby886FLCk2bmd4TgPyqv2KMZTdCrEzxZFxz0tlclURHqmg7XryDYmZrt54iSjO8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199018)(66446008)(8936002)(6916009)(66476007)(54906003)(76116006)(66946007)(4326008)(66556008)(64756008)(91956017)(316002)(41300700001)(7416002)(5660300002)(478600001)(8676002)(4744005)(186003)(33656002)(2906002)(6486002)(71200400001)(6512007)(2616005)(36756003)(6506007)(83380400001)(122000001)(38100700002)(38070700005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ci8xNnZ1UEJJblRqeEJxM0tvMERDRk9Ld3Y2YjdmbE0xQStnL2xna0E0YmNG?=
 =?utf-8?B?MnNscFFVekZtUDdweldORHFld080NUZzUmpvMWJKRTQ3OW1LU2MyU254YWdC?=
 =?utf-8?B?bGptWkZDSUJ1bGdmTDhSRnJ5YUdEcjlPRHhMNkZ3WFBwRWQwc3dxeVdrSHJ6?=
 =?utf-8?B?alI3dS8xZkV3eDhZQXp5c1ROTFFaMVU3amhHV2wxTkFSN3V2cnJQc2RYSXZn?=
 =?utf-8?B?WFlxYTRESnFjR3JXd1luRGxaQzAvakM2S0pneC83NTl4NmErdnE2L01EWjN4?=
 =?utf-8?B?M2RBQzR2eFRBMjJLeThIbjhGMjFNU1BreDM1U1FPQ042WnpDc1dpSGRTWUFI?=
 =?utf-8?B?TTVISzJ0TjRyWVBNdG1EM3YySUo0TW9oc0dVbnpXRnRRS2M4TVNWZFYzRzNy?=
 =?utf-8?B?Q3R6WnBFNzlQL2VwZG42b24vN3VNS1A0cWF3ek1lWXZ6RmlMNnZ0dHd3Ritv?=
 =?utf-8?B?dEoxem1heGJjRHdyZFR2eVdQYTRzZUEzcWFQT1pzcTVab3A4UGsxUUsvRjN6?=
 =?utf-8?B?ZFNTYXdkYXk2dGo5WWgzZHFvcnMzVjFGMk1WMUNVdlcyRTA0UzdDYWZnbkhk?=
 =?utf-8?B?NkUrS2FkNURpTVpZUlZBYWpNbHFUYVIzSWc4YWtXYW9wSlZTY1d0QlRQNDVk?=
 =?utf-8?B?MjVXUnVtZ2Q1UzdjTmpYZEIxazB4MHorb3hIRThOSmRDQkFMc1RDckdSSWlN?=
 =?utf-8?B?bmI3Z29VclFqc3RQdDdycjJnTzdXQTBBVHBPNDVGUFp6OVZCd3VtZjVEWlg2?=
 =?utf-8?B?a1J0WjVQRkR0OWFqRmU2SlVuaGlLMDhzUDhoUVpFUWZPVnFuWlk2SFFsRFpH?=
 =?utf-8?B?TUdhZlFNWEsvVy92Qk9sUkc4UlNWWERHU2Q1ZUJJblduMzluTjZsR08zWGdt?=
 =?utf-8?B?ajNSSkZKSG9TU3FUUzV1MWw4OEdKWGdhMEIzRDRIZlZMbVd3YWdvU0ptS3lS?=
 =?utf-8?B?bnY4dXN4RjFqdm1JMlFDdzVhMHdlK242OUdSWnA0SVIvQlMrZDVpUllCZ2tJ?=
 =?utf-8?B?MVVXK21xbWdWdmFxWUh6b1dTVHJXME9jb05mS2poTlpPMkFlaGZDcWk2Wjhs?=
 =?utf-8?B?TXcwTUN3eUlOcTFieDJPY2I0bExyYlJlbFNpRVNEQUl1K1UrN21kMHhTRDk0?=
 =?utf-8?B?dWFOMjNrSlFrT3pHSWtiYnFtZjBYTm1YZVN3TU5GV0xCOVNxRU43UnJVbzNG?=
 =?utf-8?B?SnJVRDQ2ajBidy95RXl0bzFCVzNTZWwrQ0w5ZXUyMnJNdk81ZUJNN2tYTGdn?=
 =?utf-8?B?UFlFbDM0YXhaU2dKTUluTmNXRVhkM3cvSUFWK3liY2wzUzBKc1BLelZwSlV6?=
 =?utf-8?B?NlBPckNuK1Bsdkx6UW1TV29QbStoRjRsWnppYzlreStja3ZidVBPWjBma0Nl?=
 =?utf-8?B?a0FPZlFwK3daTHRocTFsYXFEU2ErQk85czZ5TlFlTVZXQUthT1hvZ1pxczBK?=
 =?utf-8?B?bHc1cDZ4K0RjRndlNEV4WXdXZDZieEZaRUNHclljUndWbmhOMEFvRTArbnJ1?=
 =?utf-8?B?ZkI3Q1dmRTliM0JxWVkrcUE4Uk9kK1VTR25JM1h1b2Y1SVc3VDlEMy96VkYw?=
 =?utf-8?B?YUQ5MW5XejQwZlBuY2R4a1dvYXBabnFES0JzbmR3L2lmRjVQeFpBZFRWbFVP?=
 =?utf-8?B?QzBoT29EOXhVZ1dEOEF2b29nWENWb2RNa0dXc1FsTzhmL1pGSFhGUVhYUU4v?=
 =?utf-8?B?UDBNSFIvTy8vMSsra1RjOFNFRVB1YlZwMG1IdEt0aWx6VW9rVHNpZlUzSlVG?=
 =?utf-8?B?VnJhWFY2Qjdsbzh6SWErUnlJaTBrVWFYM2dlQm9PSTlpRmI3QUNvaHFIRVN5?=
 =?utf-8?B?OGM4N3BaVXVadWZMN1NPVDByMHQ1dzR6dkdvWXI0c2tmTFVKRFZMZzRYcWU1?=
 =?utf-8?B?QU01aWZJc0pJYWlibnFlTEplMmJib3hwbmRsc1dJd3lKODFJL2xGekRPZFhi?=
 =?utf-8?B?TkZwakFBMFEyRVFaNDAwUGNGZVlqTzFaaStuSFZISmhpS1ppWCszL2N5Tjhn?=
 =?utf-8?B?ajJOWTUxY0tQZkRpVkQveHZUc0FHTU9qMHAyYThVRFpQVEhpNHEvK1JieWRs?=
 =?utf-8?B?QzMyejRrR2ZzamUyVDFJMmNCb0VYeWNGSEdJS1FzVXJqYW90UUZmbW9jR1Zl?=
 =?utf-8?B?dGlrVCtJdG15U3h4aWNlVGhpTjlmeWNrMDUrVERncjI0VUFBbDgxRVhYZGxq?=
 =?utf-8?Q?np3l5tNiEtS4sAm3/sIu357N2ihtEHzVm3zOS7ruHKA1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A61E6B1CC9D3B94FB1D1F2E204F58960@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WjFreXg0S3pHMWwvTllWOEF1ZnVGeDRhek9tVnM3MTRJa3RZUzNMWHRFUmVH?=
 =?utf-8?B?VVFaSERDemhxVFkySUxxb3JGTWNMWUVzUUxza3FtN04zaVVQdjhIM25OZFJn?=
 =?utf-8?B?KzhxZHhQTmZXMEpubUZiaG5CcUhFdWZNSmI4RXhZWTNHVzcrL29YQnFROHUz?=
 =?utf-8?B?eHdTbGFXNWhBbXZ6TmN5dlRPWUphVCsrc0pxNkRQdWFwOENTZFdkc0JYenR5?=
 =?utf-8?B?SjRqWEFPeXBVRUw2VUJLbXY2N1NRZmJqdWV2bVNpZm4zY2RkOEVSV2wyWmNn?=
 =?utf-8?B?eFF3eVlaZFJqS05qUHlTdnlTbE5kVVB3M3hSOW4xeWJaRkVDd20vakpiWDNF?=
 =?utf-8?B?UnNSbytqZ040dVl2eUpHSVRqNmQ2blEwR0RxSTBBZEtjVytEYmZKTkR5MFpo?=
 =?utf-8?B?bHBjVStaenc3blJhNlpqUnhLWkxudDNLajV4ZktYVUJiMmRSQW5WcytuODV2?=
 =?utf-8?B?SThNUTFXd0R6R3BCSHk0VjdxUFZDc3k3YzV1UDl0bEgvWGlIUlFyaFJYR0dD?=
 =?utf-8?B?TWpzeGVnbktnbzJiOWlxTThPbk5BV2JOQ3BrRVY4cVRwTDVLTldzSEt0QURP?=
 =?utf-8?B?WU41OXpSblplbzNQTXV6aVVKeU5UWWJ6K0lYYWxZa0ZteWIzcTc4ZWsySnZC?=
 =?utf-8?B?eHVhekN4U1BCSXViS3hvcmRzcXBmSkJzQnI5c1FTWE9SNFF5SFZ4cXB0ZWl1?=
 =?utf-8?B?MjRQTTFOSVlSOXRxN3FQb3QrYmI0UDJ4Qm43Q0diK0pKMjJSR2RCK0tUWmpm?=
 =?utf-8?B?TnNDZ2prMmdLeCtaM2o4NUFtRkJncFpwcHJCQ0ErSm1qbTUrMDgxUXVxMzBM?=
 =?utf-8?B?aEtCd2NxZTA5dVFPRWtXNGdlSnhtYU5CSDlQckh6dXIvaTFFcjNPVU9PMnhS?=
 =?utf-8?B?Q0ZocFhBWDQyckR6TDFMMitsZXR0QXlwb0RVdEFCZ1cvQWtNQ1BwK1dMTmNl?=
 =?utf-8?B?N2ZYM09mZVN6cko3MDVvcFV4R01xWkxpODlrSzB4eERlb2FkbzZFTjNqMVpl?=
 =?utf-8?B?VHExNUFDWnBzdk5nVDllSWN2RDlEN0RaakEvME9kTHRwcmEzaDU4bjBxd2U0?=
 =?utf-8?B?ajdSV0RnQ2dvaGlCYmhTdmgvSVhBSnBheHlOcElnN3pLbWpkMlQ0cFVHRldt?=
 =?utf-8?B?U05XVS83OG84bVZJeE52K0hUc2JyTE51ZlJ6TFIrU2liYUJLelNDR1FKQ296?=
 =?utf-8?B?d21Pb2ZnVmxqZHRzWlNZbXozNDNkaC81ajJQdWpjQWsyZWYrYzk3RUpFbHhx?=
 =?utf-8?B?bENiSkZkdmJQRUF3WHM3RnA4Z0VGQ0V4dXlzSjhCUXdLUWVmcUNqVVJUWmRG?=
 =?utf-8?B?ZlorYk9wdFEzUytKQTZmSCswMWFaaVlab09nNjd4Skt2RnAxMWpuMGFlM2V0?=
 =?utf-8?B?eU1ETWdrMDM1NU1jQ0JXeEhNOEorRVpLVDJPYkwxSThSY1pndTZpOHp5cDVy?=
 =?utf-8?B?NEROZGs5dXlTcTRKeFFiaXJBUFhKWGlzT2trVy9BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0573bd73-bc24-4842-5342-08db25895d3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 19:13:30.7817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lOzV3y2+m5Y+S7u7lITqnpszrqBSuDObr9oFiziAInbKlJ6lizB8eIf6+zV+HTP1VYkvbTx+x9pBzBlGvWyUx09Y8sBzmbv9s4cpozZrSIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_10,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=810 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150161
X-Proofpoint-ORIG-GUID: Y3rqPg9PhECjJJc-8SWIXIv_Iss7lbGc
X-Proofpoint-GUID: Y3rqPg9PhECjJJc-8SWIXIv_Iss7lbGc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YWNjZXNzIG5ldGxpbmtfc29jayBvdXRzaWRlIG9mIGFmX25ldGxpbmssIG9yIGF0IGxlYXN0IEkg
ZG8gbm90IHNlZSBhbnkgY3VycmVudCBhY2Nlc3MgdG8gaXQsIGFuZCBmdW5jdGlvbnMgbGlrZSBu
bGtfc2sgYXJlIHN0YXRpYy4gQWxzbywgaWYgd2UgYWRkIGFuIGFsbG9jYXRpb24gZnVuY3Rpb24s
IHdlIHdvbuKAmXQga25vdyB0aGUgZmlyc3QgdGltZSB0aGUgY2xpZW50IHNlbmRzIGl04oCZcyBk
YXRhICh3ZSBuZWVkIHRvIGtub3cg4oCcaW5pdGlhbOKAnSBpbiB0aGUgcGF0Y2hlcyksIHNvIHdl
IHdpbGwgbmVlZCB0byBhZGQgYSBuZXcgZmllbGQgaW4gdGhlIHNvY2tldCB0byBpbmRpY2F0ZSBm
aXJzdCBhY2Nlc3Mgb3IgYWRkIGEgbG90IG1vcmUgaW5mcmFzdHJ1Y3R1cmUgaW4gY25fcHJvYyB0
byBzdG9yZSBlYWNoIGNsaWVudOKAmXMgaW5mb3JtYXRpb24uDQoNCkFOSkFMST4gTXkgbWlzdGFr
ZSBhYm92ZSAtIEkgZ3Vlc3Mgd2UgY291bGQgc3RvcmUgaXQgYXMgYSBuZXcgc3ViLWZpZWxkIGlu
IHRoZSBuZXcgbmV0bGlua19zb2NrIHN0cnVjdHVyZS4=
