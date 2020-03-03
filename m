Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537AB17828B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgCCSil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:38:41 -0500
Received: from mail-eopbgr40122.outbound.protection.outlook.com ([40.107.4.122]:24833
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbgCCSil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 13:38:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/eLUOcfoqFiA6U8AbYkz4pPTytd52AvK10YQ/A/FiJQ+MXM0NMjO+/ngSUiSx6rredZsiLi7A91AR5mW59oP4Exr1Dl8Dutp0oDG862+/FwtjbDTe4Z2lGBXM6h2x4tFJT9mCAP/t9/mQu9XrDNOoV9muINoH8SV0oy2T+BZHUA6EPVUu0xXM2T8FZE+6nSxbvWBjf3Bhpy2NnWjmk705sXTB/18ZSxMbF/hDDsVs8ZEuacAIOFFJxpG7B2LJfwVdKuhzUwR0XuVq8tYC9tLh66jS7AEb2xbX+bSng6zM20kqKQkfaPMxhw/56+Mo9xbTplrEsJusVFw3I+pbsn/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUMYCkML2eSWoIfwvOU1VmznssywHW2ZGkhqqFXHsE0=;
 b=GIaD1m6Hb3czmIugtXLFr2JqHaqzXtUI7ZBTcmOoB1VHcCQtCtK2RlXV0pHuy76lpRY7gW693KzfsZovCoNpwkuCr2AGJJ+GxpKGnVq309zDhwQVged19vrXbJDBLLDLyhcuBMcQ8Bu0VGJOJfjqadnYuV+f2NXSKeLV6/v/QvyOFQGhSIt3IfkE2QgU8Kx0i7qrSRu8z7fgDTTVM8bbgHJ5C+T5wMIiBlYIUZ6z0Yp2dPrTxO+yMeSJMpavAXfcWe5g159ELVaqLmQzrGjklzyLS4xnh5x8JIMvBgXd2VUDTNKA4sg1iM6aFv9eIBsgWx/Xdi9Xqb199sh09FKNIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUMYCkML2eSWoIfwvOU1VmznssywHW2ZGkhqqFXHsE0=;
 b=lQaFw9BIHakwYXEkNxAI2I8r9D/wOHCwjOtgrzatQr/EjukDgdsGV/HbguUlyZYB1iYuLBSTa3jOkvM0PO+97NbyHurFWgf7ztiaYXJg37QdENS8Qbty9lHsegYbtgIGYI9ZzOzigZSd5YbV4IaFTcnBeedAeO8j/8/ACLvhlCc=
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com (10.167.124.27) by
 HE1PR0702MB3692.eurprd07.prod.outlook.com (10.167.125.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.9; Tue, 3 Mar 2020 18:38:36 +0000
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a]) by HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a%7]) with mapi id 15.20.2793.011; Tue, 3 Mar 2020
 18:38:36 +0000
From:   "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: RE: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Thread-Topic: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Thread-Index: AQHV8F/VPCMYKsueh0aWHP1s8s9XQqg2tObg
Date:   Tue, 3 Mar 2020 18:38:35 +0000
Message-ID: <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
In-Reply-To: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
x-originating-ip: [91.153.156.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a6e08aa-40b4-402f-6fd6-08d7bfa2158e
x-ms-traffictypediagnostic: HE1PR0702MB3692:
x-microsoft-antispam-prvs: <HE1PR0702MB3692F0274D08683946947487ECE40@HE1PR0702MB3692.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(316002)(33656002)(6506007)(2906002)(110136005)(478600001)(5660300002)(81156014)(81166006)(54906003)(8676002)(8936002)(66946007)(52536014)(7696005)(76116006)(66446008)(66556008)(55016002)(64756008)(9686003)(26005)(66476007)(186003)(86362001)(4326008)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3692;H:HE1PR0702MB3610.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P2V9N/gmv/7fVwfilqH+/88NHhVmqR+E1LOGfSGFlgrbJtOnahi2dq4ziq22uSODqkqvI6A3mV4Zg5ckUKLZJX+qrQ4ICM7H6DL0syzVguNXBVPhfrkaLheg1SoKQnItt4F+nioyIzRXu8ireqNBeg3tovCfYJnE0YntkRXUKgTyIyWLiKbve1LYWM4avkbTq5zqKXB+iUOYn5Lqd/2sW1ifHokZP051Pwc9/8wWN1znrWV87dSYHNibV+Pg1nDIW6FpHKUyNf/sQAd6xEs1+Z4wifegdDREaPGc4VMHfMZoZ6lu8wfGbqxH9eYr7+ED1sgwXYF+KTr+2khlCgxVs8nkCziSfWGtVklOfB9CKlc3T++64SYL0atv+n6cLDWdXY0XyGzB39g56hm7l5b6aBWROOKPgmLxD+IkWPUK+7Ckx6vTK7xpt60DYxkrEx6r
x-ms-exchange-antispam-messagedata: b4WyMPmKsskhoylJB/HVDlyKyzmNusg+LgYOSWaVgelEGVJJKM5NKE4wVo5ALp8P1GsM/J70dbz9cnkl/mwLWsiqh7u7hoOdbeOn/4Flfd5Mtj0FTpXAPdMl/Ia2zZXaFRNkudympTLPhDJPHhwO/Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6e08aa-40b4-402f-6fd6-08d7bfa2158e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 18:38:35.9979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iTvZJExMbgLMlZJ3FpVf95u855yI/8gXmCEOqgQTl0WigN3MV03t/gtXSzzVyQoZXBYxz3Sozu0O8DBN/a0mNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3692
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020, Xin Long wrote:=0A=
=0A=
> As it says in rfc6458#section-9.2:=0A=
> =0A=
>   The application uses the sctp_peeloff() call to branch off an=0A=
>   association into a separate socket.  (Note that the semantics are=0A=
>   somewhat changed from the traditional one-to-one style accept()=0A=
>   call.)  Note also that the new socket is a one-to-one style socket.=0A=
>   Thus, it will be confined to operations allowed for a one-to-one=0A=
>   style socket.=0A=
> =0A=
> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,=
=0A=
> on which some operations are not allowed, like shutdown, as Jere=0A=
> reported.=0A=
> =0A=
> This patch is to change it to return a one-to-one type socket instead.=0A=
=0A=
Thanks for looking into this. I like the patch, and it fixes my simple=0A=
test case.=0A=
=0A=
But with this patch, peeled-off sockets are created by copying from a=0A=
one-to-many socket to a one-to-one socket. Are you sure that that's=0A=
not going to cause any problems? Is it possible that there was a=0A=
reason why peeloff wasn't implemented this way in the first place?=0A=
=0A=
With this patch there's no way to create UDP_HIGH_BANDWIDTH style=0A=
sockets anymore, so the remaining references should probably be=0A=
cleaned up:=0A=
=0A=
./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && =
msg->msg_name) {=0A=
./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))=0A=
./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,=0A=
=0A=
This patch disables those checks. The first one ignores a destination=0A=
address given to sendmsg() with a peeled-off socket - I don't know=0A=
why. The second one prevents listen() on a peeled-off socket.=0A=
=0A=
> =0A=
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
> Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>=
=0A=
=0A=
Reported-by: Jere Leppanen <jere.leppanen@nokia.com>=0A=
=0A=
> Signed-off-by: Xin Long <lucien.xin@gmail.com>=0A=
> ---=0A=
>  net/sctp/socket.c | 15 ++++++---------=0A=
>  1 file changed, 6 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c=0A=
> index 1b56fc4..2b55beb 100644=0A=
> --- a/net/sctp/socket.c=0A=
> +++ b/net/sctp/socket.c=0A=
> @@ -88,8 +88,7 @@ static int sctp_send_asconf(struct sctp_association *as=
oc,=0A=
>  static int sctp_do_bind(struct sock *, union sctp_addr *, int);=0A=
>  static int sctp_autobind(struct sock *sk);=0A=
>  static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,=0A=
> -			     struct sctp_association *assoc,=0A=
> -			     enum sctp_socket_type type);=0A=
> +			     struct sctp_association *assoc);=0A=
>  =0A=
>  static unsigned long sctp_memory_pressure;=0A=
>  static atomic_long_t sctp_memory_allocated;=0A=
> @@ -4965,7 +4964,7 @@ static struct sock *sctp_accept(struct sock *sk, in=
t flags, int *err, bool kern)=0A=
>  	/* Populate the fields of the newsk from the oldsk and migrate the=0A=
>  	 * asoc to the newsk.=0A=
>  	 */=0A=
> -	error =3D sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);=0A=
> +	error =3D sctp_sock_migrate(sk, newsk, asoc);=0A=
>  	if (error) {=0A=
>  		sk_common_release(newsk);=0A=
>  		newsk =3D NULL;=0A=
> @@ -5711,7 +5710,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t i=
d, struct socket **sockp)=0A=
>  		return -EINVAL;=0A=
>  =0A=
>  	/* Create a new socket.  */=0A=
> -	err =3D sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock)=
;=0A=
> +	err =3D sock_create(sk->sk_family, SOCK_STREAM, IPPROTO_SCTP, &sock);=
=0A=
>  	if (err < 0)=0A=
>  		return err;=0A=
>  =0A=
> @@ -5727,8 +5726,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t i=
d, struct socket **sockp)=0A=
>  	/* Populate the fields of the newsk from the oldsk and migrate the=0A=
>  	 * asoc to the newsk.=0A=
>  	 */=0A=
> -	err =3D sctp_sock_migrate(sk, sock->sk, asoc,=0A=
> -				SCTP_SOCKET_UDP_HIGH_BANDWIDTH);=0A=
> +	err =3D sctp_sock_migrate(sk, sock->sk, asoc);=0A=
>  	if (err) {=0A=
>  		sock_release(sock);=0A=
>  		sock =3D NULL;=0A=
> @@ -9453,8 +9451,7 @@ static inline void sctp_copy_descendant(struct sock=
 *sk_to,=0A=
>   * and its messages to the newsk.=0A=
>   */=0A=
>  static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,=0A=
> -			     struct sctp_association *assoc,=0A=
> -			     enum sctp_socket_type type)=0A=
> +			     struct sctp_association *assoc)=0A=
>  {=0A=
>  	struct sctp_sock *oldsp =3D sctp_sk(oldsk);=0A=
>  	struct sctp_sock *newsp =3D sctp_sk(newsk);=0A=
> @@ -9562,7 +9559,7 @@ static int sctp_sock_migrate(struct sock *oldsk, st=
ruct sock *newsk,=0A=
>  	 * original UDP-style socket or created with the accept() call on a=0A=
>  	 * TCP-style socket..=0A=
>  	 */=0A=
> -	newsp->type =3D type;=0A=
> +	newsp->type =3D SCTP_SOCKET_TCP;=0A=
>  =0A=
>  	/* Mark the new socket "in-use" by the user so that any packets=0A=
>  	 * that may arrive on the association after we've moved it are=0A=
> -- =0A=
> 2.1.0=0A=
