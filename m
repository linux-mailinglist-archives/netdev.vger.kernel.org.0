Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C346D38FF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjDBQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDBQlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:41:06 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2112.outbound.protection.outlook.com [40.107.101.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F72CDDF
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:41:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKnC9deagh7vbQZ4QnKdwTliWr2PX1eqwPUEkqjp8o87XLj81j/U7qGQqaLXlFFnnD7hQ+QBVQFE2ZYddnflFcxPN8jq7iOpZ+xZTDT4YN4oU29Ki2MefVVyAwOc0Iio9AXmD3Yn4l/Mz9qcix/mDo5QfYWS5StzbYdyt+cjwl6yLibHXsmOGaFuKXqgiz0NUPIYmxpwlEYMG9oN5DLV2ZS/azkKH0I8GjRjsKlTg4Q+/zFQbb9Yc+R0iDZcyrvf4ETiv4KN6WXYXUCrqz2Ca+kMrvWNPmL/+UCua5s7gw5sPRDDSjH2MLXPw8tdxr9hF0JhqzNPcRaDl3/XQuwtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwlwgU3J9DN/1OmhZEiwd1+zYPEfsSDawlVP0SLp1kE=;
 b=Tc3tVB5i+rnfxOqSohO/gOV4r/L9Rp8dryonKsgsdlHPpQVlxtvBNBB4pj3Us2xt3WGKgBhC65EMsBdE7mtK/joh26BfHl6APTRHuKtaErRrFpar2qsvV2CNqDIYCj8nRHdEPQB+/z3UB5WA4Cc/BbrWGi7yAYW5nA3Qpnrt+JX9l4r7aHeFNNNxJpO9ukapcD70G+nnodylwFl0KuN1QGD19bzMrgCPETqH8MXFmT/HwjnnwdP88cQbjDEhDFULMtlcMu66cZPzqurs0xciHSdP8oga9ou/ikkxDPoDNtyMSiaf42kC/eDtYcNWecLbdB3WDXPVuccM/0Oc6rPCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwlwgU3J9DN/1OmhZEiwd1+zYPEfsSDawlVP0SLp1kE=;
 b=FhKbNK8vr49IFEikyRu78x5k/PslwJaJlHAQb9UGHWeEcKWrIy7ntdn+KJ7f2jVlSQertGCpQK+bJnrhqvTMC/YDkCp/k6wBx51fYPRJLRHYVFV3zUYF2ievh727Xi0Buk0LXLV4mIu+PA7AXleiwHZHu1JfC6xHWYAvZ0MTC4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:41:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:41:02 +0000
Date:   Sun, 2 Apr 2023 18:40:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/7] net: phy: smsc: rename flag energy_enable
Message-ID: <ZCmwFmN/Gzb4hCd5@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <3fcf639a-12b7-f5b2-29c8-a5c3e2e16ca3@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fcf639a-12b7-f5b2-29c8-a5c3e2e16ca3@gmail.com>
X-ClientProxiedBy: AM0PR02CA0210.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9d9db8-cacd-4bae-c665-08db33990b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwbAbrMaocpGWvBUDKEQF3Az6VE93j+5PrTr7sqe6W952UWb3fIhLnj5sjX0dYr1EBnXG41Yc9hTFvDA1sRYNNfpnj+zHmTDP0IP+ygvyzDXCd+qjwxrPB82CnqpJ3DgNf+swJ8t9IS5T4Co9ZhyE9pFVrprVuzZCsyLjzo5VsmVLXe06ed3RxMtvYpzlEuiK1owKk/nHgu3Sz3Czaljth/1f5iSKpQG2EqnHDmrgT2Ctj89wnmjajZ65Kk+WJFQXNZq2wlneKMN/jBfoSK9TFyHSEr8it/eoJbqvf31f0/wae4Gd3SwtuOtJ4rBEgpFZX/h5e21UkK5MzlNJYYO1l/bWLrZNZzHulYz9v4qr4LE0gFScOGzSdH4OfWAqJP7JKTnKpOyHRtDoIel3dimUY4FOv0kz2t2oIXKdghnA9b7ZiSJiEhfw3BUCm04MHV0mavBb9Pf9juENCEP0PHpNynNrVOWRKCoMljxpmgmdmTd9uK+ehTIy8JNzcMhG4ZauZDMH7c48BT1YpO3mSgPRZ/InwpPnXAiOwU/Cubr/ZJ02WEtRI7G5fswf/3P26jAOubKeMcNIKSTpwxNyEBNbm8BhoVj2YSbzj5eecvTxzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(186003)(83380400001)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2wsykXum8PStzkE7+9VaBbggRdEomUyIJ9VZ7Cantwtl7aNkgr8+eQqA35pH?=
 =?us-ascii?Q?3d2l0xL9i5to/mIHfZbuUJwa8CnRlrxHK3KiPwclfiqEi0JuRr72Pv0K9kDO?=
 =?us-ascii?Q?9gqqe1BwAZifZG3hfwpg6/VOJHjenT7CjhrAaLpfMUuApEVeR8btPQ8GxFcb?=
 =?us-ascii?Q?Pc+uXS2LeUlxVx819uhGt6yVcV5YN84l9suXo3hgMqUzmr1h2/FX8o8+9hFY?=
 =?us-ascii?Q?xq6E2RwF+WZEEDuDKqhwASrSsZufLeK3X9WKNu65L1nzGiXLsvhjuoP6Wt/E?=
 =?us-ascii?Q?owxbrssfDFWG1WX7uxUqseETp6nnOja2SKa95Z4zBB5r0TjUwFYkqS99pk58?=
 =?us-ascii?Q?O09f3Ux3qVaOYwKi+ZZ/wT7ZW+dRN8RaT/KohP60R9Kwizr8Rj+CteG2A7Ei?=
 =?us-ascii?Q?PPK/eHk/RWuvoTMkj2h0lghQ3Z+ihAQ3lG8ydyvlyNKDjvamePqYMNlu/pKN?=
 =?us-ascii?Q?ypcMAxBllzq1svK/YBKRqw+82Cev51zCIM5wfTjl9O8cWGzWfYq5qGbYFpl9?=
 =?us-ascii?Q?IzOe6Azwxi0k7O76GcEzvaCROWvMgHd7TmRHzKt6k2SS2EUrnWaRpGczOUo5?=
 =?us-ascii?Q?6TdoZyhA3EYYQc+dumdA8JtRjycqH+OsrPEgjXwh3DBuO26d/q0jkcDTkg4j?=
 =?us-ascii?Q?jqKjpBVOuAdKlzPquUqP/YprxiOwtkIJ/q3tWZ8yRJ9Gf7ePACgLBY5tiGCk?=
 =?us-ascii?Q?yAxvrNiL1+IVVmCowjq4YVPQ5OveWuYaTQTYAvxdmqXoRPBQJkauKRCq3/5q?=
 =?us-ascii?Q?8zcDjulxfNy0piHIDHdPpHRSlwOU0I+/jODLT/BjdLDok4Vysv04V7Wlpy+P?=
 =?us-ascii?Q?9PFsEIXCXA8XrnLACn2Ahyvo+G62JhxyCdpO+Xz16+b1r22wEgIQm2WnWFk1?=
 =?us-ascii?Q?kBhm2WdBc0C/o2rlbHnB3Cs/Vse7QK008/8p0rS+CzWo28Nm1wVCnEKgNmYy?=
 =?us-ascii?Q?ma8anTTa4eAYd/oXSPJHZFNZiE+67S0790SvnmTB/SUXNK1UZJSAPCTu0lZ4?=
 =?us-ascii?Q?wRF8N5A+6NHU9U/CHZb+imacd/C1c3SkdpPgA8OioccOAzn55v+f2Irzxspi?=
 =?us-ascii?Q?77JQtnvYDCyDj/c7l+vJV/muqtJRXYnTHacE+jaj7Knhz5AwTVO+uMOgDx7X?=
 =?us-ascii?Q?aMDm9CoUb3YYjbw6eKZDV96LXaRkf3hlge5YC0Pr8nuLGvHAyO4QGGJaBxeG?=
 =?us-ascii?Q?UJy8o1fcJ5+wL2BCvuqIWA0K7H8YtXMIMZycSdsq/mpGSdz6/JiN5Fsg9ySQ?=
 =?us-ascii?Q?PjlvCAainQy/ioLnCGZPKhYSJsoZPSWSuvxbJ2lVPcMslUflsl51ICv2Oqun?=
 =?us-ascii?Q?dkmwQqRtvQ0DclgkkwKexGUbMVtd+OEjMIKjGqYqScQhZACZjf0jXnoeFYLC?=
 =?us-ascii?Q?d0IgR3g8WDV+GsSQNVXv/hQptX5zbig0zaTw2o9I2KrpgjUcMsFdJOinNEIL?=
 =?us-ascii?Q?lkaHnzp5kJ2jZi7kDeHxmbcgUhwaNELNa1yIpLpMaI0NSmMCJnb0FTpmrYH1?=
 =?us-ascii?Q?d1UH2NNrruO/vGSTy4pAPDGooIc8e+vk24R07n6a00WOS1gnXO4LRGxdEfjq?=
 =?us-ascii?Q?qY55Rvwe+yLmzzWF/9p5qKoncPD+BJ24hDDwRa7vzM6w91+wGk+xeWLOu4bn?=
 =?us-ascii?Q?lQ4vNy8vUwrWXQTK2KLuXKScJQCIRIR66yqg9XWfBmIpXxedC6f1s4EsHMo8?=
 =?us-ascii?Q?LQ9y/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9d9db8-cacd-4bae-c665-08db33990b44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:41:01.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16d6fdmnUZ0uLJmSFq+L3JoTaZ2R+HX+EBp/ye8y1D1+lp6XIcQGRlfGbob7nG8mfbyZkRHsR87v0qR9SfnhWSIJBVlFKg7eK323T5g/7DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:11:40PM +0200, Heiner Kallweit wrote:
> Rename the flag to edpd_enable, as we're not enabling energy but
> edpd (energy detect power down) mode. In addition change the
> type to a bit field member in preparation of adding further flags.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

