Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2459B4B11A1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbiBJPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:24:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbiBJPYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:24:03 -0500
X-Greylist: delayed 4208 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 07:24:04 PST
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB0CE5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644506642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3ro4L0cP9mg5Ij0iz/ZFdm9NWBjL+zFm3TVBR3Bgpt0=;
        b=c+Cixldm34Aej/mCgQcbW2jS9QJCqGsrSJ4U0haRgwq8HeKBGidY8b0cWOiz6uwFm3aJiG
        sZXdSj5lW/YQ7VTIHfj3xuHGzgC3WNT4flyAbxBbFzh8AaURjN9y5ELEn71yVpICmuYy7O
        S2LiSxPBWd9YIvRAFd+8kPBPVid8sx8=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-X8HQKP2fNzSQ7djBY0eNqg-1; Thu, 10 Feb 2022 16:24:00 +0100
X-MC-Unique: X8HQKP2fNzSQ7djBY0eNqg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG+omBvAk0IVDE1Ko6/kzXGRDLl1FFepBvBEiDugxv/euhAX6xn6surCsDmRlx7p+vpcbVfb0fv6SrsoNjmKCKEs/Gteq3ADb0QOuYOMDEBkGY7f9WJqKda0+/u+3dleEhc8oiVNTu0AZFbMmZL5vYZD2ZFBzs9RcWM1a8p8xiLmVd+GnC33lAp9IyqRdvfkrf9VjyF7/E32T54YPvtj+jv7nwBE/0Gmn8HbO4E8IyzcvcAv8VreXyLqmwUJWqb/84041WT6pd387/ofTPrV7D8BHjPj9bUSA3GAb8b1DssYf/cVFN+qYHT6aV4gteshdHHgWKPU92QaolgoGZF0gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqw5ABk4tQqk0VSKMzn0VA9nTetbjsuBoqgpODD2Dpo=;
 b=KWZpOiY1C46yXv0ukZywWINv2Tq0Yxh16awFwblboT/KIvRHr660UkzEROjJfV0joQUW/9z6wTGkGop4nClhwX2EWyxcA06CE8KuWLq5XsCUC++dXJjsgaF64yIbls6otUP/HLOkaY8ylNpqb4y045M/u1FGDMpHsa0mmlnJMSjc7hXO+JWn4vZG6hXy57t6+uyvr+2pscRx7a0Nw7JdOolywZ8fpj12HkP+NTxzRIDj3vkJgbukjmVhgxiG6OlR06cgJYBFOquRS3ZexTjYc+69NTm/b3m6PpwyIwmEE+2j8xJ+K+yaPzsLkrm/nwv2J8F5Tqhb27eJNz7Snu17vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB9PR04MB8299.eurprd04.prod.outlook.com (2603:10a6:10:241::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 15:24:00 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 15:24:00 +0000
Message-ID: <68332064-3c38-fe81-b659-613940a6cfb1@suse.com>
Date:   Thu, 10 Feb 2022 16:23:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Content-Language: en-US
CC:     USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: possible integer overflow in CDC-NCM checks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR0101CA0034.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::47) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98ba67bf-ef6b-43a5-f778-08d9eca95cb8
X-MS-TrafficTypeDiagnostic: DB9PR04MB8299:EE_
X-Microsoft-Antispam-PRVS: <DB9PR04MB82995DE95DAF4F1EF2919F04C72F9@DB9PR04MB8299.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwLyGTu+838Oh2xip2GPfkfQKTrG3gf3831+8qZsFObBCsGxFLevwGykSJFXcWvJLa1S7uFzYbnOrJ0R2QOscY9sFihRgAozVp7nwvBhKsYyMHR+23NKU3cDafbtf0g34w3PnegQ0U4PdYZhULiRlzqshmaocWRzL3/rlCl+JIRD8n9B+BZxFwcPl6LXhpLIVx9TSvcyO4kaDBTzZcKeMTtt3xIjYaSBqdnfGpS9KWuDNnkubQ5mjaBnXl/QdBd8emCnkb/qixxvH/NwDyMJA5a8s7jm0YxVhCtFTgh7EW8AuHU4Ffup9oAdivcPNfrU1txskpcqOvWuRPbcW1KfRm3b7kr49FcJ8dHb8MuIsex7SIlY2y8WZ9PpmIPi1VWSKfNl7K7/skxUNX1myhjHDhMgOlUqRJ9Gu3LUv7l5EPusOD2V3Dk4bzRVeE939ZyDkLfPX2LN6K7PdJay7lFuM8Iap1gaNvA7aoOZqFV5hfJNz4UfyTL95S0MZG96fu8oXIE/fn9eH60GbVY1ViNGowdIYA8dvf5xevYLuwIxVLYkFLL3zMId/VJNik03YKHtPLcGLyh1hAqJfEG+jbR9T6hcsqjiN3XrY6zbO3KbFz7vTBU8lAjofhgsAUnodrJH6hIl0TDzzEP2GMs9tNNhginezH2iAQLFLCNLZsttL+tXPL/x84hqawgD3Fn7gRWAKsicxMkRxHxHp851njlvJxtf1vRGCb087CiJ7KpupRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(186003)(5660300002)(6506007)(6486002)(2906002)(316002)(4326008)(8936002)(6512007)(36756003)(66556008)(66476007)(66946007)(83380400001)(8676002)(38100700002)(31696002)(6916009)(54906003)(31686004)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?50oLIMV6mDmZ7Be1C1cAWhCWS0nYXCE2ih3Rfr43QktWJL+nLZEXxJkRi+at?=
 =?us-ascii?Q?vGvtfBhfvQx5udKhmFAw0C+oloVOq0ZToTUvReRRl16ejnZKVDY1cfkloPQA?=
 =?us-ascii?Q?j2L7BQtu7UMi+tXgejTFMYXl3rwSQpWddZvMmLzsf9yuri91lmgvrufKLhNK?=
 =?us-ascii?Q?XtI2QLMlqKHBXmydULzkHY8BEp0isEL2GK3wnNjq1X0l7QF9FS+hKnlPkjeu?=
 =?us-ascii?Q?QE9+MHlxlthOhawNASU4qUYHmOSN7D8HGwOh1MV3lzw+7Av8ZCBY4r5a8WAn?=
 =?us-ascii?Q?B7pgfsG8q5hVFaSSRmkz9V3UWN6RFWZLeKxcZbphvpeIwliY4xym6cUVSfS6?=
 =?us-ascii?Q?Kkfahag3lWpf4uYG9rsTWg17D0a74DrRDzdUOrVjdbJjL+5IHJWHRktJhbA3?=
 =?us-ascii?Q?eW0bcFvJcJwDhCnDb5+ru4tdNp7foB7vJJt3wJPLhusXg0Hx1m0eyo9R1ru0?=
 =?us-ascii?Q?ucR124Jlc6tcWgw400r5SIlYm2Z7LNz0bEG5cOTqQmiB5KC53b0MuFy4n36a?=
 =?us-ascii?Q?04FTIgCbk8kO6cgjqcBqy9mQekUoRjRh2IPCco2F7oV3mzMQNDRX9TBVyZfl?=
 =?us-ascii?Q?UtjWYleuSybcwybmV5a62j/u//ZcfMAOW08ViJBY/pV8mCL/+GzHEJJ0nYPc?=
 =?us-ascii?Q?2Mshi4zxjzRDM7ITd9oFSk249YnlgZI0dKmhLXpXfL6I2FdvLv86d+HGhW1U?=
 =?us-ascii?Q?ZQkJuWw8xpREdOhVQcOtOBDODBlG4xcsQFzvN/vsNckI7TMxFUIRAkhLW1HA?=
 =?us-ascii?Q?xH7Hlidq+RhUvVhtL5gEvZZI65EEi+TEXYwAOphRJFw9xWoVq1kBj5UoPg9F?=
 =?us-ascii?Q?jenjNGNnqc4KsOpK3bzMTnDDbdoLed11D+P/hDdXCmINL2TKGtTRGvsIDlo8?=
 =?us-ascii?Q?RHVNTkROI447bMUgsQgdtqkqmGELbvjqLGZkv0S3drDlZP6RWndUepqpKCSg?=
 =?us-ascii?Q?NgE5yT23N/5W48oV1AXJioKCkXsKqNRUGiG0lu/XNJAQgmv131QGXbYcmhma?=
 =?us-ascii?Q?RFzJoEM103dztNtWxQNjBH7rD2PI6VKs3spmXyfvEcmaxyRFi+P74t5DInaI?=
 =?us-ascii?Q?b7/jX1LciS/4GmEYpyDmSOwyTB/P0fWSPl+MVNxyX4/oAM1RbbXSxqUpg2YV?=
 =?us-ascii?Q?WevarYylJT3it642CG82AngFtGJ9OQj1WWyIEKvBn/WQeWXWtcGNkSOw8qUo?=
 =?us-ascii?Q?7q5Hwoadz76N7nBnUnPpm1nX3nDkuuHV1TYKewW3dj5j2FlrR7HTG4m66wdN?=
 =?us-ascii?Q?pQM6Pd1K/cjHAxo+Rlq4viA8/DRzSjefn1IYZOp8Lswny73b8KNWEodxvUY8?=
 =?us-ascii?Q?h1NvRzRbAnM29hG1f1EM7OnVFMBzUrlkXu8Dg4f/2FFJj+7SjzVwR9Hyy9dL?=
 =?us-ascii?Q?TWM5TKjQPlinjpOw2D6q0/DYFh1HJJFncCDPHQR/KlykOgWhAad5NOj1tE4h?=
 =?us-ascii?Q?ltwjYLudhmML2ZRpcMSHs17SgZMrINMXwodIbGiALdHnBVsxKyfn09RSpXy7?=
 =?us-ascii?Q?ydHlJPvEUpY0qaFT4EPEeuLqiCancK2SPNnY5Fc/q/XK8fD4E/vHSHQslhbw?=
 =?us-ascii?Q?evJdScCJiYB1cZekDzua8nA9LGW0nrsZAYyToz6/k+KIe1f6sixt48mOZ2EZ?=
 =?us-ascii?Q?tVRYlsClffy9k23WFO0bhVqCLimw9nWXDCB2QzCXgNPBI88hXISjMDPfWn5q?=
 =?us-ascii?Q?VQ9hgv1LVuh3O3L4f/JVedW1Zy0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ba67bf-ef6b-43a5-f778-08d9eca95cb8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:24:00.0295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrb0ueUgNiyMisj69CXvD0uqV2Ps9ZDFIcrumi+8fQbXwU4YVnWa104hwBJnbv74JP6FJDHBkYw3gbc8xdVvyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8299
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

unfortunately there is no maintainer and you were among
the last to send fixes for this driver, so I am going to ask
you for review.

It looks to me like the sanity check in
cdc_ncm_rx_fixup() can be fooled by abusing integer overflows.
You cannot guarantee that the addition of offset and len will
fit into an integer and this gets worse if offset can be
negative.

As this is tricky, do you think this fix is correct?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

CDC-NCM: avoid overflow in sanity checking A broken device may give an
extreme offset like 0xFFF0 and a reasonable length for a fragment. In
the sanity check as formulated now, this will create an integer
overflow, defeating the sanity check. It needs to be rewritten as a
subtraction and the variables should be unsigned. Signed-off-by: Oliver
Neukum <oneukum@suse.com> --- drivers/net/usb/cdc_ncm.c | 6 +++--- 1
file changed, 3 insertions(+), 3 deletions(-) diff --git
a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c index
e303b522efb5..f78fccbc4b93 100644 --- a/drivers/net/usb/cdc_ncm.c +++
b/drivers/net/usb/cdc_ncm.c @@ -1715,10 +1715,10 @@ int
cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in) { struct
sk_buff *skb; struct cdc_ncm_ctx *ctx =3D (struct cdc_ncm_ctx
*)dev->data[0]; - int len; + unsigned int len; int nframes; int x; - int
offset; + unsigned int offset; union { struct usb_cdc_ncm_ndp16 *ndp16;
struct usb_cdc_ncm_ndp32 *ndp32; @@ -1791,7 +1791,7 @@ int
cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in) } /* sanity
checking */ - if (((offset + len) > skb_in->len) || + if ((offset >
skb_in->len - len) || (len > ctx->rx_max) || (len < ETH_HLEN)) {
netif_dbg(dev, rx_err, dev->net, "invalid frame detected (ignored)
offset[%u]=3D%u, length=3D%u, skb=3D%p\n", -- 2.34.1

