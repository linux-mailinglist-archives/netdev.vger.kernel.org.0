Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574222E139
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 18:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgGZQXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 12:23:34 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27573 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgGZQXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 12:23:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595780612; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=SMD8GqIeO9u7l+fbIorG9kVzNUW8qUFr9pKbkQmeGE8=; b=hbwO7wV7udE4mycBLN+OVrVwbVQKiuNtkZUXJzwzXcp8MtsLUJCjKYmEHCEURUjGe/G9G7Sm
 ycFEC7inxAuZclblFNk+4DbUqbK56VGpd1gGC0dp5USEiXo+jjYjU/1mELJUrKiktwWECzwO
 zTBpVgIQ9yh9IwqVtUFLcEvLEjg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-west-2.postgun.com with SMTP id
 5f1dad2e49176bd382a48e62 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 26 Jul 2020 16:19:58
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 85C1AC433A0; Sun, 26 Jul 2020 16:19:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F17EC433C9;
        Sun, 26 Jul 2020 16:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F17EC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Johannes Berg'" <johannes@sipsolutions.net>,
        <ath10k@lists.infradead.org>
Cc:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <dianders@chromium.org>,
        <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>           <1595351666-28193-2-git-send-email-pillair@codeaurora.org>      <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>       <003201d6611e$c54a1c90$4fde55b0$@codeaurora.org> <ce380ea1fd1f5db40a92f67673f070a1f88eee50.camel@sipsolutions.net> 
In-Reply-To: 
Subject: RE: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
Date:   Sun, 26 Jul 2020 21:49:51 +0530
Message-ID: <000e01d66368$9a6ece70$cf4c6b50$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwIktOPGArPni2UCL/NlBQHsbdYmAYRemCKpCPf+gA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rakesh Pillai <pillair@codeaurora.org>
> Sent: Friday, July 24, 2020 11:51 AM
> To: 'Johannes Berg' <johannes@sipsolutions.net>;
> 'ath10k@lists.infradead.org' <ath10k@lists.infradead.org>
> Cc: 'linux-wireless@vger.kernel.org' <linux-wireless@vger.kernel.org>;
> 'linux-kernel@vger.kernel.org' <linux-kernel@vger.kernel.org>;
> 'kvalo@codeaurora.org' <kvalo@codeaurora.org>; 'davem@davemloft.net'
> <davem@davemloft.net>; 'kuba@kernel.org' <kuba@kernel.org>;
> 'netdev@vger.kernel.org' <netdev@vger.kernel.org>;
> 'dianders@chromium.org' <dianders@chromium.org>;
> 'evgreen@chromium.org' <evgreen@chromium.org>
> Subject: RE: [RFC 1/7] mac80211: Add check for napi handle before
> WARN_ON
>=20
>=20
>=20
> > -----Original Message-----
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Sent: Friday, July 24, 2020 1:37 AM
> > To: Rakesh Pillai <pillair@codeaurora.org>; =
ath10k@lists.infradead.org
> > Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> > kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org;
> > netdev@vger.kernel.org; dianders@chromium.org;
> evgreen@chromium.org
> > Subject: Re: [RFC 1/7] mac80211: Add check for napi handle before
> > WARN_ON
> >
> > On Thu, 2020-07-23 at 23:56 +0530, Rakesh Pillai wrote:
> >
> > > > > -	WARN_ON_ONCE(softirq_count() =3D=3D 0);
> > > > > +	WARN_ON_ONCE(napi && softirq_count() =3D=3D 0);
> > > >
> > > > FWIW, I'm pretty sure this is incorrect - we make assumptions on
> > > > softirqs being disabled in mac80211 for serialization and in =
place of
> > > > some locking, I believe.
> > > >
> > >
> > > I checked this, but let me double confirm.
> > > But after this change, no packet is submitted from driver in a =
softirq
> > context.
> > > So ideally this should take care of serialization.
> >
> > I'd guess that we have some reliance on BHs already being disabled, =
for
> > things like u64 sync updates, or whatnot. I mean, we did "rx_ni()" =
for a
> > reason ... Maybe lockdep can help catch some of the issues.
> >
> > But couldn't you be in a thread and have BHs disabled too?
>=20
> This would ideally beat the purpose and possibly hurt the other =
subsystems
> running on the same core.
>=20

Hi Johannes,

We do have the usage of napi_gro_receive and netif_receive_skb in =
mac80211.
                /* deliver to local stack */
                if (rx->napi)
                        napi_gro_receive(rx->napi, skb);
                else
                        netif_receive_skb(skb);


Also all the rx_handlers are called under the " rx->local->rx_path_lock" =
lock.
Is the BH disable still required ?


> >
> > johannes


