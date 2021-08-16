Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30B03ED56E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbhHPNLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:11:25 -0400
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:20273
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236375AbhHPNHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ9kfwhKQxv0n8ZhnNh63nTl7mMRvLBEs8ShUQRAyYtxROA8a02XhS20uxOLWRWVjW+wrD4FYo1NK2AjVmpWY4Zk1Q09CMYAPxO57hPR9q6CAXk3hR3KX3K4W2o386bY4tMqGhIHmQYFbp6k425kdfax/tAMDEY10IrYs6TH+6B+9S4tw9fp3sDP6Z7d7IKuF3EcpAHvW7VerZy5rAMYEwuHvtLWqNtC9KvFdDMsDMQua0jf+iE7NzNqcxqOx5MmKcAAtmNckMwg5R+Y2a9qqxYz4Ce436oj01BThT6SVFdyVCKeYT3qCpc751Ddq77rwzhV72yT9ZlyJ0oNn3J+jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EkVHbMYlfepPIhJX/5PIS9VLdfUc80vBROZOhuNTgM=;
 b=i0JA6M4pF1oeturGT9pEi88anklV9W4Xh7LLnwHnwfYL5jGmGKPCW7vWmhSLiS0OpLe9+6iE8u0OFU5wQlvb46uFhFmeGCe/QyVAEkMao9K+r6G+3xHNXIZlxJNkekJiALvRkwJJeVd2XRI+Xu9F3vuRB/k0iO5sfk+c30fXZ/u45SZyQavkGPRbaHdVYdWurNymqylpVGkqca6AlrMLkmgc8JmRAIjvVzXeFznojak6TVTgz5UnApqwYI3oo53/n8ZhIn6aZr+OY9lNRWqLSmzJD7EPR/h5JJVKtojJgPBvM+R7/rRQInQKDHIvvnXqpmc2AAHwpOBSxJO44Zhqrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EkVHbMYlfepPIhJX/5PIS9VLdfUc80vBROZOhuNTgM=;
 b=eZEEu/W7p1z1oBB9O5zoJfOs9BpWpsH8+zkoD69BeiBXM4U+Wus6uNT4xfqwpiEKaSkoslRiFpvmFaa6JxIUTMN3kw3jkonOkjseeUH90uwib6VxZtdH0p1AULd/anxpp0SJTKhlhiKp27k69fJSPhb1ulz3otk810FqqZVJMgbcDUrVAPASzbmeWaA1BBCCJHs615UbOvYfKqJsGETz3T5s9FkTGVEw/C955cRu3p/KT4+T0jBZP+m781HeJFWYv4uHJPW/eIf9506yhPzOsxdolijEyGDT3VN6Ny0SN6qRHjpU8ycbOdZUTkA3WT3XJAHGoUtPi/zzU/r37+H5cg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB4838.namprd12.prod.outlook.com (2603:10b6:610:1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:07:19 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::9473:20a9:50d1:4b1f%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:07:19 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH v1 4/6] gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper
 macro
Thread-Topic: [PATCH v1 4/6] gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper
 macro
Thread-Index: AQHXkpZCE/0aCAoDikSm2T2q6vVrhqt2GgkQ
Date:   Mon, 16 Aug 2021 13:07:19 +0000
Message-ID: <CH2PR12MB3895FCE1B0D7B075C99E86CDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-5-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-5-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d7397c8-c780-4347-770c-08d960b6c72a
x-ms-traffictypediagnostic: CH2PR12MB4838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB4838EFC65627CB200D2900C9D7FD9@CH2PR12MB4838.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:397;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jNQwciZZ9dKQZ9BBtFBhIjqiZydySVVFaRT4Dh4nuJcG67s3UPPtY9sOuXj7BuNGyOCw/Ks+5xI32FN86Hy4ZbCLw+wo7y5SGfOr0D2riTM6uFYDDczViSuqfv9TkShnHi3p7TJLqBPu7incPG7CcMLmOHgbmqlqfLjrfwpQrYFx7snuvhERgPL7NryJsPwQeJLcIdF7kvyYko1AVSCCbCuNo+tj72KBMimPtiEi9dt1II1h7+Rayzf66sEdClv+hsUmkyiyyIWUjboah4eWouiWUa8xb4tYMIL+2+fux7LY13r6wT672aWD7VEk0gBUZ5B3qSJQ9Uob4sRXsWQqD7/rdMFPh79tnuORYtW47cN9qsvHtAna3W5NjjI4qMl0jEsSYnfrI4JkROS8sWIcX3PLllLOxF0aGgEbFdyZ9cd3+HlyyT6emOZfOX/YkrWcgFunlWYb3kQNcZBuY/TP2pOibEeD7jqb3gjGNIWdu3zhoraKnyD+40yV/Jjy2F2swAgaNEuk4i+aGXViwnLxpMKMix44lIphh39gGmYTFjsfOHE1eQKbhMFI7f5GFDPFtLUlJRAQ/dd9VPeaAVr4OGXDZYaYlhSZgPRkbn1oV7+w7YI+UJ3QSHEOpsZw90W1i0Ryc8YCS7f754LA4V4ol/yhBlF1Ds8tJwiUt60xC6CIhRJ5Tw68B/6qSVlfmJPUrmTKgdWCxVGP7KLBQTd3bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(53546011)(5660300002)(52536014)(6506007)(26005)(7416002)(186003)(55016002)(478600001)(38070700005)(7696005)(122000001)(64756008)(9686003)(66476007)(66946007)(66556008)(76116006)(316002)(110136005)(54906003)(66446008)(86362001)(4326008)(107886003)(83380400001)(2906002)(8676002)(8936002)(33656002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m19R7QBUtBwMHz12ELPpmvf2X1iU2+cxDA1HDmhdTNV58ySJFaHbkCe1dpT+?=
 =?us-ascii?Q?/FvkVG5fp5Sao9fcT68xZ4fPlcDxUrYuDPhX7eS88c6NOvlyD3HDzIfaus+F?=
 =?us-ascii?Q?mCV3EwxmKFuRn4i5vaAvJLV/R6KtnhWdlDv15a5MMwXr2KuDwmyLpG54viee?=
 =?us-ascii?Q?EheGxkuHihouFbfiHwKmldhEOG1jzKkUGlJyzMYTskDazXtcghVaYt+KZdDi?=
 =?us-ascii?Q?xperdyt4fA8IZpSrfNZnzoWpW3Ht6VonKPjx2nCLXAJdkX4x4A8yl22uQFXH?=
 =?us-ascii?Q?EZxkD60wFNbcamNO1xMAmjZR4ECGIjA6SgJeOR1fu2yKioO5dPO7JGxC8cHR?=
 =?us-ascii?Q?/edaGdzr4p8B5efTd7uK5AOtuap0klKxRtBuMQCer/xQtJH427+O1IlCZrpE?=
 =?us-ascii?Q?J98+V1tKDreY1jlU0BlBAmW/TX11SyDk1/1N6q7E3eP0cEE06IYrM8bpCbsl?=
 =?us-ascii?Q?ZF1w1hRZZP495xB/KXMp1zOR5mqnzQAEOV1NMwEurOt6tiXipLbDT54SlHF8?=
 =?us-ascii?Q?1ZdpWnJPijVR6eH4lYgRyzCUuEUh6nXTCmggo4u2gvxGT2qo8wWIYEkhUCBe?=
 =?us-ascii?Q?QjIaxco4HziExnB6LYTq64Csx+q6M1qZ9eC6f+ZXuss6+Pt2YdLjmnXdn+Hv?=
 =?us-ascii?Q?Zki78SkAKwSEEvpU3N0FoHkWfv2et46NQ0g1WXXTrqBZSfrJ1okZeat3RSKs?=
 =?us-ascii?Q?my+VbQ6zzSwH60i3k02QH9AjGA3TMNlepA2F0rwFsrHESOb42dxjAgZW1rbq?=
 =?us-ascii?Q?FTrMdsd8vsDx3+QuIy0+r4Vqrzu2INrMtvWRtNgYFd5VLS5GzXXRXZeU/HjP?=
 =?us-ascii?Q?+Lr3LGVvye/RqlR3s3iJ7CzG2ubGE4rvQQxEye/5C++xC9Dx9UgXHhjzYuBS?=
 =?us-ascii?Q?eaPC/5Ocw/BydlqhpJGVORaehie3J1CWgQcZIiHmKOq2Iy/JaoJuuGCTcDl2?=
 =?us-ascii?Q?6edg9Fx2H09mY/Q+n7Y96L+pnjLvxkmmf/eE74oeny8fFjjwG8k3NYip+4Cw?=
 =?us-ascii?Q?ZT3FmDDBoQgp0rkrfqEwL79EtBchvqty0O+EOpCs32nhRun1hKvlJfaAoZIv?=
 =?us-ascii?Q?muynzjX8ZPvUWGsl0gTQ4nkJviLFLl/IYBcCki01b33/RMNAiYBfMCxMcFkJ?=
 =?us-ascii?Q?cYjBiHoHrv1y/80uFMkdfoVrYRyyI0ScUCIVcN3wEgibNSOMaiT91ngaQ8o1?=
 =?us-ascii?Q?2u5DQ/qgVcl9e+Zvpqi1Wn115uuInjuJudhRERF134oZNg+XhBtLO7IIVYeD?=
 =?us-ascii?Q?I6Xlxy5ZJQxTNDJViKZk/2YvLCAF1QI9zWJ9Ud3AZpm1cwnILG/LEB9mOOfd?=
 =?us-ascii?Q?HHkRXDqwGlW0Pnj4KnVbxH8m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7397c8-c780-4347-770c-08d960b6c72a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 13:07:19.0289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vq6+mrRiEYCoZkr8tzQbhO7LoTLU+81TFmuUDPB3UuSJhBOHa6CZbMNM3RScsnIW6kbTktsxc2b2MQmSYhdj2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Asmaa Mnebhi <asmaa@nvidia.com>

-----Original Message-----
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>=20
Sent: Monday, August 16, 2021 8:00 AM
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>; David Thompson <da=
vthompson@nvidia.com>; linux-kernel@vger.kernel.org; linux-gpio@vger.kernel=
.org; netdev@vger.kernel.org; linux-acpi@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>; Bartosz Golaszewski <bgolasze=
wski@baylibre.com>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <=
kuba@kernel.org>; Rafael J. Wysocki <rjw@rjwysocki.net>; Asmaa Mnebhi <asma=
a@nvidia.com>; Liming Sun <limings@nvidia.com>
Subject: [PATCH v1 4/6] gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper mac=
ro
Importance: High

Use DEFINE_RES_MEM_NAMED() to save a couple of lines of code, which makes t=
he code a bit shorter and easier to read.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c index =
c193d1a9a5dd..3ed95e958c17 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -69,11 +69,8 @@ struct mlxbf2_gpio_param {
 	struct mutex *lock;
 };
=20
-static struct resource yu_arm_gpio_lock_res =3D {
-	.start =3D YU_ARM_GPIO_LOCK_ADDR,
-	.end   =3D YU_ARM_GPIO_LOCK_ADDR + YU_ARM_GPIO_LOCK_SIZE - 1,
-	.name  =3D "YU_ARM_GPIO_LOCK",
-};
+static struct resource yu_arm_gpio_lock_res =3D
+	DEFINE_RES_MEM_NAMED(YU_ARM_GPIO_LOCK_ADDR, YU_ARM_GPIO_LOCK_SIZE,=20
+"YU_ARM_GPIO_LOCK");
=20
 static DEFINE_MUTEX(yu_arm_gpio_lock_mutex);
=20
--
2.30.2

