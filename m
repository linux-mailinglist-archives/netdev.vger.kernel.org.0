Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B37A5E3B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 01:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfIBXoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 19:44:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61564 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfIBXn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 19:43:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x82NhGSK018246;
        Mon, 2 Sep 2019 16:43:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6VoK4jYReRo8/nZyPNkAKQpVIYOaLEU1vWdGPOBUuEA=;
 b=rjDIQl22yZxkl9iT/yW7Rinhwqpuao7cMBgtrj9N0k9Xnd8X9owXaEHektYBV3uw6kh8
 BCmNf2s/vSmOlBEOsvZuRbS64yHh0wiuWClFXUKBOVBqTRTEtuVvfRc1ML/upQ96SGTL
 tw9Q1eDSUVCbVse2r36h4WgC0bisqk7Yefg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2us31f9wrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Sep 2019 16:43:44 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 2 Sep 2019 16:43:43 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 2 Sep 2019 16:43:43 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 2 Sep 2019 16:43:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HodObwpfY3+UYJl3ssaK9B9s5RAn+atKGjpprkL5WqS6x43Dn7LiNbhDkv6pCaXUwULqnadhDdE4rUSGUWzD5uOqn07kzXfOA4yKPvV7y8SYwYFHcCRP0H2Zl0uL96f+q9WfhMnVIGRUiGOGeS+7nKYvT1OT3nS5LpWIQVRitwdUL6qkkPaU+HlyjOHL0UjK3N8OWyVmcrfxAimm9nfnQAu1D5odrL7ZRxeJXO5W+gzaEG9hG588OGgdweNMERYINWp/gvY0Ku1byZEThcAZhrr8aSHJXykzWfwhWyRQPR/zt3msBgfyQwTtDK7kWo6qnDR7wP1ndcDMmO3OFpXJjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VoK4jYReRo8/nZyPNkAKQpVIYOaLEU1vWdGPOBUuEA=;
 b=Mj6dBPORhPaOl2dSBW1wTVtolO4niIWBq+9dQadZ5QHwr59GjH0Gg6i5G7BUdsog+raisSpaQ7rjahBUiigWI2S5Lhp0wLFW7OYqz3Xht53Jza+yNnj0VBd4bV8IoTV1FLYP225lirVMCJ0/zDRp9mnIBORhOfE4h59/wcFWnDxiC0XuPl7N+zgyMYucelFYpglAodvmvQdq06hrNtiCPLrQY6yY5P67BAbEC3nscpeCY4l8PKtuJniv5XtO0uPADmHNzeGfBPojZ5nC25rb6trYaHM6cBo2fLfUkbAIhyd/yk5gHDP+f1oP9/NA7NuzYv1oD620fIpgww7ZUlLT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VoK4jYReRo8/nZyPNkAKQpVIYOaLEU1vWdGPOBUuEA=;
 b=eiUhFt17Ye0cH7pI3i9JfOSjaEyIvFJ/rwPwv//HBTJNki/OrIn4qZ8vtsg5By9DeuNtzTOhH6PG4q86sWSala9XIV+dFmr5h5etW4DsQ/1Zc9tx1+8tEHp/ctS/6L7fUvh7xshYghtBwtMdHkKK41wUFB1X+EYvYW9wdfkzqfQ=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3542.namprd15.prod.outlook.com (52.132.228.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 23:43:42 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 23:43:42 +0000
From:   Ben Wei <benwei@fb.com>
To:     David Miller <davem@davemloft.net>
CC:     "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: RE: [PATCH net-next] net/ncsi: support unaligned payload size in
 NC-SI cmd handler
Thread-Topic: [PATCH net-next] net/ncsi: support unaligned payload size in
 NC-SI cmd handler
Thread-Index: AdVhOKsnD7LLLBrzTcm5Yllqe1NFWAAiF68AAAhz6HA=
Date:   Mon, 2 Sep 2019 23:43:42 +0000
Message-ID: <CH2PR15MB36869BE1AA44813CE293891BA3BE0@CH2PR15MB3686.namprd15.prod.outlook.com>
References: <CH2PR15MB368619179F403EAE47FD61F7A3BE0@CH2PR15MB3686.namprd15.prod.outlook.com>
 <20190902.120300.174900457187536042.davem@davemloft.net>
In-Reply-To: <20190902.120300.174900457187536042.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [99.73.36.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d7adc57-d4aa-4970-851d-08d72fff6342
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3542;
x-ms-traffictypediagnostic: CH2PR15MB3542:
x-microsoft-antispam-prvs: <CH2PR15MB35421B6A3190E292399903D2A3BE0@CH2PR15MB3542.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(366004)(396003)(136003)(199004)(189003)(54906003)(6916009)(9686003)(53936002)(229853002)(6246003)(14454004)(2906002)(6116002)(3846002)(478600001)(6436002)(55016002)(76176011)(305945005)(76116006)(186003)(26005)(7696005)(102836004)(6506007)(74316002)(66946007)(5660300002)(316002)(33656002)(99286004)(52536014)(7736002)(71190400001)(71200400001)(11346002)(446003)(476003)(486006)(4326008)(8936002)(25786009)(14444005)(256004)(66066001)(81166006)(8676002)(66446008)(64756008)(66556008)(66476007)(81156014)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3542;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3wU1/NZj+eHtLi2Q0JA9KUh/ZzpeiVUdGPQ3UBtVTWgD5qu8GtdP1VxJ+CzIp01yiYpGsooNpcJH9a27dan48If4N4BLPUJbkQZYywSxsFNDAhu/JHVkkq76hRGa7XYskLrWYmhES/51TgWxTyrt6dBK+oi6sXV9XLrGMk2xAtjl9msPSKW3X4sG8HzyNN6utTx9b5Z2EoYdmZVE3uzeVA7jr6TveeFVHWjtc4bZjPKxooMVqyMMyOUjhGb7jVawxo1/0lJbSrkGcN+MXu0+5lXyIrd0fymR0a5XElt7Q9UxINV57J+g+Kc7gCviCNOsVJbamU9zeDnuxRM0iN4K8SsSiXdg6jlGk34GZUWvMvAx8UixGuNEtQAu9ve8gCQ28zkPUGYqC9XxrFI6RqEy6+LunIPGtNrKO4IMoIoq4VY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7adc57-d4aa-4970-851d-08d72fff6342
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 23:43:42.3714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ez7fuAhV9+z4q7DbYmpVqGuHEYngRHKQOcUkKBg7fth4F+cWdjsqwlvFy+8AvtIv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3542
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_09:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909020268
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Update NC-SI command handler (both standard and OEM) to take into
> > account of payload paddings in allocating skb (in case of payload
> > size is not 32-bit aligned).
> >=20
> > The checksum field follows payload field, without taking payload
> > padding into account can cause checksum being truncated, leading to
> > dropped packets.
> >=20
> > Signed-off-by: Ben Wei <benwei@fb.com>
>
> If you have to align and add padding, I do not see where you are
> clearing out that padding memory to make sure it is initialized.
>
> You do comparisons with 'payload' but make adjustments to 'len'.
>
> The logic is very confusing.

Yes let me clarify a bit.=20

In the code 'payload' is the exact NC-SI payload length, which goes into NC=
-SI packet header
and needs to be actual unpadded payload length.

'len' is used to allocate total NC-SI packet buffer (include padding).=20

The original calculation of 'len' was done by summing up NCSI header + payl=
oad + checksum,
without taking into account of possible padding, e.g.

        len +=3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;  /* 4 is the checksum=
 size */
       if (nca->payload < 26)
                len +=3D 26;
        else
               len +=3D nca->payload;
        /* Allocate skb */
        skb =3D alloc_skb(len, GFP_ATOMIC);

This works today for all standard NC-SI commands (in spec v1.1) because all=
 standard commands
have payload size < 26, and packet size is then set to minimum of 46 (16 hd=
r + 26 payload + 4 cksum) bytes.

And mem clearing is done in each of the standard cmd handlers, e.g.=20
ncsi_cmd_handler_sp, ncsi_cmd_handler_ae.



The problem occurs if payload >=3D 26 and is unaligned.  This could happen =
on some OEM commands,
and I see this happening when we carry PLDM traffic over NC-SI packet.=20
(PLDM header being 3 bytes and payload size can be large)=20

The skb allocated would be too small, and later when checksum is calculated=
 and written:

	pchecksum =3D (__be32 *)((void *)h + sizeof(struct ncsi_pkt_hdr) +
		    ALIGN(nca->payload, 4));
	*pchecksum =3D htonl(checksum);

Part of the checksum would fall outside of our allocated buffer.

PLDM over NC-SI and OEM NC-SI commands are currently handled in

@@ -213,17 +213,22 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,

So here I ensure the skb allocation takes padding into account, and do the =
initial mem clearing
to set the padding bytes

+       unsigned short payload =3D ALIGN(nca->payload, 4);

        len =3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-       if (nca->payload < 26)
+       if (payload < 26)
                len +=3D 26;
        else
-               len +=3D nca->payload;
+               len +=3D payload;

        cmd =3D skb_put_zero(skb, len);
        memcpy(&cmd->mfr_id, nca->data, nca->payload);

So in this patch I updated both standard command handler (in case future sp=
ec updates adds
commands with payload >=3D 26) and OEM/generic command handler to support u=
naligned payload
size. =20

Regards,
-Ben
