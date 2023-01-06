Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E8E660A36
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbjAFXVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFXVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:21:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2059.outbound.protection.outlook.com [40.107.20.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A30D84BE4;
        Fri,  6 Jan 2023 15:21:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfceOo4duJ+a1vpL21Si3FqQPM8r4AVJSpSRoUN3tr8Nq6YxxrdW6AYRBvnJQ8AFMyPYIipzsZmmNiB7YzgPtQVkM2hUY4Aq7rS0Y+uZ2yewjOCNs4bNLiUppCh7vy0353YGM2/c4TUU3LtlUxRiXiz1KsziPfq2B1IW4wtKKMD59mfLdrTPUOiYYlypCv3Yx9XPTQ/7kQkcxzQkPTBN2yJvI0psNN7FQaJhMriMMc6Ng/pFgnJPUa+CNBW74v5DsGGlGO3hE92gJ/sZSWL5EnibnpEbCOWrKgtIcLKYeTm03VMPTULegDTnLnUCFOXunlu2EyGukxDeE7bR2NenjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwgzeTn+f8jit8hGATvIiqMEQO5FfWk3fZoTVhTG/uM=;
 b=glzY98uNDdFSFijwgyH+T+thC5lG90HAgeN02OtJdeQbZ0KBoC94fgY1ajeaw3RuLpFAe3IbkCgvubnUUhZmibMnNM/opW/rbatIOccAbFnQyeft3WUQj0VX+/2VU1WZPnwUT3bcvhAw9aoUzSzWo4J+rbob8VKwL5uyI7tZtDkO/CTuQBZ3E3p85eJz6jq23ziuyS7nLl1Xv/J28EkaMfz8uxVS+TM/o6t2cBeJyxWy5KSXYBFbZqaSm+R/bi+VYAphEMVjeRY/S5M46pIMDRj42TobzaV+mBaGiRDouXjEYL1oTbC0Y99Rhta+1KHrccXtyKck0uD4ANpkx1tmqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwgzeTn+f8jit8hGATvIiqMEQO5FfWk3fZoTVhTG/uM=;
 b=zWCTITGGllrmue7seZLugZ+n3lxbEhIXqNt82JZADUbDMx2CrP4hnDadUd4vuyarqMskgS4Yy2Ke71qjrxU00xf1Bx+DUi3etigMzr8Nl8BnOqadijvSSce2E3E2qGzWEP8wnu3jXzZuI5xif3xb+s7Tz8Dy8Ct2qvoZdFkKhGZWXyD/6yw3agjxWnF6fySVfIBoP9YVmvVomSnRm1C6ZSi9pO8NkM8CRbxd3wv6rOeasMAtqR6NWG2rUq1/Ows5WK950pKtwHAEzQujo7d5GpxhD5Qh0K9CG9/VOM8voYTNHW8N7uQDkv7qSAc1m3xGyq4oElte3voEREoedrVRiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS2PR03MB8769.eurprd03.prod.outlook.com (2603:10a6:20b:550::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:21:30 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:21:30 +0000
Message-ID: <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
Date:   Fri, 6 Jan 2023 18:21:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
 <20230106230343.2noq2hxr4quqbtk4@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230106230343.2noq2hxr4quqbtk4@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0255.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::20) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS2PR03MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: a26b69f4-1027-49d6-c8f3-08daf03cbdd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rtKg75M2F2coxVNCPRNu6DSNeEC0u8AJUngsskxn1D5wRzasMWfTszA6VB+N01syCHAdD1lRA1wcG0rsw4aE8wgsWnzceNWgaW6v21cSKf2qMys5qvy4LSiIDmA17rKtXTXXVEcfTLcUNHIY4Y4X9ZgexrHWPz11fj/VYS2I1A5O5K0VYbaBnYkNXx3ZJHUVRIQxBUXGGR0TX22IASQKiZbqJdSa40sgyl8JI82RcXGMxitEzBaPJoy4MpqFZRwPrG032MGqWtEraqgO2SfmAEtWPLS31egPv7HeFIPOFQiBhQd1gPKM+UFV6nGfAxGJjtsODVnfGFs7xqVfyHfJg9vcdCwd1hz0wx1w25nnSAoLXOck08qk/+iPBppb5mrGjBh7fVeEJ0LXYPR3cJ5z885NyIfOKW8RoYcKWBWX8FpewA/tb1bblj/PjZHOEHGrMqPSpnmr5sZrBc5VvvZ/sttSNhvmL0+pyB7CO7zgCaTU335ZbTXonRCm/0ig/ndMwmzWMibJxIFRnhrB1a0EBTDqM++KN4ML4DhIBJ7RIGlIYVyB7Z6Ij8/rDttrBGt9dWj7mmzr1yP4AD0+4SpZvUX6U0jYIUquOzdrkdk5BgxfggkHXPWS+ErKBYaWEIe3PPZ3LbMs8/9SV20jS71yBePlA9CtVMVtq6IKvtz/LrOvKEFzPm6c7R/1c2QU9GwVSDTzykM/UTn4CAr/rtQfTL2T/4VOTaqajEpowCTBgyRX9thYuZ3s5HNtldDpswUFleQdz9mx7nJrBPa6AgV0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(376002)(346002)(396003)(136003)(366004)(451199015)(44832011)(2616005)(86362001)(31696002)(83380400001)(38100700002)(38350700002)(36756003)(26005)(2906002)(316002)(54906003)(8936002)(7416002)(41300700001)(66476007)(66556008)(4326008)(66946007)(5660300002)(8676002)(186003)(53546011)(6512007)(6666004)(110136005)(31686004)(6486002)(6506007)(478600001)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkI4QTJOdldHcmlnVjJmek5BdWRRTkdkaEVZMndKOXRrNEhndHMwQjBlcmlX?=
 =?utf-8?B?THZxQ3ptUjBwNWxneElDbkRHalJrWWs4aHJFenpHYmVxbkpjS29OU2pyQ2pL?=
 =?utf-8?B?VTZjYzQ2bDIrZWd0a1JZeEt2UkQvSTZ0UmU5QkhCbWQyd1NKejMzL04xRW1B?=
 =?utf-8?B?Z0lXVm5uWnNacnBLTVEvT0lweWVtK2FsSnBFM1BDS1FsMFFNRFNkdWVYd3VW?=
 =?utf-8?B?dklyUGdjcEdqY0RtZnlGOTBxRkxlTS9JdEVkbGdtMmNWMUp3Q2FxOFFMOEFF?=
 =?utf-8?B?eWFOQTRIamkxUjJ0TnZRdCt4NVY3bi9tZ2U1ZHFsL3lDdDlUWHFEL05yYUFu?=
 =?utf-8?B?bkVER2F4Qy9FR0g3N3psaXYxQ0ZRNTlHRy92VisvYXVua0t5THlDTHM1Qk9D?=
 =?utf-8?B?S2QxY0VuOHlYT0lHQ3Q3Vmw0OTNVNk1MNDFnK2llMHVnOGVwZ2tBUk9UazlO?=
 =?utf-8?B?MzI0K2ljR05KbmVBY0ZtSExPYzdqb09pK0pMWEh0enpBOXNvdCtiNjdadmtv?=
 =?utf-8?B?NmdTejdIdml1d0V0RHBkTWpndGpabEU5N01HMXlpV1kyZTVvZTBjYmRtWnlF?=
 =?utf-8?B?NE9vOERDMURlcUZMdVJoTTB5NEpHeUFvRG5OdU5HVCtRWHJGVm1BTGFXM2t6?=
 =?utf-8?B?SXhPRDh6SjVSV3FMSFE5NTZqaWFURjN5RCtHM3U0MVRsRlFEbm9mODI2U1dm?=
 =?utf-8?B?Zzl1cUd3bFRIQzl1Zlo4TUU4Z0lFVGd1SzdWWWhrWG02bnh4MkpVTFdNaHF6?=
 =?utf-8?B?S25wU1M2UEYzc1lOVFBXRlBuMTgvbU12SE4yNlVTTm5mOGQyVUFOd0ROa1cv?=
 =?utf-8?B?N1YvMnl2RzZ4QlRtNTUzREx5T1RTWEs4MEMxRkZPQU5mLzdSOC9TN0VtT3hO?=
 =?utf-8?B?UDdhdnU1OXFmeTRrcitkOEVQWXhsVUZCNWtkcm12dnpVbWhtc01BSG5BWnp6?=
 =?utf-8?B?clh2dHRXY1c5enFCVzA4eDNQK1JIWFdXS2xIK2JGb2luVElJM1dENE5xOVpG?=
 =?utf-8?B?L0pVY2Nsc0prcnB5Ukp4ODVSVDlvVUtmNDEzK01kbjBwcEdoa3B3d1EzRnhx?=
 =?utf-8?B?d1N5SGo5VVNmWnBsVU9QL25ITElEcTVCaGIwZHBNVkZ1VlExbllwdWJ4U1ZM?=
 =?utf-8?B?UnpVdmJGRXk4YWRoYlZ3ZVFSTklIdzV3Qm0wd04zcFFiSGMrVytBS3hNQ3M0?=
 =?utf-8?B?OExHOGFjVCtKL2NhbFBaZ2Y0MlhhNjI0cmNjS0JCYi9zdnpoNE1BcElpTmho?=
 =?utf-8?B?SVFwcTZzT3BaTUV5Mnd1V0krZjdsUGhldVlPclMvNDN4VW8zK3VWeHRocGYr?=
 =?utf-8?B?UEUwU2g3QmpVYi9qd204eDdocTdxbjJ4elE5RnAzNnpGYVBGMHc3TXBiVDlF?=
 =?utf-8?B?SFlJTXN5bGMzcG51enMvRHpZM2YzY0s5UndnTGNkTmc1TDlaaFBURlBNVWdS?=
 =?utf-8?B?eWhGM1ZJT1pEa3RObGZTYUFMR2NrMWNhYTJHTmt4QkFKY2NZYmJyM3dVZmtl?=
 =?utf-8?B?ek1CNFNpZGZaUWZRMTBSdHMxWk5jcUhmc3F6dThmb09mVU9rTGFSMklFcUIr?=
 =?utf-8?B?SWYvYjRTV1JITTNFRm5ZR1hKeXE0Yy8yZ0hKOUhIdk1SNTIzbTBKZUFVRFZ3?=
 =?utf-8?B?N0hjN1NxYzdFRmtBNHM2emYyTFpGTy83TXEvUXRyTUFNN2g5MDh1ZWhDcG5K?=
 =?utf-8?B?dEFsa1BMRnpudjdXY3dkcDlOZUdERUlRc3hBNStVRGlTczlVNjB3UW1VMTRD?=
 =?utf-8?B?a29FV2Yrb2Y4TEhZNWZpVWhGSWs3UmgwTDJmcDM5ZWxxeC9BWmNwTUVXV3cy?=
 =?utf-8?B?TXZ5aU93WUIwMVVwVzdua3J1dktzelptK2hGaGZWSnByY1Q0QVJuaTdpajJl?=
 =?utf-8?B?ZHVHYytoYXB1RHY1WkNRamJsRHU4R2NRM1NUd1JWVTJvRG85VEtIRGlnMjFE?=
 =?utf-8?B?aGdyM2JHUmhDT0FXTEh1SGNrd05QeUlsblNxa0tJNU1HV1RuYnpYTjk3WWdp?=
 =?utf-8?B?RUVCTUlSV2xzN0dhdDhkUmtJaEpqd3B3b2UrVFhVV0ljc2NRTmZWUFFmUUdt?=
 =?utf-8?B?TzBOeFAzT1BFY1QyYWlWODRHS201aHhFOENxTmhjazVtaUtyTzRnSzZDSkFQ?=
 =?utf-8?B?NXhuUUtOcTZSRXdYaWhOeTJQeDVJL2lhWklyRnFCU3dVTk5jd3hnSGVpMDBz?=
 =?utf-8?B?WGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26b69f4-1027-49d6-c8f3-08daf03cbdd2
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:21:30.1164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awA6LhG+G+UdA3B+tAVw6W2no8X4uHzjP22ZAPySfdV3rmcEB/xJ8Ai6n0F7tm9vkVJvRov+A8IoI0GquH1O8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB8769
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/23 18:03, Vladimir Oltean wrote:
> On Thu, Jan 05, 2023 at 05:46:48PM +0000, Russell King (Oracle) wrote:
>> On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
>> > So we lose the advertisement of 5G and 2.5G, even if the firmware is
>> > provisioned for them via 10GBASE-R rate adaptation, right? Because when
>> > asked "What kind of rate matching is supported for 10GBASE-R?", the
>> > Aquantia driver will respond "None".
>> 
>> The code doesn't have the ability to do any better right now - since
>> we don't know what sets of interface modes _could_ be used by the PHY
>> and whether each interface mode may result in rate adaption.
>> 
>> To achieve that would mean reworking yet again all the phylink
>> validation from scratch, and probably reworking phylib and most of
>> the PHY drivers too so that they provide a lot more information
>> about their host interface behaviour.
>> 
>> I don't think there is an easy way to have a "perfect" solution
>> immediately - it's going to take a while to evolve - and probably
>> painfully evolve due to the slowness involved in updating all the
>> drivers that make use of phylink in some way.
> 
> Serious question. What do we gain in practical terms with this patch set
> applied? With certain firmware provisioning, some unsupported link modes
> won't be advertised anymore. But also, with other firmware, some supported
> link modes won't be advertised anymore.

Well, before the rate adaptation series, none of this would be
advertised. I would rather add advertisement only for what we can
actually support. We can always come back later and add additional
support.

> IIUC, Tim Harvey's firmware ultimately had incorrect provisioning, it's
> not like the existing code prevents his use case from working.

The existing code isn't great as-is, since all the user sees is that we
e.g. negotiated for 1G, but the link never came up.

--Sean
