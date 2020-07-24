Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C8022BE0F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXG0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGXG0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:26:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FABC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:26:02 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595571960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=06rp+oHIu83X014OwhuO3Yo50SE1lVaYHF3HF2M3tlo=;
        b=ZR80GPs/7Eo5HtL+8bmFHwkhFTwTCHQWSZDfiXnIEXk/6v+VE7IYdOHik45t0uRFvrcvFh
        132B0LqqBoun9G8hj9QAWx/tF26GR9kMghL+98OmVb2cFcOwtnbcJl4w5uvhn5yTXqXH2U
        3NwccxFZU036tX6dgMbuA2FzAOVLOGMalbaSrJTzkt5M7Uoma4pAzQ+rVJJthKpDQtotrf
        dmeZM6nqyy/teOHOaSugg8IR60uLKbc5k7XzrDVpOj1xZM3Jj9TA7lth5cIJx5nxWLHVtF
        baMl2oNJYBzxJyp0V28tlwA6plA6lMj5i8DlF9GtP4XvW/OSBq6DbF3UTP6Bjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595571960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=06rp+oHIu83X014OwhuO3Yo50SE1lVaYHF3HF2M3tlo=;
        b=BUCnCxCAgt/YSsPMr0YdGZhEerrU12NvVAAQsP+WxLoORZ0qt0+SMo/CvJnWNr09FYL8Zd
        0n1E4SZAoil8QzDQ==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ptp: Add generic header parsing function
In-Reply-To: <20200723170842.GB2975@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de> <20200723170842.GB2975@hoboy>
Date:   Fri, 24 Jul 2020 08:25:59 +0200
Message-ID: <87r1t12zuw.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jul 23 2020, Richard Cochran wrote:
> Kurt,
>
> On Thu, Jul 23, 2020 at 09:49:44AM +0200, Kurt Kanzenbach wrote:
>> in order to reduce code duplication in the ptp code of DSA drivers, move=
 the
>> header parsing function to ptp_classify. This way the Marvell and the he=
llcreek
>> drivers can share the same implementation. And probably more drivers can=
 benefit
>> from it. Implemented as discussed [1] [2].
>
> This looks good.  I made a list of drivers that can possibily use this he=
lper.
>
> Finding symbol: PTP_CLASS_PMASK
>
> *** drivers/net/dsa/mv88e6xxx/hwtstamp.c:
> parse_ptp_header[223]          switch (type & PTP_CLASS_PMASK) {

Sure, done already (see patch 2).

>
> *** drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:
> mlxsw_sp_ptp_parse[335]        switch (ptp_class & PTP_CLASS_PMASK) {

Works ootb.

>
> *** drivers/net/ethernet/ti/am65-cpts.c:
> am65_skb_get_mtype_seqid[761]  switch (ptp_class & PTP_CLASS_PMASK) {
>
> *** drivers/net/ethernet/ti/cpts.c:
> cpts_skb_get_mtype_seqid[459]  switch (ptp_class & PTP_CLASS_PMASK) {
>
> *** drivers/net/phy/dp83640.c:
> match[815]                     switch (type & PTP_CLASS_PMASK) {
> is_sync[990]                   switch (type & PTP_CLASS_PMASK) {

These three drivers also deal with ptp v1 and they need access to the
message type. However, the message type is located at a different offset
depending on the ptp version. They all do:

|if (unlikely(ptp_class & PTP_CLASS_V1))
|	msgtype =3D data + offset + OFF_PTP_CONTROL;
|else
|	msgtype =3D data + offset;

Maybe we can put that in a helper function, too?

|static inline u8 ptp_get_msgtype(const struct ptp_header *hdr, unsigned in=
t type)
|{
|	u8 msg;
|
|	if (unlikely(type & PTP_CLASS_V1))
|		/* msg type is located @ offset 20 for ptp v1 */=20
|		msg =3D hdr->source_port_identity.clock_identity.id[0];
|	else
|		msg =3D hdr->tsmt & 0x0f;
|
|	return msg;
|}

What do you think about it?

>
> *** drivers/ptp/ptp_ines.c:
> ines_match[457]                switch (ptp_class & PTP_CLASS_PMASK) {
> is_sync_pdelay_resp[703]       switch (type & PTP_CLASS_PMASK) {

Works ootb.

>
>> @DSA maintainers: Please, have a look the Marvell code. I don't have har=
dware to
>> test it. I've tested this series only on the Hirschmann switch.
>
> I'll test the marvell switch with your change and let you know...

Great.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8afvcACgkQeSpbgcuY
8KbVCg//XcabFWBUdhKx1Qcno9kNmn1X8SV1Nor+E47G7lcnUaBbsxYavz1tCxEE
QMWhv3XOwbrcpXPqzodI+bIytOJNUzoZT00GXKsqRBuQMsGoCQxeeY7DA0JYiBiX
emaEZxpak7Qo/iSxdjHKNOY0l+r/Md9QKYhTicULw5/7qy9mLjnAiFMOGsoF6wRH
YFR5XSnwGmD8EnGp73WNzHU7ZRkY/asEOnvz8AR0RCfdKcotJGQMw2WZLoCWdIY2
qoRnq+7kT1CjYysre8MRABCQtyC/DNSItuMuUkn3GMsj1wgZOiEu5vXSk5JmT8nZ
lYxAtmrRXztxJWSJcCcx0YjwivdlxH5DATxQqCLDITaD+fWK/8avEf65tsVBy8O5
rF7HzvWgebWiBtvodOpCOBcnZYSaBQYc6A/jUpGAba35eHVz8wAZt7Mzhd8duBYY
MHr0wE34YbqEugrT7Ij9uU8tQr6bXuQ0FM1sojBuLC6dxloA4EZccVLEtw+bSLKW
dG2gm5PKbsjvuqoazqoYvACAMtzXsSeiIGV/Lzm1vQZJcM7fciFiTzWix9dMRDNJ
Y7w/CR901UK3vQVsFgvslksbNAGQoahzatSK7c9VRppR05lKMDcsES2zNig1pbzx
nirsX9TOxXB8WAbdgalvarqDol/k6Vreqf+4GxPxGRylLifhh7c=
=TOJG
-----END PGP SIGNATURE-----
--=-=-=--
