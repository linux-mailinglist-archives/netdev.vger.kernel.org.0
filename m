Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877564B1FF0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347949AbiBKINU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:13:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBKINT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:13:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2121.outbound.protection.outlook.com [40.107.236.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23381B8B;
        Fri, 11 Feb 2022 00:13:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO18c6NzltXxv+f0/Gf16g7IDIpnzCWBT6ahsa5ds2Oih4hrkjuZuEa8s1mHk/QmAtNMiVUj/6V21EL/i6ejSp1R7+JG8OeKY1jqj1NAtaiRaGlLF+P6UP09WOK11VIwZtEtgQv9QxSPiskeRS+ZHwysvEdiVy4zP0guJh9PjXmrJPP+x0MIHcLKIC+p/JSfq1aYMBuusW2OgVi8PaQEefaGtjXQbJY5bFrMBfippJ6x9DcX/UIOPUJy9heMuBs5HecdSnMKCCXNQmOHv02uLu0p9hHgbIEQYzIRs1B+oVnuSnGyaLJfdbn+507iwIi89LtbjjJsVB0xC0xumt4GzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djv/mYH+KQ/x6zOF3tufFDvikJQvymZ9DQ411bi+8xI=;
 b=f1iVNSKz71i5hxwPm3i7NufnUr+Qj0EH9hhhFA89PoRz0hQDWSSusV22Cwmu9ERfueGq/AiYb3raYHDRrCl2rYQMWGo2MpyGXSnxy9pd2lJzU71rFfzqLQB91wCxUXxU4AOFvRVPAmYLEV7YTIrXFxO06nYicDrdprT6caY0DoPHGa+5ribzXsYBdbunXo3yHTi2TYTOIknUPj5jxGznIZu/whyu8jh1g79R8NrUJK9ClyJZY4TGjVkMJ2PTlPws3unOcj05f/9oChuwUvORBTbxbJAeADhso5eqKFExUX0Z9/pNTk/gwMZ06qCO7FGIdpyHPJv9+QN4faU5U2HTmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djv/mYH+KQ/x6zOF3tufFDvikJQvymZ9DQ411bi+8xI=;
 b=Q15N8V2xNCinlRzKun9Yl7UgM8zA2mLZVw3eqedX6RYyPu9jsUBUkcgS9beAlHd06f9b6utqVYrkHvMDUCosOF9AlYQmM2kUiL8AGaViIAX1bV+Sjs+2caT8cq+AreHsrSbIR8wnbQIF0IBinPysRNYC2ptMfs6FYA9Q/1rjMHc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3668.namprd13.prod.outlook.com (2603:10b6:a03:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 11 Feb
 2022 08:13:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.008; Fri, 11 Feb 2022
 08:13:17 +0000
Date:   Fri, 11 Feb 2022 09:13:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] nfp: flower: Remove usage of the deprecated
 ida_simple_xxx API
Message-ID: <YgYal+CN6kScyHVM@corigine.com>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM3PR03CA0070.eurprd03.prod.outlook.com
 (2603:10a6:207:5::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cf26b47-2faa-48fb-fb75-08d9ed365b62
X-MS-TrafficTypeDiagnostic: BY5PR13MB3668:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB36685601E54ABF1EAF22DAB6E8309@BY5PR13MB3668.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7IFFFVVvYFfeEP3WC/ueLFymbecJcZPnJ9tDJEET/AYFCWFreB+BeGzLTc9O3ywO/H1f9fpzEq6PW7UWTi0sDR9StuRrzP1cnN+G635ajwuCh+d6S6dObyW2jUguwZK3iXk6BvJS1Pn47plLWn0E0PUOAt6yLCUkdO52Hg4zdSszeWVztvV36qbTceJ6uPLLw/VqI9NXURV5RcsoFo/KuF7iB3xyWS1m9COZWQGrrB8u2PT/iYolZ+iu6BSRbXbX7e5AB98PKC6OcZgZ5PZHDWLe1rX4gzMfkMWHy6GgxOIlFxw+7V3jtC/iXlJYYkJwADnng6qzaMu9fO7Vltf5W9Cf9+in/aEXzJ7hL77sOlqQA4tQ8FMgwid+djxEb4rS2xVec4BY9hk29MXdH2N1s9v+grFsE0u1r+YuS9qFWyAhnrctkf/IDPr63HkdLsITVbHXICzgkkbe0yW866NBXI9TMCJGKn8Cg/vAUVRokLwkfZtAKk89r0VnpuqJ3OAYLYED+1EMcW6eSyupAd4XmBPvuuykmn31XeevggkUbCZ5psg8Iz62pzViWE34XKiwVzX1+noXT5p6AcgXtDFXowa2D3JRiAleQsEsl/uxWRWHCeky1qN9p1A+Lualix7BWonGDECYXKy14ULpIfaJErv4SNRRWWLUMbE1IiPn3Du5ly6UOtCEiogOQqz2O3LYi1JLzDbGSECF4Tb8ZgjloHOD2vX/F6UoZcYSUQm96U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(376002)(366004)(136003)(346002)(66556008)(5660300002)(36756003)(66476007)(186003)(8676002)(66946007)(508600001)(6486002)(8936002)(4326008)(2906002)(4744005)(38100700002)(316002)(6916009)(54906003)(44832011)(6666004)(6512007)(52116002)(86362001)(2616005)(6506007)(21314003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UBc/WWK4sBaEzAeXH7yY8skp1W1EU7e1BtNNVW8trFNI41WYZsopd6xOPRy3?=
 =?us-ascii?Q?3B/5R2RNzQYI8Qr8AUVRfzQnKt/fGU3fwGbnWAD1dIy++AZ/ZdyFSloH6oeV?=
 =?us-ascii?Q?LqE1A7aRZEllDyMG0sbg/mXiSBq2bWyKTHJv6QjDoaIaZw2ve4RnKO4fb2SI?=
 =?us-ascii?Q?FXUDPTreW7GKW49I3NBF5vu53wnyMDvKcc9h4CkjEIyx+JMW9ya3z702NVWB?=
 =?us-ascii?Q?VRr7U4AMnd45OTtMKc0KRDPqhG1pFPlLWMWyzjVlCkJcUjevoF12EWdUnAsU?=
 =?us-ascii?Q?kgFLnjlf4lycHTO1x8sLrbu3F/TCPLw3JDxzLikVb69IAVGwowLMnkXSBRuR?=
 =?us-ascii?Q?OS+Sc8osVUhsQPuXqJpuXJ6BNMI65GVHEPLvuZZjv/T2DKmEqgIH8/AW/1QZ?=
 =?us-ascii?Q?RPhu3WfJQLh9Ab2WzNH1toNk7ICcLimrwKz6Q10emWTOZQJh3LMIA+mNaEfi?=
 =?us-ascii?Q?XnyECAE6f1BrAM7eHiVrF2xhOKy3aQpALcLqvdSLbetGkJqd4WTQS4UpXVxk?=
 =?us-ascii?Q?Dbs2uMttthE5C7w39kYTLbp0M58DVapTQphwTu3NFIRNfJ5Lq3+Nr49LDd8v?=
 =?us-ascii?Q?7I6JEWxDLm7+Z2sTMBx0+xMpcamjZKdny2zJUXvK+2BUKYBIG0q7sWQ8uf+x?=
 =?us-ascii?Q?CbcqA95frGHoYj2oUOkxBmbdZdCrzwfeOvJEa9Up9v5dEmIG6tB/qwPYBJeD?=
 =?us-ascii?Q?JkzutccXRyfXa0D40lYXFseVAX8E57Y39Uq7rNZUE+q0ibVb+3QULXZspcgI?=
 =?us-ascii?Q?bDtLaKZbmzg/XGR5w6iJj3r8t8FIcTScrnVUW3YTFpc4z8XvKwufxvLd/5v4?=
 =?us-ascii?Q?Z5WbZeQj9Z9TW+nOaP7vsIMnk/C94LOhaxWcJ21zBnQsc300TBHdt//ZdHYc?=
 =?us-ascii?Q?soZ3bFSQH7GHGkc7ETfQFeXcoYo4SzrETPpk2XbBhoZW3KE68P4INBZL2HRI?=
 =?us-ascii?Q?IQN1mRGaDEop0sCojMnfcJidzajc19sc7QamInE4Hla45QKR5H+Dx/QQH6zI?=
 =?us-ascii?Q?eRsCq4pWtzNadpmWGE/bfAPejP0TwUD6KpDicKGpJax/1/BK2tUymcgm7gyG?=
 =?us-ascii?Q?rsSYtPSUR783uM31BZCZp01Q54VZgU+vDw6GUsVEK+axu4bAM17lVxk1CgmJ?=
 =?us-ascii?Q?yRj4XgBsTdc4YGVZG2ZiwFIobmGYCeEikUbBPKmIid+J28klAlbF5Fk+cadA?=
 =?us-ascii?Q?ggb5fPO36Ogl7r8LG6E7fUIiM5TRgBqXPD3GfFpLIsPPqsl9bS6yjq+h4oXh?=
 =?us-ascii?Q?SQyUS01vooh9hTpzRETN4JKs7HlDPyiJPrOKQsFgt2Cj5rlCxiYv/mI8S7NY?=
 =?us-ascii?Q?jg2IU4FO0INvuRh8FJWPBB4EN/DjvtE/yDbIIL8ZkaFvfmYVxqkNiVBE6yRM?=
 =?us-ascii?Q?eitfCuZ06ExPzF58jqrimDBBb0o/cbhH44lJEYaiVtz6jaVJA8B/3AuDZG8f?=
 =?us-ascii?Q?5zeARkmApA5cPH96Cg2FBPH1YZFaS1JDRP9SlQZTmupSmVWi2lg6eUBQ9kPL?=
 =?us-ascii?Q?1AxOyx0YMZdRtaYaNjdN3XNbqZFSdNj9L2IHMQTGddHGC3JG4FCSXwVTgO+G?=
 =?us-ascii?Q?qpA+W6R+ltYkRooUwsNt9etUR20rUJGT5UFVpoAYIOE0ITaFXmbYHlyOheGU?=
 =?us-ascii?Q?f45lke19cXNpcpVcRRhVQFZOfn6biTH7jR/uKWx84O3A8zKpD9ube3IqLMzc?=
 =?us-ascii?Q?0p4LC+y1kmVm3YsJpSpjHdMbTb2aKX/3nBScz2cbvtn/UUXPluFIGXaWMB7Z?=
 =?us-ascii?Q?+sgy8kluNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf26b47-2faa-48fb-fb75-08d9ed365b62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:13:16.9678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0aFb6dmE+fQ/VeqLHFJsIncRpoZROcOzSBxaFwixcHAhtci3F5cLvD7kNeySlrK95VMsB2TGvnOMv71sQlm2j8g9kMmROrpVl34aDXFqyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 11:35:04PM +0100, Christophe JAILLET wrote:
> Use ida_alloc_xxx()/ida_free() instead to
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for noticing and fixing this. It is much appreciated.

Acked-by: Simon Horman <simon.horman@corigine.com>
