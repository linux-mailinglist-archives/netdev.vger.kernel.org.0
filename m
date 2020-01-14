Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D4B139E98
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgANAwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 19:52:19 -0500
Received: from mail-dm6nam11on2129.outbound.protection.outlook.com ([40.107.223.129]:26113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgANAwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 19:52:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoZNUncx5uulUVXtEnViDBqd2OTMi6jzjtHOJTqCvnqRYTFhUwmFiV3U8TfOe7m0q41+cZi1rHrxa8LX0VtOBeggpZuE/oGZgsievT3ezkcVV9ZJpQag9fJJP2fpHXSNqRSFqJXfRitLeyCq1psR1i3U/PilJc92ew/nsDyJjHADkqI78/XmT5sgyzMTotP+xtdkXEYIf/dFT/MUfQKDGNAerqylZP4ht96CHcQK3B21Oea1eGO8aRDSPrLLF3LlJ8zEsQlayK1qlukswCdYsU1CKMU7hUYIdVHcZZyUCJ4ao7b4GMUqUwOcc+NJlUzdkZwx7TBofoaKVma/J7BL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGQLEJGPUMi8Hg3s78JzmlE130VimwEGtOPucNQ8XzQ=;
 b=TFmGnYoOTcedh8WsbugBuHBDgl5VkhgYMZOGy3Qkkmc6DOveZoNt3SPKpLMnZtTWipKCVLltaFpyJKuyTq3MGT2U2ziPGLjDyI9roSubEreKUEqjg3C4ssb+fjwN7zQvjWFYrPTCV61knE//+JbS4BsBvU7P08ERZU3v//YdEIXfurh3ajJ5vfCM98RoygF3HFAIcv58bUmJIbNy+sUtUxd0EzW7A72aib29p156Ns6Ih2Ay0MwI9P9SK4eK9YDt28vLFMBh3X2A9BckAMJk0xJbRvUQz5A3+URxRUqRlDUzMg4bY36dPJ/SbuNtbDNdrsFfwfNeJ+Bo5B1i7dOVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGQLEJGPUMi8Hg3s78JzmlE130VimwEGtOPucNQ8XzQ=;
 b=eOU2SEsjzeVKLNASh8vgfVHMoX+Eu3gmurkjlP69UFy08POAsmIVS0NJma3a8RyuaQVJ6K4TxHtLw/ynsZOfKAVFjLzgTEkC0GzFKUi5mcfheoGMD/vXfxl/MnPoGnK3LnbY+Ik57+b5R+AitQCN/IciFUwjTbi4ZAya+FUcdeQ=
Received: from SN4PR2101MB0880.namprd21.prod.outlook.com (10.167.151.161) by
 SN4PR2101MB0815.namprd21.prod.outlook.com (10.167.151.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.4; Tue, 14 Jan 2020 00:52:14 +0000
Received: from SN4PR2101MB0880.namprd21.prod.outlook.com
 ([fe80::a9bd:595e:2ea9:471a]) by SN4PR2101MB0880.namprd21.prod.outlook.com
 ([fe80::a9bd:595e:2ea9:471a%2]) with mapi id 15.20.2644.015; Tue, 14 Jan 2020
 00:52:14 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>
CC:     Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net]: hv_sock: Remove the accept port restriction
Thread-Topic: [PATCH net]: hv_sock: Remove the accept port restriction
Thread-Index: AdXKdNH1RBG+R7RHRNOEABe6Ndiffg==
Date:   Tue, 14 Jan 2020 00:52:14 +0000
Message-ID: <SN4PR2101MB08808AAFCEB4E8FC178A4B79C0340@SN4PR2101MB0880.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:b:54a5:1766:8019:ea72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c92bebbe-8d07-4dae-2a18-08d7988bff39
x-ms-traffictypediagnostic: SN4PR2101MB0815:|SN4PR2101MB0815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR2101MB08156DE26D665DF075EFB23DC0340@SN4PR2101MB0815.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(6506007)(2906002)(8936002)(6636002)(71200400001)(186003)(10290500003)(110136005)(54906003)(81156014)(8676002)(8990500004)(478600001)(81166006)(7696005)(66946007)(66556008)(9686003)(64756008)(76116006)(66476007)(4326008)(33656002)(52536014)(66446008)(316002)(86362001)(5660300002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0815;H:SN4PR2101MB0880.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HDQlhvm3WIepmhpOMX/tc7W/t/qS8xBglmSGsNBrReyndrpdGMetFyD6PFTJH5MBYqjz9jyBFjO8q9UqfpdvSqtEX1Nu72ORAsnqmFLkgskH7zSzKJuAhBI24mkIO3QRwF8LqM+ezBg+ogqVfo2uiCF/fLIVO3e9cPNEm46PMn3vIVjR7R4Vu9kn+ak/uFTjx3RP9uWh+EPJoqTQX1+DoCVk2JuHx6MNUydU2WAT28NMpN1tksP93WLw733V4Ej10f5UYUDbjqf/Qfz1A6z1VvCP3uqGoLBreUp/sfvjwB8C/AiI0OVcqp6R5h4aqDa333X8kfBXxEHPpnln1f6fGmPecRE8zr0PFrldSxzDsJStfIg/2GYKrv8Qu7tFaLyQlhjChVIWVMqh51ixnD6bxbscKMKEWLWJQcI7IuB04Z3NchRjBhuveRvrXIzKgSsW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92bebbe-8d07-4dae-2a18-08d7988bff39
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 00:52:14.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wVh/lXvs/bCVdHpqtOSOxSdAoSUHwzQR+qROwlVgl5PncNhz3pWbolDyE5IhtsKM225GPQn4FV8HF82ThElrvqe1zAOJkNkXOxeU1Guk+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, hv_sock restricts the port the guest socket can accept
connections on. hv_sock divides the socket port namespace into two parts
for server side (listening socket), 0-0x7FFFFFFF & 0x80000000-0xFFFFFFFF
(there are no restrictions on client port namespace). The first part
(0-0x7FFFFFFF) is reserved for sockets where connections can be accepted.
The second part (0x80000000-0xFFFFFFFF) is reserved for allocating ports
for the peer (host) socket, once a connection is accepted.
This reservation of the port namespace is specific to hv_sock and not
known by the generic vsock library (ex: af_vsock). This is problematic
because auto-binds/ephemeral ports are handled by the generic vsock
library and it has no knowledge of this port reservation and could
allocate a port that is not compatible with hv_sock (and legitimately so).
The issue hasn't surfaced so far because the auto-bind code of vsock
(__vsock_bind_stream) prior to the change 'VSOCK: bind to random port for
VMADDR_PORT_ANY' would start walking up from LAST_RESERVED_PORT (1023) and
start assigning ports. That will take a large number of iterations to hit
0x7FFFFFFF. But, after the above change to randomize port selection, the
issue has started coming up more frequently.
There has really been no good reason to have this port reservation logic
in hv_sock from the get go. Reserving a local port for peer ports is not
how things are handled generally. Peer ports should reflect the peer port.
This fixes the issue by lifting the port reservation, and also returns the
right peer port. Since the code converts the GUID to the peer port (by
using the first 4 bytes), there is a possibility of conflicts, but that
seems like a reasonable risk to take, given this is limited to vsock and
that only applies to all local sockets.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
 net/vmw_vsock/hyperv_transport.c | 65 +++-----------------------------
 1 file changed, 6 insertions(+), 59 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index b3bdae74c243..3492c021925f 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -138,28 +138,15 @@ struct hvsock {
  *************************************************************************=
***
  * The only valid Service GUIDs, from the perspectives of both the host an=
d *
  * Linux VM, that can be connected by the other end, must conform to this =
  *
- * format: <port>-facb-11e6-bd58-64006a7986d3, and the "port" must be in  =
  *
- * this range [0, 0x7FFFFFFF].                                            =
  *
+ * format: <port>-facb-11e6-bd58-64006a7986d3.                            =
  *
  *************************************************************************=
***
  *
  * When we write apps on the host to connect(), the GUID ServiceID is used=
.
  * When we write apps in Linux VM to connect(), we only need to specify th=
e
  * port and the driver will form the GUID and use that to request the host=
.
  *
- * From the perspective of Linux VM:
- * 1. the local ephemeral port (i.e. the local auto-bound port when we cal=
l
- * connect() without explicit bind()) is generated by __vsock_bind_stream(=
),
- * and the range is [1024, 0xFFFFFFFF).
- * 2. the remote ephemeral port (i.e. the auto-generated remote port for
- * a connect request initiated by the host's connect()) is generated by
- * hvs_remote_addr_init() and the range is [0x80000000, 0xFFFFFFFF).
  */
=20
-#define MAX_LISTEN_PORT			((u32)0x7FFFFFFF)
-#define MAX_VM_LISTEN_PORT		MAX_LISTEN_PORT
-#define MAX_HOST_LISTEN_PORT		MAX_LISTEN_PORT
-#define MIN_HOST_EPHEMERAL_PORT		(MAX_HOST_LISTEN_PORT + 1)
-
 /* 00000000-facb-11e6-bd58-64006a7986d3 */
 static const guid_t srv_id_template =3D
 	GUID_INIT(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
@@ -184,34 +171,6 @@ static void hvs_addr_init(struct sockaddr_vm *addr, co=
nst guid_t *svr_id)
 	vsock_addr_init(addr, VMADDR_CID_ANY, port);
 }
=20
-static void hvs_remote_addr_init(struct sockaddr_vm *remote,
-				 struct sockaddr_vm *local)
-{
-	static u32 host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
-	struct sock *sk;
-
-	/* Remote peer is always the host */
-	vsock_addr_init(remote, VMADDR_CID_HOST, VMADDR_PORT_ANY);
-
-	while (1) {
-		/* Wrap around ? */
-		if (host_ephemeral_port < MIN_HOST_EPHEMERAL_PORT ||
-		    host_ephemeral_port =3D=3D VMADDR_PORT_ANY)
-			host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
-
-		remote->svm_port =3D host_ephemeral_port++;
-
-		sk =3D vsock_find_connected_socket(remote, local);
-		if (!sk) {
-			/* Found an available ephemeral port */
-			return;
-		}
-
-		/* Release refcnt got in vsock_find_connected_socket */
-		sock_put(sk);
-	}
-}
-
 static void hvs_set_channel_pending_send_size(struct vmbus_channel *chan)
 {
 	set_channel_pending_send_size(chan,
@@ -341,12 +300,7 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
 	if_type =3D &chan->offermsg.offer.if_type;
 	if_instance =3D &chan->offermsg.offer.if_instance;
 	conn_from_host =3D chan->offermsg.offer.u.pipe.user_def[0];
-
-	/* The host or the VM should only listen on a port in
-	 * [0, MAX_LISTEN_PORT]
-	 */
-	if (!is_valid_srv_id(if_type) ||
-	    get_port_by_srv_id(if_type) > MAX_LISTEN_PORT)
+	if (!is_valid_srv_id(if_type))
 		return;
=20
 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
@@ -371,8 +325,11 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
 		vnew =3D vsock_sk(new);
=20
 		hvs_addr_init(&vnew->local_addr, if_type);
-		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
=20
+		/* Remote peer is always the host */
+		vsock_addr_init(&vnew->remote_addr,
+				VMADDR_CID_HOST, VMADDR_PORT_ANY);
+		vnew->remote_addr.svm_port =3D get_port_by_srv_id(if_instance);
 		ret =3D vsock_assign_transport(vnew, vsock_sk(sk));
 		/* Transport assigned (looking at remote_addr) must be the
 		 * same where we received the request.
@@ -766,16 +723,6 @@ static bool hvs_stream_is_active(struct vsock_sock *vs=
k)
=20
 static bool hvs_stream_allow(u32 cid, u32 port)
 {
-	/* The host's port range [MIN_HOST_EPHEMERAL_PORT, 0xFFFFFFFF) is
-	 * reserved as ephemeral ports, which are used as the host's ports
-	 * when the host initiates connections.
-	 *
-	 * Perform this check in the guest so an immediate error is produced
-	 * instead of a timeout.
-	 */
-	if (port > MAX_HOST_LISTEN_PORT)
-		return false;
-
 	if (cid =3D=3D VMADDR_CID_HOST)
 		return true;
=20
--=20
2.17.1
