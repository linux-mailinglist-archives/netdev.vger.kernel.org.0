Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A896662
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbfHTQaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:30:01 -0400
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:28110 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbfHTQaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:30:01 -0400
Received: from pps.filterd (m0170395.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KGG563025076;
        Tue, 20 Aug 2019 12:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=unpFzPMywWO68rfoFFYX9S8rEWh+wxA5cn8gEFYw2A0=;
 b=BKGB7dnEw2n5kBrvHqgBbsubf40XpiD/rOba5eXfqLv6+3LFlguP3rqIDim2f729wFdO
 gQYLPmehk5sDtU3OSAZa3KmNBiyl9AvQDMWoC0w9zfWnKoGK9vslimK1szC+aU7hYxc8
 HazxyaSvowv2z1aoImhY58rqMntdPCILRuLKaP9bzlHDqFaOzFeJ1NkThem+uX8QF82w
 /93nfy6TkWdlHlqbAO/Z9VmojJ4aDZcYKVo50HjatjTBzteEVPheXhNkW4WFrpD04Eon
 MtVi4VKD48A5W7udmmWX05QisAN26b2gJbXwj/NNlT5JvZHu3gMjLYj0LCI+FJ83+lYP SQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 2ugh9gs4ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 12:29:59 -0400
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KGS6H4192096;
        Tue, 20 Aug 2019 12:29:58 -0400
Received: from ausxipps301.us.dell.com (ausxipps301.us.dell.com [143.166.148.223])
        by mx0a-00154901.pphosted.com with ESMTP id 2uey0sy78c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 12:29:58 -0400
X-LoopCount0: from 10.166.135.92
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="384864590"
From:   <Justin.Lee1@Dell.com>
To:     <benwei@fb.com>
CC:     <netdev@vger.kernel.org>, <openbmc@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <sam@mendozajonas.com>,
        <davem@davemloft.net>, <dkodihal@linux.vnet.ibm.com>
Subject: RE: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Topic: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Index: AdVWRzWK9Wcjcdd/SW6uTu9wV1cgUQAe69YgAALeARAAKCEBYA==
Date:   Tue, 20 Aug 2019 16:29:55 +0000
Message-ID: <b862e3168f5b4a6eaf005d6b24950795@AUSX13MPS302.AMER.DELL.COM>
References: <CH2PR15MB368691D280F882864A6D356DA3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
 <ec5842fff4de45069a51618eb72df164@AUSX13MPS302.AMER.DELL.COM>
 <CH2PR15MB3686A4CEF8FA3B567078B4A1A3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
In-Reply-To: <CH2PR15MB3686A4CEF8FA3B567078B4A1A3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Justin_Lee1@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-08-19T20:17:25.5740389Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.143.242.75]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200151
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ben,=20

> Hi Justin,=20
>=20
> > Hi Ben,
> >
> > I have similar fix locally with different approach as the command handl=
er may have some expectation for those byes.
> > We can use NCSI_PKT_CMD_OEM handler as it only copies data based on the=
 payload length.
>=20
> Great! Yes I was thinking the same, we just need some way to take data pa=
yload sent from netlink message and sent it over NC-SI.
>=20
> >
> > diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c index 5c3fad8..3=
b01f65 100644
> > --- a/net/ncsi/ncsi-cmd.c
> > +++ b/net/ncsi/ncsi-cmd.c
> > @@ -309,14 +309,19 @@ static struct ncsi_request *ncsi_alloc_command(st=
ruct ncsi_cmd_arg *nca)
> > =20
> >  int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)  {
> > + struct ncsi_cmd_handler *nch =3D NULL;
> >         struct ncsi_request *nr;
> > + unsigned char type;
> >         struct ethhdr *eh;
> > -   struct ncsi_cmd_handler *nch =3D NULL;
> >         int i, ret;
> > =20
> > + if (nca->req_flags =3D=3D NCSI_REQ_FLAG_NETLINK_DRIVEN)
> > +         type =3D NCSI_PKT_CMD_OEM;
> > + else
> > +         type =3D nca->type;
> >         /* Search for the handler */
> >         for (i =3D 0; i < ARRAY_SIZE(ncsi_cmd_handlers); i++) {
> > -           if (ncsi_cmd_handlers[i].type =3D=3D nca->type) {
> > +         if (ncsi_cmd_handlers[i].type =3D=3D type) {
> >                         if (ncsi_cmd_handlers[i].handler)
> >                                 nch =3D &ncsi_cmd_handlers[i];
> >                         else
> >
>=20
> So in this case NCSI_PKT_CMD_OEM would be the default handler for all NC-=
SI command over netlink  (standard and OEM), correct?
Yes, that is correct. The handler for NCSI_PKT_CMD_OEM command is generic.

> Should we rename this to something like NCSI_PKT_CMD_GENERIC for clarity =
perhaps?  Do you plan to upstream this patch? =20
NCSI_PKT_CMD_OEM is a real command type and it is defined by the NC-SI spec=
ific.=20
We can add comments to indicate that we use the generic command handler fro=
m NCSI_PKT_CMD_OEM command.

Does the change work for you? If so, I will prepare the patch.

>=20
>=20
> Also do you have local patch to support NCSI_PKT_CMD_PLDM and the PLDM ov=
er NC-SI commands defined here (https://www.dmtf.org/sites/default/files/NC=
-SI_1.2_PLDM_Support_over_RBT_Commands_Proposal.pdf)?
> If not I can send my local changes - but I think we can use the same NCSI=
_PKT_CMD_OEM handler to transport PLDM payload over NC-SI.
> What do you think?
No, I don't have any change currently to support these commands. It should =
be very similar to NCSI_PKT_CMD_OEM handler with some minor modification.

>=20
> (CC Deepak as I think once this is in place we can use pldmtool to send b=
asic PLDM payloads over NC-SI)
>=20
> Regards,
> -Ben

Thanks,
Justin

