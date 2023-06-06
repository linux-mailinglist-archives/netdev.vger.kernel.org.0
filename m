Return-Path: <netdev+bounces-8391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9807723E0B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4F892815A6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89EE294F4;
	Tue,  6 Jun 2023 09:44:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F9125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:44:55 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2090.outbound.protection.outlook.com [40.107.92.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15520E49
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5Sf7jdX9GRsTwLUVdKuZiaNpIUh9Kb/5j4FuFs9YH3PX+9hKierauhWSNG9QrlIsxPKNwux7ObVrzogI7NDGOBJXMafN1UgYQ+IvKPbMZPxin7XM+3FMScriweO6zVs7T4jUvEYCCLH9J3C9SE+v0TQdVkzhmY72DkhLFfkmOTDXO8X8i2a+hUbrtBofZ9KpeuhiK6kLca/+MUpsc4PJaeEmRbbW2ftHfxWVvebUh0L52xHMVuv/4KyWL3xyi+aCdrQoFTKqYsBngpsS5GESIkw2eObyqIbQSpIbRMvBha/iaXCSCVEWyeibPCLa98UgAfdCHJSs9oFrQr467qxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQxepnGBpnrJZ/SJyN1tBrd8PKo1sun1vLUg9qe9JBA=;
 b=Ehtw6Ijxpen2nY2H7RY7b0N+Lks0Rhh9qV855GU02aZwjaBmnVqQ3pt6VeWjKKFBAfg7TZkIVtS8/L29a6kucHgH9TTAWPhpo0CtMH/0ED1xTTIV8I5JL/b0SOU7uPjLXdhxfaYrOMXCy+DoQUDAGDbG8wQWwnb5pDHHDoBSYfwLdxhTRzv5co4dRFF9ej4UMTV7J65KE/C0W1M8MmssKAhJViRmadRzTFqWCjAZyPFggwf9FFDAHEG/wS59fjVELT30pZORyK350n0MojGifDMKP7M9hlHw7YAGwoHKhm5Hs6eteXncWtO9f0EK7+ytbfYXk1s6dXr+LP9O5/MSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQxepnGBpnrJZ/SJyN1tBrd8PKo1sun1vLUg9qe9JBA=;
 b=qekSfeu4/u/ekv5w5mCVoQQE2yCny2QeKJZGojx/cnQU+sFrSzkcXzZsn5EeK7PezkWDxNPY13bfSLVG7RoLpuW0qsWkwjj8HU35yfLG9KOFdPkzc7MjgPulYazm5CXm6eEhiaO3Fzmhd7d7ejC+RlifTBx+3937X5jXtUbdbNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5363.namprd13.prod.outlook.com (2603:10b6:510:fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:44:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:44:52 +0000
Date: Tue, 6 Jun 2023 11:44:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	eric.dumazet@gmail.com, Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
Message-ID: <ZH8ADlYysPKEPuWK@corigine.com>
References: <20230602163141.2115187-1-edumazet@google.com>
 <20230602163141.2115187-2-edumazet@google.com>
 <20230605155253.1cedfdb0@kernel.org>
 <CANn89iKhSv981L-WHn=479U2XniQXU0qNX=yoAaWBA1LdY4B4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKhSv981L-WHn=479U2XniQXU0qNX=yoAaWBA1LdY4B4g@mail.gmail.com>
X-ClientProxiedBy: AS4PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5363:EE_
X-MS-Office365-Filtering-Correlation-Id: 5853b047-30ff-4fb6-48e8-08db6672ad28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HXMhhtXLETQXdo8MtCbYBKqR8IlPRkV012Nd6oQzrr7VOMT/4ZkFrwTMv33z10bU3IL5MnAJm7jF/aI0Fz0p69OEyA7AuDUg2RBPkr//92C4a9ioxDhLcjCPuMaC+MmGHzb820a0vGPkWxqA4xHIW7CLdMBPPtuMz1psRZaLfJ4R/InxTYuen5KHKMIMI/SgYfCiDTrhquE8YFBLKXVYU8EZu1uym5++F5AT1N47V2fXJvldN4wH9dagXzRYgO5TADNHKAYfTcZT/GGr7yYyVk1oWTWI/xEALrdqC46tGvOt+FO1GQeU1c+nECP3NvFAl85Mz66SRS6BqsgPHzou1JGQrr+XToL9X+4ZOZ6xwh/SwHslO4NOhavRigIzKSVYI/3z9H1ntZ/6/77y4ehItAT5ftQRiRnqc5Q9/FoDg3/inVTaYK5HVaJxfiWAD3Ay4pclFJZUSRswImpoKIReMMvMJf4uDaNW3cqk4FdiF0TUYJJ+ZmPHHm/yxtxR0PwBv2aW/YPO/dolc3hPE5cXPcQx4D9bsEeOoeKd3RV+whrhSEQX869HXI0ZUX1DZTJDPhONMqoJhkDpMAP7/RNKiZsErBGv2DmD0njf+/wQm5o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(366004)(136003)(396003)(451199021)(53546011)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(186003)(83380400001)(478600001)(54906003)(66946007)(6916009)(66476007)(66556008)(8936002)(316002)(4326008)(8676002)(5660300002)(44832011)(2906002)(86362001)(4744005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTRaQU1wdklLMS9QOW1rV1VqbmlMK3JHbmRlTUtjTEZFU0VtdHZMVUViY3I0?=
 =?utf-8?B?WHJoZFhTcEJjMnltcUZyZGp2b211RDRnOTlUc2RwR3VXZWpsV012WVBHRUxq?=
 =?utf-8?B?MVdvMnpKWDIxQmNaaGNhR1U1MGc5QWZMbnFEcUNKWGZxRXAxK3FvS1JnUjhY?=
 =?utf-8?B?dlBhLysyd2dQc25yZ2x6dFVNVjNqc0xWcWthMm9wWi9qUmQ4K1RpMDdJbHNy?=
 =?utf-8?B?UlBkNTJ0ejlsZ2ZKalM0eVFBNkRSMFM1cUlDVDNZM1JhWXpIOEVSUWhnbS9F?=
 =?utf-8?B?cGlRckpQZXJkRVhjbGJJZmFmRjVrazFMNkNjM2pUZVVocXNaU0QzRHBtbS8z?=
 =?utf-8?B?cU1QUXNZVlNLejhBWE9LYXd1cExmVXdha21LQkdnUnk0STdYb0JrbFBUWFV6?=
 =?utf-8?B?MDF1UVd3TzZkM01tbjluY2w3MitvQlZ5TGViK01BUHM3aE1sTmlqMTlwVnN0?=
 =?utf-8?B?RG94cmlQaHVMWUlteHo0eWRheGxJZXczL2h1YzZKUVVraGZlTUk1bWYxbzhj?=
 =?utf-8?B?Q09ma0FQQTNNSlRpdnVCWldvaHVJdWk5UGp2Mk4za2xuVkNwdUVJS3hvVUdo?=
 =?utf-8?B?ckdqZ3pMcmVoN1lDMG5vRTRzT3JNaXZpaUR3VVlEZUZqVFhxZTRjM3ZTV0dl?=
 =?utf-8?B?U3JFTkxITHpia2pCQy9ZUEN4aVMzQ090WW40RTd6d25qUlg0ZWY0OHBCcXJU?=
 =?utf-8?B?QkY0STlKekQ2QW5STHlBd1E1Mk5ZYU9vdGpQeUF5aVk3MFdHRUdLUVI3bW0y?=
 =?utf-8?B?MGZhWEtjc3N4TUZjUVZRWVlnT3BQWWU0VW5oOHArSFlaR1RnQy90MVV1bUo2?=
 =?utf-8?B?N0J0VDVkeUUvSGZBOWc0Sm9GUUN3S1RrbU5zVHNwOWxZS3R0aFhqZGJsRy9Q?=
 =?utf-8?B?cEdJSEs5SnVPUUdaQ051alpTcTFISWJKbDRZZ0JsUkRkUmZ5b1hEM3hCcVM0?=
 =?utf-8?B?ekppYnpVdmZkVzZ3dUZUT09hL3BCb0lQSUJFSkZwQXNYbmFobW9ZTG83eElv?=
 =?utf-8?B?UkNscFNFNTJrRENIT1BlS3pUd1RYOU9PMm1HRDd3eVhZNk9DeDRKREMwYmJE?=
 =?utf-8?B?ZVFGQ2d0azNsQjVSVTBFQVJMVE5jN3YySTZwYlQrdm82WUhhT3g5MTVDcnR2?=
 =?utf-8?B?LzMwZkNVYmxLNno2QmxCWThyWVZiUk5HaitpaXFvbGlnbGdPd0xRSEwrRi93?=
 =?utf-8?B?ZnJhQ2JCM0FpVjU5bXNqZ3EyOFk1Ym9sUDd1N2VzdWF4TmFTUUEwVzhxNGp6?=
 =?utf-8?B?U0VpdC8wUHlwaDFUY2xyL3UxeEh5NDZYYjVGcjR6WC9Uc0xDUEM1cHdXZ1ZZ?=
 =?utf-8?B?dGQ2NnlQOG42clZpejEyOWJWcHo3dExTZkVMSUplajZsa05neXNUVGtiRDUz?=
 =?utf-8?B?cmp6UEEva3VLQm1aenIzRnRMUU83NFl2bDNCRmFIdXZacWswc0JqOVRzWDc1?=
 =?utf-8?B?VE11M1d1bzI1MUo0Vlp0aDdpYk5QVjNBSGRmTTdqNlZZRTNiZ1NaYmlRZUUv?=
 =?utf-8?B?cUJ0bDBDbGlReDZ6TUt4b0hWVlA4UlNIU1o0L2lrREdxaEV1bDdMY2thbi83?=
 =?utf-8?B?TDJ1YW01aUNzQkplMjc4Ui84TWM5cUZQY3R2cmFWaC9IRUYvVkI2cVhUSW5R?=
 =?utf-8?B?dVdlZGRZTXZQOVkyaDRZY3RiUkgxaS9MSlRLanBDbThOcy96cGp1THZPVWVL?=
 =?utf-8?B?cUpJSTBQNEhkMHRFeFhtT3hadmpkbXZMU2hKRkJlZmZBcHZCMGdhZW9WK3k5?=
 =?utf-8?B?Rm5sbTVYQkRHL08zQmZGYU1ET1E1RXBmZnA0QVA5L3FQZjE2OGZjSldPbTdh?=
 =?utf-8?B?L05ZNlB3Qy9LNmNGRXpDMXd1TGw3RkE1cjlhRlMxRkpxNDFVS1AyUGZpU2h4?=
 =?utf-8?B?TGFYZFczZDJBVFhCMGo5Mm9udTlZZkEwRmphdkhlNHhDMDF0VndrRUFFODll?=
 =?utf-8?B?OVhBZEJPb0lNTVBzT3pqSC80ZWtUaUlKamhPUFpRcE4xS3JleDZHOEN4MHpQ?=
 =?utf-8?B?Y3d3NFZLN0ZqVkdYSjFsSnUwWi9FZFB2NXRGY2hHM3k4Wm9ocnhNaE9yaXJJ?=
 =?utf-8?B?R2dxUUpEWm5zNWxmbmVWSE95WndwYXhyTFhLQjdtTTFGd1ZRaTFTM0lJT1Zp?=
 =?utf-8?B?aFVTMW4ycVpvMjdUN1c3RGlNVE9KZitSYTYvbXRTdnNQeGZUdkJXSmdwbWkw?=
 =?utf-8?B?Vm5KM2tVOEdKcTRGVHNrelZKM1BvK0NYZ3hqV0pRVXRxZHo0QWdRc2R3bHF4?=
 =?utf-8?B?WEpXM3hqeElyaHhLZk04RlEyMCtBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5853b047-30ff-4fb6-48e8-08db6672ad28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:44:52.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p2NeORkIOIWN0D3DPvpYHAcbhhGiREuw1ALwLwtVcgGgPOdyLiJxNkS7qmnlKJvafHT3Y6l27lKyXOO0tdK2jSubpbraA5UMbRnP0nTd+zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5363
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 09:30:12AM +0200, Eric Dumazet wrote:
> On Tue, Jun 6, 2023 at 12:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri,  2 Jun 2023 16:31:40 +0000 Eric Dumazet wrote:
> > > +             if (sk->sk_state == TCP_ESTABLISHED) {
> > > +                     /* This READ_ONCE() is paired with the WRITE_ONCE()
> > > +                      * from sock_rps_save_rxhash() and sock_rps_reset_rxhash().
> > > +                      */
> > > +                     sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash));
> > > +                     }
> >
> > Hi Eric, the series got "changes requested", a bit unclear why,
> > I'm guessing it's because it lacks Fixes tags.
> >
> > I also noticed that the closing bracket above looks misaligned.
> 
> Right I think Simon gave this feedback.

FWIWI, I think it was Kuniyuki.

> 
> >
> > Would you mind reposting? If you prefer not to add Fixes tag
> > a mention that it's intentional in the cover letter is enough.
> 
> Yes, I do not think a Fixes: tag is necessary.
> 
> I will post a v2 with an aligned closing bracket.
> 
> Thanks.
> 

