Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39491284B0B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgJFLn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:43:29 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:55392
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725947AbgJFLn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 07:43:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZX7YqrfjiOMHhe/1DkUHNMsACcgpdFwX2HbYo8RavhPP8xSlXhQgWlSxpI3/GpMQlgkl5z8iuUfkZdPZntK9b8gRWQjzNfZmVlh6WVPYtS+xrltiI93fAsClj1IA1EHA7wvFZzchmf4KG3LtMjCxWyBV+NdSynOxw5XEw2uUjwfPebpIlLylt7cXsqyahaqMhcAGOms5/1tq3ecfVCbKfK+8B10f3bTH1re+wAaZr81zL/tN59ltJE9RZ1yPr9+yRX9gm8DuQQH9eYoQkrWO9ea+6lrXPlS8D8pCSaHKCtNSohsGj+85j0PArGnv/h3Bbs1C2KOMuZ812EcqUcz19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zlnmm3DWnJXqqvzJtR6br1hXNaZ9tTPQv9VeDUm37TU=;
 b=PY4AOuAOubjt4B7YiW67ByipJScQuukFWC8BAtI+Vq9EVMjOHr2iGRAaADLyL5vMXh0Nb/2tSQuKcbN+l2wyw8/6G33YtkVHwe223g5t5O5aiKKBo3+1RbuH/5Xb0ucLPmto9WjjPbTFRyKby4dRKjk8GTr380RPA8aO0ZF0a9XAGa4R1g5W9sfNzD0mt/6nxMcdjhX6gP0+CTWQ0E8Dvc4liv06aOAAuJcqoPgiz6ErA8wryn7c8vGDKkL+0QvU4VkobjKWsDm+7uRQanM6XwFJTvvlBJji65fo5BYqySTDk6r3N7lufwH83ffEQOzCOmnwuvmb91A5cpqopbeAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zlnmm3DWnJXqqvzJtR6br1hXNaZ9tTPQv9VeDUm37TU=;
 b=T0TjppMBTlCfdVLH2YLgrhVy+3wE9PQsD4PKOiRx0P+SrWWO8YXCrqivJNsPY/OjJAkwx0Y1jz7qr9TFYY29uQitcsBuWcWc6PoNNyu65SArA/6OlPqPqxSd7dOGIVODymqdzUDeOq4L5cw8Bxj01feUdCBR+ZE2fJvMWt+haX4=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Tue, 6 Oct
 2020 11:43:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 11:43:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: always dump full packets with skb_dump
Thread-Topic: [PATCH net-next] net: always dump full packets with skb_dump
Thread-Index: AQHWmyajuY7XLNsKGUiuu//ZVVgxHamJk1IAgADefYCAAAOsAA==
Date:   Tue, 6 Oct 2020 11:43:23 +0000
Message-ID: <20201006114322.aq276lij2ovhdtts@skbuf>
References: <20201005144838.851988-1-vladimir.oltean@nxp.com>
 <bcf0a19d-a8c9-a9a2-7bcf-a97205aa4d05@intel.com>
 <CA+FuTScXC+t_sETOTCvjrALCmq3y4mrcX8CxyFBcLyJk3XH4Rg@mail.gmail.com>
In-Reply-To: <CA+FuTScXC+t_sETOTCvjrALCmq3y4mrcX8CxyFBcLyJk3XH4Rg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81d78672-0ff6-4e70-ef0b-08d869ed07ce
x-ms-traffictypediagnostic: VE1PR04MB7327:
x-microsoft-antispam-prvs: <VE1PR04MB73278C62185B8F97F31AE86DE00D0@VE1PR04MB7327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +mEGgSSlzXc8en0Fl/49YAHn7rrsUyvGfB+Ew9badPwDRQgU0oP42dSF/x+WZgxe4Z4uuPKyEyFOgdARC4hU/8FHfNqNJxlwgSpeqkKx9l7A2mmzuBfD6uyaz4DgQcPajIFW634fBZrn1XblX8AiXgMB2mw6DLQbkhS+fSLME3M2246Rv/CYNXLl1t0Ko9C3E/l+4L0n1DwthkzE4vOX13X2f/55bAEUyDfnBqQkrer+Au1ByyJR0c0GeR/vsFBiYfoPaekaNKJ4HRWp/zd+2Juj3yB9yhSAja6/PkbDTub27Hf91Tkgj9osl1usmFCF2eB8jdIEKX/6Wg7dpgx65Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(136003)(366004)(396003)(376002)(33716001)(4326008)(2906002)(71200400001)(86362001)(9686003)(6512007)(54906003)(5660300002)(66476007)(66446008)(64756008)(66556008)(66946007)(6486002)(76116006)(478600001)(8936002)(316002)(83380400001)(4744005)(6916009)(1076003)(8676002)(186003)(44832011)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 10PvL3taFkoWLFz/x6iqH8H2Zl5CSUR1ZMZ3qeinb7FQ4/gKnw/RGtXWiXz3KaqIHIFw83F1hIwdPKLdllYhsdtxexj61dYhinQTCzK821KuwbokMS1tYIkDUF6yQ1sl9ASfwHR3wbj0IXHcgvQpCm9UmWfFe4pN/HAKVAVtUvppOH2awEZzupxxO2vRaKGXJLXyPondsjXp3TeAx0qD1O/Iw7X/RWzFozGA5FKffyfK59bB7kDzNG4X642Tpu1QR2xEpBl69PIedwnpiNt+aomV3xICHBdqNojUS96KlDI/QkP38KMalaA5DpOGRepdcSiRGKo8HUyKlfzEf7hkBOEbfw/BX56FJFlX1SXEttVp6KlfhFwZcq+4YK9VvCq6Heb9xFKioxAQMUc6e8u7kGcFZWPJag6Y9QCu6vtV7eCHfy4nfhykolpcVPoFwUVKPZkKba6mX5FjT4yAsDhu89Mi0rZblb7D4450Bucc66UVTZCP+f61HhAqywdSQmQtOS2vGZBJ2HgRD7Bgm6OynwNlbV/SFcq4DjsIEBCpjbz7HAHo9YCusZVFniSdP1jV45gDSm8/5re6ilOGPFbkatuuU4nN8fSkJbyrFsIuoBgJkdjrwkcW9m6/5SQewRUJ1HuZHcdnRu46JAQL2PDDlw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D738176FC6996478D55A6F6CE1EDD31@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d78672-0ff6-4e70-ef0b-08d869ed07ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 11:43:23.0973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S5leTCmNFAgTHPxU5keWjL+weU6mSKk85RfMUNsbdtoFBf24MTk7/IIFoP8JKQJ3ttSL5uc1bGPe7AnA/YsDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 07:30:13AM -0400, Willem de Bruijn wrote:
> skb_dump is called from skb_warn_bad_offload and netdev_rx_csum_fault.
> Previously when these were triggered, a few example bad packets were
> sufficient to debug the issue.

Yes, and it's only netdev_rx_csum_fault that matters, because
skb_warn_bad_offload calls with full_pkt=3Dfalse anyway.

During the times when I had netdev_rx_csum_fault triggered, it was
pretty bad anyway. I don't think that full_pkt getting unset after 5
skbs made too big of a difference.

> A full dump can add a lot of data to the kernel log, so I limited to
> what is strictly needed.

Yes, well my expectation is that other people are using skb_dump for
debugging, even beyond those 2 callers in the mainline kernel. And when
they want to dump with full_pkt=3Dtrue, they really want to dump with
full_pkt=3Dtrue.

Thanks,
-Vladimir=
