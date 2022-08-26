Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8F5A22AB
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbiHZIMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbiHZIMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:12:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27B2D3ED7
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:12:32 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q1chAe020066;
        Fri, 26 Aug 2022 01:12:27 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j6fbn35x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 01:12:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjcD14O133nskB5BfDPmPK0hY8r1rsMzvCyxgOPjjIs2YgWuaT0Y3QIp/llY1LjlYJDIkNE8+ZEWumw7zokBe47v42NmvmlrZAbu1dXqR3owjVu8FsB34A97dU3jl1sPbRcJ8tsBc8+VGjouuw7gQeZb8wp67QKz/dWU4XbLzy6Jgmfr8pzZOiXJi+znY8T8PcYhuU/sG2j39H17hcIplgr8yNTHPTNP/jV+o4CRSGd3eEeAzKr3YLi8NMTSen95Kq4Ci2QSGOudo9iaD3IuLDF87+8Tj5eOQgTMpT/SoRDbjjMnH9VMQ2IS4jPWot46ZLfDpbH+8hWhjYJE1jvi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msEeHZLxQxqzmNSghj+hRuo73UqXDoLZnS+NhFKSVhM=;
 b=HqS7sPXX8MKErQQqCp5bwfgoiqfpa1yPQNKS018E5G3srcrhl8dZhuIIXHEt27oWrOxYMSIKHiVD0QOhaSE9ttYSFLZ5IoYV+gAjjyNxmNvL9iHpWX/94fWLI+FqYihlQxowYJv9eSMLo4ErUOjlB7kEso9j6S6omdYvJN133ROzpRkSpmtBiNz7bZ5gT2ATrbfx509moSfEcbxLhR3Pt9sndfgWUWPDNI0TxFoq49o0GL+i3BEvTg9S/Ukx9UI3sWCADzwqjDq9QKL/dqRVhNyuhA2Tq2kdKbAtCrgLHhvweHD6W/JB+7CfvpZ7FFQBw37MShJI966IPXCXWPNeAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msEeHZLxQxqzmNSghj+hRuo73UqXDoLZnS+NhFKSVhM=;
 b=SxPxF1M9Lz/yFrQZGx3y2aiN69fNL05QNBuYWdAAmssq2Svz6j2KA1AUajqpzweVnxW4iH4QfxqctdcQaY5pOzf+3BuY470q0EjrYwe2fBnqD1ZMVMt9/S4PzQMj+o4aSl+kVv5TDSD3xfYHO6DN4aJk4/Mpr+PH/fEHbh/f8As=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by BN6PR18MB1411.namprd18.prod.outlook.com (2603:10b6:404:f0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 08:12:25 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%5]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 08:12:25 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [net-next PATCH V3] octeontx2-pf: Add egress PFC
 support
Thread-Topic: [EXT] Re: [net-next PATCH V3] octeontx2-pf: Add egress PFC
 support
Thread-Index: AQHYuPdbb4kNaib4mUmbddoyIe8apK3ApUqggAAvvSA=
Date:   Fri, 26 Aug 2022 08:12:24 +0000
Message-ID: <SJ0PR18MB52167EC10DD811D6AB79A532DB759@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220825044242.1737126-1-sumang@marvell.com>
 <20220825195544.391577b2@kernel.org>
 <SJ0PR18MB52162AE97BF2AAAF06ECECD6DB759@SJ0PR18MB5216.namprd18.prod.outlook.com>
In-Reply-To: <SJ0PR18MB52162AE97BF2AAAF06ECECD6DB759@SJ0PR18MB5216.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f0d5fca-5912-4041-b8b7-08da873ab56d
x-ms-traffictypediagnostic: BN6PR18MB1411:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZW8O+gqyn+w0ORuXwWClbOXq281Z6pzrtk9M2F8FT3CJZ/RqZszkJhM68qeYTPxir7tTc0GDnhNjg80BBG9u9F6/68Zykekp8HHRuZoRk4PboCzigiTVlpQZJVfXy69K4pANct13VRmRzVn2xZ2psQUJk5DmGy0e8mof+KNFJEGZf7+GgEim0x3za8vYOARBiadNatlw4jrW+iuAA/pbCFdL0KtYww+fGxOW7ColaSzZ9ECK18cW852S5OWT9a5u3Ikvy9viDQhtUVbT0cuOvnXs7rHVN7ipNye7Rjb1IIrWmit3LuFflRAGhR4L1/Skvtsex3deBzsDA+LFHw5+eGby+RxE3XB2qYaTZtF07HvV6Y3/W05svwh6c0bRKcGL1C4ITotQ0fFCdeRdQok2RJmHhPAUTNJ/CvqxvIZtcC/+f42fKX7FUj44JZCEKbI+NzoyFWalD6bdX2M2+DoA3gkA+4D5nvlZNWjVCtKmnTZXrbOx1UZqIUJP8X/aiNKzUkOO9FCR2qXAMaGbaO9/ym0eRrT7XOvzeOV2mYRHKs1bcNUCCIZ5croziOMAcUW5KCp2V8WlAuq4l4HS5n1uk1obLd3BipN9vo93a1YZ96YqEQMUKT9Frc1VluDZZmySSnhg4fj7MlS9P+m/xqbUW3o2Qyou+ItG42svOUQkM6K7WdipH+bo6Jjnz6TfDLFWyULahr6v760r1jU5QDFlLP5LtNeEtNNzh/dgCxyHRdWvUvI6rLMGTZbyRryZIZ/ogl8BCFIXC5aXwcfLfXLyKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(122000001)(83380400001)(38070700005)(86362001)(38100700002)(76116006)(6916009)(316002)(54906003)(52536014)(2906002)(5660300002)(8936002)(8676002)(66556008)(66476007)(66446008)(64756008)(66946007)(4326008)(186003)(478600001)(7696005)(6506007)(26005)(71200400001)(41300700001)(55016003)(33656002)(2940100002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wu7e8qx3ZixKYsLtxeKuhTNssbUNA4LETqKMrKoy5gfasXBgZZJKVwHVdiaN?=
 =?us-ascii?Q?LdS2asn2fWxXy/eiw/dzrU+24KAwU3HaSNR6b+5lBGYH/+zDAse5vCfafIzF?=
 =?us-ascii?Q?rKtCxLLeWncC5Eu9IRu8F6OrVL1FcZm9W5x25cF7WTrtr4WOCjTxmetS/1X0?=
 =?us-ascii?Q?iKfc31b36xuLaOxY9RvSU03VhrxI+508nhWTeUoUJCodrNsyyu3bWDuqHCG4?=
 =?us-ascii?Q?NigLzlAbfjy+KTeuV+/b8+51pBx5i3I/Z66v1kvLEE/ItNRVqE9GfvXUMnTa?=
 =?us-ascii?Q?Wb0SHF5wTE2PIR5LyrZ52k2/yBsbNMr0KcNipdc8FnpMJYZ/nmJPioX8jXRD?=
 =?us-ascii?Q?u4ngzRDZHmfaBwU95TAQOMkWM7lzA7NmjYJlHDpxx8vAh0tJ7YjBUBYEiYqD?=
 =?us-ascii?Q?mfW/ZgqNTL4FCl19rr3dpsowppDcEYA1aCBEwCE904+aLjXlQYFNmVUwbPKz?=
 =?us-ascii?Q?H/CLuuQBWL7/P0fl+gWZMR4PQlXtvyv+Mfu0VIVKoJQSWbdZ9mTW0TuWjY4k?=
 =?us-ascii?Q?FQ1gEq7/ZfWFEWdsb/llQNEDfZvuIyo/ncEn+9OAWg9KC1l9XpKwSUJCEZMg?=
 =?us-ascii?Q?wx15oiUOZUx5pBzKK+PjpTByMyRE1EhGB/guaWY8liLQKZzq+vbVhKxyt3eE?=
 =?us-ascii?Q?h8kkPZ+itFTAuNSXilUyutZSMRuZnECBS3eQYq3rhMFcL+rsXjVrINR8jl/h?=
 =?us-ascii?Q?khFMnyD4GydG0luGD4JPScyOnc9R7SBjjnCl38RRWlztW4cU5wMZ8+bgCoej?=
 =?us-ascii?Q?TBtY49bdHPtdjNr/IjHJAOo6uMQwAAUF5WJj8aLnW4s2UqVpP1NuVLVQMv0N?=
 =?us-ascii?Q?BrgV31ZwcJvAICbxCJeyJrHpu4AVrBMs5+0R0TYiVV+xJfKEavSA3m+uN7dP?=
 =?us-ascii?Q?klPmfgIA+u3F8oJpj+IvwPiaYZc//SKf+yI3CtZoKj91e2uuyE7gAzYlzaMT?=
 =?us-ascii?Q?dIkhuCOnKKDw3qt/5iMj384NKiLtTNM+BN5gLCOGLBk56gWiJ4uWKRYmh6zH?=
 =?us-ascii?Q?7KioE6atIY63VL/eGFSGwMMa1n3F+JjkDpzYSE1e4aUytUpQ8G7akv0qzQhq?=
 =?us-ascii?Q?2HcJ88CUwL7y1YJ4i95AHYry92/uvCGFb15E+6oS3GLWAc7Qnf+GKTbmCD2E?=
 =?us-ascii?Q?2HWb1RlQVZzNgCPeywkNGm7mRhd5/ebJa2vQ93Jtw2fj15lfy8hYR/fY42Fa?=
 =?us-ascii?Q?SpHJVBM/l3ndq265CdskO4J6vs+EjMyIEtI+hI0+7MI40aqFdY9exqfMb4ZI?=
 =?us-ascii?Q?9t7s/my2FHh5uwXIOFalhYh4hRFZbBmaMEh+s0antBhw0jpg5Rof7zEQHsrF?=
 =?us-ascii?Q?I8zAj7L05QJXLfrIO1cZiXTV1nF9FQGTPMoKYNvmgXPjSjvyAnhTzK6f47By?=
 =?us-ascii?Q?Q26Rbu3vIt0jvdQfxfnFAxaggEBZHU6RSjr/CuCVT+KVQeW7u4eLOMtX2NVQ?=
 =?us-ascii?Q?37Kn8wGHl7GxGlhhlzJNAfNkmRDEfcg4APCIYInTf5hLuThclmI5wak8yGBx?=
 =?us-ascii?Q?DrbUwPe1TrOA6VzbT3l8+ujeyUy4iK60js3I3DD6ATmDsxhw/3v5jktRxLGJ?=
 =?us-ascii?Q?ZLvc7XK7paQkp7GoZH1ny3USAEi2hsIvWvS+8X6i?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0d5fca-5912-4041-b8b7-08da873ab56d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 08:12:24.7910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LfDwnMC1iNrlziHoWXllfZCLc72v7sDhHnvUF4XakxPUxEhMpG8P94c/9zJU9kcZ9/0jtOriSp5wJ+y1o9clwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1411
X-Proofpoint-GUID: 4Lhjd8w2nzbGJGfZenldLe3-fvDjQsu-
X-Proofpoint-ORIG-GUID: 4Lhjd8w2nzbGJGfZenldLe3-fvDjQsu-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_03,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>External Email
>>
>>----------------------------------------------------------------------
>>On Thu, 25 Aug 2022 10:12:42 +0530 Suman Ghosh wrote:
>>> As of now all transmit queues transmit packets out of same scheduler
>>> queue hierarchy. Due to this PFC frames sent by peer are not handled
>>> properly, either all transmit queues are backpressured or none.
>>> To fix this when user enables PFC for a given priority map relavant
>>> transmit queue to a different scheduler queue hierarcy, so that
>>> backpressure is applied only to the traffic egressing out of that
>TXQ.
>>
>>Does not build at all now:
>>
>>ERROR: modpost: drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf:
>>'otx2_pfc_txschq_update' exported twice. Previous export was in
>>drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicpf.ko
>>ERROR: modpost: "otx2_txschq_config"
>>[drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
>>ERROR: modpost: "otx2_smq_flush"
>>[drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
>[Suman] Sorry my bad. Updated the patch with the fix.
[Suman] It had another error. I have pushed V5 and compilation is working w=
ith this patch
