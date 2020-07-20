Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2D226D92
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388948AbgGTRva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:51:30 -0400
Received: from mail-co1nam11on2120.outbound.protection.outlook.com ([40.107.220.120]:18209
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbgGTRv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:51:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Urb/WLge3sCGJOcqzaaSUudenjXjs6YOFYkPb3o4ywaENUDtSvtjB/RBTWwrVE5ZOD9J8piCPPvr4+vm+ITZKX0GVhl+Jrq+8xuZazCvPmHh2CVMYncbSo2IfwlceGVXu1577O+ltpXr9vGogGAQ6BliSjMBybElqTolE9yTqF5w+dQrUr1WIF0y6UQRfaKbIK/zugQceqp+Zs11T7cBzl/mKl5efgzmMXXGNFHupxhVhMiWME/ryju7ffpkvLJCzu+21VOgU+EgYANPpqhfGRk17ka6yq2G5Pjwz/vDX9gDIpy6jJUpkZiyQapyN2aAKQuiznM02N4LLU3i0UzyPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR+Y2fAkmPe6JYkFP/rOoE4jDpQ1qxzH1x2DnzpA4fE=;
 b=eJI+7C6USuRD/uxgJYrKOzIrPHl06hXn3+eBFIZVmEbLjYxNEdJipokEutcN5mncIDwkIxAEklhsCGFMig2Tf++veo4QdOydPvYgkKUm9G/UYXixNukxTlZ7bssi+WZ814TYYNFElAiU+mJeL6V3SUjcS9N1NOGYIIBLSVyN9McLOtSTnStZk0cge66ffZxR+RutrxuFSr6Ga6j61JBg++2F6eUiM+Iaq7eDKUFCarS05UpW3TulNT8Hp12N9sCL289F9N8MWcp0vhFYvh+7Tb3Le5tXtWe2irwrE7ExtGsXnpfOhwOyabZUAt6+NbU4SsFVrQPOIgmEu2gh9dtNkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR+Y2fAkmPe6JYkFP/rOoE4jDpQ1qxzH1x2DnzpA4fE=;
 b=Yoty4xJH2UNTTuGPSkmn7KVHS+6auojj/l0qD/tO3JRQNZEM5bdaVtMFBBSxlzOGT+TWAGFSvDJ9hl+Zr3U9ulAXg356abMwpDJlJ9E1WhSUGw67S6Hkp9AkmQFjlM6qfPcPKQOnpPfzkdnj1F8PvKta7Kr0sbO9TZi/c7HvaAU=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1090.namprd21.prod.outlook.com
 (2603:10b6:207:37::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Mon, 20 Jul
 2020 17:51:26 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.001; Mon, 20 Jul 2020
 17:51:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Sriram Krishnan <srirakr2@cisco.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "mbumgard@cisco.com" <mbumgard@cisco.com>,
        "ugm@cisco.com" <ugm@cisco.com>, "nimm@cisco.com" <nimm@cisco.com>,
        "xe-linux-external@cisco.com" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Topic: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Index: AQHWXrU+cNEwHb7+0Uu0LFIibsmHIakQvsqA
Date:   Mon, 20 Jul 2020 17:51:25 +0000
Message-ID: <BL0PR2101MB09302E2F00839462B1D70F08CA7B0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
In-Reply-To: <20200720164551.14153-1-srirakr2@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-20T17:51:24Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5d0d978b-5779-4471-9133-f33f9c4aa39f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51924ae2-ab90-4c76-3fd5-08d82cd58618
x-ms-traffictypediagnostic: BL0PR2101MB1090:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB10900066DEDFFE9274FF84D1CA7B0@BL0PR2101MB1090.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p0KCYCwfadksexxs4PyOBnHX6gYvya/rglYbYD5L4no0dvZedOkIvH+M2iXMrRpMIOfx3G8WFxCdf0Al0SyjWdxiBTMmKgp6T9HlGfJ26SzhBq5Pi77oJFJzq5vY9miAei7xc+DU3So+TSGnsS7OUs4ICAf/xEHoj10NeAyvGJRJqNlBwdagBWFl+Y4TGHQJkdEMiTDKcOvwLaO+rNrGbCIIaeWLtG/guW3wEeTagTk7NPCz5XZVYMk+gEly7Z829jwEr1Z86azS02vYHeeArV0iBxskojTc1b8YHkcDvX+/Dv8Wm4YDduxiGUypKgYE7ZWanxG03ZZGM/u1l/Vlkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(86362001)(478600001)(316002)(33656002)(5660300002)(54906003)(76116006)(82950400001)(8936002)(10290500003)(71200400001)(8990500004)(82960400001)(4326008)(66946007)(4744005)(66556008)(52536014)(6506007)(7696005)(8676002)(9686003)(186003)(83380400001)(2906002)(55016002)(66446008)(64756008)(110136005)(66476007)(26005)(7416002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: c3BBgYKftfZ7MK6tHsel5smm3sEsCtcEgbCXyG5BFczk8eh5nvFx8qVZXGD3E/SULjKK9riD3RLPeaHWoTVjcVPuDiS7i/oiBrATCLJr80WJ5pMi554o3/naiavBB+riTEYo0HZz2QjIJ/H47KMDZXDSOOt40zBD4P9Zcy7/e+GPfO8HCFPCGI35pGVAdVdAGtNOItDb1Phf6EfQd9zOjkakaIUUEryv48In5K8AGgQQifMVJWb7gApuX0+S7s+K7JV4qnQ7kJZdl+Z7UmwcmquNzLuecL5W7YFZRLlF8T7ZZPrgAtLMeXlhD4CO4f+j0nU67Za6vhpf0Mvkb8DcgBmL4ErX5fZp1JueBJIR6VOPy9iPytZ2Jv6OZ+Nvp4hcptqiIazOX0Dn4M5zTdZWQnvMLbJov9Y3wfBTEqUAbG9pekgH6p29/Z30H00S4c7WRnT0I6CfmaMF79Qh7WAE/NzVQSwkS84EAV100vLQ8+ZdRCZ2WH23QIXqbTfDzc6rB9tGDatj4VzUcoQHOuMCqya8ruhWDch6cysTxAz5dobBPSHsmAeXQTRzrLJOny1TClS3X3zBVm8W5PEqEYnwkRAUCiHBxdTgpT7RrJ64sX1AFS3fhobjAZaMI6XSu6v6X4xLguNDvAHqCiEg7owz4Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51924ae2-ab90-4c76-3fd5-08d82cd58618
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 17:51:26.1028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDeKlYB3O3DdPti9FTkwGKOjF2jXG1RCcw3uvyrjwjRb4kvU+EjhGE5NP+UC5muyEBcH4uDhJ+sGX8Cowa4lxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sriram Krishnan <srirakr2@cisco.com>
> Sent: Monday, July 20, 2020 12:46 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>
> Cc: mbumgard@cisco.com; ugm@cisco.com; nimm@cisco.com; xe-linux-
> external@cisco.com; David S. Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v3] net: hyperv: add support for vlans in netvsc driver

Also netvsc already supports vlan in "regular" cases. Please be more specif=
ic in the subject.
Suggested subject: hv_netvsc: add support for vlans in AF_PACKET mode

Thanks,
- Haiyang
