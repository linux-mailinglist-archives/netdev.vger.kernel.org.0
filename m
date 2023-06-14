Return-Path: <netdev+bounces-10606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6D272F555
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEDD81C20C70
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A02AA53;
	Wed, 14 Jun 2023 07:03:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DDE7F;
	Wed, 14 Jun 2023 07:03:03 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::71a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BEC35A1;
	Wed, 14 Jun 2023 00:02:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjoqNEKAKaaBteEeqHf8QcW23b8oP4lbaZ6+dau/TyspayvyIZ9jKRCu+cXleb6NXd+3ucXsTE2BCqbAOLk9DfKSt0d5j/xyx8d9z2HEiKxmoE/6aSEefNBhsI/joRdg6ICjTSiaf0/ccmOckUzwLQL6vr30uhqxUldQorHIwzYsw7OZtQgMzi6xXPj/SQz72cTnRyHJ7jPbMIgWCoumodEpjtYn+8NlEqlBEfyJMyUOACNfFo3B6CUlALdnCquzE/kWSKRmCEgBaiWU77pVNgJroGsHFBGHsi+1GVQNbVjGeM8gpnSyjiJtI+GfjDXanPZoZVfN9ZVjrb98nEFV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qu+Vu1Fqr0izpYpHUXGiPlAZfxJEN/1hL7VSGsaCCDc=;
 b=Bh90o9otGsnc6bXnca+u6PRm03fSg1HS86GuqWSQ89xkZG7XGg0LzisroVwEqLOBbvmNWgKehPJV751iBEAlV/7mqoP1gN21zRhQZmJckRo20Y6hqu3BIA9qUkMTesaiMeWVNslJHIuAA1sY0lmWvWmvdFCh0v7Gk4X48NYKso4OERRBaRwiIda1VXTM+dvpuor2x2r30mXLxJjVe2hQFXjT8BN91VeNRL7wxWK3F3KhDPDWRjDApEuFigh7oTymZkdTiL8b0Ma+po80EXCbE0pnqdnxIOUKGoHUM/C7WlmzDLrinSK04SRIJ9ZO2yL+S5RFlhMmnfwR9m/djwy7Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu+Vu1Fqr0izpYpHUXGiPlAZfxJEN/1hL7VSGsaCCDc=;
 b=sPBA4ihCbHi6Bi9OI+S27IRAsYF6wRjCU8MoPuKnhNCRjPf2hcpOREgC009WSa4SkkSg9UwNSW2wTwbIxfjbm4NtIGor4XdPZybsLYPje9SpN61Xc0BetNzmqRzZzAwxZrz6B+mXzXUL6+xC1z3yl9mUtrwNHY/hUICpKqAb7H4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4829.namprd13.prod.outlook.com (2603:10b6:806:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:02:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 07:02:31 +0000
Date: Wed, 14 Jun 2023 09:02:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
	yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
	haoluo@google.com, jolsa@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
Message-ID: <ZIlmAB4OYUvfqQTr@corigine.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <20230612172307.3923165-4-sdf@google.com>
 <ZIiGVrHLKQRzMzGg@corigine.com>
 <CAKH8qBvfp7Do1tSD4YiiNVojG2gB9+mrNNLiVFz+ts4gU+pJrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKH8qBvfp7Do1tSD4YiiNVojG2gB9+mrNNLiVFz+ts4gU+pJrA@mail.gmail.com>
X-ClientProxiedBy: AM9P250CA0018.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4829:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b0c7ea-7daf-4272-9cb2-08db6ca5525e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rHkp9A3a8NMWqxdcX8sXxAA2zLzEH86x3VYI+WuWuoF7a2iYO+JKiOzey/EJvPzL7bGMz8jUgpyUYYTtJUWotsG3ZNmJOPdppDwfIm03lJowydSzOu5T4PzmnBbB7w2tDWxpO8GqZOuGCVwhVohLfFDzKaCXdwjpIn/v0EfnZ3ZwAO5GedMAydR0DRyQuhy6eGPNbMWYqczQK7i4GgPOlIYbMz6iAwmOiapyUiYvHwMTf77rlH+sQsHoL8+dcmLauBqSjOkMDUZZEG3d1qAt46rnguH9z9TL/ZkltjO8jpwaRMS7Q587W1QWfiwExPHFJxRx3qnxp4Uggvq+t6s4P+d9nZyVJDUo4Jqg2Lzk+gdD7zXJFISjkDD2kEVYUwL91fB2LIRYYD6DCwDC2cI7dJueKwWHwna21rRw2e8ZqoEpJO5h0lQhx9Y1UcCm2iXOlGX/rxlzxolBwRqDDm+XyFsAXAPPrPmHav/QjvO3UjxI4xJsVKIAGheoMC33dRgKKtvVQvoFMrSZBjvIljDfBfe10Q+oKG8VmmCyaz0yQYwYLe4JVTP/CyfHGB5EDvpA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39830400003)(136003)(396003)(376002)(451199021)(86362001)(7416002)(6486002)(316002)(8676002)(41300700001)(83380400001)(5660300002)(6512007)(38100700002)(53546011)(6506007)(6666004)(44832011)(8936002)(66556008)(36756003)(66476007)(6916009)(66946007)(4326008)(478600001)(186003)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVUrck9EUmsyMnlZQ1gxQ2tZVTV4NlREOGxFNzdxMnpjcTZWNHp4aDEvNmdv?=
 =?utf-8?B?VlNGNmhQUFVOOW9lWEFic053aDViME1adnlOajdTSm03Ky9FakZ3bmRzR3Zz?=
 =?utf-8?B?OVlSTzRudUI4bEVDTkUrc0hHVGZaU2JzSURUNHBmcThDSzJ5bUd3WWlEcGt5?=
 =?utf-8?B?WXNXeDAzS3FSZWlTVlZHYmJpQTNqTzVsNXdPUnNFWnZmZXV3MVh5NkhXdUI2?=
 =?utf-8?B?c3N0RTcvR1RGbFh1NGp1V0tjY1hqVDRUMXZKaHJyb3FMYncxeDlGMkovWGZ4?=
 =?utf-8?B?L3ViOUNrZFpUdTZQTkI3OS9TT0hHN2YrWHFqSlc1RHlqUXZVMmZ5TTI2WjlM?=
 =?utf-8?B?SGtCd2k0SEJsNVJtSW1jU3BEUnpaV1J5WmozSTF6dTNZZHJpRmNIVEd3MHBL?=
 =?utf-8?B?eVRsZ2l2M2lSRzRSWnk1T2FKQ0FaN1dha2xXQng4cGxzUnNhb1JmM0NUVUM4?=
 =?utf-8?B?a21TdW8yKy92dnRuRndURUdTMjFZRHZNY0x6akNqZTkrUXg5Q3ByMmpmdXE3?=
 =?utf-8?B?Y1QvOExoOHl0YStSb3dDZGNiSUV4d2JJSmdsOU1XcXdNS3c1RGFuRnJFb3lR?=
 =?utf-8?B?MGVnREtqSmZveHVDZHpTbHFVUFN4M3QxT0ZNSmloYnlQZzFUUXVCcHR3MEpR?=
 =?utf-8?B?VVZ2QTczdDd1dCtES3dpVWhrK2NpUGthQWlIekFFemJCMzRtdUc0KzMrY1Va?=
 =?utf-8?B?aERHQTJaNERVMWpnc2JJRmtRekE5MUxmZ2s5azdVclJsOVFnekpYMzBndTFW?=
 =?utf-8?B?eUl6YWJENDE5eGJxTXlvQWdUNk16dWExZjJHMlJCU24xcXFudlBKRHBmZnFG?=
 =?utf-8?B?MXBMUlAvc2ZmNVZudFJaaEp3ODFmYWd2T2RPS3ByNTEwZXAyTFEvQXB3WnR2?=
 =?utf-8?B?bkRjZXNyQWREVUJidXVZUDM5SWZnRXFxVTBBTk1zeVRNcllSZXEzUCs3Tlpk?=
 =?utf-8?B?d1BOOGN1dEllUjZkUTlpSjVWNzI2ejZidFBYMFBsNFd5WldaZ1g0eGpBRmky?=
 =?utf-8?B?UHA4U05FUFIybFRkenkrZzRhUFpFRFFtaWNUUjdDZG5uYjFaaVlmRStyUTRY?=
 =?utf-8?B?Y0wraXRIaEIvSXgzOFducDU2ckdPK0lWMFVzU1ViT1pDQ2ZiNytkcVlmTmNP?=
 =?utf-8?B?eUVpeEM2RTVGNkpVYmIzcVRLUjIyd3EvNVlJTGlTdzhDb1p6SlRpMnhlblpr?=
 =?utf-8?B?WnlCcDZyeExhcHZRVU93K25NVWNpVlpqUTlQTTdZTlFyanFIcjhpWHZnLzJU?=
 =?utf-8?B?cWFrcTFCLzRKN2YvOUpRNU43VExrMUpmUWE4bEpBRkJSS2FONTlqb0dTT0dQ?=
 =?utf-8?B?bm1rbEdxL1N3YVRsSGN5Y3NQYWhoN3NpQ3hXMlptdTd4YkhQVXVOQ0E5Z2l4?=
 =?utf-8?B?VCtsazdZcG9qNWREcEVrYWdLNUYxaWt6N2NnQXdwL0t4THk1N2pUY0VjYTZv?=
 =?utf-8?B?ZnNITU8vdjhTT1JmbSt6UC82dUR4SVpZNjQ0V0Nsa3FnWkZDY2tSaUgzcFc0?=
 =?utf-8?B?bDVZWmltNEFMQWxXcE93bFNhZDJnY2hlY3pTMUZPMEg1MENHTjRNamsrZFY5?=
 =?utf-8?B?bmRaR25uVGZCaVVoZHJ0T3NMMWEzSEcxV3hWZVEzZUFjSVJzTDFsaTgyNERP?=
 =?utf-8?B?V2VvdW1XcDhiQWJhbVlSWWoyUWViaWc5YkZjS3pvbWY3S1lKck93UnFSOVhu?=
 =?utf-8?B?KzlRNG9tMlY1NllTcUllVkJxU2FBMmptMXBSVmlrRStZRHJ2OUkwRkY5THgx?=
 =?utf-8?B?N0tQemY5dlNJR2dhd1FOS0Q2bnlESFV0bEtRY29VL0VkOUo3cXdMQ1ZpdzNU?=
 =?utf-8?B?aG00Y0Y5SUxMWlo1dGtsZDVtbk9XQzFyM2YyUTYrMyt5cm9jbUlHZW1kbm1a?=
 =?utf-8?B?R096Mzd5TWhKRlZjaW1mL3FPbExpeExJSmJBcW1aRnRLZWRsNU9mUnFlWm9x?=
 =?utf-8?B?M3pGeFlkbDB6a1grMVJ5WXdxWUN4VmxoZVU1aW4vdmFseTVpRURZeG5zR2Nq?=
 =?utf-8?B?RmQ0Z25jWURVL3B2VXBvL3Uza09TTnhjVStTVjdyK3FpM2JWTk1NQldzelBF?=
 =?utf-8?B?emdmRFRPN0F5TWIyTTgrakVQajVLRlJPL0grWlJmUUI1R0I3MTZmKzdlM0Vq?=
 =?utf-8?B?RVhKanR6MEtOa0R2R0NoTi9JcW1aRDNUR0hacVl6MTY4dHVmRzdmcGFnTm95?=
 =?utf-8?B?b3owYkhvL25XNndaKzJmV09oUE5KMWZoOFlDenJwRm9Zd3ZYc0pzelEwSmpG?=
 =?utf-8?B?OFk1bkNOWEFmMnNML2k1NTkzdXZRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b0c7ea-7daf-4272-9cb2-08db6ca5525e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:02:31.1920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irayT3pKltS1RqgY3tTEn/NMtLsymY27KlBffth79Ar0BYGMVLoBv+A3yg/fKNEyc/JNB295F8tzcuJuWDrFhbxjWHRPz5nRCVoAGmi4CB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4829
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:00:25PM -0700, Stanislav Fomichev wrote:
> On Tue, Jun 13, 2023 at 8:08 AM Simon Horman <simon.horman@corigine.com> wrote:
> > On Mon, Jun 12, 2023 at 10:23:03AM -0700, Stanislav Fomichev wrote:

...

> > > +void devtx_complete(struct net_device *netdev, struct devtx_frame *ctx)
> > > +{
> > > +     rcu_read_lock();
> > > +     devtx_run(netdev, ctx, &netdev->devtx_cp);
> > > +     rcu_read_unlock();
> > > +}
> > > +EXPORT_SYMBOL_GPL(devtx_complete);
> > > +
> > > +/**
> > > + * devtx_sb - Called for every egress netdev packet
> >
> > As this is a kernel doc, it would be good to document the ctx parameter here.
> 
> I didn't really find a convincing way to add a comment, I've had the
> following which I've removed prio to submission:
> @ctx devtx_frame context
> 
> But it doesn't seem like it brings anything useful? Or ok to keep it that way?

Thanks Stan,

I see what you are saying wrt it not bringing much value.
But I'm more thinking that something is better than nothing.
Anyway, I'll drop this topic if you prefer.

