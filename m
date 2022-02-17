Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F314B9ECC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiBQLfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:35:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiBQLfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:35:05 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2092.outbound.protection.outlook.com [40.107.243.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AF52A82E6;
        Thu, 17 Feb 2022 03:34:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXfvYGrVBaLB2hRJf/x8joP5WIpDgTngVgjnG6+lYrppBoLUaLHlHeLBfayKFDaQdFHRGRo2pyJGwhatitFv8ksxspMfAYka7npQq/Htq/Iplc++p3w8TkzN+n+QGKzDolGQKdXJOvXuGfPbqtjIornZ8SBcAXF7k4mbgKj6V+xlmFonQe/SXqwMESgxqwDMXcyJMXw3NzV8xgxuoiJUicrPpxVvwUeFoIKfKWcyV6RT2WWAVbB/tS9rztt8peHsmmBvMFEjyy574MHJshmNme2/v21b5etvGykiZjGvMUqCrOZuntrkSDOsyk3LPArsmTuYz+11uGwJZT4O9Pp7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceIA2Tfzk1fhDQS5kD6O79l+mdNdij3XHAF2MqAvLwQ=;
 b=KqDyA1otCzApzl48xCBY/2s29zPGL9LDX3g1q7iTrdFuhWbez7VxnR/2LsckFNCt1BM3yV/U4o2nSuzJYRNbrwHRR+Ixj6qIPMHRRbUcPCwRzM3MrHtOsnKz4z5IWyktSNnSvSTkt29RpfybT4F3kFgg2QJ0HzBzhysPRdw3FxmYtkkFJm55dZXAZWb9/ZM/SqVekZQEJ2ukVMr56S+5knZ/QWtEdniM/hgxKkUScr3KHzZs7Y7RFJJICmj4jt0EKrxdVpITIRuILqu/mhVWiQhXxj7V5xomFEvOKSr3qhrGUNU+w1Os74VZT2YtRbiQByoY8qCPA//OcxHBgs+AHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceIA2Tfzk1fhDQS5kD6O79l+mdNdij3XHAF2MqAvLwQ=;
 b=MeXlzWFYy6vrOhTm4kw+3SZtvKbhOAK8bRVsqtUoNhYAt4K99UNFTAmKsceI7JEDNA9FlbjfjfQxzvfnF4tQgWtR+0YzxV0kawxYh0c1UmqXj6SlNsOYQzlJHT9qABbKu/WvV2rJ1iPG3S5QTremCMtO5jtaO35oO1NwkRRTPho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3298.namprd13.prod.outlook.com (2603:10b6:a03:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7; Thu, 17 Feb
 2022 11:34:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 11:34:47 +0000
Date:   Thu, 17 Feb 2022 12:34:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v2 0/2] flow_offload: add tc police parameters
Message-ID: <20220217113439.GE4665@corigine.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217082803.3881-1-jianbol@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c31dd49-e710-48cc-892d-08d9f209807e
X-MS-TrafficTypeDiagnostic: BY5PR13MB3298:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB329842292B7862AF0AE6FF4EE8369@BY5PR13MB3298.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWOJfDa6wxLljJ/cE2KgjZUq76t/wP8Isd62sOHhaFv7yl7wrduEanjYfoj+LEVqMHm9D7p+WkR0FbCWtM7qKwKk7y5k5i1ncrQ64KguFzMythTl0aFyhtdyYnRnkV4pOCfiF8d6X12p7qWSvAOqxJC7AyseAb3tpMJWl2cTLrpcjlAlxlmIKfJ3yhz0YLOTYyIbVUnszP9LoOw6asVNudLk4ueiWnKAeAhd50Law4MLppNVaCSOyFkQ4aRC+VEENTJCKEwgksRAO8VlNQ8vqKn0IYKjhON9hkAu6bdYlsU+qcxkEjMkvGV/iJHAzJW5FFMCX3ZblX9Xg+J5yv4gDgSUgwtzpxmH62xhUJ0HfnjNZzx00ryVRbQkPpzrqNDKnFvwz4EwK+PGWH3BtsCMZJN3WwdQIVYMTKuMk6pNi+8x+XnTxvzn3n37Y3yFWmXo+/Fdf3syqndOtr7k5iLISLU/vW3UkIKCUiZXryqSoHOyC74+K5pYS6HDMj+2hfE4JL4X/OCKVNs/syAeBfHN55qHp5Us6v5u2ZwmCCp+Id4yMWVTjIOzRhmT3DwtPzkGxco1GKREZSk0c4CspOufnX40oaaBm0Nc1SOunBP8CMLvVllGgs3IpnNf9N0Ahvv6oDLgNWvp6N2Yk95D7BvevWW+UrRMOpx4I/9WWSyVuHa9smZ1oPkzM9qYuoZLAwKInzvpCa2CXej0uiZLnHGxfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(376002)(396003)(366004)(39840400004)(83380400001)(8676002)(66476007)(6666004)(4326008)(8936002)(66556008)(2616005)(186003)(66946007)(7416002)(4744005)(52116002)(5660300002)(6506007)(44832011)(6512007)(2906002)(1076003)(36756003)(33656002)(38100700002)(86362001)(316002)(6486002)(6916009)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?an90PYvdUh6wyZ5KQ4W13cGZsFM12/05tU3J69o3p86NPfF+H66AKFXtm3XQ?=
 =?us-ascii?Q?ATUk4TQ3e1tz4NDnpaZYu17uWZeO9CnL3SWj7xgJvU1GSjXqrhwqdoX3vik6?=
 =?us-ascii?Q?uZP11HMGxl8F21+I6o8RnoniH8PM6HHGkp62NX0YFzCghT3o48rqO+fnRBmd?=
 =?us-ascii?Q?hjDnyOh0jx7euoDM7b+jFKIPkUnrBRiAgSrtE3w5qX/KWMCCTahV2IepkBql?=
 =?us-ascii?Q?YVcL7VB5wxCjOxeH9jnZ2iYcifZWTBoE9mIO9QE3AdyB21w/70lgNU6iMSzB?=
 =?us-ascii?Q?TD5Z31Wqon5l4rirJjFE778m1LuiDVno+C+n86PhANeq64V3mRbBUdBc3C3I?=
 =?us-ascii?Q?QJOi7N/7sw/XQ8EB1cIf6FeLKa9JdxgdAlWs26elCnOi2m0yTkr1w9wBvZwa?=
 =?us-ascii?Q?iKVXExmiKHExMSBbErKnaaf96DvKz1BGiO5ailCsPPne7zG2c389JWWdHGFk?=
 =?us-ascii?Q?DXgXrvu9SV/ZCYn61OT1YUBIwSBS1qOm9G0AI8BEL3L0ABwdKlGX6NShmsHr?=
 =?us-ascii?Q?AiLhXyfZcWYTjyYfl8XEjRYP+dPK7wowFHiv1DyHAJlOjT0GOjvbMXa77rvO?=
 =?us-ascii?Q?tHVlVfv2UTudT6C0oYSaotyrGok9iQlg0oO2JchD0Gpn9EYEPuSK6yyMOS2h?=
 =?us-ascii?Q?TTrqS+J+NT6R9kCNJQlVE1mg3m+F6kQCdcRArqQWXrbDGpiMcwG6G8obbIzn?=
 =?us-ascii?Q?pliGkMuJLzCjCbLsMNPJ9wEDQTm4Nnf3C9593zdPkpfSpYgvWwnHBL7KFozX?=
 =?us-ascii?Q?Amm9hTfcCMY3CgLmXxL61pOEh9D0SJNq/C7fQ+SzcRdJ+ty4MNrtInl2UkzO?=
 =?us-ascii?Q?sWN7024KhQPmdP+Wpfz5m2Ya2Yk9LLJkm2L2SZ/dcnYO0jEoTaWVYcQI0vKr?=
 =?us-ascii?Q?zEupCOwRlM8UghcXq/Z/TZlh5exNNaaa8PS/qF7NqJ5yyeNSgJv1aAnNNnec?=
 =?us-ascii?Q?BcLSgYl4GIKDSrwNt4e3ydWpjd851enmaU5BMllaTML0oiTU67wGdC2RJ6Vr?=
 =?us-ascii?Q?Rddo/P7jJb8BnkmfhaAgTmSNG9c3Yo0wgbIQ94lcBWXRl2QLjXyHtYodZ5wF?=
 =?us-ascii?Q?i46rGDISGWv9+/P8AJKTgMR+vmeMwmN2PeI4I35nMLpwhesVVuSieRqq/s51?=
 =?us-ascii?Q?+x1YuOLFG6wxOdKnAENs3P7isqFUGLjuN8Ynx0I3Kk66Zsl9G7UuBSSYT3QX?=
 =?us-ascii?Q?9hLgc0dHoVA0O54Z/VRDTVgL4W2MwNewOaPcB/yntb0OCXq3DQwMIVrlywfn?=
 =?us-ascii?Q?/pFyyUo85URME9RLTXXT/T1YUrTpe92o5aHBVjmQmfn08sj2IUkuVUX4dPyZ?=
 =?us-ascii?Q?2uM2E9ZdsYuzCihoesgTjvrzeS0YmfHCd0V8AL9ygK3br39gOfzhyfCKJ8tT?=
 =?us-ascii?Q?PnCywi4n+rnEa/N0Jz+UWXIAc65PslHWf4EDPqL8tCvVfdoFcDNPTmI07e8t?=
 =?us-ascii?Q?A43YjkosaB+5FWmH31nD7Zi+3lfKBNy1orThXmASFZ/lzN88S6+gKzNZrejH?=
 =?us-ascii?Q?d/FOK5sOuQG8C11HPFGYIfMJ2RUN3KThEyjdXfbJ3p9cJ2tmJeNLQH88mA5/?=
 =?us-ascii?Q?8znb8d/9LeSOJYUTn9UCZamB2/HO4I84CggEs3Lf+GM7AOtH1kzSO/fBgE7F?=
 =?us-ascii?Q?o8TeAKnS4o1jYQHCQBXe7z1hs1+ecTRb29buFdq+vnES6z3cjdY8X2gVquFR?=
 =?us-ascii?Q?iRDtAPjqWlFWjcgYD9YlEVzR4jOfrHME6gBB3KBorrtwEa2KbDwCjoZXW3Ok?=
 =?us-ascii?Q?CdcsH13iwMAWxyPd3ByLvRN3OOLCuA4=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c31dd49-e710-48cc-892d-08d9f209807e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 11:34:47.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbL93b+Vg5VYv/AbDx5Zzp487bYnCWJOVa/4hROEDMUaXo1v7z/nmeD4rdcwpHyQKBZuUiyPKFxiRG9XMMGPKJ+hgtqiYgJVQBd6urWDx7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3298
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 08:28:01AM +0000, Jianbo Liu wrote:
> As a preparation for more advanced police offload in mlx5 (e.g.,
> jumping to another chain when bandwidth is not exceeded), extend the
> flow offload API with more tc-police parameters. Adjust existing
> drivers to reject unsupported configurations.

Hi,

I have a concern that
a) patch 1 introduces a facility that may break existing drivers; and
b) patch 2 then fixes this

I'd slightly prefer if the series was rearranged to avoid this problem.

...
