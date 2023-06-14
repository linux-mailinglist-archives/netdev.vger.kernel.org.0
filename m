Return-Path: <netdev+bounces-10701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B9172FDE9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 265151C20C92
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2668E8F46;
	Wed, 14 Jun 2023 12:10:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C758C1B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:09:59 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3A61FD4;
	Wed, 14 Jun 2023 05:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itQnIVv7H+M4lWQw6z9G84cR0EYGLNHd0vJ/rU2A0kEyo/UVBlBDdzRxAqs8GciRrpv+Lov7oiG+TQ19EjXqVCznwTd8I6rqXR7PP/JtOHYEhcxlgidnsW6oT7I+ohLtLYLOg0UzQWPaxCj0jXA/smfv6zB5iZl+sVG43Dja0fR/gAzYWgU6VX1rsH8nEr73+PnjGEVLV4akWwQNK9ROkP0nI/qwvdgLtT7+2+8joDHRt8wOF1g8G/aon8qG0tmX6qgMOwarpfDCddYSt8EB+N9qPcJc5yAOR6KkrAYOTdev9cp9f4GDkxnqMyDNIjYV1FckjMekjd845BexLx78yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1q/9DZvaZYaTbdU7c8D5mYAWXSbjUtQsQQKVLt+PDE=;
 b=i5q3Iue6cNi0EjlNdMw9kaEfkg9bjYggPtSKLe2ZT81GKGeBhm/23po8TsaoeeNYO+HKk5RNQ9bbZvHzSbt8o/WlJqUvLib3HRR4azwAPDx3kqKhNxmp9Wb63ysJmlDdQkU5cwPlttu+XwKcW2wn/oSn2WZxp3eYJY8RFNvVNUgHCN15TS5Jg2hNLShJvCI/vPDWIgiU5O7mI64vi3dC7YpQMRp1m2Ws9HAIpmAbB8SJyx6xfEwPIFVPWjFQDCk7+CYaUfxiZVvhmEHYA4zvSR0LFyUqA03detnta+A+PjifpGKzlXJp3oFI4sVBA3dgQdAltfGfjFPQpC0Fus6VBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1q/9DZvaZYaTbdU7c8D5mYAWXSbjUtQsQQKVLt+PDE=;
 b=t/jvJktCnosQYS1RIfZqxzONaJ57Yyl7ireAhr6hnPyPF5n/nikrB22eZOICaSQPmOdNARutm4d4Etq5KZXQcvwAYJ61VvO6p8L9JdilYyN/JesBM8sV/L1EQjq3MoGHFgpRHUspdnDDrUg/sx+aP2Kt2CpKilwkpXJcgqOZ/RE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4043.namprd13.prod.outlook.com (2603:10b6:303:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:09:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:09:27 +0000
Date: Wed, 14 Jun 2023 14:09:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	linux-hardening@vger.kernel.org, linux-wpan@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] ieee802154: Replace strlcpy with strscpy
Message-ID: <ZImt8RLap1AQitOA@corigine.com>
References: <20230613003326.3538391-1-azeemshaikh38@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003326.3538391-1-azeemshaikh38@gmail.com>
X-ClientProxiedBy: AM3PR05CA0119.eurprd05.prod.outlook.com
 (2603:10a6:207:2::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 0941bb7a-efe0-436d-b4e6-08db6cd03306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IE8euDwB/PsOUOOiqVwXONurEM2SMR7NkkLnKg+g/LQClvKDdRKsUTllZwrlWjNwAr7bmupCggrIpjjYpiH/uj7z8RKQHrbdq1+B5RO74YJN4Uj4awzSnMH40lgrCTfGerdSGV23nYbsjGtHJufTe6KO30bSmEaq9XuUhD05TxEtnUudBz0u1VqPJJ/6C/yF/jpfWvRo2xF+PNeICc7bOSMnRVipYXMiow4fVWbhpRlZRiedhKZtWDf/ARusO2GiJvSY7pQNIUBjMSGzSvdpTd96Gt2EmUmUze6PsDRKMD+uadcXNSaNFRFm5a/nxmjRUQVRc5strtD2KsaM7rajZrmPrDKhEVHk6hzvWVI0hSOxFqQz5F4G2+67zte6YNZfVLHLjtIooo4Q460idjoIueCTKn2KE+hLs+6iwY0CssUAjnxUWlyomk9wZHiVAYmM+MnzJwUoiJ8N+0Wvm6ti7oBkVgkHbGS+Hnan2OwiKtK3JAt0TrTefQVos4SynwsDlfTmHQQpU6OMvFygeg8mD1tcE5cMJGQnYj72OOVL5bHFBOCXWZNAGBfUIda4z+wCCim5O0F9d1G4ld6vf3eoB4/v73uZUYetF74Jb2UKnvi3y9R8JCYbiQknswPcRC0zJRYh54jzMCs73ktBkgWjOg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39840400004)(366004)(346002)(136003)(451199021)(5660300002)(4744005)(2906002)(7416002)(8676002)(8936002)(66476007)(66556008)(66946007)(54906003)(44832011)(6666004)(966005)(6486002)(4326008)(6506007)(6512007)(316002)(6916009)(41300700001)(186003)(478600001)(36756003)(83380400001)(2616005)(38100700002)(86362001)(156123004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fa7VxfHeUVJ/oGs/r66ju7ovg1HDyWrhjD8v9n0pWcfOmBO6QSHK2NuT/e2c?=
 =?us-ascii?Q?S/TP6cVDVSrTOjcRRwaxPrTSMcaKnTGxdnHpNSUFUa9tPEKr8s9S9/rIm4ZK?=
 =?us-ascii?Q?IQfy0owu0D4ySULiUMOMJ91u3IjdAFJlv4FIX/up/SGwdMDUZu8tAeuY35rT?=
 =?us-ascii?Q?qmHPcCnuypuXSKvlZhhsuHtTimt2MzvkP88Gdqfx9qRKltyMVX/M5J9U00Lu?=
 =?us-ascii?Q?dMU+zkAiaRR5b2mKZFjvEfw/XLzDDRjX/mdZOauNvw/6yWgDNQdEQpP9kkwP?=
 =?us-ascii?Q?rCQLDPE5/uHyMMGbXfeJa58mYIAO/h2I0934yoDeOKYnyno8CESjR7sRFy9f?=
 =?us-ascii?Q?EX0eoDXL4blIsmXzqnaUocPcuHRzM8katGfZP1nS1IWPjkSQVNbzNzqamhBm?=
 =?us-ascii?Q?XyhnxcR7ETVbCBRU3jMWPf6MJUF3T9F3AjSpaKa0f5pnUiL5fsclrPW0pJGl?=
 =?us-ascii?Q?c9gduT+NSYAMVSun4U5J9EEuB+bdqGeenSqPv7gmU2QgzGSyLZbd/eLJq7KX?=
 =?us-ascii?Q?F05d4CWGvhroE4xzMvoR9T3gHV/w6xDHxO+vocP0mIJwvyN7Ig6EDFrI/pci?=
 =?us-ascii?Q?u8/+WPYXDA6vXOH2wTnvi+ESZdmfWQNHswYyNE+rzAuhNfKonPlnRb/xxxoj?=
 =?us-ascii?Q?s8asd+reMhEwcCm+Mn9701At+yAE7MfsVzu1BMJ1RPlnkrcBjZ+tcqYYhvKo?=
 =?us-ascii?Q?TztpoDlHro4DlkC0H3EjnpMLHTYJ/xGpy2Y6KkNPccLXzI9nV4xXS8bB7r7+?=
 =?us-ascii?Q?8DS9PpjAqBg9q2zgvMBRwlcBApLM8MG+dxt62ZuBxYf2iL+67NKnYCEfVO7T?=
 =?us-ascii?Q?O2knT7zlNQpi1/9k9gf2eR7knmLcT68udurnBSxeAptYm1kVPNTxUeOarI3c?=
 =?us-ascii?Q?tBxL5xbsijGO/j+De6/kL3mtnPWRQJp4/QXQe+1u5B8S2Ujs2deBX9ezAidL?=
 =?us-ascii?Q?lqk4qDwp7OtMI43TCnZPQFVQa1I8Qgldcmev8SwqMO23Qo3Q7qdgBa5br2RT?=
 =?us-ascii?Q?cjCzB7r9dHETqrhFI0UTHNAOsxly6jHtZXYzHqnAcZMlCy4L37N9uGqgRGs/?=
 =?us-ascii?Q?fVTxZMDARDse0smEKpAogEVj90DAJZtp4nb+dPjr11Hffvf/H9Ct6fhNLfL2?=
 =?us-ascii?Q?nUfSs57W6d9JJNrbB7mQxo56VzFwicFDfmCSGw+rfa/ZQOaf1/XXby+k6zL9?=
 =?us-ascii?Q?gyZndD2AQmpPqHUVtNP86UwnbO4orVZoE7W3eEBDu4b3JG0H2eTCP8Iz/BMn?=
 =?us-ascii?Q?3Ub3+0mziALWqohANHj4wi04DoSCqpniVCqGGy40/lAiQZQEwzELeZ/18Gpj?=
 =?us-ascii?Q?bYc8ymni3hR7vQPt+0QPbwT7wM6mQxf4AEB0BjRN2XY4vpmRxpxVJuU0a9AO?=
 =?us-ascii?Q?vmB7TNuS3veC7/fiPxeOqQgfhCFQuCh3f0JX3+jv2DpIRf9NIKDO5VHwU/Vm?=
 =?us-ascii?Q?lGCMVbbziciYD1wysi7p6mGgxbrK6GXx993jp72LD/KhovhuY+Vh5qj0695V?=
 =?us-ascii?Q?SdVwIe043M9GU8+sStBYqIshYyNSJIwwhodIZqhZC5ScCQUsP+v7BZEyjmAs?=
 =?us-ascii?Q?GpaA+wxNapP6LUODLyhFwsXE1AlIMb84wiNSEGH8RgorvAgMw6+XnRPrbdlr?=
 =?us-ascii?Q?V7DztyJOYtzGLfJWLJI7hdNGqgCJiL+dQsVKXlY8c826uquSgGBW43zx+7lJ?=
 =?us-ascii?Q?zVn0TQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0941bb7a-efe0-436d-b4e6-08db6cd03306
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:09:26.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqTuUDWvWtYjy3/DksfpRynOS5AOndg1MRXipX44Rz4SFPvx5n2VWw04Rxxp5LwCJsDB+I6ZYxDyYPigZdqhuAdP+D5xOIzNDzKMNLBXxhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4043
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:33:25AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since the return values
> from the helper macros are ignored by the callers.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


