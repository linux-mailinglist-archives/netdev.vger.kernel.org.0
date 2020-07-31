Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6A234360
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 11:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbgGaJiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 05:38:05 -0400
Received: from mail-eopbgr140129.outbound.protection.outlook.com ([40.107.14.129]:16773
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732044AbgGaJiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 05:38:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cq1tRWN7RKFz1mfrDpTLc8Bnh61v7BmLJEWLwhnF6OnJNYKl943VesEzAUvwp/bnzx/W16SM1MddSSFXCFYxLzDMB5cLyUW4AQVKPli4OD/ertL2A06nJ4dKGCNUEaY59s9HiZwTAQSRzkmu52jqrVlFY7+/Q6G2w0s8VnURP8YZww0d0HrLaJjrw0fhfpwPwdt6Afk0NhW61I/Vw+btq4OcE5MrG1q5Qy4YGnTSNfI20tw22HaFMXY0tGoDFo8KCZEfPlCz+Pxlwg67v0j1RduDTUZH0BCbWX8ItWC34IDA07nPyg/XUv5jVDoZfAn6bczfsgpvLflzprGR+CKLug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpPp7aVK2n0K/nT5KZUjD24FHf6STuRyS/4nW4o0lOU=;
 b=PHCNbXRFM40QqP7gF2Y/UN8v243U18n3nVz8gslE1oEOwZ3VG46JvKzUeW0tamkwE0TOvRKKRxUmTiJDxFxmf/t+vmV/gE/h43ElvSO3tCWYBQDATQwbRVAOZIZIWFa/bhqVSolP2xdayL5Co4XAKScPH/afzoUjIWoxdp4QCo+5VsWf2nZ5H51xgvzMM6LHW9Vk23MihuIX0bRArZV0KKeZWsaT8uQQL/Xlbvy/zDbF1TSgduDL8tZ/tyyNjmYadqY7cY7Y+yPG1sv+s5YZxbDRA37zQ27qtxdfX8oBllB8EubMRms4DYrXIHOM8lc1A/RB2upRK+6EotgRYvNGnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpPp7aVK2n0K/nT5KZUjD24FHf6STuRyS/4nW4o0lOU=;
 b=cQVbzoW/LqyDH/ZoDRgEuCGytUEnUw2LIMqRR+N9hIbvuiXsLbqYl1rGb9eEC0Y8tZ8YmEdEaHjFmgeBn3YWNwVk2hZ9pWlXGGvVhkQ/K8Zxt4/LYOqci67Tk+TMCnvV3qCgm1i5wjXGr5DRtDbt7LdQsnjUAQSTPNmzhg8v8Jg=
Received: from PR3PR83MB0475.EURPRD83.prod.outlook.com (2603:10a6:102:7c::10)
 by PR3PR83MB0476.EURPRD83.prod.outlook.com (2603:10a6:102:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.0; Fri, 31 Jul
 2020 09:38:02 +0000
Received: from PR3PR83MB0475.EURPRD83.prod.outlook.com
 ([fe80::dd7f:ba4d:7d35:fbfb]) by PR3PR83MB0475.EURPRD83.prod.outlook.com
 ([fe80::dd7f:ba4d:7d35:fbfb%5]) with mapi id 15.20.3261.011; Fri, 31 Jul 2020
 09:38:02 +0000
From:   Matteo Croce <mcroce@microsoft.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>
Subject: Re: [PATCH net] net: mvpp2: fix memory leak in mvpp2_rx
Thread-Topic: [PATCH net] net: mvpp2: fix memory leak in mvpp2_rx
Thread-Index: AQHWZx5J9jaanXvKRkqd7RcArw5O3A==
Date:   Fri, 31 Jul 2020 09:38:02 +0000
Message-ID: <PR3PR83MB047572918786372967C5B20BD44E0@PR3PR83MB0475.EURPRD83.prod.outlook.com>
References: <c1c2f9c0b79d4a84701d374c6e63f69ec3f42098.1596184502.git.lorenzo@kernel.org>
In-Reply-To: <c1c2f9c0b79d4a84701d374c6e63f69ec3f42098.1596184502.git.lorenzo@kernel.org>
Accept-Language: it-IT, en-US
Content-Language: it-IT
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-31T09:38:01.982Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [93.38.127.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 509e3d0f-0249-4f9c-4e24-08d835356ba7
x-ms-traffictypediagnostic: PR3PR83MB0476:
x-microsoft-antispam-prvs: <PR3PR83MB047602BCE6BC371FE232B05ED44E0@PR3PR83MB0476.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V4jpgztD9szZVA1at/zbqC96q0PKWkxYH4GZ0ScsO2Gewxc+MdjXyW/K45LmFjpM6uaDpHQ8m8RaowJPvefsoHW7tE3Oon2dIhQr/mHtrvCfHxwSfvqIb5CxE4uqkiAHCUbgZREbE0hxApaBBhQRCeUof2hDzgmOwcSAArS/B0zSKkG6E7LKPOA8NElQqglaXrHDs5iqnioJPKLa+cgvGdS+oeW3DWfGErRUwcZIR3y9q1DZMY6mtfLHSclEGwxDZjoELKv1K8J1Sc1lZ/proPmqh0fOXgRWDIrcHe29zPHcJS2PcYMf9ZiOHruEe7bv536GsyQmQv6kep7fa1Mh5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR83MB0475.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(10290500003)(66446008)(64756008)(82960400001)(66556008)(82950400001)(76116006)(86362001)(66476007)(478600001)(52536014)(316002)(558084003)(5660300002)(33656002)(54906003)(110136005)(8936002)(9686003)(186003)(66946007)(8990500004)(2906002)(26005)(71200400001)(7696005)(55016002)(8676002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: I1BeC1frgKG4UQYJgjsR4nuVkt+JKVIOtOFzd9VuT5dkiJZFylFdaA1NBlPY5UN8zi1VJzqOjMXAommd6VcCtTpIRtAMIV4418tisNAwIBCtEmTRWYRr1qLy07nHzuMKKmA6OJpwWW3jTiSQxNxHqo4GRCu9wpqSubMKLlsAV2fLj2oiJaobWwaYJjKaX+cckdsIDavaAtxqo0iaqSEoO6qLT0hictq5A5KHZG7edhsTiI6mkalM+jgBACHIIbGGfFxmPkZ/r+qSPAcMFb+n6mHNu/joE8NMfgQG/DsoKAuRDUdEG5VQw+ArmrV/hHoDQnbR5xKqAQ9SVMTFodOvqx8j7RDUU1isg2igYSZQBzgL3z3UJDXH+KyZrVAtcAw+kZQAfBRRTQprXKx1TEmqyHSbf8SmVEfE8h/+C0rJOPLoZntQPWr2fE3K+OSwn9705gdBlAt+ezySGeDWiQHvlrqI5vDkGFQxYWUKuVIyoffxU25fYGLd4lDhd6/XnLLDz6vxWooY9ozoN+Uj71iAASdNbKmJRECacwx0V71XdsZm4k754wAllIqVxLvROpqj7ueEBNgT9I3F7DwsUsTv7Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR83MB0475.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509e3d0f-0249-4f9c-4e24-08d835356ba7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 09:38:02.6330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IDI4NNj698RUVtetR9jGX1NEpHj6urjCjs0hVVXbyWdM3Sq61MEM6FObe+ffsMnE2uyey5O8UneRTVzSObyF1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR83MB0476
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Release skb memory in mvpp2_rx() if mvpp2_rx_refill routine fails=0A=
> =0A=
> Fixes: b5015854674b ("net: mvpp2: fix refilling BM pools in RX path")=0A=
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>=0A=
=0A=
I think that mvpp2_rx() has changed a bit in net-next due to the XDP suppor=
t, but it should apply too.=0A=
=0A=
Acked-by: Matteo Croce <mcroce@microsoft.com>=
