Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3024965EEB3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjAEO0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjAEOZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:25:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6B04C706
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672928696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+vMsyLV1iqqB+rTaHPT3o+p3vbpQRz33shEufuH/iew=;
        b=U6xP912yQ4y9+PX/LxA6NUWI07vzUwtg06skD1thKAtXShh7firwi9Oc8vvnhQh+1yjIU1
        KE/4iCcRgs6vKi/Lb1jK+xryKjC9fKSdAoV0L2faX8ZnEZE3zabC+oNuS3FdlRYNbp8upx
        PJE885MYXGWAc8CChrQ564iQM+1o1GM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-xX-8cGwtNL2ZC2Cq3Wv9qw-1; Thu, 05 Jan 2023 09:24:55 -0500
X-MC-Unique: xX-8cGwtNL2ZC2Cq3Wv9qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24F6857A8A;
        Thu,  5 Jan 2023 14:24:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.50.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 445911415308;
        Thu,  5 Jan 2023 14:24:52 +0000 (UTC)
Message-ID: <5e77d02ee84ac41bd8a55e2a0980ada5fba978dc.camel@redhat.com>
Subject: Re: [PATCH] wifi: libertas: return consistent length in
 lbs_add_wpa_tlv()
From:   Dan Williams <dcbw@redhat.com>
To:     Doug Brown <doug@schmorgal.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 05 Jan 2023 08:24:51 -0600
In-Reply-To: <133a4655-bafa-a4f1-b9f4-df43cf443e83@schmorgal.com>
References: <20230102234714.169831-1-doug@schmorgal.com>
         <657adc8e514d4486853ef90cdf97bd75f55b44fa.camel@redhat.com>
         <cc785f92-587c-c260-6369-c2dde9a392ca@schmorgal.com>
         <9d9b16079503d64096b5d16e4552698ccecb9c7f.camel@redhat.com>
         <133a4655-bafa-a4f1-b9f4-df43cf443e83@schmorgal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-04 at 22:43 -0800, Doug Brown wrote:
> On 1/4/2023 6:47 AM, Dan Williams wrote:
> > On Tue, 2023-01-03 at 17:13 -0800, Doug Brown wrote:
> > > Hi Dan,
> > >=20
> > > Thanks for reviewing my patch! Comments below:
> > >=20
> > > On 1/3/2023 9:47 AM, Dan Williams wrote:
> > > > On Mon, 2023-01-02 at 15:47 -0800, Doug Brown wrote:
> > > > > The existing code only converts the first IE to a TLV, but it
> > > > > returns
> > > > > a
> > > > > value that takes the length of all IEs into account. When
> > > > > there
> > > > > is
> > > > > more
> > > > > than one IE (which happens with modern wpa_supplicant
> > > > > versions
> > > > > for
> > > > > example), the returned length is too long and extra junk TLVs
> > > > > get
> > > > > sent
> > > > > to the firmware, resulting in an association failure.
> > > > >=20
> > > > > Fix this by returning a length that only factors in the
> > > > > single IE
> > > > > that
> > > > > was converted. The firmware doesn't seem to support the
> > > > > additional
> > > > > IEs,
> > > > > so there is no value in trying to convert them to additional
> > > > > TLVs.
> > > > >=20
> > > > > Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
> > > > > Signed-off-by: Doug Brown <doug@schmorgal.com>
> > > > > ---
> > > > > =C2=A0=C2=A0=C2=A0drivers/net/wireless/marvell/libertas/cfg.c | 7=
 +++----
> > > > > =C2=A0=C2=A0=C2=A01 file changed, 3 insertions(+), 4 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/net/wireless/marvell/libertas/cfg.c
> > > > > b/drivers/net/wireless/marvell/libertas/cfg.c
> > > > > index 3e065cbb0af9..fcc5420ec7ea 100644
> > > > > --- a/drivers/net/wireless/marvell/libertas/cfg.c
> > > > > +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> > > > > @@ -432,10 +432,9 @@ static int lbs_add_wpa_tlv(u8 *tlv,
> > > > > const u8
> > > > > *ie, u8 ie_len)
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*tlv+=
+ =3D 0;
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tlv_l=
en =3D *tlv++ =3D *ie++;
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*tlv+=
+ =3D 0;
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0while (tlv_len--)
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0*tlv++ =3D *ie++;
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* the TLV is two byte=
s larger than the IE */
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ie_len + 2;
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(tlv, ie, tlv_le=
n);
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* the TLV has a four-=
byte header */
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return tlv_len + 4;
> > > >=20
> > > > Since you're removing ie_len usage in the function, you might
> > > > as
> > > > well
> > > > remove it from the function's arguments.
> > >=20
> > > That's an excellent point. Thinking about it further after your
> > > questions below, maybe we should keep it around and use it to
> > > validate
> > > how far we are allowed to go into "ie" though...technically the
> > > existing
> > > code could overflow the buffer with a malformed IE.
> >=20
> > Yeah, that's a good point, though I'd hope cfg80211 had already
> > validated the IE structure that gets put into sme->ie. If not, I'd
> > expect bigger problems. But doesn't hurt.
>=20
> Ah, I didn't even consider that cfg80211 might be validating it ahead
> of
> time, but that would make a lot of sense. I'll do some more digging
> and
> figure out if that much validation is really needed in this driver.
>=20
> > >=20
> > > > Can you also update the comments to say something like "only
> > > > copy
> > > > the
> > > > first IE into the command buffer".
> > >=20
> > > Will do.
> > >=20
> > > > Lastly, should you check the IE to make sure you're copying the
> > > > WPA
> > > > or
> > > > WMM IE that the firmware expects? What other IEs does
> > > > wpa_supplicant/cfg80211 add these days?
> > >=20
> > > I was wondering about that too. I wasn't sure exactly which
> > > potential
> > > IEs are the ones I should be looking for during this check. I've
> > > seen
> > > "RSN Information" =3D 48 during my testing with WPA2, and assume
> > > based
> > > on
> > > the old Marvell driver code that "Vendor Specific" =3D 221 would be
> > > used
> > > with WPA. Going through the entire IE list and finding a match
> > > seems
> > > safer than just blindly grabbing the first one. This would also
> > > be a
> > > good time to add some bounds checking to make sure not to overrun
> > > "ie"
> > > as well...
> >=20
> > Everything after CMD_802_11_ASSOCIATE's DTIM Period field is just a
> > bunch of IEs; the command only accepts certain IEs (at least it was
> > documented to do that, no idea what the actual firmware does). So I
> > wouldn't be surprised if it ignores some.
> >=20
> > So I guess ignore the reasoning I had above, but there's one more
> > good
> > reason to filter IEs passed to the firmware: space. We're probably
> > not
> > close to overrunning the buffer, but we really don't want to do
> > that
> > for security reasons.
>=20
>=20
> I like that idea a lot. I'll filter and only allow through 48 and 221
> IEs in lbs_add_wpa_tlv() in the next version of the patch.
>=20
> > >=20
> > > The other two IEs that are being added by modern wpa_supplicant
> > > are
> > > "Extended Capabilities" (127) with SCS and mirrored SCS set:
> > >=20
> > > 7f 0b 00 00 00 00 00 00 40 00 00 00 20
> > >=20
> > > ...and "Supported Operating Classes" (59) with current =3D 81 and
> > > supported =3D 81 and 82:
> > >=20
> > > 3b 03 51 51 52
> > >=20
> > > I tried converting these additional IEs to TLVs. It resulted in a
> > > successful connection, but the firmware didn't pass on these two
> > > IEs
> > > in
> > > the association request -- I verified by sniffing packets. So I
> > > was
> > > concerned about passing them onto the firmware if it's not making
> > > use
> > > of
> > > them, in case it's interpreting them in some other unexpected
> > > way.
> >=20
> > Yeah, it might.
> >=20
> > >=20
> > > Do you have any guidance on which possible IEs I should be
> > > looking
> > > for
> > > other than 48 and 221, or where I could find that out?
> >=20
> > Only those two. The rest that are required get added specifically
> > in
> > the driver. There is a way to push unrecognized IEs through
> > ("passthrough IEs" ID 0x010A) but we never implemented that in the
> > driver because we never needed it.
>=20
>=20
> Thanks. Good to know that passthrough is possible if any additional
> IEs
> need to be supported in the future. I see that in the old Marvell
> source
> code now, thanks.
>=20
> > >=20
> > > BTW, modern wpa_supplicant also doesn't work with libertas for
> > > one
> > > additional reason: it violates NL80211_ATTR_MAX_SCAN_IE_LEN on
> > > some
> > > older drivers including this one. But I believe that's a
> > > wpa_supplicant
> > > problem that I can't really address in the kernel...
> >=20
> > That's lame... but Jouni's response was that not allowing extra IEs
> > would break some WPS stuff; CMD_802_11_SCAN does allow adding a TLV
> > (0x011B) for WPS Enrollee IE contents, so maybe you could just set
> > max_scan_ie_len to something larger than zero and ignore IEs that
> > are
> > not valid in WPS Enrollee Probe Request frames, while adding the
> > WPS
> > TLVs?
>=20
>=20
> I love this idea, and I'm definitely interested in attempting it in
> another patch in order to fully restore this driver's compatibility
> with
> wpa_supplicant. I'll play around with it a bit.
>=20
> Do you happen to have any more info on how to use this TLV? It isn't
> documented in the old Marvell driver or this driver. Based on what
> I'm
> seeing in wpa_supplicant, it looks like the WPS stuff is encapsulated
> in
> Vendor Specific (221) IEs with special OUI/type values for WPS.
> There's
> another OUI/type for P2P info that can potentially be added for WPS
> too.
> Would I just need to directly convert these IEs into 0x011B TLVs
> (obviously with a new TLV_TYPE_ #define added for it)?

Kind of. Type =3D 0x11B, Length =3D size of the IEs buffer, and the data is
just all the IEs you want to shove into the Enrollee Probe Request
frames. So you don't need to convert anything, you're just wrapping the
IEs you get into a Marvell-specific TLV.

Dan

>=20
> Thanks,
> Doug
>=20
> >=20
> > Dan
> >=20
> > >=20
> > > http://lists.infradead.org/pipermail/hostap/2022-January/040185.html
> > >=20
> > > Thanks!
> > > Doug
> > >=20
> >=20
>=20

