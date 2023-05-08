Return-Path: <netdev+bounces-932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E1C6FB69E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6988280F9B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95B711188;
	Mon,  8 May 2023 19:08:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523AAD25
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:08:35 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2126.outbound.protection.outlook.com [40.107.93.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF3535A8
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbqvjf6zn3cTdJpaM5+u2cIpzkEK8liZVj0Vz+bWAYFwu6lR1Ajke6JyPrcyxWCgddM9nJ/cBw+YFfjZXv0Zrp2pzlHaKHoePle3xQ5ZqMKK+hVnycKI7D4wZ7qRoO+mP6SpARJeyYD4+yHx3m62v7AMSAcyOUTzFNiYjt+7Kp1f24a2uEvYemgG1DKO1JYfTqTOIq29t+fNW1XuQhSjTVC7Jojh5oZE9/nT/H+07NIy9ogeGMdl12htgHl/YXdxwEWJ/NQ4NxFQEjePryVJ5U1rP2FBnvrcwruFUjh0qdVU+J+X8DZQ9MCq8jVYTBppmKuGL5evBLujB3KkQUguFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QN51nUqa23TxGjN8usQDDCWe6DUaLpE3OSY4y2tWCI8=;
 b=iKsvolitQXPASlMZPXTNlyMTKBX8n7S2hhqOxvKDOncnxSQD/aHydq/lRIKb5Ck0dXDycw2RBIyKfCYCQXknTJytrgwlDDTLqnD4Dce8bjDYZUyE++CffflZQ8r4Q+tyuU9KhagtpoLHjegu3Q5qdybMaFYO5Gc7coj2Y8SO8iLNbr0U9n6GqcrigGoz1K2ejZGoEGhVi297Ca7bJguDW4nZ+syRNSb8Oq9zMUs1Qwsh+QAo8+6hYk2t8RgEKCjkyROFHCA7GcTQ4qOARew+/qTDYGNgZQ6wwv6QGEm/kKQiwNJ+Vw8MU4BKOuTYjo84KWSrtooq0Q+L5G10h62+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QN51nUqa23TxGjN8usQDDCWe6DUaLpE3OSY4y2tWCI8=;
 b=nMD710dBV4PpVUYA3ffWC0x9mjtIN3kpyVXyFo3r6e/eNX0pXZw6Gqc/WkE4aIwAzyH4YPD0wsWfdO0C7m4aJiJ605rag1/rEiqJ5+sw62zRzVzRSvRQCj5l/QEvDTDUHhErlEoTSueq/BUV+bd0cbhMVwEinw8ZqbDXzmuWPMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CO3PR13MB5799.namprd13.prod.outlook.com (2603:10b6:303:174::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:08:31 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:08:31 +0000
Date: Mon, 8 May 2023 21:08:22 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Jan Sokolowski <jan.sokolowski@intel.com>,
	maciej.fijalkowski@intel.com, daniel@iogearbox.net,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net] ice: Fix undersized tx_flags variable
Message-ID: <ZFlIpsd+nQ7x1pjU@corigine.com>
References: <20230508174225.1707403-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508174225.1707403-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AS4P251CA0026.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::15) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CO3PR13MB5799:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f9b78b8-ff51-45d8-d287-08db4ff79ce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zv7p3qR989RTKTfmM6DWVB5rl7MJjBVKLd+td0ajFkVBa8R7Rh8fulPHISz9VfoyUYSBVzS7h5gFqvfcOFrI9G9iY9SH830puNYQ5BOBepg62amhMSgEetbC85+YSPpz/t3YgghPTWVkrVClh7qijFsLwFLzJXYW+CVyj1OTPCjBerwz1EY+IDybSlPJ0b3XTs0B7Kldmpxotr8h2mq/dw3FlSaoYagTXpNeAfE5pBLcNDbm+SWqlJo/jbMFhEc7As3QZGOIz46PM+dt8eKX2cAMWgfmV/uMQgXqvWWWCio6lx2GpyEVQ8MTFCBPu+sNPRoPeBNiJ4bqBrYo8l17+Fnc32fEMDryPT8Su2Ce32cqHxO94OnLlaV2q+QXnKaU5XITtCO/Q8APfMmTx+ivDlQjinf2ahWXjSPs0mERWRjpmc1Opjme8eyqp0P2J7SxbwWuvy3Pb4U0HLuK8T92X/0Gn1kmEj0JRWB8Z+jc6h1s/F1us9xbfWb9XUGvCvan+5j/SMbKgu0FOowe2aXq9iivjSfv9C+YhUpxct/blBO1hAH74LliyYvXBN0LUI8aFBRUdpJhZ/MxASNZWANPpE/ORt6bP1j4H3h/AtHJxGZK6XDrpoIkA7NdoZqNUQxGFLpD7G+NckHfPum4rsti/A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39840400004)(396003)(451199021)(36756003)(38100700002)(4744005)(7416002)(2906002)(44832011)(8676002)(8936002)(316002)(86362001)(5660300002)(6916009)(66946007)(66476007)(41300700001)(66556008)(4326008)(83380400001)(186003)(6506007)(6512007)(478600001)(6666004)(2616005)(6486002)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pjq8D5mauWh1TbmCBiphMSUCSAz0PYdXxa4UjstBJRqdXFCRcGpMn9gHnuW8?=
 =?us-ascii?Q?k89TnQnD3XjzMzarKAGFKfDN4VCxlSvXAmiM5pbZGr3W0W4vbhkdwkeL0CpC?=
 =?us-ascii?Q?W7VmiBjXELSak6X5lRaRgFACt+Nb1dhmCzmIGH7tefwTJ13ROSlMNFThtxzR?=
 =?us-ascii?Q?y/buZvqGfHjTGmfA4gAy71JIdtrB6PvEgwurB/8G88+Ic8ymF05x6VUpIdMg?=
 =?us-ascii?Q?eyC4XKT7mgFUJP9WJI3Hi6qDyV23URPYIATr4aWd0bg8WWof8HSqXzL42VKN?=
 =?us-ascii?Q?mofb3bXeYVxmwMsfXN01vF/Q37997IGQ574Qxjmu1TfadLegFeajkwPHcgBz?=
 =?us-ascii?Q?1mQXMHPAurRtSDbkQaf4DQ0CesjJu+BOoKjyMCFBaUAL6Iv2ji+jjNmc1xgt?=
 =?us-ascii?Q?aKPpglVPauUEh/d0/NTxSvFNslVRLiq5FZcL9Qa379mui/MkJc5YZzzbVufy?=
 =?us-ascii?Q?76qYBVemiutd2GN/ySAeUG3xDkIpNu7nFwJL8EwMqRvPe9TL0txNACKc/tjX?=
 =?us-ascii?Q?ortNPIVRjM54Qbc0FZ8HwRwc+CHSzsFoM6z5e5HxplpWyG7BJ1yzFv6U2c22?=
 =?us-ascii?Q?+jV6xx9Ko9CRm4xEz0EJqtEcekI22oQsHckaeQ+wrHzAecYCYOXzcv0sbYpk?=
 =?us-ascii?Q?4bYe5hlJG75HxYbM3xH409/Jn33YbXklpzjqFqGkpJmnQ/uzYhgn/anMFSyb?=
 =?us-ascii?Q?vQCj8cpFNfZFF61/kN39cWY6hN24mKvOVUiGmE8cdTpyR8Z06MKkoB8+x0Hg?=
 =?us-ascii?Q?F35Q6YS176SFSWJXZ20w/U3hDR8CNWW2t9XrDN6hcB+YFDsOC8gKwIOhYDIM?=
 =?us-ascii?Q?UJhfhZFpmfkPmywfnWpuU/r7/lchrm70I2XfPc9Deu9cU3DV33V6HPaObGJU?=
 =?us-ascii?Q?Lmy9Nr3yI70Re4J1A3PMTIvvUnrPDLu75VynbhcpXlUVnVlhVQpA6hfuj1Cx?=
 =?us-ascii?Q?jZUaoXk+Zsns9fjFiYwpZ56Zhc8VogIP54thNWWMlyOw/VCgVMpdB6aQk4VG?=
 =?us-ascii?Q?CIoW2FHHsntj2spkMFWTAiQQ4wlos5GCYjLauxebMl00ef3/w24E9Mb5HDp5?=
 =?us-ascii?Q?J157dt37K3xy8v46QcGQufUw0V1PQS9veB3SB1r5Jeb3BBzvd1EzYnER2TKO?=
 =?us-ascii?Q?igxlBM9gDEOHxNnye26d5BE/q2u0b+YEEnajW66IRK+ROVmS3WIItQWu2vWU?=
 =?us-ascii?Q?x8JEXuvvlMEbxxHkXToJLHsj7H+qTU8uBMUAHbb0H38s894jWstWMiQuEJD1?=
 =?us-ascii?Q?l4IqIPIwS0B785Tz45UmGycjTExQuvG32YHEJxCh5hUAgiXcTIwAStTk03qO?=
 =?us-ascii?Q?KSO6O/okECf6qAQIJQXOtQdMXARYqddu4MwAWFKlFKO97DcZ0aHn0qAm+U1J?=
 =?us-ascii?Q?4fLTQ++gXDi86pKVMIUE/pRknfhsEzHjvQcjMiThELFHKRKA2rRCDRVhFXci?=
 =?us-ascii?Q?9btQJIFxa5iYgreA4wSGyeS3n7hfqEHtuITqvc1SIsZU8vhgaBSPTwpLy8GL?=
 =?us-ascii?Q?Gpb9Gro7HxV/8Q+9+TAAKtAyBQKFFrU5t2BYqiToiBY5QCR7F9thEnob5LSH?=
 =?us-ascii?Q?FquOahM1J1lBkg27x2l5zWT+aCbe0I2uLNi7Uhlb/GR780zJEU4MgCjJLbKt?=
 =?us-ascii?Q?Oyz8YQKlrVX3lFGCVpSpdUjcW9IFecxxFmWSBAb8DAxES/lN5rDZQCjNveX2?=
 =?us-ascii?Q?jySW0w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9b78b8-ff51-45d8-d287-08db4ff79ce2
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:08:31.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjKJe1T0kYUFCtDKNE0T9Y3LulYLItcrl4PJ5BCYU5ub2TbJfu8QMoEGg7ft2UHWlo7Nebol+dpah3a3CMjJQFzBd7yDWDkd3yopPfhOOlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5799
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 10:42:25AM -0700, Tony Nguyen wrote:
> From: Jan Sokolowski <jan.sokolowski@intel.com>
> 
> As not all ICE_TX_FLAGS_* fit in current 16-bit limited
> tx_flags field, some VLAN-related flags would not properly apply.
> 
> Fix that by refactoring tx_flags variable into flags only and
> a separate variable that holds VLAN ID. As there is some space left,
> type variable can fit between those two. Pahole reports no size
> change to ice_tx_buf struct.
> 
> Fixes: aa1d3faf71a6 ("ice: Robustify cleaning/completing XDP Tx buffers")
> Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Tested-by: Michal Schmidt <mschmidt@redhat.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


