Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A758B138851
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 22:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgALVS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 16:18:57 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:3556
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732825AbgALVS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 16:18:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDE5B30MOiiB84GPY3Glb9quZik7v2WkHBtvvOq4ah8spg1FAvg8VR1m83KT7gtjVHucLL+Xg776aN9UX9Lrs90C8YqqVWrTJpL7T6rnwpwMD086pIVg1TlQTX2ptGcGto+sP8fzsHWOvYmhoM/TIm/mOlkgw7SN041Eqg/J53Nf3zS1wxRnSBBIM0yLicxNf5ULWcaoERKvi2+4bUA3njzLAs4hniIMsYTaKNMQ+2St00ddeNjbjFambsLVBaJ8bMgtx2EnFs4nYETpb0b7y7oZ0CLdFfogKD9OPVNXeQ1A+jtZv8eA+ROTu/zSGvN9dfzBIgchqOMqzrAkDmZF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVI7tNNRFJIPeayBmvFYJXJcguf5edUqaiy+hdjffsw=;
 b=j8+wgAgAQet+7kYU52PU84wv3vA2qwmwI/AbqzhQwuc9aiFQ82AGrkPys5kjiorrspeXZT+ycFWQ+ZixpNTih77CKNDjnJHULov29P+YVjouKLx4d1t1iJC9jDyCWBFbzNutliXvJp4ebL7YXVbBoR9Rnk1mEDmfLUmkL0bGfJU3aq+WYpTv/1Na0r/Q7MoWZfFBc7BTYv4cuaLSPbeJgEL6nUjaJWeAVkNiK09x2Tj6dSNF7kvGIAYdvYH9zBBP53ax513a5aRRBZLRKRFCvvvArA8EPwKaopNbLp47fos/wbDHhsUvCykuroXF/hKty97kCG+Eu+9ZIhTYatEyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVI7tNNRFJIPeayBmvFYJXJcguf5edUqaiy+hdjffsw=;
 b=S5I+QCuxj2nUnUSo6QlXxfRTQffsKZTStsYx+CndNbOiShlQGxxPM0fzmU3e+X0l+8CACcJfO1+tCPB0AtJs5eghQVegna4zBkdSSRhL1VVQm06EOgGCwKysvRdvhxrgDUiIbx99MgExCNWS/LcPIrahHwCevjhkOuKjsKm72no=
Received: from DB6PR0501MB2248.eurprd05.prod.outlook.com (10.168.56.7) by
 DB6PR0501MB2549.eurprd05.prod.outlook.com (10.168.77.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Sun, 12 Jan 2020 21:18:50 +0000
Received: from DB6PR0501MB2248.eurprd05.prod.outlook.com
 ([fe80::94df:83dd:bbf6:462]) by DB6PR0501MB2248.eurprd05.prod.outlook.com
 ([fe80::94df:83dd:bbf6:462%12]) with mapi id 15.20.2581.017; Sun, 12 Jan 2020
 21:18:50 +0000
From:   Alex Vesker <valex@mellanox.com>
To:     Jakub Kicinski <kubakici@wp.pl>,
        Yunsheng Lin <linyunsheng@huawei.com>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Thread-Topic: [PATCH v2 0/3] devlink region trigger support
Thread-Index: AQHVxyOluroFsmd8ME+DHB49d3d0Iw==
Date:   Sun, 12 Jan 2020 21:18:50 +0000
Message-ID: <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200112124521.467fa06a@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valex@mellanox.com; 
x-originating-ip: [77.138.64.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d435d6e1-b52f-42a6-a6ef-08d797a50526
x-ms-traffictypediagnostic: DB6PR0501MB2549:
x-microsoft-antispam-prvs: <DB6PR0501MB25492BA1F57B7DCF43EA973BC33A0@DB6PR0501MB2549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02801ACE41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(189003)(199004)(8676002)(81156014)(2906002)(66476007)(91956017)(76116006)(4326008)(110136005)(54906003)(478600001)(81166006)(316002)(66556008)(8936002)(66946007)(66446008)(64756008)(5660300002)(7696005)(86362001)(26005)(6506007)(53546011)(71200400001)(55016002)(52536014)(9686003)(186003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2549;H:DB6PR0501MB2248.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BsEgkHVuhUCPyhJbTUs4SZ36DO9W1iBMhc1OY2hKflBdTXe9yMZnevSt/9ILuZbKBVHw+6YHAMj1snDcEN1lqWDW51rTSX7hi7wEm+NinZptzuxS9+NglWcl9kkE9ZuZcCpSTatRrjFOiBMnc1x2PMNFqWLbs0Wz2VwvhEcbmMcUJczjVPEDh0ltpLVvf76epmsKEXc5/zoJebRqVeAtbJ46eOuJXIPhb7ujogolsieCA2Kytjc9smopGCZt1LvRDmLS57qgRxHmGNyjA7+5ahvgqGpMUrISHPtVUE1CvRsoRkmYiZOsgm5lDg9Pnch3wPL5opGoLtfnUjq07J5MJ8Ff0NOcA6mR2ibVH+YxVS6PcKtNWglV8Mt4Q9UMpSHvGBpPx+/paMfNoPG6vXvdV8DmEz1fSmOf6sOMqWZFWEqieYcKhmxRjvUOA3pDMUOO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d435d6e1-b52f-42a6-a6ef-08d797a50526
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2020 21:18:50.6632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BgWiBPNiMvTrjBw8tE/28awxqPA/RNPh5cHWL+Epgycv9WjzlVZI8yymQVingdf8DBSs+GaPstMQLzrTQxruUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/2020 10:45 PM, Jakub Kicinski wrote:=0A=
> On Sat, 11 Jan 2020 09:51:00 +0800, Yunsheng Lin wrote:=0A=
>>> regions can essentially be used to dump arbitrary addressable content. =
I=0A=
>>> think all of the above are great examples.=0A=
>>>=0A=
>>> I have a series of patches to update and convert the devlink=0A=
>>> documentation, and I do provide some further detail in the new=0A=
>>> devlink-region.rst file.=0A=
>>>=0A=
>>> Perhaps you could review that and provide suggestions on what would mak=
e=0A=
>>> sense to add there?  =0A=
>> For the case of region for mlx4, I am not sure it worths the effort to=
=0A=
>> document it, because Jiri has mention that there was plan to convert mlx=
4 to=0A=
>> use "devlink health" api for the above case.=0A=
>>=0A=
>> Also, there is dpipe, health and region api:=0A=
>> For health and region, they seems similar to me, and the non-essential=
=0A=
>> difference is:=0A=
>> 1. health can be used used to dump content of tlv style, and can be trig=
gered=0A=
>>    by driver automatically or by user manually.=0A=
>>=0A=
>> 2. region can be used to dump binary content and can be triggered by dri=
ver=0A=
>>    automatically only.=0A=
>>=0A=
>> It would be good to merged the above to the same api(perhaps merge the b=
inary=0A=
>> content dumping of region api to health api), then we can resue the same=
 dump=0A=
>> ops for both driver and user triggering case.=0A=
> I think there is a fundamental difference between health API and=0A=
> regions in the fact that health reporters allow for returning=0A=
> structured data from different sources which are associated with =0A=
> an event/error condition. That includes information read from the=0A=
> hardware or driver/software state. Region API (as Jake said) is good=0A=
> for dumping arbitrary addressable content, e.g. registers. I don't see=0A=
> much use for merging the two right now, FWIW...=0A=
>=0A=
Totally agree with Jakub, I think health and region are different and=0A=
each has its=0A=
usages as mentioned above. Using words such as recovery and health for=0A=
exposing=0A=
registers doesn't sound correct. There are future usages I can think of=0A=
for region if we=0A=
will add the trigger support as well as the live region read.=0A=
=0A=
