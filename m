Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77D69AD7F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389813AbfHWKmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:42:42 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:28518
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387683AbfHWKmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:42:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4Es3vnI2uiNCroCU+uV1yKO6hQYlubhN6JfebSPemluHzPKjxIHC7zrkdkx1nyh12fNaneheR6hiJP0XcdkFtAaqvvMux1cX8utK5h2CmVIc4LdQWZk9e9mHM30OMlglBjVdfllpSirpD3gkxn5zLEqIWVO1UBjy2qazCcE/a2P2pBFo5duR8re4Vs098iUSf6E3QnP197afh+oG2mSmv/rLz9ykATlvvOEkCqGQZfHFq7O4taeXhdc5x+qJGX3Q9f7bEBdm7Al26ntYsnHywk+YK8cD8SFpYpvb2qJA1RIgFTPoC1gdtCwpfLo8hVFSuHXZWl5wJHERx2Gd8hE9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiTe8/VCY9dLpedO/PRgza29x0aIEWu7Y4b+QMX5fE0=;
 b=S82ejF5noNCe33p7ir/bbFMbFKO5hXJ5Mu9frb+v9QtLupX8W0HO+sNKDVln6WZriav4qz+NSHz6AvO4fpKiezGeHNYHd2mYEa7jCBSiWgcQeTdlactIKOcEHp7yrXrBZksBN/rnDnsENR2y0YepkJQjmxsRMXtbTrzzEf3IAFIR7SFyb+fuDZSA7LtBVY0VfNmSkVqzF86TB/mypu/Eodo6nB/w2QXE7oEu3sGv49HjGnIVsI3stScvW+JcDrBGl+MRrjlHMyAVZbXLzELMTN9yTGBYNYXOenzt9YlYBHW5fDoVNuUZNyJKje/3VAhcwCxhEdKQodq0rGfa4wczhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiTe8/VCY9dLpedO/PRgza29x0aIEWu7Y4b+QMX5fE0=;
 b=bsVI/fa0MLnUfLjFG1GKPbBxTcF24kQldOFKv2olVw3mWisDcgwieU1B7yF3iKKCvF94ebQZJCrgI5TEblwhPI6LbiRNibsht+O/JvjQ57CvGD6vqrvSyMqRA1DQgq0h6x2TfKmoY0WMcGWHvcLjqcVPbxyclLpSYPKn522eT7o=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5982.eurprd05.prod.outlook.com (20.178.127.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 10:42:39 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 10:42:39 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 06/10] net: sched: conditionally obtain rtnl lock
 in cls hw offloads API
Thread-Topic: [PATCH net-next 06/10] net: sched: conditionally obtain rtnl
 lock in cls hw offloads API
Thread-Index: AQHVWOdSGXx/G334B0SuSSTpdGjCDKcHyc8AgADDVgA=
Date:   Fri, 23 Aug 2019 10:42:39 +0000
Message-ID: <vbfef1c17tv.fsf@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
 <20190822124353.16902-7-vladbu@mellanox.com>
 <20190822160328.46f7fab7@cakuba.netronome.com>
In-Reply-To: <20190822160328.46f7fab7@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0073.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::13) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb99f837-6012-4c40-1a58-08d727b69e66
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5982;
x-ms-traffictypediagnostic: VI1PR05MB5982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB59820ED71EA4F3070877EE9AADA40@VI1PR05MB5982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(189003)(199004)(81156014)(8676002)(81166006)(25786009)(4326008)(107886003)(6246003)(76176011)(53936002)(6506007)(386003)(102836004)(26005)(66066001)(186003)(86362001)(36756003)(14444005)(52116002)(256004)(99286004)(71190400001)(71200400001)(476003)(2616005)(486006)(446003)(316002)(54906003)(6916009)(478600001)(6436002)(3846002)(6116002)(7736002)(305945005)(5660300002)(229853002)(66946007)(6486002)(66556008)(8936002)(66476007)(14454004)(11346002)(66446008)(64756008)(2906002)(6512007)(87944003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5982;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yJ6RSIoZpl+9QQws8nX7wRN+srUjPRqdjtanG/n/k6OsoPsXe/B0/Wn0qtW44tHSTpy9yl9cakf7bQMOUM79h0tYsY7O02LcdbYk+BNfKygR+rG3gmckHWVoNQWTuidugNAfmO8Ipm40rihe6AXC0++EzOuHKVGv3wW5ze2sfv8tNmwsl/Mg2e4OfFTrzLO82DYYYpOCc/5VV+x6fOtRe3jvTVun571wAHEP7Lz1Z/Z/xxI/ihgGikUhnN+ulc/OwJ03Zxxq7/Ples6MknEhy+Fnyqe5BJMIZ0UJux1vCLG74U1txkCyq+4wyC2FgfLgGbyTNur+ay2iUFIIvVrfyjk587IMZ6yRE6aE/Qd/9fLvSa5G07b/TRCWhRlD+JGsQea5q5VS0i2OvIq5MhUuqeY2MMfkxRFOeOU7Lks+V6I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb99f837-6012-4c40-1a58-08d727b69e66
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 10:42:39.3475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qRMIgNWxNsfgtgfPNcv8ewhOsShhvDlR3j4Y15x0KLRrzM0mHePeyJPGsjRr8Vqy/24D6iUUub0KkBRmLk/QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 23 Aug 2019 at 02:03, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Thu, 22 Aug 2019 15:43:49 +0300, Vlad Buslov wrote:
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 02a547aa77c0..bda42f1b5514 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3076,11 +3076,28 @@ __tc_setup_cb_call(struct tcf_block *block, enum=
 tc_setup_type type,
>>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>>  		     void *type_data, bool err_stop, bool rtnl_held)
>>  {
>> +	bool take_rtnl =3D false;
>
> Should we perhaps speculatively:
>
> 	 bool take_rtnl =3D READ_ONCE(block->lockeddevcnt);
>
> here? It shouldn't hurt, really, and otherwise every offload that
> requires rtnl will have to re-lock cb_lock, every single time..

Great idea! This looks like a straightforward opportunity for
optimization.

>
>>  	int ok_count;
>>
>> +retry:
>> +	if (take_rtnl)
>> +		rtnl_lock();
>>  	down_read(&block->cb_lock);
>> +	/* Need to obtain rtnl lock if block is bound to devs that require it.
>> +	 * In block bind code cb_lock is obtained while holding rtnl, so we mu=
st
>> +	 * obtain the locks in same order here.
>> +	 */
>> +	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
>> +		up_read(&block->cb_lock);
>> +		take_rtnl =3D true;
>> +		goto retry;
>> +	}
>> +
>>  	ok_count =3D __tc_setup_cb_call(block, type, type_data, err_stop);
>> +
>>  	up_read(&block->cb_lock);
>> +	if (take_rtnl)
>> +		rtnl_unlock();
>>  	return ok_count;
>>  }
>>  EXPORT_SYMBOL(tc_setup_cb_call);
