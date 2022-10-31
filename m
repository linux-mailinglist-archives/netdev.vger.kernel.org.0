Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8856138C3
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJaOKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJaOKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:10:36 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60041.outbound.protection.outlook.com [40.107.6.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F581057E;
        Mon, 31 Oct 2022 07:10:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3UbYpsXqc7DuZ1JdBP5MRrXj7UqLmDYqNfZab3gkPYbiG9D4vaXIpTqmexrSKoH+9Ei92ApnmCYZDfSVU/Abe/QXYmGr4pI1uVPXlpDpr40CN+A+SWrS2eA/wFuY5XRruA/DlFThrc9sDVzjK5Vtt8bu0nxgidW5SevcvbEWKg2vLFUt4njJAR4tQ0xi0RO/PI3CAVnGBzImfnuQm6XD9L79/D4vcvKtkqVSDMHxJlY8OgmdscD3iPYKctPB7z1PBx6HY7q4hIhUBgGMnq1dJCt9hDtfeW17GccKtFtq1MU7B1uhBNQXsXzUbwWs8tHhn3syHGqi/q/IqxnahHTjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CPAatWIEFl0KDjQnA6EY5fBe2V+xN+LHwYQXIbjRYY=;
 b=j+J6axOkhHT5/AisLaZLvTGM96GCNYOGJ5OOpsI5Pl2/U5bgmIE0XWpHMgR77WFOCjlNM0nPD6QSYNFg11PCTWzRBB00o6h+t2u1XEzPipngqbDLoVogyJKte8fH5227/WQ/btBQgj1WeT4MHpPTy4OCl9JYt2PAz68XUwhSnRaC/8NgSMpom2hoQoS7aKl4s1aAEHS0zHFssrjckR5dvyasyu3vPNt99S+p6fUbUaghyQ+Z4mJNJDcL+nXp6yBXUDhpQBvDhLhc2/i61ZpNzGXjiMG3ekJ8tPJ4bstcKW7ShqFrno3H6+b+ufVPA3Vk6RpU4hFyQd4kkFnm6TuStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CPAatWIEFl0KDjQnA6EY5fBe2V+xN+LHwYQXIbjRYY=;
 b=KdOiNayrtVsDbMo+/VSLZcZr7JFoc/4yP+mVV/zNiXreon/3seL2HCgkIlH5PRwRrjzbzxs5pFC755ikcQHQwDbOPNBXA+PaP9g/Vyono71RWv1WJRnxyfu5KbAzJV0Zl2ceNSRbaxfwpqvxXbPl2kQfazi2bJw45AOeJHl66P/thkFM96pzZczEBSbJy/lQ6rySOvgk+t2BQSl2FiG+NAKUgHhRUL0NrAkQ+HNdKpDn5pQmcxpKPyyDCJAsHYG1RzJThPftV1aOmY/Nn0VY8Iz0Ja/N9GhWOyqFgmdJFrh4skmHMNTSy9KKsVBGrP+8D/YYdSTAHY1lAGF0zQTfFA==
Received: from PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:248::14)
 by PAVPR10MB7060.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:30f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Mon, 31 Oct
 2022 14:10:32 +0000
Received: from PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::18f5:54d5:ca97:5a8d]) by PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::18f5:54d5:ca97:5a8d%8]) with mapi id 15.20.5769.016; Mon, 31 Oct 2022
 14:10:32 +0000
From:   "Bezdeka, Florian" <florian.bezdeka@siemens.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "sdf@google.com" <sdf@google.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Thread-Topic: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Thread-Index: AQHY6uYeAz+EpEHq20evdBlO5Pl8/a4kGceAgAALhYCAAEt3gIAAIQmAgAP9egA=
Date:   Mon, 31 Oct 2022 14:10:32 +0000
Message-ID: <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
References: <20221027200019.4106375-1-sdf@google.com>
         <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
         <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
         <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
In-Reply-To: <20221028181431.05173968@kernel.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR10MB5712:EE_|PAVPR10MB7060:EE_
x-ms-office365-filtering-correlation-id: 88890d52-b93f-4d0d-c6de-08dabb49ac6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TtHzk7RiLtMr6vhp22OvZc53IryuVgeEOXUFjwWW1P2eDm356G/U5I6lyyarDkjfzbKSdxfsdddzDBsqbyg+Sm5ieCJprEqzrj1S4p/mtSzv01cyr8VxCEYlMPDuo4kiIHbKcQfJ/Y9JEkFJ1zySMCZ4Fy5Rj3exmfJVNGcmLE3gCKj6cJ/cKJEsArymkTC3PUu3uaKfIc0uhuum9kPWurKqsLbwUzt+dPSDcDbRY3AqKkynhUl/N7InoAM/z0AoiM1VnzUTJcevRliqgiCdC2NWLBP5EYFvU3dlAdAjod0erEapGJT63mIrFe+JbSZ38wXlaGjEB8NGR3P7vm6kKUn5V4cVyt3uYIblOu8yqr3bDfa4scU/Qj2BJqvnLjK1YBkbnt4e/8PIjG+6XjfaU1o4MB4thIQmzb7BvHnO2MkDHXaPTKhrorFuepQ0W+NlEulDO8N6DAiHbyY7FG2PHoePb/dm+sI/rRFecIho/Wesu8MOcKtdRWKsMN6Hp1405H1nsUY4SH77K4HAaZ8FYeh7XiUAC8LXP0R1qj2TM5reKMn+jZPNYI/KYHYoeGER0tabpDJvuJOk1hEYe2o0vO76Tgb+30wm7ykl6Y0QYwI8HlWUpR5nshFNCj1FhL4Go4mZtMG4MVdBoF3Jf38UPXFsav/oFWpNGYzlcOG5bmmPl+zyLbUgDIVB2bdvKY/fLcZm9JsTizBbHmURru7+Ah3xLiqiMCxNWooZZVdcRVoZrnnZWy6FWjMvBpfG6gA+pIqSLL3ieQ1kKnljHLBh3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(66946007)(76116006)(66899015)(8936002)(41300700001)(8676002)(66446008)(64756008)(4326008)(66476007)(7416002)(5660300002)(91956017)(66556008)(186003)(110136005)(6506007)(54906003)(38070700005)(36756003)(2616005)(316002)(6512007)(71200400001)(478600001)(6486002)(4001150100001)(2906002)(38100700002)(83380400001)(82960400001)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkxOSmtyVTZCOGNHS2pXUUJrV3dQOVlHNUFuM0M4K2EwODdyQ1VwVG1kNk8x?=
 =?utf-8?B?S3Y0TE1rY1MzdVY2VHVpY2w1SFlEMmdPOHRZamJMaGhQcG5uaWpZOUhabjZ6?=
 =?utf-8?B?V1pPODhKM2dlcThNeHN6OUxqOVRIaWl6bDB0V1BmYnV0WFI0anlsQ3FTUTlw?=
 =?utf-8?B?Vmp0L2Y1OTlsV2xxRVNjQk9nYXpMcEZzUWtLWWhMeDRZMUlZNnhMWTRYTWdi?=
 =?utf-8?B?YUdIZEhqRklmUEpDY2NqS3JSYi9VaUZTSmx2RVNFcHkrVkJXYTM0VmU1K2FE?=
 =?utf-8?B?VW4yZlI5M29NSldjK3dMamxseW1GeXIxaHFQZThUYVF1UWdwTUZsc0krNTJG?=
 =?utf-8?B?Z29EcHNFZ1VkUkZHc2Rhb2pqbFAzYlRvSXYzbUdNemd2V2J4Q2RHak5VbGZW?=
 =?utf-8?B?N1h3VFFTTnJvQTRNeEpXdkUwTkkrY2xSaFBCVEVUZm45b21SaW5QYzBRbllS?=
 =?utf-8?B?eXkvSUxLSUFrckVyaCt2bnRicUIvanFqZmtOOTVLYW9sVXNvRHhNei9lVDBj?=
 =?utf-8?B?a0FkNEJVRXJxeW5hOW5HTFlwZ2ZGa2lub05xUE1ZM1JiUnNNd2w4MVVZa3Zx?=
 =?utf-8?B?a250TjZoRU9kK1FDMG9ma09PSFpZOVhGV1dOSWluNFJ2RUsyRXVvdVloRks3?=
 =?utf-8?B?dUN2c2hua1REMWRaYWc1U05GR3hHdlFScEt3enk1ZjVMaTgyK2g0Q1plbkph?=
 =?utf-8?B?TXEwTEhlcEpGaWFPNUMzdVpqUGFuL1lUWXNGNWdxc1RUS3BLRmxobWJDQjB3?=
 =?utf-8?B?MjlybUdKTUZFTUJlRGw1U29tU2xQYm1aVjRuTjRLT0oxTWZaSU8zZktyd0xW?=
 =?utf-8?B?dEtZR3RQK2NrUVY5c1JXM1hNazlOT08vL3cvL3U4cW5BTVc3SHRXVEJ1Nmtp?=
 =?utf-8?B?b21nNDA0c0FZdjNHdFhxUGJ5Q2wwM3AzOVkxZFZKZkxnRk80VjVCR3N5aGNa?=
 =?utf-8?B?cDJ6VFhUUXZiWmI3cDMyNzg2TENIbitzSWtiTHBrNGRJRDEzRmZGQjg0OXNF?=
 =?utf-8?B?czNoc3ovSWZHekxPSE5hZ0tEbGlhQmRnTEhhL1NEdWhMdjExL3VyMWVIbTg4?=
 =?utf-8?B?ODQrNjg4OUVQT3ZEK2lpQ0NaQm5NOWlIcWV4L0hTM0grcGZFblpRTGdEcEQ5?=
 =?utf-8?B?LzZKWVRGRm9vYkZEc2ljTDhKSzE4TWFnbjVlaEQrdDFGNFdJUGU5MDZ1V1Zj?=
 =?utf-8?B?TWY2czY5anU3M2tZR1BHcmk4Sm0rNDRyVDY5ZXIrRlh2V2pjdFZpcHdsbFBD?=
 =?utf-8?B?cmkrWUxzU0FZUHZUMElXWm05bWJSTFZ6MWhyaVBVQms0ZDNROWl0dElJTkR5?=
 =?utf-8?B?OWFETHFLL2VQNFRJZVFNYzlFZmdMVEk0b2xha0taMk9HMzlGbEdTY0lDSGQ4?=
 =?utf-8?B?WlU1UjZIZmhZenZramVPRnZqMDR6Y0h2V2JDak9XM2w4R21ZdkdTa1BXQUhO?=
 =?utf-8?B?WEcveTJMZnNpRVQvZ2VkU01nNXFIM0V2UEIya0tLd1ZCZG5tVTdSS0p2bnNp?=
 =?utf-8?B?VW5GV24yUUhNTHlseTBXdHkzYVUybXd2bXRyR2xseU1RSlNwREpBaTdSd2hj?=
 =?utf-8?B?YlJnTm15UWNPSkVGUGM4OS9PbHZpZ25jbHRqV3FWb25YaEdSdCt2L2ltNW5B?=
 =?utf-8?B?L2pTaU1mcjNuN1IwSlBKWWpqRTJYZWlqNDN4eG5pUm9YTGVjNEZwKzVnZ3U3?=
 =?utf-8?B?Q2ZmOWR4ZUZuRTAxVkt5amQ0UVVMejZUdkJzWitDRXlsYUtrdGZUSVBhdm8v?=
 =?utf-8?B?ajhBYnZ3S0tlclpYbkl4c1NOeE9uMERCTWsvM2h2UDBOYWZ4RXZheVF2dFgx?=
 =?utf-8?B?cS81YTN5SHZoSFhZc3BRSTJhdU5hMW9qTERCcmh6L29mejNwL3VlS1hHNk45?=
 =?utf-8?B?dExFeVVkc0pxbk9ZNXV6VTVBMnljY2UwalFLdC9vMGhZYWx4azZZZU8zRGVS?=
 =?utf-8?B?SVdDUWlPTHVTdG1rOEpoVEdNR1NaeTdVNHJGYXNMSm9zRUtSbnJ6Sm5WbEsv?=
 =?utf-8?B?L3pNZXFoYktoZG9Jc1ZTNWg3YStYeDhYc0FzK0J2VEs5Z2l5VFlSTTBTbTYz?=
 =?utf-8?B?aTNkcEhnb3ltRkpvUkJRbXN6cWsxU3ZRaFdGQ3dNdWFrK2cxVmxrbGNUZ0w0?=
 =?utf-8?B?WmdFWGdyTlVRRDIwZ3VpR2JqV0YzMVJJNER3TGZIVGRsVmtkNDI4SFd0ajZU?=
 =?utf-8?B?NjVXSndJVE1rWHRlQ0UzYUhBZXdPN01XVThrRGhJRkpsQVllNThtRmVHSWhl?=
 =?utf-8?B?azNSU3lRTFRIN3cwZ2RGWXhMVTF3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55C927B7BCAD1B4F9767737AA19B6750@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR10MB5712.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 88890d52-b93f-4d0d-c6de-08dabb49ac6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 14:10:32.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ExRtOHXz8oVDHKdjJHxrHqNGmZcaDRfaCjUoYzX1URban/vKFS9nm+Qq93Kjqmt4xuHsJexHLoGZhkQlduL+F8pv2bUKplVbIPDL6COHX3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR10MB7060
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQpJIHdhcyBjbG9zZWx5IGZvbGxvd2luZyB0aGlzIGRpc2N1c3Npb24gZm9yIHNv
bWUgdGltZSBub3cuIFNlZW1zIHdlDQpyZWFjaGVkIHRoZSBwb2ludCB3aGVyZSBpdCdzIGdldHRp
bmcgaW50ZXJlc3RpbmcgZm9yIG1lLg0KDQpPbiBGcmksIDIwMjItMTAtMjggYXQgMTg6MTQgLTA3
MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBGcmksIDI4IE9jdCAyMDIyIDE2OjE2OjE3
IC0wNzAwIEpvaG4gRmFzdGFiZW5kIHdyb3RlOg0KPiA+ID4gPiBBbmQgaXQncyBhY3R1YWxseSBo
YXJkZXIgdG8gYWJzdHJhY3QgYXdheSBpbnRlciBIVyBnZW5lcmF0aW9uDQo+ID4gPiA+IGRpZmZl
cmVuY2VzIGlmIHRoZSB1c2VyIHNwYWNlIGNvZGUgaGFzIHRvIGhhbmRsZSBhbGwgb2YgaXQuICAN
Cj4gPiANCj4gPiBJIGRvbid0IHNlZSBob3cgaXRzIGFueSBoYXJkZXIgaW4gcHJhY3RpY2UgdGhv
dWdoPw0KPiANCj4gWW91IG5lZWQgdG8gZmluZCBvdXQgd2hhdCBIVy9GVy9jb25maWcgeW91J3Jl
IHJ1bm5pbmcsIHJpZ2h0Pw0KPiBBbmQgYWxsIHlvdSBoYXZlIGlzIGEgcG9pbnRlciB0byBhIGJs
b2Igb2YgdW5rbm93biB0eXBlLg0KPiANCj4gVGFrZSB0aW1lc3RhbXBzIGZvciBleGFtcGxlLCBz
b21lIE5JQ3Mgc3VwcG9ydCBhZGp1c3RpbmcgdGhlIFBIQyANCj4gb3IgZG9pbmcgU1cgY29ycmVj
dGlvbnMgKHdpdGggZGlmZmVyZW50IHZlcnNpb25zIG9mIGh3L2Z3L3NlcnZlcg0KPiBwbGF0Zm9y
bXMgYmVpbmcgY2FwYWJsZSBvZiBib3RoL29uZS9uZWl0aGVyKS4NCj4gDQo+IFN1cmUgeW91IGNh
biBleHRyYWN0IGFsbCB0aGlzIGluZm8gd2l0aCB0cmFjaW5nIGFuZCBjYXJlZnVsDQo+IGluc3Bl
Y3Rpb24gdmlhIHVBUEkuIEJ1dCBJIGRvbid0IHRoaW5rIHRoYXQncyBfZWFzaWVyXy4NCj4gQW5k
IHRoZSB2ZW5kb3JzIGNhbid0IHJ1biB0aGUgcmVzdWx0cyB0aHJ1IHRoZWlyIHZhbGlkYXRpb24g
DQo+IChmb3Igd2hhdGV2ZXIgdGhhdCdzIHdvcnRoKS4NCj4gDQo+ID4gPiBJJ3ZlIGhhZCB0aGUg
c2FtZSBjb25jZXJuOg0KPiA+ID4gDQo+ID4gPiBVbnRpbCB3ZSBoYXZlIHNvbWUgdXNlcnNwYWNl
IGxpYnJhcnkgdGhhdCBhYnN0cmFjdHMgYWxsIHRoZXNlIGRldGFpbHMsDQo+ID4gPiBpdCdzIG5v
dCByZWFsbHkgY29udmVuaWVudCB0byB1c2UuIElJVUMsIHdpdGggYSBrcHRyLCBJJ2QgZ2V0IGEg
YmxvYg0KPiA+ID4gb2YgZGF0YSBhbmQgSSBuZWVkIHRvIGdvIHRocm91Z2ggdGhlIGNvZGUgYW5k
IHNlZSB3aGF0IHBhcnRpY3VsYXIgdHlwZQ0KPiA+ID4gaXQgcmVwcmVzZW50cyBmb3IgbXkgcGFy
dGljdWxhciBkZXZpY2UgYW5kIGhvdyB0aGUgZGF0YSBJIG5lZWQgaXMNCj4gPiA+IHJlcHJlc2Vu
dGVkIHRoZXJlLiBUaGVyZSBhcmUgYWxzbyB0aGVzZSAiaWYgdGhpcyBpcyBkZXZpY2UgdjEgLT4g
dXNlDQo+ID4gPiB2MSBkZXNjcmlwdG9yIGZvcm1hdDsgaWYgaXQncyBhIHYyLT51c2UgdGhpcyBh
bm90aGVyIHN0cnVjdDsgZXRjIg0KPiA+ID4gY29tcGxleGl0aWVzIHRoYXQgd2UnbGwgYmUgcHVz
aGluZyBvbnRvIHRoZSB1c2Vycy4gV2l0aCBrZnVuY3MsIHdlIHB1dA0KPiA+ID4gdGhpcyBidXJk
ZW4gb24gdGhlIGRyaXZlciBkZXZlbG9wZXJzLCBidXQgSSBhZ3JlZSB0aGF0IHRoZSBkcmF3YmFj
aw0KPiA+ID4gaGVyZSBpcyB0aGF0IHdlIGFjdHVhbGx5IGhhdmUgdG8gd2FpdCBmb3IgdGhlIGlt
cGxlbWVudGF0aW9ucyB0byBjYXRjaA0KPiA+ID4gdXAuICANCj4gPiANCj4gPiBJIGFncmVlIHdp
dGggZXZlcnl0aGluZyB0aGVyZSwgeW91IHdpbGwgZ2V0IGEgYmxvYiBvZiBkYXRhIGFuZCB0aGVu
DQo+ID4gd2lsbCBuZWVkIHRvIGtub3cgd2hhdCBmaWVsZCB5b3Ugd2FudCB0byByZWFkIHVzaW5n
IEJURi4gQnV0LCB3ZQ0KPiA+IGFscmVhZHkgZG8gdGhpcyBmb3IgQlBGIHByb2dyYW1zIGFsbCBv
dmVyIHRoZSBwbGFjZSBzbyBpdHMgbm90IGEgYmlnDQo+ID4gbGlmdCBmb3IgdXMuIEFsbCBvdGhl
ciBCUEYgdHJhY2luZy9vYnNlcnZhYmlsaXR5IHJlcXVpcmVzIHRoZSBzYW1lDQo+ID4gbG9naWMu
IEkgdGhpbmsgdXNlcnMgb2YgQlBGIGluIGdlbmVyYWwgcGVyaGFwcyBYRFAvdGMgYXJlIHRoZSBv
bmx5DQo+ID4gcGxhY2UgbGVmdCB0byB3cml0ZSBCUEYgcHJvZ3JhbXMgd2l0aG91dCB0aGlua2lu
ZyBhYm91dCBCVEYgYW5kDQo+ID4ga2VybmVsIGRhdGEgc3RydWN0dXJlcy4NCj4gPiANCj4gPiBC
dXQsIHdpdGggcHJvcG9zZWQga3B0ciB0aGUgY29tcGxleGl0eSBsaXZlcyBpbiB1c2Vyc3BhY2Ug
YW5kIGNhbiBiZQ0KPiA+IGZpeGVkLCBhZGRlZCwgdXBkYXRlZCB3aXRob3V0IGhhdmluZyB0byBi
b3RoZXIgd2l0aCBrZXJuZWwgdXBkYXRlcywgZXRjLg0KPiA+IEZyb20gbXkgcG9pbnQgb2Ygdmll
dyBvZiBzdXBwb3J0aW5nIENpbGl1bSBpdHMgYSB3aW4gYW5kIG11Y2ggcHJlZmVycmVkDQo+ID4g
dG8gaGF2aW5nIHRvIGRlYWwgd2l0aCBkcml2ZXIgb3duZXJzIG9uIGFsbCBjbG91ZCB2ZW5kb3Jz
LCBkaXN0cmlidXRpb25zLA0KPiA+IGFuZCBzbyBvbi4NCj4gPiANCj4gPiBJZiB2ZW5kb3IgdXBk
YXRlcyBmaXJtd2FyZSB3aXRoIG5ldyBmaWVsZHMgSSBnZXQgdGhvc2UgaW1tZWRpYXRlbHkuDQo+
IA0KPiBDb252ZXJzZWx5IGl0J3MgYSB2YWxpZCBjb25jZXJuIHRoYXQgdGhvc2Ugd2hvICpkbyog
YWN0dWFsbHkgdXBkYXRlDQo+IHRoZWlyIGtlcm5lbCByZWd1bGFybHkgd2lsbCBoYXZlIG1vcmUg
dGhpbmdzIHRvIHdvcnJ5IGFib3V0Lg0KPiANCj4gPiA+IEpha3ViIG1lbnRpb25zIEZXIGFuZCBJ
IGhhdmVuJ3QgZXZlbiB0aG91Z2h0IGFib3V0IHRoYXQ7IHNvIHllYWgsIGJwZg0KPiA+ID4gcHJv
Z3JhbXMgbWlnaHQgaGF2ZSB0byB0YWtlIGEgbG90IG9mIG90aGVyIHN0YXRlIGludG8gY29uc2lk
ZXJhdGlvbg0KPiA+ID4gd2hlbiBwYXJzaW5nIHRoZSBkZXNjcmlwdG9yczsgYWxsIHRob3NlIGRl
dGFpbHMgZG8gc2VlbSBsaWtlIHRoZXkNCj4gPiA+IGJlbG9uZyB0byB0aGUgZHJpdmVyIGNvZGUu
ICANCj4gPiANCj4gPiBJIHdvdWxkIHByZWZlciB0byBhdm9pZCBiZWluZyBzdHVjayBvbiByZXF1
aXJpbmcgZHJpdmVyIHdyaXRlcnMgdG8NCj4gPiBiZSBpbnZvbHZlZC4gV2l0aCBqdXN0IGEga3B0
ciBJIGNhbiBzdXBwb3J0IHRoZSBkZXZpY2UgYW5kIGFueQ0KPiA+IGZpcndtYXJlIHZlcnNpb25z
IHdpdGhvdXQgcmVxdWlyaW5nIGhlbHAuDQo+IA0KPiAxKSB3aGVyZSBhcmUgeW91IGdldHRpbmcg
YWxsIHRob3NlIEhXIC8gRlcgc3BlY3MgOlMNCj4gMikgbWF5YmUgKnlvdSogY2FuIGJ1dCB5b3Un
cmUgbm90IGV4YWN0bHkgbm90IGFuIGV4LWRyaXZlciBkZXZlbG9wZXIgOlMNCj4gDQo+ID4gPiBG
ZWVsIGZyZWUgdG8gc2VuZCBpdCBlYXJseSB3aXRoIGp1c3QgYSBoYW5kZnVsIG9mIGRyaXZlcnMg
aW1wbGVtZW50ZWQ7DQo+ID4gPiBJJ20gbW9yZSBpbnRlcmVzdGVkIGFib3V0IGJwZi9hZl94ZHAv
dXNlciBhcGkgc3Rvcnk7IGlmIHdlIGhhdmUgc29tZQ0KPiA+ID4gbmljZSBzYW1wbGUvdGVzdCBj
YXNlIHRoYXQgc2hvd3MgaG93IHRoZSBtZXRhZGF0YSBjYW4gYmUgdXNlZCwgdGhhdA0KPiA+ID4g
bWlnaHQgcHVzaCB1cyBjbG9zZXIgdG8gdGhlIGFncmVlbWVudCBvbiB0aGUgYmVzdCB3YXkgdG8g
cHJvY2VlZC4gIA0KPiA+IA0KPiA+IEknbGwgdHJ5IHRvIGRvIGEgaW50ZWwgYW5kIG1seCBpbXBs
ZW1lbnRhdGlvbiB0byBnZXQgYSBjcm9zcyBzZWN0aW9uLg0KPiA+IEkgaGF2ZSBhIGdvb2QgY29s
bGVjdGlvbiBvZiBuaWNzIGhlcmUgc28gc2hvdWxkIGJlIGFibGUgdG8gc2hvdyBhDQo+ID4gY291
cGxlIGZpcm13YXJlIHZlcnNpb25zLiBJdCBjb3VsZCBiZSBmaW5lIEkgdGhpbmsgdG8gaGF2ZSB0
aGUgcmF3DQo+ID4ga3B0ciBhY2Nlc3MgYW5kIHRoZW4gYWxzbyBrZnVuY3MgZm9yIHNvbWUgdGhp
bmdzIHBlcmhhcHMuDQo+ID4gDQo+ID4gPiA+IEknZCBwcmVmZXIgaWYgd2UgbGVmdCB0aGUgZG9v
ciBvcGVuIGZvciBuZXcgdmVuZG9ycy4gUHVudGluZyBkZXNjcmlwdG9yDQo+ID4gPiA+IHBhcnNp
bmcgdG8gdXNlciBzcGFjZSB3aWxsIGluZGVlZCByZXN1bHQgaW4gd2hhdCB5b3UganVzdCBzYWlk
IC0gbWFqb3INCj4gPiA+ID4gdmVuZG9ycyBhcmUgc3VwcG9ydGVkIGFuZCB0aGF0J3MgaXQuICAN
Cj4gPiANCj4gPiBJJ20gbm90IHN1cmUgYWJvdXQgd2h5IGl0IHdvdWxkIG1ha2UgaXQgaGFyZGVy
IGZvciBuZXcgdmVuZG9ycz8gSSB0aGluaw0KPiA+IHRoZSBvcHBvc2l0ZSwgDQo+IA0KPiBUQkgg
SSdtIG9ubHkgcmVwbHlpbmcgdG8gdGhlIGVtYWlsIGJlY2F1c2Ugb2YgdGhlIGFib3ZlIHBhcnQg
OikNCj4gSSB0aG91Z2h0IHRoaXMgd291bGQgYmUgc2VsZiBldmlkZW50LCBidXQgSSBndWVzcyBv
dXIgcGVyc3BlY3RpdmVzIA0KPiBhcmUgZGlmZmVyZW50Lg0KPiANCj4gUGVyaGFwcyB5b3UgbG9v
ayBhdCBpdCBmcm9tIHRoZSBwZXJzcGVjdGl2ZSBvZiBTVyBydW5uaW5nIG9uIHNvbWVvbmUNCj4g
ZWxzZSdzIGNsb3VkLCBhbiBiZWluZyBhYmxlIHRvIG1vdmUgdG8gYW5vdGhlciBjbG91ZCwgd2l0
aG91dCBoYXZpbmcgDQo+IHRvIHdvcnJ5IGlmIGZlYXR1cmUgWCBpcyBhdmFpbGFibGUgaW4geGRw
IG9yIGp1c3Qgc2tiLg0KPiANCj4gSSBsb29rIGF0IGl0IGZyb20gdGhlIHBlcnNwZWN0aXZlIG9m
IG1haW50YWluaW5nIGEgY2xvdWQsIHdpdGggcGVvcGxlDQo+IHdyaXRpbmcgcmFuZG9tIFhEUCBh
cHBsaWNhdGlvbnMuIElmIEkgc3dhcCBhIE5JQyBmcm9tIGFuIGluY3VtYmVudCB0byBhDQo+IChz
dXBlcmlvcikgc3RhcnR1cCwgYW5kIGNsb3VkIHVzZXJzIGFyZSBtZXNzaW5nIHdpdGggcmF3IGRl
c2NyaXB0b3IgLQ0KPiBJJ2QgbmVlZCB0byBnbyBmaW5kIGV2ZXJ5IFhEUCBwcm9ncmFtIG91dCB0
aGVyZSBhbmQgbWFrZSBzdXJlIGl0DQo+IHVuZGVyc3RhbmRzIHRoZSBuZXcgZGVzY3JpcHRvcnMu
DQoNCkhlcmUgaXMgYW5vdGhlciBwZXJzcGVjdGl2ZToNCg0KQXMgQUZfWERQIGFwcGxpY2F0aW9u
IGRldmVsb3BlciBJIGRvbid0IHdhbid0IHRvIGRlYWwgd2l0aCB0aGUNCnVuZGVybHlpbmcgaGFy
ZHdhcmUgaW4gZGV0YWlsLiBJIGxpa2UgdG8gcmVxdWVzdCBhIGZlYXR1cmUgZnJvbSB0aGUgT1MN
CihpbiB0aGlzIGNhc2UgcngvdHggdGltZXN0YW1waW5nKS4gSWYgdGhlIGZlYXR1cmUgaXMgYXZh
aWxhYmxlIEkgd2lsbA0Kc2ltcGx5IHVzZSBpdCwgaWYgbm90IEkgbWlnaHQgaGF2ZSB0byB3b3Jr
IGFyb3VuZCBpdCAtIG1heWJlIGJ5IGZhbGxpbmcNCmJhY2sgdG8gU1cgdGltZXN0YW1waW5nLg0K
DQpBbGwgcGFydHMgb2YgbXkgYXBwbGljYXRpb24gKEJQRiBwcm9ncmFtIGluY2x1ZGVkKSBzaG91
bGQgbm90IGJlDQpvcHRpbWl6ZWQvYWRqdXN0ZWQgZm9yIGFsbCB0aGUgZGlmZmVyZW50IEhXIHZh
cmlhbnRzIG91dCB0aGVyZS4NCg0KTXkgYXBwbGljYXRpb24gbWlnaHQgYmUgcnVuIG9uIGJhcmUg
bWV0YWwvY2xvdWQvdmlydHVhbCBzeXN0ZW1zLiBJIGRvDQpub3Qgd2FudCB0byBjYXJlIGFib3V0
IHRoaXMgc2NlbmFyaW9zIGRpZmZlcmVudGx5Lg0KDQpJIGZvbGxvd2VkIHRoZSBpZGVhIG9mIGhh
dmluZyBhIGxpYnJhcnkgZm9yIHBhcnNpbmcgdGhlIGRyaXZlciBzcGVjaWZpYw0KbWV0YSBpbmZv
cm1hdGlvbi4gVGhhdCB3b3VsZCBtZWFuIHRoYXQgdGhpcyBsaWJyYXJ5IGhhcyB0byBrZWVwIGlu
IHN5bmMNCndpdGggdGhlIGtlcm5lbCwgcmlnaHQ/IEl0IGRvZXNuJ3QgaGVscCBpZiBhIG5ld2Vy
IGtlcm5lbCBwcm92aWRlcyBYRFANCmhpbnRzIHN1cHBvcnQgZm9yIG1vcmUgZGV2aWNlcy9kcml2
ZXJzIGJ1dCB0aGUgbGlicmFyeSBpcyBub3QgdXBkYXRlZC4NClRoYXQgbWlnaHQgYmUgcmVsZXZh
bnQgZm9yIGFsbCB0aGUgZGV2aWNlIHVwZGF0ZSBzdHJhdGVnaWVzIG91dCB0aGVyZS4NCg0KSW4g
YWRkaXRpb24gLSBhbmQgbWF5YmUgZXZlbiBjb250cmFyeSAtIHdlIGNhcmUgYWJvdXQgemVybyBj
b3B5IChaQykNCnN1cHBvcnQuIE91ciBjdXJyZW50IHVzZSBjYXNlIGhhcyB0byBkZWFsIHdpdGgg
YSBsb3Qgb2Ygc21hbGwgcGFja2V0cywNCnNvIHdlIGhvcGUgdG8gYmVuZWZpdCBmcm9tIHRoYXQu
IElmIFhEUCBoaW50cyBzdXBwb3J0IHJlcXVpcmVzIGEgY29weQ0Kb2YgdGhlIG1ldGEgZGF0YSAt
IG1heWJlIHRvIGRyaXZlIGEgSFcgaW5kZXBlbmRlbnQgaW50ZXJmYWNlIC0gdGhhdA0KbWlnaHQg
YmUgYSBib3R0bGUgbmVjayBmb3IgdXMuDQoNCj4gDQo+IFRoZXJlIGlzIGEgQlBGIGZvdW5kYXRp
b24gb3Igd2hhdG5vdCBub3cgLSB3aGF0IGFib3V0IHN0YXJ0aW5nIGENCj4gY2VydGlmaWNhdGlv
biBwcm9ncmFtIGZvciBjbG91ZCBwcm92aWRlcnMgYW5kIG1ha2luZyBpdCBjbGVhciB3aGF0DQo+
IGZlYXR1cmVzIG11c3QgYmUgc3VwcG9ydGVkIHRvIGJlIGNvbXBhdGlibGUgd2l0aCBYRFAgMS4w
LCBYRFAgMi4wIGV0Yz8NCj4gDQo+ID4gaXQgd291bGQgYmUgZWFzaWVyIGJlY2F1c2UgSSBkb24n
dCBuZWVkIHZlbmRvciBzdXBwb3J0IGF0IGFsbC4NCj4gDQo+IENhbiB5b3Ugc3VwcG9ydCB0aGUg
ZW5mYWJyaWNhIE5JQyBvbiBkYXkgMT8gOikgVG8gYW4gZXh0ZW50LCBpdHMganVzdA0KPiBzaGlm
dGluZyB0aGUgcmVzcG9uc2liaWxpdHkgZnJvbSB0aGUgSFcgdmVuZG9yIHRvIHRoZSBtaWRkbGV3
YXJlIHZlbmRvci4NCj4gDQo+ID4gVGhpbmtpbmcgaXQgb3ZlciBzZWVtcyB0aGVyZSBjb3VsZCBi
ZSByb29tIGZvciBib3RoLg0KPiANCj4gQXJlIHlvdSB0aGlua2luZyBtb3JlIG9yIGxlc3MgU3Rh
bidzIHByb3Bvc2FsIGJ1dCB3aXRoIG9uZSBvZiANCj4gdGhlIGNhbGxiYWNrcyBiZWluZyAiZ2l2
ZSBtZSB0aGUgcmF3IHRoaW5nIj8gUHJvYmFibHkgYXMgYSBybyBkeW5wdHI/DQo+IFBvc3NpYmxl
LCBidXQgSSBkb24ndCB0aGluayB3ZSBuZWVkIHRvIGhvbGQgb2ZmIFN0YW4ncyB3b3JrLg0KDQo=
