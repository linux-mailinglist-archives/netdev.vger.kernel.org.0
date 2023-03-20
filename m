Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82AB6C2238
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCTUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCTUHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:07:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2103.outbound.protection.outlook.com [40.107.92.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF4AEFB8;
        Mon, 20 Mar 2023 13:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+xXkHNLY5WbX7omX0sGIzKAEBR1fJR/wbZNBFkB3+XOviJlUBTy8vrP/aAeepHzceidZMC0ETlnfqAA8U0EANLaLNu58NMXho2rA+hYp+OqOmJCiMeYQwewcEiZCdLaYFFEhaX2zLFwEX0DEG7CEoYmvbS8nwd50NwVBUnB8Nik9CXwY7G+oJpMbu1AGHQXaWGb/3cGsgMaP7CEI12+I8Vs2e44srBjHRGhb0TcxAxl0y5wX5wVlqaQ0y7tAZPsDvUUeZGHvihKeieFoGyHhbdGmyKK2FYUBoZnMwoczrUPgG1CG/w+lz2PkL69L4O29a9w/wYu9WFvF0Gp979NkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hY5uEtFgUJ2MrwOQjLDRZwwXndPHBBl4vjgfrhmfdM0=;
 b=kUM4BaBCCIcOhal/LSRHD75s3WmP6nofC0LwktLjBKRTI4eXq4Z4n8PSxw7OFCE403Yh6061LKhorTJqe7JSrRyOWKnLf/nm+uIWjTZ/lThn/mP5xQOKaDQxetr4BTtmmEtPqepjsf+zk+BMM/5ttLvVsWiAErCh+El0v5RUsNr0ujcfPLyAXElBsBUp+9uWS7/2FWCTh1yyyKXLB7bnmkEkQoMO03r8+O4FGjJCrPIZMAxlZg4oJeoN46PtynV82ueT0FdYu28MZZoRasZUiojykqQr19p1/7D6xKZ3eUxacIHGXO2uyEZZoiYzE9qZaluHMjL+4l6nYQZDGxONxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hY5uEtFgUJ2MrwOQjLDRZwwXndPHBBl4vjgfrhmfdM0=;
 b=XD4GvnNcLiZLdpB87V3U8/ai+MzQm6iHm/Fp/3PONrdTmcZk64xYbr3pINLY70U/ck9SnrTil6qDcySVHgRQsPZOlOjJbX1MXLRCj+jYXv5TqM/RFm5UsiOX9WLnasmdPLGgFYT3qZhUJctXw6jY8NVUD/fIJoD8RSabZq9FbDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3675.namprd13.prod.outlook.com (2603:10b6:5:1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 20:07:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 20:07:17 +0000
Date:   Mon, 20 Mar 2023 21:07:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] net: dsa: b53: add BCM63268 RGMII configuration
Message-ID: <ZBi87pSJYUqOWUp9@corigine.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-5-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320155024.164523-5-noltari@gmail.com>
X-ClientProxiedBy: AS4P190CA0051.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3675:EE_
X-MS-Office365-Filtering-Correlation-Id: e4eb6978-4f77-44b7-8022-08db297eb4a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZAt0WsjsnpIbO3ZdvCpn+ww+dBv30iWR5q/FtjlrxT9PkqiQ9knW4b807XjjKhJ2bM2jucaAuaebiQq0zH/0xEs4kMWW0bF+SDlq0acw6yBFd4AhFCU8vgDqQI4qv6lFYG4o1kk5QHBd29PvqE9zAOIT3jvOpMu0Am8ZbONLvyv+cLNPxCkgPPV0CRcXd0fluoMwTP0TRNEhe6nrGS8zHb9cXvveU2HwvQrmsqAyn7pK/EqXHBMFKGn3uaEzlQYJsoyVnJhjPJ+6TnoSqfrsD0lWOL3ui+wahfLXJyls1os4RHawCcUpL/X5OqlataFGeQxWcay/Sp+xQf2VCU2EygRhyxt8x9jj6Ef8ai2DuALGw0xIWolqUYisWanoLQETZvPSZJ79uzO8a1WG4DGaagUkeyyR52mkcdvYNXfwdFeUCB9atSBR2tQz5mw3t7ZSlu6TX6MsvKhlzgU28Qisu5Z3bvbFe87a42iX8PmyX9iETIoHqGh3DSDfgSrxt+RtZHQ9GNjkf6OSNmhJrSyNTgp0IgKnCnAu763L7na6R5gunmel2mQd6Vn8XfXZefr8Uwc81Sv5nCUOzLulFRuAzfjjC6vGMqt9cZ+0Wc4Jp+zEIKdOk1HfBamIpe+FbRPEuYa8p9q/kz85ldsa1RCZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(136003)(396003)(346002)(451199018)(7416002)(44832011)(6666004)(41300700001)(8936002)(6486002)(5660300002)(186003)(2616005)(478600001)(558084003)(38100700002)(2906002)(316002)(6506007)(6512007)(86362001)(4326008)(36756003)(66556008)(66476007)(66946007)(8676002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG9JT1dKb3BmZXJ4R2JhM1krM21nOUl5RWR5a2REbERpRUQzbUNLNmduN2R5?=
 =?utf-8?B?alZrRjVIdGtCb29CUTB6RWZsRDM0Lzh3TVhBOWhxWXpmbGxibjVldXZsclRF?=
 =?utf-8?B?Zm1VVnVTMGsvb1NxekdoeksxWnd5R2RHRkVCUmVLRm5JZ2dFSW5mSm1DV20v?=
 =?utf-8?B?Zy9tWk5uRDExbDhDWGxTTEoxZlZ1UEZOSFptUEQzWlZFbHVrdjROYkJqbFhW?=
 =?utf-8?B?S3JjdzFQZUdaUk53NmFEekZmMEFEVUVWRTlldE9hVG5XN1I4MURMdEtZekhn?=
 =?utf-8?B?eEdweDU4Q0J5bW9BNmpBZjZpdzdOUThkNitpQk1LK3M4VWgzR0MrY3lvWDR5?=
 =?utf-8?B?R0k2NnUwUGlvUFZFWFdMbVNHR2ZvNkQwRWM0QlFQSVNHZWQwZzNyZEd5dDJ0?=
 =?utf-8?B?Q2FtWWNHejFjdlhqVWtzb0QvRERhNjBnTFBmRUhYU0hUS1VxaTRFc3lWc3hs?=
 =?utf-8?B?WHJPUVhlalRGaHYzV1FDWGI1RjArNEw0Q3JuVzlSZ3BHdzJkaHhKWGE5OHZD?=
 =?utf-8?B?d1M2ckJRdmdZVFNWUUFvTXY5R3NwYU9yM3FCblhIaGNZakpHRWdvWGYwOWFP?=
 =?utf-8?B?eUFTOVI2V29iS1pQMGdPelgweFNCYVZVY21DU0xzSHVrVkNwWStIcitNSit4?=
 =?utf-8?B?RDRsQ2dnOEJheVBOT1RjOXBXQ1dLV0ZEeS9BK2h1RGJIVm5GVnVjOGp2d2Z3?=
 =?utf-8?B?RmJBMzEvYXA1T1FFcTRVTDNiaS91Ym9vSHUxT2Rkcm0zWEU2cTN6Z01nRE1N?=
 =?utf-8?B?WUVqZ1Nnam9RRmo1WEV6aE1CWXNoYkJvanQzZ0dIVG40L3hJQWRKVzJzWjVX?=
 =?utf-8?B?MXVXRk52ckRJc1I3ODU2MklON3RlRjltRmp2ampTd2w5MTF1WExHdVRuRTF6?=
 =?utf-8?B?ZGt4WWJNR25paG44V2hqdkVmYVhQREg5Q2tBUXA3L2pGVUhzM2R0YnVMYXI0?=
 =?utf-8?B?UldwQ3Y3V21UR3hYUDdpUXBHQkhIRWI0Y0lhN0tXQjRTajBMekxTT1M0ZVJu?=
 =?utf-8?B?elhzaXovVThURnhRSDNhS3FjOUdKcnUzSkZlZUVMQUprUE8zZjlnMEp5Ny94?=
 =?utf-8?B?anMzNmtUa2tMS0VBWm1Wb3dpdmpWQnQzOFVybEVQNlNhSU9sbHZ2bDJyZ1Vt?=
 =?utf-8?B?Z3ZMMVFzaEdDcmhLVnl2Nk1USEpsQWhKRW1QbWw0N0d6NW1LbFIyZCtidG5l?=
 =?utf-8?B?b0lGRTJUaVBlRXAwNk9Id0NObXVJazhMaHNhbU05akdRM21SV0ZPRUYzL0xS?=
 =?utf-8?B?OUhqdUhPY1J0YWVNV0cwMm5ER0d5Mzd1NzRCSFRKL3V0VHA5eEdNTStkOWxh?=
 =?utf-8?B?WWJVc0J5TDNIMCtUd0IwVlpJa0tDTlpNVHJhd3RsU1NaUm9lNFRQaFl3d28v?=
 =?utf-8?B?NmU3dXQzMzJYQmlMdUR4bTBLZDVLUVhIZ1k4YllZTzR2a1FNeCtDRGoyMDJP?=
 =?utf-8?B?U0RNUUIxL2crVFJPTG9HS3orUFZxd1NMb2FUS2hBZ05SekZzNHM0dFZmUDI1?=
 =?utf-8?B?c21YTmdQR2VjcFU1SGI3Y0dkYnQvV2JpZ2t4b090bGlVeHFSdUppWXhYNmp5?=
 =?utf-8?B?aXp5Zm8wN0p0RjBYNm1QNVZ4K1JwRktjTVRnNm1uRk5Ud0Zuc3dySnJWVmRL?=
 =?utf-8?B?WFE3UzdZYjhrT1RuWi9kNDB2S3hDa0NRRGFJMGdVVXh0cEFGSHdGMEdEMHM2?=
 =?utf-8?B?dXRtb3E3eVJDOUp6SzNaeFFzaTJOcG5oczJaUUt4YmRwRmZDN2FqQmJKRURZ?=
 =?utf-8?B?ZUUwZVVQTXU2N0YxTlFsUHBwcjY0LzVJUU1LNzlsNUIxWlp1eXhYYTc0em9l?=
 =?utf-8?B?azZRRGZCT1FNM1RxODZRTGVhVlltdFQ2ZlRHcVo0THBCNHhObEVicDFSYmhh?=
 =?utf-8?B?d2pXZ3hCT0tDdFhESlduVWp6Qng5QjZZNm1Od1Vqa1ZmQ3lWWXN3YVdoTDdC?=
 =?utf-8?B?R2tzYUxucGd0bDVNbDV4QmRxdkY5UVdhYjJYYkZnbWZxRHUzMmkvUFhtR1dG?=
 =?utf-8?B?RTBUSEJJaVg4czJOajBZNEVRSXEyZzFyTHo2Z2R1NEp2cmt0TFdKMmRvanpU?=
 =?utf-8?B?VzhwQTlPQkMvU0IydVU4ejhiZXV2RVJSU25xWWhTKzhPNGVCdjhBdGZSdWJ4?=
 =?utf-8?B?U0Q0YXZaOVBWK1Z4TmI3NThvOWx5Zm9NUTF2bWVKR0VFUjBaZ2dLWVhZVGdn?=
 =?utf-8?B?cXpvaEVCVDE2dWJod1R3VWNJQmRpaFdWTGgyNVpscGpQUDk0bGRPQitJVWRQ?=
 =?utf-8?B?OUNobzZSSmN5eWI0Z2FPSHNpRGxRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4eb6978-4f77-44b7-8022-08db297eb4a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 20:07:17.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9TXXd+RR6ugt0EdkH4rECd4vDqCH6F6f9zX15OWjqSUpzx9bpJZeONblMfdR3sQpsXuxnHHSpF6jOE2sEwpyE3PVjMax5+Ein/MPRJRxXec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:50:24PM +0100, Álvaro Fernández Rojas wrote:
> BCM63268 requires special RGMII configuration to work.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
