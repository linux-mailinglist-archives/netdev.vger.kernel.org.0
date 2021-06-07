Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77A439E569
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFGRbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:31:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11372 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhFGRbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:31:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157HPP3d009683;
        Mon, 7 Jun 2021 17:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=loLKDbqo1r6vWnNgpDdlcAxOdNKC3oP6XnDhx0LBOX8=;
 b=Thm+b0xY9xHL98lUXCXG63THR9HcWulq9ZndcW764E1i8eoTB/TowGJnLA5dkZVScyLe
 s53IZPfPysyMzXivOIF2n+QOocZV0pSCxGIUJ7gVlHXnMH1EelS/iT9nTOeUmKpTM/Gt
 ix3WpXSJr2CELKogo6koCw9zR9IpxN2kfJdwFVVcrBJmpWIxyGFJgAN1OFc/0CHvqGfR
 DxnyTioNgCG1AfIzKW2ZyK7gmtzFn70TKgVdLI4KmxRE7seVkMtTkJyGKGfSJ5oEULRv
 oXpfRxTm/86u4BFSJy5KeIqxiwKXfTPfhj48I6ywk8GMrCp8ghiD0ACIoSzcxhr0JlNB zg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3917d4gaqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 17:29:21 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 157HRjOh002113;
        Mon, 7 Jun 2021 17:29:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3030.oracle.com with ESMTP id 38yyaa8yxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 17:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxLwrFmbMDU5wCWVIpVuuLheQfJi3xXvDihod0bHOzisgb6mVp1/Qs8ofVnwCv8Q6Ucd8DQeBkIOPG1T/CYOI9M8ktiM1zymxG+N+c6/1KQsAQmHbfwgTL6yHs4Sd4oaE4C+O+KVz+62EWIXJ2P1hBRY7EGk88gAn4q6GaUgyhQV+W6uavlh8XobD+QwxlrXOL3roXpDAFU2/HRMyGcqGTEZ0EWMCl0EwScFiLhhfo4jufO0D6ADbx4EwOhrbd0krpRFsaz5KW3ZviVAGC0bxMRwzsfuRJAaPXqOFgO2n31IkGtH/rgLUqnVH3ntZXPC9xpyAC9uBjxQfpB42gvEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loLKDbqo1r6vWnNgpDdlcAxOdNKC3oP6XnDhx0LBOX8=;
 b=mrutE1Rlw76StO5PuRmeUk6qhgse3/IFFNd+g4howRWQKspoEbyj1tpoT2lXLoMhkvOO3NvL0Prn3OxihhGrK7vmmV5QcnCv3MdrFRh6UutZDcnlYpUlmRP+/Svs2dhtgYvXVCXPZQd1KMvv63hRw24i2ZYrkjTpEVDyCTEwFNHDCUO3pVIsPSPuKBrmyCrSyDqbq5xozGviJiGdKMiMbx/u6h5srq8K8ju028h6ubzzz7aJGiCdORrwDs2EXR7cdLhob33pCyPSFIMdNXuFs7eG5gWQUW3WyuNkLrJw8zilZ8DMft8wHq8EP7HBTRPOVux2ZH1EmJvohGa9yji5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loLKDbqo1r6vWnNgpDdlcAxOdNKC3oP6XnDhx0LBOX8=;
 b=w71VWEbEG7yuCUzh+tQ6zufbqkj+EPEfuqx0JbtHKn8brmGYxGWS8x5ZE1ZK9SK2jXbkhZ4f0C8KYb3nCtbu5vpzkhPF77z8SEMQXR4oj7wE2xiIUZnxk7U0mGysiNBn2udMeCG0NRd97fwnjxWFyNIfti8DVJbJTJIHmBAwz7E=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB2520.namprd10.prod.outlook.com (2603:10b6:a02:b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 17:29:18 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2d8b:b7de:e1ce:dcb1]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::2d8b:b7de:e1ce:dcb1%3]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 17:29:18 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Alexander Ahring Oder Aring <aahringo@redhat.com>
CC:     Linux-Net <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "smfrench@gmail.com" <smfrench@gmail.com>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
Thread-Topic: quic in-kernel implementation?
Thread-Index: AQHXW7FlF80La5jqQ0+1BLKKAcjzR6sIzeWA
Date:   Mon, 7 Jun 2021 17:29:18 +0000
Message-ID: <CCEBCB35-9F6A-4B04-97AC-39300EDF5E2F@oracle.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
In-Reply-To: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d675afe-86cc-42d7-1458-08d929d9c7ac
x-ms-traffictypediagnostic: BYAPR10MB2520:
x-microsoft-antispam-prvs: <BYAPR10MB25209175F6F784BC42AC81C393389@BYAPR10MB2520.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: alSVYahqfVJBzarR1Oh1lFeAHXbrgNLkoUfuwLVzb52eSLYXTR11xz+8muQYbV26CwKEe+nRLnuOyh8Gz/VMcxDJ1hhlSwNBsf0KMxkm0n+8tYaThPzhWr2lgR53BtLOVOMVwYBcP3+SeeGyGTNMIuy1LhYCiKfXhBC0G6YFAXU+Gg6x17EzPJ8jOKiPpmdJCJHvfi2S4/RX8c76mBR9xkmqkJ2CuD7+w/BaVmOg+KUYZSyX8jE9FLNPiK+WEKfqHb5O3652AR5Xoh71Z0UPf3LGEz3QALCmmzc/xmN3QNUB83/0EDawnSnCf6RGT//3tEqitn/Q+hxaPBj7Y4zPSUUWGGhICo95KGvDlJVpQUkk1BNNijfkkiwjduc8vuxNvMFezJub1TBFgJODxddBQ6m3h1s/ngydBSc1btsjWANV4FJXHyb1pYlI+WGA5pa00PIGCJhqXnA85ujPSzfjmXyFUT+wBEHOSRn7k2EcH3Oei/c68tzBcPgQg5XEa+x+hLVEFmLJE8j5EMHtQMQGjJXKlxGhPL9wfC1Q2SAKQ+mjS/YhVpPnQ0ArPmnyONx1K6zPIGLYq/lPz4Fzdncm7xegIJZkYC6HIOwIsJj6xoK+ZteCPodbEOqqNmZX+XrcaqCtZ3f8k2LGyTenMKm7A+8dhR7cuVleEQperfZuBmI7Fwffj6D8/JNP56SLAc9lYDpuwfG8r1Tt4iIX7pv+jyhQ7r374lU7xevJnuzqxY/gcoQ6ZfMpfjq8/GXEaLp/bWQ6/byRhTQ/OjKw77yhHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(38100700002)(71200400001)(122000001)(966005)(478600001)(5660300002)(2906002)(6916009)(8936002)(2616005)(8676002)(4326008)(66556008)(6512007)(66446008)(64756008)(66476007)(6486002)(66946007)(91956017)(83380400001)(186003)(26005)(3480700007)(36756003)(86362001)(76116006)(33656002)(54906003)(53546011)(316002)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+F0UAOXeGI0Vp8zeHnUrT9xfuH0rRnKANnA97P1ovYeY+d4ZSTM5RexDVmw4?=
 =?us-ascii?Q?lvdSHu/aV/KQ5C3OFV+J1i+uGnlGmk87/PmMmhtKbtmXSGzwPACBDz9QQYLI?=
 =?us-ascii?Q?18sSq+06QhTuMHMSDRRIeqRX2q5pe7fXDwxhVovNQHqTcz8cXz+MjL8jJDfY?=
 =?us-ascii?Q?/cyA5kNlManLFSeKcC4GKl36TSswgJ4gKJ7G4QQI1KXLsYFM2IGjKlK+9+B8?=
 =?us-ascii?Q?8/T5sLEIoDFBKpxknjGY4I4Vm6GfV0SukgSGQS/5n4tyq6WLBn1ldTa2s98A?=
 =?us-ascii?Q?IVLalipSYftvfSGV8DB66MtTQuwgqvIRYAoSmu2sv+/xmEuJ++yR3kYxMXen?=
 =?us-ascii?Q?4CUZQb66gSodiHf4L3s9fkmVirpdHD2k3wgclOwacGxyR9MG7suDenSqjZTQ?=
 =?us-ascii?Q?i+MCImIRIG7jLpRV7lNbokNky+ZyuhUpmOjmEcBS7o4TageFj42DfOGZpWkX?=
 =?us-ascii?Q?4Gk5FW3RO0OZCpVQ/SyaHCNtbfz3yMVEnbZtS0owCYZIlVYYSVwkg687rK3D?=
 =?us-ascii?Q?fLQYR7nkCBPOQPSinuUdCh1OtGyZelsMUTiHf1hFWiTFfOXy8+GUPZSKLVNZ?=
 =?us-ascii?Q?7dLmgeRMVET/9/4iDt91Cvq1JoXt59TQysYBtV3U4rjNHRIipqf4147j6svk?=
 =?us-ascii?Q?btwVhXO1EwKvGDa3N+n0VO0C2NZaKbp/zsSWIt7TdJgQU/QMt8dQDrmBf2iH?=
 =?us-ascii?Q?MNnMcip0xbbu/uQdQpUBBuLG0SoEQZHZ0dQdm7Po4pRtz+UZVPJBfyJVm6l5?=
 =?us-ascii?Q?7+db/Xyln2rDL3l3APaKjUnzA1x0dUQcPDx+835443mwHmvC57mN471iSZ+5?=
 =?us-ascii?Q?lWUs9nluwE1ABZ/pm6ni5SwCs4c1jBLFkppW5vcCGpnT2WkMccgg0W4Nq6MB?=
 =?us-ascii?Q?1BtKuqxvn6J9ZT0U9FR1dS8Ut77mFX8kp5JISt6n2Em9VzlvFoX7NjloDhBf?=
 =?us-ascii?Q?fOf9aIavBSSA4lmZtngfOS+UToM2Zjdf0++6b2Wu7E582GmUyTNqeI6msItR?=
 =?us-ascii?Q?gzltDW62SuTwNk79PJM01I4YonSzZrm+jYl0H1U9DAIMo6VoDOik4osOq5wg?=
 =?us-ascii?Q?DqB8XT6ec2wzjn7wf1S0lT9mgQipgfHjjcfep3emafe+NfbuyJkrjaK7DGA/?=
 =?us-ascii?Q?K8O75jouPtPHOMPNQV3DiugMfwOMBDwddMfn6oHj7c2da7a8EMNz3QRH7m8X?=
 =?us-ascii?Q?wqwWNFUeGiroH5sexhwELalmStWt5qS+doowp5Vj/wjIoujAfNZ/1IAncuc1?=
 =?us-ascii?Q?4k/SpGBMKfnUGyR3vioMOvubTr+heDp2JDVq6D1PCSrxm3QLBqCJjUxbqBVN?=
 =?us-ascii?Q?O7+jFTVodylOMl7D0CIFT7P1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <623939E04067FD4B86620A32D34E57A5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d675afe-86cc-42d7-1458-08d929d9c7ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 17:29:18.3145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/otbj/6Vh4d9Y/jEZ30+ulz1FHc44LHGqJ05NI2GMuiI81lqIfzIbhdjcMGrDui+XSmA/xTHcE7MglE1j/ZBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2520
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=793 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070122
X-Proofpoint-ORIG-GUID: CBkVHm0n6mcruU48NqiTIuxQFlpYI1WE
X-Proofpoint-GUID: CBkVHm0n6mcruU48NqiTIuxQFlpYI1WE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 7, 2021, at 11:25 AM, Alexander Ahring Oder Aring <aahringo@redhat=
.com> wrote:
>=20
> Hi,
>=20
> as I notice there exists several quic user space implementations, is
> there any interest or process of doing an in-kernel implementation? I
> am asking because I would like to try out quic with an in-kernel
> application protocol like DLM. Besides DLM I've heard that the SMB
> community is also interested into such implementation.

The NFS community has standardized RPC-over-TLS as part of an
effort to prepare for running NFS on QUIC transports.

https://datatracker.ietf.org/doc/draft-ietf-nfsv4-rpc-tls/

Towards that end, an in-kernel QUIC would need a way to perform
transport security handshakes. Tempesta has one we are looking
closely at -- it can support both TLS and QUIC.

There's more work to be done to address the ways in which QUIC
is different than existing transports (eg. its support for
streams and transactions); however if Linux were to gain an
in-kernel QUIC implementation, there is interest in seeing NFS
use it.


--
Chuck Lever



