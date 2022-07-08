Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5049F56B1D1
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbiGHEpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiGHEpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:45:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDEF307;
        Thu,  7 Jul 2022 21:45:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2684ZlUu011020;
        Thu, 7 Jul 2022 21:45:09 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h635w2d4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD3UTwL1tPcYKANSTEIIU9W3Il5ZKKK6z0hOY0I38zwhJTuDySRMsHlK61FvI3IpNHDTxEWV8O6V/L4Ie5mJv/iKvBSrjzr2yV0qKW7J3opggqodQuOkT/BSbk9KCJF10A2x2yeXKjnj04+leYG3CFlu5+4o0hr5kdGL5R3ZORRgozRQrMObtL2bIPLrMR3gxNBnskJgB53Cslqp1p3cbYK3tqwy+k17tfOWC8KOucSD/zhq8QuRRTJycMgk3SmcvbNTMgsByJBunwIzZCfRUfvp8qMYeLvc0ZsWtPMETTGov92LjW07yKpZJ8PlCy3LdP8+MP2k3zQQDJjBtj007A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHqnUIKKmXFAe907scuRXFx6lK3Dx7RyhtsTi4eIrgg=;
 b=N7EYBTx0rjIKsJdq3O2xJZ/uVOp1iKt7ucnJMxq+Ii2Tp01p6/Lnt+eND7i3/cnE5/QHLe7tTP0Qm3q4V4ZVJRx6p0xLE3koTQC7jUdgFj3C9/5cR+/mXlNKqySeRGp33TW4PsjdwmObSh5h6OrgLo0cz3vkMep5MDQhD3oEBweTgf8WxCZQwJg55PdSPrSMfn1SPdHjtXA7sAivYgI59syd6MWg73XhA4X2OnazT9xFQswCyw/+o8JWZq3UUAS3IfQDLEMC+y0MSLqn71YUw4PGNs8N5qdznLhPtjr7RZ4x/mVYBZ6EYYAZwXg+oNZemKNAn37IXjIAhVLcbga3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHqnUIKKmXFAe907scuRXFx6lK3Dx7RyhtsTi4eIrgg=;
 b=q7z6WL824pWHuxBGDU4iyhtOTXlon37tibaFRx17DGHmN0mZI4vjcwd0FIwkFQ+j//gMkWat3vWS68Qn8S/nvYdedMr6UYBSQxEQf3OM//sF9/k4xFGP4o1ozlorFiN71/daaPuugNj+kUILLu6t8SKmgwiyUk151VL1+EJEHOI=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BN6PR18MB1202.namprd18.prod.outlook.com
 (2603:10b6:404:e6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 04:45:05 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::b489:f25f:d89c:ff0a]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::b489:f25f:d89c:ff0a%7]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 04:45:05 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [EXT] Re: [net-next PATCH V3 06/12] octeontx2-af: Drop rules for
 NPC MCAM
Thread-Topic: [EXT] Re: [net-next PATCH V3 06/12] octeontx2-af: Drop rules for
 NPC MCAM
Thread-Index: AQHYkdQksQfuD7Vtm0qA5q2Ok6/vvq1zpuQAgAA8qSA=
Date:   Fri, 8 Jul 2022 04:45:05 +0000
Message-ID: <MWHPR1801MB1918C2542BC344601E837721D3829@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
        <20220707073353.2752279-7-rkannoth@marvell.com>
 <20220707175428.127006ba@kernel.org>
In-Reply-To: <20220707175428.127006ba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b869444c-d7f2-4592-c282-08da609ca0a7
x-ms-traffictypediagnostic: BN6PR18MB1202:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0YZTwn9hFx852Yg4o4DhdVt4yUKx8Z83Y5HBsjRwpsvrnGnpYiWf5HYAzNb0dXUnBdlGIfpPIExZZEtXCI+JHgyS7Zt1sRwaRl5LbfFPHOC9LSFnz5D91w4dNOE4v+kKPwR4hmM1fzyu3hDTCti2XJ9zQF7dwuV2OLxTThtc47qTvoDiO6DNhWu4JJxg2iYNQWVmNTB3yE2c7XYSj9RrVheTd2VZsAGHqsoL3p7YJHkz58TV050Obxr9gCwytq70wZwOypwUREBQ4p20ZmJb3o2gV/Wv7WhEp7loxzvC7s6gY7//ayo9GeEWuEZXA1GnkplNTPfM0SD1cwZgiWxAwcuhyU/OJ8wsCTwsFO5HW3wr+M+i3spsTISRk+cRRM+Awj7FRBoM3hoJ5+oHaRNU5tjKzC+FO6cvS+eo7rDxaKzKAXuQXGE6xMBVpBTLf71A/wKX0+8UZvu6qB2/mW4CaWyzHffIIJ+/+f1crSiogCr0uqtK13PVGHKEByLwzWXBGH0gIZMA1dVovw5Zb3hTTIZxiqEndmuWyQzOyHoKypuKIxamA83/jhxzpPsoPnkuemToLjTHfWeMdtnhxkUXUpyjrv77o6tk8t/moYJ+4xd/UTOir9Fnk+nkBkTv5o6XAiINoBAI0Mhj2O6J3h5sO5UwoglWep2TMWxawVAeyndNiuAj26QJuf2aq1s8y05lfO0/xvVu60T7pqkVV/itHoHjITbCQg0v3PL5/VKqSsiOxSN34UFddxbCZ+grM5vOdkx0M2dnFADfc+Cd0/cC1ZIUmwwMHSbopaYf9MIj+zPRZ/Me0LmFWuC5AB/TB7r5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(38100700002)(122000001)(83380400001)(66446008)(55016003)(186003)(64756008)(66556008)(8676002)(76116006)(66476007)(54906003)(66946007)(4326008)(316002)(71200400001)(6916009)(33656002)(26005)(5660300002)(52536014)(86362001)(2906002)(53546011)(478600001)(41300700001)(6506007)(7696005)(9686003)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4VAtXsiZhTNOIsYvWd/TdfMoMclj81+/SaY4e56PCajMqHfkv3jjY1ZKrw7m?=
 =?us-ascii?Q?pwAYHEoSSClSczTQYcdMQmisS2cftp4pHMDVlEas1Nxw/cSq8EzPpknr9XmG?=
 =?us-ascii?Q?+914Q4d8YAhpxBN22nNE/4A8xWz+KrKxfZpKf2cAqF4CkTQgsNXpam2tng+u?=
 =?us-ascii?Q?fjY+mVJCKnJRw10NTjIqWUrgAutHuA0Q9RAgRznrgiVhzmhPmk20gKq+lGNR?=
 =?us-ascii?Q?3l/nyJd3V+EwJujl5wUdGIijEicFJXRbfiA4xEAWTw1mXkfd2MGueT+tKWcY?=
 =?us-ascii?Q?OJHrPOuv1AKQWeHwG3s7FJwkH9F/e8pcoX31B0IQC4GXKRzisJeDjvfN/Epi?=
 =?us-ascii?Q?xsQyYPbbHVGpaVPpffGxu/4KoWRCza7iG+etBUE3FWrdKK7BU6evhuziTXsK?=
 =?us-ascii?Q?dyC1WAI8cLVTci1zHKLWVprJ12I+otupljRxbVU1JuPwycCUa2avzr8dhIGV?=
 =?us-ascii?Q?XVSMX3xRUoVyxL8eXeMdbOhMb6buvT5rl4smxLRW6L//CQ7CPR3nRhyJIiOD?=
 =?us-ascii?Q?34GY7Y8NXkQD+Smy/tMyocwFg+FxyVB5x4hTCGNyDdnbGxOWl298FJO5zrLz?=
 =?us-ascii?Q?/S8vSkqYF8l3f/xaT20hFWv6Meafyi6BFOH15x53jRS2E1FicsaQ3ogU0pbL?=
 =?us-ascii?Q?cszooOzClC8NBmnq/pBRy/fKZPws9MNNKJSXf0nJrGVcigs8+QxyoWh03lbg?=
 =?us-ascii?Q?CHGSPFefx6gohO4UdqdVy2cOehsQbWlsFp+9XtiPgc3vpfT3466vUsjDc+Tr?=
 =?us-ascii?Q?0ntNoC6uwT5GV4+EfArp4XepVbWfVs0kqkJKzJL/U6OIz3LKBpZIO0QuoeIp?=
 =?us-ascii?Q?2VlYjEdfRyS21IG3sAMzFvffzgbUn5bnhu2+IoRx393PbAcKhJS9LKKU/DPT?=
 =?us-ascii?Q?pDuYrbtTmwIKNDBz/HjIW5p1zp69/u61POPlXlVuBGuvTXrgqm6JCMTABIfY?=
 =?us-ascii?Q?HTPfrUgQcB/nbOaF84DfoQ1PLb4N1LOxpVUXu3lnkQDh88zSGZUdWzqPOGNk?=
 =?us-ascii?Q?TKcwWyM6ejsYpaCsAxbQybTYV9D+dieGqX/jIsgQxn7mgVtzXsUAIcIRDM94?=
 =?us-ascii?Q?ShFW/q50NHycJz6KL+UyibXCmGoI+9sVZch+KzrQPCL7ykkKK6Vwd03HgdVd?=
 =?us-ascii?Q?B+FK7C+mOrCkoj8fvxTXZvbAR2y6sQTA3sLQCh6DCu6SyYlUwWUQ9Bs7q4ZA?=
 =?us-ascii?Q?B3y0M3kM9sq7geECsdrTUtS2KfGO4Su0PMdnRjpTAuXNeHR8ChQc0rkG2jAO?=
 =?us-ascii?Q?xYoJuXsEnF451HuTFljZGwaSfRV3+VRp+DFYVMIfiE+pQF3qAURGD+0PSJN5?=
 =?us-ascii?Q?5HdF9iCDA6p7Cj4UIxBDxqebMYJLMZOTZ+NiI/IceY7Mqi5cZqFQhxEpyEmY?=
 =?us-ascii?Q?+jXjmv/QLHw7Latu7ta+B19SOeVtMMTR4pJorIbCR0Auhmk8ufji+ooXrgIt?=
 =?us-ascii?Q?dtA2dCfLReufmdrBRsPm63CQoImeMxC/Oq4Yi5AUa4ayYjv4PqFdGIzWjuMi?=
 =?us-ascii?Q?hJi5UTIVuV5l7bVLohKrwBnuZwyBRaNkZp40zgTy3JWIZnLQNiyhCfuR74Rv?=
 =?us-ascii?Q?9gOBzgEyjEPJrNgtoKpJ6zyFIo87Bl4oOjT95mY+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b869444c-d7f2-4592-c282-08da609ca0a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 04:45:05.2547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M+tsu4avaLSlyMV+KeJGnaLZt7qnA4po2ueZ8+SHmlWogD4/AjbrBy9b+c2JdFiT92TthnjdPrMKOhXzIQd2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1202
X-Proofpoint-GUID: _ESowbfAKOzLvlCQLw0AeqzRJFkFCJ11
X-Proofpoint-ORIG-GUID: _ESowbfAKOzLvlCQLw0AeqzRJFkFCJ11
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Friday, July 8, 2022 6:24 AM
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Gou=
tham <sgoutham@marvell.com>; davem@davemloft.net; edumazet@google.com; pabe=
ni@redhat.com
Subject: [EXT] Re: [net-next PATCH V3 06/12] octeontx2-af: Drop rules for N=
PC MCAM

External Email

----------------------------------------------------------------------
On Thu, 7 Jul 2022 13:03:47 +0530 Ratheesh Kannoth wrote:
> NPC exact match table installs drop on hit rules in NPC mcam for each=20
> channel. This rule has broadcast and multicast bits cleared. Exact=20
> match bit cleared and channel bits set. If exact match table hit bit=20
> is 0, corresponding NPC mcam drop rule will be hit for the packet and=20
> will be dropped.

>kdoc:

>drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1462: warning: ba=
d line:         u8 cgx_id, lmac_id;

Done. Posted new patch set.

>clang:

.>/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1228:6: warning=
: variable 'disable_cam' is used uninitialized whenever 'if' condition is f=
alse [-Wsometimes-uninitialized]
        if (entry->cmd)
            ^~~~~~~~~~
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1232:6: note: =
uninitialized use occurs here
        if (disable_cam) {
            ^~~~~~~~~~~
>./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1228:2: note: r=
emove the 'if' if its condition is always true
  >      if (entry->cmd)
        ^~~~~~~~~~~~~~~
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1201:18: note:=
 initialize the variable 'disable_cam' to silence this warning
        bool disable_cam;
                        ^
                         =3D 0
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1308:6: warnin=
g: variable 'enable_cam' is used uninitialized whenever 'if' condition is f=
alse [-Wsometimes-uninitialized]
 >       if (cmd)
            ^~~
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1312:6: note: =
uninitialized use occurs here
>        if (enable_cam) {
            ^~~~~~~~~~
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1308:2: note: =
remove the 'if' if its condition is always true
 >       if (cmd)
 >       ^~~~~~~~
>../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1275:17: note:=
 initialize the variable 'enable_cam' to silence this warning
 >       bool enable_cam;
                       ^
 >                       =3D 0

Done. Posted new patch.
