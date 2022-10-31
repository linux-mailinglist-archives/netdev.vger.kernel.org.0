Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F565613D29
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJaSNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaSNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:13:23 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0853160CA
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 11:13:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgltKoHREvpsEKcoxSKHXdXWjwyM+qY2ydhXvmDzrvJJSkSx48YUZ7MbWkqDVN2E6H30X2m0duwDspPd5Pw8kxQ340rPFaCK5Xg5xtm2tOUNSuTeZNF6RWSSnqpA45hwih37mToBuyV/Eh+gQdfTdQzSdaDy8/LLP0GZ7/n73EfAg7aX0VTUuy5cJRDqUEAlReInXWbOv5sqARVeiXFjBNJOIqU5sozSNrdGRJQ1JDjKHmlLlDtN8sg7tv2rS1BbpQ6FPjy+ig+8XqkC7qbrCg/fRoAMjVgAfxXuHMQegGviphERxh1DzNOEPhVcPjs7RUOPw5BiQEQOLE7E0KH5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndxORlzTz5t1qNKGx053hqqNcAdzDuWF7rS+mGGfJ/k=;
 b=m6BL7C8UBbmIP0+NKYFMpZuL+mNik+l9A9ewVTHuEp58KU1Ojco1F4VHeup7VgG7OjuQyal1EkU3WqdCCLo+jwlrMZI9xP53Gp5QKO+w2c4sDYturIh9eD3Pbqj/f8BcCgpOp0esUxv02ifjMRzjEMFp4XRR8+Z0Z9hmAmgVmKW979WcuPbpYWtvIxAKfoyPp2Hde3bX6lj/uPXW1bYUBu+UuXz0bZ5mUtwAWO87gNvUMrFmSR4M/5adbUX9u/lOwzSemTpLWPu55VeuklyBrcwEQlEPQKYjuiUv54Gv1zJot1a+bhMwFWb9Uvjb/nhEXhv+LAwq/jKN62Y31dWhdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndxORlzTz5t1qNKGx053hqqNcAdzDuWF7rS+mGGfJ/k=;
 b=o0kRcwZhbr4hB64wfimSF6OX18wU9Cu8e9AD7518Qxngx0kQd7RAiESCpvNumReskYuY+ZEcQkaIbr2B315pilIB05IlFshNYITj8404uA5t/+pIC6CGG+ctDnbans12dqpk79jd4rIV+lCz7ceDgJZKrucQkE6bn5lExUuxY/lxS8d7hd7X91UqlS+VP5H0WZSEzBVGNVf1MrPI0Vfi52PrVUUEAzqCo5Kt5LcW5R0BICNLaWT5oG5RrtNvrKaFXoENietmP6d747j6gyc+Y7C6jO8OlGE0fS29jKVOJJS7CkMPjw/Y6+O4Ks+5dGynXwE1VYhlHhjzMOYvwUrh3Q==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 18:13:19 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 18:13:19 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHY6HobywKcS3CUh0e9rdSVQmztBq4ftFCAgAENjtCAABwdgIACt6KAgABgg4CABN6FkA==
Date:   Mon, 31 Oct 2022 18:13:19 +0000
Message-ID: <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221028084001.447a7c05@kernel.org>
In-Reply-To: <20221028084001.447a7c05@kernel.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|MN2PR12MB4189:EE_
x-ms-office365-filtering-correlation-id: 9f0387c6-25a4-44e9-efea-08dabb6b96f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Euh3pPqkLgsXF+YxXaveMiwCd/GbhN/0jqKtTvKddP2z8lDZ8Wf7zqnZ5Avw+QpGs4osuQbjNb5tE0wcH6JseIevfqRtu0XIbVGHaVu3lIaX1bbll7HchUYELYxwz/sdXIF5aXcpPG8Wlk9smKS8Fm9P5JetC2M3QUteEYLua4fPzZLLVYP9fHkC4mQWjjG+ofYLuS+bmEnPew4GuUOVrJfhN42fCUUhQ4wg+QcoEaCDdMNYMz091Mx8pxZY7WAyBkI0fc2zJKR0OwYdY4cLAty/T203bvCvmuIGuFQH2u9RYICkwHuWFAaiv/4qO8zMcD+9g7em9bdBpdz24u4IuiBLI/x+UEJoax40bESoCPgvkRQEV3p0pK661GI/zV3hyJXR1c0u5ITmy2h5phw48yjfV5PPRWVSZrtzrK1NR6wD75enpR8iRaiNZZwKVShhEu921yETZtmUt5YC/EHhM0pjBuB40TA1c4/bUHrpRQG3Ouc8sw300PyV+ghxhrdJPBg69h976/6puQE1p/WYW4ciVGXqSOu6MbkjYtqHampju1E+eJEfwu4egA1QS3uFz3ysc053lM8MWXQjhgFTl3bHOK529WqjNafNLRnyeTC0WvM4pzq59/5ZJSuE1Jv3BjOPr4bCML94t3ZB/7YWCOptyK4Ug8R4S8NlDQj3+zQZXn5KmYZWuJEdYbOghUWP1V4IHMhBJrRIt7PBLRzwWPYiqqfKJYSQDnRkS1x2fD81Ic07qsz4ayA3tulo8AmyeNnDgR4QytVCRegxi6IsKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(122000001)(4326008)(66556008)(5660300002)(54906003)(41300700001)(186003)(33656002)(55016003)(76116006)(2906002)(52536014)(8936002)(26005)(6916009)(7416002)(71200400001)(316002)(66946007)(38100700002)(66476007)(7696005)(6506007)(9686003)(64756008)(8676002)(38070700005)(66446008)(86362001)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?od75QzhnOe6stk29TvCWoZpMjE9b7ZKsugMCaIbKCGe/DlKG72U8brun5Dl7?=
 =?us-ascii?Q?II7hFWaH8uY4sqIg85L4KCx+mvVJsCtUEP1MssEdfaGX46wGuUrQHhNrrXKM?=
 =?us-ascii?Q?OfmYqI6t25M4trXicwjfuBCUOsURRmo3KaLks/9ae4L4eYQY/UTfXpQ8yBle?=
 =?us-ascii?Q?zacIdeWaDRM9dU4Qfzp9h6pneaP/iUNAnHOzuufT/oZFxnEhPzy4Nw9o+gvn?=
 =?us-ascii?Q?9lnxffjy6X5bVODFGFWxsXyM53leyv+Zz0QTOAsItS2ucqBHFeOCd7P6Ghcu?=
 =?us-ascii?Q?mik5QFnycW0ghbx8pBIZTRSGsI+gGgWp2ADVdHSpBdzPkjocJ5R+ujFPSqVd?=
 =?us-ascii?Q?JWvr6IobG7SfhsNEhhYpgGfaaKPakQdJ/3dxI49pU5NYHYzMoVGpVEJNSQ9B?=
 =?us-ascii?Q?B1qtlBt6MBPXf+icA4lYK7Grjet9l4QT3jYPsHBvbI86T3K/Pm7KVaVEBQue?=
 =?us-ascii?Q?VRjCG6eXrmFA7apyDEHm/csKMInLycFJJ3g1B4z+vC7JGXueEKbsirZvHFKo?=
 =?us-ascii?Q?rxORTMgl2cok7N7X4Jniyc12/VhCzvXzqal3pwV4zA01al1bvGGWVNnZSpmq?=
 =?us-ascii?Q?m1qaq4K1p9KisAdZfhmvlbqFQ5QOUmP+MOQdbFrsTpBh9vDFUU3Nu1B+xNV5?=
 =?us-ascii?Q?x3a+atc5TDPCjOUSsSwiJApYG/mRkJFnycEcOQ0H17yc4LKswzqZQoCqwkKg?=
 =?us-ascii?Q?ggku9I3lUi7f63RdZJKaD5EvUl5UsLZx8ghDT4FUzADYBtqQiw9XPmuis79g?=
 =?us-ascii?Q?ua/fWLBsSzO43ap1GncvrGA472RlRWX9CLfA3WUAB6wozluTJGXGHfZ4J3wl?=
 =?us-ascii?Q?eQkWxnYZW3N3ayGZhW85R1himF5nQNguUWcdnjitMtKlKe86C7Eh400v8ClW?=
 =?us-ascii?Q?bsLf+KFppMB1P8LHbBOjnYQOEpyDacoutZecz+PPE8S8UVRJZHfCP/pw38T7?=
 =?us-ascii?Q?4N+36XzKF3OEolGsjVqqFWSvCkL352BxluZy/EXgtpX4X7x0qmbu6+uYJcnZ?=
 =?us-ascii?Q?Az/QR5zFuM/pcqx+ijC33bM5e9iuark2Iq/XqLY6PqFDaBqg1JOKah2LNjI7?=
 =?us-ascii?Q?iiPOS9LoyZPSH2EVgJQjICxau20L+Z7+sVTinEEsX8yJqWRBIxvsFX4RMDJA?=
 =?us-ascii?Q?cJNKCCaUr1AMdQPNNdhlHhKrYIgN0ymO+vWLOxTBv5juVk83KocPp1CBFvLz?=
 =?us-ascii?Q?rFCAgzKpQ97x5kM45eSwLy5JIS57AINIxnE0arKQ+htXgJzvi/+JUP9ZFkoK?=
 =?us-ascii?Q?kOBe3HIRRTW+x69aCTlhdwuxiStc9F8MVpcHmIg6hgyP1Wnk+0Bs/Icrz/Dw?=
 =?us-ascii?Q?zSpscJuU/QfLHMkrSH8UJxwC4ITa2kwQntmFSEe0J/3CcrZaiNK23nwx11z9?=
 =?us-ascii?Q?2tssA69ysWx0rqk83HDDhUP7hqPx+nui+OmCflpteNQTTwJeJDcVKcJ7FB1a?=
 =?us-ascii?Q?sSdNoYHapUqW9Or9PG+byMuYjen2dL6ZUYAiSBVTFC88O1pZwvxavs46nSxl?=
 =?us-ascii?Q?vCszD6gL5hDVutRJY5DkPoZIK8CLRMdOdM6Su/NCMNtKsFCyfYOjBB+izps3?=
 =?us-ascii?Q?6nMWgA6hxTbJzs9ugQ+MhSHWr97+ke2liKNyNuS6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0387c6-25a4-44e9-efea-08dabb6b96f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 18:13:19.4185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfDco8sOd0PLN+DR0sVd8QIMH3F4ovSCqxHOl1EWoJlT7t1cLu+UTIBnKnylC4K7Eh6LHdHrqm/JQCpfjvRDrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 at 18:40, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 28 Oct 2022 10:32:22 +0000 Shai Malin wrote:
> > > It's a big enough feature to add a genetlink or at least a ethtool
> > > command to control. If you add more L5 protos presumably you'll want
> > > to control disable / enable separately for them. Also it'd be cleaner
> > > to expose the full capabilities and report stats via a dedicated API.
> > > Feature bits are not a good fix for complex control-pathy features.
> >
> > With our existing design, we are supporting a bundle of DDP + CRC offlo=
ad.
> > We don't see the value of letting the user control it individually.
>=20
> I was talking about the L5 parsing you do. I presume it won't be a huge
> challenge for you to implement support for framing different than NVMe,
> and perhaps even NVMe may have new revisions or things you don't
> support? At which point we're gonna have a bit for each protocol? :S

The existing HW L5 parsing is capable of supporting NVMeTCP offload host=20
and target.
As part of this series, we introduce the host Rx and following that=20
we are planning to add support for host Tx, and target (both Rx and Tx).

Supporting a new protocol, or a new NVMe format, is not in our plans at thi=
s=20
point, but the overall ULP design should definitely allow it.

> Then there are stats.

In the patch "net/mlx5e: NVMEoTCP, statistics" we introduced=20
rx_nvmeotcp_* stats.
We believe it should be collected by the device driver and not=20
by the ULP layer.

>=20
> We should have a more expressive API here from the get go. TLS offload
> is clearly lacking in this area.

Sure.

>=20
> > The capabilities bits were added in order to allow future devices which
> > supported only one of the capabilities to plug into the infrastructure
> > or to allow additional capabilities/protocols.
> >
> > We could expose the caps via ethtool as regular netdev features, it wou=
ld
> > make everything simpler and cleaner, but the problem is that features
> have
> > run out of bits (all 64 are taken, and we understand the challenge with
> > changing that).
>=20
> Feature bits should be exclusively for information which needs to be
> accessed on the fast path, on per packet basis. If you have such a need
> then I'm not really opposed to you allocating bits as well, but primary
> feature discovery *for the user* should not be over the feature bits.

Our design does not require information that needs to be accessed on the=20
fast path. The user will only need to configure it as part of the offload=20
connection establishment.

We will suggest a new approach.

>=20
> > We could add a new ethtool command, but on the kernel side it would be
> > quite redundant as we would essentially re-implement feature flag
> processing
> > (comparing string of features names and enabling bits).
> >
> > What do you think?
