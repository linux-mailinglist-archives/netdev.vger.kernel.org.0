Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29E160CA69
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiJYKxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiJYKxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:53:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7897818058B
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6V0Y8ol0WzkyIOJHhyJ4htuOxYvZWB6QFjkXGL5m03w1NBGo9c+UT+TKDKie/JJ8yr5X9EHj1yrrPNyfLEGiJyqOD731jR1lk3N/RQOeMQ0GRplrocnDuwG/Gk+RXIr9OrYS1Ub7TUIzftSuKp0rmChwO8uqbwEPTfv5EjYAMP/3YrCrhbgB46P22BF2HpWcNRz89WHBXMSWXaTk/z9rNqKt9CUC8SbR6NZbCVii2yl42JcagsHdkEBcj0nN3uzGbzebTAx46F6aHbQHlrM+54zp6dkNQZmt+UYwDfqBITwHBQe16O6fXhL6l7og6+W8uPFuwJiegHscLYz1BFiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mgrt68RTokIPjxFk9F1VtW4AgjAvWhPVw4wFYPgG+7o=;
 b=F7JXfQtXbsp/tgnwRYwkh1QV9OBQ8Be3ZnvwtQhCHawKwbi9Qo3ptIDKC9TvjG4oOS5r727xzgHcnfhbL0H2IpQcrsoAIV23nitJFyaeU94f7oMlQc/RRJyawk36NAaPWKwMj6qV2xaerbFYkWzVlk+TT80nUngCquwrsYNNgxo69YY8e7gxnuZFgndhM3yxCI60I3nhrz5zpYElYZzNI1OFdL4uBQ0eJrrkI+sVoRD8tsMXL4NL6Ywt1vnZqeussFjmvoDeObNUf2SKKJVAu5najtK+J6d+qB/nNHA71XHqza/IA+RW5ENU5THMId5zvB1mftSv0l8Fi+GTQPhgHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mgrt68RTokIPjxFk9F1VtW4AgjAvWhPVw4wFYPgG+7o=;
 b=pLRRqlS78PrNILEG8db0Kbjrzc97tg/uT92QegIJGh5zRaagxZpp6bQ26kpWJkh6R6zdpnptpPDPXrDfQy5ouBRbwinz0kugst2oK7X/DAzaqKS9XzB8MPFKRhCnvueghS4i/qEJmDVr5Sg44NrmxQnt/DQwChuXlHVDK5csoz9qH8YcTbxXlzA6rkyBVDQRokBdCnhTmc6/KJcrjxtxI+BYiW5QLYPFAxzWk97Y63fLSa5LSc2oSSB5GwwrxvVs5srFCDjFQxXKEArOswYn+Luet++fFzXyc6K1+gI5lzyENebDHzGdsfDIGkksFLeOz5cJweMYANfXiRB6Iz78Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:53:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:53:09 +0000
Date:   Tue, 25 Oct 2022 13:53:04 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 00/19] bridge: mcast: Extensions for EVPN
Message-ID: <Y1fAEDkgAG3ttvOQ@shredder>
References: <20221018120420.561846-1-idosch@nvidia.com>
 <20221018122112.7218792b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018122112.7218792b@kernel.org>
X-ClientProxiedBy: VI1P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM6PR12MB4202:EE_
X-MS-Office365-Filtering-Correlation-Id: 92271d3f-8c8d-4b53-2faf-08dab6771af6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sgc7FBmQTtLZoksxk8kY7jBr6VmwJQeRIgjhtQYlsTR4k5T+Yra1s19A4CcZJ5VjGxhRszprX/BiSm8BpV/Jh4iFIFTaUPI+3DF/D7Z3Q2nz4uH39M6dz6BY/+W40fZtLIs7oueg1IisDPX7oOOIWm4nME+ieZpQMXfLb8RFDcAlcciHy7rm7TKESc8f4UKnemv4zBCCGHZV8fc9z0SRhdlR4+hwyb6K7Qk2Dq5tKOTx9/nwhGHFpPeeCx9ZWTLuNyIzzdJkAEAmRM6fKyU4iZZVVCafxRYUSSnhBwEKKWA0ghmXKDpQro0A6Y/zJLb+AHk2g30255hM0aUAernTtEEBF1/AT9kWUkmx+K+cj4nNH8V5kf9TIxTlXrs5nsga5RWyLx6eD3kwxqOvipB0DUdYb8fvuj5fenSVSMcsykZPvtXhVIdEtLkNQzZX1a2P/ZGpbAUFtRffcD1EEf2o2M8I8Dg+aASvUKJQAHZJE/ccn2kCPspEUXqcLEetenat+1iIxaW0VU0gFcmBSFb8X9Z0BkW+YVy87GdG0ernytwQMneXqwILZ0XveT4e/mwaS89Mc6UQaf90sQMynHz+RkDC/9WCbeBe0U/Dx60mzCFYEw7CqknQ9eqJhQPJuHubJHTuYZ1C2+TiwWRtFXxDLpOr+j9GRo77OyG+gNZ5kEszJjhQM1KbP0eVTIQivPDjjXYpnrOwOeN2EflyeekNZnaq2M4aBYYJOltMxnsiiJkSnDvW3+84KIKKT1AllNOphhBH4RVy7GDhyqdi3s0Vf8HdScaloaLxsndES2Dd9kE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199015)(6916009)(966005)(478600001)(5660300002)(6486002)(8936002)(83380400001)(38100700002)(41300700001)(2906002)(66946007)(8676002)(4326008)(66476007)(66556008)(316002)(6512007)(186003)(33716001)(9686003)(26005)(107886003)(6666004)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NtaJWn8Uug+LDLKCGe68MprmkWe46BEkP62jk6VmT75wajK5EaMKpBOlMMp1?=
 =?us-ascii?Q?y+Ih8cNkBhaMp3pnHGZNE8mkhZllLz2h1RJzLk2wAWtHjLgT/AhAkGzvsGfV?=
 =?us-ascii?Q?gxSHQUUdPOXi5KqaTIck0NJJzxiwjLrvT0xrThLsWFmdopjezuMXKk0kmFe6?=
 =?us-ascii?Q?kFKjZNUBHec5ZFXhrGCnb869RglDVDfLYi+bFdnSVv7dl0hcg01GsXqYB5Wj?=
 =?us-ascii?Q?/WaLejpO1/MzAYvQef5MgAUaZG9Cp89GABUTAbIQhGRI2nRmFY1tNDHlPehv?=
 =?us-ascii?Q?tILRtWFtNLkwMnTuVz6wwzRlmaaIny7CBzVk/iDxfHDxAA9acoD8cgRfsnP1?=
 =?us-ascii?Q?ek5BbJdzg7V9T06S4i0H+O41+3NHZVcd46Aq4actbYPraLfu0BAVWaeBAvH2?=
 =?us-ascii?Q?7pwV/Ma3CgmSwidf0sQEvvh9/6nxbF3NQ/dg5b5kXNZIGbRD0JhPjML6bV5B?=
 =?us-ascii?Q?AKoPg+Zil9pKAsALV+linxRHLSLu4CXzUHjwUdRBW4x6c8KU4UCMYvwNrvdF?=
 =?us-ascii?Q?cwF3yct/MlC3wDHitJUVwhOpCJEXbnTlD4+Yfp754YUEcim51xLXy5vWiHL9?=
 =?us-ascii?Q?SGor0WmUtIlsFV3dQgMu6KPfjW9z0mPhrxgV90g7v3KKJZeBQ1k6DbM8Oyas?=
 =?us-ascii?Q?uYrzCjNr7NUjfk6uFW5HKXV5y7ch6d0kt/KIaNdTxRoCg4A70XU+UOhPvqKS?=
 =?us-ascii?Q?n7t5ZIciILVEDDtPdr6eAiAtzWk1i234utFY4X5cix+Y338SyN1nlfI+hK6c?=
 =?us-ascii?Q?iMr+KtIYXMjO59ugIEVkRR2fTqb/qmO62pbgVlApO6mD4ZLwaIMxb+r0UjrJ?=
 =?us-ascii?Q?/FWFMibvbTmk4/mMdUNW5QqLNTdM/U1eYOJma7XGsNtsDNfPhjX0yjtaYfKI?=
 =?us-ascii?Q?JtcxwqLbHyyXBY+mU/jElwmU7ZdC+yemU6zPMc77NP5vgQJIlvejKub13ug/?=
 =?us-ascii?Q?q8fN3pT7OLLNP+2SRsFv8bbjBqoerWJOOk8AQFSfS9ZxmOapI6O74QTKqUnz?=
 =?us-ascii?Q?/uQt51p+Sxn6Z9dnEmVT14KzuNNOzLS1DfLxLRqccAfYr5a0rXgyEbOu0Vne?=
 =?us-ascii?Q?AstD7S6M101d94aVbmky/Mji/uiitAscYs2cAxrso9Vr6bKVWK/KjMJ2Bu/f?=
 =?us-ascii?Q?+L9P1aUnCbmMeDb9eLkD5FDCxT4vtjYdeQgAWhnNc9b5VDhRvgd1mDNAc4FD?=
 =?us-ascii?Q?pM8Zuq0np8VjoSj4IVcMxXtAv0SLDSp0dn/2q5gvGAEPeXC1+jXiQgDfQAdH?=
 =?us-ascii?Q?K1vlbFRHcPQWhcwF414Zfodt3O44YVV4SIwN6uXltnqRtpQ8TGctx9hTFU8B?=
 =?us-ascii?Q?X1KLEGvdwd9cIAxVuyknVm/H0gBqTEgNA1N/KAQlau/ijDiOw6/cqp7Ug08N?=
 =?us-ascii?Q?cU3ArSVW3MT5lveqJwvV0QkzvA9gL3CPfURjcIeOeS0dScsrRQm+vX0DIiyu?=
 =?us-ascii?Q?NvDi+ar1VYPt4QzqEUh4a0jt0ljbtgDlnMmhwTFIZ0690jjwbEVWzlZJAOV+?=
 =?us-ascii?Q?2mjhAb8kXZTF5OAJPg6sarAkwRmWmMIDov9KQT5X3r4eJ/8CYwnV2CoP9eFR?=
 =?us-ascii?Q?B16dvarjLwdS6BCIf3mRvcmAVMYCyNcbBjV8vQZi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92271d3f-8c8d-4b53-2faf-08dab6771af6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:53:09.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhAduJRhJmIbwNmWZx0d2NjhTU1UWG7WR5ZghsFwNjLinu3IlRdhTzllIIS1c35XckPB3TIdEEvXzPAh39EvpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4202
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 12:21:12PM -0700, Jakub Kicinski wrote:
> On Tue, 18 Oct 2022 15:04:01 +0300 Ido Schimmel wrote:
> > 	[ MDBE_ATTR_SRC_LIST ]		// new
> > 		[ MDBE_SRC_LIST_ENTRY ]
> > 			[ MDBE_SRCATTR_ADDRESS ]
> > 				struct in_addr / struct in6_addr
> > 		[ ...]
> 
> nit: I found that the MDBE_ATTR_SRC_LIST level of wrapping corresponds
> to how "sane" formats work, but in practice there is no need for it in
> netlink. You can put the entry nests directly in the outer. Saves one
> layer of parsing. Just thought I'd mention it, you can keep as is if
> you prefer.

I guess you mean:

[ MDBA_SET_ENTRY_ATTRS ]
	[ MDBE_SRC_LIST_ENTRY ]
		[ MDBE_SRCATTR_ADDRESS ]
			struct in_addr / struct in6_addr
	[ MDBE_SRC_LIST_ENTRY ]
	[ ... ]

It is a good suggestion, but I wanted to make the request format similar
to the existing response / notification format that already has this
level of wrapping. See example in the commit message of patch #17:

https://lore.kernel.org/netdev/20221018120420.561846-18-idosch@nvidia.com/
