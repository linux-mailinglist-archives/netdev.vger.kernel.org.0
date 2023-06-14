Return-Path: <netdev+bounces-10801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E22373059E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D581C20A94
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426AC2EC19;
	Wed, 14 Jun 2023 17:01:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279807F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:01:40 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39E72103;
	Wed, 14 Jun 2023 10:01:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EDDr8O011722;
	Wed, 14 Jun 2023 17:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8rWBijZ0YfUnIkE9UpVbz4QPnBwk32EauWUtwXGQKyE=;
 b=p6y3RftcRCJJjdrgwPlIC54/mxg1kii9Dq1vK59721BvoHiAWFuUoB5kyIsLz0TmoS+/
 U64wWylZMDOdAERhMttnJmNhEUUPBp9sC/eBVuWWnV3lPEwUIvkozEaWsOovztNOXkBE
 n+PYQ4FO8rsUfayU02aApAVUFz/z05Dkihm+nJf9R1jM6vr9eOiYwZPOFNECS4GaJDz5
 H/0zKmYIGh0qj8hmkfFrDBLU9c0AGRpbSTc13dl7ty07pqaNewNWLjZoOvqi3GD1U76S
 Bsc8HNkqGFmjrVzYWib0TcwEvrDnCWRI2HZ9GD7LyduRtWko/33d6TFVV7mes53ua7ph uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu01c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 17:01:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35EGj5Hw008972;
	Wed, 14 Jun 2023 17:01:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6456u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jun 2023 17:01:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6kt4sXxe8V66XP3g74SbbHRTunCuzn287YtRyhOBqgpzoqUMcGyImjw/074W0URmWxzTff0o0w0JlBHtj7sf880ADuWxmY63KuVHAXP2BLRa7FblaknLsnYFcMbNZwYme6XRjg3mUu7FpatPszhgiX7gDB/e1Xr01G8JMk3uhwKhZPzD6VAG4Zfl0wBfWdpkGd4vyBgCkP7yTy+aXIeJ3KaNb0iEoq0LovUPfgSloSwis7j5ldmUChqIHbZ+/lFelA7ftaICFAvx80cmu+YKvm6l21bP5zeht41P5QLsWnP5NxL+gpnURduW2VzW7FhV2le2+JrDhbpT6ce5rwMgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rWBijZ0YfUnIkE9UpVbz4QPnBwk32EauWUtwXGQKyE=;
 b=SxG0zi0oUyIDkYerkxil0J9yGV1ASenZORqIUgkZyO9crAgTA35ET3KVBu2xAzSu0z6yLfb3pY5V0Leq7DigEXwywVRX7YkamPGmNwm0WF9RvEC4JBh7+kbhMoSbpCdwv2Xv8G4fhr2aq5EIf/cPq7oyvP+rhxDpDsJ+aLkOhvsR39a8qlKZOEkyOTRWFnMtySbI3QzFZmGy3gqswUaiYaQH45S3dXJ8cdv/DJ1+ej07FbzKKGIs1iCtrWbvbIiRQJ1DGYAZGBcaqyrHHdVZn+qSPpCxXPHQF+rdH2/MrkwV+lp+BT7Wcosn+4pkRCPgob9byHzBlNxaGMUIYMJ3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rWBijZ0YfUnIkE9UpVbz4QPnBwk32EauWUtwXGQKyE=;
 b=rulhA1TB7wMYlWBdEWc9P56/CBkrctYksAA6b3LesfpTKO1IcvjLlVeYYlFc5vAbDiQxzpZiJX+MaWexkoYUJ/Jq9Qm2SB5CfTXFvGBFDgA8wEr0YP9FwQrsr8xvhSHpGOYsDBl4bmjifYvaVJ0KvnJzKSOqmHiGldWH/KSroCw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB4826.namprd10.prod.outlook.com (2603:10b6:610:c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.31; Wed, 14 Jun
 2023 17:01:19 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ae00:3b69:f703:7be3]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ae00:3b69:f703:7be3%4]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 17:01:18 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
CC: Jeff Layton <jlayton@kernel.org>, Kees Cook <keescook@chromium.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Neil
 Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>,
        Dai Ngo
	<dai.ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Linux NFS Mailing List
	<linux-nfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond
 Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker
	<anna@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] SUNRPC: Use sysfs_emit in place of strlcpy/sprintf
Thread-Topic: [PATCH v3] SUNRPC: Use sysfs_emit in place of strlcpy/sprintf
Thread-Index: AQHZnsV+Hr4hGxE/6E2Ku0WJzu4eU6+KhhOA
Date: Wed, 14 Jun 2023 17:01:18 +0000
Message-ID: <9208246C-491E-4DA8-9EB3-76F4216B4D4F@oracle.com>
References: <20230614133757.2106902-1-azeemshaikh38@gmail.com>
In-Reply-To: <20230614133757.2106902-1-azeemshaikh38@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB4826:EE_
x-ms-office365-filtering-correlation-id: 4ab11826-cf56-4186-1a06-08db6cf8f8c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 fb2m0DwEPMk98P3Uylkp5QLiwG0oc7CR1wMUMPoDjtEggXxIFjZ0Dm0jkHfk4sO11bVLGbOcgos0sy2atlxYm3izkhQG+4zXnQ8h84X8JVa4IEjT2oJiBQmnPhcwrRn+FAQCpFeZhc2jd60TO3nrprKj2hkJBw06KeaDQ/CKxLPHLMZyLmnuWpTMc9nKiep7luIn1fnI6zwpp8OwDRJ95wTSED6MvFUlxgWLrCmZ/G3uqXon9wEynZjwWeWekLQDNPJr4QWnt7doQ2LpS0KNNBJF80LhFojBeWFPbGi1vt5Hxz3Vu5/w+pHCcMyrqhuhrR1GVDkqbv//943L9CY7mT2bXOYFq8ZsPiCAtMekmlFjwDx7qu8Y26p7ekv8J2KS7wyhrWKaLGaZGMYVjeZmSDwB34najSFO5ayZhaKA4WbBsXOo3NRFAXS9ZEIXYkb0ttyBceZQCZaMLaoqM/nU+kvs9HDQodgXdnIMmLTZ0ooYxaBZ+ISc5EDBmbsVVzajyq4ulPeHdGLeQHVc1EcUg1n6OBKM/zpWbWVCpO0TyX4UWHelqw3kIHzx/i6XZCtvzEUQwdD0SPOT1rbtU+wh7r5Z9JIdcGyKh9UFH+5tjivdC45tf9fqR4xg/o8Ghnd/
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(6486002)(966005)(36756003)(83380400001)(86362001)(38100700002)(2616005)(38070700005)(122000001)(6512007)(33656002)(53546011)(6506007)(26005)(186003)(2906002)(54906003)(66556008)(478600001)(66446008)(316002)(6916009)(66476007)(64756008)(4326008)(91956017)(76116006)(41300700001)(7416002)(5660300002)(71200400001)(8936002)(8676002)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?bN8jHjOdP+uST+aWvmTIld2yyb+ox3ftk//88GkcO3AOwOHLAuMR5helDho6?=
 =?us-ascii?Q?t64fMt9JASOUrwNqchtvi5fFmKaLps9XnwK165Ake+3YCgikYth1V2Gtj3T4?=
 =?us-ascii?Q?p27ts4KR1K6dm2KTGTGf3+wZLOEdLjsq1aDqI2wdwolRW3eO2ghOBxpGPund?=
 =?us-ascii?Q?APwwNP8MzwZ8iHcfLjM4XY7Q0iBt3JXptHOS/2pA0J7y8HTa/Q+AEiVHbuvu?=
 =?us-ascii?Q?Lz+an49sNXY8q4uo6xXE/DA1jmLjqzUyDtKEdrxUNvXcF2tkkkWYoKBBohKW?=
 =?us-ascii?Q?F1lHrgshcjI6YPRtzgShOSbb3chKcjjhGq01cBBL+1FBO/UipfFQu6LMCWyi?=
 =?us-ascii?Q?pl0kO0JhxxIiAqGE2Bp0ERtdR1xjsBroUZ9d//igkl3dElyL17nDDjt7bHA6?=
 =?us-ascii?Q?XUvdj4HQG1ZoSHuvPIAq6kmfxcyNy4xsAKNsbkCJvAzRukw5y045sfxiWKqj?=
 =?us-ascii?Q?XizNLq3fFrEtVCVD94OhPzsqJGXar3uQc+VzdPEZ+AzU+KMQcVHOMBiCFCgX?=
 =?us-ascii?Q?cHzGvVbuXdCSoBtxltAWhvYaIpw7tgvJflqSIiF2NfDwlgBocUjjwGzDFGOm?=
 =?us-ascii?Q?lVAoHEKSat1YHSECS2JxtrqZiY9wG/EJAlXoAN1fM2dHcd+JZ5nwC/Y8WRft?=
 =?us-ascii?Q?BICxZRTugWP4zLtYfEBVJPeMzfUjj+ZZN6kmjH48bsWm0DXckrrdHU5rCMQS?=
 =?us-ascii?Q?ERbuf+lLm1eznc/GWZnuP5sGG+pYHWAkIEbuorVSiZjMhifv8+Ij78TOmbXT?=
 =?us-ascii?Q?JMBn8A3NCwg1FScuBVvPzN7AqgdONayBehgRSLs3Qu7SNOxICHQaOF7cgOP1?=
 =?us-ascii?Q?SVBwW07ieYQsfA/26dHc6rCE1hJHIiO96b1BV2lK8V1Vl+Q2qza7jQTMEshz?=
 =?us-ascii?Q?zPSLwkAmhpdeYetgv/lqUetnsbXo5Sl8csoCHyqyptb0+gqYnFY5VLDO9xxv?=
 =?us-ascii?Q?RMI5HOZaKqwGTxMKA7GLnwyk2bumL57cKFYw1oEIfV0N55oFKqF943RzZ9kF?=
 =?us-ascii?Q?ehJ/uJb50OZ7b8GX8zO2oGkpX9JmUc7gqvuo+e9ADM5FaRQNAgY6o/c+zbuI?=
 =?us-ascii?Q?a4sUTAAJsd5spEEdZ4Io+viUrgiZw6NOOyXiGpmpWKyStGJVMMdNWEpEqdp/?=
 =?us-ascii?Q?jJKT2/SGhXEm4CmX3GBC3D8+BPT+PqQvghz3Go9kfs49h5AfjU/n+sscoyIc?=
 =?us-ascii?Q?aMz1+d+k3qRYTWcPuK793HYvbkOzWkoARUBJYznWDSqwHtG25ej+apsbU+0k?=
 =?us-ascii?Q?BHuwHpzWJ2Qg7w0Z9FgjvJjQb0ZonPRcBvRUB6OD4UucDnbt0XCzmqpgYHCE?=
 =?us-ascii?Q?nRM+S9Lf9XzyGDwh6te/4xTiaeAKqdD4lOQRLpDQm5zAmLVlqijmBTDPv+Hw?=
 =?us-ascii?Q?xe2mpLj2mgqBjcW8rc4pkvmdDKu/TMQ0CZ7kZmMeNFKykMALlDxI54E6NDMV?=
 =?us-ascii?Q?06lqiH2UxmQ4poz45s8TM9UJz3ANt67VSyNYeaBpzAuhkgoUinoknJXiEqQq?=
 =?us-ascii?Q?ujM2EQqxeX0WCRCZay6LOJ6PKpO5BORFeiybN17Uk7hulTmAaIzEkLvENVUg?=
 =?us-ascii?Q?D767ABrrmRGpe9LGmktu7339e7GX1z8iN/WOFzJrgyS12IyvKlJxH4XPSeJZ?=
 =?us-ascii?Q?cA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF7F7B47BE15164EB0C65E462560F5F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?570j/8IAdhf48mIUaFUsosQacf0w3RwPzdn9CsGIoxhpgqguA/AOi2cQOjuT?=
 =?us-ascii?Q?V1JIqdVzzgB7w+NBTx2kIIyFVWG8USQ0PSVExKrC3EY8NX46bJ7DXQqcQD8R?=
 =?us-ascii?Q?ASw7MrudVRnc52qCd901uHeuhp0V4fqmz9vW5s0g+vTcgBaDKcAW65nnDwzc?=
 =?us-ascii?Q?Q1cs4PzNSlGH6nuyFn92H13DQ8ePTyziACb22Ktu+jCwTjuGiXOezfHY+wAE?=
 =?us-ascii?Q?0XtVYhRLQmtaTVN7/02jZGfd4TGst0tpgpyJYnhf7+Sz6gNpvQqWEu0Fg/d1?=
 =?us-ascii?Q?w86Sq+q/hQyqPtt79jt+/0wSY3hDFXg+XM6w4xZUIebhyZcLqseiU4TpOEZ/?=
 =?us-ascii?Q?+iV6uoG/fpzexi1O/6jyQ21H+mfo85+QC0R4JtVb9vD9pSKGaFe4luwKyewU?=
 =?us-ascii?Q?+vJ9TGBopnhkyXcg83OBHmQ+5TvhuktYRj4Lm+BW4GUqZBM4kA+jyJxat1Pn?=
 =?us-ascii?Q?acCRC+LK9+59bW5QGqtewDtZOix4ncvCazHp5F+CQg5x5/VCO2Hmox8GL5YT?=
 =?us-ascii?Q?4MKSOKTx7Dg/RojRta1qNcaixiYvPbJe2B3M3AY60+IXYbtggSEC3CGnZkgF?=
 =?us-ascii?Q?OC3KUN6hC+bPhD3XD17UEnnr9+2I6UcoYRkdjW6Qxl45KUg3KNLn8QiiNBwL?=
 =?us-ascii?Q?Ms5kWQNu9fUgAxWP2/8+C1BBYCxQRGS48JCrrX6zIq6IWvjBjLkrhWVQSBUA?=
 =?us-ascii?Q?8dK6M9aua23/eEzn22eGrOMn34XjMJ+xk4FfRRgfPNq7Xr7kFXDvRS+4LeHn?=
 =?us-ascii?Q?B77udWfUPapmu3orDaORlS7PXFI2sIpIRPWjq4qNCCS1IrwR5+IM76gBBb2q?=
 =?us-ascii?Q?hd+zQTbYz4F56BHmyGUpm4apnazJm2+JpevoRfEjv2LZ+HzaGVHtWqT5wyAs?=
 =?us-ascii?Q?/n5pfUbJ5Mw2Hj20XbhkEm+1saljwiK3EfyNHYhPm8QD13/fn0OfBYtnhuVr?=
 =?us-ascii?Q?tm7CzxhI1/gbpGC1kuvneW0NogKApkITiiwenz82IhbEFmzh6u64Xbjv4K/p?=
 =?us-ascii?Q?KvcIft/bjxnFaJsm7KjGjcGWVFXll7FRKAOm4VIH4ER3JykDszMW70iVTxOk?=
 =?us-ascii?Q?KUiXGMWI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab11826-cf56-4186-1a06-08db6cf8f8c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 17:01:18.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0K1kynkQ87pokqWDgcn0cQY4x/EAdvTEhXCxCOU87TurWujpJnRcjiriLKYJ3SxB73ZOowbZcz+/9+crbAaJ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_12,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140148
X-Proofpoint-GUID: xSelXHgKBQFuTmSHp34qD6KtZ1LTslQ7
X-Proofpoint-ORIG-GUID: xSelXHgKBQFuTmSHp34qD6KtZ1LTslQ7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 14, 2023, at 9:37 AM, Azeem Shaikh <azeemshaikh38@gmail.com> wrote=
:
>=20
> Part of an effort to remove strlcpy() tree-wide [1].
>=20
> Direct replacement is safe here since the getter in kernel_params_ops
> handles -errno return [2].
>=20
> [1] https://github.com/KSPP/linux/issues/89
> [2] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/module=
param.h#L52
>=20
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Thank you! Applied to nfsd-next.


> ---
> net/sunrpc/svc.c |   10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index e6d4cec61e47..b011c318fef1 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -109,15 +109,15 @@ param_get_pool_mode(char *buf, const struct kernel_=
param *kp)
> switch (*ip)
> {
> case SVC_POOL_AUTO:
> - return strlcpy(buf, "auto\n", 20);
> + return sysfs_emit(buf, "auto\n");
> case SVC_POOL_GLOBAL:
> - return strlcpy(buf, "global\n", 20);
> + return sysfs_emit(buf, "global\n");
> case SVC_POOL_PERCPU:
> - return strlcpy(buf, "percpu\n", 20);
> + return sysfs_emit(buf, "percpu\n");
> case SVC_POOL_PERNODE:
> - return strlcpy(buf, "pernode\n", 20);
> + return sysfs_emit(buf, "pernode\n");
> default:
> - return sprintf(buf, "%d\n", *ip);
> + return sysfs_emit(buf, "%d\n", *ip);
> }
> }
>=20
> --=20
> 2.41.0.162.gfafddb0af9-goog
>=20
>=20

--
Chuck Lever



