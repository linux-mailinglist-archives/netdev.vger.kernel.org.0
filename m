Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9273707FF
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhEAQ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:58:40 -0400
Received: from mail-eopbgr30132.outbound.protection.outlook.com ([40.107.3.132]:36421
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhEAQ6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8Ym7nCpvtX9V+71S2ifG289nXbvRGQFhGOhbkGFwXr+0r7/AZ1WluOTn+YNhcvCt1GnKXvYcfmRHAAxvpq1KKkK2Il43c95bwkt0S6GfVfkptWnv7r0H0JLzJ2j6D59RV5BjYBYE+dNXRB089HUYPlpMd19oeliFN2IOklPSaI3uI423xyZ8SJA4pEBOMhSWPkHtkhxvarBdOk/rmKZIybcR8JxEjVR9yLAteC64P1Lrc1hWHOgVLycr2ZJ2hnAHwpBZY+yVhhItLqatVkSEpUR/jw0VNOB1MJF1dOdA0BUli23rCMs4uJqClMcqQwT7ozqbFOtXLzI7RideMD8Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Zuu9eDLQ7FdgzzbDDpt1+y00bN4SL13WEwg/YcFb20=;
 b=R32Jn1XmAdOtSSnq2L+En3qcbk1HEQjnUlHNwRwdKurXiwzSU4QL+NwLgKBltprWG+M9nEWZA2atfflVxIOH95rjuoP3HNgHXi+SZXqWaRP+IjdPud4eL8qzIcfcT9jC8Eh3Vbr+pfPiZP/Jw414EdxQNcK1d7z/9aYifDPIa7sgHxE/wFfhXLaYlqOFoWQqUF5Tf2yBcvVOxpurNyegrxJRIZkJ62H3D/qpfCEQQ+yQ6EIdxZV6y09J69EyVeJmR5PQ///pqNpSKodwZRIdbzVIvSAQ3IK0SFui9/7vFjnuNu41NB0QAs+uHnOcUqjoKlLFHwvCdg1mvPXvYRjRQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Zuu9eDLQ7FdgzzbDDpt1+y00bN4SL13WEwg/YcFb20=;
 b=IlmgRn0raGlG6kdWi1o/8XCDWc50AGuTafGScpoyxHqtTcKMqn3b/2XK/hMyvFBt3sKA03AxjgjthwDG2t1aWkcQw8PHQRWjnNiCXt+77Wr18wd6YuyqjS30p2adST13s7zfqAJGygxESQF4EYeMMHaX+P+aRpmBxeXaYFaikfo=
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR07MB3388.eurprd07.prod.outlook.com (2603:10a6:7:30::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8; Sat, 1 May
 2021 16:57:45 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45%5]) with mapi id 15.20.4108.019; Sat, 1 May 2021
 16:57:45 +0000
From:   "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Subject: Re: [PATCHv2 net 3/3] sctp: do asoc update earlier in
 sctp_sf_do_dupcook_b
Thread-Topic: [PATCHv2 net 3/3] sctp: do asoc update earlier in
 sctp_sf_do_dupcook_b
Thread-Index: AQHXPfvoxULyoeIZq0q1laKfutq9L6rOzX5P
Date:   Sat, 1 May 2021 16:57:45 +0000
Message-ID: <HE1PR0702MB38180121DAFDF7D7FEA001D5EC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>,<371d885e4d50b379aff56babe77517f6ccc32651.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <371d885e4d50b379aff56babe77517f6ccc32651.1619812899.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [91.153.156.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426609e7-400a-40b4-224f-08d90cc23e11
x-ms-traffictypediagnostic: HE1PR07MB3388:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR07MB3388E4548B8E7E5EA6614463EC5D9@HE1PR07MB3388.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qe/IdwXh+6flqceKi2y/u0xIxibzyHMUVBisD6mE6vOarv1mLpq3ocYa+1amhlIY/iMjov13ThEpcaVNvuHCaO+4wYhv4+YaiAKG7B2vKYgJx2qQyS5cT6qZWcOpyxS75+bFPzaQyq6UzoYiTlTns/Ze8evLsXTsEmdhZlu+RGjoGLa4jqYAYfACy52BDtH8YRbITr/G1+gi3saoMk1KwcAnxWAa7EHgur2bpqTiR/4hmV7v2ij7dFVWxmryFn8rzcye+VnY3iO+ot08XVgtn9gRGPWKcSx56vDhOc5e4ZafZDsGPurwKw7dkJ7kDbjDziFvBxTfUZX0WySIkRgTYzBX7PXnyT3U4Etf8WoRwxMOS+oC1MK30Ux3otKuQ/s/Iq52q0IlUBRFCe9yFFOpmXMkSM+2GB/LgDTHa/7VkzcB7EgE/0lIgVuhOVZgDwEAOBBFEJAl6/olI1ehKE9QU7/mL4wdEYKYPkwX7T3c56RE6jXX89W08fdUCsdzsXht4QsmqcPIA+U8qks59SKLWEbk4rqHFxz0lLaM5dPLE+d4dn6goTxoFnkAg+xlSiQiO9qB2laML1X4fT3okx8HCURpavOIJY0qdiyeVd3OlmI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(54906003)(55016002)(110136005)(6506007)(26005)(33656002)(2906002)(107886003)(9686003)(8936002)(7696005)(186003)(498600001)(66476007)(66446008)(64756008)(66946007)(76116006)(71200400001)(15650500001)(4326008)(38100700002)(66556008)(52536014)(86362001)(122000001)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?k88srGuJY9Zw+6s7XcXl0UPc5gI0YvAvoELfUz2nnVQvvdwDgYwUiptDy0?=
 =?iso-8859-1?Q?sI7asOwV/t3DklpvEP9BSiurIuf7OKapHJmBXwxjgVxunyeL752A08r9Ma?=
 =?iso-8859-1?Q?WZp/nkGMBWYkTQVFv1SdzU7sAu36OFU39d0AxEVwGn/e0VTj0lPgMj7Xa3?=
 =?iso-8859-1?Q?ll9ue8O9naudaG6r+hLnmbeneDGdoLjvKsWZlSeRM+Pb/U/Oak9sB1fFgH?=
 =?iso-8859-1?Q?TKQ629WA0O/BfToyIeYmUFhQwnGn7Xmd86wIMk/7dhpk/n4TXmCJ9p5N4T?=
 =?iso-8859-1?Q?Jjsca5ba7T6X0xU8CDQMSR62IGFFi04VQC3Tb8Bzc9ojW7R9WGGXtp/Vdf?=
 =?iso-8859-1?Q?TljrAJo7Zrvc8LM/AIXPuwbOhK5/PO5JDRW1OUSS8dJcnTnc6HZyWOe2qE?=
 =?iso-8859-1?Q?VeCRRJWpo4dAThVz3zpc6uqNRapYRUp2Rfn4fQlZHg+G+tg3jdR75pUIHG?=
 =?iso-8859-1?Q?p/qbcLkHuqqz49zdZSsamiPpTGHeJuggRnyJvWyjgrATyl8rY+oxZkidIn?=
 =?iso-8859-1?Q?07r9F3HYuNZbGOJtWAjKpPtYlVCExFRuaYvkGM1ngDKG5+40Tr1NWFULQB?=
 =?iso-8859-1?Q?tJoYjvJoOGOQETtRRTpKPCHX+/KnRO4Zo5hemF7IKEhI2je0DtJUAS3UZi?=
 =?iso-8859-1?Q?xYhbLl+uXh/KdmHhftTPB4cVjnySrcTK2H00HHccErEA4KJxGNIbPhGjl9?=
 =?iso-8859-1?Q?ybenzBhLBOD/7z0FM9x/QLNJHRlsWkvSpp5W4o9yuhzrt8yAUUzEI3M9Lj?=
 =?iso-8859-1?Q?86g7BfVqOD0wq+G0x5Au47S7vYqlG76qXPympoGjyYC4EF8N8dFHRwIgJF?=
 =?iso-8859-1?Q?/C4agZ3N4NAU3TVs+2akSC77Nt2oBablXMn6EfGmQgKYHIXzb9JkDabTBu?=
 =?iso-8859-1?Q?ohoKjVyEHTq7+2REKjP+yVF3mEs6tEzOx1lepS4xZhTIfI6wtXbAnZFoDZ?=
 =?iso-8859-1?Q?l+20Zff+99eGhBJzZbiq5L4ldmT75d3IBHRe9l5eEh3L8AIX23d0BKFENK?=
 =?iso-8859-1?Q?QpitsL90hc5P1ofTgPL1X9wM00zySKb3O5GyCsoWBweq8hRohTGmLFuZxe?=
 =?iso-8859-1?Q?wvbhVAVMB7Kh/SJB91s/ISV+nyKPoNB59NmDyJ5PCrDmGA61rkrA9zs3cA?=
 =?iso-8859-1?Q?BZbxMnZlvMcKThayyJnGd+IbbRtYEN0DG7ZOgLlAMc9dgXimyM3nBanB6e?=
 =?iso-8859-1?Q?qoj/QMplO315LhTvKXO0zrgAc7z+QlWumy2GD5PJQ+1/mvAFuUmjMCHL3H?=
 =?iso-8859-1?Q?/dVgAIOsTem5ENmJH920pajQzEiFqgEnpFABdgOZeX71ILDZsmXpqYmSdo?=
 =?iso-8859-1?Q?nbJbtzk7QJCYQNfGfy/JVAzyUoypBmjntcGAzeVGaID2JcWI6hzhWnTimO?=
 =?iso-8859-1?Q?ROBhdKcEjY?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0702MB3818.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426609e7-400a-40b4-224f-08d90cc23e11
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2021 16:57:45.2465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3BnUPrGylDYVcsH8El+gkjIYEt//gIGGb/As2L+VSkO9rXGUhvU88N9hMMCzKp4fEHkGOGGj7BoSRdJjdIR8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3388
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021, Xin Long wrote:=0A=
=0A=
> The same thing should be done for sctp_sf_do_dupcook_b().=0A=
> Meanwhile, SCTP_CMD_UPDATE_ASSOC cmd can be removed.=0A=
>=0A=
> v1->v2:=0A=
>  - Fix the return value in sctp_sf_do_assoc_update().=0A=
>=0A=
> Signed-off-by: Xin Long <lucien.xin@gmail.com>=0A=
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>=0A=
> ---=0A=
> include/net/sctp/command.h |  1 -=0A=
> net/sctp/sm_sideeffect.c   | 26 -------------------------=0A=
> net/sctp/sm_statefuns.c    | 47 +++++++++++++++++++++++++++++------------=
-----=0A=
> 3 files changed, 30 insertions(+), 44 deletions(-)=0A=
>=0A=
> diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h=0A=
> index e8df72e..5e84888 100644=0A=
> --- a/include/net/sctp/command.h=0A=
> +++ b/include/net/sctp/command.h=0A=
> @@ -68,7 +68,6 @@ enum sctp_verb {=0A=
>       SCTP_CMD_ASSOC_FAILED,   /* Handle association failure. */=0A=
>       SCTP_CMD_DISCARD_PACKET, /* Discard the whole packet. */=0A=
>       SCTP_CMD_GEN_SHUTDOWN,   /* Generate a SHUTDOWN chunk. */=0A=
> -     SCTP_CMD_UPDATE_ASSOC,   /* Update association information. */=0A=
>       SCTP_CMD_PURGE_OUTQUEUE, /* Purge all data waiting to be sent. */=
=0A=
>       SCTP_CMD_SETUP_T2,       /* Hi-level, setup T2-shutdown parms.  */=
=0A=
>       SCTP_CMD_RTO_PENDING,    /* Set transport's rto_pending. */=0A=
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c=0A=
> index 0948f14..ce15d59 100644=0A=
> --- a/net/sctp/sm_sideeffect.c=0A=
> +++ b/net/sctp/sm_sideeffect.c=0A=
> @@ -826,28 +826,6 @@ static void sctp_cmd_setup_t2(struct sctp_cmd_seq *c=
mds,=0A=
>       asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] =3D t->rto;=0A=
> }=0A=
>=0A=
> -static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,=0A=
> -                               struct sctp_association *asoc,=0A=
> -                               struct sctp_association *new)=0A=
> -{=0A=
> -     struct net *net =3D asoc->base.net;=0A=
> -     struct sctp_chunk *abort;=0A=
> -=0A=
> -     if (!sctp_assoc_update(asoc, new))=0A=
> -             return;=0A=
> -=0A=
> -     abort =3D sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));=
=0A=
> -     if (abort) {=0A=
> -             sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);=0A=
> -             sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));=
=0A=
> -     }=0A=
> -     sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED)=
);=0A=
> -     sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,=0A=
> -                     SCTP_PERR(SCTP_ERROR_RSRC_LOW));=0A=
> -     SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);=0A=
> -     SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);=0A=
> -}=0A=
> -=0A=
> /* Helper function to change the state of an association. */=0A=
> static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,=0A=
>                              struct sctp_association *asoc,=0A=
> @@ -1301,10 +1279,6 @@ static int sctp_cmd_interpreter(enum sctp_event_ty=
pe event_type,=0A=
>                       sctp_endpoint_add_asoc(ep, asoc);=0A=
>                       break;=0A=
>=0A=
> -             case SCTP_CMD_UPDATE_ASSOC:=0A=
> -                    sctp_cmd_assoc_update(commands, asoc, cmd->obj.asoc)=
;=0A=
> -                    break;=0A=
> -=0A=
>               case SCTP_CMD_PURGE_OUTQUEUE:=0A=
>                      sctp_outq_teardown(&asoc->outqueue);=0A=
>                      break;=0A=
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c=0A=
> index e8ccc4e..a428449 100644=0A=
> --- a/net/sctp/sm_statefuns.c=0A=
> +++ b/net/sctp/sm_statefuns.c=0A=
> @@ -1773,6 +1773,30 @@ enum sctp_disposition sctp_sf_do_5_2_3_initack(=0A=
>               return sctp_sf_discard_chunk(net, ep, asoc, type, arg, comm=
ands);=0A=
> }=0A=
>=0A=
> +static int sctp_sf_do_assoc_update(struct sctp_association *asoc,=0A=
> +                                struct sctp_association *new,=0A=
> +                                struct sctp_cmd_seq *cmds)=0A=
> +{=0A=
> +     struct net *net =3D asoc->base.net;=0A=
> +     struct sctp_chunk *abort;=0A=
> +=0A=
> +     if (!sctp_assoc_update(asoc, new))=0A=
> +             return 0;=0A=
> +=0A=
> +     abort =3D sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));=
=0A=
> +     if (abort) {=0A=
> +             sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);=0A=
> +             sctp_add_cmd_sf(cmds, SCTP_CMD_REPLY, SCTP_CHUNK(abort));=
=0A=
> +     }=0A=
> +     sctp_add_cmd_sf(cmds, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED)=
);=0A=
> +     sctp_add_cmd_sf(cmds, SCTP_CMD_ASSOC_FAILED,=0A=
> +                     SCTP_PERR(SCTP_ERROR_RSRC_LOW));=0A=
> +     SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);=0A=
> +     SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);=0A=
> +=0A=
> +     return -ENOMEM;=0A=
> +}=0A=
> +=0A=
> /* Unexpected COOKIE-ECHO handler for peer restart (Table 2, action 'A')=
=0A=
>  *=0A=
>  * Section 5.2.4=0A=
> @@ -1853,21 +1877,8 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(=
=0A=
>       sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL())=
;=0A=
>=0A=
>       /* Update the content of current association. */=0A=
> -     if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {=
=0A=
> -             struct sctp_chunk *abort;=0A=
> -=0A=
> -             abort =3D sctp_make_abort(asoc, NULL, sizeof(struct sctp_er=
rhdr));=0A=
> -             if (abort) {=0A=
> -                     sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);=0A=
> -                     sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUN=
K(abort));=0A=
> -             }=0A=
> -             sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(E=
CONNABORTED));=0A=
> -             sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,=0A=
> -                             SCTP_PERR(SCTP_ERROR_RSRC_LOW));=0A=
> -             SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);=0A=
> -             SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);=0A=
> +     if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_as=
oc, commands))=0A=
>               goto nomem;=0A=
> -     }=0A=
>=0A=
>       repl =3D sctp_make_cookie_ack(asoc, chunk);=0A=
>       if (!repl)=0A=
> @@ -1940,14 +1951,16 @@ static enum sctp_disposition sctp_sf_do_dupcook_b=
(=0A=
>       if (!sctp_auth_chunk_verify(net, chunk, new_asoc))=0A=
>               return SCTP_DISPOSITION_DISCARD;=0A=
>=0A=
> -     /* Update the content of current association.  */=0A=
> -     sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc=
));=0A=
>       sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,=0A=
>                       SCTP_STATE(SCTP_STATE_ESTABLISHED));=0A=
>       SCTP_INC_STATS(net, SCTP_MIB_CURRESTAB);=0A=
>       sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());=
=0A=
>=0A=
> -     repl =3D sctp_make_cookie_ack(new_asoc, chunk);=0A=
> +     /* Update the content of current association.  */=0A=
> +     if (sctp_sf_do_assoc_update((struct sctp_association *)asoc, new_as=
oc, commands))=0A=
> +             goto nomem;=0A=
=0A=
Wouldn't it be better to do the update before SCTP_CMD_NEW_STATE?=0A=
Or do we have some reason to move to SCTP_STATE_ESTABLISHED even=0A=
if the update fails?=0A=
=0A=
> +=0A=
> +     repl =3D sctp_make_cookie_ack(asoc, chunk);=0A=
>       if (!repl)=0A=
>               goto nomem;=0A=
>=0A=
> -- =0A=
> 2.1.0=0A=
