Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D378553BAA
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 22:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354199AbiFUUeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 16:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiFUUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 16:34:16 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020025.outbound.protection.outlook.com [52.101.61.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5DB2DD40;
        Tue, 21 Jun 2022 13:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQm+QsFey7h0tZcfGfCgdbYN67OFv5nrAQ/r2EFSERrkg9mpuREy0yHphPjlnrkpn9+dT6H873yJKv7PkpvM3NZo3A7e2YKwohQdB9uJqGVgGYwNwLT8GGIK0SXZE7y1QxTGww3CkPzJUVqiTrB3s8nszvdsqHwjEWXfDAqdiSQ/PiYeB4zjoTamaZzld/YiRnN83Q4g6RDNCB0rYmEWNpwyStD9tC3fJmjwbawcJ1oh6mg/kpkq3JY4lwhXqGU8YfXTkrqJB56zVcj+5YBWHUxXVhSwTfJdCr+YyhTzN48+hf+RuhrNtARRo/HvKuX5q0F92+N4j/sTr6inZwT5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5rRrHcFdpN+EwU5hiRLilJqFDtl6cj1slGKUgq05vI=;
 b=WQg0/hJ5O5mkmWnj+yLbnli80iE84CR575n2dhcOl6jky6WUmgyB1yYYbyfqM9c9vWUMvOqzwjNJ5dfhMRnFJH1GMWbzd+SUkTTEQ7MyuJfl/UU+69Cxqd4pPVAKW3fYSY3x/uF2D3ibVo0gop4S594ZoAQodCIgMOCPDWrsFg0PUnvhkO2qNOJOnPPa3gwMuhZkYwQxr+g112du3Asdq3XRaOHu+XiBG0e1Nshx+Pj2llX3BbGRCPhj68HNN0WJkkoPesqkSQKuSi77GEA9v5jAbBU5WOwmymznP5dt4Xyjf0qBShbQjfKY5aOQ4jQR8dGuN/QU/yW1rQ9V5F1kFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5rRrHcFdpN+EwU5hiRLilJqFDtl6cj1slGKUgq05vI=;
 b=bYKKEZQveQZ055WISITcwYL14X/FG3wCrUH2a9A/bQHrgu5NPSQd0IDOQvHBEvmg5YL5ww4QYv1KZNwRPHNfofat3Mo3F0WCA/PbX7y7x9JTDXfar1omIpRWih7L3mVLPArYNcH5kgLr4J6Ex7qAtdHcmfBHe/IZWYhsZCBwNgs=
Received: from DM5PR21MB1749.namprd21.prod.outlook.com (2603:10b6:4:9f::21) by
 BY5PR21MB1505.namprd21.prod.outlook.com (2603:10b6:a03:21f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.5; Tue, 21 Jun
 2022 20:34:12 +0000
Received: from DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c]) by DM5PR21MB1749.namprd21.prod.outlook.com
 ([fe80::f4e3:b5d6:2808:f49c%9]) with mapi id 15.20.5395.003; Tue, 21 Jun 2022
 20:34:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Thread-Topic: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AQHYGhkbwj/2soN83kmQnCFUF3LCRqyFiqLggALM3QCA0sG4YIAADQYAgAABU4A=
Date:   Tue, 21 Jun 2022 20:34:12 +0000
Message-ID: <DM5PR21MB1749263977B6DF4714B057A2CAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
 <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
 <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
 <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM5PR21MB17494B8D4472F74198C88FE7CAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
 <YrIpgssFaIYu1EN3@kroah.com>
In-Reply-To: <YrIpgssFaIYu1EN3@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=05b0fec6-a7d1-4fab-ab15-dc0d3db26129;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-21T20:31:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 675cb369-69b1-423e-64fb-08da53c566a3
x-ms-traffictypediagnostic: BY5PR21MB1505:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BY5PR21MB150529B44331D2054B22A9E6CAB39@BY5PR21MB1505.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xa9UyPsKytFDX2JRCKZ/6ups/ljAlN71uIwsVuef7zh7AxRbIp1IKTAKfFSEmYTBoyZiBDXZUxX+B5MzhQhY4CBmSUZ8AuQoF1bKUVTl1q7MGMkwsCdwQq7GyGkWuF5UpV36/i9cNhqFOs3Nc3Kwws0usizhl3kMwSltPwOpD1EtdRTTIFYfx01yc3yAm9++mw7aLDJ7sHNOzdNQ1U0TxVgRAhvKPfjK2SRU5G5tvRXo67xv18/FxRvERba3wlTPKqL61nt6oyiNyb8ZLRzsEDgo8b1M0cU4XkUQ7rAnQj050ZZmko2zM2tyClZvYIcpGZIInT7TccAsk3sMOsM/+R7n5w9NChNNbZp4Cnzj4O83dWRQYGiGotOBhkbC8/r0PKrcAHlTig4NkZ4epYjAmB2t+AxZ1CTbOhKB/XDabWBr6eHo38wRuaFy6+6GRv//J8YMJvUCz8XTSPbHPjZmbUraYw75dwyW9/n8w8dkCGDamLGFQVjrgZlo//vgBZ7nqjLsWGqynbH6Mj/3v+We0NEyj1j8PevvKOUy+LSGo/OPf5zLfJA+/gMexF1SOC+u1PqpaUluy/CjW7vqqTStpFdBchG57/qcj0i+8sonTf40DbIVweBPRCQwJT07rtqHgUo8FlUYBxBWeeXPkH7T3mwAqgAFOqo4gwAe4T4O3W8bdlfqd9tcb1ew3ds/LyDOwK9t5tgW7RZNbNgEH6kom7wqUqhFZM35YBNqsr2uv115qdImPT7Z3j6PG8CbBZY/Lwxabb5M9eMEBQ944J90W00g3x4KElksq7Vm61snPo6yxOpLKjADaCI0BQQ9mHK67WYYcJwZ58UiyzuLgdldKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR21MB1749.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199009)(186003)(7696005)(76116006)(66946007)(55016003)(478600001)(54906003)(71200400001)(8676002)(64756008)(4326008)(5660300002)(66446008)(66476007)(66556008)(6916009)(6506007)(8990500004)(9686003)(41300700001)(26005)(83380400001)(53546011)(10290500003)(86362001)(38100700002)(33656002)(2906002)(316002)(38070700005)(82960400001)(122000001)(82950400001)(966005)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VcTEH0pjrBK+W3LlyybHXhwGhF06wbAmpOGBVjUavl3maciGOsSrms0abLCh?=
 =?us-ascii?Q?Sh41cwNAEq9JhJNGQLnvXHs7xSd9xPM6M5d3hz/1n/oA8RzNv+nS6UgfrONP?=
 =?us-ascii?Q?RllJHcFTYWDhJ2UcleVopLzeirmsirHAO/wNMHIIELhz90O4QgQKeeBLydd3?=
 =?us-ascii?Q?X/6spA8B3HrSknyU6lyrf7JvMX6nx7KcEcLDuuh5fWsWQJqMyvxcT82/hYaI?=
 =?us-ascii?Q?xw0Us9Txe37ncRdRHgaH7ireBLpb/Hda/74sh0WVh+IP26di8EyGORrltoWZ?=
 =?us-ascii?Q?+68LV+Gy3vxm98cRW8svuvX7g3BkXy+h6iw7B1gxGN20tgCNkjn6AGsSDkqp?=
 =?us-ascii?Q?k5B5QVbVdt0CJTZxbWZu5xER3fcWXWt3GfYiwOLsrqWVHQzHtp/VmmqY5YiC?=
 =?us-ascii?Q?fC6pvveZY752ACsfcoPHI5F+s8U/5cgs+IIb9xlyszxaFwYiaEqSwCfoYZFO?=
 =?us-ascii?Q?mEr/RAM4kl56v3tJPJT4pb0VNN6H8wbXcEimAHfdjje96LowjfyB9Gcve4Sr?=
 =?us-ascii?Q?4fhbSfNhcIrMisePrwJX1efR0RRduHE9dHYU/B3PHvvR+SZ2Lk3LAkaPSUe8?=
 =?us-ascii?Q?BgP+8Ab6N4cxQhCQ53izrmbeAHoA6GlkXN6U1Kl8NLTgKmTccRAGkpbidDFt?=
 =?us-ascii?Q?E1fAq4T8YN+9Sp0iE+Jjlj5Gbkt2Nirxol0doWRUrMeSXxb6L6DbuWMUULwj?=
 =?us-ascii?Q?4WwhfMwVi+grRKaTzGEuu/vd58J27vRDiQniugFV4lCWxE6Myrc4h8CvKOAi?=
 =?us-ascii?Q?NEJqAhN2C1G75P19ubB8f7+h8GvNwdEm1PhL3vaLinbmH+Es+EoXjwpfamOG?=
 =?us-ascii?Q?deQ/qaAm/tJl3aG0rxVPqYVspiIuJcyewVxM0oZAmMaOIIjlrzDNmzurHrlo?=
 =?us-ascii?Q?Z7kQ0fpnufNy/FUHdWhhpeO3WIQVCKmWpfeHAYscgcp6mGyRE/Ib0N65s5ZJ?=
 =?us-ascii?Q?vxoiqAPRiGb1bHY/P4JBmN+Cek9KVo0U2xnYlJyCSuONvmfWmuuyK46aWL1H?=
 =?us-ascii?Q?Q163LIPTxfmr09VnxubxnajmhnqybaNNy+UbQEh0ExgqgoyLSh/ENQrer8hq?=
 =?us-ascii?Q?Z6FtKYnPnzUuCcCpJCa0fpIQosomOz6KjrbKU4zh8/w5+kOFhwE4qsO3I+Vg?=
 =?us-ascii?Q?S3tj3/NwHzXmSOnXu71BMoiQYiSbcOsIviQ2ST1U041P7gXnDC849kPMYc8z?=
 =?us-ascii?Q?Ki+fzckWqDqsd079s3XJGsV5RYbxXIw+D/Oq/z8se1AMY44F2y7zmgBcrayl?=
 =?us-ascii?Q?57IcbcbJp/SvPESTLE0IRhBeYTvcFPzoVTk3xBI1vpuFQDKSWOFItrB/ckOt?=
 =?us-ascii?Q?KELJsZrzC/+1HovUWMni4SWTjRVv5l1mV7fmNhLYiMf75EoXc/XshcY6vbzA?=
 =?us-ascii?Q?NDrIkAFwbUFU4mFlkYu3Q2Xp4ZKb5vGWh33SiPBSpamn1k1Sc7rXkx2GN18W?=
 =?us-ascii?Q?aIZ4TXVW+JVEmkrbLkl0UXBw+cGWkt//0QhAMxu+pw1roYnQ+4D3R7w8KdzQ?=
 =?us-ascii?Q?IQK067bGv1hOMsqfMOvFNejgSBNDIrqJoloii6UrljQzTcm9oKwHmdfFzURI?=
 =?us-ascii?Q?FSrhUNkJ0yMg37FRxqrdogxOdf3ichLZKdFzQhsw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR21MB1749.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675cb369-69b1-423e-64fb-08da53c566a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 20:34:12.1357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+LNItvbd8cQlNislJzeKqBQoZxMtAz20Gwa/oqEtzAfCdHmAkBtG0/S9bpFp2uxSWgeL3ZR8pSLA8HMDgarRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1505
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, June 21, 2022 4:27 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; Dexuan Cui <decui@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; Shachar Raindel
> <shacharr@microsoft.com>; olaf@aepfle.de; vkuznets <vkuznets@redhat.com>;
> davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of
> CQE_RX_TRUNCATED
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>=20
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.k=
er
> nel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fstable-kernel-
> rules.html&amp;data=3D05%7C01%7Chaiyangz%40microsoft.com%7C9ecaef20f4
> c04a77741e08da53c45e7d%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0
> %7C637914400166157108%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAw
> MDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7
> C&amp;sdata=3DLgg0cEUxQf3uhKHqAF0pTFcQvHj4NKkUCEuQ9elePvw%3D&amp;
> reserved=3D0
> for how to do this properly.
>=20
> </formletter>

Thanks. I will do.

- Haiyang
