Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7285B5FB1B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGDPkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:40:51 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:41704 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727454AbfGDPkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:40:51 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 38FB8C0ADC;
        Thu,  4 Jul 2019 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562254850; bh=ghecPn+0+MUlWdoUlxao5fLxwE8zFRw0GbuvNpa905I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=WQwswo2th+J+Frdb6XmJjieguk5g4a8suzSSMQd8aKs0bJcWgRZMH4IlM7C2azyf6
         Bkonvojdm+7P7fBYnus9BNTBbgq174iXIoRvzAcsY1WcJltuV3uFOJDohh4cj12dU0
         QdpWjAgPllXEhLhTAzL1sGQh7rkOw02ER5VgLITP3eyWW3bgUUL9y/XnecIf4U6u6b
         bh/hGCUf9HfZaXfIhe8w61nM/mRWva5MO4CQFGuuGOGTpL2MlglH2WJY+Y09bCMi1j
         At4hBBefxWcIWb6us2q6VBsRUJoe/5QziSEbI+/1+Lw6w3lWzGjLg6/lnafYiXeAg9
         ZOmQMy6dHdagg==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0F5D7A009A;
        Thu,  4 Jul 2019 15:40:49 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Jul 2019 08:40:48 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 4 Jul 2019 08:40:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC25VB8tpldUT/tdc/EyZU+pNl8Qid1g93KhYL3PAwc=;
 b=rAuAV2H1fvwyxHlhj1mclQ35bBmCHOWtl3LMADTb3j+MFaV6+6FstEo40TUBD9BC6Tq98B+dcQIBSsTBaT3wckXD92WzFNmGsMxULNiIu96/ckJd7h4ruvxHhGajNtb8bDHbF+vwY+mXfhM9mxcy3xI9E8/ekPKyypofOjdUk1Y=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3367.namprd12.prod.outlook.com (20.178.55.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 15:40:45 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2052.010; Thu, 4 Jul 2019
 15:40:45 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH net-next v2 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next v2 3/3] net: stmmac: Introducing support for
 Page Pool
Thread-Index: AQHVMnnVrFqevi0djEyAS7SJukKFkKa6l/UAgAAAixA=
Date:   Thu, 4 Jul 2019 15:40:45 +0000
Message-ID: <BYAPR12MB3269D8AA0646A74178ED4024D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562252534.git.joabreu@synopsys.com>
        <fd2b12e6fc99f6064b0c04e1baae24328d16289f.1562252534.git.joabreu@synopsys.com>
 <20190704173758.6d985aa3@carbon>
In-Reply-To: <20190704173758.6d985aa3@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42786008-6f33-466b-b28e-08d70095fb19
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB3367;
x-ms-traffictypediagnostic: BYAPR12MB3367:
x-microsoft-antispam-prvs: <BYAPR12MB33675D4368EC54F9BA658A24D3FA0@BYAPR12MB3367.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(51914003)(476003)(52536014)(316002)(54906003)(14454004)(6246003)(86362001)(74316002)(110136005)(4744005)(229853002)(305945005)(11346002)(6116002)(7416002)(486006)(5660300002)(7736002)(4326008)(25786009)(478600001)(76116006)(66946007)(73956011)(66556008)(66476007)(64756008)(446003)(71190400001)(71200400001)(66446008)(3846002)(33656002)(2906002)(102836004)(76176011)(7696005)(26005)(99286004)(81166006)(9686003)(81156014)(53936002)(8676002)(6436002)(55016002)(186003)(66066001)(8936002)(68736007)(256004)(6506007)(14444005)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3367;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uXds7R88Cy2zSlUc0TTSr1kVU3Xh1JbCq4yiz42n6Anwxgw3s5a4cH5+Y2u3H7PsGTKwUaI5z1Nwr56wyeiyTtDRcc0LNdq/tYbER2ixqpS4WfFuh9JO95BHOFA//uh1UrbDeHI6tKQF4TLYv/eco1MYHObdw48Jb/Ddd63oRe1W+xbtLyJY0VN75vTEpsLdmq4Ut0q08/zJ8ZBCtElXbMBdVm7ULDtEG9xkpszMGgpklgWwoJNbXlGCFuRKteRFb3CFAvlQHNaulLztVpydR9BiFeeIe8oSYfONL8sSXQPGX8t8CL5lt3dOazKtOBALYjLgo99MeNevxchqxZ9yJGkLY4OHo/wN8gQo2F6FOQTiGNG5e0Mh0PGv+0w+P4FJLO0zl/5XVbdRj4Rr/ajvQvqePB66D4mKa3V0xlC6Xyk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 42786008-6f33-466b-b28e-08d70095fb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 15:40:45.7597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3367
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

> This code is okay, but I would likely write it as:
>=20
>   if (rx_q->page_pool) {
> 	page_pool_request_shutdown(rx_q->page_pool));
> 	page_pool_free(rx_q->page_pool);
>   }
>=20
> Because (as you noticed) page_pool_free() have some API misuse checks,
> that will get triggered, and thus provide a warning of you forget to
> update this when driver evolves.

Yeah, makes sense. I will update and resend. Thanks for the review!
