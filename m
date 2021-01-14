Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797FE2F5E20
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbhANJzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:55:47 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:49504 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbhANJzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610618073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RuPJbH1sZwzeQewHzyao0Amsy6ly2VgaaIfW4h2+Y60=;
        b=CPknqe6iEz+fIFw/qzIAQzXpt1MYKM1IjisBOsOsR3Dz92BJO8EHK5vcSxlLtd7Xx+tywz
        9L1m2mPB6FpYnOCrIugOWN5KsxziqtRZ6CukqWLVvo7iDbqfsCO8/EZwUH0pTD90gKiynP
        BoHbJN4WWH0eq5gDnxttmmzGGcYZEi4=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2051.outbound.protection.outlook.com [104.47.9.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-171LxoBbNiCUipOVIH_uTQ-1; Thu, 14 Jan 2021 10:54:31 +0100
X-MC-Unique: 171LxoBbNiCUipOVIH_uTQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKpPmwvaz5WsTReNlbhaOwIdPtmTDX+hHvsWbgwDMM52y3gf+Ud+EzPkTDDFnRp27X1VqYpkZFeyPaqW0Lx/pP2ijQ/uOdncY8AvH2Ar0HHEnnKXep1z70EGA3ybMIiQGWuJ//iJkCBxX+jrd83Aax0Es1IXFboW6RtGdUNn3kaMK7BjTm2c6wTgDoPLnYBdnubBdQDfzle3SZtGIyA9rsJO0PKdbXOXB7UuUXkU4gZMz8S9tsngPtrzbwvC34EicoKsqu22FXPhAdo44ELO3wo4ms9gWU6uEPBl2J67jCiXCslwkK7AnPaLJKJoUYN/c0CtH0I3RFZ+kJIO5ufIiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh4xHFFakCx+dtShLesr0lX3WCDWSfkdgawanIHvwlI=;
 b=cwLQUdxaryxwOyIAle+JHJP9Y7ORbTmv8q2YPJi6ev01vFeW3M2nbTbP89YZA0xBcBT9Tpd3L+yFCZhiHeVAAg19xZ3YxT6UkGxl6TzatJv9QSHw93D8hCIsiaIDEEYtNHEePvELR5LBjp8VtauxOS0vv9CUVlnogOeItfk03SARPEXYGU1XmKE3+TlCJZ9REGrSeeqYYQaM8zi02ACF1XnkB/a+oEvOIItBqozKQG0nMcpCwuxxCV2nqZZ65cxQjRXlNbOCOdCxXu3XyDUfk0tud2/6vhqr6D6VcgnVuMq6SC1loxoRBRDflxZgT56sGhPJzsl2d909ZOiHuIAEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB6153.eurprd04.prod.outlook.com (2603:10a6:10:d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 09:54:30 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 09:54:30 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v3 0/3] bpf,x64: implement jump padding in jit
Date:   Thu, 14 Jan 2021 17:54:08 +0800
Message-ID: <20210114095411.20903-1-glin@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.145.171]
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.145.171) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 09:54:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05ba7326-f51a-4ab8-8274-08d8b872633d
X-MS-TrafficTypeDiagnostic: DBBPR04MB6153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB615335B962ACC671AD3FBF39A9A80@DBBPR04MB6153.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMCrJJTl8MZvteiiMibphTWjWO6VK+EGY4fg593BL0dMJuIT3wti05j665lmdwoCbKFEzD2gsXMKv8qqtGUmo4GsEjlephJUDMVBHBQwkxDgB4+cpOPK9oXa2YWA3J7OlhEyxXZ/F+kamid2jh828OEydyWbU9nqIJL2ZZymLkZM1KPS1Je/DU68nafaPOrD6LZfi9YbX4WMDf+WSlZktcdsH0lygApX4S4jYwS06g1QpXg0Ji3s/dQ+Ucr0doZxQE9ulZtVTpNAAcgbvsmiBEyrIHbqdvS1wX+JoS53GI0X9l14bWthrOpNy9OaEERKAggGfH1YS13jpXOuIOq55ITUMNVtHHVGo8v5NE1utPVuzJB313UfDRs3/Ae/eWf8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(316002)(83380400001)(1076003)(6486002)(2906002)(478600001)(52116002)(8676002)(5660300002)(186003)(110136005)(4326008)(107886003)(36756003)(6666004)(8936002)(16526019)(6506007)(66946007)(6512007)(956004)(26005)(2616005)(66476007)(54906003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bby21dtMAz/eTW0K4L1rvvqO6osLXWEG/T4ujhDj5rUmqKh/2hQrU9KR8eUL?=
 =?us-ascii?Q?pY6c7Gu5bsXuja3WE/kSadapLmqGb+yc7H1hcH6l3IqJa5HtjdxsN2MGDK/w?=
 =?us-ascii?Q?v9p0/7LOQ7448/2md6VvEmnB9qFO/0SO58xA7/FVVAGObdg3D0XwOXq0GcJH?=
 =?us-ascii?Q?T0fjiLaDa/7eP16RgYUgXV48BxsmpDtwdEtAOUWMmLreuPODlZKJNeSk7K/E?=
 =?us-ascii?Q?qo48GAmj10H/soHwfldgfd+bQBkfi/Z5EimHH+TD8CuT5lyezcsT9p4Y4CgT?=
 =?us-ascii?Q?L5dXB6J5qrxvkOeQNDYaQwWlVs9/hFS3WurtcXzmRJpUHTk4SoiiS6yW/H5k?=
 =?us-ascii?Q?PL1QpNdeCiNGmOVk5NRu+XIvqu2GqYe/zBwgiOOqpg7wbi7V3pEnaCX0FkfQ?=
 =?us-ascii?Q?9BEzCRih/qjYf8PvbP3pO1aGNSKo+FeBexop+EWsB6JMzjGiFTvFoJlnCdGr?=
 =?us-ascii?Q?VYaI2uQSCiNf5gsPKrskd5e0I0tXrJgsHAay9FEWpJYqiwAfO3BHWvBbf8gC?=
 =?us-ascii?Q?6Y76TBtqPJBkbE+joAO7/+7gjvVjllv8z2LEyu8UPUI5saj4JK8sa9fucyWg?=
 =?us-ascii?Q?hr7YsgEvUA9DGBpbRRTYNXc5bZP1UYAK7FAWrG03H/AYH65Inb47+Qr02C1m?=
 =?us-ascii?Q?kz9L8GdIp+DrbxQs90//jInVeEoHxNu2HtYl5dszbT9pzscYpM+ISg9/pyOl?=
 =?us-ascii?Q?u7ExONgADjDM5Q3iAN9mMUOeiy0kh5zSc48bMK3/8HZvby86IlzfYQ4jXOSa?=
 =?us-ascii?Q?BONONtkciGBVPSWOzownDeBmdsr2Y19Y978ATV0FtnMtURn6EeugYof+fqd6?=
 =?us-ascii?Q?J9HkeA/K6uFa7vmfKDPpn2Ks5EYBJXwlczBk5Tzggvhs20aDLOaLGn1qwwxX?=
 =?us-ascii?Q?mSKh9R/YiTEYeVlKBk5NNQsehjZ1BFYm0dEFsXrx80C+GbzlzDJ9YBx2a6CC?=
 =?us-ascii?Q?oO6zx25jDX6Xwna5klhXHx+pOH6SgJ7P25+z5JgUSCXalSjbIxxLtQzEeLwU?=
 =?us-ascii?Q?oB/s?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:54:30.1784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ba7326-f51a-4ab8-8274-08d8b872633d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHWwbdYsiSoeimqdy+g69sMVAe919kUjMQCDEaevMtpSVBbJ/xN/XPmdZs3KX504
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements jump padding to x64 jit to cover some
corner cases that used to consume more than 20 jit passes and caused
failure.

v3:
  - Copy the instructions of prologue separately or the size calculation
    of the first BPF instruction would include the prologue.
  - Replace WARN_ONCE() with pr_err() and EFAULT
  - Use MAX_PASSES in the for loop condition check
  - Remove the "padded" flag from x64_jit_data. For the extra pass of
    subprogs, padding is always enabled since it won't hurt the images
    that converge without padding.
v2:
  - Simplify the sample code in the commit description and provide the
    jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'
  - Remove the EXPECTED_FAIL flag from bpf_fill_maxinsns11() in test_bpf
  - Add 2 verifier tests

Gary Lin (3):
  bpf,x64: pad NOPs to make images converge more easily
  test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
  selftests/bpf: Add verifier test for x64 jit jump padding

 arch/x86/net/bpf_jit_comp.c                 | 86 +++++++++++++++------
 lib/test_bpf.c                              |  7 +-
 tools/testing/selftests/bpf/test_verifier.c | 43 +++++++++++
 tools/testing/selftests/bpf/verifier/jit.c  | 16 ++++
 4 files changed, 122 insertions(+), 30 deletions(-)

--=20
2.29.2



Gary Lin (3):
  bpf,x64: pad NOPs to make images converge more easily
  test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
  selftests/bpf: Add verifier test for x64 jit jump padding

 arch/x86/net/bpf_jit_comp.c                 | 103 ++++++++++++++------
 lib/test_bpf.c                              |   7 +-
 tools/testing/selftests/bpf/test_verifier.c |  43 ++++++++
 tools/testing/selftests/bpf/verifier/jit.c  |  16 +++
 4 files changed, 135 insertions(+), 34 deletions(-)

--=20
2.29.2

