Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286A556D2A2
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiGKBdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiGKBdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:33:01 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B371175BD;
        Sun, 10 Jul 2022 18:33:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMufee1Q0ATfKNYpcXjIhEExQ0lYKmmTf3yhJRqO6Zv4bVHejP8QsZxl6mFFH3j7yLsRFqNtncCAmhz1+IWEc6o+zQi/hzQQThXXW1tnt3dMaeuxF/DXWAQct7tA6J9wZUbS2S8zXlncVI4Lc9rcVHojvML5dMF+UYrYqoLsXVUofuNFVwVfT/OF0aAsbQ/wwcw5SxvKd1iCOeCBR3WH2o/WeY7d99bi6MG1nb4FVBDcSZxBQuETqbJERFcDE0QUL+a+JHTVRtLmtm/6fLMI20oz/a+gP849oCj9d0OyPtywFvwBKEL46TFA/o2lpPNrBZVRUAA66u8hhpH92CKcUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMWuDudGbpsy+BWvi92KZ695NP/uidvbJtORkY6SxzU=;
 b=d9IMe5XgrF5s78VBYvsst/H4qSbicrUCaI0W/y+ePh5zAfEDA9C0UgYL0pyWDBNPgzFUieMYGx0eZFLBPdnGPoqXIX8Fbz7Qn46ig7hbmmePf1UvnitSTDib1HzOY8RrY86xM2iquc1CcTd78E5XTC1ztU63zxW6bgwoOqklkMiYNIq5RwhRE456ex4vMAt5dwos43i1YrQww45h7BYrDkMaRRui9f3qjKMpdl7m2F2Q7YhH/L+j14wsRNrAQbtqI4ro+lB9hQDiX1/c/EkVaP8DKfDMgtlDXSAbxLQtnsEmmq4PBjDoSohJS+xVmeqCr/7N33ibKvJFIpft0a9bHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMWuDudGbpsy+BWvi92KZ695NP/uidvbJtORkY6SxzU=;
 b=hjBkwtlQvf0h2nrMsHIH0GOpflESvWBppUaIadb67tDPCMYfLZ7YrwIn2LFKLMboYfsLM2yjJQjdssaUK7ncIYCEEC1a2WEB3iTAjRhja5IWb6ymuBkuGlN6mC1c2bNz9YMHqL8x2CXo0Rag9Qijuqc23fSh9JHJE80RBrSOxFI=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3508.namprd21.prod.outlook.com
 (2603:10b6:208:3d3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.2; Mon, 11 Jul
 2022 01:32:58 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:32:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 11/12] net: mana: Define and process GDMA response code
 GDMA_STATUS_MORE_ENTRIES
Thread-Topic: [Patch v4 11/12] net: mana: Define and process GDMA response
 code GDMA_STATUS_MORE_ENTRIES
Thread-Index: AQHYgSXb3GrASVL1l06x8kJRXbp+KK13AsuQ
Date:   Mon, 11 Jul 2022 01:32:58 +0000
Message-ID: <SN6PR2101MB1327242702E5B45E5F645C02BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-12-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-12-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f6d65af9-11c1-4d04-95d0-0f4746288dc1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T02:12:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37092282-f207-49c0-cbf6-08da62dd4947
x-ms-traffictypediagnostic: MN0PR21MB3508:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51zMHTlqhUKZkyV3QhYn8v3ht267TUFDGrIKOqC7HlHghRR08rVmwUkJxioKnvjrjpgYQzD1qqomZgBbhdKjIH0ys725ueoKz2xXroGMWXw2gMfuryACFvr8x/uZMqSTUY5dI/dScTP8fCWuzNtnU4DrI4vYSIWtdXCRnUC0LaX6ybBPw7K33DFTR9ulGBkCttprxAjzT71VLaQqQivletpM+xyai7HtFSWjZFDNXZe//2OyNYeYkU3XKYtS2gmRKct7cHZgvqxqyQ9VQQHCdpgaQxxiuBBCeFncMe/8CDw8UBdNbJOycq3gZp7oClGD+MXiSegZNDoW06jPa6ut4C5lef9xhZwTD+gipHEm+oBd1jQ20nHphKFml7dxNYqfh6g3oKDDcFeZTiRsqy3JGzNVdfz/1YeF+E7dkpKvapRuVoxtEKzJWQQgFsAPVs1Wu8raVL4k+PUG1w8aHoTNG5icEDeq3fg9AXh80tQ8JHgVcxlmaZEYo5Znvp4FgJze/b5PtSYFamkOXXegrJM0Bg8jwtEk9/UsMktc98hTDqZFN+65wa2CPnXP7WeILQaunosa63pEyDpvVzk+tImAdzb8cEfw4shCf5eknhnerjn5RZjT+Xni2+/9YsD08AL5Cr82aLHKV14aUgtl/qz0qf+zksQgDs9LFEm0J4yJTltpbr7wuRBo2IST8PZAHukjBFbXr4uYq37/VIw/UilhQriuoz7buf8N8nVSzL4cPZMup63iibz0MJJaiS4GTh6/bsceAxGVXoplDtsQawqjjeHrgvGULzmJhZ9QvgtQpnOFiFAshx+HsUZ5j2fJrWmHaLApsSMHHxh7+ESn+aA7ocZocwHLyfjXuV6USyAbw3euc/2jw2kwu2VCR8qyBeS+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199009)(2906002)(6506007)(55016003)(7696005)(41300700001)(33656002)(186003)(83380400001)(26005)(8990500004)(9686003)(71200400001)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(316002)(110136005)(8676002)(38070700005)(10290500003)(86362001)(8936002)(6636002)(52536014)(4326008)(4744005)(5660300002)(7416002)(478600001)(122000001)(38100700002)(921005)(82950400001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zi7SHJdK153ry32mprFNHwWqfjgy3BcxPrBqqVlSz6XkErYOCAoNwj+YCeg3?=
 =?us-ascii?Q?uwfPBOejyVaaZ/sKqaevKyiHHAw5sxF+nf2DvRHzMinsZBEWj5vEw+CCkEOX?=
 =?us-ascii?Q?okbL445Xhp1HUo3QODgCf60OFKZqzhL+C/kzoxnydSyZgNjyFjPDTfHhamej?=
 =?us-ascii?Q?+qWp9hcaNMLAZkKZjCvnk5YIpaRKrpbeFvusfGxGBQfGboDNF3CeIFneBwAd?=
 =?us-ascii?Q?QP4BiSOSpyx2t8MrOwlHVrNftxDJhUBicgkYzHzrOQ09cvcuCCC4+1X1zOuT?=
 =?us-ascii?Q?SzXaB36n7CjO24A+ew6mWRUsoP3IWvByZBoOzIiQLbXcTbI9PNnoGnwQLeTf?=
 =?us-ascii?Q?DMwZzYY44igtmF2Bayi785qnp1nNjcX6b0GzZkujDnv1lCFEgIcw/cJZiJpG?=
 =?us-ascii?Q?Gs3Nf9ve2sfb1LUyOEIvEbxRKmKWQdvEY6olxTxR75xjohoZ0jL/KHKH58ui?=
 =?us-ascii?Q?DZivHqEYed8XWoMku8cMFcQ0Tsye+PyIQA2sHCSetMBdQPgsDNJlFtTDcoH0?=
 =?us-ascii?Q?M/ZeTE+Fr6vxqtfP2FydMJ/qnMdtHxGsd4pWbIs59OqyjW4jJvch+2wfvbAe?=
 =?us-ascii?Q?8MUakcdDd/KD6gFolXFOp0h6nMWldOkcr7v0jEpmy1fLGpGhhZnfcIDOFAwk?=
 =?us-ascii?Q?2glckZYWBcYIEh8H+BVfk23Owz5Kf9C5/eGzA3ow9r9+XNk7wZsPjucjiq2j?=
 =?us-ascii?Q?sh3VtKSWWHvd8JbipzCBCrFHKV0O9C1/Z0msO+Y/8FLvvOyYGSYAHn+Yh5Lc?=
 =?us-ascii?Q?l735S53WWSFEl0GyNCZc2LRwKeYBHXbR/7zGwtDwnsdrRAWqn4h6z0vVQkpi?=
 =?us-ascii?Q?P8OB/Ti6Qae3q720jWSPs7PHQ8+fezkXfrriEfc7/qsau4B27Udvg3DEEsVQ?=
 =?us-ascii?Q?fC4gI6edJQTV0hNK0RCNkWuzfcgM+RDQGFfQnUbMdFCRUFb3i5iBO1Uuyw5B?=
 =?us-ascii?Q?EKmTwKLm5b1rpSTM+B6sagnFrT52+pnH/6Sm9f8VJk25qkPFFmeOOk8063nx?=
 =?us-ascii?Q?Y9eyQ6F/+uOHZ7PbiAWgg+dv0aFf5wQCV5AWqQr0ASfW1Dr1x8417AKfJU9k?=
 =?us-ascii?Q?c0hedpQJHyL+hAsR+d0iHIbGQQ2IZGQ5SRMnkPTPlZNQAQ7xWZJssZgRwz1D?=
 =?us-ascii?Q?7FGCeDvUBN2QC9ejRluV8n9eL9+nPCjP1TDystjP+Cc/N5C7WZM0rLatVD2o?=
 =?us-ascii?Q?xMAeJPEAjZHJ9PGtmHVRuRm76UkMblaJI5xHwGvJi4ntK0RxzLGex070HJ7O?=
 =?us-ascii?Q?wRamq0B5ly+RIKKgSMKggG64OJCEs605OEJjC6m2zhAZyITIqZ92MiqK4fQ2?=
 =?us-ascii?Q?98Yz1zGRXz8k+l51zrUbMoyhYaRoFBlzQB9qL1mrswfsht36T5jtOBEPsQx9?=
 =?us-ascii?Q?qRIcEmsfKCYq0cdDiaBSL5V50C7i3VTZ8qpFaFUmQfY6EZCG0GjvhYFMbPAl?=
 =?us-ascii?Q?On7aSWvWiSJloXj9DUnykf8IEwac2+GYfI3bgxuXWO0FMD/Y3bHPCwDihiMa?=
 =?us-ascii?Q?0MP+HRx3ALpe/x/QozP3jAxj1GWx3JouKS1ZqYV7XlG0+A8YAg69JPodxieT?=
 =?us-ascii?Q?yyOLOMpx+jjelzlg7wlYI4eWrpXm4LGDDboJJ9/l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37092282-f207-49c0-cbf6-08da62dd4947
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:32:58.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LMbsk8CDPF0adjgxnaNQMHkhZVwMiCkp7CK12HMfXTTQ9KPkatn7l3FCVRR8LMkaNLex96DJTBHcsA6Ymi+wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
>=20
> When doing memory registration, the PF may respond with
> GDMA_STATUS_MORE_ENTRIES to indicate a follow request is needed. This is
> not an error and should be processed as expected.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
