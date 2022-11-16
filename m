Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3596962C123
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 15:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiKPOlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 09:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiKPOk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 09:40:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B191C391C1;
        Wed, 16 Nov 2022 06:40:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0hs39tfQ50+tgfyruWyjRDWKxjZ8KB5oL2hlWBn4jkNEGJiHr8IjIQAvXKq+KmpY42e2rzOTmyIYOQuKPXTNPTB66ToDdgK0Y7Sm02F3Cb+AWTF9Fa1UdvGN+k0XkEziYvcagoK6Rp1g+ei6uqsUb2DuoqB45gBqGOly+Nx3T8uiVD8jFv/uC5PvMNWCoL4IRijP7qdGn6i/zECrj/enoU0aOOh/BMEESL06clocafSHQZ6y0gS3fBWwmFbyx3yVcv8URdwE54itVL2/VOIzz8ssQCK1Y4HqiOl2woNkyQzATZCBeYg/VlLwSZzChkxvXYRG+uaNsSC5Ld46BXZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ad9LK2PelbL7tkqLhYQk9BzdIn8qg84GgijA0mDP3X8=;
 b=ntfYFTjtV1WHjuJf2lj0eCezq9L+n9kvQIsaRIuWrETEVIDTiqTEj5hTDTUn0UbLX89wrInpLm6b7xB+276h4ln2yoPtsnRxWF5/ffnTXZF2+FgCXw5mEsZWod3ny/LrOpwz/6PDGokujgdwGFxQVJ3AuxDIOACf81ubIoC8nVBQIbwxM3gneLoGl2ihIDZQJBDiht2vnSGGwe+Kgp7aIACtpns4ZRGLvT/Sc3wMDJ7fqnlaHMppV7W8FiXx3lhvokIUX/9voT7WX88iDezJU0osWgKuJ/O52RyO3Q1AbBuha4DK6iUOhLjkXTbs3IeV5XQzEQ/3Bx09Hk4CqLww/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad9LK2PelbL7tkqLhYQk9BzdIn8qg84GgijA0mDP3X8=;
 b=PdPCqZa3OrLdhWxPpZPpYn1EAtDfTcR+4UEnNfHw+QJZutEUt8I/dl8Oz52w8b48EH3SgV9HuJtMTyHF1f53lK13sT13PAAKUwONc3OjqJc8q0v+8X9kPdotI44K54laz4bMkD7iTBIPkEttU76sd3gFQMGkOZGkuMOsunDTcSaY2tvHEELET1x/ja8Sjb7g+dD8rMXx9N0cJ768oljYQ7L2wldVBrIEK+579BGHIammm5Wqad0Il7JvrHYKOZCs2k3q6Eru3DCM5DRC2r7lg7Tc/N/c/4GZsM5YBJJIc/De/NbgcbhR/OLsgpTR+I7Q86etQN32AFvFFsly7PKz4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from BL0PR01MB4131.prod.exchangelabs.com (2603:10b6:208:42::20) by
 SN6PR0102MB3406.prod.exchangelabs.com (2603:10b6:805:7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.16; Wed, 16 Nov 2022 14:40:51 +0000
Received: from BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b]) by BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b%4]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 14:40:51 +0000
Message-ID: <c7c6eb30-4b54-01f7-9651-07deac3662bf@cornelisnetworks.com>
Date:   Wed, 16 Nov 2022 08:40:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/7] RDMA/hfi1: don't pass bogus GFP_ flags to
 dma_alloc_coherent
To:     Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-3-hch@lst.de>
Content-Language: en-US
From:   Dean Luick <dean.luick@cornelisnetworks.com>
In-Reply-To: <20221113163535.884299-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH0PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:610:77::22) To BL0PR01MB4131.prod.exchangelabs.com
 (2603:10b6:208:42::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4131:EE_|SN6PR0102MB3406:EE_
X-MS-Office365-Filtering-Correlation-Id: 87551009-9462-453a-acda-08dac7e08ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oV1mWFdhj+qcCUxwXmgHu+P+gyVk3DKCuxRB/7i6EMGfYv5gsdqHUVxRzGKZ6SZHf7BWNOnXUc1eG0KGFahcFvcCK+HwalbSrCld+tbLB2TNApyK+vVpxbf46lrkdt7YnGLfzzhYtBwtKPkjJSQn932Wu6/6WUXmy174lVdfrtSc2Bc4b6wQbwM5/q7w9HE1bT+FdiFSmwIWr/3fiZ4iT46LtkxdmFSsmPBiFbiSHK++ikUcO9tshWohyrCImaEUTEYnrT1dU2eY/LJF3p27LXoc/R/oiU2XQmuN0lWg3L9YtAGJ+PEsDNNmfyt8gjwkNbOQZQfsXEuIiavLCmeUW0rMtH0rjCICNiffLimFzIC0yjmEM8Oyy8aZVcPS55yHdJQ5V6l2X95FH4X6+y/yJrbKsYFB/e6bhzaQxrESrJULRavKvuC9m4V1JzaOEwYWABb0ZNOMnHOALmdsbB64musIhMpLFPMpPmu5XjaaUH+WcWjrtotq2+HLkedoOcr2achztiJ/D1zrzT6M0TeR9l4rder/mn91WQENLawqWB8UR0AGdn6++3GphFOcMDEsAZS+0adx/aUxJjNw+h146K5bHbeCweVovZxjYXFNRWGY8Dky81/6oC5Ok/Pa/vkPxJGW8PWy9Ug8tvzbIgHuNHaPgcPW1UOWzhDUtHrhOzyhd7YPh50II41rV2g0Ql3APydmzzf3fHBuO+Co0NTwAjQjwtJIl1Q22CLulHYeVTD80r3w5t5CS+JyUxVGY7QSNAFge0MW6SucRh7S4FFbJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4131.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(376002)(39840400004)(451199015)(31686004)(83380400001)(6666004)(36756003)(110136005)(6506007)(53546011)(478600001)(31696002)(6512007)(66476007)(26005)(66946007)(66556008)(4326008)(8676002)(38100700002)(86362001)(921005)(2906002)(8936002)(2616005)(6486002)(41300700001)(316002)(7416002)(186003)(5660300002)(44832011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3Z5T2VwMlR3OXExalduODZjRklYUUFQL2FJS1g3ZFE1S1pranJSZnE3NmQr?=
 =?utf-8?B?Q2dmSDAzUVk1bEowZnorSGw4M3F1ZzJ4cW94azZ5OWJ4aEZ6YkNub2kzTCtk?=
 =?utf-8?B?VGxDVW5jYkdnWHYrY2pveGdzS21xZjFMbjZKMjhpUzVScFlhZFBlUDBncmxQ?=
 =?utf-8?B?TzllTWppanhyb09VWHlCOC94N2U0NTNnbmNvczhqRmJmOWVCakthVGtEMEtR?=
 =?utf-8?B?RTJmNEdmTk5VeGZCWU9VV3VzMmJqeDc5YXA3eEQ0dmpDZ2dBaGNBQVY4Nitq?=
 =?utf-8?B?OG1Ha2RRaE1ra2E3b1ZTTjV2U1VoWkpXenF4dE56MGYzLzBEcHFkV0VYMTk2?=
 =?utf-8?B?SGlZSzZwZTA4amlLMDBoRlFjNVM0NWxvamhzM3h0dHRXanVYTXIwRHdOdmxK?=
 =?utf-8?B?ODdMMjZsb0U0bXNxdm9EbFRmenh0WUNVc1NWOW1nQ0tYL0ZwQXZndW1UbCtO?=
 =?utf-8?B?UXhhb2daTUJPMDlqbFlZekwxdGhlNmJWUVNvK05rWVA0L2k2UklITkMzcnpD?=
 =?utf-8?B?QXQwVVdsVkZVaW1tanE0WVVTaVEva2hwcHNvTy9PR1FMcjNsWXJLa2lXS0lv?=
 =?utf-8?B?bmo1TkxIaWNtWU5UZlEvUWtGdkU3Ump6cGlUNUdMdE8zcHNSU3MwM1ZFRXFh?=
 =?utf-8?B?YktCampXcGFQSW9scDR3NFE3TWxSTXhzQWc1UXZPeGtXeWEvR1JIemNBR3JT?=
 =?utf-8?B?b1UxeDJTU25hZ3RhaHBEWlhuV2JsWE9NbTg2bmVuK0hIWDlFSDBCWWtTSHRK?=
 =?utf-8?B?bDl3U0dYTEt1TjlLWUdIU0dLVU1nR0pobVFXSHJ4UzZ2RVFGUzRLemxnS1NV?=
 =?utf-8?B?bklPT2FKYStiWkQzalROaGFoVjFEeGl3NWZuaFU2aC9ySVR4SWJjaHhOY1FC?=
 =?utf-8?B?dExMejMzR2g0Mm1hSHZub2VXNXBCQWxMNkFsclVjcDk2ODZsY1BwY0E3cWFE?=
 =?utf-8?B?dkRLMHE3NEhrRDUyRDY5Q0twTDhSZU9NY1F6MGQ0QzJPM0RkYVFuRGdneXhW?=
 =?utf-8?B?NCtzSnkxb24vTzZGZkYvZ3FHc3ZnQituT0dOek83Mk1wT1hmYTNrYnJIRWp3?=
 =?utf-8?B?aElVd0VOWDlzZHR1dVF5WVZYQzhYRnNtOXFqSVVTTWswaGVXdElWOFRESnds?=
 =?utf-8?B?bGVkb2pKSFM0SGlIOWc3NEJEb0pjTDh0anpmSzI5bVhsazZzK3RLZFVJYW9D?=
 =?utf-8?B?aVZaQ2dzLzcxcUVsSDd4ZmdxbWxETE54bHhGdU9lZmVMVFdiZXBRSmxzVWpQ?=
 =?utf-8?B?VlJIMndFaGFVNFVGNHdmT1BqVkNVSk1ydWhvM1prT0duUGJxZDhJTTBVMFdi?=
 =?utf-8?B?R000TkJvSnVzUVVOajJQMStLZDdEUDVpVGgzQVBpUDl1TURQVEpsSnRBVTdv?=
 =?utf-8?B?OTJnY3VUVlNqemFzbGI0UXN1K3RoTUsxSkkwYkwwYzg1SHdIZTVHeHg5SS9r?=
 =?utf-8?B?N3NOQkQweFhEV25wQnlETzhORTNVUVh0b1AxR2grZCtPRzd3enVueVUvVDRJ?=
 =?utf-8?B?ME1GZEo3NTNVSzlOUGc5ZFBrd2pHemZISE9teVpwSW1rZVdxZUNONG15SlUv?=
 =?utf-8?B?eEpSR1lhRGUxRmNKS3ZjTVBZNTVWZW1XREhHWWh0ai95dXk3cSs0dDZYU1VK?=
 =?utf-8?B?RkJqVVU5bnR6T2kvVVloTGJ4S0dNYlhYaUdQS1lXbTJhYVE3MUVLUUZSV2gz?=
 =?utf-8?B?SGo4WkRXR21IUXEzWWVwRFg3NDBzNlVwVHhiZnF4VVZCS29sVXVmaXJSN2Ji?=
 =?utf-8?B?T1ZhM3JialRYMUpibWVxYmRTVWVmYk5iSlhjZStITGpTcTVRK1kwMmJJV1Jt?=
 =?utf-8?B?U1prNW42OFRSbDV0SnNlU1NQVFVsdlFBRjhUZHZWUW5sd3I4UjREY1hLZGh3?=
 =?utf-8?B?UEpCME9LV0RLTkcwOU90VVZ0cjJNNDJpMUc5UnZ0MGhFeE5UNGpSNk52emcy?=
 =?utf-8?B?RFlhZ2dTdms0ZUNIbE9OMHhScElWVnMvcWs2Vko5MHJXV1JCMTBNUFgyWnZh?=
 =?utf-8?B?L0hwS2MwZktMK1U5ditBVE9mNHcwaHJiUWVtVlFNL0drRXI0NmRBbCtNaVF6?=
 =?utf-8?B?NkQ2V3IreDFoYU5LMXdVMDBqQTZDRHNMd0NreXpYR1RZZHdrRkVUaGRvKzZh?=
 =?utf-8?B?YkMwSkR6M2hZSkF6ZW5STFlkNEtmV2taZ1doTWM4Z3hMWFNjcC9sZEVUUS9l?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87551009-9462-453a-acda-08dac7e08ec8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4131.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 14:40:51.0339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQ/nTykRdIaJCNPxnCxm68yn33vry0fIzdZ2Fvx3QE5vqzXkcuUjfVlYM9QN1/5smFQwC339EyzALKidQvYtzh/CCdBFNkjIynQ6Q7wOAIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3406
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/2022 10:35 AM, Christoph Hellwig wrote:
> dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
> for allocation context control.  Don't pass GFP_USER which doesn't make
> sense for a kernel DMA allocation or __GFP_COMP which makes no sense
> for an allocation that can't in any way be converted to a page pointer.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/hw/hfi1/init.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hf=
i1/init.c
> index 436372b314312..24c0f0d257fc9 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -1761,17 +1761,11 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, =
struct hfi1_ctxtdata *rcd)
>       unsigned amt;
>
>       if (!rcd->rcvhdrq) {
> -             gfp_t gfp_flags;
> -
>               amt =3D rcvhdrq_size(rcd);
>
> -             if (rcd->ctxt < dd->first_dyn_alloc_ctxt || rcd->is_vnic)
> -                     gfp_flags =3D GFP_KERNEL;
> -             else
> -                     gfp_flags =3D GFP_USER;
>               rcd->rcvhdrq =3D dma_alloc_coherent(&dd->pcidev->dev, amt,
>                                                 &rcd->rcvhdrq_dma,
> -                                               gfp_flags | __GFP_COMP);
> +                                               GFP_KERNEL);

A user context receive header queue may be mapped into user space.  Is that=
 not the use case for GFP_USER?  The above conditional is what decides.

Why do you think GFP_USER should be removed here?

-Dean
External recipient
