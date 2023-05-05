Return-Path: <netdev+bounces-571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F8F6F83A2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B161428104F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C8779FE;
	Fri,  5 May 2023 13:15:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B33156F3
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:15:38 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE97203DD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:15:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JD7oXIP4QbciTnC7/TJnNZZms7JDvtn3202napCrGrvJkNARblIyhAfhfwdd/Q8n8wUsf65twvVZqrybOncNlKVIx/WWCToJNHVufRlMar6zlo/ZcIWG8LaHb2IVzu7KzIgpQugEuAsMYrPwpMM6RqP0dCcr1NBXLXIDKmAtrJQKWp6oJ8MW+wLtjbCR8lCrRdF9WOpzN4sNbrhPF8zhiOf3bsig9lNKkupEXmh6L86aZ+wMudbHd262cql2O+cm77/ZUWEzVvXAeuugMduGT5lGBGEJaIHTJpmlsiheGE3vCK5/4hUhbpl32hVWz6zvdt8IDLMIB2vITi4k9rtFcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8E/Ql11fBeiH/3cyZqSno3Of8wd/y5HRT4rZ45g2Qj4=;
 b=WoaVj1FnlTQ5Lrd7TpcVJKJ+9+YOhymo4J/HxdWgQlucKNLUHAvrgSdduFdj155amtsWTpo+C3uLCAUIleQX17zVASb9rMgT3A08NKPqlhSGCVvXa6xJU0OkrdgoqwOuO+UmDW15CIbwrWf+cK05e3OZCgOe3gr5PC0m2K0uFveH+SW276ZQ3qfD45Yi8+85dE1Ln/XFHom77USa7qB+fcQ81Lm0EHDox5h4QEvMne7Ubep0kFL1uRvhBEqH6P1K9/xIKx8jB1iDMbh4c4EN3v7gy7Qn3kCCnP5EqCrt6naD2ESb5MKY0/vdMjTD9xX0xrDCiY+KTDTv/F8YxRieIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E/Ql11fBeiH/3cyZqSno3Of8wd/y5HRT4rZ45g2Qj4=;
 b=MeLsZVivwMlMfZQ9Bb8BYYQ7RE1EoyACjKoSUhR+6pCaT6k0AGOwRZfYMMuMuSm/gEgrVB/494au1pIy7JZ/BmQ9gP7VUeXnS44Lltedosl9iNwuQTqRONrDyoGZQdI8eOmBnTAtdsEY2tqH1aeVa8gvRoKyaIyb3qolohsBaoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4555.namprd13.prod.outlook.com (2603:10b6:610:61::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 5 May
 2023 13:15:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:15:29 +0000
Date: Fri, 5 May 2023 15:15:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 1/5] net/handshake: Remove unneeded check from
 handshake_dup()
Message-ID: <ZFUBa81y0xXrAY1y@corigine.com>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321386878.16695.14651822244436092067.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168321386878.16695.14651822244436092067.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AM0PR01CA0139.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 3380c17a-35ac-44ca-2367-08db4d6acc31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b+GzplpttLClTKybZ+MSugBJofbd0PudfdcWRzXkNstWoOf0S3aq5G7Vb2Kw7vVRcP/mOioQi7QildTZyAuSTrT78qsjHdnaORkmsnbd/s8IkgixVucwVxxbDUUqb2EfAfcF3nrQLXPSBiOamiRlm4dgqHypeVqfjOL30PPlPh6Dpg/GErfXrpismeef+M55BmPYcV4NLV/muZR4hSrjHpcnDRw3iYp4R5JRBuFi8O8lmQFGAU5kz/a4D4rvO/F2X1HIhF0t0c7kfRUzZkoYSNV0xK//JHhiC8xzVTa+Zdepnry8PNHdiIxr/QZum42Bzjnyou03h9ScAeInOiWrNjLQ5J0tfCd9r28CiUmfhTpXuFkkW9zKUrSKnfyYI/tPOmdsk5cIkcJNVvZwOpCmRQCEXjKsh3JQxYnGfOUVgtf8hxLo0MfjppAX539a+z8EH2pZ6ezZm0zRN/pm4EIpyGUtUGKJ1AaJtnS9hxNe5EacGXtR6SfkPu0+Si6W6qpx/fM0pwVwwF+Zw+90+NH7sMo3e4ZqWRpqF1ros6hd20bqU6kSx6/mH/CNhywbzpHI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(366004)(376002)(346002)(136003)(451199021)(2616005)(36756003)(6512007)(8676002)(41300700001)(6506007)(6486002)(6666004)(186003)(83380400001)(8936002)(66476007)(66556008)(66946007)(478600001)(316002)(4326008)(6916009)(86362001)(5660300002)(44832011)(38100700002)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXO9Q9YYL7Ol9QH4IxdEZvU/6drZGL/9Sl+ALuPf36BxnAjqa2ez7W0NyDiO?=
 =?us-ascii?Q?BI0ItMTfgrgmaw9A2d89RKsR0mZ7pL+Q+xhT/fh9xOcvHvreDXxBwL0cAAs8?=
 =?us-ascii?Q?L3hEu9WRcz48vfo9GJlbck6oIiJgoa0GxTXUhonnXCdUM8Ne6oobF8GiC62U?=
 =?us-ascii?Q?Qg7Uu5HKZ8yehedN9YoNVZoLvTOGmbmBFMv+H8z7P0C2ejqIcWwB4y0Bo38v?=
 =?us-ascii?Q?lA7HKDpRWg+tr1DACh0WCv8Pd0NgLjYcgzgIp2ME3YHZJ7MUNjKYgA7loG5C?=
 =?us-ascii?Q?yUWJGBV4m1Xc/6oUfordnWsbHygVE30hKWL2C+f7k3E//FBONsU2y9tmKJU3?=
 =?us-ascii?Q?Wv72f1F6e3nDLgGV91IxooIWT+DDGX3JP/y5UmMDa3htUVVJ7UtdxlErrX7c?=
 =?us-ascii?Q?47ctmTA9NeNrdW3B/vJ1lZAjtKuKWSEK0453ES3hxmzSdu/KWetmaPAUvwWe?=
 =?us-ascii?Q?gopro8NjlwniN7QbGoX83k2GHo2jh42VtyCkeD+h3GnGJOSot/EQdpuNI1Sh?=
 =?us-ascii?Q?otKjyNOYayb0LzThZZQpEfgJ/C+UP+pmFqRY+JmBoumsDd/mErwgs9Tq7a+k?=
 =?us-ascii?Q?Cl+qr5cxY2Oq5n+tUmPSlPn1Uzzk+AnLgD09Uviq8SRUB4ci9Pc18KJkY7bc?=
 =?us-ascii?Q?F54ptwLSrDggF/t+Lana2LUXLhOglYZ1RLWfh368bl6ouhgKbEzRKvlgWK5o?=
 =?us-ascii?Q?c4LsCg/qeplYeOuZWFLZri/eFrOu0Fw03miV6GmL0GmmjhRS+HIoOM44qS7k?=
 =?us-ascii?Q?16wmTTXPoMBy4djMQR/mxusny/sUJqrgwu0aKKl7CwuK6N3nc8K6Fr8Q1jMi?=
 =?us-ascii?Q?3CkFikxhrqkV6CceiaIqX1zY0tYkyR1C9BhsZ6zqT1TaGUum8IxZu8CfpTXp?=
 =?us-ascii?Q?UVu0feLM/eZFhqQk2ApSdLjqyslW47iXeFUPyFsbNkOYbcfpa/YmyMm7FfKK?=
 =?us-ascii?Q?pfYrC1UX6YAodAMM4ERYa0RR2s7e7UzI9RXhWv5poCWT8WPAcT+VYGCb4y3m?=
 =?us-ascii?Q?Iyq9S1cMAGmkAWorSXI7DoZC1vmzLeHVzqzYzg0r/ZKdoRktk6z8pa3NstKr?=
 =?us-ascii?Q?UT7XRKyhUDTaNID4c3LI6t94kC0TPlok2Wx1CqVHIBTl4pV0KY/yz2Wvn4wv?=
 =?us-ascii?Q?gcDbrvLz1sp5P8k1wUPvJWOhmQF+vgWzqiphUXNBMw7oU19Bqy3a1Np/mQAO?=
 =?us-ascii?Q?PesPaAWrNhToqlP/Pa94woCdt1Cq5BobRIjJJS3+2z/EFh7IEugnbp8/nlKX?=
 =?us-ascii?Q?E9/XV+J+QUUkmkln3fdj79sv3sdq5jgQ1p3BVkedNjKNhBBrXoGIbFdB7sYq?=
 =?us-ascii?Q?wjSuz/IZFil+ZIb8g+9KjZ2NrKDZWX1NGi3+aaNxA4IR8emP2VixRsj9GfjV?=
 =?us-ascii?Q?8GM2LdGf1Lt3HgaDgrbsrzBjwdAFAR/fag3zstzLQHEywYK2pHbqL0Y0i7Uq?=
 =?us-ascii?Q?l126ut2geLsmo99kCjdI4L/gy4qAkREXC0c9QzoBm8NSYYEt5jVVGH3doJFt?=
 =?us-ascii?Q?Pu5Zfj1b8D2OhLRbTnbDu0+irXQXwv97ZVAY1Wqhyv1FqXUwxNe7+95WDzJR?=
 =?us-ascii?Q?cx4L52TJZ3GZjhRp1P8Ys+QuAafWSWXZz7w63V9k0I756UKOg6qlppPjySD2?=
 =?us-ascii?Q?952OzbNRXmvjWWHKnDYQZLxV3LW5g4OavkxIDTyOausCQNYAf7VVp7+8j+45?=
 =?us-ascii?Q?yFG5Jg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3380c17a-35ac-44ca-2367-08db4d6acc31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:15:29.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TutqefaTkG7cT1mKPTKKFx+WlZZWaG1eoiaS6Y2rkJ4OmairiqMnSjydQ6WgJ8AlVHXG8+uZoHgh7zDLj5eeyOgOqu/kyFPWqudE93juPR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4555
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:24:38AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> handshake_req_submit() now verifies that the socket has a file.
> 
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


