Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691E3233485
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgG3OeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:34:01 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:36286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgG3OeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 10:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBpPrWObnonG3urOUkXgavnhFyfMDbtH8Gn8bM21mSJAU9HmCrW+HYbVeGFtVAoC0y/99LrmsSCGDqYnCelywAz2yTwBhyaBS9Js1WiMr0HchIqxLdtVn+1MhQOLJP0UF5ltKgfTw9lvNZdGcEqvgAVAcaz+ctmkeQ/0J4sJBwA9fPgzDCmaD88G2w1M/rxNot2M59VJyXpn6fVeao97Bfl474mh0HXXwyabMfG1A9rsUQOtelBNcHmzXwFogaELgM/ZTZz0eRzLn2WTNR0wPzNw5oWzixGT8j1m3dIXI0wnptqHOdAJGKVH6LZN8KhyISC5dqqBgUiC0OLWWoFoCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RciST/0RvZcCCRsPY1C5hy3iAORqlROeJNhrFXZ/nQ=;
 b=CWfQVu+FBuueu3zSFTb+B7UYBcCtN8SahVarsOa90QEXrxQukIfdOfEnE7+Lnz+VxCot+TQtgjhkWj3VLqIlqE2pov+wp1n7T37fEI4+CvbDNMVb6BoIaX7lpFDuAjOrOr8HVdWAJe+5MnrmLk3d1J1Iz8/7M64ZpJn3MqcXLNv8NjgxEtyCkG6HHJPByGWr1q08G61VWPetqb8urWeQy+D/lJi02sB1w+cXA/DchzbOFsr6WvuwDplCR+nBWJ7PgBHy2hQGubNSnXYpKmERVz/dJaZ+UpV7DqF6Eq9+DGfCYG/KgQS66WZOPw/Bzon24ha1WJueM2nnRzHXGbyHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RciST/0RvZcCCRsPY1C5hy3iAORqlROeJNhrFXZ/nQ=;
 b=hzegkJqHSJatAEeASl/OYCsRlV/+HGDmSXqHxu1KNL35EkNzsEytlmk2L7WEEbI92Q9PS2BUD9X5w4CRxX8Eucmv4TIw3v6FYw2RQGPe5RO30Bst3xGQ+4NqnmN7PlE1N5GKnFNoDzU2pVoEGmdK9aDN99ck/V9GwkEnihKx+tM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4419.eurprd05.prod.outlook.com (2603:10a6:208:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 14:33:56 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::6926:f23d:f184:4a8c%7]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 14:33:56 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next v2 0/2] Expose port attributes
Date:   Thu, 30 Jul 2020 17:33:16 +0300
Message-Id: <20200730143318.1203-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (94.188.199.2) by AM0PR01CA0136.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Thu, 30 Jul 2020 14:33:55 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69d34178-4085-40e3-b67d-08d834959716
X-MS-TrafficTypeDiagnostic: AM0PR05MB4419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB44192FF8962399538AAACF54D5710@AM0PR05MB4419.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: joOtgWDxErSCJVnEFGOrQCrmJsZKqL3R/FnJN3SF65E73lcA/6zbv5VW+t18/CADMELILOCxxwLO5kVijb/fQslHXODaslUhs1ywihraVMqTmNUtYprg8Z7hXYZ0rm47jANRMs6cdBPrs33zmG/qSksuSsjj6pAvPzrJIIgpQIRLXlHV7jMyRUY51qG4r9GiAhfgAdDWibFrPPhpTnSrq6IdfO9AH0bcPQTNEHAgIUARbuiSBzE+56UuTtFtZc6NoonWQeUSme0RI+q1hVebzZV+Pze+0ejEoGASqcMdcBA1caqikVScbTte/o31W9BqFjP2Cg8H1P7uE+Hjl5adew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(2906002)(52116002)(2616005)(5660300002)(1076003)(83380400001)(956004)(16526019)(186003)(4326008)(26005)(6916009)(4744005)(66476007)(66556008)(6506007)(66946007)(107886003)(6486002)(6666004)(478600001)(8936002)(86362001)(8676002)(6512007)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WVvIk85MBh78jS8cs2Ip94joohPzSaLFFGhHoMRLUSVCXkGuMlJflCLgCcjOCgaMhbEJ1Wkn7CfYr9kpys8v57b4OizPlnTXgV8PAdwibcAJJno8rLAFkZDoty8IVNVFJfLI0DJ49NSj+WBkInMPSd51WdvRxe0MkiG7cxTfJBx1CAJtLWhQlQJL2O4qqkxWMbSMabTObHgmkxPrufP87GRP8lkDQCa3N8reSdt/81NFuo48uKidXQlnoEG//+uKSEbo+NsXmlSrmgVRZq7fzp8WPpUlbe4vUgJYaqqQUWo6qEzK4qCyP0H6fO/6hDrQ6/C7U8Oe/EbdIaSzFtquPX6L/T3slnfT5IZsTN+6PIYNm/Cz8ezCHjRo6b/WXe2Ep0Q7MGZhwbVuFp+85mokZYpbZ8wgkm77W0Ba+y2G8O5lnDuTrn6vCzTG+npzlw18yGPOhEcUhuR6I9xGm8gmDctLubNfeHARTJK4GHh/mvXgu5Y7+u0YvdYkhiSAv9rM6hriEqHfQoepPyNySd2vlpZMizKrdTnp32KmsQI7vZ96OEjLE80i/zkAnDiheWZR8lbWJSeVWIaghqY0zL1YspRDFrrLqtd/vQbbGdsGvFJpj4wIBT8U5Fd5XcqOnDdr/792kN+pRI0DlowVZXD1cw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d34178-4085-40e3-b67d-08d834959716
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 14:33:56.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxS/txBAXdoLw8daF3h26yZR4me89koJXSOfnnTi0XEJW8Wtpol1bXp7HqLG5HTx1/LnDU2dOnS11iLEah7JOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4419
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new devlink port attributes:
- Lanes: indicates the number of port lanes.
- Splittable: indicates the port split ability.

Patch 1: Update kernel headers
Patch 2: Expose number of lanes

v2: *Update 'devlink_policy' with the new attributes

Danielle Ratson (2):
  devlink: Expose number of port lanes
  devlink: Expose port split ability

 devlink/devlink.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.20.1

