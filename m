Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7386A5AD0
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjB1O3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1O3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:29:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F0FF760
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 06:29:12 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SEKCd2010574;
        Tue, 28 Feb 2023 14:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EeeDHrz7fxFDYqCyLTqEgNDDdaTlfWEMfM9gsr0D3pE=;
 b=efn2hCneNySI9DYR+m4k0hpcc5/m5znwbqdCcgjkEheWVOE5+jhOZuBtNGMMVUFUZsHV
 5pCs8fKE0jmUJ+s8jr6ayHOvPpSpOIC+rORl/t9yuKQ4VK1PQfyCP9CxbeFzvwHwl4XU
 JjSUagaVLq5bTgueLVv9ElEYdi9eIyVPGMMtusmoS0kBC/U1b0IqbNdLKfM+nMtCA2sI
 IwVK0p5tqaMDvlwKjWnFeEJFtXx0VyElU/aufOX2JXfB1iNX2GrHXTTXGfX8LTlK4WYr
 6TSjjq7XNVmgi9QVkXTNDXDSWxCdeX7vmyGRIdclPVWMwm7ROfd6hsQ+6LF9wY+ex8Yg dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb6eecd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 14:28:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31SDkqqB013035;
        Tue, 28 Feb 2023 14:28:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s6uscx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 14:28:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0dT4N66ZzdsUgb1tDnWMyJqZMlC/vtzTeQwAc0Fpwmw55Q80fljbGCd5GLVJZaC+c34gwNV82t9nF0ExiYe5xkoyFFmmVvrk8oj5Lv/sic4QJnKeNqDLWETYciddTHqcUkHM/ai/MHhLoTgbuQ8fjwqNBvKz24M5XRRqXjRjEa6+0i+7oBkeeR4Uy/9EkJ/sqqxHwxoSdCbFmiR7bvzo5V+i3x1XNhkZpbArIPF8BJq9zkBlhxEUwQCw1gcFzA3HBiSqvrUZ4M5aLclRqhfqW5g6tZUobWKAWobhfzchWf4mR+mnDs9b8be+zv6sawmsu3WOBeHfFMcxhxv6sZofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeeDHrz7fxFDYqCyLTqEgNDDdaTlfWEMfM9gsr0D3pE=;
 b=OMSrHv5Z2CUln+atltx5w/TvVIP5RSeMlF2v/W3eKLtvk3iDCx0jLF8eU4yl6WYznwyHIrS/PoD8TbBrJunIBS/caO3SlhDThS6mrqqxrd8zA+zIz0MYX4CAS4NCAJPcVEinAGxlXL/G4v7yTFDBJcOSgVoj1pOabgVNcr6PmcRtOB8+kVnDWE6IziC9Y8BDTy+RS/Fklc9dp0I5dLjLCYAFbOUjdUnoAx6BbzXhbmfdPcgcr3DjMHjXcC6QmvcYlkVhB8pQzpW4fOwhXkcIbFt0L9G9d4cGLcEQbZn9594mQ9TUF/kEBdW82zaqHVZ6FF45UXbP5t9N31NBDIg/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeeDHrz7fxFDYqCyLTqEgNDDdaTlfWEMfM9gsr0D3pE=;
 b=SCkFzW0ELwm0TeVXwg03Bu/6sU+BGLZFTAFmm5EzU2S+Ulhk6gdOxmWqLDVYKb4a+QOoen4YrJTNVKegOiTJMos8IIpK4jg2fcjzQi7OFzYigRlezSLRvpkXAmCSgSM0Wts1zL+7gK728X4DDA8K6gauiWz9GHSrEUbhttOanGs=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6060.namprd10.prod.outlook.com (2603:10b6:510:1fc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Tue, 28 Feb
 2023 14:28:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6156.017; Tue, 28 Feb 2023
 14:28:51 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZSITpzXcU72XpWUqa2tRUnzVdcK7iiYuAgABdpYCAAARFAIAABu2AgAAcTACAAA3tAIAA1mqAgAB95AA=
Date:   Tue, 28 Feb 2023 14:28:50 +0000
Message-ID: <D06D70DC-D053-4212-B72C-82C1BB1AF9F2@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
 <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
 <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
 <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
 <b9c3e5aa-c7e1-08dd-8a1b-00035f046071@suse.de>
In-Reply-To: <b9c3e5aa-c7e1-08dd-8a1b-00035f046071@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB6060:EE_
x-ms-office365-filtering-correlation-id: 0100ce30-3e70-44ec-7147-08db19981c9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xEyThpOxEtnEzQ4uTNxoZ2FPzwsSyiA9u2HhxkYfqCc8qQul+COg3psZzTOhfyFOmFGCqfxYMkmdGZfi2E02ejJgOReXHCyPxMjGrFEjMmDfE8FpbCt+CEpmK6t16/flIgz0oJrzafMnIN2WVzvfIPlQW2NgIH9lJiPFQLnpxz+7iPWMG7D+ZWqpEZ5lRzbw0fj5V2OFPLejdvzRBYkFwsOkXgFGczVmuIxyU+QWMlGzdRqqZLUeNO7wLC9Fvb3u1phguJ9seZbE0MjaCcyBl+gOeHNWbEChwjB46c5VN8Mmg/yCzeiED9kmJQ8oYQdBKrYRecy/WLPs3j7oHOc7atvah7do91vxGdjzac3xlrLqIVuKiwz0Ujv7yA4XbQqvYDC0Pe1oemtGDZwYTedtbKAZABv0kacHGUkHcpZ3f2+p4nxk50x/j9x8qfbym/VQVOzFlXqskWEiKl6NQzW2Wi+/CSWdQ7AKiQ5VUtEvSKvLDT9fNGzX90PdP+HgeRXm6ZCV0R+mL/qumKYyQAoFsgzgxhGYXmnHbWYj0XygMb1eKS5LykWR3z9oQnFBB1XuQ/5XWduwcHzxoKkti93eXsBUEiFRMnKWWVJoqUdSYkaGKPwjxlCsJ3VwfcSn6xhKGXh1pH7+WfqzysG2LQACtrYXhiplTubU8yfuQWn0oqnsKPaLLmrxIw1CCzklg6yipO3kW+H2gjE9MuE5Qq/V1pFvC8qd/D6NQv8vHDdEaf4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199018)(66899018)(33656002)(86362001)(36756003)(66946007)(66556008)(66476007)(66446008)(64756008)(41300700001)(8676002)(5660300002)(8936002)(6916009)(4326008)(2906002)(122000001)(38100700002)(38070700005)(71200400001)(6486002)(478600001)(54906003)(91956017)(316002)(76116006)(83380400001)(186003)(2616005)(26005)(53546011)(6512007)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?clOJmXv43+rvzbs4Hn7D8Lkq1fiiS3TFnH52AF0QnsX8PlGcsgXv7w+1RXs2?=
 =?us-ascii?Q?WCRcwDM1CBuOfWMsBissiDiTLYCO+OHWeNArUYKFNhxPUhrX92isvW1JxLir?=
 =?us-ascii?Q?CSu5zmD9E/VEf4oJQpk5TwdVwU3Mt1IKAWLhxMUFWpuAKMZyJKmddfYLG4kG?=
 =?us-ascii?Q?+CIo+mVtTvJhy2IqZ/uQaChWlQ031ZpujPrCyg8+yQIvgJeBpZ4/92Y5SM8G?=
 =?us-ascii?Q?hgLDO/82eIpfiScvBc3T64NWdrYMJYJ1PeWV0ld0KoUzW1x+PsFYnp/EO6wr?=
 =?us-ascii?Q?8mU0D8svn92PODHoo6xIQg4mpNiTlHbfCET2WzWipy09Fb2xy/nvOCc5vdBI?=
 =?us-ascii?Q?/qtYZPuy+hkR6YutMVddEel8O2r5erAI5LB19uf15LP6QF0IlH5QZSrD1WGm?=
 =?us-ascii?Q?7L+ysMQvItBE/VMo10CCVJ6COfGFgxIN7k4T7cqxlpDDgUdzU3+oEelTxoHG?=
 =?us-ascii?Q?Uyjrv4EJmsLwvmR010bzGCdR0nHcq8Rkf5Oglmv6IBujn88k7j9/3l4+KcSB?=
 =?us-ascii?Q?LKeAugwaamgHmPxZ9YoPRREDjSgLnkePY+mM+wwZ/ZAipDEcl8ypuxn41654?=
 =?us-ascii?Q?b8M8XgFchDJbK0RYW8Qc/IDoIU1WeCxQid0xIrKO1UrmxMKBumAzmFHhyM3m?=
 =?us-ascii?Q?fTE+NxBg5P2VHkVG/dhQIUMIBbqgWQbSerUUJSe7VHFVcTX2VM5rqm/WTela?=
 =?us-ascii?Q?95qqJ83qEn8KxpW8TdARF24fYLdpZBHjsKEnxU4F+5maKHfwixXpraS8x3e0?=
 =?us-ascii?Q?giFcny8CNiso7e8EyLieUHC0KUgQffvilsl9Uop883HTfvIMTQGRK8lBeflK?=
 =?us-ascii?Q?wFsRjTwwU2fYI3304qkM9hb7Pux0n4+uBZsMs8rxGs4DY/i8iFtWrfEZ8Qgy?=
 =?us-ascii?Q?jnyZHN33xrh9N5pAM1eWnZaQjmV74hp2p/7NAmvorfElcK+H3GSEFdK0/KnD?=
 =?us-ascii?Q?tZFLLa+6/8o5lhZxJfJ9vVDLfaHf5ZphvDQJz7AQVP4ITfAr2UvFe/y/UCkn?=
 =?us-ascii?Q?EbBlVWrRfL1mwtWYqBehq7E0zRT/FtGd4gs8Qvr42QDrG6wTZsKrqdlHQyOc?=
 =?us-ascii?Q?57mcNsB3jJsE7Af3VctixsOcdlzCvJbN9OWogOaikq+oMFkfJlr2IFInsJFC?=
 =?us-ascii?Q?PG+C1A4N/5nFQHTrlZKf9YQzqDNAlhwPmWKjeDqYCmJDnkKFuKZMQUVLvtPX?=
 =?us-ascii?Q?FYVGOHSeUQA6MKJVL/10qs7GiafKOszFuKDnE49qrcaAttCngY8jSfiFGpbV?=
 =?us-ascii?Q?ERyskmoEOkUwQRgkB9hJCoNZ0JRpOBgarjsxuOrxCormgiscxdaBN3XY9Qtu?=
 =?us-ascii?Q?WhojmO763IUGvk9oThRSP5mV9BaDfGjlAwAc94qZ121O7chI/aCtFqCnAIWz?=
 =?us-ascii?Q?ia2wd0QXrP3UwKd0QHTuPid30uz4lNVHDu3mIyCKLFrEk1fb65yhHs2oU80u?=
 =?us-ascii?Q?zEP0VLX41XfX56RkAMUtktZUZyy3W6V6SXqxNI3mXTUUs9ntXUx0sLfOwKko?=
 =?us-ascii?Q?gEg2dq2MlmMsJj9znd/VA5jXm0X1f5Bfv03THq73jAcM8bjaZ5qtrjPwPbyF?=
 =?us-ascii?Q?ZQBI8/sdRE8HtaOSp/STQ6cd9V5gTa/Ah4UO7JqeC0AoCvwKDPmlPEQEx2yU?=
 =?us-ascii?Q?sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <00E04256EA253A42A71B3951EFE7DCB5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KJzUTQg89L5+II5qWGdLZZuVkgqz6CttQYUL6cvFdp1BU3ZdsOhcOx62W7m1TOpOIIz1OwQPWuzYyWlcS+bwBZi2xz+7n86So615YFCUyex5fTiF1nELk9p9A9abUTtTQ4xAOGwednbZ4oQ/TLbWRtT4k18lT8TrtUTnVnjXBD6ynpdQIUZgR5fXOMR3coPf48JpaAR9DAwk4ehv8P/Enj/gRjyz2VlimyRdHeCxWUnl630ISQawJhNS33Ul1pK12nU6ASTuhbwV2dacrr31G0a06dz2FICa+0xJ7fRIxtlHi/SaI3eX03/ae5PsKSWVIhvOU10wSp4QZMOctDF+DgjMRkeDlXqPZ7uUkw79twuWI6A3WnQhEaYRI2wBnjH/E8cOP+R9l6vURhGMvOTHY/jylw0DxwOuCyy0HUSfCdUXWbgYst5S4oAm0AHGwii+/a59rqrCuSdtMuU2kNqfOhM3HSmSA41VD3mSFkMxKuMqpqvsoaeUx1pO3sGTmplApxzCSSG+FlRjDrH+xNdcIA+Lai/YzopE1wk64B02DxMYUMhURcmSTjGrG4aQIEo714BkXopvxfJVWkYj2ecLmliW3E1Of1kOOY5dogH+H03ENI9JXVIOLw65fWM/ZIudEtUDueTfz7gc4FpcFZl2re7T1q+T328BJCCBRuTl8TYWvLi6+fM5zTDR5oC5PcftIHVDZbuvQY5nVjaDwjnIkdvUnUy1Imjx+PnpRPVB1QXjhy5hOLvq6oyI2/9SH6DZoCH0DhgkCng0pH6BTTAaeKiqbSQJF3Yt4BiwA9K+nrJotXJBZB6A/VN00XvvBo7EwLYK/tJ5YqHkI1RzWp3kPxR94BOp7kJDJ70d6Fsf/Jpk4UDFFItB5xE34pKcoSg2Nplh5krfqLlMd0llsPWBtqyheCwy9ghgNhyknHlD7IM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0100ce30-3e70-44ec-7147-08db19981c9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 14:28:50.8260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mTLrYedTWDSOXRW7ptvIEseDLi3Yj35oed2S3UxYlWb/jnsSqIxSliDg3S4dwczAHqlMIQNotmVQtW8GtXwsuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6060
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_11,2023-02-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=720 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280118
X-Proofpoint-ORIG-GUID: GblxHl5VtbcIGRZcGWnHHPXyqDkJDI12
X-Proofpoint-GUID: GblxHl5VtbcIGRZcGWnHHPXyqDkJDI12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 28, 2023, at 1:58 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/27/23 19:10, Chuck Lever III wrote:
>>> On Feb 27, 2023, at 12:21 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>=20
>>>> On 2/27/23 16:39, Chuck Lever III wrote:
>>>>> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>>=20
>>>>> Problem here is with using different key materials.
>>>>> As the current handshake can only deal with one key at a time
>>>>> the only chance we have for several possible keys is to retry
>>>>> the handshake with the next key.
>>>>> But out of necessity we have to use the _same_ connection
>>>>> (as tlshd doesn't control the socket). So we cannot close
>>>>> the socket, and hence we can't notify userspace to give up the handsh=
ake attempt.
>>>>> Being able to send a signal would be simple; sending SIGHUP to usersp=
ace, and wait for the 'done' call.
>>>>> If it doesn't come we can terminate all attempts.
>>>>> But if we get the 'done' call we know it's safe to start with the nex=
t attempt.
>>>> We solve this problem by enabling the kernel to provide all those
>>>> materials to tlshd in one go.
>>> Ah. Right, that would work, too; provide all possible keys to the
>>> 'accept' call and let the userspace agent figure out what to do with
>>> them. That makes life certainly easier for the kernel side.
>>>=20
>>>> I don't think there's a "retry" situation here. Once the handshake
>>>> has failed, the client peer has to know to try again. That would
>>>> mean retrying would have to be part of the upper layer protocol.
>>>> Does an NVMe initiator know it has to drive another handshake if
>>>> the first one fails, or does it rely on the handshake itself to
>>>> try all available identities?
>>>> We don't have a choice but to provide all the keys at once and
>>>> let the handshake negotiation deal with it.
>>>> I'm working on DONE passing multiple remote peer IDs back to the
>>>> kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
>>>> the other way.
>>> Nope. That's not required.
>>> DONE can only ever have one peer id (TLS 1.3 specifies that the client
>>> sends a list of identities, the server picks one, and sends that one ba=
ck
>>> to the client). So for DONE we will only ever have 1 peer ID.
>>> If we allow for several peer IDs to be present in the client ACCEPT mes=
sage
>>> then we'd need to include the resulting peer ID in the client DONE, too=
;
>>> otherwise we'll need it for the server DONE only.
>>>=20
>>> So all in all I think we should be going with the multiple IDs in the
>>> ACCEPT call (ie move the key id from being part of the message into an
>>> attribute), and have a peer id present in the DONE all for both version=
s,
>>> server and client.
>> To summarize:
>> ---
>> The ACCEPT request (from tlshd) would have just the handler class
>> "Which handler is responding". The kernel uses that to find a
>> handshake request waiting for that type of handler. In our case,
>> "tlshd".
>> The ACCEPT response (from the kernel) would have the socket fd,
>> the handshake parameters, and zero or more peer ID key serial
>> numbers. (Today, just zero or one peer IDs).
>> > There is also an errno status in the ACCEPT response, which
>> the kernel can use to indicate things like "no requests in that
>> class were found" or that the request was otherwise improperly
>> formed.
>> ---
>> The DONE request (from tlshd) would have the socket fd (and
>> implicitly, the handler's PID), the session status, and zero
>> or one remote peer ID key serial numbers.
>> > The DONE response (from the kernel) is an ACK. (Today it's
>> more than that, but that's broken and will be removed).
>> ---
>> For the DONE request, the session status is one of:
>> 0: session established -- see @peerid for authentication status
>> EIO: local error
>> EACCES: handshake rejected
>> For server handshake completion:
>> @peerid contains the remote peer ID if the session was
>> authenticated, or TLS_NO_PEERID if the session was not
>> authenticated.
>> status =3D=3D EACCES if authentication material was present from
>> both peers but verification failed.
>> For client handshake completion:
>> @peerid contains the remote peer ID if authentication was
>> requested and the session was authenticated
>> status =3D=3D EACCES if authentication was requested and the
>> session was not authenticated, or if verification failed.
>> (Maybe client could work like the server side, and the
>> kernel consumer would need to figure out if it cares
>> whether there was authentication).
> Yes, that would be my preference. Always return @peerid
> for DONE if the TLS session was established.

You mean if the TLS session was authenticated. The server
won't receive a remote peer identity if the client peer
doesn't authenticate.


> We might also consider returning @peerid with EACCESS
> to indicate the offending ID.

I'll look into that.


>> Is that adequate?
> Yes, it is.

What about the narrow set of DONE status values? You've
recently wanted to add ENOMEM, ENOKEY, and EINVAL to
this set. My experience is that these status values are
nearly always obscured before they can get back to the
requesting user.

Can the kernel make use of ENOMEM, for example? It might
be able to retry, I suppose... retrying is not sensible
for the server side.


> So the only bone of contention is the timeout; as we won't
> be implementing signals I still think that we should have
> a 'timeout' attribute. And if only to feed the TLS timeout
> parameter for gnutls ...

I'm still not seeing the case for making it an individual
parameter for each handshake request. Maybe a config
parameter, if a short timeout is actually needed... even
then, maybe a built-in timeout is preferable to yet another
tuning knob that can be abused.

I'd like to see some testing results to determine that a
short timeout is the only way to handle corner cases.


--
Chuck Lever



