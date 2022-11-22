Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F27A6341D0
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiKVQqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiKVQqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:46:47 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8233C697CA;
        Tue, 22 Nov 2022 08:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=cfCEpsHVZR+VbInAoPMp32ekOw5sXB2mwaZRbX/GjM0=;
        t=1669135605; x=1670345205; b=wBpYOUVpun4OcoDQh56MgJLB6Vonb0MoWY0iAxmiJ3s35eh
        OtZ7qG4WKZC3Vz5KzAA5uyLFpEAgcHDjKZeaSfY0LrcG+t+RQoaQLHvxmdxbMPQFd43k63t81XJjp
        kiDB9XlCfdXh5UUUiLpgv4lGc5J79x5L90v80KWf2RWryYpKO1Nv3z01HtQYf1MYI2pJDADZeKaTM
        bWSZ7WZHJsy5eXgR5rrMSz3nnJSXG0CWt546zo/zpJb+hk1sc6syBMvoIjkjRVQSr9v5VYz/BtI+r
        i5bMStm7akVf1xDQRHPxw04uPEVJlYdEeVwj0qCBsscf0nBsu0Q0ijIQoNS4b5WQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oxWPS-006PQd-38;
        Tue, 22 Nov 2022 17:46:11 +0100
Message-ID: <1d3a2fafcc14de7406fd689029277fd74ed3ce87.camel@sipsolutions.net>
Subject: Re: Coverity: iwl_mvm_sec_key_add(): Memory - corruptions
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Petr Stourac <pstourac@redhat.com>,
        linux-kernel@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Errera <nathan.errera@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        netdev@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Abhishek Naik <abhishek.naik@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Ayala Beker <ayala.beker@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        Sriram R <quic_srirrama@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        Mike Golant <michael.golant@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Tue, 22 Nov 2022 17:46:09 +0100
In-Reply-To: <202211181424.794FCAD@keescook>
References: <202211180854.CD96D54D36@keescook>
         <d4c07fa45de290f32611420e2f116d8a6e32d22a.camel@sipsolutions.net>
         <202211181424.794FCAD@keescook>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 14:25 -0800, Kees Cook wrote:
> On Fri, Nov 18, 2022 at 10:04:38PM +0100, Johannes Berg wrote:
> > On Fri, 2022-11-18 at 08:54 -0800, coverity-bot wrote:
> > >=20
> > > *** CID 1527370:  Memory - corruptions  (OVERRUN)
> > > drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c:123 in iwl_mvm_sec_k=
ey_add()
> > > 117
> > > 118     	if (WARN_ON(keyconf->keylen > sizeof(cmd.u.add.key)))
> > > 119     		return -EINVAL;
> > > 120
> > > 121     	if (keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_WEP40 ||
> > > 122     	    keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_WEP104)
> > > vvv     CID 1527370:  Memory - corruptions  (OVERRUN)
> > > vvv     Overrunning buffer pointed to by "cmd.u.add.key + 3" of 32 by=
tes by passing it to a function which accesses it at byte offset 34 using a=
rgument "keyconf->keylen" (which evaluates to 32). [Note: The source code i=
mplementation of the function has been overridden by a builtin model.]
> > > 123     		memcpy(cmd.u.add.key + IWL_SEC_WEP_KEY_OFFSET, keyconf->key=
,
> > > 124     		       keyconf->keylen);
> > > 125     	else
> > > 126     		memcpy(cmd.u.add.key, keyconf->key, keyconf->keylen);
> > > 127
> > > 128     	if (keyconf->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP) {
> > >=20
> > > If this is a false positive, please let us know so we can mark it as
> > > such, or teach the Coverity rules to be smarter. If not, please make
> > > sure fixes get into linux-next. :) For patches fixing this, please
> > > include these lines (but double-check the "Fixes" first):
> > >=20
> >=20
> > Well, I don't think you can teach coverity this easily, but the
> > WARN_ON() check there is not really meant to protect this - WEP keys
> > must have a length of either 5 or 13 bytes (40 or 104 bits!).
> >=20
> > So there's no issue here, but I'm not surprised that coverity wouldn't
> > be able to figure that out through the stack.
>=20
> Gotcha. And some other layer is doing the verification that cipher and
> keylen are correctly matched?


Yes, the key must come through cfg80211_validate_key_settings() at some
point.

johannes
