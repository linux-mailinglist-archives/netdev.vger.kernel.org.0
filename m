Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32FF1DC19A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgETVvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:51:17 -0400
Received: from mail-eopbgr40098.outbound.protection.outlook.com ([40.107.4.98]:55046
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbgETVvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:51:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOj7wtadohe1RTHP8EvgT4hCRLlIi1rNI5usegvJIazZwpB0wpQMbGGYPZwMIxSNVDD6SMGnD1xdansSNLnnXHc8ADbQulJca/k0xEe7dFRnOa9m2fv5lCOaMGBK+2Rpz7sJDHKfn+AFBrCQmbedhrknsGMA7NxRtnDCREQPGCo9EZZ4VHYT0jxjXWkFWH8UXrzMRgdxotwmbmx8KJtQ+0IAtnISRphhP1/6Y/MS7BZsEji2AX8P0J8TmlR0vUXanRjb4cpvFmsY0HwCkrEDEB6l+4tF3kAH3FpQ3sXpMJsW1924JFRXS7vExPjEBjV6eIivgi+tzanqpB3iEBUPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OX62dhEOCWcNCxihQLstOKxL7p3S0PFSXXycQQIxMO4=;
 b=oZ2zC8s9tQJtDmRIv1Zwbj5ohD1U8mqlvZPecycPytfRW0fXKFFt+HuCs/Jof1OfFBvOggt6QkVsBVPUC9Rw4ah96UVdhQ8O40suxRgN/mCEyv/r4ElGdHf7qg4NLUdBm9i9cbckks4MVkmqd1IIq6vTfQb9E+FbjiaDJuhNtd83CCBtCkNU2nRnMhdsCkMcYCgOUXGLTUqYKxaTI8MZIRb2Ir1qh+kKpD6YYVEbmaEKlJN9dgUlYz4oFyTHa75HFgwQJ6I6FzDKpMwDLwIos3Gqk62G1TMVaeD7oedFxLqrD4sp16Zn1iD3D5zMRcUiMp1TNiUgDDBsvHUpEERb7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OX62dhEOCWcNCxihQLstOKxL7p3S0PFSXXycQQIxMO4=;
 b=OFHggydrFRnvkhES8cKoHa7WZXfUH3ywfDWaGhAvnmUTYOxveLQeO+ctOu431DWHAcI8Ig6tBEuT/L5HRTDGNRu616K7gS87d6RSPcUg3lTkErszGp0efyVAHQsCVKtZKIKDgi6LCXslnQQV+1YcNaiVvgJGbcrZXMcqa0P7JTk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nokia.com;
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3561.eurprd07.prod.outlook.com (2603:10a6:7:8b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.12; Wed, 20 May
 2020 21:51:11 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::f0bb:b1ae:bf22:4526%6]) with mapi id 15.20.3021.019; Wed, 20 May 2020
 21:51:11 +0000
Date:   Thu, 21 May 2020 00:50:58 +0300 (EEST)
From:   =?ISO-8859-15?Q?Jere_Lepp=E4nen?= <jere.leppanen@nokia.com>
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
cc:     =?ISO-8859-15?Q?Jere_Lepp=E4nen?= <jere.leppanen@nokia.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH net 1/1] sctp: Start shutdown on association restart if
 in SHUTDOWN-SENT state and socket is closed
In-Reply-To: <20200520194629.GS2491@localhost.localdomain>
Message-ID: <alpine.LFD.2.21.2005210039550.789637@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
References: <20200520151531.787414-1-jere.leppanen@nokia.com> <20200520194629.GS2491@localhost.localdomain>
Content-Type: multipart/mixed; boundary="352996365-1605154134-1590011470=:789637"
X-ClientProxiedBy: AM4P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::13) To HE1PR0702MB3818.eurprd07.prod.outlook.com
 (2603:10a6:7:8c::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by AM4P190CA0003.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 21:51:10 +0000
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71247082-4bd6-4629-7f37-08d7fd07e8b8
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3561FA94AD4FA1B597B97721ECB60@HE1PR0702MB3561.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sg5dAtlopGlyJjujvaDngI2/wDlTUmqBAxLtwTJiVvlwk4rzDHJhgubHS+Aia7mnXAkQJgB6+4Th//pMeunFZhfK6iyYzNhVabgq9Mz8oAcuyq4OX08WbWPusMerQLtZ5Sk4YxKFup5xx+Dpd83t9f/bkeYJbv3cmZWBTg9zBHSbw4dtKWLY/vewmp5bkH7HgkBk3M/3mZ3qLzp5wQeGMwQOeU/tiqWfZzFmmNby93zk4WtjVTwEZJIeR0s8GDDO9w2F148NmhnBtJ32XZVLXn3pLNfqOIUYIp24wBnK1K/vO5tnc7c74ySvSw7miYwD8egKSmzEGzP6BbQLhzsOHcbCYyKXW0SpMV6zOmPl8/28cxojyH4IVkvE2kitxEvP0Q2SdSA0aaqV1/o+H5GIPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(52116002)(26005)(8676002)(66556008)(6666004)(7696005)(9686003)(66946007)(86362001)(8936002)(66476007)(316002)(55016002)(5660300002)(6506007)(478600001)(966005)(186003)(54906003)(2906002)(16526019)(6916009)(956004)(4326008)(66574014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5DRFgc4NN4VMaCnX8fi5RqiHKGp1HeKhSZgZt5C0iE15OpbUwk1cAjrpRyXAD2/5DQ5PvmvkPdzAlNyYA64otVJCutYEwFSIhwVGH6XnNzKGxnej7arg0/9AmELbDIPYNuuaoIjQzpiSi079qwAeEj01PSZQBmaTZsddpcIQqKlB/7t3KUUk0SxVA3F2inQ4oj3AHeMmKFMlsy1Jk1CZLJ//sRF8Ad4VKoS6veVCBTtq9hu7JIpeQwlg5CRpaY42sRuyAT6pa49WZG5EhjdDTB7AXyDjbV0iNtKS+JjVK4jq+n32w8JBDMUKI+eQYUjIM6EV86pY4vmTObBbyYKCmNhb3vJfZhxa5D2YZD/OlE/N2RMbGOxCJFF5onpSnYlrKomK+gj9Q9RKgSZf2T2243B19h7Gt7SREgBSBrmTHUi2/P3GSe4IdxhAhpks/Q+jWSFRQMzxTAue79SNgY2ILExJoT3taeWOmjw2FxDvSR8=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71247082-4bd6-4629-7f37-08d7fd07e8b8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 21:51:11.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ss0AjrrqP/zNdcWmG1ROX/tUEC4owX0ji8S/bePzCLjtwasEwR2If7XXjQ9NohOhFQwquc60/ZAHxp6EzfDaMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3561
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--352996365-1605154134-1590011470=:789637
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 20 May 2020, Marcelo Ricardo Leitner wrote:

> On Wed, May 20, 2020 at 06:15:31PM +0300, Jere Leppänen wrote:
> > Commit bdf6fa52f01b ("sctp: handle association restarts when the
> > socket is closed.") starts shutdown when an association is restarted,
> > if in SHUTDOWN-PENDING state and the socket is closed. However, the
> > rationale stated in that commit applies also when in SHUTDOWN-SENT
> > state - we don't want to move an association to ESTABLISHED state when
> > the socket has been closed, because that results in an association
> > that is unreachable from user space.
> > 
> > The problem scenario:
> > 
> > 1.  Client crashes and/or restarts.
> > 
> > 2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.
> > 
> > 3.  Client reconnects using the same addresses and ports.
> > 
> > 4.  Server's association is restarted. The association and the socket
> >     move to ESTABLISHED state, even though the server process has
> >     closed its descriptor.
> > 
> > Also, after step 4 when the server process exits, some resources are
> > leaked in an attempt to release the underlying inet sock structure in
> > ESTABLISHED state:
> > 
> >     IPv4: Attempt to release TCP socket in state 1 00000000377288c7
> > 
> > Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
> > an association is restarted in SHUTDOWN-SENT state and the socket is
> > closed, then start shutdown and don't move the association or the
> > socket to ESTABLISHED state.
> > 
> > Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
> > Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>
> > ---
> >  net/sctp/sm_statefuns.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > index 26788f4a3b9e..e86620fbd90f 100644
> > --- a/net/sctp/sm_statefuns.c
> > +++ b/net/sctp/sm_statefuns.c
> > @@ -1856,12 +1856,13 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
> >  	/* Update the content of current association. */
> >  	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
> >  	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
> > -	if (sctp_state(asoc, SHUTDOWN_PENDING) &&
> > +	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
> > +	     sctp_state(asoc, SHUTDOWN_SENT)) &&
> >  	    (sctp_sstate(asoc->base.sk, CLOSING) ||
> >  	     sock_flag(asoc->base.sk, SOCK_DEAD))) {
> > -		/* if were currently in SHUTDOWN_PENDING, but the socket
> > -		 * has been closed by user, don't transition to ESTABLISHED.
> > -		 * Instead trigger SHUTDOWN bundled with COOKIE_ACK.
> > +		/* If the socket has been closed by user, don't
> > +		 * transition to ESTABLISHED. Instead trigger SHUTDOWN
> > +		 * bundled with COOKIE_ACK.
> >  		 */
> >  		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
> >  		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
> > 
> > base-commit: 20a785aa52c82246055a089e55df9dac47d67da1
> 
> This last line is not standard, but git didn't complain about it here.

The git format-patch --base option. It's mentioned in the docs:

https://www.kernel.org/doc/html/v5.6/process/submitting-patches.html#providing-base-tree-information

> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks for the speedy ack, Marcelo.
--352996365-1605154134-1590011470=:789637--
