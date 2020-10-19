Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D196629235B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgJSIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:06:02 -0400
Received: from mail-am6eur05on2126.outbound.protection.outlook.com ([40.107.22.126]:47094
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727349AbgJSIGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 04:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6JABtT3gIFtA9pUltwsHqg+CTYKUytU10XuOoe/EN63rtcPeRdht5QvTeAL/eLbkO02y4C5rd224iDoT6XWKX3jVyukVCaDmsxOeI29N97obpfd/TqQFDIsptrPnLUe3hr/7KqHicevP+gmLi0E0k67UmSe4sUmMZntpjEwFRqTp5d4oQamtcsCTE7ux4tGWHsxhu21L3xqB3NfNA5H54kBPVCT8HaKSOLzHfVs9gfnE6b0C4wMOJBcV8pSB4zJ4zsCpqhwvFMmF9pk4GIcHWmfGyqTHy7kzsvURYAFFTPwXq3VnE8I0E9Bwe3OFOTd+sMun5+WdLCWRiSWOU94Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNdGwiWHvHfzR9xh1wyNJqbh6NihvhQuTA/LsJWMyns=;
 b=frhYydZQw7x87pn7vQRh6A384+slpk+ws8NjQGK+/uzVi3Xt6MrVEMDgq3k1A5958xpAX66Z6ogE/OryAm1o1I+3p3wuuEGjMEYrQEOVycDSegMqYkvK+90euBsauSOMHYD+NmuJNHaqdRkkqS0m4gbwzd8hY/NrdvhGCEcZ0tNPi9TzG3GBHkEMP3HEOddeaOA646z6Nlp0MXB36sZsSMWjcfBrYuVUxS5RjWKBnxHSepuNZ3k4YklvcuLVKpDQIUKeh+mz7mLkZ++Jy/lAlyo7wrIlFNyzRp5ucXaXIP213J4HY4I8VLMP3jha8836yBP7xcww+qfHITXKPsRClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNdGwiWHvHfzR9xh1wyNJqbh6NihvhQuTA/LsJWMyns=;
 b=cx2a7pTt7p2ET1O5WPMiIIbnBV3zxMLF+2Qol5IJwYi/2VlXiXZApVcs1dmlRuDnSUuXd+7SSKoYmNwifOlEVFaz0ARGIwA01m0m1tnXU5ezakhozkQYpxU5cIx589/kkFC4FW7GFn/50MmtG0W1dphJb0cDXqwDeE+xz8vHMbk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4403.eurprd05.prod.outlook.com (2603:10a6:208:65::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 08:05:57 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 08:05:57 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH net v3 0/6] igb: xdp patches followup
Date:   Mon, 19 Oct 2020 10:05:47 +0200
Message-Id: <20201019080553.24353-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::43) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM0PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:208:ab::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 08:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7792e880-abd1-443d-68a3-08d87405cf06
X-MS-TrafficTypeDiagnostic: AM0PR05MB4403:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4403AFCF8ED8292121953EE1EF1E0@AM0PR05MB4403.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 38EPdiluRjKaN7tTvYHeQYJ6wSn/AfPAYfzh7cP5bER+VstDM4JwUmMbZvkozT/vTW8TrQQDuSafkYsoh6/GYAd1kKpnkp1ZbQ1ibwrGY2Zg0PVmP9x6sKwT4ym5SObf4pwiSsT/bRWjJpggua8UY3UUQqIAK0Psj0T2qWRW6qx9e8ynVwk3KVVYnGHT5qEaSCNNSXrI0gI/ZAsoLwl6sbxFpitlL5g56UJlYQx4YSXVtsc8hV3nJlYPfzZWVJiMd7gaX1XDpxQYEAwSodo6F9hHY8u2m2eMQ65Sn0t4Tsgvj5GY35vAd/F8IkNTSFqJY0EyuenJoNHzroeV5jHqyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39830400003)(366004)(396003)(346002)(36756003)(4326008)(186003)(86362001)(66476007)(66556008)(16526019)(8936002)(66946007)(2906002)(83380400001)(6512007)(8676002)(9686003)(2616005)(956004)(316002)(52116002)(5660300002)(6486002)(26005)(6506007)(478600001)(7416002)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bf7ebLsKKboPaXXDeBWjLMI1yE8ZurT+ecgHSMc1clEJIs5ybGYRCNSelN0/ZqppGwe+B36WGMr+7FNAmnDfkbkyFWDJ9/DrXqkhzymtpq6GIsNXu4EDzbA/Qg9KVaIhPXNMmzdtivHG/AkjhIE+LPZDpJRUS3ytJIYVNtB3iKnv+aF/dvlGKxMSD7JQoaehNIJaFwX5AzutfwIzjMQCHrEQSiv/7Rdp7DS1+8PKx9hcBf6UhrJORoAJOIHjtRuAOgG6CKptYiH+woS6hyUAIR0fMXdURxkIASfXCircDy8hG3bq0sKANP3SAsep91MSoxUcufA08a8kHmHT40ayEBmjKv7qgKa3bSd/AYvtddKZQL8RjMLDQumWdgUBN3/5QlVv3r+FtQuDAgOt6JEtM2Za1VE93o+AegaNRwpa8FzrZBjzW9ziie8zhTDCS1+6KNKBY8dJ3hKwg4mQYZ6Lcfq5JEwzvMBabHgQl0XvnatPt5X6GkWSExSDpUkQwg59qwHKhwF9i7LK4N6MlbYAf+P8l1y4ELagLBpiVBfyD4ZcLz7BCBKNJ4TU5I3PXGShEpcAUHWfLphfEBiMthi0wi89sGLLro3SE1WIlwp3G/3M9eZjZSXkRqtzc9QG/7N5GOC7IjbuR0kA+bFA5phAaQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7792e880-abd1-443d-68a3-08d87405cf06
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 08:05:57.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/dhqq522761p99fbAhpNlpuJcgkUV3C9P6dWABKgXLiGqOWBbLEDKkqUYf0ycjDF0nSF+czOMIbB3txiM2rJzx0MOs/5oJ0BBhgTvl2WiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

This patch series addresses some of the comments that came back
after the igb XDP patch was accepted.
Most of it is code cleanup.
The last patch contains a fix for a tx queue timeout
that can occur when using xdp.

Change from v2:
    * Move SOB line to end
    * Remove SOB from cover letter
    * Add a better commit message for
      avoid transmit queue timeout in xdp path
    * Add ACK by from Maciej Fijalkowski

Change from v1:
    * Drop patch 5 as the igb_rx_frame_truesize won't match
    * Fix typo in comment
    * Add Suggested-by and Reviewed-by tags
    * Add how to avoid transmit queue timeout in xdp path
      is fixed in the commit message

Sven Auhagen (6):
  igb: XDP xmit back fix error code
  igb: take vlan double header into account
  igb: XDP extack message on error
  igb: skb add metasize for xdp
  igb: use xdp_do_flush
  igb: avoid transmit queue timeout in xdp path

 drivers/net/ethernet/intel/igb/igb.h      |  5 ++++
 drivers/net/ethernet/intel/igb/igb_main.c | 32 +++++++++++++++--------
 2 files changed, 26 insertions(+), 11 deletions(-)

-- 
2.20.1

