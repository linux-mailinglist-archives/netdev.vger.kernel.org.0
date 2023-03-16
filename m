Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75786BD757
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCPRnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCPRnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:43:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2780CA8C57;
        Thu, 16 Mar 2023 10:42:32 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GFnWdI021189;
        Thu, 16 Mar 2023 17:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jGB/FkAnPe9ENlI2ASps1V/FiNAsmknzdcj1LnGZfbQ=;
 b=Qo5rEwfQGchTba6HrjivT/nAgBFiU0/BuBhvEjCF00nDBEjRRb3wnAiW32oc/Ry7eGpI
 j+cnqZjR8V+BmKE+UuokweIHdrlcPjAf61/t8zbJ9+Ok2hakRAPiPscBgjKE6y61kHnp
 XO1NEuhy6uqqKrw3WXDL6KCYEEPs76bJJQAYtHXGtRjELqSBFuOBBU90Ldzt/Rul3T8X
 8SdHDJ1J4eGDAFEveYXHzTQ7PQeDm7O57dR1qpdICf4iRJpUYne4+x/LQGJUsQzJuA/F
 JweVa3OzmEZgVLZeIaQekWXivldMYDavQXVfrZcXXw9g4oPPSDnmL3QNPY84TaBxLCBE ZA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs299u31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 17:41:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GGKcKe002987;
        Thu, 16 Mar 2023 17:41:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq455pdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 17:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGkd5H07eW7DZyl8e2ffQvjjXzL/vnIE25j5KMpdzjh5/ZpRXuvNokcoLCc7xNcJRZC0Ue1xoRG9dVBpUORntpFjwBhgWlgH3VirAcrQt2tiC4lOykobQGSE0nOuTJawiIlyTPHBx7gLlfF7GHi7/um1sK2PFOIho8PrcNbsCV5upTimXRsVgroidU5TsHvOIhU8p4HLempfIOPyUC/ovZwvIHw+hHBWj4vwH0ADr/U38Y5VZRTpzyQKYuNRuvec3V20OSIIi0oLYgURCCrCHYOH9N9Q18ZkoOId2pIHHC2lFNSGBCq4fphYjKsjETRGDcp1eAmDQVwVjYFM8HhJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGB/FkAnPe9ENlI2ASps1V/FiNAsmknzdcj1LnGZfbQ=;
 b=lEq5ZUX7QblWtMRZpoEcoi+FeFI/2VBoH0HlLYWnMsuy2dZY4JIf09trnGaZ/QnksqlPR+MoxCl+k4ehqeD7HsrE0Wg0VeiUrHmItG75+iH85I99hMrmJ2gpDJjGb53dkqgoQHghZsVqd8/OJIrR8OvWmrhwZI35sSjN1vyy38KRee1rt/ty8RNHY2hVpNoumyGnNDeCgOzuGryJ7kYoNyJEZnGT4/mb3756bx8jLKtOUk00TVHJwr+3lPgHgu24qpa3JLdLw+e26GI4ft+Kh53e6vAwXAbzqAkIMvf0jnH0pZ9fF2jzbidyQRhuMm1xQqeQBiwVAZxV1BBZQWhyWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGB/FkAnPe9ENlI2ASps1V/FiNAsmknzdcj1LnGZfbQ=;
 b=ioqgrVjhoJBXDXvegzMH+/jqn2U0U0cHYw4YPeudpXOmsvUEFbn7Z/UtCbELCPji1BjEkAoOSkHLy9hltHllGdrG86tIa0wkO+q4UqEoCxqhYlLggrahkA5cmMBB6rBgzPZmGRaLW9Tn4HHoPuFs+QidKBC0C4lVMjRYdtaFsY4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO6PR10MB5601.namprd10.prod.outlook.com (2603:10b6:303:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 17:41:45 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 17:41:45 +0000
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
Thread-Index: AQHZWBvb8HUJFMz1IUqxVqJkfhIVpa79lX8AgAAOqoCAAATxAIAAA9QA
Date:   Thu, 16 Mar 2023 17:41:44 +0000
Message-ID: <3B4C4D62-E80E-4921-BA7A-1A157942159F@oracle.com>
References: <4EDC79DC-0C32-40FD-9C35-164C7A077922@oracle.com>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
 <782776.1678987682@warthog.procyon.org.uk>
In-Reply-To: <782776.1678987682@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CO6PR10MB5601:EE_
x-ms-office365-filtering-correlation-id: c46b0f9f-ad5e-414b-8e74-08db2645b5f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +bj1/soTC2Qv7o3kGr1Ho3W8BqL22kbsLDPkuxM1vo7VKPq7/Nap47Sf/xHxRMhm6L2LNvf5yFVPg8W8g8cZx/KGLHIfnNMGTfnWH5wAK+GGKjJ9fY/vN+7Rb4WyHtgmZbSpJjOZMwNgRU0UmM7xQ25ItP4lMQnysGlhiO9/BSinpNwyLZlJAcY1AYLZfGaIo2ipa/HQ5p9z6/T6fdn1TdnRMgy4W1ZLwhY6ZkB+Wg9bVjNqn6J6AG9Zkmhp8A1K3c9GXGcOighcB202LVKC608gHwwPpg3KECrMtje0LBzC99qWMdooqzMJwiIOFYazUyEqJYRsA7pS11H3/PWgNck84AMe0pAssUxvfDlCFbOB2TGHef02nqBOKpHOpt1zMHxTwbWm8dhkAPYH8BoXvTlMXzZmTqsa7dI/kNbOUpogQPPozkYupl5mkPgmRGv17iXahCdv3ooXm2qmiOG14NenneLNwPrEh1+bNLnUOXH2jrnah2BD7aLX97Zp1pW4Ux8qCwW5VS0mpAt+KuZsrqlOSKhWUYp1e7EJ3ZoIboLck7eav2P/zVRIeXM9o2FRt6wI9MCrSx3GywmKVqUqbVzwfIWmog4ULtwmfx8B9M98tOk1lXfJnhcxspjUfWqC2Yr9mGDwpknsrJx16UMpTFMa7vGowHrsHrC7vuH9Y9iyZ+KqgVmQ520FEhHy6x0hF/hBoWOoRGojUjgPAd1WQMwTjI6viNhAqNoy1NyaAESJttwWYE2UGaIGASD8zf8Rct27K4WURRBEqs93Ez5tHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199018)(5660300002)(7416002)(86362001)(186003)(64756008)(66446008)(316002)(83380400001)(33656002)(6486002)(2616005)(478600001)(966005)(6512007)(71200400001)(26005)(53546011)(6506007)(66946007)(8936002)(6916009)(76116006)(4326008)(66476007)(38100700002)(41300700001)(38070700005)(66556008)(54906003)(8676002)(91956017)(36756003)(2906002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?597/+C9FvRu6mZIiSFPlRarAypaBPh9scTek/cT2bYrP7z4Cxq0ZonP2bkiR?=
 =?us-ascii?Q?E/3fRxeuFtB0cKoxZ0IzubXEcTRjfnPG7qIdZ5seW90udd6C74mn1OJwm1Yf?=
 =?us-ascii?Q?JG0HhCD8xlL/KM0iKll7vuSaIx60JOonh+uzl5PyZtkFxnDnfM+VyAql7kOS?=
 =?us-ascii?Q?LyFKhSfWjxxcqatKx889rHDzrhi1dAMk+9Oy7gehxUUBjco/o7C8kQMFT+9v?=
 =?us-ascii?Q?z4MLeyTQeKtM7G+0Ug3Oq8J549DgKycwaULBK1VJ6fGr0g31FlLQWRqs25oy?=
 =?us-ascii?Q?RgFYFtlp2UfN1I7C7J8hh63p0bx1xFHuFaJAvhQJ63fDFEwi1tqt+KB7yTJ2?=
 =?us-ascii?Q?d9PTcBXeb10LT0RHXxloUOpAi55c9vOlCMy6Ny1Z/ywe/13iTcmFiA8vAkTs?=
 =?us-ascii?Q?jIs8N8ReuxC2HtqySEbKRMtWNirpBwz5YVE58g9ItJMkie8MJM5Km3dCL+bL?=
 =?us-ascii?Q?yf5SrOaJbxSdyug/x2D52EyHjA+Pds3xjtNhENwayyyvsWzSaozpQUXjoaE8?=
 =?us-ascii?Q?L/d+BdQXUHuoVzYVS0L0qP7fEGFdFl04YY/cf2HJTfs/tdRDZT16XiJxRDYW?=
 =?us-ascii?Q?x6JBpzbCeAKsaD/ASGEkcVXxVutgm84yiEmtAEKrVlspTvkTGNkZbp9O1GK5?=
 =?us-ascii?Q?mTkRJ8sa07DtFxjPXLj/2qdHqA3cgv0by/CYvDvFU7BeTXtACF9j51aJO8Tc?=
 =?us-ascii?Q?T9S9xHsS22PFzto2WcbfWdKKCarssx9761er+ap4y1i6Npi2/bi9I8hT4+1T?=
 =?us-ascii?Q?FcNVANDLuZzI41CYWiH+sEe4IQVNW+RXHQcqsGM/nbEJShNNbUP4v8Dzjjvi?=
 =?us-ascii?Q?uCO7/xp47pgC1KQmN089yJGUyY7MZqapUdd1QQ6qEeYNniYSe5pE/2KQBx3S?=
 =?us-ascii?Q?Vah34geziZdSxx85ioULRwaIF9HFW5S4txUSxEORM8g+pZXJNMpxDvqBp/zI?=
 =?us-ascii?Q?OUBRM6xbuv8InyBixf6/BIpkdxsNXIJktcDBuO251KKVHfcyfHr4GdXTNS9i?=
 =?us-ascii?Q?WmqNKRBXAOP+/FN6mqaFVzsoJ6x3QlMfBFOfVHOH3I3JxFyg2DrycTpVd/T0?=
 =?us-ascii?Q?9Tlmx80DR2hlucPng52FnneusT/Vr4iPL8dtcPcpljQd00IbNXpDDOdOcSeX?=
 =?us-ascii?Q?V2SSa4sX3+zfWbpBUT8Wf9xLrV+vPuqebCFC5uoO0OGCXYlQBtzhG9DQnyqW?=
 =?us-ascii?Q?t4YFVrnofgQ+h1mGOjwyMh50Aa10xG0a5gvJi3/akWiOcb4HFPjPu/uVbhJL?=
 =?us-ascii?Q?p2s48cCtUDMNYK1Y52ZfoG65r6E8ABUFi0ewHXItZXCtxVrKtGEZlF9U+Sf3?=
 =?us-ascii?Q?VuCAMw87jJ1JVUdSSVTm/p030q7IQG+Zy1aUoEtNvQqMErfa3ziW+K02ny5Y?=
 =?us-ascii?Q?IDHIgGOVOH9qzElOiExXG9RlIjKxDNKhxQJG018/sPORzTumaIS19nPdxbdR?=
 =?us-ascii?Q?GyWdPbiPXyETXOHJY2OXAF+8WgeKp+GyfcZIgVWDl9KqFY7ZA05FqWIqUUed?=
 =?us-ascii?Q?riwV0vv9NhQolUxDpIvOV60X3f/mw1AS4dYfuYSOXc/8+j9LSRim8WIwuEam?=
 =?us-ascii?Q?2giueN/+ufDfXW+JmeruBC10JQJoFr0U2AEZbOn3TJO7YqDwO1nZi0Ea5MjN?=
 =?us-ascii?Q?Og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74F46AD99C17A64089D3E271DEFED00B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?R3cY2oiLbu4VxaBriLREHRZ5Pgx6HFaVH3obzqGdrZfMIx+dCKv8C7mVpFxR?=
 =?us-ascii?Q?hzwPvq+shYC0pbjrFW31InH7Rg8UBhEEFuAtkjm57seIHO1ZA3Y1sztZ6+XO?=
 =?us-ascii?Q?J9XHU3iWCaE91rvKZiHxAiaC6n6nFbgZ1nwDXLrwueqnoXW5uNYlQLvpt6fi?=
 =?us-ascii?Q?/IMlDKN3+b95r5HI5A90J9W4uXOraOP0bSx66IYYFyoh1JHN0Hscvh2lyP6P?=
 =?us-ascii?Q?51S+ysYrff+237k9Ki5gxTYq5bH7TbnxvqHdDgMwhgfTTmzokZmZ4R8y52EJ?=
 =?us-ascii?Q?oR63wZB1TKzGOlTc8xdDKdqTToUYWpaj44y0UJBHA7QNXHHiMYA3WqrllBXm?=
 =?us-ascii?Q?p37K5UMXNKKieVVrGNrQ6GXjRKWQzBW0rPlKeY5/d//RgxGwyIyfghoHMPMi?=
 =?us-ascii?Q?jCa98u9upYsMkZe/b+db7fCdUs/oUPhzdULPRZ0+Wo9xbwN2/61VCsZsimM6?=
 =?us-ascii?Q?kz6hXDFsVJD0uWJ6XSyYW4TgJpKAWi/hTywu0cp2GuErTTyJWNcQ0O4Y4s97?=
 =?us-ascii?Q?+dlPfCTfNOkanIKzXEddkflENl22ZLeR5XwsrYDn4JA7sQ8PTe1FCQqoMezG?=
 =?us-ascii?Q?LVAbBflfKg55cmId1tlE9bWosdIVGc3D5grf0fD2rU6Oj8OyPq7Qsnb6YTQg?=
 =?us-ascii?Q?Dn712eVo6QNqL+CPyYB0zQCw21tgpRLaQrZ4CrOSD8cOVi6oBF8jwh+GlF6f?=
 =?us-ascii?Q?LEDjthxnhkq4nXl8ToNG4R9nYxBnWn5E3yGJfxLlQEJZikZbsoTlwv/ftFWD?=
 =?us-ascii?Q?KiqcwMQOxJLtF7JwJVttE4OJHig7WOV+uD8o+goSpzpcLKP3l5poiMpuJ4xE?=
 =?us-ascii?Q?Tvh27UvHaRUD1wlpnEkBbNPvUcQDgXcHUeHd+P3bDnh1RUF2IXg9efYTDIfb?=
 =?us-ascii?Q?jniE4/v7yR88pfQhmQ8x+OQu283x/JfMnu9/dmizHdKvnk/Kwx2gGQKQ8TAG?=
 =?us-ascii?Q?zmcjTIr0B+jZ50UZplg0IqUY0t/ZBPTu5iZE5pIWzdPc6Fzejt+lR2eIyXp1?=
 =?us-ascii?Q?+4kta2G89GH7FbajnqZ5OEU6LvjoFRavFE8JDRU73bfgCDMXQXUajU0hHOYy?=
 =?us-ascii?Q?/ozmFsr+7JcXCauLUQe5DTor06rmS2Z3VDHI452iiDdBG47VSfR9SRWm2fMW?=
 =?us-ascii?Q?GDvP1P1NZht5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c46b0f9f-ad5e-414b-8e74-08db2645b5f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 17:41:44.9454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7HEBxEpexi44uRLRbNZ/eOlAmUI3KUKMbDr+WhmQkQaE9It2JxfFRndj8jYmwnLx5AkSBvwyq2NMUVmRnZQfAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5601
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_11,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160136
X-Proofpoint-GUID: yshtJqeH0lvnnwn11PcA-h-W4fNd3Qeb
X-Proofpoint-ORIG-GUID: yshtJqeH0lvnnwn11PcA-h-W4fNd3Qeb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 16, 2023, at 1:28 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Chuck Lever III <chuck.lever@oracle.com> wrote:
>=20
>> That means I haven't seen the cover letter and do not have any
>> context for this proposed change.
>=20
> https://lore.kernel.org/linux-fsdevel/20230316152618.711970-1-dhowells@re=
dhat.com/
>=20
>> We've tried combining the sendpages calls in here before. It
>> results in a significant and measurable performance regression.
>> See:
>>=20
>> da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg for socket =
sends")
>=20
> The commit replaced the use of sendpage with sendmsg, but that took away =
the
> zerocopy aspect of sendpage.  The idea behind MSG_SPLICE_PAGES is that it
> allows you to do keep that.  I'll have to try reapplying this commit and
> adding the MSG_SPLICE_PAGES flag.

Note that, as Trond point out, NFSD can handle an NFS READ
request with either a splice actor or by copying through a
vector, depending on what the underlying filesystem can
support and whether we are using a security flavor that
requires stable pages. Grep for RQ_SPLICE_OK.

Eventually we want to make use of iomaps to ensure that
reading areas of a file that are not allocated on disk
does not trigger an extent allocation. Anna is working on
that, but I have no idea what it will look like. We can
talk more at LSF, if you'll both be around.

Also... I find I have to put back the use of MSG_MORE and
friends in here, otherwise kTLS will split each of these
kernel_sendsomething() calls into its own TLS record. This
code is likely going to look different after support for
RPC-with-TLS goes in.


>> Therefore, this kind of change needs to be accompanied by both
>> benchmark results and some field testing to convince me it won't
>> cause harm.
>=20
> Yep.
>=20
>> And, we have to make certain that this doesn't break operation
>> with kTLS sockets... do they support MSG_SPLICE_PAGES ?
>=20
> I haven't yet tackled AF_TLS, AF_KCM or AF_SMC as they seem significantly=
 more
> complex than TCP and UDP.  I thought I'd get some feedback on what I have
> before I tried my hand at those.

OK, I didn't mean AF_TLS, I meant the stuff under net/tls,
which is AF_INET[6] and TCP, but with a ULP in place. It's
got its own sendpage and sendmsg methods that choke when
an unrecognized MSG_ flag is present.

But OK, you're just asking for feedback, so I'll put my red
pencil down.


--
Chuck Lever


