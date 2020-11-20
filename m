Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4F62B9F34
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgKTAYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:24:09 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:38206 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgKTAYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:24:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173]) by mx4.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 20 Nov 2020 00:23:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQR4h3315WMqoxhFeYZXLiy3SJUKiq1up/TkWU/5L8TozBS5H2YLgajXiU39P6cW0z8an4yWPKcwwKkRfK6pLW0o/vFud/ZWpBOaMiIL8iuwT12zan2GQ378Qg3c5Mh4O6SEKB4krfd564LtCFmSl/H5BPkxnPCqNnf/5GRLliJpNcXS+UEww08B6twO3LkEDrFoQUk0ohB+9Z3prdG5ZlDWoIwiw9nZ9UxzNSl0cQc60iAJabm6hW1rCjq56azbh5heUGAPZb41v2tyUWENK2ljyzLQNnxMaz7yDuy7RiKX+0mY2Ozqguo2dWaIQwc1taK3wXzpBEsROvg0AYM6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAXvBJSjd+x5jv4EQTYwA/66jKc3xBTJevM1NkX5rNM=;
 b=FNiA3+pxEdhdYBbkbAa0iiJ5DLZEisfV65dMECUieRvUJlqrep9IhZk3gP9TfH3uUjXcROkzjNnlWr0isl96HEgj6uizP+DW8WfSkEpvqfBtltlr2ooj/U6iSaKxfm0x9xGYzih4E7OUdI8DlOqseEwLjR9m8hSicyA1kqprL43Xekci0C92MWOFzAY1RlsimEtOcRw/MyWXXuRsyaitCVzjPTen6mO1E208sg7erAFt/oAh9nvxoelas+PqTCAZUXwNc0aBSynXU7naU/BxHw4+el4LAXuq0itOPzpwhMAq37KH8m+6iczC4z/cAUPhFYCYbdFAyfpHF/jUJOXJMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAXvBJSjd+x5jv4EQTYwA/66jKc3xBTJevM1NkX5rNM=;
 b=mCsUBV92OWfcVtW+elaFuc2M1e+Z7G0imyKML2+owMQtWDmAO273Q6oTsiiNY06upnf+rUd8JZTJdH0/nCjbFJgyAlRclG36YJf0nQBvQwiwH+AtPS5r4Efpg94PSpiT81reg4+cdr/mz6Hk+RK1oBx6X+J0IZtsDoaTOCm9AiQ=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2165.namprd10.prod.outlook.com
 (2603:10b6:910:42::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Fri, 20 Nov
 2020 00:23:05 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Fri, 20 Nov 2020
 00:23:04 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v4] aquantia: Remove the build_skb path
Thread-Index: AQHWvs8ZM2n6oge2KEC89hbATIw5VanQJ1WAgAAAZVA=
Date:   Fri, 20 Nov 2020 00:23:04 +0000
Message-ID: <CY4PR1001MB2311EA0F0D57273541EE2A28E8FF0@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119225842.GK15137@breakpoint.cc>
 <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201120001705.GL15137@breakpoint.cc>
In-Reply-To: <20201120001705.GL15137@breakpoint.cc>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9660f55f-e09e-4512-13d3-08d88cea72cd
x-ms-traffictypediagnostic: CY4PR1001MB2165:
x-microsoft-antispam-prvs: <CY4PR1001MB2165837A2C183690D193D9ECE8FF0@CY4PR1001MB2165.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9s2J4aa7rUTZNf/kxW3M29jfUx1j1PEKdkWicOl6XgWtZv6HMZxJlZw8n3DwNGLzfzfRrtw+QNDuosafD0daQUou9iPa5UjTgnDMHMi6HRPLFqEw7NmqTv7Warzm4pQlFbA33N9wfiXuImL3x/kvWUGcRGKmeSRyx1F9c9ugcjHYp2UYtI4tIlIjI6jJN4QwG3Owgu5dyY/nLM0oBWmyFCOou/B8ezVJizNiirrmO/tnu2jXy3jNGfowPBBqTeDOkUKDb/GE7yZBGlpm9+scKpErv1En32R+JEB6p+0dqLlZnAZ1IFBc7WHo83iELJMY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39850400004)(136003)(33656002)(478600001)(7696005)(52536014)(4744005)(26005)(2906002)(316002)(86362001)(71200400001)(5660300002)(6506007)(4326008)(6916009)(66946007)(55016002)(186003)(8676002)(54906003)(83380400001)(9686003)(76116006)(66476007)(66556008)(8936002)(64756008)(66446008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: J98Szi9pJE7L0H3hnhCVeAh6nruWwmdCrqAHUml6S91m5Z6vQUvmgyOm+PsqUr7UCsHxe81TyAvXazXzm6GrCHhPXrQSl9hH7PjRNEV/wG/76rbr56mgwXEAJvZqPDHHdsMFImD52K2PS8DgqRLE/W7zZZssjDkWGx3SFyeHGxUqQ91KVybjLiaN2iLvyP7NwD+fQfFoyItH5i6cEkUyXxjF9uuoHpYqtn2t+8nzedgzYMBuHzWSl86e7p5tuuNZbY/9qBRA8zrxnx/+nNQSzMef5BdpdpLTp9I//kwnPOGWLLnBVf59twEEOhqydfCA8NC6JLlksB2Zrbb49p27hMsKLfEtC74AXTCx0DSiaOQh7rMhkv0EHnwb9c4GL0SgtCv2P+QY509vmvFq4EASFT/6+EKdJDZhKjbsP3Ni0vTklFUgwujr5grd4MSU5G2ijBwCQZxuz26rxXfbLFzZzcjxsMEqPxRyV9vAvqIo+GMUcOoYevLvKvnrcMl3kMtqct/BKUN0GEhtDDeCz8aMy3UIR1MO5cxhOzY/no3eV5g2nChTXnnNTqG71cv/1csWNdmnxeTUWW8diQpHvfERR34atNCzt+guhhJGMmibhqvdjVWBzpNcgwLQgqZIixndCLLbm0KahLGMyjh3OC911M1CO3cPcJiCBHPDXvyljr+hHkxv051iLCsudMbu8bMXKNgNUqlZ/wSyDcldeBIjia2MYhcnb41Bq+VvPK6ewmnCHHdk/wTyVGH2wFIzEGMsopbaWe9+D3vaSHNEy+zAo5FcV5JXeTkIaMVDAPbPtJlAU/6YRKMFt7Ix9XDVIAWOp4X9sVRujMaMbHQd0OaevTW0RtE1STaWbXdf3PKgAEm0LUwkfAK7/tKIgVmPa3PppVIKWjVJ6H4fVqGR4zyv2A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9660f55f-e09e-4512-13d3-08d88cea72cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 00:23:04.7714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYldraHXGfGfTmcnvP88i0hgP8dNJw82I6BobwZi+2ejoappvw0LV+/PXNJNTxvUvcnx5+xzE7h6YXVylnjmRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2165
X-BESS-ID: 1605831785-893006-2617-503-1
X-BESS-VER: 2019.1_20201120.0004
X-BESS-Apparent-Source-IP: 104.47.56.173
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228307 [from 
        cloudscan11-131.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't know about benefits/feasibility, but I did wonder if (in the ev=
ent that the "fast path" is possible), the dma_mapping could use an offset?=
 The page would include the skb header but the dma mapping would not. If th=
at was done though, only 1 RX frame would fit into the page (at least on my=
 system, where the RX frame seems to be 2k and the page is 4k). Also, there=
's a possibility to set the "order" variable, so that multiple pages are cr=
eated at once and I'm not sure if this would work in that case.=0A=
> =0A=
> Yes, this is what some drivers do, they allocate a page, pass=0A=
> pageaddr + headroom_offset everywhere, except build_skb() which gets the=
=0A=
> pageaddr followed by skb_reserve(skb, headroom_offset).=0A=
=0A=
If everyone's happy with the patch as-is, I might just leave it and let peo=
ple more knowledgeable decide if it's worth adding this optimization back i=
n with this offset logic ;)=0A=
=0A=
Lincoln=0A=
