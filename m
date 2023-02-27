Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D2A6A4634
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjB0PkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjB0PkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:40:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FB1DD
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:39:59 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31REgBbK022950;
        Mon, 27 Feb 2023 15:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2takCXuHktlpUTAxTDHJEJWl1WmtjGZ9kwgW5DHsuRE=;
 b=I5i6Z6s3KM83iqwomyfjpdGRfVkiBNaiWMrjAQaG4B4xr4g4X0JBLNXI9l6LoQ7QHtwk
 /lEi/7t7yMci/DEJmRPhc11F4Vfqh16G3wxI6RforZU9fqSb6KrQqieGMvtsCB53awJf
 lUGj4Rpxpo7S5nKP+swZIQHq2B+a62SFqE57ILfnuVSx3GuTKZ5Hss0TnSeLOxbUDLs5
 N2tKlA9a2mZBxH2dZMdVsNX0J8p8UKZ6ay0Nqr5MqX53oou0g1oIzKqdCO6cn329Ufxz
 Xkd/ZaPeXIC4uPtA62M2ZZD33Uw+xxGLY/3iPVXhVy1Tjao8ajv21XNR/XGBcBsucmKf QA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb6ebw25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 15:39:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31RFQJCZ032294;
        Mon, 27 Feb 2023 15:39:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sc75t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 15:39:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdNAgGWvGB2emvgFhzIpICS5WY0QNCtU6C7b+mNiLSLcjlotEKT/IDLmSuLh+1nkyTGK5682WGCYmdzYUPcL8paQMU3imxEWYaGlwNwSMMu12XieKaNhxhPuUlIi0YU/KmySc31R4G+WCmpvQ8oErl6+aV3BEvmEUQ+wTtuuaRH4/XscjplNNMrTDUA7uXglLVwmaZjGEDaWuBElNskKM2pqRkbWra8Btk+iAjxFOJgBJgAX/JauWF8HBcFNvqiPe1zQNarHk7BmpyIftXhguK1aDvli964vfR4SEsjS5t1qSF4OKVjf0nyL/ifh6FqU3wnRSbdoGhuB/GYj9HCeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2takCXuHktlpUTAxTDHJEJWl1WmtjGZ9kwgW5DHsuRE=;
 b=PefgAsDSqHg/tUZ7DqRgWHeAKq+bhA9XXWhf0FAGHVPOjrpI6d8bl5kHZzCvqxTp2r48Nrk2icPO1oV3m+c/xQTnbHLaaLuYo2ExB+T1p50nJnfaFizOZ5y1jILKVqdhvtj5XOG30mV/7mS0CwFuz0GdiCdMphozvmi3XnftxDJtmhFgarMl9WWvvxZcYLUALXCCj/xOlpojwNlbDAgTaJnU9XGjCD1J//jqG/yuTrYZFkl3P4VmH9n1HBGEqPZvjhAY40z+NtvgLDGK4xMpRFI0kvzZmuHbich1g9dvPjz+dp6gaafWOba9LRNvjlx91Ihtsll4S7gUrzB1mM2OAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2takCXuHktlpUTAxTDHJEJWl1WmtjGZ9kwgW5DHsuRE=;
 b=TsMn72sw9nRh2azIwOkPMM82VUiXDm9wf8jl5cGe2ZAEyQtEgchQGYP1CociMQJbtpbgBEQEuUevghsZTlTlqGNbwTyX1NIBuqNzqpUfshsZ2PbM8Vk/3XCC8lgDQ0Z8s+JQVOcQjiizvQ6/5NoA5iqYQefADD/0MIajL9aX+uk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.16; Mon, 27 Feb
 2023 15:39:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6156.016; Mon, 27 Feb 2023
 15:39:44 +0000
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
Thread-Index: AQHZSITpzXcU72XpWUqa2tRUnzVdcK7iiYuAgABdpYCAAARFAIAABu2A
Date:   Mon, 27 Feb 2023 15:39:44 +0000
Message-ID: <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
In-Reply-To: <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM6PR10MB4186:EE_
x-ms-office365-filtering-correlation-id: 93182805-09f5-4a96-8536-08db18d8d963
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H3uk/GV5n2JY4TdXDX+wQuZrrMZL88dn1E+VViJ3VZSo+PNHkVAsTVfv5iQoiXob6mbm8ZehmKr/9XC4lNMCvyhyaQu98ZOK3JuhGv0DAPr6Bqu6iSRnLW7QAhzasMS1Nh7cRMUOg4OobXIWNwTb4c7joxPg6JIdRNloh0WXDBRCs0UC8DMvbdtY9m16ohul82HZ2fSrkNOmV3sir/D6htiK+yhkbV1Z7YBPs3TlznLL5TioZ4Q6qXXuBM7zqkp71dp9QrDPnRF9Qoeh+fiepwNrgkOrduXksuJDU20ix2HO+IeLjAv+ZmSQJaa9kh+lefWricbnoGoCQXniqWrNgqLrs3F7ee8hqqdBl10rKfBSY+ne1atFt2W0PJmJ16GH8q1o460hxN7jzuKrNPh6GT5xJUaqqjFBGIp2yI61rVksdhcluCNW/wT1uN4qG74rJALWMZWAIS80UFm9WDx+9IfRGdlciooWmlYcf69/HSBmrGDca5QciI5k/rZotIkqpEwbnDBuHQpvCMtoecBKVs7A3lyhWRd9TwpGbekpXFn4fodm6fwVHgfyawF3f3SoxG2JDK6y2YShQUGd2+HUUFBlfXUGvklDXGjpRSx8n6/5ZOgMfV7bDR2bYKPPVAopEdFAvctNELu0EyPkJETi5UmfVQ+uLNNE8KDRRgXM4TNZFiNlWe1LtWZEAHmVvatqZJnTupPLwUFD33hTEVpKnAY7RaN1FrsKnDb5m6qiB6qajgUh8Aqi5TW6YXrKay4/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199018)(66899018)(122000001)(316002)(2906002)(36756003)(5660300002)(33656002)(8936002)(86362001)(6506007)(6512007)(76116006)(66946007)(38100700002)(71200400001)(8676002)(186003)(91956017)(26005)(66446008)(4326008)(64756008)(6916009)(66556008)(38070700005)(54906003)(66476007)(53546011)(41300700001)(2616005)(83380400001)(478600001)(6486002)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pg4eVRy0B53tIhMhPWKgB9D8E9Bw+ICnsTFzIxdIOBQSWbtOzENubl9Tr22S?=
 =?us-ascii?Q?FjgfFKx2i1j01taDwrRZkFags3nWx1E95Q/hjj5pWxnK0jCZ+D3ZYRNnI6AM?=
 =?us-ascii?Q?6OLlWcI+x8wo698LAckOHFBXcIOA3pxxyn4lL+pdJBzKEJSKLnN3gMMuEpBJ?=
 =?us-ascii?Q?U0mnYUWV2E4D0AUl+rEI5WxFruH30QF/Ymvp/aT3aAY1VBXh6tZSlYMr36ih?=
 =?us-ascii?Q?XxeL3xiY3BNXDomWdRPSouptTkNhTx3eOBceBcxRx65o1lCqNJioAN8/muns?=
 =?us-ascii?Q?C9XzAOTmmIRvDvU3XFZtziHIX++NWtob47yqfHBrTrt495Ph/oTFS/+b7CQ5?=
 =?us-ascii?Q?SJoRszz1zgjN6/zG2Sk0o0yCp5scuBuplmtEA8I/D1DMTB2L+x9MVRKXgaCw?=
 =?us-ascii?Q?BAnUQ56CP0Nz4strqGg5LAVpHjaqaVmEQuzZ9oGRag15QVStXe7vxcUsEqcu?=
 =?us-ascii?Q?+Sw/6KwEYjY/okFtmFtu0Xdx72SEyPFlKohl9UDs0FG6OV6qW0hPKQjhDpzK?=
 =?us-ascii?Q?uKwBqQYvU5/B/uggMEWDv1SM51Bz1xiqeorMxvKZ1P7SA5p1yVlyCcW31xuG?=
 =?us-ascii?Q?3iwreoHku6qF4yN7vfHJsSywOW0oEAOV00dKTqiMXjkY8u6l4GCCM5yguLfU?=
 =?us-ascii?Q?rnNAWxwT6IYJwabaW+KBViDHhn3CpEG7pHdwsEylnxRqEQbHnPVJRw1/NIHF?=
 =?us-ascii?Q?YUbctPQH9urJq8Rur9EAZTUUVTZ/QdjvQjDP2wThnwURK/BarRLWJOkvlpSX?=
 =?us-ascii?Q?qHSvmTgmM3a0pSpGhAFq+n15LF9sp9OLnyMvAwXJ8eQJQM44rbGiiiYO1TYT?=
 =?us-ascii?Q?C/RiPK6TDcNedoJMQwNrU/i0xl1AaqYCMCE+Pf2X3dQHstKHwTCyPq70pB0d?=
 =?us-ascii?Q?CpZa/zX1r/v9726/2nAARFn+juGO8JcXHMWGi/TdCUgxUsDoGzto11K4criJ?=
 =?us-ascii?Q?EeLafQEmQJhs5gw++Jbp4A93o+8mrSIbXZd3aCX/DVIorm/OrYIrIQ6sHNec?=
 =?us-ascii?Q?BUZWVNvbfIxWGaJjRYVMLPxsw0LzJQxrDLJ6q+1qHRcpeQgZpnzrJsEwgshe?=
 =?us-ascii?Q?RDbTOHpLqLkSjkYPLvaRspjtGgcb7+3hwM7WCn/1eJGJuOupxMhyUH7NCEdL?=
 =?us-ascii?Q?4NruJlUN3uIhHebvvDxHSIwEWeSkGSlVZ5eNukP6OC0oDsaHJjHzKwYeKnUl?=
 =?us-ascii?Q?k67yEuJryex35U1RlUaXyJy3Nz1iCT1IXgxg6d/sSD+0LK4U/bUk7FYFO+q2?=
 =?us-ascii?Q?GEDjd7mCLwzFmCxT311xHQRXKo1T3bOYox5kwmQTYuhRi2bth5tf9o6kmlzN?=
 =?us-ascii?Q?mUkpR33qk+0Tdm+805BKqdilpJAHryveV4zwJepJt6CNQjzSbBlOqlSNqkkf?=
 =?us-ascii?Q?ubqfePNiMRQfXjpQLqeDC9S0NN8rnv0KW0jWY7MgQpn7MJILnpkrIlZjv5ba?=
 =?us-ascii?Q?9ertslSUWTRZt+beLQGB8jAEAma2ec/iky7pSUNYVCPizNxcltihx6GVS3QR?=
 =?us-ascii?Q?o677KRn0EmFZsxsaKSMdn7twZLc0z+qHFsobWCGcXOGb0NO6WP6LhhwXQIq8?=
 =?us-ascii?Q?DKG5d5zW2m6TecDD7oEtXzKQQfoFKGGJ7gF/su9g9C+ioD8GCESWGLLBUpEA?=
 =?us-ascii?Q?UQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <934D0BD720F1764FBB6162C3A29A9805@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hBispyjcmat0rhpTqqeXpHqC0aJuyVn/ePGaqqOpXUIEYZVB+2hVEL5jFySG0NdToMiJJ6NsBN3mBkclANYWalqUpTsIsiXDYdvQUX+h8/wX7UqpcECWjsIfXzgrGlCLAyw34oBmZ5dXFgedVPBTgvPe8fKuZWNLsavlOwkTMHAQ6LNzDpyK7YyTW7DIkMccqcsbI5potU6lU9TzVFHHvJGi3xCNoiDK0pkfVW9naUTdN262XM7Mwxm90SRgOxBNUjWg3NWFc72EkjCeGyHTINtRx/y+0+vHSJHd7NMnAAmwbEI96v3ygR/wRCwvPr7V5gs/Vjp74fmE9qvX0oavDg9t8MvaFNXz1wDLoGSJuJRsEN2tGhtSYIi0HtzGeFIHtI9E2XwHIwPzv4sfiyh1/LAvauDacnT0GYSd7OQ39yE1ehupdDZ47qDczs2rp+g6Us547lbmovKbq3GMC5wykoOPqYDpOJXNcJRn3LjTQgOxwfdV1gxXWsZBJAI/PrjPbP0uNhHKBN1yo5VqlyeUrp4p628Wc/vJ6AZrEbdnndRxGvNoRcDuatx0ANEyd0kDQ73X2AGowiiDNv2N6yW1oE1zB9pNnqUv00wSRbByxkG4KYkFOLEsXKXaY/Rl0nOd2lFwmZD3lHdgWgYMSy/RQyaEQjJ9r5xJDTRpfN8z0Rg0leTL0/SQuEqvnF2hHawJj/iO/Skl9jlcyTuFiu/p1DMv0OI2X95/k+VrZ2LOxeeqZBn1l1VS3qhhoJBrnjgOJoORwyKTg76vBP5P+qWBrR6FDbU2+NGWYY/hMHml8FlvuugZigBHQjIzEHTQ9aeu8R2RBRbyXqFyz4sAZ4L11NCL7MJzxKOHMg3+TypAsT+SwtrqKodXSGuCYmbf0q+l10lcPZBuBcftP+TROWVuBZpwMfdT8Az6Klsm/TE36sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93182805-09f5-4a96-8536-08db18d8d963
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 15:39:44.1925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4f6WJbM9vn2a8mcVRm4HFtE6KAF4pJx5IJRz2g6D6v6Oh82srLy8bzapLLRITtoflH6Aug7RufPckJV97dSvCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_12,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270120
X-Proofpoint-ORIG-GUID: A0V7NZM0h5egLGjRzgViGtkU1Ug5QR-J
X-Proofpoint-GUID: A0V7NZM0h5egLGjRzgViGtkU1Ug5QR-J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/27/23 15:59, Chuck Lever III wrote:
>>> On Feb 27, 2023, at 4:24 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>=20
>>> On 2/24/23 20:19, Chuck Lever wrote:
> [ .. ]
>>>> +	req =3D sock->sk->sk_handshake_req;
>>>> +	if (!req) {
>>>> +		err =3D -EBUSY;
>>>> +		goto out_status;
>>>> +	}
>>>> +
>>>> +	trace_handshake_cmd_done(net, req, sock, fd);
>>>> +
>>>> +	status =3D -EIO;
>>>> +	if (tb[HANDSHAKE_A_DONE_STATUS])
>>>> +		status =3D nla_get_u32(tb[HANDSHAKE_A_DONE_STATUS]);
>>>> +
>>> And this makes me ever so slightly uneasy.
>>>=20
>>> As 'status' is a netlink attribute it's inevitably defined as 'unsigned=
'.
>>> Yet we assume that 'status' is a negative number, leaving us _technical=
ly_ in unchartered territory.
>> Ah, that's an oversight.
>>> And that is notwithstanding the problem that we haven't even defined _w=
hat_ should be in the status attribute.
>> It's now an errno value.
>>> Reading the code I assume that it's either '0' for success or a negativ=
e number (ie the error code) on failure.
>>> Which implicitely means that we _never_ set a positive number here.
>>> So what would we lose if we declare 'status' to carry the _positive_ er=
ror number instead?
>>> It would bring us in-line with the actual netlink attribute definition,=
 we wouldn't need
>>> to worry about possible integer overflows, yadda yadda...
>>>=20
>>> Hmm?
>> It can also be argued that errnos in user space are positive-valued,
>> therefore, this user space visible protocol should use a positive
>> errno.
> Thanks.
>=20
> [ .. ]
>>>> +
>>>> +/**
>>>> + * handshake_req_cancel - consumer API to cancel an in-progress hands=
hake
>>>> + * @sock: socket on which there is an ongoing handshake
>>>> + *
>>>> + * XXX: Perhaps killing the user space agent might also be necessary?
>>>=20
>>> I thought we had agreed that we would be sending a signal to the usersp=
ace process?
>> We had discussed killing the handler, but I don't think it's necessary.
>> I'd rather not do something that drastic unless we have no other choice.
>> So far my testing hasn't shown a need for killing the child process.
>> I'm also concerned that the kernel could reuse the handler's process ID.
>> handshake_req_cancel would kill something that is not a handshake agent.
> Hmm? If that were the case, wouldn't we be sending the netlink message to=
 the
> wrong process, to?

Notifications go to anyone who is listening for handshake requests
and contain nothing but the handler class number. "Who is to respond
to this notification". It is up to those processes to send an ACCEPT
to the kernel, and then later a DONE.

So... listeners have to register to get notifications, and the
registration goes away as soon as the netlink socket is closed. That
is what the long-lived parent tlshd process does.

After notification, the handshake is driven entirely by the handshake
agent (the tlshd child process). The kernel is not otherwise sending
unsolicited netlink messages to anyone.

If you're concerned about the response messages that the kernel
sends back to the handshake agent... any new process would have to
have a netlink socket open, resolved to the HANDSHAKE family, and
it would have to recognize the message sequence ID in the response
message. Very very unlikely that all that would happen.


> And in the absence of any timeout handler: what do we do if userspace is =
stuck / doesn't make forward progress?
> At one point TCP will timeout, and the client will close the connection.
> Leaving us with (potentially) broken / stuck processes. Sure we would nee=
d to initiate some cleanup here, no?

I'm not sure. Test and see.

In my experience, one peer or the other closes the socket, and the
other follows suit. The handshake agent hits an error when it tries
to use the socket, and exits.


>>> Ideally we would be sending a SIGHUP, wait for some time on the userspa=
ce
>>> process to respond with a 'done' message, and send a 'KILL' signal if w=
e
>>> haven't received one.
>>>=20
>>> Obs: Sending a KILL signal would imply that userspace is able to cope w=
ith
>>> children dying. Which pretty much excludes pthreads, I would think.
>>>=20
>>> Guess I'll have to consult Stevens :-)
>> Basically what cancel does is atomically disarm the "done" callback.
>> The socket belongs to the kernel, so it will live until the kernel is
>> good and through with it.
> Oh, the socket does. But the process handling the socket is not.
> So even if we close the socket from the kernel there's no guarantee that =
userspace will react to it.

If the kernel finishes first (ie, cancels and closes the socket,
as it is supposed to) the user space endpoint is dead. I don't
think it matters what the handshake agent does at that point,
although if this happens frequently, it might amount to a
resource leak.


> Problem here is with using different key materials.
> As the current handshake can only deal with one key at a time the only ch=
ance we have for several possible keys is to retry the handshake with the n=
ext key.
> But out of necessity we have to use the _same_ connection (as tlshd doesn=
't control the socket). So we cannot close the socket, and hence we can't n=
otify userspace to give up the handshake attempt.
> Being able to send a signal would be simple; sending SIGHUP to userspace,=
 and wait for the 'done' call.
> If it doesn't come we can terminate all attempts.
> But if we get the 'done' call we know it's safe to start with the next at=
tempt.

We solve this problem by enabling the kernel to provide all those
materials to tlshd in one go.

I don't think there's a "retry" situation here. Once the handshake
has failed, the client peer has to know to try again. That would
mean retrying would have to be part of the upper layer protocol.
Does an NVMe initiator know it has to drive another handshake if
the first one fails, or does it rely on the handshake itself to
try all available identities?

We don't have a choice but to provide all the keys at once and
let the handshake negotiation deal with it.

I'm working on DONE passing multiple remote peer IDs back to the
kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
the other way.

Note that currently the handshake upcall mechanism supports only
one handshake per socket lifetime, as the handshake_req is
released by the socket's sk_destruct callback.


>>>> + *
>>>> + * Request cancellation races with request completion. To determine
>>>> + * who won, callers examine the return value from this function.
>>>> + *
>>>> + * Return values:
>>>> + *   %0 - Uncompleted handshake request was canceled or not found
>>>> + *   %-EBUSY - Handshake request already completed
>>>=20
>>> EBUSY? Wouldn't be EAGAIN more approriate?
>> I don't think EAGAIN would be appropriate at all. The situation
>> is that the handshake completed, so there's no need to call cancel
>> again. It's synonym, EWOULDBLOCK, is also not a good semantic fit.
>>> After all, the request is everything _but_ busy...
>> I'm open to suggestion.
>> One option is to use a boolean return value instead of an errno.
> Yeah, that's probably better.
>=20
> BTW: thanks for the tracepoints!
>=20
> Cheers,
>=20
> Hannes
>=20

--
Chuck Lever



