Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF81D6977CE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjBOIMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjBOIMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:12:33 -0500
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23EE3A94;
        Wed, 15 Feb 2023 00:12:31 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:12:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676448748; x=1676707948;
        bh=s9JzE6b6DEfckH/ZqQDZxssRt/o9LAwbB3i41yJi7+4=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=fva+HL8dsv3tACxLbMbg9jlu6/1+Zx2YrA6/vdm7SZEtuYYigjN0yxwB5HMeLH0EE
         a+dNE8DU6teGbczfDlI1u5t+nHRU4611angKVhKSn1ZsbOxnn+wCGR6bE2DVAHJoxR
         GFwJHVnCovTqmb5tQrQbLJ09M11k56qN3x+Y2AvMa3JL3b6QpvhwTp155aUucarhmv
         NbuLt++S+UEQLO7sWVTNT7I2ecxB0igDRYfTgNcbc2IOYCzgAoYjFx280cKLnujCg/
         FDR7fdlcwadje1Joqh1cMVDckXnlB4d59KzgSfT6YJ2qD/JJ7FxAtEogFExHIVaIDj
         J+hiZbVgKV5Hw==
To:     Kalle Valo <kvalo@kernel.org>
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yohan Prod'homme <kernel@zoddo.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] Set ssid when authenticating
Message-ID: <Y+yT2YUORRHY4bei@opmb2>
In-Reply-To: <87ttzn4hki.fsf@kernel.org>
References: <20230214132009.1011452-1-dev.mbornand@systemb.ch> <87ttzn4hki.fsf@kernel.org>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 07:35:09AM +0200, Kalle Valo wrote:
> Marc Bornand <dev.mbornand@systemb.ch> writes:
>
> > changes since v3:
> > - add missing NULL check
> > - add missing break
> >
> > changes since v2:
> > - The code was tottaly rewritten based on the disscution of the
> >   v2 patch.
> > - the ssid is set in __cfg80211_connect_result() and only if the ssid i=
s
> >   not already set.
> > - Do not add an other ssid reset path since it is already done in
> >   __cfg80211_disconnected()
> >
> > When a connexion was established without going through
> > NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> > Now we set it in __cfg80211_connect_result() when it is not already set=
.
> >
> > Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> > Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
> > Cc: linux-wireless@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
> > Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
> > ---
> >  net/wireless/sme.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
>
> The change log ("changes since v3" etc) should be after "---" line and

Does it need another "---" after the change log?
something like:

"---"
"changes since v3:"
"(CHANGES)"
"---"

> the title should start with "wifi: cfg80211:". Please read the wiki link
> below.

Should i start with the version 1 with the new title?
and since i am already changing the title, the following might better
discribe the patch, or should i keep the old title after the ":" ?

[PATCH wireless] wifi: cfg80211: Set SSID if it is not already set

>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

