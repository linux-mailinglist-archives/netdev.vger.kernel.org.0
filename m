Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABC6E3A59
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjDPQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPQzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:55:02 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931AB1BDB;
        Sun, 16 Apr 2023 09:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0sElS9yX+X6QHv0LUucuU3lPbfplmHZ8RrO+NzmSg6tKd0BKGcRhibOwuXAKyrgU8u5STQIZsTnIBOwXa2QUBVNgFReIX2AX420zj/8p5I7BvtclppFw+G4M2gPaPOPd9h+0+BELcglwOoNjUpaKmff3WdI2GAedIYt8qqk1P0hGJ38ONayftpccOJXSwPsOYlKcEtkCt2Ltta0g2fZJ2WsxFD7uCgvwEh5rY/dsg8QddD2WctEz/qTUBwWDzX12hO9s50h7kArU3gfPPAMXMe1fSBiPI56RD4JtcihnYTGE7eMU/RMd++mZx2EpEG+Z1HInuosoHodAmFk1xSZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrMMZG+z3OcbtXH3/U8xzql6PiIZC9OyHP2JmwpZsnY=;
 b=VI862hCUyc4hi58T+5B9cKFeV2YD30+2dYhljsj3JWrm90y7LKDKHFwoh1XwZrealHPdSWi6qQRoF0jfqVfqQcMUY6sf1Q9H7H8ARSrbeNa6I/Ml0W4chHj195T5mU9tM9tsSgBvgmMz9/CqmhjWXdSHDxvKIjwH9mA33mGA3TASWSzQ+vIb5tbriKxF3oAFOcYBJgZt52+GsGx6GFUw0Xc9QiyhZUs1UsoAKtW3stJIXILHaC3hC8Ae+V66Ud8Yi/JRr1o1iKeRL3RH7efwGiq056qyu9FPyZCfVSuwGQ/nc+BEpvbmjZ7S/ohPwFHHme0rrHD6zqIRuxyLVT3M2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrMMZG+z3OcbtXH3/U8xzql6PiIZC9OyHP2JmwpZsnY=;
 b=Ei2zJVX7ChnQItLg9EJ+nSdLP7tI4MVHtyxol6HOta55XQMCmnQWmpAN+CQ3V6MgwL+BTYz1Ry5WW1VlnZsx5eDaJS+dWuG7sCits0I11eEhVLQujlhpCAeKvzwCUIfqeFohXNutPVEmQ1PrE7K2tgxgpSrxCm0sMDiCFYPu7yA=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB8705.eurprd04.prod.outlook.com (2603:10a6:20b:428::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Sun, 16 Apr
 2023 16:54:57 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Sun, 16 Apr 2023
 16:54:57 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9
Date:   Sun, 16 Apr 2023 16:54:57 +0000
Message-ID: <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB8705:EE_
x-ms-office365-filtering-correlation-id: b3519b65-0124-4232-33a9-08db3e9b4f55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eikL25aLLr5g7MGPKQacYeyuJXWgKd6PWAeM9AAyZpXxSvsXPde389p93pw2uNjeNELH4JGHluKZgId3yqeeBmrYhkW1VyRtBaA0G3lBFZ79K837SQQMeEFPWmqixNIF3vROHomrVZzLC4K1cvPH0tErdw/3GZ5a9Z+JjXxSf2rw/foqwtEwt8CcFOr/vc+U3AIHiy9rEMg4v5UakT/0Oyi30c81hF6yiE9oRw7jXoP/+4qY/GWcpIzLOPCW53H5yeGG+I+e6PwxoHkMxAo04ym4D0w30iEvfN3XrpTe11MDDpIZVkaZTCKva0UgI7C0KrFlRZ5rv6VcaEpURwaxUylJZhdxVT7zD6Jo2iTgsoDu+btTEq/R3b5gX69TRN2U84LUAWZVHOR2q8l1ivdmcnG5jJRkz7drKLqOA0cCxIRcj97i/ORc3cbJA5SjsR7kUru2Pxh7J01FHODhIwTaQ0tDaLVKPFEYPYffq2aoxQ7n992YHogzI60t4b++ZOV8xpLzylRDTi+wdaI62l01YoCKiJ1rlgbha1cgjue52I+5Wj+hTJQOESAue2HWe4mAPKWVckNk9uHierdVnOt97fZ+MtCu1AIhwqDOYLBtxcSc6xtD2BDKIu4Zzct7VZLB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39840400004)(366004)(346002)(376002)(451199021)(38100700002)(8676002)(8936002)(122000001)(38070700005)(44832011)(52536014)(5660300002)(2906002)(33656002)(558084003)(86362001)(55016003)(478600001)(7696005)(71200400001)(54906003)(110136005)(186003)(9686003)(6506007)(66476007)(76116006)(66946007)(66446008)(91956017)(316002)(41300700001)(83380400001)(64756008)(4326008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JuFNzclqg8JkVDsldmchIfGbtUF+SmD4XE1rblSRPcJNyH+TZ9rbU3tshD?=
 =?iso-8859-1?Q?8rsmSji+FDXU1o3jtFzBKoIDnNEoryRIpzg9rrkk9mK/y7HB/jsMRmh4vM?=
 =?iso-8859-1?Q?TpI3yHWlvVGnbb+KaTu6kV6MdoV8uXGYv8XVjGCiYbr0SWuKQWy4yJ7txy?=
 =?iso-8859-1?Q?VGG/gtFSdLEEtkHXTrnGrsnQWcRoNm/Y+5v8Rdj4Zd4093A42IaOlfyv2H?=
 =?iso-8859-1?Q?+mqDLq9E1nHSUa854hBM1t1JYkrAY6PFNVqUoAqBAvTDx1dBLCk1exq2Jg?=
 =?iso-8859-1?Q?ynHvzkfZ16UrkW1HHuaYQNAOdB7jF4ZGGSB4jioeyyW287v0BfQOtPtQsU?=
 =?iso-8859-1?Q?zc+L9evPpivUbD5DRLTMWz4DwJUnVvt7k1zuBEHNjAP6ofpM2t/f0LwM38?=
 =?iso-8859-1?Q?BLZ/eu6u+hXY7r8SGpep4q6XsEiBrDwht4DWFO4pa1OfLbTtDkNLevvYX6?=
 =?iso-8859-1?Q?qQ7oE4/y/nfIiU8lnQTvCn+s8hTv/A6+Gls1UuV6OzY12ctn3W3MqdZQZK?=
 =?iso-8859-1?Q?IhQBjYjPrcA5fakQEqaf+Vr6rTYurOXhQSMidD0rhXTetpl4GKDKNNr/L6?=
 =?iso-8859-1?Q?RuDyCWCMZCR+9eFTRPWpPbp3Wg/gbGpU3GtKRxrgs5n9o12qey1Rckz7bL?=
 =?iso-8859-1?Q?PtcKzdKj2lzJ6KDinP/27mdEowhZlJkP7OLAGlp42Y3IXSKUAuKf6YeXqU?=
 =?iso-8859-1?Q?EsHadpNPPP82TLACT3foGJEFayM5fNZm8AIhE3CJnfrS7qTmlyk/Id2VdB?=
 =?iso-8859-1?Q?ZolO+wVG+j5MYgbPvEFIU+BISdEaLzl0mvWXhGPS/zCdQxVj6QbIwymHU4?=
 =?iso-8859-1?Q?TmGyQMTBn+1epyV326boMIkflC2swR+KsXLAFYoaShiHOoI9FMFh1Rirfx?=
 =?iso-8859-1?Q?cH6yKMbciIVoHQg2DJPaH2s1BBqE/7dkt+3IMSTnPvNkmracP1LFhw05g4?=
 =?iso-8859-1?Q?0SYmK5K7SxebD+HTtr30pBXesrKU/pjpQp+OfNPO4SEk7mAI2ehpHD5bNU?=
 =?iso-8859-1?Q?Vy9BAaXyUO2k/OLZKyRVCHspqgOYzMraOcnvnnLsuy5CcYxUHTnwqSc2VU?=
 =?iso-8859-1?Q?27dF8uzQDfKVic9vcotjG9DurR8Qmsq/W0C5fC2zUP4xrZJt/jXyqNFD9M?=
 =?iso-8859-1?Q?5JbwCzh4E8rF9oEOita0iXCPx5Z7F8f5X9cV08k1E4AdVLFP7DHkTCkorF?=
 =?iso-8859-1?Q?ZycU3yAcCRRHFl1eDc4Zo5s2gP3DtV4k9vjMdF969DjgPJCGpLarqxtP9I?=
 =?iso-8859-1?Q?3qns9zm3YnefFtWGtAZpwMxBEnM94tcNDkf1M1e9fAuZwxb9RJhx9hn2qe?=
 =?iso-8859-1?Q?NxP80uYAyC7QaKjDRDTiqnQb7XssfawiXGOTbmYzZNI9tN/E9piK+rqohT?=
 =?iso-8859-1?Q?HqZQ+lbcv4ndIG6WimNr6ZCnATHG0ar4RndovHx6AkCC/eW2pNlN+CLsun?=
 =?iso-8859-1?Q?3amcHWR8VcmeVdvdM49ATGyXXwfAArTQK+1jAwPvmw8e7WM7rPZ2AN3nOr?=
 =?iso-8859-1?Q?UcadBtzoasD4IMVJbLbz0D5cxTyOR7QZ4nPjExbNtp2PySKiL/+qC4x9pU?=
 =?iso-8859-1?Q?V58sE32MxODNa/V9o3On0EelLKma1fsktyld8wg2Q7Ly07duSplRP4DECE?=
 =?iso-8859-1?Q?qUn8xo1F+2y7MCwofBH5+8F1DO9esoKDuWPsxAATRy6iTyff8zC5MjYisn?=
 =?iso-8859-1?Q?byLYBiR+4o1DbqDb4uRkqyTm1zU+dew+4wMirlCn?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3519b65-0124-4232-33a9-08db3e9b4f55
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2023 16:54:57.4798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/1AiU/TdirOd4eyEF0DQtSCZiwdkgJkrXg1Y+oCwqT3+lqypHCStVmHAMlJ05XLqV8Ak4yYK9Le4hL6cY0kKpZIkjfaHWbMav3L/XrTyXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8705
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After further consideration, other virtio drivers need a minimum limit to t=
he vring size too.=0A=
=0A=
Maybe this can be more general, for example a new virtio_driver callback th=
at is called (if implemented) during virtio_dev_probe, before drv->probe.=
=0A=
=0A=
What do you think?=0A=
=0A=
Thanks,=0A=
Alvaro=
