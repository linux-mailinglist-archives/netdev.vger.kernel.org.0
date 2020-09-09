Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0262262675
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgIIEvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:12 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:57634
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgIIEvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVZOEuWEU7DsmCqHbZvjlKdLDVtZm+QzeooetG48Xtv6N0zrmYsOsqSAIB/fR90RCivqRCYSc2DYEQl1jRyxe7No6GKuwyCsAbQePuuwn1DqNNHf7VieoL2Mh+CHGCLPm6Tfzh83em/Af/p3TdkNTmRmDE4c4yPb3a6RNu9vp+xR7NW+mapiN31evswqGHCo1BoJ5sOBvc/e1iqJv3i+481y4NKPsyvBrVayudts/trylZrVGT+YJ9GXQhletm1SMGHB1LvjcOmG11Jxpi8BgSiMzexcqB72CM8ZRKy9lc8Bhwi0StjQ/mTFs9I4zValsGHu8C1mJr4tY2Q/pCqi0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NXluFTZQlnPUWWbnn2fE/nKocfr4qDfHXsX+o1gO1Q=;
 b=WsCGd8MIg9eTD5M5JEDhLSbNbppAgYUXbuT3/0yiLsTNHp1UIYjXHexZCajJrLD/1RmShQ6OrMa8kdNRWovv8m3wk7O4o81Tv78sDKOqtyGmYpwVqL+VImYBaAEGPx0PGbAYl38MFspx5udLJdyRU+nkUJFizs8Y7tm22/J6nVet31YiC5hkR5QOKpL70YzuETDWnVdRjT/Bz3iXl1boulDdqduJajqdxn3ikmi9ad7DW0USZQDjueAORP6FHAKRH1ahXp3a4vwIA8E05p6j/E4jMUToJrl+8kkHah/y23NyM2exUjGea+iqAdxwjOJtHUDpEpIgM6zhtbrv28xpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NXluFTZQlnPUWWbnn2fE/nKocfr4qDfHXsX+o1gO1Q=;
 b=Z503NFpZQBkRK34xfykR1QZTkylsJ0U5y+cYcuLtsXU8aw6rMr7Vmia2C8BtrsCRN9crBkaOUfJJpkOHZx454PZc5qIEgLNmzlRtVvaRsnu5db++CW//0aTJ7mCcdvwNbASqB90CBwymrZQGTrLH5YZS0Hrx5q2DhgLzwU95Cww=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3650.eurprd05.prod.outlook.com (2603:10a6:208:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 04:51:05 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:04 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v3 0/6] devlink show controller number
Date:   Wed,  9 Sep 2020 07:50:32 +0300
Message-Id: <20200909045038.63181-1-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825135839.106796-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2aa6ce68-c969-439f-7db7-08d8547bf522
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3650:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR0502MB365049A3096B4F42FC826F8AD1260@AM0PR0502MB3650.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGOJCLd2iWWTUXmWAOtJee1ALLTscByPKVgPhTEe5QLHn8qglIx1wm0menEsoOwJ/ltekdWFlSQjYyAL76kK/uGGFbWZvxB7Tk1Xdhclmg1aIjCiiUdEmfVl68wkk0r/p9Q2WCKiJNgceODCFMD6RYLFl0TO/aeYI+3czbdZq47SIk6wo0A35KygME6NWdnmaIy49UoeLmzmCEVQOjTyk63j+jmK6ueoxRnfvFpoWgaZh5Vz4RbrRN0Fpde7FSYxUCap54+p3lokO7i8W8Ph712e9d7Na2Rfvbkq41RXuayGAY65O1w0Fn1fgIMMVYJCbPfsDnkOvxw9keM4aXttPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(8936002)(6506007)(186003)(16526019)(956004)(2616005)(26005)(6512007)(316002)(4326008)(508600001)(6486002)(8676002)(5660300002)(36756003)(2906002)(52116002)(66946007)(83380400001)(1076003)(66476007)(66556008)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8b+P3c56xz5jNA7hGT2RyDM+daccUAtRGgSytuInnaYu++ZZvYhe2Ju9BDhtnnk7elvW0T6BuCZhwSsLHsOFV7vGNscybPzIzJif/8tvSZMCWp2OmMxzFTqs2mSHIyTYdV+ryPhxcuvyAma2i+pfdkaNQgMvzmzbkwqwvLmbVYdWzxZHTk5ExN6ZiS0yqMosoprMvgjm7z61BWk40wE4n7qMtk/xsSEvL8JkzqSTTLhfEqTsDQG6odPFfeSpvE48sDwzYqXIcKWjs+ATxtraVW0mLFQFGbGT0UETUmr4dajhG0wd1NnK4GspLpICZQfaPaEhaKvM9iK9MiVMTsqeVGkY7yKY4opwiZqD/CBSUbC9sOLmmWFgt4uBEUa/RaG8y8ue3C6JxzWcqig8ENVCAg6c9gV1BD4PJHq8pcl9kfw+66F4KvrRW5Pz/wCq1vGHHHfd7gjq03ueDstOQeqXK011YbxAOBrczMSfaGN0JrvJCA/d6+hRx1qDaMH89eYqfc0Z8puf67xegkw1KF8KwjOZEIEAO5UoMtnkZ/rvdW6KZvI948Os4Lwu4uQmV5cQ4A/ZWD9HVpEE4Foehd3O1VpswG5f/ZUWmjOtshQZ8ebtJkbFZcLa5w1O9kjcEBK6Gek09OlgtqxGx+VeSkchag==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa6ce68-c969-439f-7db7-08d8547bf522
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:04.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEZbatXESk6GUMNBhsn8663nMrY/pOZ1ZC/HsvBtVbN7DuPJHQOD8KkFNG7yN8Ldr7eIm4XNxJtfd8WrXSRkbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Hi Jakub, Dave,

Currently a devlink instance that supports an eswitch handles eswitch
ports of two type of controllers.
(1) controller discovered on same system where eswitch resides.
This is the case where PCI PF/VF of a controller and devlink eswitch
instance both are located on a single system.
(2) controller located on external system.
This is the case where a controller is plugged in one system and its
devlink eswitch ports are located in a different system. In this case
devlink instance of the eswitch only have access to ports of the
controller.
However, there is no way to describe that a eswitch devlink port
belongs to which controller (mainly which external host controller).
This problem is more prevalent when port attribute such as PF and VF
numbers are overlapping between multiple controllers of same eswitch.
Due to this, for a specific switch_id, unique phys_port_name cannot
be constructed for such devlink ports.

This short series overcomes this limitation by defining two new
attributes.
(a) external: Indicates if port belongs to external controller
(b) controller number: Indicates a controller number of the port

Based on this a unique phys_port_name is prepared using controller
number.

phys_port_name construction using unique controller number is only
applicable to external controller ports. This ensures that for
non smartnic usecases where there is no external controller,
phys_port_name stays same as before.

Patch summary:
Patch-1 Added mlx5 driver to read controller number
Patch-2 Adds the missing comment for the port attributes
Patch-3 Move structure comments away from structure fields
Patch-4 external attribute added for PCI port flavours
Patch-5 Add controller number
Patch-6 Use controller number to build phys_port_name

---
Changelog:
v2->v3:
 - Updated diagram to get rid of controller 'A' and 'B'
 - Kept ports of single controller together in diagram
 - Updated diagram for pf1's VF and SF and its ports
v1->v2:
 - Added text diagram of multiple controllers
 - Updated example for a VF
 - Addressed comments from Jiri and Jakub
 - Moved controller number attribute to PCI port flavours
   This enables to better, hirerchical view with controller and its
    PF, VF numbers
 - Split 'external' and 'controller number' attributes as two
   different attributes
 - Merged mlx5_core driver to avoid compiliation break

Parav Pandit (6):
  net/mlx5: E-switch, Read controller number from device
  devlink: Add comment block for missing port attributes
  devlink: Move structure comments outside of structure
  devlink: Introduce external controller flag
  devlink: Introduce controller number
  devlink: Use controller while building phys_port_name

 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 13 +++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 +++++++++
 include/net/devlink.h                         | 33 ++++++++++---
 include/uapi/linux/devlink.h                  |  2 +
 net/core/devlink.c                            | 47 +++++++++++++++----
 6 files changed, 99 insertions(+), 19 deletions(-)

-- 
2.26.2

