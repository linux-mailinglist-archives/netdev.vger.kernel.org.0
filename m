Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984EB683145
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjAaPUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjAaPU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:20:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB2C48A19
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:18:21 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEDjE6029925;
        Tue, 31 Jan 2023 15:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gtNhcLHxMsgXtz1keHsD73hyHshzyzyIzBhGMeuJPug=;
 b=JmuakqKILue09pofTgxSTN1H6HH/NApBHrXZjBdcV7G0N9BjUZCprZlsHnd5HQTYLKbB
 HyHjAsX0gnE8ueBlgLrtjsZDVpadMTFKZ0x2TcCjLaXlPi2Q7DaQ8yu3J+B1UolMGbKz
 fwGAp7ma7z5iMq0cGexIhav8wZAl7hwNFPx0sbc+8l8U/i7H/xvCGOsGJOzAYtOH69hY
 ZDmGMy6QoHUvbYmxNzb7S23W92Cw9gNzP9T6ei68mkun7A9w/9z/NhGIjhW1BLYfTieS
 8Al+aFuBWSz+uVLMC8ILXXaCYenadPLJdtmuAZ5JJYMia8HyilD+NVBiEhW6+lVvV2K9 Fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwwuwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 15:18:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VEw95f005176;
        Tue, 31 Jan 2023 15:18:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5625rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 15:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrwBYjjlrR8AT2M6iiJICoSkKyl3UgKh00SsiMlfDY+EznPuqulo7KgUVabQERLN/HGL3qnIfRwBvxvkhhd0ANooiX22mQaA6Y/M0VqLlSIFprFPELd0AF4idTFWIEu8wW0y7g+QwOGuNfgwunpgUzr4rRJPsJp2h3fP6sOrRQIXBS2mbjd1AWYGLopVDZUpp3OzGcOgF6zGgoR2HZ6DXq3JrkBrwF3L/uSPGZcE9NKrM2YaOzF8Tg9pWm7a8Gb0o0kE5SP97lqFmEzcif6uz60yCt7eOxD74u1a2IIGT6yiqV+2hniA8yJzV2hGxqLrqaMx32CLP7IoO35s3CKoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtNhcLHxMsgXtz1keHsD73hyHshzyzyIzBhGMeuJPug=;
 b=oJk4O5T+W1wMzhCFYD3+isAZM/kmiZNz785SAgNxiqQ0xDe6vWmowUfJS4qMkjAbkQ2k5R0UET7HNDdGCffhkRBBRVy1HGGvWUi4/ZuF0WXFFbc0d8Uen+BeI46YrHu+ZRlBObyv6ZNKUxY4HPyv6AEvVBPFwhcS9aWB4bZHGof1jHpoLmgW0bKQNTPNUoar/0dTIfZcvQa8wv7JT8tLW1wlXRXIcu3purI+fyFK87ukhmJx54yxhnVmFudehrCo9MpzaoSw5En1KR09cYPNRu3WOy9AW9f0le+lAZqC7RjLA0f9ihgbAGq1/jyTM5H84wB2kwQYv3IDsYdSHi3Tiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtNhcLHxMsgXtz1keHsD73hyHshzyzyIzBhGMeuJPug=;
 b=rboItb3oehMAnT0AhrWK+gzoUKniDn8rQDGneGAbalKgGeT1Bf0DyvOOMfUuQMkyEQjEG2Az4Mib21uPEOBhGkSG6PQ/KG8N+kQG1+00Hp7pxidRqMl01jrvJ9ogWJNyLl89MVxJ0Jbm+xC0KmUTl3xJSr3olroDsbvWLsSutSM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MW4PR10MB5839.namprd10.prod.outlook.com (2603:10b6:303:18f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 15:18:02 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%5]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 15:18:02 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Topic: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Index: AQHZMvMNX3GnD3At1ECXj8a1a7fZTa6z3aCAgAQXWgCAALOJgA==
Date:   Tue, 31 Jan 2023 15:18:02 +0000
Message-ID: <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
 <20230130203526.52738cba@kernel.org>
In-Reply-To: <20230130203526.52738cba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MW4PR10MB5839:EE_
x-ms-office365-filtering-correlation-id: 4bf7d305-d174-4627-4215-08db039e5854
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByHb947KWCh7RD2pNjUeJeA05RudcWCa07qx9w2CjsIU4RQXSv1KvjMac3U5P0Aa7E+b0stEKTNhsNHPAVAgPcEI/JiBMFozwHlbwI5OQmLs0AbrMwUbjkFjd/jsMX5Pwy8/Bhlxfoazs5pnbj3YKjGCNOJ73tHhyh9I5VB5iz5njmb0J3EUe/pE/VY8g4Qm/W/xHZB/ocGqvdL6yb9pPpaEAefm5wDLaNGDz2+AbEHy41+dYazvR26xNudPIlqfcTzFgVvjoy2msVbZM7p/AuyVnHAXYqmXQ9uVr2NMvlUIVWqLLGT8inoIPnHScRJv57SOn9MGJqbcRhol+gT9z7nHSUMKgzPgeQzd2J9aueGoJwRCfMf5g46wbxNydjUMylNGVGGj6edQ2kFWsb/BVAIp6GTLzwmGQHRGoNolyql8dHZpi1qfYZcZV0V+cn4GC+RPbeHgzhWufZpydi/HGHM/ZB15P0qtTX80AwG+1ioYMRvwCBLITGU8kl5H8hThwYV6CTpsdy3q5bFXt0dsG0uYwgRyCVOc0Rfj4aTR5vCNw9Tkl4uiqyQVOb2jGwk3bR0MDqteAEysHF6+kiL8NVmHIW86pv2AuEekBHLWlAZ37SOATQy5rbmtOGw6/3aKv6HLCqzf1bFLN4aea0vQLzdsAS3jn5bpNOQSQ1FjdEZVLgK3X++GwNva8h1JTMhrk+V0BiuFYmZca7+6LuxJx/h0j5ulVAgsTWlCAqDi/cs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199018)(2906002)(36756003)(33656002)(2616005)(316002)(54906003)(83380400001)(71200400001)(6486002)(6512007)(26005)(186003)(478600001)(6506007)(66556008)(53546011)(66946007)(4326008)(91956017)(66476007)(76116006)(64756008)(66446008)(6916009)(38070700005)(5660300002)(8936002)(41300700001)(86362001)(8676002)(38100700002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O2T3WxZ4HHRQp3pBr9dXxp9YmFhWG+/vGCM6OMhgZ18njeukEwuBCfmIE59r?=
 =?us-ascii?Q?t6f4XTT/d7RgQjoQxHPydYruHzv7+eIn2tsaPMRepYcqop+BYvY4fRjSU7+/?=
 =?us-ascii?Q?l5Z3MUT8SZiBAMGeARMaY+VRmk0W86FuI2QD19FCvk071AmEWMzfj4dly2h6?=
 =?us-ascii?Q?rXdDEwWzjJXYku5WAikU0BIUOF+hz79dFeu4V5Y+XflBRZthhixnWxVQ1juB?=
 =?us-ascii?Q?U1Mm6jCPC+kFUAZ14bwTm43QwVUdCKwGo1mMCu2yOfm/+AD+7rbBRoDFbLy7?=
 =?us-ascii?Q?yDsRgfjcthYLz5JTQAdK0qeT8z4aoVsUIkCxZDGyww6oK0vnJenl3PB8wOpn?=
 =?us-ascii?Q?LT9/f9w8+6JWdhGEPaheN7djgHO1DNkShBUsBiJsoz/FgVE6jxsJsw6VELG9?=
 =?us-ascii?Q?VDUXw7tLIc78HVOlbqSYmkiKbXUs/C+CnYERTSJluIRL/FnD866H9M+rgqiq?=
 =?us-ascii?Q?OEaRkXOs4q4R/vYmiOEaWXIMOI7Db/Qw1DM4afJqaa2ixLAXgYV3Q57D1pO+?=
 =?us-ascii?Q?D/jzA/kMqKxiZwDc59ReP2ZiPm2+RjMHre18FBRgMjp//B1bkX+ZW+7kRsQy?=
 =?us-ascii?Q?xEo0Uiz3Jnj6Y44WQQDaFTUPStRotQ3SbrkZVxgYuAjN5WUwTmtn4QF2ZkFG?=
 =?us-ascii?Q?xp9eQCRpZYUfXxjFnRFxeOwW2I17YpUlOEcUICZ+bet11wOcIWWHZPbCYF/L?=
 =?us-ascii?Q?anRbimoTLPJ/U1qabAUjA3nq9qCakGuCIrMlcB2Ra1YD4huR4IRTz2CvCYxZ?=
 =?us-ascii?Q?4nJOtZorxVq9vfSYyTb+w09jMDcLMDpL+C0mF4SuMDRh+7+LX6m8WA9Iq64S?=
 =?us-ascii?Q?3Kcm0DEyYU+kwecC0DuQlumQCSEQWdiWzre4lNGNXtbMARX7xoEyFxhtFBNf?=
 =?us-ascii?Q?9Z+4PdylH+lpvIjDzprWpKiy07/x6UsTQGlQcZrIzb9ngso/kXRlzhCdhJJH?=
 =?us-ascii?Q?zRdBGxhWcLLrw+aaoLukbd226dMcwoRmnu+aejIZ30w33S9g6iX4++Ae019+?=
 =?us-ascii?Q?a9x00olRYuakp47Yxzvz8xJYOqQejhLn0jl1xVVuupX8YJLkDVngrnh9IW2A?=
 =?us-ascii?Q?UjgLo+W1rxlqiXTxG6VPH+QvXpq+CwHEY9uqNQl82oUI5oS0TLZ5Qnvk2AUH?=
 =?us-ascii?Q?E2zmcfOZHFZ9T2nsu0Z+YBZO8ZYqBVvGEXW/6sdKJdEUHdv4RkVuhqLV9Fz0?=
 =?us-ascii?Q?ZiuGC2jBH4YqPapqvQPg5Xqa20O8PBFenxmv8HzXA+f2Pv7ooCg8tPBoICpy?=
 =?us-ascii?Q?3LwaDNYMssN4KVCkunXeN1QrOo0oGNlpv7nxTEFYkkyPsWEA5OH0CyjIth1a?=
 =?us-ascii?Q?kKDcdCZcD8f71XaKOXYly/+lwCMKl74AYd/8dPaFscj53LyeV6GI0RCV35Lj?=
 =?us-ascii?Q?RqkLOnFjHSryyrUFHSPZSWREzECFj7YpCbEA2FubPKzL1IVt6tbzUJqsCqGD?=
 =?us-ascii?Q?zyJT9QY2RPddGFsZmslkw/Ire1Y7Bnms1fbt1ud+m9FvoHE9y5UHqR7DtS7A?=
 =?us-ascii?Q?ZH+pWasrtROoiN3R54Hr6tWCpKmZlXdfD+QhqSDNB7FPv6Duy6nZDqBicfxE?=
 =?us-ascii?Q?Dypg6u9+8aCibNOGOjMkJHB3kQxkGNJfSWPLW0IeYOPVmTT/3Dfqkd3WLswG?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7BB7A20E8DEC5142AB1D98CEBE8DB078@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TvIPryHY2ipEu1hRsMQPLoHGzPxcYBai3XK3StfCplvY06owaz+eKr+Kpu6RgGoilIM2F+2G8rqtfxLBV2Lyw+rt6hLGVtrfX+Vb1erwrF7py49jkGbRRBErOMgzXcpL29OIrX5L6+x4GY/JUgao0V6p6S62CVMWvP2Pj24lJCOg6M1Qh967ii2WAuk6ujWT/uIdwxJ34zPRpN4QdiB35YtssM4Lhc4R34bkStguc/v9vwyPbQYbxc0Mbfhrjk7rD89ShdA/U0IPk27ljIz/W6bH784Xv6fV4ElHwXJvRUhFq3TQddo1F5S/6GXjDtkJqqEKu/jKiFcx5o3MVqLwVUV0HsgcGsgGodMr0xtUInqQln5ZhOzAFfMf7casCxsZsGnZCzO4Ga6ynVxe7vnWTbI5ttZgJmKxRJIf1wOebAZwGpjiPLmzEjH5wNAx1BKi3Cs16ez3OtvX9LHU1vTkcsJnR8YxbVN8FhnKQzLh1hC3UbvtaR0IRfaxOp7SejkEcMUNYuw1jMgbag4G3HmAL9jRXIbBYoyAAcoxq3EsniJO/AHqaiOae6WxVKb/YfIiPHhwyh9dNIo5+QPlqwW14LUTx297so8A204ir46AMHdrbq6SOMSjJDMT2x+kyuHtRgwq8kS6A0sqbZVXYkuaAKs3f3E6MpGqgG5BB8BNLJXOLir7Oc5pctdegPYU3sUSjFTL3fxFhJ2V8+86cvoSB20ATymimnetHVWUGExqBvkDwrhlZ7jr6MAULJALBGyihovSN5Ek1Y+oFRCeO9ZkaK6GfaAF+jsl9NMCJ+qcSNFz2wBV0gAx21QnDtTg+6ut4Ft+dMIRw0ckNEEFgmpmgGJ3cu666M5kUNPhYoqT6GOJp98SedWGhkEuyl6rjFDK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf7d305-d174-4627-4215-08db039e5854
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 15:18:02.4065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qsSKmhKzBKV/wkQuseAMQVchTCzaM1gVV1jWuLQ2dp6hdcDlxNyK9Yb3o2qxvlAfh9viVs2ro/sY/l+w4lkbWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310136
X-Proofpoint-ORIG-GUID: hlIaJNQEO_drYk4sZwnBXJcXCrQtNpKv
X-Proofpoint-GUID: hlIaJNQEO_drYk4sZwnBXJcXCrQtNpKv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 30, 2023, at 11:35 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 28 Jan 2023 14:06:49 +0000 Chuck Lever III wrote:
>>> On Jan 28, 2023, at 3:32 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote: =20
>>>> I've designed a way to pass a connected kernel socket endpoint to
>>>> user space using the traditional listen/accept mechanism. accept(2)
>>>> gives us a well-worn building block that can materialize a connected
>>>> socket endpoint as a file descriptor in a specific user space
>>>> process. Like any open socket descriptor, the accepted FD can then
>>>> be passed to a library such as GnuTLS to perform a TLS handshake. =20
>>>=20
>>> I can't bring myself to like the new socket family layer. =20
>>=20
>> poll/listen/accept is the simplest and most natural way of
>> materializing a socket endpoint in a process that I can think
>> of. It's a well-understood building block. What specifically
>> is troubling you about it?
>=20
> poll/listen/accept yes, but that's not the entire socket interface.=20
> Our overall experience with the TCP ULPs is rather painful, proxying
> all the other callbacks here may add another dimension.

> Also I have a fear (perhaps unjustified) of reusing constructs which are
> cornerstones of the networking stack and treating them as abstractions.

OK, then I take this as a NAK for listen/poll/accept in
any form. I need some finality here because we need to
move forward.


>>> I'd like a second opinion on that, if anyone within netdev
>>> is willing to share.. =20
>>=20
>> Hopefully that opinion comes with an alternative way of getting
>> a connected kernel socket endpoint up to user space without
>> race issues.
>=20
> If the user application decides the fd, wouldn't that solve the problem
> in netlink?

David or Hannes will have to answer that because they
understand the races better than I do.

However, I will prototype "fd passing" with netlink and
ignore the races for now, just to get something to
continue the conversation.


>  kernel                          user space
>=20
>   notification     ---------->
> (new connection awaits)
>=20
>                    <----------
>                                  request (target fd=3D100)
>=20
>                    ---------->
>   reply
> (fd 100 is installed;
>  extra params)

What type of notification do you prefer for this? You've
said in the past that RT signals are not appropriate. It
would be easy for user space to simply wait on nlm_recvmsg()
but I worry that netlink is not a reliable message service.

And, do you have a preferred mechanism or code sample for
installing a socket descriptor?=20


--
Chuck Lever



