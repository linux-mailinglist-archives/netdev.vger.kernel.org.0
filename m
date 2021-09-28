Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9614241ABC5
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbhI1J3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:29:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56458 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239818AbhI1J3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:29:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8Gprl011480;
        Tue, 28 Sep 2021 09:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=wuRsUq9MUV8DYvIZlq/uMy/Rdz+S7Yr8OCMkSSom2Nw=;
 b=r3DAomqS5Gd1CHKyOYH6XVBU5xEW/FbfmD/ChwBjLiTTs5TJ3Ljy9gdQik14/iEqGrMq
 7yXSjWSUsAOKJzqzPwyVqz5KKgTU2MARBezeDDZNFTR60/1ncvPKQ/KZbmxvRoXKEU6W
 MCQQS6YaNxl86oQzS7J4emW9qd/AjYuMgy59AwR1ePAmDD+Nk1qHJl/1brYg2yYJ2Wn9
 Bae2LEu+zrRTkcq7kGX/UnFnZZTMizqWcYhYlYyxkIK80TqIKEa63gylv1V1bk10VXjs
 Gs8A6NKEW3PU6wSotfG2QBbt/vQ5G0UECa6JGambBWDHUeagyQfEvCa0E3rIYcZXRCWd qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nnp7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:27:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S9GLON079189;
        Tue, 28 Sep 2021 09:27:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 3badhsf93c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:27:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPH4BIL372/2GrQY1sL+UEvqZWzh5BEdaEQIgjEm/0t27rNLLNCjFxJ7ybOEbvGfBEyOLz21bRE5/97uCNI3A/t3aZDEiSrux2hajCsLeFTJQmidLRyc5U7IwS3ApIakwPdT/4fn2iSpGPODfE0btaP/3BHQ96/tiMnG+X1oR6pJUAS0h83hco/juGad6028I7w7yJwC+OZVhZxGSY8HVIIfIffsPKEFiq9sCrJtgQ89zsdtmp7w+zaF/sRjlL99Rd0HFrgDBFJn2aZq7VqHVCGYxyL49k9nC4Fm2LrNFEFBKBLiQTv0K9TjAxq7XercsV0pajLJiB5V7pw7Q04UIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wuRsUq9MUV8DYvIZlq/uMy/Rdz+S7Yr8OCMkSSom2Nw=;
 b=j/gSA+fjKeo3O2Umh2LtBz++oWznF5gG4Ph3J3nRIzGAfNfJ41elva78dJA2upYo2uuK0qyzkVj8jQXxHtO6ArrIYIyvKXfR7FEl8Th/ObyMYlK+3YKt+nKp3ZQV8FMgr5x945mducCxSfhvUCB/KPM1lct6Hedf72xm7woExB/58saCXAvshj3h+WCLDP/iSIsNC3UFca78dvOThUoOxBNrq8a9m0Pj991D/YGKt3Lhad8Uyv1HXk2+Br8unHyu5HfXjrxAJe+uoUNgr2vztNJMV6YzLct1Zxjg/8jLie3jqOIqOyXd9OleAC9NHDZxGmcmoCMaTPt+UL+g25NlMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuRsUq9MUV8DYvIZlq/uMy/Rdz+S7Yr8OCMkSSom2Nw=;
 b=Z3UQOJEGeTONJuOzRbIphleW0x0Bo3NPwzWToAHkj9Vre0BBFQTLUuH/K3969/TaSmC30Ci4yK0jqai8i9v1Yn6/hLBtgSJ5JFXOZuwx+N93TnqHeiDUF+w3kzz80BZda90XlyeIvrliBRRGfQhVnITMMBemEGof5NSOuNi32wQ=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4705.namprd10.prod.outlook.com
 (2603:10b6:303:96::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 09:27:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 09:27:17 +0000
Date:   Tue, 28 Sep 2021 12:26:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928092657.GI2048@kadam>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928085549.GA6559@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0007.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0007.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 09:27:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7cfb3e1-1953-44fe-5f17-08d98262298d
X-MS-TrafficTypeDiagnostic: CO1PR10MB4705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4705EE8D4DF429CB5BCB894B8EA89@CO1PR10MB4705.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3899uovykzFra6pyqtt9cvTL2Q3xb8MMUoMiIAOs5N+RgDEnTYxN+gX+7t7sd2PTvHnTdFg8NkpUj7EPo7kWpCQ0dEoOcYPQuZPoIiDM2gZG5zoJkPsenFSj4TcZoK+vOs+wPeGn/6ZkEKe7seAmgBBzTzFbyPwAzMobqPjNVXBbgxOR5lKun8ktCUQz2r/lRYaqfVEfVmF8lSh3wWLZXBLDCZFjfC8JA96FZL5G9PG5qawxPVlja8UWK6XM6URdOHeVgkT5M5r+AieZ/K3o8kGcFfIV/0BCcEIcuIVEwbeHktOiMLoyMfYrOjt84zbKurTujsmWazdVULKbxLT1QewkQXyW6SmCBHVzAyH4Xp8ewJt7AG7KsHMVQYEELRkOgeefKWDjSdk0gMV46qmlK2N/zz8uUYR3o8QlsCPv+BIsSq/4m6PZmn7nRf667xsr8qLgsW6qWaq3FJEqV87A8BEa2Tiq0oVCVuvrWx26Niaf8FXudj2WckJ8hPK5MoXRTCqmqu/ESr2sXVVSMgspCFv8RZus/R6jhw76lXjRkD16+M6P+HwYHfFbWuAxvLNLZOFy913xkrMsb1lQ2Vfg0gnVsaXaDwAKPvQnPbpuRzv7XSyiFo7T3oqTPEA2mR1N1wxg1aKNvfKKH5jJFoQ5Zvb7n1/V6dtek7NKEllB8NB1Nb1JyKZ4/7u8LzRjAYUFlImmErHKWSief1jCeVSqIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(26005)(83380400001)(508600001)(6666004)(5660300002)(9686003)(186003)(8676002)(7416002)(38100700002)(38350700002)(33656002)(1076003)(4326008)(33716001)(52116002)(2906002)(6496006)(8936002)(86362001)(54906003)(9576002)(316002)(44832011)(110136005)(66946007)(66476007)(55016002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VTc3AQrX68ZPSzG8gzuPxGXj3JDOEqIkg0yZUxBBvP1s+G1DBDHrMVW8DsZh?=
 =?us-ascii?Q?8j5kuyUMKCpfC5ZRer/KPQTNFL8KdaRQVcjLeQ+va8Ry5R7w4KAGfkKVRHEr?=
 =?us-ascii?Q?Uoal4sfNQq+dsJ6Izs8IDE+CJ8dtIrzISxUA2UafjOzpEiZPEpnhMAHK0afx?=
 =?us-ascii?Q?1k1LGkWhRDmCVjrFDmkGfO6+4p8J8gyrQGdbR/TyIriJisOCXfsF+5WejnET?=
 =?us-ascii?Q?qyf35iY72SzD7XWy2dQPZdkfkl+DZIKZJFk35Rf9o3nEtwUDOhoWt2GvYQyr?=
 =?us-ascii?Q?9WoNjG6icaedVV/V9+ODFOV7kQL6eqIMY5F8aZSP9206a+kulx5la2XRUWtH?=
 =?us-ascii?Q?bszDBze7AkO8ZpRtFsqrPH9gCcJe6HL+hyDPB3elEHVnY6d1F8Rrus5eKoFw?=
 =?us-ascii?Q?OiAgiQ8ir2LAHPrJYVeDscslzwxp7iKCOrJaWx0eQ0EM2sDU6Gi8pmgOq5v4?=
 =?us-ascii?Q?3ShOzP8RIQe1UO7zfV3700Ii7sf326Tmx2pBYQD8G00Pxq5H0u6PSlUP+NHB?=
 =?us-ascii?Q?WeABEl7rIjRVyDUWxFJmXol5u+SQ40QXWdNJbxMyC9JHairzwHCRqbq5fZsV?=
 =?us-ascii?Q?LaAYHjbCclk8N/rvfms8TPBvdy3yZ+5MJhfuH7Y+wpDzlG5t8MAS0rAVWltX?=
 =?us-ascii?Q?uOyyavFPtiBIr/Nn6uAUXXuQ66b7hi7WBEiu2lunA5RPxbi1GQhHkJPen5fQ?=
 =?us-ascii?Q?hrXKjMqz3jNi0okrkIoNnAV04n2yA+qYI7K9XjrwATk6N70R57gtT0Iy1ufL?=
 =?us-ascii?Q?4klnwf9PHYSUQymffNZvge9Zr39wWLVDcybXqQVmNeOguTRytkMxDtiYrHs9?=
 =?us-ascii?Q?97kbmPfFDcRDhpHBytAdyt+i0WPnCuPyUYIuKpKfupnM7gpW9oPrQtMl2gj9?=
 =?us-ascii?Q?SNUzaRej/hzr68rawsXO2ApYG2saQWsJSd/lO+nBAi9/xo/p4q9yjMafMJoU?=
 =?us-ascii?Q?5pjl+0BbySYAXFdQ/sUyJjN8FZoKSH1ADxvmHrOsi17ooX7cZEgzdgMSV2jU?=
 =?us-ascii?Q?dkpETB1ZZqJXiDuQaYF2fr1Au1ITTEjdbnW+kkChnQbsocNs55u/WN+TkadJ?=
 =?us-ascii?Q?7K1chmTtCoksg5FiOKOWdVrLQuXu1GaO+9f5Bb6AhirDY9bsuipHa0TPPlmk?=
 =?us-ascii?Q?142hlp3nRR1KeJV2uGs7FW0YK6w3QkLk5QrwVwwdjWovlpuFlaHSVdHFmzCB?=
 =?us-ascii?Q?cYfyO5+kTpoXkYB0V/9b607trqLwsmptRbOhD+eJbuftEiEU3AAR39WVPeHb?=
 =?us-ascii?Q?F79xwwmlxkiJMjhiyrwIyfRzl9lbF7f6Ysk6ww1azfV/mgF8nYqLyqbjK/So?=
 =?us-ascii?Q?XRXH9NpqB/rRWSG1ZZk/9Jtg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cfb3e1-1953-44fe-5f17-08d98262298d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:27:16.9639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxUf0sipM+ZRCAVu7llL6DiaBy4P1mFsS+R+I68Kj3ao6nHV3lmZfq1jolEjKC8siSJEtHhZbxAyut7So85qNCyEFvNw/rgWRQnvetzHTqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4705
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280055
X-Proofpoint-ORIG-GUID: COAh17DTEOkbP0lCAGmGyPvy7jgjNpwG
X-Proofpoint-GUID: COAh17DTEOkbP0lCAGmGyPvy7jgjNpwG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:55:49AM +0300, Dan Carpenter wrote:
> I don't have a solution.  I have commented before that I hate kobjects
> for this reason because they lead to unfixable memory leaks during
> probe.  But this leak will only happen with fault injection and so it
> doesn't affect real life.  And even if it did, a leak it preferable to a
> crash.

The fix for this should have gone in devm_of_mdiobus_register() but it's
quite tricky.

drivers/net/phy/mdio_devres.c
   106  int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
   107                               struct device_node *np)
   108  {
   109          struct mdiobus_devres *dr;
   110          int ret;
   111  
   112          if (WARN_ON(!devres_find(dev, devm_mdiobus_free,
   113                                   mdiobus_devres_match, mdio)))
   114                  return -EINVAL;

This leaks the bus.  Fix this leak by calling mdiobus_release(mdio);

   115  
   116          dr = devres_alloc(devm_mdiobus_unregister, sizeof(*dr), GFP_KERNEL);
   117          if (!dr)
   118                  return -ENOMEM;

Fix this path by calling mdiobus_release(mdio);

   119  
   120          ret = of_mdiobus_register(mdio, np);
   121          if (ret) {

Ideally here we can could call device_put(mdio), but that won't work for
the one error path that occurs before device_initialize(). /* Do not
continue if the node is disabled */.

Maybe the code could be modified to call device_initialize() on the
error path?  Sort of ugly but it would work.

   122                  devres_free(dr);
   123                  return ret;
   124          }
   125  
   126          dr->mii = mdio;
   127          devres_add(dev, dr);
   128          return 0;
   129  }

Then audit the callers, and there is only one which references the
mdio_bus after devm_of_mdiobus_register() fails.  It's
realtek_smi_setup_mdio().  Modify that debug statement.

regards,
dan carpenter
