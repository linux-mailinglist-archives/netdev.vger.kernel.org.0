Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A8E6BD6C1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCPRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPRLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:11:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C6FA2F24;
        Thu, 16 Mar 2023 10:11:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GFdLSo018285;
        Thu, 16 Mar 2023 17:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xi22yca+y4L4hzm6HJcuSj5NNWthmqMhyvvKdNDRwbE=;
 b=f7tUez4Cl3OV+FQfzOlRdYOCK/ycKHnSuWwDwAgc/ChNBO2YHPlAeXHxWDj347cw8YyQ
 BtOVmU9Rkf51EBb7zhM6c31QuIaVPzgcdxM0AVSYVDP2eTswa3VEL6eZGS+h/sOq903n
 LGj/yWIFpMP7RJX45g+WpFBuzlHMKKjnkK1XJMk+vmUkiYyPsXC+7ppRCgE6rXSFXjjY
 sfr9yhLdFJvKSEWxYPA5dwkASMdFSWawkqcOJEjcmY0Y2CdIQdoc/nQDhXoWc2sBoD3H
 MjkUF1T6Ss2rjYqOxpHNl/AaA5yCFmEG+YLmgQ+RicemL92chwNZoiianGyxGktm+B5c aw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29hs88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 17:10:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GGIlYc019330;
        Thu, 16 Mar 2023 17:10:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46mayx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 17:10:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrxCCMwCatN6pP0PNGYelqSzY0lQsgtVQp4yMhMEfCs/hDQC/Lc3fl4BTxwZjkz2QVtSVA3kE0kg9nUzE72+DgF31o3WDjxoSEG/Sb/rL4rWCIKr7T/bbkG/jZ0j2CjAYcvxMpGUQhvIaPgnyXL5cMvmdopDp1vxEyQS7F6jwBAT6lRSPyryYyfpo7DQdvX51mYOdZ4/4XKfBqfAZpGgUzggxtck7dRzNfzEGiiipwhRoQti6mgOjDS3HaLX/2w+wzqmD4BSRcYgo8KccDMxozjW+ExblpLrGOJDGrrBlo4vEEoGGO00wSRyIfJNsJz6cuErBcxxu0EosG8h6hkV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xi22yca+y4L4hzm6HJcuSj5NNWthmqMhyvvKdNDRwbE=;
 b=EJ6d1UBjKBCOgr41N8igJA3nKTyD/FO8kc4el0Pkorwp7GOQT7yWO/6TujkULu0urhBh4nyF+tBmmb4eTwcXVCtBg/KH9FDaRhI2mb5sDGpcaW5X6EEEKRhsxBsk+3EpgV+nbCAVeGB0c8CjovJqeGOt+HrYCPpiOCvDEHd5LoiRGpUzD/lZCpVMxA4yuuuAt3bLVHv3x3jCwPDfDve4GRJybD9Otc3TRPOrVIH+ttEIMqa6jFrp/Ug1tKW8ToBFXk9NblhUB26VzNpg6eSxswiGBRsjd6cUkkjAMQ/8VROUIMPPIThLWscaQ59ZsmVzQhDGG0kA1XsZXZPaIjDPBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi22yca+y4L4hzm6HJcuSj5NNWthmqMhyvvKdNDRwbE=;
 b=ze1dSyLA7yZA9o7ukggQx4+xcgpN9kQAULMDYYWZqGbWa6lc5q8rddSKaARCw6VTwD/kkDRas7juL2NdVFgnoGt9tDRgQ5Lal2/3Q2pfIqPxxBi8WxTprDJXJ+RlzhuKoi81F7b5dxqPxFVXUYyBGk7LunlgNnml8fZGii231gw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7214.namprd10.prod.outlook.com (2603:10b6:208:3f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 17:10:21 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 17:10:21 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Trond Myklebust <trondmy@hammerspace.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Index: AQHZWBvb8HUJFMz1IUqxVqJkfhIVpa79lX8AgAAOqoA=
Date:   Thu, 16 Mar 2023 17:10:21 +0000
Message-ID: <4EDC79DC-0C32-40FD-9C35-164C7A077922@oracle.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
In-Reply-To: <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB7214:EE_
x-ms-office365-filtering-correlation-id: 11a2a04c-332d-45b4-e6a7-08db2641537a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJRIS6iFNLPXedEfYcDqLcC/QA6MdcNJI/j/PVel4KWmGztJpQpMC8GiPVkGn203/OpYi1g+0dn3K0eeZXv1RMw6/QuWMCGjS/YdMthoGSYyiORiq0SXCPPpOcP1Li0bC3MmVOmsNjPw+W5n7UvjzadXRp4/A/4wv5bc6XId/IX/ivno6ZP0cXwT8kDfY/WeEdIDIxeBD+eIxPsGChcw2am2sfaIa7tMMj9/RM+DZy6LxVZAu7mvFF+XsIPY7djfjO0QVfEzxOWs6ufilVO0YW1VwxT642iay4UW1KvvRCYbMrtkfHZzFB86rVWTT4PBcn9cKPmN6nN2E9+bd5gW+tzuqjDqTvmuDHnzpSwqrU2dvzhbYW1vLR80qqy70LUF7jPhzLLU1R5pYxrHU3+i4h5/Dy2x7flKdYY/vm11bi+G+EMhHf/CEDmsR1bMqHHQAEx7vtwifVjbrsgKbwMJk+v8WHigX3FfPw0tJm3ZpBSODmNZJRNc/Ifrrh5FmTolKNVqnZkRiBnyA1np7kH9G6DXat1Y+cmQfJ0EE9sss5o9cRacX8i+6wWFL3aD3wVUoyj8VpBfpdV2eu7eXUeRVytWeIcNAGf6mGDPI9SizbmgMHtHfo/IZqHHqPQ+coJzwucfF0MjdrLNkD6Bh7FcP2rmWgEpIKzK7iRcg7n/ha3dLZrAxAuKLTvi4NxWK2pcfKTZ3RcR7TDvg/vo3ANxTSLrel+TA5uyQX7jaPdQJVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(4326008)(6916009)(41300700001)(91956017)(6506007)(6512007)(26005)(38100700002)(2906002)(8676002)(76116006)(64756008)(66556008)(66476007)(66446008)(66946007)(2616005)(8936002)(5660300002)(7416002)(186003)(316002)(83380400001)(478600001)(38070700005)(53546011)(122000001)(36756003)(86362001)(71200400001)(6486002)(54906003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LgwKr7i4bYZW2PhXFmdg5xB+D6vxOP4q4+6W20fNDkHMUxKgdrWDOU5Dn6Ac?=
 =?us-ascii?Q?m6rD8UcAahVDypqrJHRxrF1DTxEAm15EdX/NhsunyWroAnQSIqFDMeAJNOpy?=
 =?us-ascii?Q?Zh1qy8kCfF0ppE0aosKBq/GifHSJlnmgkg5GTYe3CIgMBD9pQEbz01mUl/77?=
 =?us-ascii?Q?5e5ZmlbJKiWBvIFVh0An6Ac7gGCHlzS3npP/Hx23nxTuthbtSRqMG2MXMoiu?=
 =?us-ascii?Q?umECE1h1tAVPKk88qfEU8ZLxFUk5meq8HWCg6gH/+tah+5Kpj8cZNkjUVYAl?=
 =?us-ascii?Q?WnAplfoBvnk/gpYCHVj/8kLNYB87UaIol3qkyxJ2vtcE+a3ZHl5CYN+lrQ1e?=
 =?us-ascii?Q?cLYbHsg6X8nBB1Lc1Zkq3964PNFORxa28WeSUAUMAZ1DbMHATpRxK1wZcs34?=
 =?us-ascii?Q?IsMO2v9COoEBLiERTvzpLdi4i4PF8p+Z40VxDX2IRJYnd7QAJkIQkegLkCZE?=
 =?us-ascii?Q?V9iAMh3bg9Gsd7aB6+KmKEOr+xX3HOiBPTBzqpQeD2oXNZjdzMn2gKHY7IqX?=
 =?us-ascii?Q?4uiQIpMZRjeC4uK5I6UMuteVx1WXHNEhH8xcXcJqSEAq1K+yU2LyVzracL4v?=
 =?us-ascii?Q?f1dM9dst7kkjtUuHT2OTO2yAO2pQu/rcfcDEwLmb74WrW25ixRD8+I/wH1KE?=
 =?us-ascii?Q?+qNNoZcStKTaJ3ibCs1FSS0OY+C2M1iY1BqdcRvBn3/SzEzJFuJUq5NiERbR?=
 =?us-ascii?Q?3pL2JeMqC+HEAXIXc05j3ECBQw6OEh2XAxPp0SHhiX2dyu8jefBqLQMorMIN?=
 =?us-ascii?Q?6yz9x2P5gnu5F9ebJL7c6ozJCRXj6Md2UklkUzDfc0wpWg1uHqmMilKpZ/dD?=
 =?us-ascii?Q?j5saYxuOSfrJgYwcMX0IZ6Yuze8Iiy6Ag7siqkvM2oEUoPXv65d6hO8soDA/?=
 =?us-ascii?Q?O3X6YGTumFAXId+QJtuiXhI9hzOMdp9uNc+ybkPumE/xD2fblNRBoXLkBSn1?=
 =?us-ascii?Q?vga93hVvGaRB58a/IQkRYYgNk5hbbxKG/4ZliDPq7jUeekqqVUJVJv/rh8Rt?=
 =?us-ascii?Q?X9uv76+uHombfN4Ar5EoBGjUKFgTo2uu6B3fz3y8T7KMpfBS3x4DtL+XGxN7?=
 =?us-ascii?Q?vUjBmQhoSxDMoKZCqL2N/dhNfUHyuO50fCmy/drC1eCsbEpga63PTkdDqs9B?=
 =?us-ascii?Q?k+MSEib0xOAHZqTGlgAWuMWRWf16zIfp6STZgwuudLYsAVbUxkHmnwTCL9R9?=
 =?us-ascii?Q?5NW/sD9TJHTgv8wFODsqKhJT6sdnbK/T0ORnTT68bdMKQk/kyJQgeorbY2OR?=
 =?us-ascii?Q?XfdGvaTGX7u1dThHHaT/7L/xwoBDYhVXHA4KXQYcT9aSkQgn/tpWMVzMKoqK?=
 =?us-ascii?Q?KsT9L+wAItQeVRMNfj2FmKKJxsFHs5qz4ASxwhnIEo3+n0pdOoycQpZqbhvW?=
 =?us-ascii?Q?BKFXRcxOaIOYK5nfo3quxclejxlYM1SWjq3+SuzJ3nwb1Cy/E2dlrXzygp1z?=
 =?us-ascii?Q?Rckbd7YFhW/NVir42/xAkrH8KKShV42Eqamrga7GQQGt9FLIL2ardM8N2krl?=
 =?us-ascii?Q?c6vj2+DSnTZdJ40LAeLcVAmUM9uxAv85MXAzetiCjyAlp/CHuRJsqGlTBJWT?=
 =?us-ascii?Q?a1D51lBnkgSi1A56z1LTh2Faq1TeKGxRWLAWV2t0sQO6+xKuba3VxDVh/4GD?=
 =?us-ascii?Q?8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F37389682BD3E8419A3AF59474B1447E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?45/AhMxVVjojELYsVAW9qVHnRuLvgZdfOlbTl9ZSDm9irlXC7y3flTQJjZau?=
 =?us-ascii?Q?G7UcaLpXOQkzmtrZ1/iOTjbursBfd1OXV1LiTxuE0T+kzO/QhzFESH5EjKkq?=
 =?us-ascii?Q?MWMDock0cx/7cLn2K5UAg7NVY9rpSWmu22zJC/BpZaZkK5ENYEuBgBc9v7in?=
 =?us-ascii?Q?na8lkYs5pgxxIs056wV+D06q4rvodOJEwZLDlDe5IlFhy4sAwWwi3q91PqqQ?=
 =?us-ascii?Q?lhACOq4hHP6dAbPA8k2yFYFiGOEirQdPmtBeC8vexkN5qAMb3nwS0DAYRVip?=
 =?us-ascii?Q?JKDVw/1kSdquDffOAlAyOMG4IGsIRAWCQzb+XLep9cXGfJxINiHOY5OVi8Zm?=
 =?us-ascii?Q?vbEa2oGFDzR5jGNJC+0O8LarAwGHYufiWrzHokvPH8DlZmY7gqklm+fT8QAm?=
 =?us-ascii?Q?JlefhPCrlWh4oycncZ1EJsOPEmbHjJH87OmSCfMXYHF8falnnuqNnf21RrQN?=
 =?us-ascii?Q?brqca7qBRP9HpGbQtXx6T/rd13OFm9jpeZvFEH6cuqxYCeLCeOFrXkWp+a6Y?=
 =?us-ascii?Q?V42XfC0U85k6OI8eG0UqOX8DPQPUwcTDMx6SFnIzr9N/ukUWSo4hU2v8+TPG?=
 =?us-ascii?Q?1Vi9kxU3g2hFVuDT5W828ZZzV4uzypO7STAdu06DZjbwI16pAmziBJ9llKki?=
 =?us-ascii?Q?L0i2IQidqYVy1NG6OD3wlOA049oeJNyK4X3uGOuZeP6TKiWkEdg/C+snWoy/?=
 =?us-ascii?Q?uj3MyMldb0nTwDr+90QcO4LDDAnCr2Es2yug3Ai8zNlKw1sG6ymN/Zf2cp79?=
 =?us-ascii?Q?V36qigg8nVP3jcE5TfiUhoIKhqGmTFmcyaJw1OOGGiqlZ4cGfbC5YLG7FgA0?=
 =?us-ascii?Q?8oCvcZ4thHGdbksHURHFH0HVUbS6jTlE44hNW5t35Cub8Z2+H18T380Phz+z?=
 =?us-ascii?Q?xkBifXiQZaX7669yh6bbky6q4LSjAxzf0+PWoa1LJrm/FFgjGaFlsiFOZrwY?=
 =?us-ascii?Q?BH6kcT73H/eCRRBaTYk+HOVE/zxaYhxKgvrMmPkOoQbnZRq41CgrqIT1mmmb?=
 =?us-ascii?Q?IlhI3KuMHbap5SZqq8W+f/F/5NXN4gZtAUsVKN7gosfeF1RR9Ecd7M/z8D6n?=
 =?us-ascii?Q?AwnJnh+pfJ5tW4sUfGZkri6PcM0KZGbN9jB4H3jj558vvh7/Fxv2zmyG82gS?=
 =?us-ascii?Q?60ST69eUFRdr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a2a04c-332d-45b4-e6a7-08db2641537a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 17:10:21.7725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OAM2qW/bvB/GpFxrgzsEaUPHRG1ugcmEarzAFfR/niuj+Zh0s/LgioieikIPApmLSt4dBUo07czLnyXLMIQbwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_10,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160133
X-Proofpoint-ORIG-GUID: QjBZJctWVS7EY3ASdOx8UAxuKdil5GW1
X-Proofpoint-GUID: QjBZJctWVS7EY3ASdOx8UAxuKdil5GW1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Note: this is the first I've seen of this series -- not sure why
I never received any of these patches.

That means I haven't seen the cover letter and do not have any
context for this proposed change.


> On Mar 16, 2023, at 12:17 PM, Trond Myklebust <trondmy@hammerspace.com> w=
rote:
>=20
>> On Mar 16, 2023, at 11:26, David Howells <dhowells@redhat.com> wrote:
>>=20
>> When transmitting data, call down into TCP using a single sendmsg with
>> MSG_SPLICE_PAGES to indicate that content should be spliced rather than
>> performing several sendmsg and sendpage calls to transmit header, data
>> pages and trailer.

We've tried combining the sendpages calls in here before. It
results in a significant and measurable performance regression.
See:

da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg for socket sen=
ds")

and it's subsequent revert:

4a85a6a3320b ("SUNRPC: Handle TCP socket sends with kernel_sendpage() again=
")


Therefore, this kind of change needs to be accompanied by both
benchmark results and some field testing to convince me it won't
cause harm.

Also, I'd rather see struct xdr_buf changed to /replace/ the
head/pagevec/tail arrangement with bvecs before we do this
kind of overhaul.

And, we have to make certain that this doesn't break operation
with kTLS sockets... do they support MSG_SPLICE_PAGES ?


>> To make this work, the data is assembled in a bio_vec array and attached=
 to
>> a BVEC-type iterator.  The bio_vec array has two extra slots before the
>> first for headers and one after the last for a trailer.  The headers and
>> trailer are copied into memory acquired from zcopy_alloc() which just
>> breaks a page up into small pieces that can be freed with put_page().
>>=20
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> cc: Trond Myklebust <trond.myklebust@hammerspace.com>
>> cc: Anna Schumaker <anna@kernel.org>
>> cc: Chuck Lever <chuck.lever@oracle.com>
>> cc: Jeff Layton <jlayton@kernel.org>
>> cc: "David S. Miller" <davem@davemloft.net>
>> cc: Eric Dumazet <edumazet@google.com>
>> cc: Jakub Kicinski <kuba@kernel.org>
>> cc: Paolo Abeni <pabeni@redhat.com>
>> cc: Jens Axboe <axboe@kernel.dk>
>> cc: Matthew Wilcox <willy@infradead.org>
>> cc: linux-nfs@vger.kernel.org
>> cc: netdev@vger.kernel.org
>> ---
>> net/sunrpc/svcsock.c | 70 ++++++++++++--------------------------------
>> net/sunrpc/xdr.c     | 24 ++++++++++++---
>> 2 files changed, 38 insertions(+), 56 deletions(-)
>>=20
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index 03a4f5615086..1fa41ddbc40e 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -36,6 +36,7 @@
>> #include <linux/skbuff.h>
>> #include <linux/file.h>
>> #include <linux/freezer.h>
>> +#include <linux/zcopy_alloc.h>
>> #include <net/sock.h>
>> #include <net/checksum.h>
>> #include <net/ip.h>
>> @@ -1060,16 +1061,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqst=
p)
>> return 0; /* record not complete */
>> }
>>=20
>> -static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *ve=
c,
>> -      int flags)
>> -{
>> - return kernel_sendpage(sock, virt_to_page(vec->iov_base),
>> -       offset_in_page(vec->iov_base),
>> -       vec->iov_len, flags);
>> -}
>> -
>> /*
>> - * kernel_sendpage() is used exclusively to reduce the number of
>> + * MSG_SPLICE_PAGES is used exclusively to reduce the number of
>> * copy operations in this path. Therefore the caller must ensure
>> * that the pages backing @xdr are unchanging.
>> *
>> @@ -1081,65 +1074,38 @@ static int svc_tcp_sendmsg(struct socket *sock, =
struct xdr_buf *xdr,
>> {
>> const struct kvec *head =3D xdr->head;
>> const struct kvec *tail =3D xdr->tail;
>> - struct kvec rm =3D {
>> - .iov_base =3D &marker,
>> - .iov_len =3D sizeof(marker),
>> - };
>> struct msghdr msg =3D {
>> - .msg_flags =3D 0,
>> + .msg_flags =3D MSG_SPLICE_PAGES,
>> };
>> - int ret;
>> + int ret, n =3D xdr_buf_pagecount(xdr), size;
>>=20
>> *sentp =3D 0;
>> ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
>> if (ret < 0)
>> return ret;
>>=20
>> - ret =3D kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
>> + ret =3D zcopy_memdup(sizeof(marker), &marker, &xdr->bvec[-2], GFP_KERN=
EL);
>> if (ret < 0)
>> return ret;
>> - *sentp +=3D ret;
>> - if (ret !=3D rm.iov_len)
>> - return -EAGAIN;
>>=20
>> - ret =3D svc_tcp_send_kvec(sock, head, 0);
>> + ret =3D zcopy_memdup(head->iov_len, head->iov_base, &xdr->bvec[-1], GF=
P_KERNEL);
>> if (ret < 0)
>> return ret;
>> - *sentp +=3D ret;
>> - if (ret !=3D head->iov_len)
>> - goto out;
>>=20
>> - if (xdr->page_len) {
>> - unsigned int offset, len, remaining;
>> - struct bio_vec *bvec;
>> -
>> - bvec =3D xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
>> - offset =3D offset_in_page(xdr->page_base);
>> - remaining =3D xdr->page_len;
>> - while (remaining > 0) {
>> - len =3D min(remaining, bvec->bv_len - offset);
>> - ret =3D kernel_sendpage(sock, bvec->bv_page,
>> -      bvec->bv_offset + offset,
>> -      len, 0);
>> - if (ret < 0)
>> - return ret;
>> - *sentp +=3D ret;
>> - if (ret !=3D len)
>> - goto out;
>> - remaining -=3D len;
>> - offset =3D 0;
>> - bvec++;
>> - }
>> - }
>> + ret =3D zcopy_memdup(tail->iov_len, tail->iov_base, &xdr->bvec[n], GFP=
_KERNEL);
>> + if (ret < 0)
>> + return ret;
>>=20
>> - if (tail->iov_len) {
>> - ret =3D svc_tcp_send_kvec(sock, tail, 0);
>> - if (ret < 0)
>> - return ret;
>> - *sentp +=3D ret;
>> - }
>> + size =3D sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_le=
n;
>> + iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec - 2, n + 3, size);
>>=20
>> -out:
>> + ret =3D sock_sendmsg(sock, &msg);
>> + if (ret < 0)
>> + return ret;
>> + if (ret > 0)
>> + *sentp =3D ret;
>> + if (ret !=3D size)
>> + return -EAGAIN;
>> return 0;
>> }
>>=20
>> diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
>> index 36835b2f5446..6dff0b4f17b8 100644
>> --- a/net/sunrpc/xdr.c
>> +++ b/net/sunrpc/xdr.c
>> @@ -145,14 +145,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
>> {
>> size_t i, n =3D xdr_buf_pagecount(buf);
>>=20
>> - if (n !=3D 0 && buf->bvec =3D=3D NULL) {
>> - buf->bvec =3D kmalloc_array(n, sizeof(buf->bvec[0]), gfp);
>> + if (buf->bvec =3D=3D NULL) {
>> + /* Allow for two headers and a trailer to be attached */
>> + buf->bvec =3D kmalloc_array(n + 3, sizeof(buf->bvec[0]), gfp);
>> if (!buf->bvec)
>> return -ENOMEM;
>> + buf->bvec +=3D 2;
>> + buf->bvec[-2].bv_page =3D NULL;
>> + buf->bvec[-1].bv_page =3D NULL;
>=20
> NACK.
>=20
>> for (i =3D 0; i < n; i++) {
>> bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
>>     0);
>> }
>> + buf->bvec[n].bv_page =3D NULL;
>> }
>> return 0;
>> }
>> @@ -160,8 +165,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
>> void
>> xdr_free_bvec(struct xdr_buf *buf)
>> {
>> - kfree(buf->bvec);
>> - buf->bvec =3D NULL;
>> + if (buf->bvec) {
>> + size_t n =3D xdr_buf_pagecount(buf);
>> +
>> + if (buf->bvec[-2].bv_page)
>> + put_page(buf->bvec[-2].bv_page);
>> + if (buf->bvec[-1].bv_page)
>> + put_page(buf->bvec[-1].bv_page);
>> + if (buf->bvec[n].bv_page)
>> + put_page(buf->bvec[n].bv_page);
>> + buf->bvec -=3D 2;
>> + kfree(buf->bvec);
>> + buf->bvec =3D NULL;
>> + }
>> }
>>=20
>> /**
>>=20
>=20

--
Chuck Lever


