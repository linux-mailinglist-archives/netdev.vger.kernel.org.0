Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF44291063
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411517AbgJQHMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:48 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410562AbgJQHMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+P/HRN11TxY6C2FfWOFG0FzdofTp2FXWqmr3r/vYkjBKEazi9HHyMdcCDHM0SqPIeOhRzDr3faencFMuwEtUmr/VqfO68Ct4FZyGY0uVN5TQC1fYMhPEZ3oIu+HxPXW8O84ziMa4qE45Dplf3YRSBJ0fcu9QQ+kPT1Ps3yfafO2jFH+YgRJq8j6IZT+SxlVRKccUMO0LKxxkVV9HS1271brXnMg0jXS5KX/d4slthZrWjpA0qKmmz/qawYDoTBrIitjiOJwpaGFbdjqANX2ebSgMkQbyoEtX8m6w6dOZpRlaxmlh5RTwX+Z2E4M4v3D0znQA9719wK4uo8Djifi0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cvAU3m0xpEsheXyH8GRGZW+of1AVUCHgCJmqAtz2nc=;
 b=NR16ivGVPMNbuRnF08LEuNSLLaqfobrgZ9ZuMQHVfFzec3TDHhSq2mejlJPxPbHnyT6kJav8Osvp0LvwXFLYt5k/UxHdLMAe/b4RIw4Oe1LF8Ejqtf7B8SfP+2OmpFmr3u64Tp1L3EEv8knusdQfIL3EwrRbH8WNTE3i/ORGF2DAkSH5UapPe/txieD8UOTTqJ3+jmyNokYAamaiGcnwSLJwm18l3FWU+aDaWGUOwC2hIzlNkfIdk4SlBEVy8JSEoZGDB5p/wlJYkF110j/jbhtDS3ud2d8X2JLD7P+fyxQPZ0E4NRhFq/B8wASC7cguPZAOTXSOfIZd2O4B2Xxdig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cvAU3m0xpEsheXyH8GRGZW+of1AVUCHgCJmqAtz2nc=;
 b=eeIxTCYuTP3fWVNoZDivqYo8RJtmGgrV2PceB4IIu+9t8roXq4UXrdJGdGgAoHNGuKhzmjBVEpHKksFX6yZKT5BSSOOcdpszyr0HSHJNXMRarIybZqXttrYp0WuuNyw6an0GlICj5O83a/dAeCA+FNs/PapwW1CqhLmJMwx44Ms=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:41 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:41 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 0/6] igb: xdp patches followup
Date:   Sat, 17 Oct 2020 09:12:32 +0200
Message-Id: <20201017071238.95190-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM3PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:207:1::13) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dbdcee9-4a74-4cc5-d30a-08d8726c0979
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4018C25E538DDD1E5BE3A55CEF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPO2/+TDZR4ReaoO2YpcOUq0t8uYDOcxGbGNWOgn0FNKvg3YUClKaKoeS00lEEJ0OIF5XjAY8FMCerVlS0/oFs56zMcsPEJoPV4vulIRyPphvdQuWRQc+YOrMpxfQlO+s1aKvD9w3UNxK4rBHYRqLNmZgL1h+uayuGy2tWePTKdJtvbUmFb6aItvNQbXT2EMQC64HBo4thnTD6aMYvSIRW/amPnO/QoS+rRjrCHA6wWPMJP8Snn6jkMZ9GFjrg2FdniwOvdhmzTWzidBpQcKWjs3aKzAZUfI8bNLBmVskJPc9T7ZyQb3fyMlMFL8YqYQcOUccbiDDxuHZi3Cx+I2FMEgrkxoTgAwol+jFsm3Ub4sh+mblqT8hZgFLNjRhu3T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(83380400001)(4744005)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tpQGRMo7Xrl4yPshL6To66Gz4Hu447OQgnNVRQHP7gmoEFWbYm1GuYfEOXGD8PqJad8kcS08dnR6s4iKmvX/gg7aUVATFW7D/HHto73JXsRJfWacmzP0OIpsHfLWeamHQvvfBGMBoKLOTLEZNLWy7nv+ajPJIrsGpc5+UIWVgD2msocGVSGmTurCBoIu4Bj+LU8UfY0z0AunsUfcF1xwNC0HZWUA0kWJT8Hndbrsj0Wkgr7i3X3KiKFFl5kItQrxT22QQGDDBOTa5zCR5b8X/PbhX3i6KmfOC5zCfQMlebSMAmk+HOPdqwAkcvPnWbHjaXlpCrNVSnFFrUeaGnR1xRTaqMuLoph/jriVy7hD+NTH49oWdzlU9RD0vRDDa3V/RDChRkgoR8eyhlFM9+5TDbc3ZlAmiGFjxueU1kg/Qy1ETQ/edxFM+n2QHjN8IopZS5ThsIYdFFnxF5rs0kvQc/nG0oY4PTEM6xl9x+lorEhAbu0ZDl1cMQZ60by1wFmtyIUghscwXZAQTYRQZ1sdorr8yZS6w0l0DkBCZ3qZhb0sevT/3K6p/OLMvCOH9Tu0YboiY3ZVXYzSmaFHLARzb+dbWuUiL63kx1KRTqcZ7hjsGjhe3JUnkfKoenT9fwRk+V21Xk4Y0Yv7DqIfnXm7vg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbdcee9-4a74-4cc5-d30a-08d8726c0979
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:41.5989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lz/eUUvgmaGeTNegyxUrfEKk5+XBUAYr/TSPBsRfEVwMaQjUYlAsHkuO3M0qw0on+ROka9SlX7u+cWDrUxfAc5DlFuN+Q/a3r2LXVdeOFyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

This patch series addresses some of the comments that came back
after the igb XDP patch was accepted.
Most of it is code cleanup.
The last patch contains a fix for a tx queue timeout
that can occur when using xdp.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

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

