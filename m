Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86DE6920A2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjBJORp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBJORn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:17:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C216302A1
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:17:42 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AAoOFn029066;
        Fri, 10 Feb 2023 14:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=IN2ci3rKn0RFobEOFeqCzVuuvHy3HCP4Eocb7fn4/F0=;
 b=0fz3oPAnf8C6lyVRAmy6ROp2DIr+xhFyDlUCPT5CMqHN8id38k+XrWhd5EUd7Al8k4i0
 8M8iRk7wJ/VCSXjiIuShNtFB+vtSuhZqz7wF0qJTIkeM+0JJATK7jQatAyuhdjmISajA
 R/HTM0brUBxFNTbuA87i9RG4+mm3hUF9gsp268gZIblCohGS+FjUpF60ERgRG8cbB/mX
 VeROmqcmYR13CqGleXgv6MGFhSbpU8pZZ/xsw99Qv/AJIUfpYSYDmvt5poqDe6ttltM+
 yNPFke6Gte1zrXphJb0dmJuohWCgOOKYophPL9Hoom/5bEw6cnmhBvpzUqntL6FAjuTc kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nnbbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:17:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31ADSUOk003179;
        Fri, 10 Feb 2023 14:17:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtat8ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:17:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ts9YmtdV7/xghfjI+fNDvTEMbQgnuzo/ZeD299yWTxX6HFb1pxWXj5wCebfq/pW8gXRmLXABCBA0vEFEPizN3QSVlKgt0/3JhoHyzYV1vtusIokvRke49iKMB/LCj/MO6qdeaXMkT2P23bZojGlHpdCCJQg1euI8PcRk/70Vw7HL0Xn5mhtz4Xkj9AI8bZLSSVysH6F7FqCIZWtQP6wINaRQpDQh3kEtmHP3i4ubfx91VjwUX0MgLUaoqLuwo7Ku12doEfO1XjLLLjeHgXVMxajn+n1yrUkBojLkGMBxLZk/wSiY4urdIMxmcNPPdT6rcWij7N5xtNtiiAoBltdrHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IN2ci3rKn0RFobEOFeqCzVuuvHy3HCP4Eocb7fn4/F0=;
 b=PBcLmngrEP577sZu5Qd6P26xTx4E603VTp6QIhsw/vdW1EijQiZDUWSIQVgHbURMCPH7Dn2l7almV4FuV+7D/L+TdzyF3i8aHUwrRW9KKW3w86ewer6g0sTw3fQl0DqE26lPk5b9dz4L5zyKe2lP4t4As4F2fYQCb2DIkYnzI72mn3782EYz5/Gp8L5ebeBGl4kaoYYhUptvAxrc7Q9NbJr15nbhCJm1/CjtuTZIFa6gK70rMoJuqRcBxLY+CrOF3PFOUm8C0l4hHU1Sd4XqYC44eeKPcr6MaWcRZMIjIkkSONkXfAkfpL8gaPIPrimSujqhPgU8eW3NDTphhlt/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN2ci3rKn0RFobEOFeqCzVuuvHy3HCP4Eocb7fn4/F0=;
 b=SfR+FYxBLp/kW1um+bZGLlHnN/f7+XmUoJNvNqAWwJsdVLjlHaJkxLES39Wn6lMzbpa+m40DzTeNHjzOoB4ffAzLIBp4IqGP4R5Jfrr7lmAbX3+Rth4p/orBXnRuu+HJRdMRx1+ZTBjZ9Wj2W4gz/UE1/nhEnlZykveORRX605I=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6110.namprd10.prod.outlook.com (2603:10b6:8:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 14:17:28 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 14:17:28 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgACuc4CAAMv2gA==
Date:   Fri, 10 Feb 2023 14:17:28 +0000
Message-ID: <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <20230209180727.0ec328dd@kernel.org>
In-Reply-To: <20230209180727.0ec328dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB6110:EE_
x-ms-office365-filtering-correlation-id: 15a1daa1-9188-48b6-7e25-08db0b718a5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0lpIvo85aio0YRnv27LhRq7yohMOOiRxjLt1p8JBbaRfoovQu6LOZ2Xn9BzLT/e4d0nxhK8j9ELU9YKVFeTgmRpPpsznUihPjcmRalLoy0Jqa1SQ3+q5sGQ/zEyNHLo/48u5WPgBra6gAQxLLKiIrN19SuNus6vnViFIb6zJqKAZPqnoJWDY4ONMviq8CSRxt+BHq16+TtDS9az3GmZl4hizU4AWb2uGRUeZdZ5JfTy3AQZqpVAndb7kklyUa4UKy835GJSrl6adiUlnDMqKaG1BvXJQbBwHh2KpiV2AGofuti730E67rCwBSTPV0xSyoMbLQ5yjpmk+yKDNsxCvQKfHQkapOj+Uxo+BEIH3jFSSrF5bi9Q62RYgXCZlmoF7NNRG1HMwuUQ1qif9WuXQgP7TWAatJ7XagaUhVtRKAKEyRCw3MYnbwsp92jFuvDRCYUc+zSddImCzbaDD/oCd/+r6jsUEuZNUqmKjys+YiQTj81WsrhBbUUIlIRBDEiozmYNlPATzw38MlpJiPGSdHXCN4oq1lAPH6YV+4L4O6hAWkDufz9GuFOZzqPWe9QPdotT56mrCb/VDq1HgdpOEot7+fTQWMJO5uLe4kdpd99jA32KPhVxIDjXb0D1I/OStIcNfXMaU1yZZ20fdycbWFFsFOBocXHMgZCMpKfNoEJiJUWC4xGs/jAdo6Qf1gZQ1cql2xIUNfHXCIEd6anMb31geoc3qiy/a9Qh8x794YQGX3CyM3ez+DHTberMnRxHvnJ1m8oo7BvfehFCAxITITQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199018)(5660300002)(71200400001)(54906003)(83380400001)(36756003)(66556008)(66476007)(4326008)(8676002)(64756008)(66446008)(6916009)(76116006)(91956017)(8936002)(66946007)(316002)(41300700001)(86362001)(38100700002)(38070700005)(2906002)(6506007)(53546011)(122000001)(2616005)(186003)(26005)(6512007)(478600001)(966005)(6486002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vfczPobRIZ1+KhaqRaphd9Xp7bq1LScU7amv/b8plhO1l6DIMIKncOHVPDkI?=
 =?us-ascii?Q?FgwkwvK7bueePJ0a9eGhEv3Vesm2DnACZjVDxLs0oeXTYH9mQ2szynHeaqyS?=
 =?us-ascii?Q?craOMhx1EITtuboLlU4SQrHmzVTDQDvqSo8DC6AKz7i/eooW/fJ5FQ9UWAV4?=
 =?us-ascii?Q?lFfUjWSM/BPkM2nN77To9vZkOvs8Lvr1Yfcdk/Kt1n4b3CaExCVdqJ94aqTF?=
 =?us-ascii?Q?TjO29zsAgdSKQNFZNlWiict/04zeNo//LI7qDB5yjoPGYX3O+ePb3RloctEO?=
 =?us-ascii?Q?DPkHurw2LpXfsYWNb69MrnYJp3qou+wCP0Ngcd0qQEANiJbOeizpcmm0kJAU?=
 =?us-ascii?Q?BiFTHML6Nai0/XaFMszXKozHtsL9pfTzFCnxP2yUEWRLjc+//m2Ucal6rz4z?=
 =?us-ascii?Q?zH1vczHIKRTZwqu9ckFlo4l5MJeuXwAKEeruFT8U62fP5NIDwBGlPUYLUgf7?=
 =?us-ascii?Q?0H80lIGEDvg2/OBmv/uX4nujn1VhXtl40LFmupCn1qALqG0qahCjWLkGgL0R?=
 =?us-ascii?Q?f0Soy4RrzLokF1a9xoZ6i7Vk7QwbkuajSseP4zZOyhkpe4o+VR/8dJGeHNvW?=
 =?us-ascii?Q?rXXnsV1AutfaxEWVkcaua29RjAITipmPjiDBIv2oe5evWlE4iVwGzvSexO1U?=
 =?us-ascii?Q?HEIf0ZG9v3B/gpb8AFWR+/iAOQPLOt0Z/qCgqnbjWLecnyKoVwLeuLLsZTR1?=
 =?us-ascii?Q?ExgDs9LFmtoEk6UfvJKFmhzeoKdE0MDLD1kogaHjTZaRd2Kt1qFIk4rybwv8?=
 =?us-ascii?Q?7hqu8qq0MLqzUiY+0LkzZs0TV0sci8UIXVr3g13XQbHA9pTNuIEFvGFwQzzY?=
 =?us-ascii?Q?lxHmvX+gQ1FFWjt2N69JTA0cjV0eeqh6tLFBXboOTCC5gmVdp+9xK63yqNsE?=
 =?us-ascii?Q?oQOE5UJtIr038EN6+ehSFcBby28Zge1rUQZYkv8vAJbdQKRCidNILi8KWyrR?=
 =?us-ascii?Q?KPozxD/+eRLZM93CCL44B5W9kZgKLG9KUvI/u7eyn9hxR6qagmQw57GozVU+?=
 =?us-ascii?Q?ygmrhy5nigtm0wcbZh8V4WdWtzH7CepuhEEGaLdx1rI6Ya2aEfakxyvWcJix?=
 =?us-ascii?Q?M1OcWb2Y3SZCiaHZYWSdeOmkhQ99hQET1/HDkdG3OtL6ve5Aj8hXst1kSME7?=
 =?us-ascii?Q?lR02rIWAFD3V0T0XOaWYlbv08d/t5H+3wa0SpwsFqykygcTp10vyTAyjeSwe?=
 =?us-ascii?Q?MGq08BSEivTNHRiUx+xsnDSts830npMXOfjSsCJrtMTLiGUw07lUg3np6VO5?=
 =?us-ascii?Q?6+wXMYo7C1dI22MzED+iM4BO4RojUhHqtdmKZ0BRBbSScAZ4xdksjutIQDQO?=
 =?us-ascii?Q?Xq0gNh9lLKGPxcrjcqP/7w5n0J8PvUA1V2o0CCoVDNdyVVgoqg+lOuKyjMJt?=
 =?us-ascii?Q?iF2f4Q4g67pc0LWv1ggybDkBJnUmNrglO9R6RJrmk4JDOKugi7smSO5Vfjw+?=
 =?us-ascii?Q?UMPrNxr2+88m3hOd+Wu3REansuQUARliUJ2iJxjfLXH1UAmvxd2QMApy3emx?=
 =?us-ascii?Q?P2MiJTIGyfhrnlR9YJudrmngR1EcLxX3im3Gj7YyhG/hrvVKm9vpf0bWyOtS?=
 =?us-ascii?Q?w6jS2IxlDJwqideu7CrZWtx4lY/8S8jytR1vYkmLeF4dENhnBo9k1rfavnHv?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EF9D447921F9E4AAE1B76E670C2E93D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Tg/+g7bRrIGCa0KglHqfAORK9lzDnVMVvZmWGDW55RgDQT4aC0EDJmafc0MByhR5qTT+1XNKMe9tlWEhvQCnSnhMAOiwjeB7jfXapqN93HzxwcPEh6CwpyXstKP35jh+VWNjqPRA2A9DYQSupvNgvIsrhE+og+dr5KhDNrGK9YhBQ0rCWOxfKi4Mksubw1qxHzkrBKaKmMEmPrRGtqEbvFzek5b85qsZFAsShf1gOU+tJiQCWvfYAimAAP/UGNpHzdYy2QWvw2lnWki0683avTXhyzVAZbBLXcDrTCF2OcxReLUHx8QFaGSHLwAoh0SJVpXSwwe7TpANVo1DY1tCkRRDzMa0t2+W9r6KSALB6sqkL8aB8VzEPJKkLNZMHtpQJta9QkmczlTW335K3bcyIK0t4bj/SbP+3ZjfJJ/xUZLrYa4RxFSbT+MHPwjgMNaeuZZEqlDQTna3dd7pkyvN0mUBwcg5kH/7RMk21UoWHWjHQUwyg1OsRf6jZYH/MHeZxnEqPQtw7qtQ8XlbH3M4OHrZkTn5Nfj8hNAjnId1Jks941Ow11shdjLvjNnE4265SI6q2v5aUVtA4VlP7u8oKdZWaWPTQED/rDjRYM4eoTOT9/G7ukAPUE9KTfAk3WPGJppBECB+BzZDkdm6o1ucHlV1K/d7nQ4GryllO8uTdu895/tsYE832WJNJw+G5egF1Z41Kg4ySZPpR3BWdMDoyjVq/J/R0WAp9eDxiUXc1foKfqRoOPXUeFSLS98nTH6JvZ+ce+jlEJU6DBOJ/BM6Y0FndGyVof4Wqb+Y0EOZTny1k0hh6h61u52I+BWsr2AQEx7TkKVC35XLyd0Yhk6aGS6zuH9FdsPH638n4IZCCXTjROZCH13dDVFLBSye0ETH6vkB7We7pYjMw3vIY69ljw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a1daa1-9188-48b6-7e25-08db0b718a5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 14:17:28.2828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VlSgSAbEQTwgp4xSUMmWywR3Al+FUNg7vkQW5uRNcCqxS1V6KdeT4Yn5CLkm/+V7nil92dtCaR1hu3C6TB5Udw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6110
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_09,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=967 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100117
X-Proofpoint-ORIG-GUID: LVuHHIitDRMo6fzQWMv6hZeC_1UBSPQj
X-Proofpoint-GUID: LVuHHIitDRMo6fzQWMv6hZeC_1UBSPQj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 9, 2023, at 9:07 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 9 Feb 2023 15:43:06 +0000 Chuck Lever III wrote:
>>>> @@ -29,6 +29,7 @@
>>>> #define NETLINK_RDMA		20
>>>> #define NETLINK_CRYPTO		21	/* Crypto layer */
>>>> #define NETLINK_SMC		22	/* SMC monitoring */
>>>> +#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake request=
s */ =20
>>>=20
>>> The extra indirection of genetlink introduces some complications? =20
>>=20
>> I don't think it does, necessarily. But neither does it seem
>> to add any value (for this use case). <shrug>
>=20
> Our default is to go for generic netlink, it's where we invest most time
> in terms of infrastructure.

v2 of the series used generic netlink for the downcall piece.
I can convert back to using generic netlink for v4 of the
series.


> It can take care of attribute parsing, and
> allows user space to dump information about the family (eg. the parsing
> policy). Most recently we added support for writing the policies in
> (simple) YAML:
>=20
> https://docs.kernel.org/next/userspace-api/netlink/intro-specs.html
>=20
> It takes care of a lot of the netlink tedium. If you're willing to make
> use of it I'm happy to help converting etc. We merged this stuff last
> month, so there are likely sharp edges.

--
Chuck Lever



