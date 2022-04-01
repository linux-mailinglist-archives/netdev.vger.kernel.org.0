Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53A4EEE83
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbiDANxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiDANxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:53:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2110.outbound.protection.outlook.com [40.107.100.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A039C1C6490
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdeLh+AByyZ8Yg4sjP1sb1+aM6sofrSIPZkrhXR5aMvI8++9b41srkqXtaPp9ARaaUHpnSDJFc9aNO9VW3DnGqLP7Pp+3f9p7LlfUyuwc8C1ViNEK/+WuaRSoysB+7phrnnYsxwbORt/fOC4W89ygXDTEAtqEF3ffszOAuhg90IQ9OlVLv3v+b10Ilyf3Pp49J0Fys2GnzgkamdlKPvAzwu7vyZAqr+DMIbCs8Jhwb4p7ZA79CCxnzbsBo/zWTI4CohTmudZ4nQvOMYIr3PiU2XuaAGxjpJTB3dnoC40CJcNP5LGarpoQNrtuKau3AFBJeY938xLn1B0+M/ZvxcSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izXlp7Kh6TaUiXje9gRmGXic61CtItzV/Z1IVsxGRJM=;
 b=B2Rys6FBkbNfTF56qn62/QPnSmEfn504yCiPLm6EqRHs0gruPaO3aovyNmJFAvzHN1eRutTmbB7UuGr3lRdk79moGz74Ub3FYzVkZ1EJUyDmwtnLgJDh+UYnIQHmbK3JSkRN4YIxk0wqIg959pB0fwBSa0hGTgoRAnTUNml7ra92xbd69NyYrCdVzthxBJr3lOI/FycJfTGf4u0abiQbfxk+exB8aTEJpibh/ILb1S9kkbwemGQpkhiUCWhWU0gKOQZGXITkP2vGNmhGM/HA7RRfz7BEyy7D+/i1tReIgDHPf2KZcs6WAuPXxXNw5eDxR/UJefAEZ+kN9TDecGW+9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izXlp7Kh6TaUiXje9gRmGXic61CtItzV/Z1IVsxGRJM=;
 b=IyXJKPkV2S1UdhhQGEPV7bIDO/lQ21xvH/WCT0C9J4b906ru5MYXx/9loB413aSkelj0hAbDsmb+WrJfxEaU2/ABR2ZnNPs5xEeWgvag4AyEtkMm0TW1tNsvLoz62Z0Ixp9z9Tm/q/bsY3wEl/9gPG6v6RH6nWOKQ2aeGJzfpEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2627.namprd13.prod.outlook.com (2603:10b6:408:83::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.14; Fri, 1 Apr
 2022 13:51:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 13:51:31 +0000
Date:   Fri, 1 Apr 2022 15:51:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Danie du Toit <danie.dutoit@corigine.com>
Subject: Re: [PATCH net] nfp: do not use driver_data to index device info
Message-ID: <YkcDXS38LRWx0LNV@corigine.com>
References: <20220401111936.92777-1-simon.horman@corigine.com>
 <Ykb7s+uysncYGb0t@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ykb7s+uysncYGb0t@lunn.ch>
X-ClientProxiedBy: AM0PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:208:122::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecf9985a-4de8-4d03-398a-08da13e6ba24
X-MS-TrafficTypeDiagnostic: BN8PR13MB2627:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB2627479264AF23D3974C4B58E8E09@BN8PR13MB2627.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LjVBn2Kf3bnTOnaqr/CxlZ1gtTjcnVZ/l8FOO4A1ie6yZJVs91SykKK/yXLne6pSrJ4+4G2iGIkkQZ+Tg68HidtGcKm0HLSL5l3MiF50des/3J9aots30rfAjMwo4GAK3bCuXmKFnvpoiQCnDi7hfqVZtJCYQn6poMF7TS4qzVPFipzxlWuvca2y+ZyRNECzbHkFIakJQUViiTzDXyODetqJWNlVWziQkbUf1OeHTm/8/cmMv+IAC/Y2qKWmamRT3cxssaTyhNhtlus3nhnIFAgVw5zhwRmAzTL9AGVL49EUscssu28HFXBtPtj7xkz7JFDLPWAvWVVupAcQ8xx3jwCnLQO4FFPtgOSNy/fwzvrJ8vFToCGKO9gzSA/+Xy2S18gg9MJH4iT0vJYt1gMlHfvz7sck9czTck1NVICQQdnMnX++PmKIC2+lM7i3d87wWIpWIcqZwIHkA6AkGvDwFtRC0/8F5+/ytkMJ9tg4SW3wEQiOVy5xa56nCZZUHPo9R6m1RiR0d9zPkql+S+6ehbX6iAg9Esy77Eq9I6eSNBP+iW/NmgmGRw6GWFANRZ5N8kVyusysm3p4IgyXPF0EvB1oKty19tP0PKakJajq86w+SnakkPwcj7xAECU9Umg9WOLS8IVQHK6ABE/b4htK7CA1i3sEjC5sr5RqtXzCONY37rhNW2/j72X/lFZNh8jGQgX7Vpo1wtLyFUjJDMjLz8uUwi+fWbpvwxz+DK/QKVULOSv1p1cps+L+KRp3dFo3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(346002)(39830400003)(376002)(396003)(66476007)(8676002)(66946007)(2906002)(5660300002)(54906003)(66556008)(316002)(6916009)(44832011)(86362001)(8936002)(38100700002)(6666004)(4326008)(38350700002)(52116002)(26005)(186003)(66574015)(6506007)(6512007)(107886003)(6486002)(2616005)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnltKzU3bjVUZUEwenlZZzdVUDVUMVB1azJuZGN0RUJYeUlOMUF6UmNMdTlV?=
 =?utf-8?B?RUZISk54YUpzNVQ1bmNnSXhqLzAyOXRZUWNmaFZ1TWlSTktKSngyL0psQjhO?=
 =?utf-8?B?WEJtYW5KNDVCSGVMbkhrVm1BUWx3Q0FTcHIrSUQ1SXFtNW9VYWtVZS9ITkhy?=
 =?utf-8?B?ZmdBZWtwdVgxNnI2QnNvZDhYbkE1endzMlJVLzhxVitDRlVSMUppSS90YVU0?=
 =?utf-8?B?ZmM4cW9TZGkvQXlGU0xIRXhvWFlzVi9qZmJhelR4c2pPVmJueUpZOXlwMm83?=
 =?utf-8?B?NVByM21DakRQZUxQZTVudlZjb0lVYlRHazdTZTRCZDdmQ2lyaGdHSlV4emln?=
 =?utf-8?B?cjdWTTZHMHN1ZjFxZWFDM2pCbTh4OGxjTDA4cHBiMmV0QlhBUFdTTXFlWEpl?=
 =?utf-8?B?N1hSR0cyaDR5a2JyVldVRWh0RVpXcm45VDczZ1U3K0VUdi9NVzNTWHVCT0lC?=
 =?utf-8?B?OTVoZXhhTERXL1AycUw3THdLa0d4WjBodWhUZUkzVWNpY0Q5V0RaVUNCNXV4?=
 =?utf-8?B?SGJwazA4eGRiV3pnNXR2aDlPWHVKeVQrTjYxbzRwNVBTOGRRVmVMNHhYVWJi?=
 =?utf-8?B?TVdkcnNySTV0ZkNKenJLRjVOcENVSlpPZ3RMOXk5YnlDYWNWaTd0U0diSDFE?=
 =?utf-8?B?YTcwV1E1WFRQbWVRUlhqNGZ2T0ZGbUNxeTF3S01sL2RUWnF2SSszUkJmMExS?=
 =?utf-8?B?dW5sc0d5c2FlZ3dZaU9Nb0ZjalZlQXhPT1lUMTE3azU2NzR4OXNMUXd2cnV1?=
 =?utf-8?B?OFd1ajhIenBwUi96WXVxdE92Vy94SVZmcWVlZmxSNnp5dXhCQkVqU1YybUcr?=
 =?utf-8?B?dmE2aXFzVFFzcnV2c1U3a3dhNk1GS05FazU0RENkdDNhUDRqNWJPbXhyQWxw?=
 =?utf-8?B?NzNIWUNKd0dxbnZOWXUxeTdjNHh5ak9RTkJDdmw0TEhJK3hhS1FwcWloSEEw?=
 =?utf-8?B?YlQwR29TMDRUNHVicDViVEd5QkMzVm9qazBacG1ZZ2paTnd6ODNWLzRwMkRj?=
 =?utf-8?B?M2FnSGxlcW9kcjdCYmhsaVp0VWQrRCt2blhwWTQyR0xzZncyNE5JMHYyTnd4?=
 =?utf-8?B?dWxDVUNFS20vVXJUb0diL01QTGhnRXVOaFM1ZERwYzdvVEppVXNza2gvYzU0?=
 =?utf-8?B?SHFYTGZ0Wlc2Z0xDL2VRTzNvK0FNSnQ3elJDa2tSdDh3R2U5NDdQcEdNRC8z?=
 =?utf-8?B?MEt4QjRVenFCTUtDc3E1MUFhZDNzYzlxU01RZU9uNExqYUZzWDZCUGZDUkFz?=
 =?utf-8?B?TGhwdU9lVC9yWE5yT2ZVanVYY2dxVk9SK2hUY1gxRnlXeURtNDhDdzFjRHFm?=
 =?utf-8?B?emk3dVlnQVlWUVl6TDlIVlpZeFlSMHhIcTRqNG9hTXhXZ0loMUN1WDVtdm9Q?=
 =?utf-8?B?MEI5YU1RYXdQVW4zYlZQUSs3dEtsNWF4VU5wMUx5MllId3ZzT2hCWC8ySklM?=
 =?utf-8?B?UVhvbVlmdEsxQ3ZRZTBvTXlqYzJLNy9PUXFOSTVqWXFiNXJqSi9tczZpOUNo?=
 =?utf-8?B?MlNwSVBzcU4zMFNOWUN1dVZFY0ZaU0p0eFhyZjAvVjYxWTEwYUtjRHNJbnVP?=
 =?utf-8?B?Q2c0WGJjdzk5OGl5b0ZoWEpsTlVuTXVkcnJXRnNwOHRTWVd4M0tvSjc1RTJC?=
 =?utf-8?B?Z2hvQWxPRDdlR3N1MC8zaFoyNkp4V1AraFdmVVhBN21GMS8yNnU2aGROSXJn?=
 =?utf-8?B?dXZlaW9wOXBwS0l2MHdoWjBXTTRmSDc4L3BGY0NZbkZ2VWxWdEduN2lIVUV2?=
 =?utf-8?B?azl5aVlZa3B2YnBuU3FDVEg3OU94TGJNc3hBVEpmM1pKRmhlNS90TDREWjhZ?=
 =?utf-8?B?SFM5eDdaOEp3NXBFTUN5ZDhDQ1AxMllqSG10aVFISFFib0djUmloZHJRL2hK?=
 =?utf-8?B?MWE0aHVhcVVpelFDclIwV3R2WDRLalZRZmcxSVJYQzR3cUlKL3lYc3JYZGRH?=
 =?utf-8?B?L2pkdXViK21ndXdxbU5wQU96RktOcklQd0x6YXNBLzBZT3IyVTVPU1pNa1dD?=
 =?utf-8?B?UFBHUHlTZFBIbW00eDlwU2pOVUsvTVJQL0dnRnl3WURuSEJpTHBrWjJhSGJI?=
 =?utf-8?B?UjFuTUtUZk02ZWxnOXZwY0llTzkyV1BaSTllSllKRTlYVmJkZDA2UFdCb09M?=
 =?utf-8?B?S1VaQ2pwaHhybWxGZlZLMmN2UUUyVFNIZ21sd05FV1RDQTk0YzNqWmo2NUky?=
 =?utf-8?B?dlhqQ1NxTmdQZmdGSlVZcm85bmZJaklTYkd3SHpETkxtaXU4LzBjQXRKYUhX?=
 =?utf-8?B?Y2YwMkJJMGx4OE84Z1h2SjRFS280NERXem4rajNObHFUZkFORDl3bHYyaThP?=
 =?utf-8?B?WW5ZZmRFTlMzTm9QN1A1TGRqWStjY0J2T0Z4UmpWZFVCOFpBRkN4clZ2bGNN?=
 =?utf-8?Q?SwIr9EcVpHiU1Z6I=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf9985a-4de8-4d03-398a-08da13e6ba24
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 13:51:31.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtiE3Cq9Nf5MTmypQKbF/cohozggTkm4szAt2vbmJ3BG5W6IoAO/l3REcvQVeVu/hjK3k8Ecul9w3+wE45Zv4+y5wXj4DGTEMsvvCcqGuYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 03:18:43PM +0200, Andrew Lunn wrote:
> On Fri, Apr 01, 2022 at 01:19:36PM +0200, Simon Horman wrote:
> > From: Niklas Söderlund <niklas.soderlund@corigine.com>
> > 
> > When adding support for multiple chips the struct pci_device_id
> > driver_data field was used to hold a index to lookup chip device
> > specific information from a table. This works but creates a regressions
> > for users who uses /sys/bus/pci/drivers/nfp_netvf/new_id.
> > 
> > For example, before the change writing "19ee 6003" to new_id was
> > sufficient but after one needs to write enough fields to be able to also
> > match on the driver_data field, "19ee 6003 19ee ffffffff ffffffff 0 1".
> > 
> > The usage of driver_data field was only a convenience and in the belief
> > the driver_data field was private to the driver and not exposed in
> > anyway to users. Changing the device info lookup to a function that
> > translates from struct pci_device_id device field instead works just as
> > well and removes the user facing regression.
> > 
> > As a bonus the enum and table with lookup information can be moved out
> > from a shared header file to the only file where it's used.
> > 
> > Reported-by: Danie du Toit <danie.dutoit@corigine.com>
> > Fixes: e900db704c8512bc ("nfp: parametrize QCP offset/size using dev_info")
> > Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> 
> Hi Simon
> 
> This is missing your own Signed-off-by:

Thanks Andrew,

I'm very sorry about that.

Signed-off-by: Simon Horman <simon.horman@corigine.com>

