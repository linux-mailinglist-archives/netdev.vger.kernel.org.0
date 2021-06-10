Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C13A37EF
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhFJXey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:34:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230103AbhFJXex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:34:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15ANURc6017683;
        Thu, 10 Jun 2021 16:32:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=oZf4Owh4rAQgRmLtEBBTF5rXea7v2tjMvqSZ+95s+vg=;
 b=pP8CyfhG8/j8NPC+CROaeON/LJ+P+s6BjJmvdc4lHToSl0OnOWJwBqeOXUhHEM8IrsJZ
 5fgpb9EK4vaCRUlcG2E2+VHF0qy8gkZPpRhkuox/sMPnNRJiOS+gOW8Ke+qoomGFjUn3
 1I7nmjb4DYkVSe1tDOY40cGTQb4Sesv6oec= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 393scms9ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 16:32:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M12QVVqONQ22HVJppw+MILwRmO8PJ0mKQUKzXwQJp+JODhVPW6/375sHiuUbEbSMsvFotP74AN69Y5LxS526hOwUGHSeD3kdj/bh2+Kf/70twM4KXD+qKDZS9ox3YwLBUY5fps6LZrgQo2E1QSuQCo/fGr24umg8l+sHIkssJiLmiy/hsurp3ul5lcE9M03h/WBYGY3dy+63QJq7cQx/9kU4ytGvyXzzVmZRBdjYTgPUEML3lU2lM/aIG3vfjeyZe/9nlTanU/Po1j8NphxgzhmY1fJRI+CoIelmSWVVktvL0sx69M9PZvBhjOjRkBagJyM9bZyGAicwOC9umLX/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XeegPcsQUUpo22H/CT+RmX08eA1qtoRIOLP27ufcrg=;
 b=hPOgwsJGwR6lSIaUG4bRQfcPnSfmBBq0gcQszSKmhPIdJnu3NCtWoOG4vXWt+ZA8v03G+yaOuBzH2pVR8DI3qeNAcqXHuuawdVqoFtVtKCpKmm5KlVkC4EtPODIm4zpNed3FOEJgjiCS1NZrWe7Uwg6pRUU12IBOXvi0cus62vJJOkaBgHdlXOI4aJvw5kxG6bt+Js34nbebBSLJCEeIdM3Ivh+Kbi2B3UbRBJ7oNkreJS/UQhIDwhNXJr0QFPUxOSXz2KiCtKa04U460n0gT0eL3nUka+Eb3reBcyysfcp7PJiVgsyAHweiOEFNSwMnZEHMdhNlEJYhXxcAenbTzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3934.namprd15.prod.outlook.com (2603:10b6:806:87::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 23:32:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.031; Thu, 10 Jun 2021
 23:32:52 +0000
Date:   Thu, 10 Jun 2021 16:32:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 04/17] xdp: add proper __rcu annotations to
 redirect map entries
Message-ID: <20210610233250.pef2dwo2r5atluwt@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-5-toke@redhat.com>
 <20210610210907.hgfnlja3hbmgeqxx@kafai-mbp>
 <87h7i5ux3r.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7i5ux3r.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:198]
X-ClientProxiedBy: BY5PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:198) by BY5PR17CA0019.namprd17.prod.outlook.com (2603:10b6:a03:1b8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 23:32:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe90ae8a-779f-4dc1-2b3a-08d92c681108
X-MS-TrafficTypeDiagnostic: SA0PR15MB3934:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3934721D304B97703D0A1FC5D5359@SA0PR15MB3934.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OVqMeH/T2Cc03gYGx9guAWwo/rtaGWhjNauJx4VA93ynLrQT43XR/r1vLLtKFp/gorrSDqYgY3F9Sj+WGWpusFsqDxQR2iO/AB6W6jD2OgLBiInLvILGTfLjLfngDAoqhE2jtzbjKyYI1tEMRzTsXCKMe9E5DaNC0KeknOHowDvNmF8zF1kBjMYwaAcI9BfTRi8x5c7FQ+TGuLGwgJnJtRvKuCh3u8NORCPlWaDVOIrphE1JYEB3Qg/HHfVZ+//EzymtjT+1J0o7E15HiZMqlHXus6hnotUbpf/zeDRsHWuy1f28S62ETrveOcjllNxd5uFf4zJ9V4JxyNQ1Zbf7OiGK/xjlEd5VIbHGGElOwa7IHHI8k7hqJeh53LtM+Mpysa2yfPemPizQTN11arXFBnBg84hvxITw/XdwJor4CoXZfdViz7C9pH/d1yQ//31GXakEgun4yclbIMcp1zxE1yhcg5qgN5mlbvIzLFq/DMhgiEKJas6IJisML1ItLtlfT1FNevWax28wNbvKn5WgtezmpPJARRm1yBO628N8V1oqUdU6058Q15j7dktlmoKuXfmhP5DfuldNPTT00LRABQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(52116002)(83380400001)(33716001)(186003)(6916009)(5660300002)(8676002)(16526019)(9686003)(6496006)(478600001)(55016002)(2906002)(8936002)(66476007)(66574015)(1076003)(4326008)(86362001)(66946007)(4744005)(66556008)(316002)(54906003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?02UzTk2xk+3QJViyAENwoaDataphiR3HLDAe66pDnvePOwWY4bPc4qEQdD?=
 =?iso-8859-1?Q?CWwGSklI68stusWOttTrnxKu5jMgx1gzFmeJYeXKB9VW8Dkfwx7tyO1hKv?=
 =?iso-8859-1?Q?Ozt2rR3w24AcbkFtQfU8nd78v1H4gC1Nhn4OMZxV+6tOL9RlGv9NEjUUYB?=
 =?iso-8859-1?Q?ZM3SXVrNCHgnG4EwuiKoekdAo3FCKB82AcHclz/nvI2LEOiaxT5nhkLzGM?=
 =?iso-8859-1?Q?8CGVoSrUc6KdAIhCatZHvpn0aBuSGx7M6DG33OU4SWFWNK7khTdqQSStp/?=
 =?iso-8859-1?Q?PPjonnMO2ton0TrfkmzMfvCGk6VdjT8hRh+gxHNYfkUplOPn1u0C7Yw4yX?=
 =?iso-8859-1?Q?RUNO1KK8EgBe2TZl7CHuldbWQZKfxGd/dVnCzJYRQ42Ss5XJd88OZKh226?=
 =?iso-8859-1?Q?e/086KQBcQVnD+0qSrQMo4uKEhnM3KNEGQunJM/Ctow3ZL54Kw1u6hFQjU?=
 =?iso-8859-1?Q?AHRkZwpYF0nXDDt0nmi7sEvU+Acp/SWEuDb0YsTsI07EfISCLRGofBk2DS?=
 =?iso-8859-1?Q?RN4oisdPfSichqAyM+RNJCHcPD6tPRuacM2GCCE06r/LBwyOwtpJ5ckI6q?=
 =?iso-8859-1?Q?74EOaN5cAjHJxYIossyegkwvzen9VoykXMvStCd0DVFnbv7Ltr0cmFr3fm?=
 =?iso-8859-1?Q?E7Wn4UkLM0A7oMPRDfrBb3VOIPo65FS7afkHNyFa7G89kGQ34uV5lIPvd4?=
 =?iso-8859-1?Q?lwnJGl3GgrcXWIL8u4HRb6j/Qg78CfuyR+pH55Eaab7MElGGv4haYnggMH?=
 =?iso-8859-1?Q?7nnwiCNeT8oABx7KP35opC2RybFJw5AXpRCo3vbAWl2xBlzIO3Yj49MHrl?=
 =?iso-8859-1?Q?KfHHQa64Up9ms2834Kj6YD1SudvPPVw5bKApmPHE+vo5y0MIE7IrJYWmn9?=
 =?iso-8859-1?Q?BVQSRY/dRAeJTtC/GKEWcabWmY9UdcGEDTDLGDEexFjp+QjSDfe3Fjq5HN?=
 =?iso-8859-1?Q?EC0ZBKAQuNzFclaC3bZ+ExUWeA/8UgflvHMmzwENetT7i/i+3ssWYSJINE?=
 =?iso-8859-1?Q?e2NGj9rcoBmE9XATp4fbRzQ3su7LZphLpinKWpj523cjd7gBy7qQT0C2KW?=
 =?iso-8859-1?Q?4sRU5EXjunFPTy9fH4qVZq4vnXsGzZJzzG4AaQrTBNgH7hkOK1ExS/U/XL?=
 =?iso-8859-1?Q?f3apwqT7VO3JOBWKKnVwraXo19ns+omThBMubzvwEZPfJomz648tp5QZrw?=
 =?iso-8859-1?Q?YvBC7nJKcbrlpmHJEaGrkZ0YuSMsOd7N6365nJu1pwt2g2DhmIoe6D1voC?=
 =?iso-8859-1?Q?AdWZdENek9tMhhNHFsyIQO2DntbRsIgm6TYjxnnVGd0dRUk+vtw1KtLlvN?=
 =?iso-8859-1?Q?DX/g84QMX9S3YxgB821MdMrEZnmp9fmfHtKwwfGiwPn6QJcxvaMXlFOZ/W?=
 =?iso-8859-1?Q?V1gVyNQxNGBGAelvnlrdT/czuYXoej3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe90ae8a-779f-4dc1-2b3a-08d92c681108
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 23:32:52.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cSM5C/eP+9JEDMoyPshUfi6UZRJR2Z3Eo2E8rBNu2ABunspdaXsbU1QCqq4xGd8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3934
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4sjaNXf6OFPlOjY6YxGn-FNjAWwCdoHa
X-Proofpoint-ORIG-GUID: 4sjaNXf6OFPlOjY6YxGn-FNjAWwCdoHa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_13:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=763 malwarescore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 01:19:04AM +0200, Toke Høiland-Jørgensen wrote:
> >> @@ -149,7 +152,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>  			       u64 map_flags)
> >>  {
> >>  	struct xsk_map *m = container_of(map, struct xsk_map, map);
> >> -	struct xdp_sock *xs, *old_xs, **map_entry;
> >> +	struct xdp_sock __rcu **map_entry;
> >> +	struct xdp_sock *xs, *old_xs;
> >>  	u32 i = *(u32 *)key, fd = *(u32 *)value;
> >>  	struct xsk_map_node *node;
> >>  	struct socket *sock;
> >> @@ -179,7 +183,7 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>  	}
> >>  
> >>  	spin_lock_bh(&m->lock);
> >> -	old_xs = READ_ONCE(*map_entry);
> >> +	old_xs = rcu_dereference_check(*map_entry, rcu_read_lock_bh_held());
> > Is it actually protected by the m->lock at this point?
> 
> True, can just add that to the check.
this should be enough
rcu_dereference_protected(*map_entry, lockdep_is_held(&m->lock));
