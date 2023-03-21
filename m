Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DF06C2C14
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjCUIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCUIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:14:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0260265AE;
        Tue, 21 Mar 2023 01:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=UykcgWL46Dt3H3GsvFjfwS1TvGjrc+oNy9ibKRM6Mzc=;
        t=1679386445; x=1680596045; b=tOzsdCYivcCCWK0PLqK8Twv4pGsUVHrcsUBxfeFEXTK7Wih
        gY9H8MYJebdV8I72ED/DjVpgnwBd0lIB3WRDvG9rD8sKw7dZdPAWmBjaH5QyWAuC4oaasXgNcLzHZ
        s8OigD/FPdi7XmoTjR+orez75BGSFN/lfkTIwBew1UTAB3Y7Im60roD7SnczBx/vu6Nc/lCstV3E5
        8MpIRqMh36iVMb1z6VKIPebJmPPOssXRRbWP1ovASg225n876gi++fQ7s3ugDJPQR2IObwnp1dI2q
        7ZfWO7Zz3kPM51FlJpU0M0nDpZjhK8qB1a2huz6LvYlveaXAclY5mVlewDiwMFIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1peX7m-009niq-0Y;
        Tue, 21 Mar 2023 09:13:42 +0100
Message-ID: <412741af88854676b3070a0e378584dc52dd6905.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: dvm: Add struct_group for struct
 iwl_keyinfo keys
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        lukasz.wojnilowicz@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Tue, 21 Mar 2023 09:13:40 +0100
In-Reply-To: <6418b988.170a0220.82efc.cadd@mx.google.com>
References: <20230218191056.never.374-kees@kernel.org>
         <3181a89b49e571883525172a7773b12f046e8b09.camel@sipsolutions.net>
         <641897bd.630a0220.174d9.9d11@mx.google.com>
         <0ec5fe8b6945ee545b335ef2f3bee75b0af458d0.camel@sipsolutions.net>
         <6418b988.170a0220.82efc.cadd@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-20 at 12:52 -0700, Kees Cook wrote:
>=20
> What sort of patch would you like here? How should the other cases in
> the switch statement behave?
>=20
> Are these the correct bounds?
>=20
> 	WLAN_CIPHER_SUITE_CCMP:   keylen <=3D 16
> 	WLAN_CIPHER_SUITE_TKIP:   keylen <=3D 16
> 	WLAN_CIPHER_SUITE_WEP104: keylen <=3D 13
> 	WLAN_CIPHER_SUITE_WEP40:  keylen <=3D 13

40 bits is only 5 bytes :-)

> and should it silently ignore larger values in each case?
>=20

For the cases other than TKIP, no changes should be necessary - in those
cases, the key will always be =3D=3D the value from the (corrected) table
above.

For TKIP, the keylen will be 32, but comprised of the actual encryption
key and then MIC keys, so only 16 bytes should be relevant.

I don't really care how you handle this.

We can be bug-compatible with the old code, then I'd say from your patch
only the changes in the TKIP case are needed.

Or we can just limit the copy to only 16 bytes, but that would need some
validation that it still works. From memory, I'd say it will still work,
and I'd even say the whole memcpy() might not be needed in the TKIP case
at all since the iwldvm firmware deals with phase 1 keys (P1K) to derive
phase 2 keys, not the original encryption key.

So simpler is probably to just take the TKIP hunk from your patch, even
knowing that the memcpy() there is almost certainly incorrect now.

johannes
