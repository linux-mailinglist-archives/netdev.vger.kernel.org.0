Return-Path: <netdev+bounces-89-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA73C6F50FC
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E27CD1C20BC3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4E62113;
	Wed,  3 May 2023 07:16:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5D111E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:16:10 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC82422D;
	Wed,  3 May 2023 00:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/qQft16kzefIQ8LUGtVbLOaguitnUM+Uckb4BrJQkuiXyrmGqMV6+Jk3MEJ9CgmaGbkys5ttDSQsK2ubmT62Y/JdOaXlPBOV7F5q1MRfuJ/k9RxOGPQAjPL/2+ykRd3WErlcfAXp2bod/FMZ9ZYhvHddqSJrBK8/R7bOduMk6yXuxfDYDgm8VxbMdm9Bv1L0rlXhjLlRQN9vFQJJ3/Igsymin2QgkZqBqRR1wDnNQE90EGRkHFHlcdVjIHPG2C8PNrQzY1xczgGHACT+gID10UuhIR7yA8qcbLwAvgHtNdRRxhKRagE38t1nxuqdv3PDtaYW7R312lZZFmNnlwN9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3KBTSJBb+abUahNgLzos10712LFwdZDW+Eus5T8OOk=;
 b=HL88NSKeJfsTXb7y/iqz21nyWoqIWopLz4t761XffxiM5Hk/v5ZDHY/CLqiTrjY4EJSYAWG4hLMC1+UTgmpYlWR39nwaCmMyHb/jWceUk+iF+HXCidCrYMwGdldHr4v6onuFeNvCHPJB5Tqaw/zI9EHSVbYi0Heos35qiRsmPW1w/Y/JzxYHIDIPFyyLgLmlDsmj3LVghCn2w/g0/QkVC2QWQl17CIZu86/x1R4GgYA5ORiTsVTbYP+G7dOiZIR9YEpCtv6bp+qp5MSHlxY8MNV/lwg/K8tg4GQI0MGMiKyu6g2BTI/vR8n77203UUTf8nnEmhSS1eFoIRNtQOGzdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3KBTSJBb+abUahNgLzos10712LFwdZDW+Eus5T8OOk=;
 b=FEbXawT0/NnhvlGDJXtqijeXNJ7vVQ9shy6ZKOsWattM0w+Xb/B29/HVGDovc+TnOOu7y7N5z/9NMbP3h4JapTA+8vcNfWoz+LZ6oaczNBMF9hNhTg6hkNWT5cJXv0Iv9EnrUYE1lgMEh/CaP0gQksrx9HjnygcBvTZNagf+/0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5972.namprd13.prod.outlook.com (2603:10b6:303:1cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 07:16:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 07:16:05 +0000
Date: Wed, 3 May 2023 09:15:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justinpopo6@gmail.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com
Subject: Re: [PATCH v2 net-next 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <ZFIKLRqFaJSHEIwp@corigine.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-4-git-send-email-justinpopo6@gmail.com>
 <ZFFn3UdlapiTlCam@corigine.com>
 <CAJx26kV9E7M5ULoPqT8eJ5byaUEZDtW6v25f3DT04xs4NGcd6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJx26kV9E7M5ULoPqT8eJ5byaUEZDtW6v25f3DT04xs4NGcd6g@mail.gmail.com>
X-ClientProxiedBy: AM4PR0501CA0043.eurprd05.prod.outlook.com
 (2603:10a6:200:68::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 36667392-9ee6-4680-c186-08db4ba6424e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S7alDoF2QwjedV3SHYym86nXj+HDQheTO78ks16UeglLOdiC4y4HHgAYVVNqS2IhxAprt/WO+iDS5fUFoFoeLqI+AFx9Sp0jfp8VKu1SBbF4ms9x97RMb6kv7i8KUSWQJi4YoIfgWKM5duieqIHCPtabMpTgPSWwJBua5yuJd9Zk9yh7LM4QNnnYLcCZJiGff20uU+zRe6QYY4ybOl3uw0yZD+TDDkSQ/78tjlcTulLeuwNN3o+n5NBaNdMs7pMKf9xmjPGFAL7ErYWVHDfqhkdMw0kIpllhtjg0kZShnjuWdvdWvysB8y5iAo1r1iweYmA73roon13ICWIPFjm7MGd3Y/jQyQONWXZt+DY+ntF+XcbhPGtOKLkcy5U6H+yqte4B2av6PPrq75eu0Dnrihw3lotewLxVROcevyqzWcUrPnLDcQBVGtCv0zf9trX8daZu5ocrlerKruWrGsqsjrXagO32GpqNG1mz+Jx3lb7B1IGsosXR2mBpF5e8xsuOU6GfKBIhsNNIMJ4CbN5pk3mKscO8pz7FyZuINKDJKmb7efW22qw/OrxN4VXDiEEW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(39840400004)(376002)(451199021)(478600001)(83380400001)(36756003)(6512007)(53546011)(6486002)(186003)(6506007)(86362001)(38100700002)(2616005)(6666004)(66946007)(316002)(4326008)(6916009)(66556008)(66476007)(8676002)(41300700001)(8936002)(7416002)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wms2cXpHNG9Fbk1ycEwwdTlBSGlQN2VuT0Fia1hIaEN5V0U5cnREK2dVajEw?=
 =?utf-8?B?WTh3cGlZWXRIT0dmbGFJelYwbkw5YXQ5TUJLam5EZGJLUi84U3ZFTXNnN1Ey?=
 =?utf-8?B?cjRFZHY0MFJTUHNVaDc2STVrVUdzL3lGaHBHM1p5TXNyWmdyc3hicW1Ta3ZC?=
 =?utf-8?B?Y3hYZDBYR3A4WFJNTXpmSFlveFNsdXoxSitCWFNnb2RXU001UmlPTnQybSt3?=
 =?utf-8?B?Zk04REpTMXp4TjVlRU1XcG9yOG5xTTlTUFMzOVpIL2lOcUJ0RWdCTDBlNmQ2?=
 =?utf-8?B?OFZldFJjVE1nR2lWdlZlZTV1NzUvVlROeGxBYTM5Z0dWYisxeWh0ay9pbjBK?=
 =?utf-8?B?b3haQ1dzRGQ1elhza25QUE1LcWwwampRZTFWOTV0dlRIc0RFN3p4eWQxWFNU?=
 =?utf-8?B?eGhGSVo0eERBR2cwNlk2L0hsNTR4S0JrWit4OFh3VUZjR3FZNk05SFdJdUNo?=
 =?utf-8?B?UTFYaVZYZFFxb1JyRGhFNVRDYVpFTndOMjdQS2Z5MHc5MlViSnRleTltUGNx?=
 =?utf-8?B?Vk13ZmMvYVdacjJSS2U3T1NITis0ZkEwNjhZcjRxZS9wVTQyZEE4SXBvM3NU?=
 =?utf-8?B?WnMxZTNFd3RZR09VQWE0dm1IY1B2UzdYN1hXM0dJYU1CYkVWeW42WEdZVjlk?=
 =?utf-8?B?SWIrT24xamZhZWR5c3p4YVNVaU0zTGttanpCOFNwK0VvalJzUnR0MjgxZ0po?=
 =?utf-8?B?WW00SnlFQm9CeU41eFFGdnR3aW9QazV1aXZPanUrNzBHeGFPczV5TGxhcWVx?=
 =?utf-8?B?Q2hlc2d3THRvMjZCRFNTYVNJZzdYREhwYjVpSGxpM3F2d2NPak5oVDJHclM2?=
 =?utf-8?B?S2x5Z1FzekowZEFwcDEveDRhaFJQLytTRklQaWY2OTlwSlo4ejk0RUxoYURw?=
 =?utf-8?B?dDUwb3RwTE9zT21tMjRVOFdVM2paWUVEcmdlZUQ3QWcwK3hXV1JBYUh1dnZI?=
 =?utf-8?B?OVd6Z05OcGRIMjZRN1NJZFlTc0EyZ3drblVPR1Y2dXcvU2ZjdXRhQzE4dzMz?=
 =?utf-8?B?aWZXYk45UUorS0hIL3d6YW1yaEtKc3RWdFFEdFcrTTNmUE9KaU9CY3VtcitH?=
 =?utf-8?B?bFQyaWQyZnBSWXFHWTQ2cVNxRjFBWWVlYmhIRy9rOUNoQVYxS0IwVVZqeVVC?=
 =?utf-8?B?NXhqbjFPV3Z1RUJTS2xYOWZNb29xc2xJdXJpdHREVzc2ck1CNUszQXJKbFcz?=
 =?utf-8?B?Vjk4Ymk5TUdPWXI2OUNybTBobjRkemZtQ2lwVVF1YVpRRXNrVytCNXl1M2lT?=
 =?utf-8?B?ZDd5T253RHRLbUlpOTRjbTdMVDNBUHAvR0hlRkNvRHpWTUMwM1YvR0FnVHZw?=
 =?utf-8?B?ZFFtcFNnRTdsV3V2VnJKeGgxSmNCVnJvTzVEa2xHdU1PaWZhVHZWUjh1V1RC?=
 =?utf-8?B?OXlhWGFTeXk3QVFDYlFyVkI5c0xZUmhvZzd3SXQyNDVrSGs3VGJhaVZ0OEd2?=
 =?utf-8?B?WHRJdjRpMHlSd0JONlY2cklLM3V2ZklQZzF5YzF6SE5oY3VtMTROalFIZFhh?=
 =?utf-8?B?ZW43bzdFTndZZmlJNCtLM1NZemNtZWN5M2tjRXVCa3pUcmE0NUN1UENnbkh5?=
 =?utf-8?B?aXJiUkllSlRXcDBuYVBGUEpSTCtvd0NpSW1ENGVQWEdtYWZ0VjF3d1d0M0dN?=
 =?utf-8?B?WjlQWEJiZmFJUjJoK2xuQzhGYklocVNIVmZZZW1CbmxtUEdJTUUwSkF6YmM1?=
 =?utf-8?B?OXhKT2pRNHVndVlVOUxaaHk0a1F2QWlOTEZNYjV0TzVuTGlHYkJONTMrcWFs?=
 =?utf-8?B?NlFTVjhCU0Z3SnZMUk53YWtRM1RFUGRoNko3RGtQUnk2MnB1cnhuZ1FCUVVz?=
 =?utf-8?B?R0crYWRMd0xGVmVIb2pOcy9QMDhVZWlDKzJZeHVwaHRPNHdQTExmNXViTitl?=
 =?utf-8?B?d3F1eC95RE4vd2dKNW1SR1gxM2d3b0VBVWoxZU44N01VM0gyNHlrUmlCM3hY?=
 =?utf-8?B?ZVRDcjN5NDJ4cDNjSWxYUlR1QXRsSGUvZmFCU3drQm0zMHI4U1lNc0N3R0cv?=
 =?utf-8?B?ZW9OMXJybGdDZGNlNkR1dmY2WVI5eUg0aFZwTTlUaVpUNXZTZGI4SGUwQTRo?=
 =?utf-8?B?UDVUTjR5QXVIM3pzcFQxQm5hVndhNyt0Y3dDb1pzRWhaZ25ZVHFheEhQU011?=
 =?utf-8?B?SC9BQ3M0bXVmYXJmbi81cllZbW13SkUva2FNM1lwcEZsQ0tqSkhGeGR1dDlD?=
 =?utf-8?B?V3BFNnRlWXNZNzNXMUI4OUE3VDJKdVA2NkFrbXJ1WnBSbG9ibU1CVVZvaVds?=
 =?utf-8?B?bkI5Um5hRFROTEsxQm4yYldvL0VnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36667392-9ee6-4680-c186-08db4ba6424e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 07:16:05.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xg+Ir7FE+BGLC3j5W8ZwwwS1wTTev3pAr+MzqvBFu2veFyyppeAgT8HDC06OLHgLz/7TXq3rqSKek5iU2P3h5c/wCdSuWPYTfk+tGAHl2b8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 02:26:53PM -0700, Justin Chen wrote:
> On Tue, May 2, 2023 at 12:44 PM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Wed, Apr 26, 2023 at 11:54:29AM -0700, Justin Chen wrote:

...

> > > +static void bcmasp_update_mib_counters(struct bcmasp_intf *priv)
> > > +{
> > > +     int i, j = 0;
> > > +
> > > +     for (i = 0; i < BCMASP_STATS_LEN; i++) {
> > > +             const struct bcmasp_stats *s;
> > > +             u16 offset = 0;
> > > +             u32 val = 0;
> > > +             char *p;
> > > +
> > > +             s = &bcmasp_gstrings_stats[i];
> > > +             switch (s->type) {
> > > +             case BCMASP_STAT_NETDEV:
> > > +             case BCMASP_STAT_SOFT:
> > > +                     continue;
> > > +             case BCMASP_STAT_RUNT:
> > > +                     offset += BCMASP_STAT_OFFSET;
> > > +                     fallthrough;
> > > +             case BCMASP_STAT_MIB_TX:
> > > +                     offset += BCMASP_STAT_OFFSET;
> > > +                     fallthrough;
> > > +             case BCMASP_STAT_MIB_RX:
> > > +                     val = umac_rl(priv, UMC_MIB_START + j + offset);
> > > +                     offset = 0;     /* Reset Offset */
> > > +                     break;
> > > +             case BCMASP_STAT_RX_EDPKT:
> > > +                     val = rx_edpkt_core_rl(priv->parent, s->reg_offset);
> > > +                     break;
> > > +             case BCMASP_STAT_RX_CTRL:
> > > +                     offset = bcmasp_stat_fixup_offset(priv, s);
> > > +                     if (offset != ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT)
> > > +                             offset += sizeof(u32) * priv->port;
> > > +                     val = rx_ctrl_core_rl(priv->parent, offset);
> > > +                     break;
> > > +             }
> > > +
> > > +             j += s->stat_sizeof;
> > > +             p = (char *)priv + s->stat_offset;
> > > +             *(u32 *)p = val;
> >
> > Is p always 32bit aligned?
> >
> 
> Nope. I can make sure it is 32 bit aligned.

I'm not sure if it helps, but you could also consider put_unaligned().

> Acked, the other comments. Will submit v3 when net-next window is
> open. Thank you for the review.

Likewise, thanks.

