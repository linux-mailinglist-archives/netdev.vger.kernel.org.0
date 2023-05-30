Return-Path: <netdev+bounces-6271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A68715778
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E00281027
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097EE125BA;
	Tue, 30 May 2023 07:45:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89F111B9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:45:01 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20715.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::715])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5745319B1;
	Tue, 30 May 2023 00:44:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvBrDzkOzje1YfcUW9eKSKsRO85Xo3MfHP5pKn34tlF8fl0kyVtZCjK8TLe7KXWBYKzR5XWG4C3j8SKE6uJDOkr0a289iB9ry/avWBMZVjfEZLTiBOG8uykvKf04Q2vgMwDjmoeHW21oCc8PKyXjPIbTqa8QaFpmuZt96snGRyKbYKNDlehad1CF9B1AL10Z8DS2Mpraa6zuh137wjx+nMNUKwhXOTwoMFxlj7w7GtVMxoUYbLfUnjyUEGiW1ibodyJP2qclusbaoZkHmF7xZzdP8FVUKl3OYvOMZi4WZTBCofguGLfx/Aj1aVEgqPMPH2XBaHUoxL4zXkGtvMEJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bA6cQGirIn20ixWdRubfueeyQzbew6eXaWFByF25YE=;
 b=M3sjx3N32quGf6GfHGa1d1wKxw7D73dacNF8se8ofqp2eL1IHkQzXJbE8ZkPl4ybIrhiFS31sBHXeXn7TxMAL2TH9LFpmp9DmlQS3rdl2VeQTZ94Ffdx3UDeYbYeaEO92STFUC7iVBiMpBAaqtxTjkcYxX0aD4LO2BzW+dPFuSPZojwCtueJ7lDv/hzJV9D4GBqFfL+hjuGFKDUC6PZhHrDoU+4M+8E0EFt/ly46gtejezpPu/sMuq1B//9ja+l9YC6eHkVLgO388ZK2mYog+bG2uqv1S3x9scdyN43hBUAvnZDHdal9U/Q2GjFDYMTkeurc33+iq5AT1lq+zyzOhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bA6cQGirIn20ixWdRubfueeyQzbew6eXaWFByF25YE=;
 b=wiSqGe6JICdYoy4h2wUfWTU7rZi4eNusllhjoPbGk+3h/qRjC0YuflnQ9mtG+XxEKFUaLXdzYIndoZHDLw8tNN+IjtTkOXxTh1P/L99gQ9BNKjH2gyi5s4S5YmxvPjovZn/MoRHObOV0/+HBm8vr9vfm/w93nt09MDx733l455w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6494.namprd13.prod.outlook.com (2603:10b6:408:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 07:44:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:44:08 +0000
Date: Tue, 30 May 2023 09:44:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Remove a useless function call
Message-ID: <ZHWpQY60xYpxd6z1@corigine.com>
References: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR01CA0087.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f47189-020b-4c2f-5b9a-08db60e1a66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mJ9+2IhIpIHqGTImIAUoTE7VFvtZLfJwpDBRqVocyxAUoZeGT5faN7gwqmkXSa2+c01CYRkcFTwMkT6+FkhZ2OwbibMx+107zy8NpKOlVdi6D1EnKoIWb9rmLhKEhIBQM59/sP/NVG4whHEEUlERLczgr6/gXp3poJ2MYNeMTX3aaD9t094u3zTlQVEnncke00+6ussooxuAMlgSD+395wPA6RyjJuctJMMiC7tsH/50VamUWNond7zS5/AbOJrNJByljs8iDgCa4KXEdQlpHdjhxrplFSxczzQcTsOuBd+3oVeG6DetP57t3N1fcgIBWs5SJzgknIBcOGBQqzFTdLO4MHL47HlcpBstXllmDN/AWwu0ufNPqO2/tryDW+QgtTH7Ecr4hnJePLI1pillfNwPYmPW8sLplJlMT6bLDZi+NLyqDTSb6R2aUUTs5oVrD+kPnZyeTwC17asAqueMZI+169hIqxogzaSskdiwBoNm2wpqbccLf5RxNXsgXvmxaZ9g2HqCt+y/YvQ8qmyogz6/ungWGNFAYyXccrT6x2G0azXKzjO4FyDEHbnBdCQu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(478600001)(54906003)(8676002)(8936002)(7416002)(44832011)(5660300002)(36756003)(2906002)(86362001)(558084003)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IvNDLOl3PQi2x0pTx+r21X7BNf2/gPdTOVpd65O1JHVNZn2J1YYRHR8H/Qpf?=
 =?us-ascii?Q?kD6fmSezZVuifIOgZiX//PpNkMZb/uEyiJjNd73OhZSDNox8ymDs+xWfnu3G?=
 =?us-ascii?Q?WUg1yVPPX21jqniBfv/0x3VOrJfJr4p2w6yjuV2jfyo6zau1PbMxw5FD8ROp?=
 =?us-ascii?Q?QeGz1Sz7qMCVwLjVVPMKjxLvBdn2aGCxLWe0ApcWDNmhbuHoZCLxR5dzzLzu?=
 =?us-ascii?Q?FA0xKwgNBc+UJ8JYF2BWhC1HIajWOSXcaop20DwztJ+D3B6/9+Nwof5a1zVG?=
 =?us-ascii?Q?o0bbtUtc6oUe5Q0jbMoTmaLo2ln/xaf2LdK9VNBReIHvU0QcaJRl+rzrLlfJ?=
 =?us-ascii?Q?q2WJq2aHPsYzpsfN+XGjjsQnT4wlqJUGAJdz1cJ890yWNh0lx12Jq6LjmTPm?=
 =?us-ascii?Q?AwlVTnBbrNz40Hfavb9dSygXEJ85dRdrTg4mE7xI6/mZdohdTzYIGHe4UWIz?=
 =?us-ascii?Q?L/F8ucBrnVOwQBRsvyQH8+ZIF93fq55SuamnMy8alHPkwtlu5FregA0tORpW?=
 =?us-ascii?Q?UhXyrnE0O5yNwy623T+gFIpX57/FfZb9vRKKhOIL/ypDRGfSFOXMzt4/FPnB?=
 =?us-ascii?Q?HEHWx9vrlFmdLrSN0Rd5VxytIy7D4eRInwmrj822w2PwMIxW+VX7QBvtWxKd?=
 =?us-ascii?Q?JkebxR5a1nucMVl3mbZ8PkjP1M2EusB4TkLf0khfvyZAlgLQLMlwQ/OJ73UM?=
 =?us-ascii?Q?ubJ4V0D9b/lAnwrHmqAkKEDj2FhlV0yfxHM3DBTML646nt/Vdwzpvi3PCGuz?=
 =?us-ascii?Q?l4MOL9OR6CAVs1NndVxx6hVogjEPg/tiwHWqmZoZGddEwKurPdECIlDCETDk?=
 =?us-ascii?Q?17YSKH/fJHW2KqFrgYUQuCaJOh6A33I4SAGKZwR/68RR3rqkzS3pwwNuGUHW?=
 =?us-ascii?Q?ehfoknyUBT6V3Y1elBMsigWlT+Y6JY9eWmsu4lfWdZnlxGxVMs3DUhDsHH7b?=
 =?us-ascii?Q?jdVaSp7/glfSxpTCCcVQVoaQOYUOJB48CRBidBqY0TlnO7I3YVx+kH/C/e/s?=
 =?us-ascii?Q?GeF2e/nnktHhwE30z97iaFNbiUJbP9bTcr4l3kx2QWSgtm/ZYcWpGlS/Srox?=
 =?us-ascii?Q?fxz1j2ZaUu+io5KjtmY40Q+AjpOSzze1ysLCPyoeAtbuNy3aQHhWsAAnDU5v?=
 =?us-ascii?Q?sI+ArJ3TLgMlwb9dpXwbWEEQ6AUXRbefFx7TZAT3omUC7etN+Lx/8uhc/acr?=
 =?us-ascii?Q?94Hbv3adsSdf/fV0Asnf0vWZAkGCfuyXxYx12tr1NPRbvsm6e2SF6knrLEnZ?=
 =?us-ascii?Q?0CKU611IGxgp8uDrVerVF536bWOqd284MdbrEAV7H4QJpGf7r7MfgoQAx8XM?=
 =?us-ascii?Q?Ps6rIlBABdeO8epqZg8CMdb0x7dHiiGCjZ0Hbxg6j5oZBai+xS+SOUi+vYLb?=
 =?us-ascii?Q?+9wP3AX3irAWVKMAu0qWjnDnE/fYhQtTw0wDl+KHVSP36MXqFz88/oD1pTmR?=
 =?us-ascii?Q?BYY6HKVhCtWQvtz7/9y95oHgfb7s3bxk3dtwHCeAG7KsL2CipdWeGgqr9l1x?=
 =?us-ascii?Q?k8KVYEnnVtV8cLdSJgO4PfEPtwvEwhwTNjqCo6O25jrBG4jz+Hl0I2YCS02S?=
 =?us-ascii?Q?M429QgJ8NOxhj8WtmIjRo13egMNy3YsCPbIpGHuD4g5YdlM8cWLw459a7OmR?=
 =?us-ascii?Q?+NiQc0xI7Z7glc/fBPsptQebXEbT1VZQTduqqNTo/6+GN8rCd75ImJOCyZDN?=
 =?us-ascii?Q?SAyVLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f47189-020b-4c2f-5b9a-08db60e1a66d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:44:08.0459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AErXM2Z7HTOJb3wlEYYP8ZdO+m0ZgEk6uNnxmzFn36DBxfCopXOMCgP1KKZvnGRW1FadKVw992ijXbd/olbMNwZYK0io/h8EN6fg+JV8Gs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 10:34:59AM +0200, Christophe JAILLET wrote:
> 'handle' is known to be NULL here. There is no need to kfree() it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


