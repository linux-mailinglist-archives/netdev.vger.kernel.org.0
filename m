Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA475507269
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354201AbiDSQDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240853AbiDSQDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 12:03:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA0B2C662;
        Tue, 19 Apr 2022 09:00:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JEsWZv020195;
        Tue, 19 Apr 2022 16:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=c7z5vOnynLyEDnPy11mmrmJ6Qi08Dwu5taImU8VWnnY=;
 b=zwG7N9uJHcdgTg/uBtaEiJXRzeeYFUx1L1Jy5kiH77HKEGvbP6y6fNC7d8Ui8ze9ElEE
 TYB4EagNAETyYw2dJtyA/vH+oOP9+L3GEXgROhxo4ChA8wHl7W2c5610FXecA79GEM0O
 iX93jAX66Cr7qvi2CcLsewvEttP5k8ABAWxP3g/vRZWxFn1tksMPcbs06uaEkPLVOMNA
 jcGxiPo3UPtMS8quIr6I8hiQ2PJ2+9AwASyJ6kS7ZupeDybfyF8VdM9eXbUT4Kk1rL+V
 H9IceCMJrzbkpGyjaYVYsvJ+9JmlPLnE+MepgxOdx2ntLnEneNLA2je3QJpXxY7mQdEd +A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd16j99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 16:00:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JG0dB3036821;
        Tue, 19 Apr 2022 16:00:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm82y8xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 16:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ4VRxonwYxz9tbXeN/bbWx2zMopeLzn6r+YYND4uFdNE3jb8zsfUK/YwyG6lMnXbu0aZ1eITgUnsRZUjDkzWdODYIzJVg2FPKamkL0e8UHsjG8/jHIoSiezR//XACNNhoJzxyWXgQqNm7VhVaySaAFwQ127DUAe9tn0vKVQnULkuDXP+YdfpbzBiW84pJwjfQ8SjTozpiCY5FTpXPRA7+8Qyfo5SXv8wf1bLDMdBugjU//RF9V7/Alxfe8Kgx8f9rl92SHlMLk1Eui9GIl2OtPCZwKkHoYUiz3U1/xQ5Y1Z8pRa6+smunhGpOUM72beZElAG68IU42RQ51l5FpMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7z5vOnynLyEDnPy11mmrmJ6Qi08Dwu5taImU8VWnnY=;
 b=dMD8RH4gSwtVuTl24/ZNyfr12fpQKJP+RxBBnHBzmqfqUur3FiAWwXFsdRtAjjL/zz2C+d4ilSkyJuJOkAFHwsSs2fw5ZSue/1HujnUvk13RM9wn5Ey8gPotXlQ52DcyiAZ5bmCvJdlhlHiRAOSodewwe4HzDnQRCmMGypNF7Tg4mVbJKJiZt/hAUELWpjpVGbohaGAlTU+0oRmd001hZyxRV8r0R2UYGCZnCCSLlFo/62Np9ndGl0uB8GVKBwzl5Nqf8AB7uYpjVj7b+xOruFFqK4z18d8JGWD82Sf6A2xBdWEOdABOL6sSuG/WLCTV7uK4odvtJSV71zkIkkA0cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7z5vOnynLyEDnPy11mmrmJ6Qi08Dwu5taImU8VWnnY=;
 b=Jt/JYHXuge0kmcCSkgV/e19CWhLkefp/hRi6zjoRCy+PPdP7Y1W2r2FICeeQiV8D8QoejfcKyjssiUH97Me6yTty+gv0MS2nvUdTYH+dyWh4+ddbKPbqv7FoiZ1xwXUvj+ATgPtHflAycBselD72y5cMaV8inIvL224WuF31AfI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BYAPR10MB3702.namprd10.prod.outlook.com (2603:10b6:a03:11a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 16:00:40 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 16:00:40 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>
Subject: Re: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Topic: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Index: AQHYU0SpuI21otIlHEi6aMaWB1g+e6z2lWsAgADRRwA=
Date:   Tue, 19 Apr 2022 16:00:40 +0000
Message-ID: <06AB6768-AA74-43AF-9B9A-D6580EA0AE86@oracle.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
 <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
In-Reply-To: <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66c44ed2-2d89-4cd1-c335-08da221dc09f
x-ms-traffictypediagnostic: BYAPR10MB3702:EE_
x-microsoft-antispam-prvs: <BYAPR10MB37022C74B435B71FC6120C9993F29@BYAPR10MB3702.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ngnwiC2wPeIsmiRMNrPozkNxABo5M2cLUXRsqV+pt1Yl2sK9Ft1zt8ZO8rsev0ot+oDijSaToW/VJdkGQ+Sq/i/pedoxMBJ+33f3VMWwxpZSKYlmz6pQDvBmrdgctJUDHuOZ6uI2J+/4mgkqI7jkOowtPV69w9hssRvmHzlN9oXg6N02LWsCqPtQ2ah7tUgg2/H/7EPk344V1Ig3NwrhcObUvNbXsyAVUeItGN3eZq6G2/wY0zniRwxHj8a9bmnbZCzwU74c2vDpwLXCiMrJkf54xQkcCqOSl9C8QQCbDedfdAYAxPRrA9aoWbbjctr9AAzw5H4EWAJpcfn2lMLf5GhJQtKnzkrVyqfSR6xaLc4kJqHOn7KEbGAMoj36U0Yh/4ZMwZNEeVjN9Z6KYm0aChxDRX3VBQHeYzyWlfog7rZIVwDHXUTjQRzf7b1FhiDf1nWHxpiT3udP5mFr02cs9gieX9Pk0Pbo0JUb9GO+JmJwrkFuhttlEsRk8c4Pi9+7jwySde2kDIINu+Yhma9xBTXpQxf/mAe8bXxG88/eMOmvX3jMiun9bxJAQ26MTdj2wBiPiWFWiN5I3CW6kTv7XWvWF0hZMJkmd8BodixGpPBOHo+XoTjjBQub9J46VWtTkI1eKgllcj3vAI/bLOeojz+M7O1lxQ7C4Ek+UewnNPnWbUTiGd78qc+zIZp9Wia+Ad3qEH1Ue43ROwVR3YqtIDX+yzwJvYTfbnzmmqmaOo2uirPseZfyyMMvRFonVLCELTimDGcU0PHUGi4yZ7OzyJk+HY4h1JBGtlmnq11bQ6nCTcGBDCJJdrcsckVYLwcx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(83380400001)(26005)(186003)(38070700005)(122000001)(38100700002)(5660300002)(8936002)(66446008)(64756008)(66476007)(66556008)(66946007)(2906002)(508600001)(6506007)(6512007)(53546011)(316002)(76116006)(8676002)(91956017)(4326008)(71200400001)(6916009)(54906003)(966005)(6486002)(33656002)(36756003)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8IlsyU891a6D5yPCIJ58+NOFPTimC38WbZBb6B0DFCB2ODqnpKL4qE0vltim?=
 =?us-ascii?Q?qw6HX0hSQ88UUAT2Z0+KYZbYnYJkgfcWgN5QOCzR0agFgdoVGy+kKTJKpK7d?=
 =?us-ascii?Q?T9Mim1ejSantgrT2VkqxNtaL5DOEOZdW0I3BEf1IvEtpNhnZhnqQg4l3J6Ca?=
 =?us-ascii?Q?3/gAdZrPFSu7mW/Dy/C39X7arFtguMNXgskZYsqs2aHoVR4PjBV5wTKqpT4b?=
 =?us-ascii?Q?SjKg3l8EzC8+hlaPB60nzyrr/lI+848fykKiTpKXRY+SL1FFlfl6dLtzOFz/?=
 =?us-ascii?Q?lCxtOxbbik961LJgAm82A7egEA+kLgWqYD1OVq3Q6hwhKs9LM51IiKXrciAx?=
 =?us-ascii?Q?xlL6egLXqnVoC7R1e6sNbz5MmeQzEwHErjwCe6n7gqsVKg/chjeDJknsusss?=
 =?us-ascii?Q?4aTKf/5wBTUi46m8zaC2XTEkSl9kmR9UKnL2tjVagsLMfyAaPeJgVRAsvoFN?=
 =?us-ascii?Q?T5nUi04mqXxr66h2DqJMFhhI66RF64Clz+9kqE000Z9Q9HoZz0a5ajy+QHhU?=
 =?us-ascii?Q?tEhDao0XLgwH/1D0LHv4OjtBzjKoNDd0fm3HYjCNjB34jqE6oScTqIvp+puU?=
 =?us-ascii?Q?QYEX1iuFx6svZWEiH/tEUBxNfm6B/u4epEbr+wbOE1N68pyaNoLJ4Wj7TRpJ?=
 =?us-ascii?Q?HTyKT+9OG9BxGRgVaNZtIRMVTaBwvMhmCiCmAI38QuxPHnrAKs3qR1kIPK2P?=
 =?us-ascii?Q?t3Sg7vW18/hrA2bn795msH2Tr2NhPFWGpFZdNFLa4FE1BeeVlMNFCBw1H1ta?=
 =?us-ascii?Q?RtOOWpdx0F/LU89x6Emq1y/dIlhW0kQ/yJFk6D8spXXHttAGZ8x6GT+wfd0a?=
 =?us-ascii?Q?I3KGsUs1yBQzLS5JG/PEl4LvQKWif2Gw02BD5XwrqTJEmQLccEuBESXmPc+6?=
 =?us-ascii?Q?OsCXVU+6pPpycntKMkoTnStznEIH1HPAaCHaga5/Z5aQIh+zFidTg6Q5Kw2p?=
 =?us-ascii?Q?tzaVX/zN+goVXT9CWWFqMKna4InPXISWo13LYPYBDKYWtIN9qTE2ZmgtSVEU?=
 =?us-ascii?Q?vHhPZO1viukBKN5eViMnC+R1WM7fDaqfWDTdbpyxKNYPzHFpi9hawJBOeqYn?=
 =?us-ascii?Q?Dl0YZ/AKx/qmAgBi6kXk/FCbBor4KBr8sV6727e2yef29ZkzzMMenPc2KBAR?=
 =?us-ascii?Q?0ua5VrdnUsQ7srHETS8fi6gTJo8NDg3LqXfDd2XLXkcG2ZpLhggCsymHXDeT?=
 =?us-ascii?Q?+DHDSMK9fkVCYK1jwWxdQ9t/wGCZ0Nykbk7sGn5cIionQQ0vqEDuJfZftJjO?=
 =?us-ascii?Q?b8wIIryPnRbAlcJeel+c2lzroWv33nPjBDJI6wmst9xReZPywf98kXLLRBtM?=
 =?us-ascii?Q?YA5fMuQviAckbkwFVCnLNUbo8HZjhikk9osgVnSS+GxXUJWA/yktmsKa4+Q5?=
 =?us-ascii?Q?pIywhc2XaOlmehKlVhsCZpqpZPHIz0pzzDRkD1lB3Exz+t4wXDBcPAhFi72J?=
 =?us-ascii?Q?cghSs1spEG6WGgupb1StkUb7f5eELr+JR0+8MD/B0kx2+fUJqepR8MFPI+cA?=
 =?us-ascii?Q?OPq375QlAdrfP8kYWCVcRaHod9ZbnNkGNAsiHRAhnQGIU7AgL9dzSb2aD4mU?=
 =?us-ascii?Q?B+CHPeaXMCx5RydBink414Irtfc5HwQ3TUtw3pjMnf05AFPVxZLUl8MbpjkE?=
 =?us-ascii?Q?dEVk69w5lGrqfs9a+MXbHUtWoDYE0kfL6DKQxoJeRfVaptyz4Kstm+5fmBOF?=
 =?us-ascii?Q?OqJ+s35OYx9ArLAhu+s9kxrbnzKCAmHsgONCQv63wr1JoG/uEXWD+z95zbVd?=
 =?us-ascii?Q?dKBX8mxLdKwg6FM62+3ge/B6qCntdjQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <699212148367BD47A22BF36C67807D07@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c44ed2-2d89-4cd1-c335-08da221dc09f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 16:00:40.6813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MxT3JaqsmgGKT3Aua1XDIT7WMtHy4tTWuP6/u2rWxhJAAHLUHu7Q13zr8LA9cUOM+LO7KMzOGabKDog6fHCz1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3702
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_05:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190092
X-Proofpoint-ORIG-GUID: BQWzxijSRghv-Gd_XwhBwqC6g7rufF5Z
X-Proofpoint-GUID: BQWzxijSRghv-Gd_XwhBwqC6g7rufF5Z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Trond-

Thanks for the early review!


> On Apr 18, 2022, at 11:31 PM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>=20
> On Mon, 2022-04-18 at 12:51 -0400, Chuck Lever wrote:
>> This series implements RPC-with-TLS in the Linux kernel:
>>=20
>> https://datatracker.ietf.org/doc/draft-ietf-nfsv4-rpc-tls/
>>=20
>> This prototype is based on the previously posted mechanism for
>> providing a TLS handshake facility to in-kernel TLS consumers.
>>=20
>> For the purpose of demonstration, the Linux NFS client is modified
>> to add a new mount option: xprtsec =3D [ none|auto|tls ] . Updates
>> to the nfs(5) man page are being developed separately.
>>=20
>=20
> I'm fine with having a userspace level 'auto' option if that's a
> requirement for someone, however I see no reason why we would need to
> implement that in the kernel.
>=20
> Let's just have a robust mechanism for immediately returning an error
> if the user supplies a 'tls' option on the client that the server
> doesn't support, and let the negotiation policy be worked out in
> userspace by the 'mount.nfs' utility. Otherwise we'll rathole into
> another twisty maze of policy decisions that generate kernel level CVEs
> instead of a set of more gentle fixes.

Noted.

However, one of Rick's preferences is that "auto" not use
transport-layer security unless the server requires it via
a SECINFO/MNT pseudoflavor, which only the kernel would be
privy to. I'll have to think about whether we want to make
that happen.


>> The new mount option enables client administrators to require in-
>> transit encryption for their NFS traffic, protecting the weak
>> security of AUTH_SYS. An x.509 certificate is not required on the
>> client for this protection.
>=20
> That doesn't really do much to 'protect the weak security of AUTH_SYS'.

My description doesn't really explain the whole plan, it
introduces only what's in the current prototype. Eventually
I'd like to do this:

  xprtsec=3D none | auto | tls | mtls | psk | ...

where
  none: transport-layer security is explicitly disabled
  auto: pick one based on what authentication material is available
  tls: encryption-only TLSv1.3 (no client cert needed)
  mtls: encryption and mutual authentication (client cert required)
  psk: pre-shared key
  ...: we could require wiregard, EAP, or IPSEC if someone cares
       to implement one or more of them


> It just means that nobody can tamper with our AUTH_SYS credential while
> in flight. It is still quite possible for the client to spoof both its
> IP address and user/group credentials.

True enough. But some folks are interested only in encryption.
They trust their clients, but not the network.


> A better recommendation would be to have users select sys=3Dkrb5 when
> they have the ability to do so. Doing so ensures that both the client
> and server are authenticating to one another, while also guaranteeing
> RPC message integrity and privacy.

With xprtsec=3Dmtls (see above), the server and client mutually
authenticate, which provides a higher degree of security as you
describe here.

I agree that xprtsec=3Dtls + sec=3Dkrb5 is probably the ultimate
combination of security with the least performance compromise.
The prototype posted here should support this combination right
now.


>> This prototype has been tested against prototype TLS-capable NFS
>> servers. The Linux NFS server itself does not yet have support for
>> RPC-with-TLS, but it is planned.
>>=20
>> At a later time, the Linux NFS client will also get support for
>> x.509 authentication (for which a certificate will be required on
>> the client) and PSK. For this demonstration, only authentication-
>> less TLS (encryption-only) is supported.
>>=20
>> ---
>>=20
>> Chuck Lever (15):
>>       SUNRPC: Replace dprintk() call site in xs_data_ready
>>       SUNRPC: Ignore data_ready callbacks during TLS handshakes
>>       SUNRPC: Capture cmsg metadata on client-side receive
>>       SUNRPC: Fail faster on bad verifier
>>       SUNRPC: Widen rpc_task::tk_flags
>>       SUNRPC: Add RPC client support for the RPC_AUTH_TLS
>> authentication flavor
>>       SUNRPC: Refactor rpc_call_null_helper()
>>       SUNRPC: Add RPC_TASK_CORK flag
>>       SUNRPC: Add a cl_xprtsec_policy field
>>       SUNRPC: Expose TLS policy via the rpc_create() API
>>       SUNRPC: Add infrastructure for async RPC_AUTH_TLS probe
>>       SUNRPC: Add FSM machinery to handle RPC_AUTH_TLS on reconnect
>>       NFS: Replace fs_context-related dprintk() call sites with
>> tracepoints
>>       NFS: Have struct nfs_client carry a TLS policy field
>>       NFS: Add an "xprtsec=3D" NFS mount option
>>=20
>>=20
>>  fs/nfs/client.c                 |  22 ++++
>>  fs/nfs/fs_context.c             |  70 ++++++++--
>>  fs/nfs/internal.h               |   2 +
>>  fs/nfs/nfs3client.c             |   1 +
>>  fs/nfs/nfs4client.c             |  16 ++-
>>  fs/nfs/nfstrace.h               |  77 +++++++++++
>>  fs/nfs/super.c                  |  10 ++
>>  include/linux/nfs_fs_sb.h       |   7 +-
>>  include/linux/sunrpc/auth.h     |   1 +
>>  include/linux/sunrpc/clnt.h     |  14 +-
>>  include/linux/sunrpc/sched.h    |  36 +++---
>>  include/linux/sunrpc/xprt.h     |  14 ++
>>  include/linux/sunrpc/xprtsock.h |   2 +
>>  include/net/tls.h               |   2 +
>>  include/trace/events/sunrpc.h   | 157 ++++++++++++++++++++--
>>  net/sunrpc/Makefile             |   2 +-
>>  net/sunrpc/auth.c               |   2 +
>>  net/sunrpc/auth_tls.c           | 117 +++++++++++++++++
>>  net/sunrpc/clnt.c               | 222 +++++++++++++++++++++++++++++-
>> --
>>  net/sunrpc/debugfs.c            |   2 +-
>>  net/sunrpc/xprt.c               |   3 +
>>  net/sunrpc/xprtsock.c           | 211 +++++++++++++++++++++++++++++-
>>  22 files changed, 920 insertions(+), 70 deletions(-)
>>  create mode 100644 net/sunrpc/auth_tls.c
>>=20
>> --
>> Chuck Lever
>>=20
>=20
> --=20
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com

--
Chuck Lever



