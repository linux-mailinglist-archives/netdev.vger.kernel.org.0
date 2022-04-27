Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090185120F4
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiD0P2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiD0P2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:28:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC831D422;
        Wed, 27 Apr 2022 08:25:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RDmeLM003700;
        Wed, 27 Apr 2022 15:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=j77IoaAdl8nYnmd06YhoXI8jamhcCwAdCN922cI+3wk=;
 b=acfv18f2AnydgheB/mZSx7RGOXY46uE2hTEtEt5CuyPU/UJEk5WXOZNubrLMAmDbXt1l
 YTSLPCm98yWnChjOcb8E1xYZitqwEsrOEiDJxMSfPVYP7pxuWsTEFhnmQ4jjT2eCi8qk
 UAyvtvKM89Cy0xMbFSLq1ZwsCovPk/6sJmF0UBaahzRhM/SJocBdtQ8JFtvQxNlAOto7
 xlwksFfGxq+NvLJQzywOXQVd/4z3OhBD2qI3bVHSmqOi5/L9TJ0B6Nljbx5FVF6n6a8n
 nBio97IBTU41Zu+OhILx7p83SmG5lj+MoZpkDfzqOledbVtreKbk9vU9IMGFCrZ9XYq6 dA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4s2f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 15:24:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23RFA8FD012172;
        Wed, 27 Apr 2022 15:24:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w4y24d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 15:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGV+SVze99KXMjkFg66/SaGKQFfCQD8SI5SjTOE2FfX74rIP31s++6h4vNha2W5f5aA/wsaNxU3meYNHM2Sa/lBCS2ge62HS+cz7Pw1u0PZBjEXmTl7JW+KsU9RHVuHT+zNr4oL8lGi4Muuv+esWLQrnS2r7zMIXgD36RdCqB6QhPibdqTjYN1Lb7JmF6E9Etny6j3vIrZ90KADb6Q7OzUZ974ED7535dbHvBEL80A8XSQfo/tjMiKySh2Y9qR9fspBlxO+exQZgsl4y2G5qv7PfkfMbuMskGLQ4N4CUy8fIGH7ONEOaafOypp0nqxx3WK5AVjS1rdF23EiNSKWEtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j77IoaAdl8nYnmd06YhoXI8jamhcCwAdCN922cI+3wk=;
 b=ArYK5AxmeNfI4K8U3hHRwl2lw/fg8Fw7EanjXEj9wir7ye1jkHAfqz+dFIIRgtLZ5Ju91BIKj7ifmN5jxpw3CKvtsA5BhUHJyctM0P6odl2B+Ow3p5ByJFPF9Tbh/vtgfKJsQXhU29VSu/ziGA2siTUy//Buusxije7Ew71epARRz+kMcGkz1jjrzCNb5vYHgEvFFM60wGeS7c0KdBzaTZSOitnoVI8IxHqd98yRUEPzpDHSUIYM6jzIlgAcGmVc3Q8/U4x/ZrKfVw5DG0iCnESYNvmwl92JY3JyGiFix7pQ1NXqOv/+E/cmBVaMU/ZgmuVV44qjDDQVewfzqEUUpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j77IoaAdl8nYnmd06YhoXI8jamhcCwAdCN922cI+3wk=;
 b=Re7DCi+AD21szDQ0RynWUG3yslXegoXzntbgEj4xlaPUqjwME+b75XFI9QrEhUHGA2lEZdzLEugIm46zHqzCbDXkkHDGHEf/rmOaPpvjAiLuqmihn7gqVwTHgH80vmpJU13F/l47Scmg4BvC1qjwDWmeF32qWD+S+zFIFSf9HDE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM6PR10MB3545.namprd10.prod.outlook.com (2603:10b6:5:17f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 27 Apr
 2022 15:24:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 15:24:26 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAEUOICAAE/AgIAACW2AgAAPnICAAId8AIABAUiA
Date:   Wed, 27 Apr 2022 15:24:25 +0000
Message-ID: <238292F3-12FD-49EB-834F-F84A06AA866A@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
 <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
 <20220426080247.19bbb64e@kernel.org>
 <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
 <20220426170334.3781cd0e@kernel.org>
In-Reply-To: <20220426170334.3781cd0e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d96d049-f065-4eeb-799b-08da286203b4
x-ms-traffictypediagnostic: DM6PR10MB3545:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3545FBB3EAE2CC8B3888ABE193FA9@DM6PR10MB3545.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O/S9FdobzwhXD2sSke3R2Oy+hvD/leFpcHzWSQyZ8AgtWt4yuGgc5CwRacJ+BgSCAMxRlKquktztpgLJZBzWJP9wU4fBqMUihRrXgTrtNwdHqZo7ZE+ymwLWqG7OJvC8SKkeEx8nOr4sB/VRm7ANjjp1q2KN+tCSyidyOnjqhl22FZ7HX+64IimZg/V1Bcbm6i0KTBeC21T3JwY1LgSSsB1KNv2b3adSOu50iI0cTsa8AESKDOONMraEEXEkV+vIOOaZ/eG6x7wsfeGzFOL6exQjZdt9S1Dp42Rau8zHDoZIA06zmZYmyxT8bmM31becH1dYs+hW2QZgyzFRxRDfD9xukr+Q0zK2lO4iXslyF0QtLkNIRviGlw7qqNJ6O+48eppHqDmUyUc1tTfmgD015bOpZdKmymXAmXjH7u8ZJkyehOX7adMpjIgtmakGyzKbCQ4284s9n4g9Nxvybs5BOQBL2QGNWnFHREQ7S4CfRJsilFcxU/Jshyp/QcsCgK6kb1EE/wm/RX/p1P1qVRC7xT66DvWAjGZvV/NDRr7eUE3Xbbf3UarBZivm2AS+Tx7yL6j7IF7gvTAYGxprclXAgmj7F3HYcGaFInK6Xl+uLnaqcshMTc9OWRaGieuoMweE3ClnjyTon15JWEfJ9iuZvnnY3XrFGyEzxV4wv54JCjQ5dJUshMzPrPCWM740UYVRWwMCjPi6OguMwAUzZq3UFfUgX1yRRo9bEPlm624IKRB6QxAZjOZRozogLRLqMXqyhdDjsdT4dWJd2fAxRHcIsYyhzDPKO2Qsxcslfn55Eu4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6506007)(53546011)(8676002)(508600001)(33656002)(2616005)(66476007)(66556008)(66446008)(64756008)(66946007)(26005)(6512007)(4326008)(36756003)(91956017)(76116006)(122000001)(316002)(38070700005)(7416002)(54906003)(5660300002)(83380400001)(6486002)(71200400001)(6916009)(86362001)(186003)(8936002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LHN42HErrcA8RBpCLZXg3RWJlyH+dvwZ/BPi0AuZMgpQhKXoo/NUMouJ+OE9?=
 =?us-ascii?Q?g7Qmn1SaQATPK0OdcJxTPW3vT52+fI0/ZacdWKrgbzbtIqddbaf188TITgsU?=
 =?us-ascii?Q?nFkhXuPYTJaYCh+YL4tTgo5lqhNejxJWBb6zirLXhV48+f/3qKars2RNNat4?=
 =?us-ascii?Q?Wj2D/+aviMuR/Dk3vkvygCMFdQohz53EKzNdO5c8TogqAIyfZ008Q6nH+R09?=
 =?us-ascii?Q?O+osAsSYhsU2NQMAZ4U3uJ520En3DxhDpS6avUGu2/5HaBDKgX1WygpGXnzI?=
 =?us-ascii?Q?CAStHKjHB+WaMhpke0ttB3s0RkIzFtVLRjFrW5oRw520ePP6+FOCPdMTuNDL?=
 =?us-ascii?Q?47u7r8dxZykBPWb6yCl/dFFgvlHP0fkFXR8a0Yx0Z8oxJadWLn6qHlUZ4aNe?=
 =?us-ascii?Q?9jog8lqldaCesUxYZU3Gy5nwfXdqGeN3w7sbxNt4KSx9BNp1OtfT3IGlSbFe?=
 =?us-ascii?Q?QHDW/ISAWxmGqRk4B94nhoSs0dzmHQ7fRo0nWbfW3k1KbPvySDlhB5MeYzMy?=
 =?us-ascii?Q?2I3B6LW2vIHFItLp7nqKHX/FQeiAx4cjBOCjDFBUhY8JLu19JrL/0cCapih4?=
 =?us-ascii?Q?IsAXnsya7l7DPfqxF9F1hGnatOSw00QPKsNPxQ4usg6wobUms/P0+DrwU+dH?=
 =?us-ascii?Q?360NrWirWHgjvaW+HO6lEtZ+2kZFynitfAd7WdUMPgeVevw/kKQpJcH+fGuu?=
 =?us-ascii?Q?3QtVFBeJsRj7csDHTlBS1XNhFJ0IvAyM1g6Ohd2P0R4nSbNPf8U94mMTJPsK?=
 =?us-ascii?Q?/+cy8po+w26HqVqmnwBvN9EJItbjKMcDyJdtf5rdqwliBprb3B96JYpgdrRG?=
 =?us-ascii?Q?HZPJc8jLKcj9sR67rW28r1/0gxkIfl5FpN22VInsEzNDlNg5q0HbrrUV1BX8?=
 =?us-ascii?Q?MBen2Gwf+yQvEDbofFivyDYMqwmcN+9YCppWM7w0HbwqhvQoTDTCm4KlcXwB?=
 =?us-ascii?Q?RR5tCZJ3lBlp3P2/IeA6fmsCUwzQAKZ2c0DBPcRDfK1DAU/rAQHaLxhj2/l7?=
 =?us-ascii?Q?aG3Ru2rIjZ78nuW0XEcXjRk3nrbEOrqSHWa5UJjrGvP2T7AVDfrUjwbHrjRG?=
 =?us-ascii?Q?sU5+9cPEuyW9uHAkgz3QU/W55Egzhe7+dTaPN1W+MpLtWHFmcMovCYjqwH+c?=
 =?us-ascii?Q?IdT4rXgZid8FHGVdiPQ76OrShSZt7Z9bqN6zOlpAm4o4bfYlFm2RG11AuwBW?=
 =?us-ascii?Q?XitG60L7+B4yf8DWy+gkbGcTg7ikMpdC7dV9yhLPNm4wtqb57z3PJ3kw1yHH?=
 =?us-ascii?Q?e9nD3fornoL397avB/8l6r6DGwd0z42v8Zvu5erQG2nQCkl7HBVfzgMvTIwd?=
 =?us-ascii?Q?hXZaAUwngUV5QcaYsm65+lfQ2ohVY9Z7Vf2L+7p9oDamjVRIS3MfjjZbcI7r?=
 =?us-ascii?Q?mcutZZl0r0pP3R0qnmHQz4oG9yd8SNjVxf96zVBzfdILfDTYAfwMTMMTa7fX?=
 =?us-ascii?Q?Rm7uhBCmpbt1s8GtyXNX1G9jx6rzrA1ekuNiFHGLIUs7865RClPUzlhQvZv5?=
 =?us-ascii?Q?P4+BfiGOXMqtiyoLdNukUTgp2h0a17sv/wcuNvEIYA+FaelsSryaTEGhg3zP?=
 =?us-ascii?Q?i7JR9PVKS2ugb48ZQ0PgYSMJtSxBaSXWDYCMQfWIydE7jVx95UgXMFnzFKOH?=
 =?us-ascii?Q?aE6b8X1uXLfOjyMCujxLaaEWC3M+akxGap49K+wJT9s4QQAxoJi946i4YQcd?=
 =?us-ascii?Q?zU8UT34h66rfuWsqcQ6B6CP8f7i/CVPVoSKNiZDnUy6rCfhicD9GwykOOme/?=
 =?us-ascii?Q?9R1gvdUos8HifB2KrATRFEQTcfyw/Nw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9240E12ED427964EB5DEEC5A267F09E2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d96d049-f065-4eeb-799b-08da286203b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 15:24:25.9943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FclXaDAr48FTrtTwgTPNQysTFvhaf5zu0Za6mkuArEbFuVELdeSjVRpYXLN0Ed09muHZ+GYV4qBS1YPEygka5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3545
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270097
X-Proofpoint-ORIG-GUID: KhyeFE7E_rMTHnA2ocmzKqL-qopMNG1O
X-Proofpoint-GUID: KhyeFE7E_rMTHnA2ocmzKqL-qopMNG1O
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Apr 26, 2022, at 8:03 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 26 Apr 2022 17:58:39 +0200 Hannes Reinecke wrote:
>>=20
>> - Establishing sockets from userspace will cause issues during=20
>> reconnection, as then someone (aka the kernel) will have to inform=20
>> userspace that a new connection will need to be established.
>> (And that has to happen while the root filesystem is potentially=20
>> inaccessible, so you can't just call arbitrary commands here)
>> (Especially call_usermodehelper() is out of the game)
>=20
> Indeed, we may need _some_ form of a notification mechanism and that's
> okay. Can be a (more generic) socket, can be something based on existing
> network storage APIs (IDK what you have there).
>=20
> My thinking was that establishing the session in user space would be
> easiest. We wouldn't need all the special getsockopt()s which AFAIU
> work around part of the handshake being done in the kernel, and which,
> I hope we can agree, are not beautiful.

In the prototype, the new socket options on AF_TLSH sockets
include:

#define TLSH_PRIORITIES        1       /* Retrieve TLS priorities string */
#define TLSH_PEERID            2       /* Retrieve peer identity */
#define TLSH_HANDSHAKE_TYPE    3       /* Retrieve handshake type */
#define TLSH_X509_CERTIFICATE  4       /* Retrieve x.509 certificate */

PRIORITIES is the TLS priorities string that the GnuTLS library
uses to parametrize the handshake (which TLS versions, ciphers,
and so on).

PEERID is a keyring serial number for the key that contains the
a Pre-Shared Key (for PSK handshakes) or the private key (for
x.509 handshakes).

HANDSHAKE_TYPE is an integer that represents the type of handshake
being requested: ClientHello, ServerHello, Rekey, and so on. This
option enables the repertoire of handshake types to be expanded.

X509_CERTIFICATE is a keyring serial number for the key that
contains an x.509 certificate.

When each handshake is complete, the handshake agent instantiates
the IV into the passed-in socket using existing kTLS socket options
before it returns the endpoint to the kernel.

There is nothing in these options that indicates to the handshake
agent what upper layer protocol is going to be used inside the TLS
session.

----

The new AF_TLSH socket options are not there because the handshake
is split between the kernel and user space. They are there because
the initial requester is (eg, in the case of NFS) mount.nfs, another
user space program. mount.nfs has to package up an x.509 cert or
pre-shared key and place it on a keyring to make it available to
the handshake agent.

The basic issue is that the administrative interfaces that
parametrize the handshakes are quite distant from the in-kernel
consumers that make handshake requests.

----

Further, in order to support server side TLS handshakes in the
kernel, we really do have to pass a kernel-created socket up to
user space. NFSD (and maybe the NVMe target) use in-kernel listeners
to accept incoming connections. Each new endpoint is created in the
kernel.

So if you truly seek generality in this facility, the user
space componentry must work with passed-in sockets rather than
creating them in user space.

--
Chuck Lever



