Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25F9680D1F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbjA3MKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbjA3MJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:09:22 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367BC36FFE;
        Mon, 30 Jan 2023 04:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675080529; x=1706616529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=KbR/lfydZ23CYXeHpyzUsM+hocs4sM/ZwTXBmcJKKvotYSolM1OvdCmB
   vOXSEEa8okYUAGNEUl0FDVixabqYCid7pOcvjYI/CXDO04pv/CdprV5iJ
   lMOaDWGdFAYlX5hJrHInxKAFtnfjx4w3cuxaJGBz0/gETNlun3yGrRlyP
   Eimdm4HpVse8TjeWN08L3RhNE0IP6Ijsm0KG/FrpTzCDnIkv2uw7FzP2c
   AmpdnxDY/8E8pNGL2W6+dt12/2C15m4h65/+GnvIssG0KNFO/S0KRWu46
   jiRbRqVvhysYAoL1yBxWknAU3SuaiLOYov+ITUNCYH00dhUAGTsJzY2l8
   w==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="326368003"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 20:08:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkJ7RMQaqQefxZwfLTEzopZZkxb/OXdVmitxRPrJ2oR1ep3J5Uq6VIirOtxcy2PH2H0zQIJLxRAxnT0glnuYYFCFoIxZdbtmRbRXg2c8+3vMBg4sSWCFkMGcAR6SF5lmaDvzLPeNrshjkdSDI1lL9ou2dx5qkNsT0jQQbeX4FmDfjV4E6iRPmrTFhFbYqgBMobXwG+N2Sa1ae8nn2iFtD6vc1P0HKVIMIrRCYYhbru4fMj0vvix8awTlt1ZJIeQmPZmVDn09CFBvcEfxFa2J9cV4KMHPHRnyoN5gCb2Q6jvVS/eKyv3P5Y2BXEPlItikzaXwwcQvx1KrJrELLulyRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=JnnVZIrpGaTP6OCIecs4b/lmyjhINrZXh7BRoHWKP8br2JMLPzq04T2AffF1VgPxE3hZXegcpzdGaMXFz61DuQgiOYWsUmbp1XPQTIIVB1oXZCU9LKjRgKudZoItt2e2ZCmBccawWJ6YjTs4u0RQOw2qzLq10cZzN8krazsbNHlqQ4qO9y6azmaKYhR+lS6E43v/wOoo4Qkw7Hjq8U0w1TUI+JELQZm3z+eN8fxjidtXg5Ti2PaTYgkvy332H9kx3lSYjNHe1CR3QAiq2Fzwo783N4TxMnCc1lq9BhW6FcUUefkEI9xsmdTYEGHiQdAJkJzBk9THrewMgDcrpgQ1eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Uvn2aAlCNLhVVWWUcoN/cJAYNWzke0WWpuQnjJzoOiMKnpZ5LJCdpbOtaUSs5HYehSLii4B95h2b4CJ/PhGOZULDclg+I+3p4D+SBhkDw+TyXWlcIPY+7ah5LAyHmRkkTWqnBZZ9lfsZHOpEcu98xJ1ttYgziDqnNX9LKXEDLjg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB4428.namprd04.prod.outlook.com (2603:10b6:5:9b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Mon, 30 Jan
 2023 12:08:25 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%8]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:08:25 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@lists.orangefs.org" <devel@lists.orangefs.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 03/23] block: add a bvec_set_virt helper
Thread-Topic: [PATCH 03/23] block: add a bvec_set_virt helper
Thread-Index: AQHZNIypsthvuWwwq0qVmHmpsAvlka623gEA
Date:   Mon, 30 Jan 2023 12:08:24 +0000
Message-ID: <cf45cca7-87c8-f1ae-70c4-112179c235e9@wdc.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-4-hch@lst.de>
In-Reply-To: <20230130092157.1759539-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB4428:EE_
x-ms-office365-filtering-correlation-id: af119cc6-e9e4-41c5-41d1-08db02bab05b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lIMWjCzoDPbfgwj9CUjCo2sKGDktE5sh1or1e5F4goaW1YHGDPMTME5OZvj+Wcp80x/alslEWvP2jYNMcA6Tq4O6tyHM4MOWGw+/Y9ZL1T7+NhOBFZUZxSCsOZmAy4IpN+KKFuJYGvnG931+bJbywwAa0cLU7o2zOwHwnOjDRCUFk3uAgWD0BtIwzUI/ZV7GZzN2J8x9Hq4EsH2FjTOhfDIQSQ+xgrMJOG9WwRbO0RmH0CIPsJ9Fot4EcNI877wNFL9SyKsacBCWf38W8PidaMn1fLz0zbcRAYErnDPKy/OGU5ivLhdFgUksRLWSJIbcQAoxF96VUpeyXwLmDJqU3UmKwZ7YG1VWun+Ru41n01MlodDLsb6TFyZBCJ5XPYlin82voUMDXxQ3ADrvrmTL0xK39hqUPqOxcL3HvD0tU6m16pML+5lXFG/QqzXetN83JYlRMcTs7hqRNuf5NvlYLtZWgkrlLphJxqtSBrGUqFuHbEMYEsjuJ06X9CmuLv+JnKUQ1x3TwkPpoHSOkpSdU1Ra50GkUie2dIdOg9o1wGhWMj4pA/d4uzgBsw1iUas6f1xK0cwJ+/mpqa6m50Ks6a1tC7IKSobxQQWaUjT1Fer9WWljZriZ5o30NhHc0BwCrNRXf/usXScHyO17X9J2FYzWlgOpDAl2q2uShl29KPbSYrslpgb+Q+UQUfauxA9BRmHIaZTIUqj20KWjEuGkBZr20u17vJ7cz5cWdG+DjTLsFa9LLsY/hF7UkQTbNLVHfHy4LNq4M5hMoGsDxWruRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(31696002)(558084003)(36756003)(71200400001)(8676002)(19618925003)(6506007)(6486002)(82960400001)(41300700001)(478600001)(66446008)(76116006)(66946007)(110136005)(2906002)(66556008)(66476007)(7406005)(4326008)(91956017)(316002)(8936002)(38070700005)(38100700002)(2616005)(6512007)(54906003)(5660300002)(86362001)(7416002)(4270600006)(122000001)(64756008)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUZXQTJkclZHSUdmdEQxaXdVM2NDUXpic3V6RTd4K1I5MEROajJjK0w0Ujdn?=
 =?utf-8?B?WHlWOGFyM1hNVHBjYVhOSWhaRkt5Qm1MSDFuRzE1YnRxTHcwY1MxejVUODNx?=
 =?utf-8?B?UWJFL1pUeUhRT0ZSMllmRjZ4R2tmNFdjWG9ZRUxKMVltdjZ0K3pUWVVPbUl4?=
 =?utf-8?B?U1RVZ1JjL2JMSmJiOXIwL2FvNFZKSXdsRUlXMWROcHkrc3ZGMlBNWEhHckMr?=
 =?utf-8?B?Q2dyZmh1ODZQbkRHWkJuVlV3WUgwUVhhZVE1aHBUS2JmQS9qYmtuOGczRk1p?=
 =?utf-8?B?ZnJPQndIZ2I5c05FTGpIQWY4dWFQYnBobjdFOHVJcm9LVlo2c0FvWXhjUEV3?=
 =?utf-8?B?NEcyUU5rVjdSbll6a2FYcFFUbUlHQWhncUFjR016MUU1NUNPY3NPQXpZS1RQ?=
 =?utf-8?B?YkRuRlUvSE1YcW5qS0tQUDlMdHRsWXRDdUlhemhmTVFpNEtjK2s3bFREV3Js?=
 =?utf-8?B?RHZScW9ZVTVINmNxdmJQQVQzYVZLMzdMbjJXMG13RGtZZ3RqVXhUaHdleTNS?=
 =?utf-8?B?d0xTU0dKNy9OaGdyVmZQMXAvUDNmMmIxMmlvUW80STYxc1NDbU5QRGM4aENN?=
 =?utf-8?B?OEVnbEF1a082cVJCck96UHBzNGJNY3JXZlM4SjdEYkRKcXRTQmg5MmUvUE9R?=
 =?utf-8?B?MWNTcGJISUtGdDE5OENIU1d0TDl5SGZyS2ZTNVlrRVlJREJGbG1NQWI5MHcz?=
 =?utf-8?B?eXN6MmJZUE41dzlyZTlON0pKRHl4eUVyeGtXNUdOTXl1TXlmUUtnd1c3QVNI?=
 =?utf-8?B?MDhFd0FieThJZ1dKQXNuWWxqengrRTRlU0d4VWZYbkpBQUc0aDgzQTVCNUVF?=
 =?utf-8?B?UGZSaFlsVzU5cTE5eTN5ZnNnU0VRM2F2aTYwOXA2UFlBNW1NZTRNTDlHWjVT?=
 =?utf-8?B?NzByTTBvbXVDc3VGdDBGUTNlKzhRN0JQaStUTFl4a3VmdUpxcUVRQTZBV2N6?=
 =?utf-8?B?V1JjYktJL2grdzFLR1ZwMXhjSU0xNHVSSU1HVXlnK1VjYm9CeCtZbVVHZ21T?=
 =?utf-8?B?blBVWDkyRTl4QjZBZmZzV1ExZlZ3TXFzM21jQXdVK1lHREdTaW11VGg0aW5G?=
 =?utf-8?B?UERUaUdxQS9YN0JoMEZNV0xJRmJ5ck5uKzRUcTkrU2NNLy9ocjVYZWpCR2Zt?=
 =?utf-8?B?bXlEQVNqZTltSFlrM0pzNXBzeHQzUWpvUjk0WFVjNjdhYktZeXE2MUhhaE90?=
 =?utf-8?B?aW1rbEcyMUMzSEVUTVphaEVSbHM1dzFaRFBRcEFOa1l0cmg2ZHQxRzcyOFJa?=
 =?utf-8?B?c1JtcVZjamFWamtGbG1TUWZrYUtueUQvTDhBZzU2V3dLWng1Rk91aHJPQmMr?=
 =?utf-8?B?dEhkTUhqb2FQVU5jaDgrTWVic0w4QnNIRFY4L3Q0Y1RuZm9UWk44ZjlOYkFn?=
 =?utf-8?B?SStlWEc0V1ZSb3Z2ZnJoZUtVcU1Qb3BwdFlUdnJpUFhEcU5HZjAxUzZnN2VP?=
 =?utf-8?B?UWpZaVV2ZDBGSVlqV1kvYnFZZGtHT3Y5eWE3S2VOMEw3K3cvTnVsalFQZUVs?=
 =?utf-8?B?Sk1WcjQwajREd0NaZDQ4YnV0Y3ltUXF3cWMxa3hTS2NhYk41bWo0a0VPZmpx?=
 =?utf-8?B?Z1MvdDV4WjE2dTd2V2RrNWNlTkZLYUdJRGN1c1ppQlJ1ZlRjcWI5dDVMcGJw?=
 =?utf-8?B?cDJkQWd6U0ZDcHgveGRkNFFoMkVVWW1Sdk45RlFTK2svQlNrQXVDcFJiV2xw?=
 =?utf-8?B?dHNxVlB1Mk1uTWJoMHFKTHhSdVZkRzc3bzFPVVAxVjZOSVNweEVwbzByOXJ4?=
 =?utf-8?B?TSs5TWZRelBtb01KcThZanNoS0IwNzdSN0s5VE5maURuYWRBdXZvbEVFbFNu?=
 =?utf-8?B?YnN1R2wzUEdVS0libzBXQ2pmK3FsRURueUlRS2Zsa3l4WXNQVXh1M0lCUnc5?=
 =?utf-8?B?N3lGNEZzTDdVSUh3eXFNZnUvTmcvb2Uzbk51OVN2bW9OQXVac1AwSlRRdS9l?=
 =?utf-8?B?SmttOGFseFZCcExMejhTZGtMaDJsOXB5TWh3Z1Q1Qnh0OU5WUDZiQ2IzT2h4?=
 =?utf-8?B?b21lRnV0SVMxajlaZklTNTBxcWdUVVMrL1dzeEhLTE5tRlh5dURWMS9XaEha?=
 =?utf-8?B?dTQyWVhEalFoTUNLWWx0SGhNSXlpK2tIdVlzSUtjWE1ZTlZYcHorSzBZaUlr?=
 =?utf-8?B?TUI0WEl2cmdVQUxpcFZKeTVFdGRhcW9IT3NqSmlBc0tRNWdKVHhiVnZhSGJG?=
 =?utf-8?B?dFhwWEtGWjNocm90YWtwbjVNdXBHR1liTXUySTRlY2VyRlJReXlKVk1KQkI3?=
 =?utf-8?B?OENxRzlDcmRXUURVc2JiaUg3U01nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72D4DE3A32A11840941CE7639084935A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VEhjS1RqZStuSW8rM0lxSjJoelBuOUtWQ0hUQVJtT2UxTkRvZ2tybDN6ckxt?=
 =?utf-8?B?NFpWekppNlYzeFUxMjRQTVBybWo2TFFTY0JzeHZCVGlkZ0sxL3dZU3ZSblA4?=
 =?utf-8?B?angzb3o5NnFoNjBYcGpScnhqUDFLaDUzODc3QkdEeTZFSmRpd2dCTTJxZk5y?=
 =?utf-8?B?VXJjbWpRNkJMSmV5ZnAvODFMb3piTGk2eUdZaGtTelNiaHJuMkR4emhzNHdi?=
 =?utf-8?B?YUxhRkVOTmYyUGdTV0UwdjdRMlVzT2p4anFMdmozVzFDdDd2UDhhY0RUVVdh?=
 =?utf-8?B?YWlLUCtleHNBVm5UZHpOalBaWktRRjIzVEYzTklmVDFDemRpN2VOODB6eVRK?=
 =?utf-8?B?R08zN1pDbWJzcmVta1Y3OTZjTVJQbHJ1R1lueEF0cGkyZ2ZseUZkMFhUa2JF?=
 =?utf-8?B?ZHZVQnVSZTBVcnJYK1FTeE5XY3FETlNPeTZYSjFVTXU0a1dRMTVOS3FGbnc5?=
 =?utf-8?B?WWJCM1lPVThmOXhVY003TlQvTEVRaGpqRXUyRUlLbGcxOG4vMUpSMDJnRXRz?=
 =?utf-8?B?MG1CZ3JlVXRCa2NGbThxdzk1MlhabXo0RnIzcjdMUkpDaDJLdkRuWGE2UVQ1?=
 =?utf-8?B?d0x4MllGbHR3dE1JQ0NxeWxTckhCamY0M2I2WGZYdEJyRFh2enROUHlTd0FT?=
 =?utf-8?B?VE1rd2FUdkoyRjF3QkpJbVJsdTFyOEU0SFRjYVdlY3lnZk5HMDBCdEFSUHlM?=
 =?utf-8?B?Qk1UaWlCQ1FvaXhrZGN0WVZTSVVZdmQ2YzMvQXhobmtBemFUWS9KdkIxc3pz?=
 =?utf-8?B?MEV2dWdzcm83dnpXcmtuTVNjLzBHMTZoUWlMZGFKK0hLai9xYTdvMlR1S1Vu?=
 =?utf-8?B?a1lONjVvOXV2c0h2UTJvWmZ1T2hEdE5nRVpLcTIrTmFrNUpUTHg5SzgwR3Qx?=
 =?utf-8?B?ajIwaGpWYUlFbk81eTdNV3QvQ0txQTNmaGtBM3lhQmlFc0d5VzZTYlBkQ01Q?=
 =?utf-8?B?aHFJeWVIUEliZ2xaL2JYNlFoNkRNRVEvSm9uaTNuNy9OS0cxc1JxT0ZFblpl?=
 =?utf-8?B?YlIrWk5uVmxJT3B4S2hURUpFVkpLY1E4Nmt6YjRFYjNuQ011S0dDQXZlMGFO?=
 =?utf-8?B?WXY4SDVsQkZFVTF4UGI4Yk9zT0FVQlpZZEFYYjQ4UEF5Z1BGV2NscXlGVjB6?=
 =?utf-8?B?UjJla0hxdXY2aDdiSGRPNTRJa29ERU5ZZzExRDBDc3UyaWRGK29DZVVpN0dv?=
 =?utf-8?B?djhheG5DbkRscnl2V3FPejFiQ0ZxOWRwdURMaVl0NDk0bEtFUWJaZEV3T3Zz?=
 =?utf-8?B?ZVN4dnlSQ244eWtjY2xaZVg2WHdIaDBDQUJXRkR5ck5ucEtqekcrMlNtOWsr?=
 =?utf-8?B?M1VibGJxZTArVnJ3M01xajQ0d2F3aUFBaXo5T0hxeEEzYUZrOW8wYTFnVWkw?=
 =?utf-8?B?akE0SHpWNXVyTzdOOCtnNGExdWplQ3hoVEwvREJxd09jOXB6WVR3eEhmdC9m?=
 =?utf-8?B?c01yN2dvVnZZcElNT0MwNkxQY2FBZVhUQkE5cXMrcGpBKzFMc2FLYTg1dlo4?=
 =?utf-8?B?SmlRWnZWNGtvMW11YVJ3UXZiTzRrczB1ZnFhOTAzU2g3THFBYUhXQThkN1dF?=
 =?utf-8?B?Wm05VXM5dENlZGYxMVhRN2lRMk04elk4N3VhOHUvRkdFUnk4Sit0VC9nc21j?=
 =?utf-8?B?QnVueHI3cGt4OFcvQzNyWGRMN3dJMGFiMlU3Z2c5aHJsUkx6ZWxJQmxQUURG?=
 =?utf-8?B?VXdxR0F4bXRVKzJucXlOZFRDOUdlZmhPME1LdE1tZGcySk4vTW1FczFFTWJG?=
 =?utf-8?B?aExUbDIvd3VmdkJ1ZkFWZ1FpVWNLWnhCSDRWNXlhc1RxYmlXVERvcExKNFli?=
 =?utf-8?B?R1p6VlprbE0zZTF5dnUxdlMxNTQwMXVnSlNaUC9sdktTVDlNWG9oVWVmYVdo?=
 =?utf-8?B?alJ3WHU5emU5ejRaL0lPNklPUWhOSW5PU3QzOGRWbXpPbSttWG8xUGF4RW94?=
 =?utf-8?B?OTEwNGxlZXo0a3VudXl5WHN6Qzc2UnpTZWxaR25QNEZGZXVab1hpdnpQRmI0?=
 =?utf-8?B?cjJ5a1l2K2pSYVJsTXRxcm4vUWxhUzRPOVBGOFpycHRlOUtpSFo0RmN6UzNu?=
 =?utf-8?B?ZyttL3BrVmwrVERuVW93Tkc1ZFduOU0rMnhOQT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af119cc6-e9e4-41c5-41d1-08db02bab05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 12:08:24.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kvznE4GlC6mzAQpKuOKFoMhnBDlGLrR4x3obksyA9sxWPJwhwbeshU2Bzl9FId7DivEnJQIK6w9jRmyUOp9xX3kC2wKWWa2O9NJR0ZbXS1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4428
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
