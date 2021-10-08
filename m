Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A95426F61
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhJHRLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 13:11:39 -0400
Received: from relay-b01.edpnet.be ([212.71.1.221]:56908 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhJHRLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 13:11:38 -0400
X-ASG-Debug-ID: 1633712978-15c4341a8812a4040001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (94.105.120.149.dyn.edpnet.net [94.105.120.149]) by relay-b01.edpnet.be with ESMTP id 9YazIlV7jGF6uqr7; Fri, 08 Oct 2021 19:09:38 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 94.105.120.149.dyn.edpnet.net[94.105.120.149]
X-Barracuda-Apparent-Source-IP: 94.105.120.149
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 5ED651697A73;
        Fri,  8 Oct 2021 19:09:38 +0200 (CEST)
Date:   Fri, 8 Oct 2021 19:09:37 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Message-ID: <20211008170937.GA12224@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Mail-Followup-To: Oleksij Rempel <o.rempel@pengutronix.de>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
 <20211008110007.GE29653@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211008110007.GE29653@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 94.105.120.149.dyn.edpnet.net[94.105.120.149]
X-Barracuda-Start-Time: 1633712978
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3123
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.93131
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.50 BSF_RULE7568M          Custom Rule 7568M
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 Oct 2021 13:00:07 +0200, Oleksij Rempel wrote:
> On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
> > Hi Kurt,
> > Sorry for the late reply.
> > 
> > On 2021/9/30 15:42, Kurt Van Dijck wrote:
> > > On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
> > >> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
> > >> cancel session when receive unexpected TP.DT message.
> > > 
> > > SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
> > > However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
> > > If I remember well, they are even not 'reserved'.
> > 
> > Agree, these bytes are meaningless for last TP.DT.
> > 
> > >
> > >>
> > >> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> > >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > >> ---
> > >>  net/can/j1939/transport.c | 7 +++++--
> > >>  1 file changed, 5 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> > >> index bb5c4b8..eedaeaf 100644
> > >> --- a/net/can/j1939/transport.c
> > >> +++ b/net/can/j1939/transport.c
> > >> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
> > >>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> > >>  				 struct sk_buff *skb)
> > >>  {
> > >> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
> > >>  	struct j1939_priv *priv = session->priv;
> > >>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
> > >>  	struct sk_buff *se_skb = NULL;
> > >> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> > >>  
> > >>  	skcb = j1939_skb_to_cb(skb);
> > >>  	dat = skb->data;
> > >> -	if (skb->len <= 1)
> > >> +	if (skb->len != 8) {
> > >>  		/* makes no sense */
> > >> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
> > >>  		goto out_session_cancel;
> > > 
> > > I think this is a situation of
> > > "be strict on what you send, be tolerant on what you receive".
> > > 
> > > Did you find a technical reason to abort a session because the last frame didn't
> > > bring overhead that you don't use?
> > 
> > No technical reason. The only reason is that SAE-J1939-82 requires responder
> > to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).

IMHO, this is some kind of laziness to make the exception for the last TP.DT.

I attended an ISOBUS certification (back in 2013) where the transmitting
node effectively stripped the trailing bytes, and this 'deviation' was
not even noticed.

This change applies to the receiving side. Would a sender that
leaves the trailing bytes want you to discard the session bacause of this?
So the spirit of the SAE-J1939-82 is, in this case, different from
the strict literal interpretation.

> 
> Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
> TP.DT data packets are not correct size" ... "Verify DUT discards the
> BAM transport if any TP.DT data packet has less than 8 bytes"?

Kind regards,
Kurt
