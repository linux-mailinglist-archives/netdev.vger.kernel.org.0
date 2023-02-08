Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C020268EC85
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjBHKQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjBHKP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:15:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F943CE3B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:15:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5cLUhfd27e9RF1JtroY9UaKKP3xMkn3DtZ9fSyzxYSvO1FcGS154dmGH0jyxqewrK6n7IA8Rm/Tb+sA+L45Od9pQX5zauHMzJq8h2Nb3WjmEPwe4z192icNMHBDiJemuHVe9RifI/+9s98fgOTvu6Ja2TNHcsU+TvMxugwPn+CE/niLmtRsTyXtFRIjlxTjjcoUyyWLVynga/P3SCc6w/S+oPxNiMrfajpKJsZ3BDiaS+ESAQ/PBeT33wmwnoqge9Mw4oTjtEUGskkr4C4+BH6gqJORNgttLjW1yvDLoKYtb61b7IVPMwlw1hXGpzpy7o0h/zO3HI0Aq3iK50LOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VG9Itxw55LqUIXr/0ITXCpU322QciSqHNco8W0+NKDM=;
 b=bo4rklZPIO6pB3VWEPrgxge8EPQswcvuWhNZjllUFwqzwxydz6y4OL/CRYOUsjUGXffj39w4b0Si5v3qpNMqxM8W/zd0yqo4haWFGcPvuSTynyNQFa2JTifaA1wEmJm14eohAwl3QtQ3OpIlB2U57ZqhsKQQ1xylJTl0wn6TF4/fjw7oMaFKxUxabuFpHn7ZhYMhvMNTKz0W/+T7P3+hkTscG2d6QawlteqW34/ba+bUspSxCcbq1819RLjDEJSJ6aAHJTDF4JLX4eA1PP2mDDQJk/Tu7LzaUQc0yX1iPeU/0Ow2ZYOr/eTfoVLV74rYZxL6uXFSjrv88sBlZqfTOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG9Itxw55LqUIXr/0ITXCpU322QciSqHNco8W0+NKDM=;
 b=flWKhcE0H3EEwU5Kiq6O8K5d8aQp9MzF8EHZdmgmtNN3EpVTv+1kqT6YsTybE4xDQlGe9HQaaBoqkUfUNnA1cIJTvd8ZBfFMxxymHyB7nAm8rQks6jof39I11BU8iC5aiWIAyLV3tgQmoDBLpC4aVj/6+7WKmbdxFQ022KTzil8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:15:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:15:54 +0000
Date:   Wed, 8 Feb 2023 11:15:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 2/5] net: extract nf_ct_skb_network_trim
 function to nf_conntrack_ovs
Message-ID: <Y+N2UzC3AXp/J+vM@corigine.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <0dd0765269b3c92d3856331738bbb464537804e1.1675810210.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dd0765269b3c92d3856331738bbb464537804e1.1675810210.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM0PR06CA0074.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 080b0898-31bf-497f-8993-08db09bd7660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3fz/c4iLTZ2sWf1Dide8MbGjQd56wL7/LnHQgeAaYykq1/Bz86kJoqc4SnbL7uJMiZE8H/aopjSlwSuQ9GvN06UsRuwbu2CzTzPDP7A7fE2THAypE8BzYY/daudS63oyjDiso/oD6i9THF2AeMFTw+GrJS8WA8WCqfylsEEm3yNHjdFWc6dzIHEg4oPL8SnF2++iq9++xDvm4bLNCu/NhGjYY9g6y6fr5wiC3x36igOp/o/7ktBZN+X/y3LZD/qNgdV66/LlsxhGEBWpYGuicqrpPt+QV0kmghzIw4jYmOpwscLFN4b/Yj09sH/odqYrkLYUOOLGghQl6Dr6Go6cPGemr2XER4pJRPSX4gE/y55a+xRtP8dTglgW1YVffHI9cHUZbU9ZObjPZqm+vOl5LSVX5aqFZ7x9HKmjuQFQI7+yFFcZOSTrcOR6azTqDiQvLbG0538+/ldqR2Ff+EbBfGpjLWYPVccN+mj0tyFrvRcanhc0Z9bNaTeFqst1FjxdTwCROGCOf2XFQ/fUgeeki4pzuwyzgdfkiYT6Q+WK4Ntw9aBRSQCaO33Efkj5wM3YcXWklJY0mJ0Qax4YZ3g4EJrtuvPShb7shPKFODulXyFk6Y8IT/xFoFgA8aIyPvAAgtKJxUrmNRR5sekgvbWFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199018)(66556008)(66476007)(6916009)(6486002)(66946007)(41300700001)(316002)(478600001)(54906003)(38100700002)(4744005)(44832011)(8676002)(186003)(2906002)(6512007)(86362001)(2616005)(8936002)(6666004)(5660300002)(6506007)(7416002)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bWwxda4eZV8iOaw0Tl1DOTb1vD1C5Gvtp4Coq/1JZggToAr8CN4v1ohYWm/8?=
 =?us-ascii?Q?EipHZ2MYWocURb+82AFZu/+IeJchAT6Wa0KMbgCNU2SsrIQ6YO75BF3utzrd?=
 =?us-ascii?Q?b6V9HuVYThEb1eUiraQZsxaoRjLSB2aeZ9QdDQ8uMBTvQVXJxG7D+GI3AJLT?=
 =?us-ascii?Q?Umoi0yzAypp4LPR2F262xhTYGszfE6O2MsG6O6C4TW+z3Wf2hg6SJflfTeQr?=
 =?us-ascii?Q?6OHCR0/aET/E0OcGGoTb2VyCM8GSMKs3JoxDZF/R9KqBBZvPDrqBmG+H5xr8?=
 =?us-ascii?Q?ZAWOOKzAqAqDJy9PuGdcNaDJ7qGFrJwKkmJEYI2W14SLkmpEOnI36TYToZnX?=
 =?us-ascii?Q?jq+1GfoSlAEAtOArJsNHM5FXOMs8dPwSDf9tScb3LXDcTHGlYI30Byx+BvVv?=
 =?us-ascii?Q?69Uy7qe82KyEZMQYXA/zXPLUPaZbdW1apa0DjUE/qF4w1SIXzt3PO1patT4s?=
 =?us-ascii?Q?kQQ9WHPtPk6UFz3YZNLSxNnqtR6pX8sfLm+0SvAuLOBb4KfIR9nyecrT3PZ4?=
 =?us-ascii?Q?SpwSc18nARLu4/kIAxooY5w7KuTeQUss7el75/dIc5DGH5H7IIcQvBAXsGae?=
 =?us-ascii?Q?rhpT476uWh/+QEVDMFKYCfFv4QKlv9Xh7owHov0z+bxhnflN+j+hBd2DDh8W?=
 =?us-ascii?Q?w/9pOG9jrPiDoQMHIjjklMUkU1L0baE7ikX9QdXdXxzNlgb1fvn4F10vEH9J?=
 =?us-ascii?Q?GmI8++utK2q/XcrlWUBgzPeD1IfCtP4c1gEgY0Wa6ovef6O4cmTSr10knTmH?=
 =?us-ascii?Q?uAqKjIPgWmprwlACVA1KfPZzPhQVBKDtLORlL8x7iiAJYFf6Hx0DldlqAjf5?=
 =?us-ascii?Q?W40CB+X4EgWXPaXPyBIRa47RU4DDZj/4dM1iC2ChEhdwywnPfEhGtD0OiX2N?=
 =?us-ascii?Q?3ZPEXkZCIDcBRUpaxzajIm9UASsiWqA7Xp2V5t5BepcjnwZLkD+FZLlTbFe/?=
 =?us-ascii?Q?SyYHZTic1KH5Ku/1UWYEeuzG6psqAygU6mwnVfC2sT/4OE7HWPISj0GLg+2q?=
 =?us-ascii?Q?i55UsWYdHnTY4bO+7I/MbyXlM0ev/XG8vdt9+ORl9pNjLAG+IeUWON4rmo/P?=
 =?us-ascii?Q?y1zLyfXWWsv7I89FQ8pP906vBfi2P+TanXVudOV823dTJg6yPkI0PWUhUs3i?=
 =?us-ascii?Q?0QveTawTuPTgBu6+iEB+k4+1UKdVg9giXU6O4bVZPFOUhRDxNc8ztiZ/jxmQ?=
 =?us-ascii?Q?NKs1hw+cAXZUgI4wq6EfP8eHw9ddUbBSx3UZGoTWIy+nfUUzLR7XznVvttE6?=
 =?us-ascii?Q?zIrndPdPicyTa2SSKhicp3dmHgnKocB+lT9LVnj/zY7bws/JIENnz7px7zkP?=
 =?us-ascii?Q?gPfeYV9GAFkrsZDiD9XO1lD4KRPnFZ+c298oGa4ZfUmrGl6Rht2chv5+ECi/?=
 =?us-ascii?Q?G3irc8RiQj1zCjurqvYnFyL/2yDyUdjVyF9mCNBnyJP1ohbjR9faq4MqIGwv?=
 =?us-ascii?Q?lylbsz6oqtxX/8JPkiAjbVzwQ3DkVL7mxhjiCihgjHh05zfMY7XweUFaLZEN?=
 =?us-ascii?Q?foOJIIKoOn2Q5X1wm+1YAsgJ9SZ0cPz/zj+NA0TNftWbLn53y3c84p+uYFN4?=
 =?us-ascii?Q?lM+5v/bWtE1XeiDDMfUo0BwKvuJ/JCVZKO/Qr3O45YAsC++d6Dpzu75ao2+0?=
 =?us-ascii?Q?WVuuAiQIjwKsl9oVOaxB0FR7e8kSPgClMnRZcpjr3iVMF1YHmxBcELCM4j9L?=
 =?us-ascii?Q?ANgD6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080b0898-31bf-497f-8993-08db09bd7660
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:15:54.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iO1x04iMg1j0jwgFp8xRgQc6i4x7u8+xiLrh4wwz36DaJqxd7Zj0X4ZsQ0SxpDF9KGkzOSD9N34tLm41f50fDWXpmkAt9lvXEpDLc44uQ3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:52:07PM -0500, Xin Long wrote:
> There are almost the same code in ovs_skb_network_trim() and
> tcf_ct_skb_network_trim(), this patch extracts them into a function
> nf_ct_skb_network_trim() and moves the function to nf_conntrack_ovs.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

