Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7244A4D22A4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 21:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbiCHUdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 15:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242370AbiCHUdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 15:33:41 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521BC2A258;
        Tue,  8 Mar 2022 12:32:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4jFR2wn8Mienoqh/FvKQ/hrffqtdHZihHtiA+n3+YAoa7tp42zrk/zpE0/Cm+Zgq/gIhul6dp7e5oZFVm3wYqm4lk+A6PZ1WcjnWXPQMx24L8Lur8AGLcpOzP3sdoBD3TQToYOhtXWAZnFvv6TugQ3Nc6cxbW1cppDapO+tCr5It1VPji1C1EFnfXdHF7eVdLrObqP1WuV2IvZxIel/jV790SnUZXJufoWEMQwpG/HdcvA+t48M44wl6DQ9GJ41nyyjFLUH+vBvOkeCCP6KRfU9+ZjaYeu0jfYB/DbmjfsrDMjPFg0vNAUDWN2qmyYlm46ooyIfz+bXdhVnCUA9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtMiWNKXd2z4n2IgW+2NDqJ9ALr7AwS4QHNJC4We9Yk=;
 b=jd7Yw/1lQSJKBwJ0MLAYCC0SNEj3Wte89L2wqvJQvqCwyQEGHp9EAW0petI1AG4os3swMjJmYX5MnPUavX6fWQ6hb2LDtU482Jlokaef3aV2Xj/1VhPmwREio7NYZrRikp3+05feXCfPuaZXfGT/fCq2E9zaUD7woOBN5g1SLnKrVnbya0ANIR3YovfmGztfT52SjuLPJ9+V/XYYPdQFmqrnY/NaZL8r6nvwm5owZJzYZzs07lw5+N4TZXbwGCmcD8pbSRx4HxCCN1Pn2PP3D+XI3NnQzhvyCm6Jy4FMKbz+Upa1dMRMHqDPQk7+rSbhx9B091UPSqOdAtQACXnQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtMiWNKXd2z4n2IgW+2NDqJ9ALr7AwS4QHNJC4We9Yk=;
 b=sazqzLU+zlL3UqFcdho5PWA/BEHOTJk+wrrI1WWm78xez/fFXC6q+2No8Q0OyFi19c9lQC7qOjSrmSw5azexAZ/ITlW67KK1c1xB+tA47G1zbA1d1T0hc73LtSd6ZNNTPAddvJ8/VIxAMo9r7KAMxJ1pH3DV/EYLky6A8ui0zWAbosOYHZyiuGrUMdiGfc85at/CeG/LDwz18mOafHEhqPzBxndkJc9MbhH2U1hmb0YptapTZ4VV7b+orRUGjJ3TiU2as5s+KmuXWqS+zkPzh0qHkLz1T3WgDcUsu38bB0pNJvVug0eW2zOZxJyFGoZke1HRER02nh6+KeVfZChhhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by MN2PR12MB2975.namprd12.prod.outlook.com (2603:10b6:208:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 20:32:37 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 20:32:35 +0000
Message-ID: <716345fd-0ad7-77b3-0a7b-2da448ea31a6@nvidia.com>
Date:   Tue, 8 Mar 2022 12:32:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH linux-next v2] drivers: vxlan: fix returnvar.cocci warning
Content-Language: en-US
To:     Guo Zhengkui <guozhengkui@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     zhengkui_guo@outlook.com
References: <38c7c77ee46ed54319b7222c2fada0039a980a2e.camel@redhat.com>
 <20220308134321.29862-1-guozhengkui@vivo.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220308134321.29862-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eca8c4b6-ea6c-4c8d-e568-08da0142c77a
X-MS-TrafficTypeDiagnostic: MN2PR12MB2975:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2975145A536C7CC603F7E894CB099@MN2PR12MB2975.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ol/oLldYBkIdWsSKPBiDmffWuK6vbLQleCI80VsFipoakSSwsPBqa0Iz4nxFsbdThjDTtUo8wnT4Dw+Ai/R5Hs7WHR2P1hAFK7CaMqq0WoFUw1VZ70iB/fNwfem3vGh1jFKwJGbfvay2OeAMk5XEptBC5Dqm49rPCm3uA09X9YxtrqQBcRkPbuMmaqVoJVtZEcxqxCc+so2QIR0gGdx0wQYPvbbNbKOGTpXDHC4DMrURVfvOa4slXuwL5NwpUA/mhCdcmb1jhkKRDkivB88l0GQu0Fu9AZSeap8zLA3cwK5bRXSyc1xNWWpO6y2O56mTCLYz5AbHvRAg2oOpAgT7JXS+SD4nfrCIParSKVamgQ09dEeUwtYnG+FPz2+s1WEmrf2MAaRnrhjTSubmxFJHUZTLE7Enz2i0H7KKrBcJECIgEZvOD5Xu8pMQq1a3jLQiYOBamr9urWf0mhZwwKvr8c2lJq90Z+yN8XY8ILU13GCjNTNDhEAa0XRwyVh+qAT/qG/8RLPrnj+tfUfj7tftlXDJrZZEwe1klH+EqSOE/sC9MmODpHrh9lJt6NZwhww2wPfwTs8anXjjwnPV66V/U3ZixfcDJJ0Vu3aFlp271pdq3gOKvfh7xWfD6ds5nNpfUBFsrVYwGuYR76QcFnjSnprxMvgpXt+x6pJLYmUIuYYNVeOA/1C8gqSlzD/tsG1d7qXU2nwkjnFLUSLzEZtut239urlH33vp2K4VRnWQ2zbKbVNPXfmgCTTnbHlEz7YI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(508600001)(53546011)(2906002)(6506007)(36756003)(6666004)(31686004)(4744005)(6486002)(8936002)(26005)(38100700002)(186003)(5660300002)(66556008)(66946007)(86362001)(4326008)(8676002)(6512007)(31696002)(66476007)(110136005)(2616005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3IzOG8rdDdzcjhHcXFhcE0xTTZsR3VadC9MN1FOZFAzRlFTeFc5MlRDNnhl?=
 =?utf-8?B?QStmWTR5bVI3dmR6M3hSS0Exa0NUSDBnMzJBVDl6N29ONHQxQU5KZHdFSHh1?=
 =?utf-8?B?QVY2S1pad3BWZmt2NFNZSjh0RFJsSCtWT3NETVhWUzlZQnJncDAvN0tyVnRp?=
 =?utf-8?B?NU1kQjR4Y085R0VNbzIxVkxRZDlwc3V2NmE4OE9tdm9hNE5za213NWFiOTlR?=
 =?utf-8?B?MC8yd3hWS2pRQ2YxaEw2azlFQ1NUOWxUeGNvcnFneW93Y1hSMlIwZGJrMzhD?=
 =?utf-8?B?a1VKOFFTWk1YU0RLNXdRNHphMG16SmltVTNXNmUzMDBWTEttQ0QzUXI0NVg3?=
 =?utf-8?B?TXZ1eFpVdzFDZjVhdDNqS01kZHNldGxEQktmOEo3SjluYWQ4cE5HdEhUSDk2?=
 =?utf-8?B?ZTVpdit0S0lOZGMvUTVzRWJsNFN1NlVNeit4KzN6dTg2R1hkRUMzUEVJeXhm?=
 =?utf-8?B?bTdkdVNhVTd3NVNmbG9ad2xvT3BMTFhaalluS3RVd1o1VEtROG5zUzJrc3Ry?=
 =?utf-8?B?QjVRT0N5RWlVOFFIMFRwODFXTTB3dldCV0hoRXdjSmkwSi8yUUh2eUt3cVdT?=
 =?utf-8?B?SEZSM3pUUVJ4bG1NM3hyZURSeEZQUFZ2NklOL01pM2ZGckNQVkYwTnFUYkZK?=
 =?utf-8?B?RkdHSEhDSk9WTVRsUEozaXVBKzJlUDE0RDZYNWcyby9Gdy9kNVh1bDZmMitk?=
 =?utf-8?B?eExZdkJnM3kxZlJlZFNEblN1Z3F0SmZSQitUTlZpS3pVSllaVmxQaGh4Q29H?=
 =?utf-8?B?WTM5dWtweEhXc3lMZ0xVRERiV1RnNWlpSkVMWFNreFdKT3FCYy96dStFSW1Z?=
 =?utf-8?B?bWhIZlRFYlNia0huNDBQS3JhYzZFVjVFR3J6blYyS093UmQxMmtDbEdtejJW?=
 =?utf-8?B?U3VmQjlMeVAvdzhKUWVMRk9wYjFnZnF4MHBNL3pDRHFQYVFmRmN2S01DVTZ0?=
 =?utf-8?B?SVlwUE10WTIxWXFhOXV2TjRzM3NoSEsyS1RzYW5TMVlOL3Z2N1EzbWVYNVh6?=
 =?utf-8?B?eEhmcXR0RnkvdXZ4OXVzYlpOLzJ4ZjBNSDZIdEY1bEVFOEZPMzVaUTUvSEVS?=
 =?utf-8?B?RjFEbTVLSHBRVk1USjgrdG5JL0M0WlpTQk4wNS90VDRGZzROODhEUGtNRHo5?=
 =?utf-8?B?aXpxVnhpQUpxV1JzREJla3dka1p3dzFWVVpaREJvbkhTS0FKNGlvRGFqRzBB?=
 =?utf-8?B?VTZhdmlydXoxYW5BMUJxTFNpMEswaWszZHMxZTc2bDNWZTlMaHNqMWtKcEZr?=
 =?utf-8?B?UDFpcFN0RGI5ZzNzUnZBL0l2Y0Fad09yMzlIVTU2TWh2ZE9iZU9oeDNQZlB4?=
 =?utf-8?B?bEZkSERUdmxlNjBoWTJ6YVlHNkRLdjZmT0U2WkNJOFFLbndKdGJZVjVaL2Fh?=
 =?utf-8?B?U0pVejMvdEpncWZKOUtmRy9qR1lKakMxT0c5bFd4RW5zYThWMW96TjlpeE95?=
 =?utf-8?B?eE5qYS9IOVUvU210Z2V2V0lQR3l1ejQ4Mk1DaUM3SmtUY3RRTHVnenRNSmlo?=
 =?utf-8?B?amUvNm0ra0h6OEdXTHZzeXdjRHc2cDlYTTZURkRseGl3YlVJNGpRc09oREEv?=
 =?utf-8?B?end4R3MzbVkvRGRHTmYzSXRIL2krNG1PWFdyakhpMVBhZS80dy9idHE2czMy?=
 =?utf-8?B?L2dTTlgrUUpFK1dZYk5pbUszQ25HMmwrYkhpN0VZS3UzckhUOHNlMVMzQUZC?=
 =?utf-8?B?LzZ6QTFaaTB5ZGFGTlBMWm1taXUzK0tYVW5wUkRLN3lRc01Nb05SbFF5M3pE?=
 =?utf-8?B?Ymp3eExTcEo3Nmg3R0pyZ2hKK1NnYks4SmVuUXVqRDZlVnM0SVpZSkFnVWhZ?=
 =?utf-8?B?aS9OOEUwc3JBTFFsYkFmTFRzYlJGV1ZhbHA4OTZ4Ui9vVmFOaUhUS091Q3hS?=
 =?utf-8?B?L1hDZjh0WGtvOU16YW43dE1ZL2dURnJIZGlnMUNWT0lsRThzQ0F2ZmRPclVJ?=
 =?utf-8?B?YXlxZkRPQk5LeitLcFhXWHFNOHRYeVRCdjBiODc5azAvYlJWcUxlTE11a051?=
 =?utf-8?B?K2lvVUh6ZmZJMS83NUM0QTgzZkRqMVNOUDRMQkFKbGRCazRraXhKUGY5R09a?=
 =?utf-8?B?R0NzTFNtbWFXS3Q4UklTK1FlSDVRVVEyWHRTb3UvREFhVU0vejVLVWJnSU40?=
 =?utf-8?B?WWxFY0c1bmFZcU40V29FYk1zWE16REtYeS9vblBIeE00aGNFVVlhTEI5cHhD?=
 =?utf-8?Q?yagrUAANwigfjVFGxlvftkk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca8c4b6-ea6c-4c8d-e568-08da0142c77a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 20:32:35.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Cseq3SdHjJ7/kql2rlr+9IrGKAfQdqSaBmGp6di95ZBowHwND4hO8Do9lTt6Vx4x5xA/DRPWDYjKgbakLXx0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2975
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/8/22 05:43, Guo Zhengkui wrote:
> Fix the following coccicheck warning:
>
> drivers/net/vxlan/vxlan_core.c:2995:5-8:
> Unneeded variable: "ret". Return "0" on line 3004.
>
> Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---

Acked-by: Roopa Prabhu <roopa@nvidia.com>

the patch prefix should be net-next

thanks for the fix


