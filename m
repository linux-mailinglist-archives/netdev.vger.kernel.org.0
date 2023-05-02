Return-Path: <netdev+bounces-7-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9FF6F4AD2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45455280CEF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FAB944E;
	Tue,  2 May 2023 20:03:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361538F6E
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:03:14 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D21C19A7;
	Tue,  2 May 2023 13:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzrsngPge7h5bTKmQac5rD3vpweqZv9sTze30sHEwt93uAxN2xUF0BuGaSiVg6D+xgyfsZMnmhWgFjIKaxs/g8vEfpYZqJRlDNpX7eQghQhv8awJ2CROvjvwmAICXO06Kfi0J9OznF+DDoVxvcbyuaba1jYOXy+VH+OPh6N1u1ZvkXQyV0Ba8HZC89forJlhaPxTotF7pSpk+IeSJhyvXbHXKi2uZTlwFM7kbjZCHXcBSK9uzDEDsz80HSy8Pi70x1GPmC2xUUXkDRhX9RURY+X4ZCmFxVpHICXvqObfkeGrEad2ltbh0oWwNwwkwFnh7jjeQ6I6mV2kRTkm75sinQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CvscxX+jDTa0V9nCt8Coy8cDMWoGUBEZfMXmWvKA84=;
 b=WNdPZ6VrEyIBpui+Gti+i3M0sxtbgJdmRC0/N3WYcWvdqbf/eQ7bLqmGNZjEMJ9m/9ILKlKB7Wlnb56GcQgnu+f/ZfulNz9rvkMn988zdfc06cKayHZ0q6jd3QRtSyllUa1fnehZyrnWUrAMOHBCDwZwGatRFpAtLQi0+1xm0HjugUtq4j5l+JXuUx5ThAUADv/2hbcy111i7QuLIc0+1DpfLMon7yMDTkcIFfl0bJAr6vtz0Qu+eihURE0ZwG0dQAKTdBWUqe4P/GrQBPB0Byq3qAyOpkBtZ68lzMJO0XylO/1/3WpKvDE8WaFRG11c2wsI5lDm6dJg30jx4PsVcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CvscxX+jDTa0V9nCt8Coy8cDMWoGUBEZfMXmWvKA84=;
 b=G0ak94f52YoR7g5ZwCN856kucw2+KUzDha1zGLmWUjeQqHiXkQDQCScp2w6zET3doNt5G82CFEdmWYz//fiDl7gdfd8HDhbw7UVtD6AAWMdRUEB2SCagNsycpjHGiiy7ALcqsR4uPmh/eoZU1TGSgoQxR6bcJtO19D8ve9Z6EBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5114.namprd13.prod.outlook.com (2603:10b6:610:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 20:03:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 20:03:08 +0000
Date: Tue, 2 May 2023 22:02:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
	kvm@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <ZFFsb2gvDMiLSY2F@corigine.com>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
X-ClientProxiedBy: AS4PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: e1683daa-b310-40b9-98df-08db4b483fd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V3tvTbyNB8cv098kaC00vEjrd6ETxPxVor/hAj/ozVs0sNJY9Krl6bCjKSD+nim0wumGPJmkyl1rxCpTFMEwCamT6Sf8HYoeXueRqkr2nbqV2Bm1M1UE5Ca+0B8RziDVk+EtIqD5Wm0u9xKCv7vyHEfD/2baAIxyPosNGpUPbgQl1x7WJkWkg7Mt9yjnQhkegohzvzcH/dFYh91jH0KjxPy+iWFlBI/i+GmXBHlcDexaAVUE7Ke24rhh0qeNpEXy1ixJ38BLjDQ/kbKXNhtF8jE2FJux8rJ5ZrH60Ll022kVJmOQYniFEj/tbnhFE4bOtUITuzJRyCjYcpYWJZ27pdkQqZhPEUn5HTCaRAPWClA2FzzO+1nEA7sw3SE85OPRItVgohA99FYmIsBElVElGqY6jY7U4wYgW+U/7XcJdHtEXfQa8dTSasLz8IDFK1SDy/0hpyiLlnauht5UJB/rISrFt656lSBDFSuu4lHACQDyCUhYw0HMhJRNvI05fGCqzUcEC0yVU9/9fqbPvIjaAmFLOCcmFvNn4GWBCwIh3mgq+pE+2ffJfCmPXi0JvouL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199021)(86362001)(44832011)(5660300002)(38100700002)(8676002)(8936002)(41300700001)(66946007)(66556008)(6916009)(66476007)(4326008)(316002)(2906002)(4744005)(6666004)(6486002)(36756003)(2616005)(186003)(6506007)(6512007)(83380400001)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tTJQmf4J82yrVt11akCkPF6hK6dgwAGhE7zSTsX9LGwMg53jId+zsHO2FEXv?=
 =?us-ascii?Q?BgVaIKo2ZPztPaUb5M4Lm77YTSTwUKXpS7lijgUW+GZ4oTKYPpHIcTBKafOf?=
 =?us-ascii?Q?J4OwzOIz/ayHwjkfyh6GutXxR+6dfrJqGFpk5mb/mw2FjPEG7IZygWnqy3EJ?=
 =?us-ascii?Q?wDjA12uszZeaYCZkKTf7KHctvPHWInFBCQ1toNMGhPICQ/qQEvS2VS2eUC9Z?=
 =?us-ascii?Q?zER27N28bmyfVijGJljqH23781zZDyrnnvDyVWFypJvq4akX7kNKg3AyTpR2?=
 =?us-ascii?Q?FkvEKJohSciMcSDZc5YySg5AmS/jEbXBYYZ1PATcMM4NnWRBPZHx/J4NY88D?=
 =?us-ascii?Q?nwd4bZLn5pQ3VYke4BldY5u0g74PxFjc368QBUffNxMznynIgclTTpLXR6mi?=
 =?us-ascii?Q?U2LqfwAZEjiBZZS/O4aR1OWYVhgirclPi2sClAotmgMxZtYBAvQcgEvw0UUD?=
 =?us-ascii?Q?KoUOMvJlhfMFUOtkn+TpD/vOVlt4wSOH2ROOBg85c8uLjkadRKnUc434lY+t?=
 =?us-ascii?Q?ynOt7xtMDrZvA13YquxTYKfv5RZpgI27A/buqS8BCRkUrC7pRTsO9j/V6Adq?=
 =?us-ascii?Q?O206uXDZt8WBavGTu8dmURU/B7D8BBWGCBmXQvviaBOKOdI22RChlJiAkIRW?=
 =?us-ascii?Q?SC33EDaz1KKjLNtoYbYRfTSjK4KNLiNoACkc7PvTgdQEpN8RS9dI31rLVmDx?=
 =?us-ascii?Q?SJ7VprJcMEei+Zu1UmmJAVmyoI4tUiRn6AW27CYM3sZhvW0UoUqajKzjlH56?=
 =?us-ascii?Q?VodFPoy8T+6ov30lJOKxRMQWuWeJ56G50B65bVF5yAGBnfUg0umO2gPef83j?=
 =?us-ascii?Q?OrDN248qJqTkscFF1ZSlr+o6rofxqww9DtLevOsRhn/W6a1mEMJafjSuQCXo?=
 =?us-ascii?Q?sexaP9AiP79E36PZeTGMhjue0GjPZNVmiQFNKd2f0jVOJccrOQ/6pyod94hc?=
 =?us-ascii?Q?fA1KsY+fKEvqOSir9B+Cp2Ugpo0DlhdfWxsEkjRPoumQg+niqNCDqbjRzQsU?=
 =?us-ascii?Q?eLFjmHL5hTYiQf4uZFondWeS86AaxLgSgCDgwkt8CtLZauxSYdxaRpXsxEls?=
 =?us-ascii?Q?XAAVl74D55yH+9xDcS1vvRqE5BPjxShPUxJYOM1+SXyEDRuFSP2nX7rC2zl+?=
 =?us-ascii?Q?gikpDbZmjG/kFs+n1gpw4YNk2PMO4BU+l8GkwHikdoc+Lm19MNnpud0mTeCv?=
 =?us-ascii?Q?hRHQmHdE5lKCZ+Vn3pDSU/FKnrt+hKMg0rGvzSbJHE6IVWq3PVXeWHSUmkIw?=
 =?us-ascii?Q?ZYcyC1pYwyI8Q4O/Jeh1Oeqk4JxSr192qvEbwlbHeTQGlw4SpS1lcYUsLISZ?=
 =?us-ascii?Q?m/UwmDvihlKULvvW4sNsdYLqYeVSYEMGS6+b1j3DmUR0POdXst9IbLilsDO4?=
 =?us-ascii?Q?LEH1hM2SuGtc/IQ1ZX/R0q+yhS74D0/GqzKSxUwMpZ0tUe881u5fKH3pIHgS?=
 =?us-ascii?Q?n0dEpv4lUv6cOJxQ19EI1AaG/iGqzI8hsN3+jjuZ6mCUjxQsXHaobpbrOGaC?=
 =?us-ascii?Q?r4k0Z1M4zScVHyRlq0k6mPiOHwbCNDiS7cnKQb2R/i4sw71U1xhD6cOS+Ei9?=
 =?us-ascii?Q?0NCDIZgonr7HTs2MsBObI+2MOiTL7pje+qOtdPvbaIkR1MOkrU9a+RJJYmfk?=
 =?us-ascii?Q?+aeKFFKNMvjhv4bOu/KxQ7csaHz9owKHXIZAVcjJw3ClaIo4BnQePu79/BLO?=
 =?us-ascii?Q?2c0GtQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1683daa-b310-40b9-98df-08db4b483fd2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:03:08.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mlwm7YO+oYSXWxhIG5U6/9FQSXGsR4mzurCtW5QCXgqeS8p7a+IU/y1oW+NPhNXzCqhQdxhulQSyGR9XojWhS/Ekrj3SpiP3ZJess8KQXyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When virtqueue_add_sgs() fails, the skb is put back to send queue,
> we should not deliver the copy to tap device in this case. So we
> need to move virtio_transport_deliver_tap_pkt() down after all
> possible failures.
> 
> Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


