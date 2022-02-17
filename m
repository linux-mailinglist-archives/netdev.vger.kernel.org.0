Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CB44B9D42
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbiBQKfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:35:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiBQKfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:35:31 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A227D6B5
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645094114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msTEMNJZLitu29lKEW+OQmN57Js4hhDffm8mV43g1C0=;
        b=BoCIKUWW3YpS9g47zdMmR+cEBdDq6zrlXlY2IiSF4q7HHdHTqqQVaajkYOAObH0zn+X5zU
        IY4lhttqtYR6OYG2V5zO506V7HP5pwy6hi0zCM08gjVm3Kw9K3ZuuxmKHkmY//RHwh8ARF
        cQ9i/nfnSirxzH2qBTt8Q0HZnxhhzxg=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-j63jX1L0PsmQNmMii42YPA-1; Thu, 17 Feb 2022 11:35:13 +0100
X-MC-Unique: j63jX1L0PsmQNmMii42YPA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhRY3aAx2CB+oHCd5Bbj3FqKis3tXeD311UtDG3TQQrKCIIh1oS6K+F0K8iGswp3On9ZJmWcv2HVe02m8JVxcTl3tI3Iqx+ykyGijhfbWSeuQIXxffB1y/d5/PPLxAmP+j1Mlcp6D8exv1FBJSQdGT3prVsTZNF8YuW0vfccwUINKkOiVajORehhEbtHS95OWRNTUaAO0wJyff84xr7XBa+3yOmuWa5YGfWmpg/ZP8b7C/Ksz1JFHe7NpIe480MQG+ARLxEi3Vj1JzaMQG5tOlxN0Uz3P98p+9BlurpP7JFSggqEvyVuplBvWEKE0aep2byGcvKoL6B1TU0uZS88cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SE1PKJT2qCfegbyo+70SURGSg0s6SkCNFBwtcDU3p50=;
 b=Id2upOQkeXHk2F1MTYjI61EOexToH2iA0CznSFsCz94k/Bx4jwV51jjwKgUf1jvin2+Z2NsiiimV7q1n6eiG26X/qQSFc1uoNK3tv24EFvuCYTt6PVYa53yyOsvHZukvyXYqFB238zeVf0CnSA4mji0tLwKyyUUlLcSEoCFizQVlkdqYhHxKEozAmnjiCOVmXtWgYkvjTdwx9flRBV6Qefm9nsAz4b9ylPRPiSschenmRtWvBOz7r2o2hS0w/kvjqjK2PkXbiNwg+fgAx1wZ/W93wWVc/5WbiLzeWIhTJ1NQgtKtL+cToLQWGg0LmiVyyhjD2D/vfAeyHxjnaHMDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AS8PR04MB8802.eurprd04.prod.outlook.com (2603:10a6:20b:42d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 10:35:12 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 10:35:12 +0000
Message-ID: <0642f910-bccf-103c-c176-d77cc75e6a25@suse.com>
Date:   Thu, 17 Feb 2022 11:35:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: malicious devices causing unaligned accesses [v2]
Content-Language: en-US
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stern@rowland.harvard.edu, USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuliano Belinassi <giuliano.belinassi@suse.com>
References: <281493dd-4b3c-3c99-8491-f5e6b0af602f@suse.com>
 <87sfshaiuc.fsf@miraculix.mork.no>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <87sfshaiuc.fsf@miraculix.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::31) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70788d3c-887d-482c-71ee-08d9f2012d46
X-MS-TrafficTypeDiagnostic: AS8PR04MB8802:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AS8PR04MB8802773C0D6C1F0EC6CCA784C7369@AS8PR04MB8802.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7fqtbMCfGKaRbxgsu2KYCQXCAyAsClb1yKq/bgKZmDkT+XlT1U+zVCjetLORm8Kwf4HpGydzAF1oGL5hSzimiUG718o3FGM1BdAyC0veG8VXyM/of6wtiSwsEcr7aAPwrnAGv5EukuHZ7vPYr9sPC/jhaV1uQKosvrT1Y9fOhW4e6prFOF16M5ULl+WLe17xHvVt/QHyWXtNFWLbT7rFFzLEfQUC+8w1ou6OzrsG4nZIxtn09QQxo7xUSNpZu564Tr0p29yPCs6Ts5yd6bsufmkxK+VzxXYdppJqdnLGkEjw859jqq6vMJhwnUhlmCg1oP+l8LIbu5L+vqPAJZdZ+SCg/TLjf0cw63gQ6tbPA8g3qmuG7Gkjqyb45cv+cbBAkLa6KF8sHIALW1iUFhy/qtI4zUIQE3WkV5XjAvMHJcpcVyD54L2HW6RDSy4y5yuFgwnTPyKokDPGqi7X63NOrzwdJ04wK1H0hRzyr4pLDI98z0lbSSb5dhXI1NEp2CJ2DyCooeVdr3zO3iB3YWY2sCPSHAfDwe8psOFQi+SeLKTy8Gs6Joed72Igw/9AaWRYoVNL2NCsQTw4UYBVzWeVBrTxr3nvs8+zo7ovfxZfR3H6OCv1Nbfy4ihtdF1wXQJZxcmJYvUCtnI8SY3b2GNFo6N8B7ypRs4ubhbNlzxLmcnOoAjT5LhNfb7DTwA9xMdzvT3aPeq0hJfyMvDixQWueLKdTmbYsEQ/AP3uCOeO9U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(53546011)(66556008)(4326008)(66476007)(6506007)(186003)(8676002)(83380400001)(107886003)(2906002)(2616005)(5660300002)(66574015)(86362001)(31696002)(6512007)(8936002)(6486002)(54906003)(110136005)(36756003)(316002)(508600001)(31686004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LUviuftLLEKKobnqpMU8g/wVYMvpizkcPX97y65SkKTZg42e5DrC1B89Bwb8?=
 =?us-ascii?Q?PdzHh9j1ly9ZWYK256mqgesXUqVHWyI5FnB3kV4VAV7pUEiiiCpy6PTcxrFU?=
 =?us-ascii?Q?M8iMCTSBrSLDyQpk1Vb2Ll+MuKpqxG6Ko5Gv1xRzLLJ2pbMbZG0uLJ4I9tQH?=
 =?us-ascii?Q?A/g3hPvTgGR2ZK4Ifvf/vgZ9iqJTU+HjFXj+TG+Vs7TcIhOA9Euw6Q2jtzvd?=
 =?us-ascii?Q?a6djnODjIakbbe2eKS6RSGaRivQxe1W8xOCiTstZjSsWl+zOe6nKRXw/hrF8?=
 =?us-ascii?Q?KWu1VtxYA+1Xv2nHv0Xc01FDgJ9Yzby6dfpMQgtjejp6DqLb0YKCgnOccHWT?=
 =?us-ascii?Q?Yi4jNrYmsQDdPqilrsRJgC9jOAubfZ6/O7gQHYf1BIdfq6KUo+YYy7Fzl121?=
 =?us-ascii?Q?dO7ayMfOKr2cQN7siNvH5OegFkHhZi/ej97P/EkHRPApZKI0b11Y7NBZ/AJg?=
 =?us-ascii?Q?IZuwkXZzriBgeBpfTf6+b6XfrFENJkpfnOs1RMsCPxbPXcN3v58VJfgcXlkG?=
 =?us-ascii?Q?6NMGCSzyrTzsbmVtrpwG7YIkBAC7G8lzcE6wYsVJn4oAnV0C8U9kb2cVyLhd?=
 =?us-ascii?Q?q56Ik2mp7APjDz8w/3sfIo3js51BGCmgKduKdA/28ycB3miagt51nB1wZLjs?=
 =?us-ascii?Q?Ln5RTcRdqGoxAoENP5p119Nos+tkADAd04MnSVdSiydO2V1w2tGJaVQbgkl3?=
 =?us-ascii?Q?BTbtcpFzPiBimNx+KFNUOt5/Up7nXlIQcuiYF+XzEdIiVgMdpRBKgyJLTyuq?=
 =?us-ascii?Q?vUzRHufNdPqnDtYaV6fXefPWpQr4dOzsydw8BYhtUSKAXJLBcR22WiSJX9e0?=
 =?us-ascii?Q?YLThkS35p6llA2c/EZLku8vNCPbsyVyoUlImWCbgo0D1XBDQxTnS5QAWTnU1?=
 =?us-ascii?Q?nESL5EH/H+a/QA5wc/Lgr63gS1iuk+83M0Z1vCmMuU+Nx/zo0AQcghfqIb7z?=
 =?us-ascii?Q?bqq+bkkRwzsaaHHjIB2KV6Rm3+z9sr7kCn2jj8ky4nOr1zkW0GGWk2pdbJDJ?=
 =?us-ascii?Q?NZkzhHjQQLXyokqiZqAIcuynV+wOPeZbX6qFrgFndrlqtdERqO+xxi6XaF8z?=
 =?us-ascii?Q?OUfS7g1mOYHGI+B3PobcqdxCe/cAc92IOc5PsNDT+h0gRNUM5z8Cb84dEYCr?=
 =?us-ascii?Q?HUlp8eBwav6tNA+PgCN9GfPYNMoJ5YAHF+erI5M4ht8I5FL4GXnLczKh0wUx?=
 =?us-ascii?Q?i5na25bdgcQudadtq+tOj3OZ4BWK0aeOben0QflltT8aBP8bZduUxw9gvQEL?=
 =?us-ascii?Q?OL0DRl+a4/0BvrAEe8xofJZzb5r/Eo/sweNyKSMdBE4Puz46BIj1ywac2+jO?=
 =?us-ascii?Q?X2PEHy2NhvwMST5t9u3tieW7K9/ldPBFNjWmegZ+Xc1Uo2uX+NrrUH2i97NE?=
 =?us-ascii?Q?NS9pPU3/QLJkJ5TsCvTuQ6qjH33I0FjJiLoh/wNXhQGheoKxyJ13shf+nd/E?=
 =?us-ascii?Q?JMcnbuMwXPxp4r+9eInK8PTWZUz8f9UboIVKvuoA3Y+HeuK8K8a3kkSqWhmX?=
 =?us-ascii?Q?eSwQublDF+pwpXbeNG1Y3bs9n4XJdq7wjrgK2BoLW/Xh/4X/iiqzWeRdNFcZ?=
 =?us-ascii?Q?Zj1GbYUziYEebNMIakLA9Kf1MrRcqadLzttTr5HRAGhbl3UwiPC5JwiWXi8A?=
 =?us-ascii?Q?/znTECbb5mAiMvgH5Ivl0LgSMHDg27eWcnC2fOiHqp+6nStVpM7OWjq8y50a?=
 =?us-ascii?Q?7jfAh1JSwR+3qBfnKjtJwlZxzLw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70788d3c-887d-482c-71ee-08d9f2012d46
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:35:12.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZj5wBXGLPuvkqSgXwtdAO2rN07+WF1LSvUe1SjeLgfYHTJx5YwxTq8NR37ei+6FXgPAxAeEHhGpiovVHitXhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8802
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.02.22 11:27, Bj=C3=B8rn Mork wrote:
> Oliver Neukum <oneukum@suse.com> writes:
>
>> Hi,
>>
>> going through the USB network drivers looking for ways
>> a malicious device could do us harm I found drivers taking
>> the alignment coming from the device for granted.
>>
>> An example can be seen in qmi_wwan:
>>
>> while (offset + qmimux_hdr_sz < skb->len) {
>> =C2=A0=C2=A0=C2=A0 hdr =3D (struct qmimux_hdr*)(skb->data + offset);
>> =C2=A0=C2=A0=C2=A0 len =3D be16_to_cpu(hdr->pkt_len);
>>
>> As you can see the driver accesses stuff coming from the device with the
>> expectation
>> that it keep to natural alignment. On some architectures that is a way a
>> device could use to do bad things to a host. What is to be done about
>> that?
> We can deal with this the same way we deal with hostile hot-plugged CPUs
> or memory modules.
Yes. That is a basic decision that needs to be made
> Yes, the aligment should probably be verified.  But there are so many
> ways a hostile network adapter can mess with us than I don't buy the
> "malicious device" argument...
Sure, so what is the level of damage that is acceptable?
>
> FWIW, the more recent rmnet demuxing implementation from Qualcomm seems
> to suffer from the same problem.
>
>
> struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
> 				      struct rmnet_port *port)
> {
> 	struct rmnet_map_header *maph;
> 	struct sk_buff *skbn;
> 	u32 packet_len;
>
> 	if (skb->len =3D=3D 0)
> 		return NULL;
>
> 	maph =3D (struct rmnet_map_header *)skb->data;
> 	packet_len =3D ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);
>
>
> (this implementation moves skb->data by packet_len instead of doing the
> offset calculation, but I don't think that makes any difference?)
>
> I guess there is no alignment guarantee here, whether the device is
> malicious or not. So we probably have to deal with unaligned accesses to
> maph/hdr->pkt_len?
Yes, as far as I can tell a device is fully in spec if it sends frames as
tightly packed as possible, so this is simply a bug, not a security issue.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

