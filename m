Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598C568DCF9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjBGP0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBGP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:26:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C895BB4;
        Tue,  7 Feb 2023 07:26:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VC9PswbIVOFkWJw2MUDHZyWxNrhyPAq3NpYf/P2w1xhyyInHDc3tLiLdgoGXimu8ml+Jj+P3KKZ/EbQwoWsDVqwPHkOh1dvdVoBc/988XsXzJpolBeWnq9geqxoU2SYJeRRE4BeOnm4eSV2Ho8R3Hl39yyyIsHzjTRY+dT0DamaUZYGNrUa3VszeCgWp35SK4Z1PTUW8ACvgTaZSTHDdb2da4tw5YWgVpdRYZ5IfW9R1lMG8rb1F68UkZbbO1Z1czaPCX5+ef7qEDCSWNjPWeKZ76jDDcRQcQ9ZvGtR1jZ3v76kN7oSCczDgaM8uXyl5ZYn9ETSlx5aCFzo1krsq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOT9PaFRPKfG8RDjkDP1GhMRvQAfgdxnZrhHQPpkxe4=;
 b=ZGtRf1G6EZAoTu1fJ089cxMg7x2+Vr8A9d4cJGHidLwoTdQ9cAjpYm7SuCUZSYZUWN/1DeeebtvQr6YXR0AQz7qaf0fBK9hiAl/M5NqnQHEEnrNyuJbNAdPwUsv7A6uEsWzInY+lR1n/riTzVMD1Wux5BRe4iic6aZziYwC6Vkm6jhfQOiFyv9wdeNJNOYZwuCGF8rB/Nqxa55+Upobz5fmCFm6R/w26E2FCzNZyzxitL2Wyytsz84+2GvQEB2Df3F7uuPKwS4/7TFTlHi1vKPZ6XR6WL91/JPdyBMtSYnLx4GG9t4pkAvjtogK2RAMlWNQ1HOPZTPF3h3oc/GjcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOT9PaFRPKfG8RDjkDP1GhMRvQAfgdxnZrhHQPpkxe4=;
 b=hlb2K2MS74jn7OR5zWqBKc/cWDWpUlWxQ37UYxn0hGBujGljcQtl06Og7dUmCL9e0M/GsQP4WlCagCX0qud1G8K9x4n84VMb/uU9CGtd89WK1iZaTJL0K8j1ZD1RfMdbSxx5/Uyfucpm3KGDodbrplsB2Z2OTtzcncXI4H53/bM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5725.namprd13.prod.outlook.com (2603:10b6:806:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 15:26:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 15:26:01 +0000
Date:   Tue, 7 Feb 2023 16:25:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH net-next 1/4] s390/ctcm: cleanup indenting
Message-ID: <Y+JtgWU/nMcx2s7s@corigine.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-2-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172754.980062-2-wintera@linux.ibm.com>
X-ClientProxiedBy: AM9P195CA0001.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f38cb5f-8438-48e5-f3e7-08db091f9e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnuSA/saTVd4vBexlcdNSod+VoTk2gx/wJQn4cRGv2XnIWEEWLoGZ365yJQR1KkSSRRTCDO/pArRsB356ulo94LMFTd2SA7cK6Fzq08j2P1thYtCBG7C9ulG2lbwk5x9Q3um/FcEzSwyKjJRrMF1MKnbsw1hX4yZYqvzmerC7NbxFHkQg02ywRsA14MHwC83HUAvN0/DBkbpoab08ctO7H2XbJAZPbFjWRUw/zOwmcmpqfegFJw+LqldndgzjWXTcxxjjJQxe44mli3RZ4uU5LtISkL9M8PPu9QB+QYitgIKPCsG3QzvZaOcGdCHSKY6vWy5thWqxN/PQ1TXCXRct0Xs+12z7MlrwEI8s6EdWO9w2kQSsiqkdFnGNQAkw3kmHmAusAM/cOd2VBm/35gZYVJLECGtFoWoF1CSzQiWIZFMzM4kbIgMgtI6a6o9beRoEJvZajdRS62o6qFKZ3sfzqpDOgYAtEVc5K0xUK/99gD8Qpe7nUBsQL9VlneO0vGOPfWixrsH2bmR3SXklsQv/Zac3ILT8TFCezTr3dlPHD2qUtIHreoEP2hLM0lXLm8TxJ4AuKKQqtu8vKbIqACidvCk1AhIoMV7fMPYlLffRqSHCCuqDxxeRnC8tw7HxdIqsRFyI9Qtz8mZlo0zFF2Y0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(39840400004)(376002)(136003)(451199018)(558084003)(36756003)(86362001)(38100700002)(4326008)(41300700001)(54906003)(8676002)(8936002)(66946007)(6916009)(66556008)(66476007)(2616005)(5660300002)(44832011)(478600001)(2906002)(6486002)(83380400001)(6506007)(6512007)(186003)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGQ748oKn1OG0XAVTqrbhJBVRoL0ykqD2b4CoQvR6j/vsB2nOnlkUgRuHEh6?=
 =?us-ascii?Q?kigeXVJFQeVWGpx3KOUY4BeW5sgN/RioCW00vdwc7zIai270nM2bYhxIOMp/?=
 =?us-ascii?Q?i2PK/1cLJF5CXDTNZMIR885Gc2MxcrOlfzdkhQTONTyL6cCsX1V5CK1BCpYg?=
 =?us-ascii?Q?mAjmByGqJMKbNvH4AhOMp4DG3+MtZqRQOMgM97a4KmBRnlSE08apcgvXEVUl?=
 =?us-ascii?Q?OGXPWfTHufoWpscAnX2iXk6DrTadx4SkPmx/wg2lKQNcjbjVtbLnUuxv4QaP?=
 =?us-ascii?Q?8tYMCWm1H5BvjrG2MjAgeROLvKtviihQdU+5Fe+fC/vpGvwdDjnUMwIjTkOZ?=
 =?us-ascii?Q?atnB3/6/Um3MHsxDKe1YL4Fe9V8c1zg9xYx0rISJx+dI3dqWaDDpFyy3oUJJ?=
 =?us-ascii?Q?+cB78hc4pN5euE9rO9Rv4jSUHMFM1hCFek/lrxZ9gonh+Epiev4tjDC3sO2q?=
 =?us-ascii?Q?ztB3m6hzfSrZKP6VZDXXS29OBakyefpKHlxOn7Iy9RUkxLowTCiLmfDpuPhT?=
 =?us-ascii?Q?LWbITk1GJjddIajbW0ick/B1BZDm9IFWgG5IemIotoefGYsLCz9tQH7klNgS?=
 =?us-ascii?Q?LInOzG//5/Q2Z50maFCFQy1/mKWcwkrNOvOEiPShmvv/pmTn//mDCGDZezPA?=
 =?us-ascii?Q?ey/UXFm0G7kPN4SjP+aT6RbB8xUqZWj9OIoWaqqRnC1D2OGxV22XqXiiMg6D?=
 =?us-ascii?Q?qfAXqCG2BnSB34IypC/xyWgnRrnOjPmm681oj7Nw9SvxNQA8tmO3dZ0KE9kP?=
 =?us-ascii?Q?RaWg37lwdKSCh0ygH0NBOnmOyJMss3C8RX2LHscjchZNaqAbO45UPbweyC2l?=
 =?us-ascii?Q?MiP4s92Ww+28IezmlUVf0z1NgoHp5fTpgYzY8dwbd+NmifJ0FGZyc+5ZOyau?=
 =?us-ascii?Q?a+SvFSSJFN7ymRa8uPue5d7K+hw7Z3yhJM66GRVEMMFYXV+t9TiU7pCz/ay+?=
 =?us-ascii?Q?JrBY2bC5v4Ru8azHuOX81zRP4mmXmfPpSkB0Hq6WwAWeFUCHiWCzG0WTSRDc?=
 =?us-ascii?Q?3q1+VdUEFvaFt1DRo/i0cA9unzaVRHDITSkADQGKIgC86PJ7XV+vLxylZt1z?=
 =?us-ascii?Q?ecBJoAkFjF1yRdL0Vn97Kh9FZ8Q7bJVQnA2UkuOTdYQsxi9J8hRgBmXHwkwt?=
 =?us-ascii?Q?MUyAVy2hAzS+pdPqn+FUdNNI5JRAPHWbZXD5ILXdG6JJrSKKSw79c4VxNGoI?=
 =?us-ascii?Q?s4R9ECNtoF95Eg6/OcAz/LngP0RbzbvaqWAxvAaAYXLiU9e0q+k5jb5fmC6C?=
 =?us-ascii?Q?bZD8T9X8zQtQoGs9TzQvP7MXCsJlyizMs53muig8pvsJElWIZC0ka/jnpk32?=
 =?us-ascii?Q?j0frIQPEc9ixZG4sLJNEGzsAkIrLtPPfh4XYwhByaoheBXedYUaLPHA8YWmS?=
 =?us-ascii?Q?lWIaivtai4mTAHTZXr5JShDdfuS1sp06YdPuzF30KNRyZ0UD1zaqhZMAyVZq?=
 =?us-ascii?Q?mOnvOkupkwcMSTq/Bibb7DI8hiid2P02pjZbMPLpUMPR02wwH1PZV3TTeaEP?=
 =?us-ascii?Q?g3JpxrxyHDASccbiXZPD2EpzGaaDF2SLL1JV0qtPTP3ibc1SgF23Jw9nLKc8?=
 =?us-ascii?Q?HotwlIg0Ghw7IfxhPfWp2dz80y2VyYSmrPAfTJDE2ffjBDIWcaOPp6CeGzIQ?=
 =?us-ascii?Q?5LRiv7ESx/dSsEsE/a7eo8pMA1Ths3AA/Z26SFOMcXmU8AOXu08m7sSa39vS?=
 =?us-ascii?Q?vDWaRA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f38cb5f-8438-48e5-f3e7-08db091f9e3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 15:26:00.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHc9URrqt01tOVdeeC9oh0oJYlVAMHDvFkX8W6nf8+fh1DbDHGce/af63SzxLkDWhkiHQX7V7D0t8QE6mwbWvPLZ++qcP0vSa5NCouzNe6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5725
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:27:51PM +0100, Alexandra Winter wrote:
> Get rid of multiple smatch warnings, like:
> warn: inconsistent indenting
> 
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

