Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8DD6C20F2
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjCTTKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjCTTKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:10:08 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C286A32E50;
        Mon, 20 Mar 2023 12:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4SfcGfKDgeILLm6xf2u1324+z23TNdPkqRGTcQnXH3ig/XYyLnguM9wbQdLM0+Mfj3K/bhKCRrb5oEiXrgbVQlbAxX28HYJdABHXN4YV8Kpv4ck6GxJOeF3sh23JolIHULPMj2N0a9bSozGDx+O7KcBVTT5JKi6KuMBAMA7mxUh1IUs4vdlGpXnDBMJ87wv3BoTfn5mZ26bX9yZ9yJ8GvMRKlCqj94HOCB26yJciVpLizMT4BHdpHaKnuJvjLxFNvioW6tAYGpvr1NE0OaEJHP0qVdUn9WhSx/pBI83QMaqC8GQHNrwygVOSuEs64fvbg83zosHiG8b39p8e7ebrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnCSu058l7VTrz0Ogqhot7h1TSmEnU0YH0rdbVzz8SQ=;
 b=A33geJwurPWdxlDT8c3pggg5jULVawl/LSfg6XDOu/vq22K7SaJ2MD7pq59/3DRw9NtQCuR4wVbLikgSy0SrqgEgcMLoBCQoFARjQhSitfn36kOG6mHgMjJ3Qb2an0YUkGktAC6mapPQpgEZKYp9+mfRybljy1Uvskl3EpsBH+8VMD3DE9+5jxrzmCYQXLdP9YNlzjaJsPBBg7wC5T7yNRsY73G+XME/ffSJAJ6cpj8o11k350CwDk+1Am3c18ZDADrCZf4tBnsqyrc8FhQFlU37i2UegsNi1uafqbT+gnif3CrAH9hDzKjRlOyMYlF4TW2UsBGQYlcZCNieKzL4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnCSu058l7VTrz0Ogqhot7h1TSmEnU0YH0rdbVzz8SQ=;
 b=RZI2Do8+N7nfK2Vn0LcZO0cWtHmBS98zHoR6DnYX1UxSKrUZJYCzKT4Drk1II31ruRtx5M2A+GW+macRUxA8bjTBcEXFg7BQ+xE5lMFS6GkATlR8feaJ4DgYtGTigsne8D7u9PYKl4+PQTyuCtt6kUYQHx/qZF55HXqd4NyqGSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3965.namprd13.prod.outlook.com (2603:10b6:806:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:02:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:02:23 +0000
Date:   Mon, 20 Mar 2023 20:02:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rsi: Slightly simplify rsi_set_channel()
Message-ID: <ZBituEyt7BZDDVlw@corigine.com>
References: <29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AS4P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3965:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed6e270-9dd7-4116-f6bb-08db2975a37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cclCxkk8cJwA5tRlf/5oejq0uvFegYi0LXMtww8UysdwjtiVvSduiJR9PzvOCe4WU3PCtCNbMp6E8hh5ab6fvmWW8XmXyKwoOhabMvtCMmuv0/PO3AR5ttASOkTujCrWaYY1fyNdbHnX2hB5a5/8rbEYefaRLeYaB3HkoKNLy/ZH8whdH3jdWGrOPiGJtk2UoCcObpus1IR8G0d0G7jww22KUhKeZgajuQFV7Kc2qNPYV/ZKLbEAInD1ftMnTYASH/QYONHvT9j5jhplF5TUqsrbYdcZ9WN08cjAL2rsQ5p2yw/0bxR6rR1CgIcd12Cg8mf2cLhSObwUX8m0aYcUpyEn5JsNK6mS/CDk0jiusJc36cd+zuUJNroTKIw8KZ45VgUxwEhM+N1u+LtWcWOrYYS1jC6IFkZFPPSSlyLDb9l4Hrp3DrNV0yX+f1lKVJxRYe/YqW6MEGsARTSABTquDoIku2XzpsKFM1pC5xBPHZ15zRhpRMSjRRa8ZKpE2jndtM+4djQB2hD/GygRHzbY6zIlDJU9uy8JbCTivWg3nA/8Yy46w4EISt7tHLtiVtcmrWV57Coj9prpZOZfFq+7hmj39KD4cwhGbEKODdKFJw/XZnazKnYhKhhHiUaVYrxtjc1LKlj3Vh2YvYZzNrUwBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(366004)(39840400004)(346002)(451199018)(38100700002)(86362001)(44832011)(316002)(4744005)(8936002)(5660300002)(66946007)(66476007)(36756003)(8676002)(66556008)(6916009)(7416002)(4326008)(41300700001)(478600001)(2906002)(6666004)(186003)(2616005)(6512007)(6506007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wS/oeSZc4Dsa1z8ypSVsbtiWyGB+7k5j3nu+sNsrxsf0Nm7kUSsTKx8SAqn4?=
 =?us-ascii?Q?+nwEXszgv1UKVDRCMcvxpoM7mfoTYnU8QM8Lndro9mbDzMyYt+6X28Am2Xtw?=
 =?us-ascii?Q?jFUpJrpo1LkTnknssUh/pbjMQq46ubNKf6C+3/+xJMSAcJ8U7kaHx65+Q/5M?=
 =?us-ascii?Q?RY7jnBzDBI/e3IMICPk8exV/YnXVtdzgQpbAwWnNC6KuQEEG+k99HDKhIOpw?=
 =?us-ascii?Q?yXCeOqcVYQhNdES0baWTX5xIMpAwKxHA0eKKIMhG7WZmcQIIzaARllulX7Ng?=
 =?us-ascii?Q?1hR3ttLsatZtM/kxjo77UUr6XqxebKH7Imh+XKswtUDwoHgMS7TK2dT/IWKU?=
 =?us-ascii?Q?YghgPiNQ7O8uajn7NZ9g+MaqhYqZb65L+rrO99erRFCeHTtEeezRQHWB0ktF?=
 =?us-ascii?Q?V9Saq58hqcLhJCiBjh3VnyHJ/SoRUHQcwEHOSyJMytEu36lnla12zN91iSvP?=
 =?us-ascii?Q?ew3d9FrBHkCnVvTJpWKBVtqRXYUvGmchC+QaFrPHzkx1v6jr++WYPhsOYq7i?=
 =?us-ascii?Q?vBfG8+7+YsRGp2B8FFebO+CkoEryMnWW0XGCr0/aGVvc7Vrxmnh6bThQyJpf?=
 =?us-ascii?Q?GBk32Oon3PRYlRziEZjXZnZ4Kos/8NLqjc+hkzW9NYjhmWKVwe7nckwsJ3ZQ?=
 =?us-ascii?Q?eyW9mane8uJqZW7hG2SL+zfwU0cCuFuSt4cNNPGOTJ9Gk9uCP6H59HhYifbu?=
 =?us-ascii?Q?iLUoqPt+AU5exfbZTXclBoiCDKWkNvBnd+3ZedQJElujpTlT10bcaB6oZPzK?=
 =?us-ascii?Q?NIA++lkF2jNCwiW1GSyAsK3Rk0FW1zod55wPJAQcLCsdMHuj4YNuKS/+VO9N?=
 =?us-ascii?Q?k6OwyGNLSIOYLi8Njt0/AieUtkjHkmrko9IrCABa5JtmPsw+2bPMau6A/t9A?=
 =?us-ascii?Q?2cgIAlAmRkL3OoSb4R5fVSdX/d1cUgU0IOW1aeg5c2XAGrZEG8t35akO8ahG?=
 =?us-ascii?Q?6WxUc6mDkt1UhJ9Zzlk/ClPtGIQORsEMTowpYvy/d1scqnVAs1mOftF2zGnO?=
 =?us-ascii?Q?V9h9wqlBWnqyAbHVihu6+K5c0ZG71A3BZ2S12JB/14JsvoDT/c+RxOdNjC6P?=
 =?us-ascii?Q?iVGdTT5YlXdxed7I7YhrHY49dLFUAXBvzpzYbyaTk0ZjR9sMs7FrpAPs/4tz?=
 =?us-ascii?Q?xU8gnCKxHgGPiW//2VrNXTZKIKQulLBHj9VMuoVCUmlJNDlzdqU2GvI8Z0Yo?=
 =?us-ascii?Q?hhs4be8IzyI22JAFk6rlGPUfTW8q4UCO3Neer57Fcg5nhYnAp6JD3ZRe/sr0?=
 =?us-ascii?Q?pf82466Gl6DHyXE4Vpu+Fb/0qakgYYcMtSYIjz48mDvZbBT3kJmiKFxPTB2P?=
 =?us-ascii?Q?RgompyvOnS96Ab3Xd+PNFNZGR58D+CMhFlUYDW9a0uOGSuQLhda50KN4/lSV?=
 =?us-ascii?Q?7ZoD0wdT23i7zlBE/Qa4W0lP8bKTnqM8mOhl4V+lbAhaGoEujChQQ/cMkcpl?=
 =?us-ascii?Q?yehDgxnf6B7EqAtnD/kU6oBuzijr1u9m9/WeeLJI7lByXNAI1X1jxOcmRfHy?=
 =?us-ascii?Q?IAdxM74SFdmmN9OUCEFn6QLwLKCeHScPYBNgs6+niSjeu4uiWgGoWXtojD+S?=
 =?us-ascii?Q?IVv4EPb0uWcjaWxdGNRnYGjTxBIgdRykbwqQgPCk2jWwFdUGD4SckrY/QzK1?=
 =?us-ascii?Q?fZzilinkqYeYzye0eqJarBehvPf8t6jVJJvB9Hds3JZFNUdCZlJQiKyDndlt?=
 =?us-ascii?Q?8ckC8w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed6e270-9dd7-4116-f6bb-08db2975a37a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:02:23.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knP+K4uNf/iTojGjAcToHdn5vmnkSWkwa/DPQqtEGKBPjrN7PnOT1PFYk0Ah73yUWyuyHcdKaLtgLLb1lIufGpCG2PifLHHmVkIjpKCHBIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3965
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 05:13:42PM +0100, Christophe JAILLET wrote:
> There is no point in allocating 'skb' and then freeing it if !channel.
> 
> Make the sanity check first to slightly simplify the code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

