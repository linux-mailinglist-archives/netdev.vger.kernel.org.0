Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A9FF8EFF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKLLye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:54:34 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:37646
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfKLLye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 06:54:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ek6b3FrbMMUGcyqUsEOINVO8n39Pmk1wtXEj5DNmImH7I8UVSJh/a6veq/N29Ha7JOe3XPHJ/e6O8Ks7ZtN9SSLSvufWSXj94TFRBoW2HHnOUhpBBr+hoz0zLq/L0b1Qe3wIlVObHEMe1pPrvxlSikZYhXwq/E3li4s5SK++KMPjs4LbV8loRTITpa5Ooq7YKEimzYq7EflpCs1Y5lwXbg1jjEgQZQ5rzgjcXPw7450vRmPXsM4TwhMj71LtPywlPAdbIhWERRO2MXGt68WVX1cOMjY5kd58H7fTKVZeM4NMsIZ9c5Ju5J3KDjBizgQ55XcbB/udb4K9gdsnCzwmNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0Mt33xgDYurS+RDwYYN0lTH3c6whVl9nYUGFZdMsJU=;
 b=GQMSqlQ7gG+jBQU2j+DlD2bzfiyktYSosDPypX05uDQDUSf+B+iKl8uwShfvJ0hhZCDj5kZjGy1lBc8LzXY2NUsc5BxYqoVDMQMd7+FMFInskJhWPxjDq/7msiDLP3ynAfLrtRnLnbNetLj+kau2T9sg6/O0vJp0VdJIn7fuhPqwMflFhlGBMdwj48A14Qz+tgxaS5YPj+FGYdBi9egsy0AQUxK+q4RoLeGURXmm4vh6twJMeIjA8L/jFSBgvoBFbnwiO1xrHdMCYvwY3XZD2u6uZw9xY2NEJj4J+6PSRgIfkDGJroyrU4yOAuGR3r9v6/BfScn+Hd/quVCtc2TSVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0Mt33xgDYurS+RDwYYN0lTH3c6whVl9nYUGFZdMsJU=;
 b=ncMGBTDHTh4Kl/p3QTffj0TEXHDmIbC79lKEIq46vAkIx5ia5z477vlIMPlycEh1xu58LHhbBKYfZHoBIyA1OsRJ7YJxXY+ShwfCvzakJ4/E6HLuAdnU2tIGAliscW3M0WDOR+pH8AjeqvB84RWFY6yZD03sxY4d/SUvbuE50EY=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB4368.eurprd04.prod.outlook.com (52.134.123.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 11:54:29 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 11:54:29 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Po Liu <po.liu@nxp.com>, Simon Horman <simon.horman@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Topic: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Index: AQHVmEpHUNIqbyQIWEm27TZfncKzVKeHSiOAgAABIzCAAB79sA==
Date:   Tue, 12 Nov 2019 11:54:29 +0000
Message-ID: <VI1PR04MB4880B514857A147B2634B27896770@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
 <20191112094128.mbfil74gfdnkxigh@netronome.com>
 <VE1PR04MB6496CE5A0DA25D7AF9FD666492770@VE1PR04MB6496.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB6496CE5A0DA25D7AF9FD666492770@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea117073-a747-4ba5-7240-08d76767132e
x-ms-traffictypediagnostic: VI1PR04MB4368:|VI1PR04MB4368:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB43688BB16266C86599ADF2E696770@VI1PR04MB4368.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(13464003)(52536014)(476003)(9686003)(446003)(4744005)(33656002)(66066001)(6506007)(66476007)(66556008)(66446008)(55016002)(76116006)(64756008)(76176011)(66946007)(7696005)(5660300002)(186003)(229853002)(11346002)(102836004)(110136005)(6116002)(6436002)(3846002)(99286004)(25786009)(256004)(26005)(8936002)(14454004)(54906003)(6246003)(44832011)(2906002)(478600001)(8676002)(7736002)(4326008)(305945005)(486006)(71200400001)(74316002)(71190400001)(81156014)(81166006)(86362001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4368;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hH3bCLrBfLK3Sj+ctNb3u3Ebsy2ki+b4h5opNZi/HSmLmJzDuoZVn4LYdNOOhn1cagjJJNKBlKzpAanBeJq3idQhtMFOsrF3XW4OvyDCCVzmQo61DHV8rop8gQ/MgVuZO+VKJhYs+B/A5P7lmHyiQqNanHeGTFIj9EWI0ocjnQCJmFnL6VhZ5NxEceeqctXZbF2zCuNvtFCjt/xJndp1c21c4QTdPExKOXbJGY7g0ZWsXERFk3gYOzqzIOZhst7C7m+dYC+nyeqoLz3cTkjfjTLNiQhqlJ+FoP+hXGgnFt5eKPguTlSVqi+533fn6fiU4Y8AysWxUhMFVISGW0j/9OSx52dA4CPY8qEsggRlvnPXqpLeAyfvBdoLq21mKDUVFVMte2eid6DN+LxiYtbDyz3/t+kAJprHMFxu67XQHqaFUbSckF9wvYEcTN0mNPW5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea117073-a747-4ba5-7240-08d76767132e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 11:54:29.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1yljqyy37Yf1rwOqM6dB3e4RJuFMBawURldxvTilbmfSTB3PJcMRf3U/iUZq3x5qTO4HUBy1CQwUJ0qzPzwig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Po Liu <po.liu@nxp.com>
[...]
>> -----Original Message-----
>> From: Simon Horman <simon.horman@netronome.com>
[...]
>> > +/* class 5, command 0 */
>> > +struct tgs_gcl_conf {
>> > +     u8      atc;    /* init gate value */
>> > +     u8      res[7];
>> > +     union {
>> > +             struct {
>> > +                     u8      res1[4];
>> > +                     __le16  acl_len;
>>
>> Given that u* types are used in this structure I think le16 would be mor=
e
>> appropriate than __le16.
>
>Here keep the same code style of this .h file. I think it is better to hav=
e
>another patch to fix them all. Do you agree?
>

I don't see why "le16" would be more appropriate than "__le16" in this cont=
ext.
The "__leXX" types are widely used in kernel drivers and not only, to annot=
ate the
endianess of the hardware.  These are generic types defined din "include/ua=
pi/linux/types.h".
Whereas "leXX" are defined in "fs/ntfs/types.h", and there's no usage of th=
ese types
in other h/w device drivers (I didn't find any).  Am I missing anything?

-Claudiu
