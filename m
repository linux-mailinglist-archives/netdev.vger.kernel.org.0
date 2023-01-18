Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CBE671B0B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjARLpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjARLoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:44:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20702.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::702])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B4165EC0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:05:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h15xZ75ucgqNkIrVFVuVVFNgBQNHQlcbXlPjzPhdXpPQaNybZOs/AaioFC2OKfbK81sggImZ4yV4GbohR/roixVb+oUsMWBUWAy2MgzzR/XOFp8JKn6E5aO+w/n2k3LW8pjI0/3tPtorr3QyXvyvm1lItbiSAwVZisv2K/Z4IywU45Mhf2d2ad5jfExlkWuIzPdtZqqycQjYHfuwHNYhJjZapqis/oU6qDGDps4MXzSwaJuGtrXsNFjN2GTyRWMZk0hkb1D7umAgM/Py6xRYz9wgEFYme3gIRtuk5E1CtD+mUrD0Q5rFUgHn9zSZOmQSy6/r5EikCyR9NPN7Ss+cdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqfhiwiWqmNEKFiv1Iw1KhnNrfjDbtixLYVkpFxnUqg=;
 b=Tm2aGDb+fdeOtOwF5YgyyVbKmqPWIGpVCJJlHccJsE6VGSiW+kHCzBIGtsvKvC9jxlJQp7dF3ffjTvUq2HkVuoOHOb1S2EHi59tarViLEofAaHg3PsMwmzRhj1aAsOXmQ6LipggpnN4AwHQO4JPCD51hgShov7bLYblpCxyxgJiR0sp7fb3CNbA/WH/e232Y2SvrlI4+zNUnmIMN/TaR7vctq80i+AV4qeCG3gQWFmEuMXx9Efwrig8PdYp/FA1QG8U7RtoqCAmQs8DafJUzWf02ZNkaMgJeFJ7Av7XriB4pdiOKhj6XPU9CgJYI3Ilgon+y7u3OwOzhuZo6H18+zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqfhiwiWqmNEKFiv1Iw1KhnNrfjDbtixLYVkpFxnUqg=;
 b=D96XkNvRzIiF1+uXXY2hBFNnZH7KKpSruPrQDd9rniBOaN8TmZllXwYOoKU4YXjdXqKntSKdKVJbiUyUNwhckgzudmThcBW9g1dylwoy7eotwDrPsAw1TnHuBO1qHqVulfEQoWt5FxJ3wjeUvcUcvRjGJp3jr5vzg8NBskCZKCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3790.namprd13.prod.outlook.com (2603:10b6:208:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 11:04:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:04:57 +0000
Date:   Wed, 18 Jan 2023 12:04:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stefan Pietsch <stefan+linux@shellforce.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [RESEND PATCH iproute2] man: ip-link.8: Fix formatting
Message-ID: <Y8fSU8IEPFp6+iu9@corigine.com>
References: <e59c7cdf-9c54-00e3-bc9b-22fa471bd5ab@shellforce.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e59c7cdf-9c54-00e3-bc9b-22fa471bd5ab@shellforce.org>
X-ClientProxiedBy: AM0PR02CA0097.eurprd02.prod.outlook.com
 (2603:10a6:208:154::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3790:EE_
X-MS-Office365-Filtering-Correlation-Id: d54637f6-4ea6-42b5-b464-08daf943d5b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHjgypOElk4DnHq4PMwZw74ixCu6uR73AOZGCH9P5RPeo6FnX18ZoDiiImVrTuNAlIyYhVAmG6Ve2gbqv3gRJ0D5NJ+x5fbJv8qBdEj/we7FHy4Wzen34CtmqLRlZ5ufHwX68/LUbX9aJt8sakIiuCD4S8ZPrqAk+EUBpNXb8sdxOAoROtGMcogCViZT5guyqi0yf4PYAK3xR8JZmponKiVTwnivQ219oe9CWTkjVK7oFToYS+CPUNUj0KKB5EZK1ymfkcogyR/i3GAZSYSBxY7q9d0MlelUtDz/NtoCMlMj+Ety628GoZVi1ZUqrilkA7XUSE9d1v/O9TDFn4kw2SVM+7PqiWk7hMSjhzTymGMCBEhHlGy7VbpZvnbX982FABDFgusq0nI8Nc3hBSjUlaUNK812gnD18i5IBNHKVl+7PTHo8HczUTh63oxLbIRYfbt4g82B2jCpasGVelaWWnTkgNfkXRzLmYl/q/8KjgvFnQd6WDKUlyNRGi2a3IbwBl2+etFAVW7fHITbo9PHIQNaRIwQnaVaJVvCFxaLDNW70AOnL3pff1wN6kifi58yB9HCeeiMtuEPKKWGImq98dkfpv0Op5GJwpaeBfLxMuItAp9B9MMCpnmMHWJUfJimrHgl18Y/tkkS+Wj4dDknuQzAMMIcuWobDQa2hUGJ0EBKhLHVjrJvXzDomS5PAwoZns5V0wWb4SSiZiTNILdaPhSDRVV8jj4wU2qHlYzrnKLHqmCER9O9mzWxuu1dwfDL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(451199015)(38100700002)(558084003)(8936002)(66476007)(5660300002)(2906002)(44832011)(66946007)(66556008)(8676002)(4326008)(41300700001)(2616005)(6512007)(186003)(6666004)(86362001)(6486002)(36756003)(478600001)(316002)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZgh2hdwy1MPAA9qYyPSibOeAkSuy2gLhYJvqDaNkVRUSQbKwsUlfnwZkWER?=
 =?us-ascii?Q?9ebJBo9+XRPJYZRpsdpJIjh4fXZWva3IVliiVvlcD8ZGbuKPdLRtQxg/Sp9G?=
 =?us-ascii?Q?kxxhwlDV+6zdNsI2K+ETAZqzGGm93DnGrVJG3R3lIMZBa2E/syCrVv53GiRs?=
 =?us-ascii?Q?eX8hH5zTwlG6Pki04jYSKrYUOq+ZPyL2Cs2f2Ta1QPSsPJlV50tjhUwMI/99?=
 =?us-ascii?Q?H19Hlw7L7WTGge7hMxBRSmsLXsMBQzgGsOyLSjM0x7gT7ZePaMSH6y0TJq6/?=
 =?us-ascii?Q?mPEDNK1f6OtYgKaG2spMHcz5MEhdJdFPN0df+XFMfvdYkNLjX6zszIo+WyjR?=
 =?us-ascii?Q?FeP/kCI0gsusZwAKXH81ohCQGl5rTvDMvoATAJq0aTF9HDXCWe+QaWU00BWQ?=
 =?us-ascii?Q?k0w3isbY2c0WX7RyluDu9KzdOi3LSH9gWj2U9KgzL+Yc85GPTgb6F7x5gh1f?=
 =?us-ascii?Q?LkFhFIFsnVXr9WB2XSYKIoMdOquSwpk+YBsD1P57PQwKa8S0adRWm/IUS1m0?=
 =?us-ascii?Q?w8HKzxrScUWSgV30M8CG9ZXhQowYFFJGKJHrBcp2nGB+/ve8A41IBEACu894?=
 =?us-ascii?Q?aoP9UqeOXSd2CFFCb/lsEcB+Gc6yZunE9VhOmqwGu9kWi6BvjZYPk3Rg8xQs?=
 =?us-ascii?Q?2MXF3mGUM3ZVx+IYUTLMuFU8nLeEUakaCJa0GXCAVfTxYaDGvCfdNmwyDVWO?=
 =?us-ascii?Q?EQiDVIkvKD41gV6x2PzTaLoxVkKrkuuotlsamyo5RlAMkGvLi1/Bvw/nlX/r?=
 =?us-ascii?Q?oCHaCS23rwO51t2U9AiLeXskcyAbZgUzVx81q3wAE1LGi4zNxLz2IDpvkJE+?=
 =?us-ascii?Q?KVjjvjKHvAULXAnjR1Ro+fn3t6OA305SeFbbFx71Uo7lrzAEi7r5NA/qYp9n?=
 =?us-ascii?Q?faUkR9pB5Be5SaQflj12UCx6fvUxTtpgcrhAmEVKjTn4kgxjh48nbwXr8TYb?=
 =?us-ascii?Q?OIZZ41mKOA+PWCITjlonD1L5LSF0h7mYFh5IF2g/L3QbdhHYPz2V7/dV/2OO?=
 =?us-ascii?Q?6d32NX6v8P4jnN9H5NcxNqlvv4YWDP2341ZlYOff7JvtqQGfPcdDw44oi9G8?=
 =?us-ascii?Q?jpzk7ftR4g+BLGW/AZjshquvwZI4X9bELJCNnKHmZAv1PJV4eHI7r7WPdtuj?=
 =?us-ascii?Q?LERjqyKRU/XtIdcVwPqStRNkiLqgk8bl/R6zm9wikIuTGZJKogdHK6N8CRjH?=
 =?us-ascii?Q?vXYOhzIUrHnVqQ6V8igyTJGZnaOz0TIWh7mLO1VLdLKPvPOgDnVB0MgytXFm?=
 =?us-ascii?Q?/bkZ1XZTBXAJMBTrdHbZBlTlAwgJMGZ7OOJUC81ioU3iTKFnWRNx7yRMfM+w?=
 =?us-ascii?Q?45JX6spC5XCRSdf81iTTLyO1fOZFVHpUpr2Zuf44ClMijfzESYLI/Sjt9UIE?=
 =?us-ascii?Q?8OOWb/HC38x39+Bw9JyeHSW4W9/gTrbYq0sJZIf0pwo1zvppMJPPq2pYNaMW?=
 =?us-ascii?Q?UWZ3j8gTOFelytQ9UysfXjZ+SRSXiQHKP8MxzSAZBxDk4I69VBsHe42xmOTk?=
 =?us-ascii?Q?wt1e0GKdIvDdMHKZcWMWKFq5qyW9FRzfTJv2ecx1ai13jbB4cSPgeF9Glkm3?=
 =?us-ascii?Q?Ikjp0GgB1t88l7orpgVBd4KguXr+RNaHeHkpFJpou1YHjIyWmyC08BkaxWV6?=
 =?us-ascii?Q?pYbd10kM4frcpP07212ZYNpd0yw8joT4d5CP372R+oAC4eLTT1yqWGu/W36b?=
 =?us-ascii?Q?xxkSIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d54637f6-4ea6-42b5-b464-08daf943d5b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:04:57.2299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67oVNi9If3B1rB8R9jDRM8ksKfyV2KZQRMnj+DlecMjtJGTpkgsrcPeMjHAq7CEUM6jlvlcrJaUU/yOylh5T40rE92fDULlL+r8pQDBJu1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 08:41:42PM +0000, Stefan Pietsch wrote:
> Signed-off-by: Stefan Pietsch <stefan+linux@shellforce.org>

Thanks, that does look a bit better.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
