Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73993D809A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfJOT6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:58:50 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:32398
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726421AbfJOT6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 15:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pldp3srW3sOtiVRlh0ByNH8rec7V9RVVl+r5NWZoOcnkBm7434GxEVmjXdXxUo2uQzlJbrxxJmth5kpDX9y73Gbt6jHPNjZ0KoSBSQFrglvOAa5lbyJqvIQQtbr2WcmMsCGZmzUXwbzQTW5IYmRJCJSPMJGpQuDndq5h9xZEmAKbumaWtKahU3dw+SmO1G/wQqD1KE77lj6U/TmaYXIMKdoGzoeN9MR4t/OS0l/+bDcy7hc3DCSPKWpdwgVXJEV4ghirLKtvXnkASKS0j5VEvZQTL74LwTPToSOP9JaFNmuN4F7iqnq7N6H3Gy3WItcB5VnKUSC8E8bbB/XoG2C6iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU6ep5v5euZhuzRBi7IiEderRSPN+pfUq7jh7YKhU/0=;
 b=kzu3b6QppBMcA4fyFBWuvBzHBkAKPtUKxC9fd1gxF3G8+GGTBdENJlwQJeLUqeudxaqMoan8Y5EyzpRe5Z7hDMVQaaqUwRlsUeP+kPr3SkMg1pN8WPGxKfBPx6XD57m1kBZS3ppmW8wkL6m1fsK8IzTebo3BvwrBGrc0gqMLp/v/PMwshAw9PIPYB4+LCYW7pRUYkZRoWeba9gmGSLQb7RP8Lgg4I3sVgs1wtrZJ3HisomMWRC64okYlsz8R/zQmnKcDecmy9tvtcfSkzUioqdNVFJ0KPqmbTlFVHSfIM8LX4Y+xpy15tvx40BvwFVZBr3XwHSezTivEnYtshNC1ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU6ep5v5euZhuzRBi7IiEderRSPN+pfUq7jh7YKhU/0=;
 b=Iob62YfbEym+NElFAmzcrDltyBqEPt21Vul04vbCNQtBScn2o33Boz0P7T/bP/ST9YrFz/UeGPsoBP6Z4AEp2+a7pHB2EFBd3qvuYdkPDHF0VCaVTlKVKKLKHyaX5RMRIY9o6Q5TeP4ZQYZ70BON/qrNqF7Gr7tE/h/sXn1E7Wc=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2864.eurprd04.prod.outlook.com (10.175.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 15 Oct 2019 19:58:06 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::9136:9090:5b7c:433d%9]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 19:58:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Thread-Topic: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Thread-Index: AQHVgnFTE+1p7xEGekmpP/G97EE3oA==
Date:   Tue, 15 Oct 2019 19:58:06 +0000
Message-ID: <VI1PR0402MB28004BBB62BF52B75AF1284CE0930@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
 <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
 <20191015123603.153a5322@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.124.196.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3d26693-a5d1-4d39-3fcd-08d751a9ff33
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB2864:|VI1PR0402MB2864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28642A8A7D75185940DDCA97E0930@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(64756008)(44832011)(5660300002)(99286004)(6506007)(186003)(305945005)(7736002)(74316002)(26005)(71200400001)(86362001)(476003)(102836004)(6916009)(486006)(446003)(66066001)(66556008)(66946007)(66476007)(53546011)(76116006)(14454004)(76176011)(66446008)(14444005)(256004)(52536014)(71190400001)(478600001)(9686003)(33656002)(81166006)(25786009)(7696005)(6436002)(55016002)(316002)(8936002)(81156014)(8676002)(2906002)(4326008)(229853002)(3846002)(6116002)(54906003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2864;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c1u69/9gZOwuaDU/RiSwupXbbQaunz4mkM0iG47Pu4uyut4fKUkANrEhoGden0pZSqThz4ursKAaocratYsxKMgRYzrSTNhZzKjCQR1Txdb5i1Jsm6nsGymWzLzsxoDbqgqmWlITRszoKz9mGiRx+eFnU6OKB0flinjj14Fe2/CE9Eq9yKpD0cx937c9JEL3D79S9TPUft0B2xNyVRcuTplX9wDW5GFeMj1OKKM/7ZaOJFj52v/ITIjYduOiDQ+eBNzlUZjQrhKLXCBxXtJrzpmcWoxOSECkpe7DTIuhoZk1+8StRp747VLVWi+MLmwXSsgu8t9i5jYt9I0+/K6apve1z0z1Az+T9I9n3y34jQ3dxKDsi5kpbjSYk+bCaVN3hp+zcyjJAVqGHximOuRkc4Bv5bHe5XidWGzmqa/vzq0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d26693-a5d1-4d39-3fcd-08d751a9ff33
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 19:58:06.7676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ydk5mirbs3Uqen/ogLIgPFUGn7Kjl+6Sy420Ma61N2dvnQC8EfooI3LLRtztxSkZdd0N0ceoo6Mwhs8WIug34A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/19 10:36 PM, Jakub Kicinski wrote:=0A=
> On Mon, 14 Oct 2019 12:25:17 +0300, Ioana Ciornei wrote:=0A=
>> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>=0A=
>>=0A=
>> Depending on when MC connects the DPNI to a MAC, Tx FQIDs may=0A=
>> not be available during probe time.=0A=
>>=0A=
>> Read the FQIDs each time the link goes up to avoid using invalid=0A=
>> values. In case an error occurs or an invalid value is retrieved,=0A=
>> fall back to QDID-based enqueueing.=0A=
>>=0A=
>> Fixes: 1fa0f68c9255 ("dpaa2-eth: Use FQ-based DPIO enqueue API")=0A=
>> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>=0A=
>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
>> ---=0A=
>> Changes in v2:=0A=
>>   - used reverse christmas tree ordering in update_tx_fqids=0A=
>>=0A=
>>   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 42 ++++++++++++++++=
++++++++=0A=
>>   1 file changed, 42 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/=
net/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
>> index 5acd734a216b..c3c2c06195ae 100644=0A=
>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c=0A=
>> @@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2=
_eth_priv *priv, bool enable)=0A=
>>   	priv->rx_td_enabled =3D enable;=0A=
>>   }=0A=
>>   =0A=
>> +static void update_tx_fqids(struct dpaa2_eth_priv *priv);=0A=
>>=0A=
>>   static int link_state_update(struct dpaa2_eth_priv *priv)=0A=
>>   {=0A=
>>   	struct dpni_link_state state =3D {0};=0A=
>> @@ -1261,6 +1263,7 @@ static int link_state_update(struct dpaa2_eth_priv=
 *priv)=0A=
>>   		goto out;=0A=
>>   =0A=
>>   	if (state.up) {=0A=
>> +		update_tx_fqids(priv);=0A=
>>   		netif_carrier_on(priv->net_dev);=0A=
>>   		netif_tx_start_all_queues(priv->net_dev);=0A=
>>   	} else {=0A=
>> @@ -2533,6 +2536,45 @@ static int set_pause(struct dpaa2_eth_priv *priv)=
=0A=
>>   	return 0;=0A=
>>   }=0A=
>>   =0A=
>> +static void update_tx_fqids(struct dpaa2_eth_priv *priv)=0A=
>> +{=0A=
>> +	struct dpni_queue_id qid =3D {0};=0A=
>> +	struct dpaa2_eth_fq *fq;=0A=
>> +	struct dpni_queue queue;=0A=
>> +	int i, j, err;=0A=
>> +=0A=
>> +	/* We only use Tx FQIDs for FQID-based enqueue, so check=0A=
>> +	 * if DPNI version supports it before updating FQIDs=0A=
>> +	 */=0A=
>> +	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,=0A=
>> +				   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)=0A=
>> +		return;=0A=
>> +=0A=
>> +	for (i =3D 0; i < priv->num_fqs; i++) {=0A=
>> +		fq =3D &priv->fq[i];=0A=
>> +		if (fq->type !=3D DPAA2_TX_CONF_FQ)=0A=
>> +			continue;=0A=
>> +		for (j =3D 0; j < dpaa2_eth_tc_count(priv); j++) {=0A=
>> +			err =3D dpni_get_queue(priv->mc_io, 0, priv->mc_token,=0A=
>> +					     DPNI_QUEUE_TX, j, fq->flowid,=0A=
>> +					     &queue, &qid);=0A=
>> +			if (err)=0A=
>> +				goto out_err;=0A=
>> +=0A=
>> +			fq->tx_fqid[j] =3D qid.fqid;=0A=
>> +			if (fq->tx_fqid[j] =3D=3D 0)=0A=
>> +				goto out_err;=0A=
>> +		}=0A=
>> +	}=0A=
>> +=0A=
>> +	return;=0A=
>> +=0A=
>> +out_err:=0A=
>> +	netdev_info(priv->net_dev,=0A=
>> +		    "Error reading Tx FQID, fallback to QDID-based enqueue");=0A=
> =0A=
> Missing new line at the end of this message, I think.=0A=
=0A=
Will add in v3.=0A=
=0A=
> =0A=
>> +	priv->enqueue =3D dpaa2_eth_enqueue_qd;=0A=
> =0A=
> Should the enqueue be set to dpaa2_eth_enqueue_fq config was successful?=
=0A=
> IOW if there is a transient error we should go back to the preferred=0A=
> metho=0A=
Good point. Without setting enqueue back to dpaa2_eth_enqueue_fq =0A=
querying the fqids would be for nothing. Will send an update fixing both =
=0A=
of these things.=0A=
=0A=
Thanks,=0A=
Ioana=0A=
=0A=
> =0A=
>> +}=0A=
> =0A=
> =0A=
=0A=
