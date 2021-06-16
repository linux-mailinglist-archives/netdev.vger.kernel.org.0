Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDFF3A96C3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhFPKEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:04:41 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231698AbhFPKEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaKN2JMvwLZTczvlwkHRz9K7GErTO+lDJoj83SnDTBkFLNHR/Cid0zNZx17im7CNo9D4tCZacXj59nfqEf9Nw5dHyAIcmZNvI5sU9pWUexJZxfL2bScIBj1nqU0U7Gsh7oYCQBdf/rk4PzFJKdH1+YsgruF5acD/7oTGMYLMViHvGHlhysNJaw0YjEfaRjDjznFyhnbH5rIT6ztoB5zzsavRV1Enykm75QNpHtlbviotb9ALPJBGw4D41mFp8LLyIQcO9ME0gDkhqsm180h5tpA0fwrVswbg4Ep0NRL4H8BVqHodx8p+u76mpInNsxy4hE2CBj3JU7KxxUdrNig0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooe/cL+Mnne/iULDXeMM+ROg8GrlnMfRBpHevp1M8ME=;
 b=NQ9xbyRl38Jn3vZlEGfeWnpN0b+cOmARiDp0CPCjxneVrME744sN3SscwpPJnWWy2fgrGfnpWGUzGiX+mHgXTGtUfNrE7j+BWlQqSHW4Fgl0LkyrBjJ4TBHJR0fDbFc7H5SxgwVa2XckpnwUWAlGbRlHX8HTV9G4YwWt2jAetYmAGDjNhjJjSk6GLVnr2dKDSmmS39SWfjDx7lvxIHh++Pc1qxgEusaFWwXslk+Qeo1WwG/mvEuqFJEQvabC6R5hHojVVD0EfOkbkzkkG79rgHPbwePyAE355zSkvz4Lh+cponHP21h5BHmAtAg0E5D6sUjcOwmihbW492Kv1yGTWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooe/cL+Mnne/iULDXeMM+ROg8GrlnMfRBpHevp1M8ME=;
 b=hYSFDGUE/fPEpAa0JVqaN/vS5uiFKphT/oSlaxeUdU31Tq9oQTSJzixYchiIPtruNDqnEDOm0P2HG1moRS3hhZusMBMF+msIUdK89w8chjxqSeEGJQ97bMzVjzcP7F792VPdxsDTPQhKTJiPMog2TtaWdsGlDdvpNucR23xPwvY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/9] Next set of conntrack patches for the nfp driver
Date:   Wed, 16 Jun 2021 12:01:58 +0200
Message-Id: <20210616100207.14415-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790d8bdf-204c-41cc-1b44-08d930add761
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB497175857A75FEC61ABE2226E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMw3P4MFfGwhVnWeY95Js8A1n5Plg0qTy3v+scWYIT64Fmi76fAX/5DybKM6lU8BslL/iFNFPEvaqJSmUSAj2q/ap+y3zqzlgCTwlbPJhjCuKUg9P4cM3F3FwHRxheK/klKee+5RzRKdcP14GEm81LKinPBGJOGfXcVq8/UmMjkYhzUoKRgeAHfdoX7TxBEwuEoS37Ff1ccnFIRBazYYIoWUgZW9PF9FoWWKep7mDkVlyXJjcHv/DIQBOo9NHMhslh/US43AqrIa2VGzYMP1xOEhGQ95CTDqSWWX9UB8jky5DCwuSagj0ehaAFrZ1TvCZpfqeDVHxTD8GKrnaXnb//nMgCaLLFbcPBt+EP36RRUsh7n1K3035eZ5jFrYi+/79wfQ6a/6DN+vFaq5p9+msvKYimskpehGDJkQBi7aBqp+HsuXxL1fzuVhY+WX/Iie74kpJHlRXUKShQuyFGol1Uvt/qdRZyJyNDH6rZ0ME1ZfBUUszHRRGTFJEJe0LEUfDI7Rg8KFWnqPuh8ZheoxV5x9VzxSJPUFXlIrhCzz8U8TsuT+pxbr0i1E+Sv6nAfxGRFK3apfrx4c0i0ownaIKgtFkKctunbdp1Fo0RmEn98mRgjNT751BDF/vhO/8HnmrdU9L8VhtvPjNck/4bxRRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tARnvlpNPtTFll6TkCCSJrDXRMDc9+0lI7RACD2AV3hXWh7fZq68D7SIYFMr?=
 =?us-ascii?Q?ytM3FZYCfis7GJwJk2ltuyIT7QVw+VTY8czpnooiLqgxMNfDqR/mx3HVUNAN?=
 =?us-ascii?Q?vqU/rNhF9G/vw3PopA1CemeO7wbrkmQFAimjH2wxmHkFGZu0f3hYlMlq3GeE?=
 =?us-ascii?Q?fgFmkYUJify1+mTWOdxkT6VU5jeopZNsoiUDaZKRjpWcAtuziJv+jPSGRQ/G?=
 =?us-ascii?Q?JhmAYsJ+IJir1CKA1ily8HB4UpIY+xmJJG9xbT3vOGgLdi+9BQOrqKIx+TnK?=
 =?us-ascii?Q?CcIafN5kddLT3eovKwvGue8H/cy9srd9KgDK/AwwBXhc1S8PGtVIczcmHllV?=
 =?us-ascii?Q?hpBjKAC26kNHarMzachdBTW+LtglFixrtiB77mpGbEmZizKAAQhCP6ZmoABD?=
 =?us-ascii?Q?QVq/F/l0JAflQoSxEgfBpFivKPqu6KAN8DHAxNEW5YJW5sX/qXOBARqX+DUw?=
 =?us-ascii?Q?N7zCGPoDjjBLTRbngAle1CzDdLM0W1BZOGpKM4b5nThxUw7ijVuPweqnh8gp?=
 =?us-ascii?Q?VJNlSme1BbqK/SlgQ5eLzqhqDhDcKjhhb8Toy3XRFDKm9OKGtOjPMq8gb+2C?=
 =?us-ascii?Q?14nYdnWUqu3PLmEA1bGeoWLkRyJL7lETnoDFqNli+EdP04cqkgeyfjrM9LC1?=
 =?us-ascii?Q?jEEQ91vY5kYjHlD9D8g27YW5THjdIjWWzZ6X7GZtq/M1cWu/z0GdVJ/29YDj?=
 =?us-ascii?Q?xLDzqZbgsL1HOU6OmnRbhG+0lPVqk3ze6kOklW71/9gAp0r9XkqvIaEcjmbc?=
 =?us-ascii?Q?g9sf8OpoO7yByO3aqPeH828v8MLkMTiC2GTzFHMKJPNaQB1kNK4gwvdcYfyH?=
 =?us-ascii?Q?s/E6ro9FhLSdIC+iBBKJnzH4asrarKUGtsjJZZXAL7UoA0gSx3lU4ldLw7ko?=
 =?us-ascii?Q?knHIwDx0NChemy8BhGI48A166TMqP/da9j5Yi8ezqETxWN3qc1JBqn9MIXFP?=
 =?us-ascii?Q?ewhBiKRbIKgjaCS+y7W96QVuXmVx5ZrqY5KLet9NOZDu31fztkbqTz9txl2s?=
 =?us-ascii?Q?FGdewE/VPf3zcz7THh98hF9AhYq254QoSddqoeqVMhTFAXiSkUixjNgkhAzC?=
 =?us-ascii?Q?gIJBg0G4ddNI1zAThkP5+/+XQ98W8dQM/7bqxbuxI3S70+hnwl2/KOOuo49U?=
 =?us-ascii?Q?D4664k7FeTqQGhQ0SV8h1GRrovNSQW1RPsxtlPIOeKYAzbPgIckOdnr8iVko?=
 =?us-ascii?Q?+AfZLsSWYpKLQ2fpnBNBG+LK2pqp4y7rQDE9ltykeW9HDLpAVp+sHJyE/BdS?=
 =?us-ascii?Q?pRCoGtnbtMVt1cuF+5W8FVB2yzg5Gj106mSaQhTe2cM9XUCyXC9kJNRglShY?=
 =?us-ascii?Q?T/RIIT248Vgur9n1U2Nx19MrcDFDp25HLk+PgJHPSK2of0KZZx79A61zSu+B?=
 =?us-ascii?Q?hZUZoMNx8vybOluHOITblDajPYg3?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790d8bdf-204c-41cc-1b44-08d930add761
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:25.2597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TIKFCZjNfNI2Kts1XkeLbHDVq2XSomEksNW+0OHx+Lg9Ihljv058nqR8SgqciPjYITnoLJYPbv5wRAUbmBIt1W5Y2M440RTFdM5mlTWEoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

This follows on from the previous series of a similar nature.
Looking at the diagram as explained in the previous series
this implements changes up to the point where the merged
nft entries are saved. There are still bits of stubbed
out code where offloading of the flows will be implemented.

	+-------------+                      +----------+
	| pre_ct flow +--------+             | nft flow |
	+-------------+        v             +------+---+
	                  +----------+              |
	                  | tc_merge +--------+     |
	                  +----------+        v     v
	+--------------+       ^           +-------------+
	| post_ct flow +-------+       +---+nft_tc merge |
	+--------------+               |   +-------------+
	                               |
	                               |
	                               |
	                               v
	                        Offload to nfp


Louis Peens (8):
  nfp: flower-ct: add delete flow handling for ct
  nfp: flower-ct: add nft callback stubs
  nfp: flower-ct: add nft flows to nft list
  nfp: flower-ct: add nft_merge table
  nfp: flower-ct: implement code to save merge of tc and nft flows
  nfp: flower-ct: fill in ct merge check function
  nfp: flower-ct: fill ct metadata check function
  nfp: flower-ct: implement action_merge check

Yinjun Zhang (1):
  nfp: flower-ct: make a full copy of the rule when it is a NFT flow

 .../ethernet/netronome/nfp/flower/conntrack.c | 726 +++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |  76 ++
 .../ethernet/netronome/nfp/flower/metadata.c  |  28 +
 .../ethernet/netronome/nfp/flower/offload.c   |   9 +
 4 files changed, 819 insertions(+), 20 deletions(-)

-- 
2.20.1

