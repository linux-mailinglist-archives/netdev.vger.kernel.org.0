Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B469C12E
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 16:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBSPMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 10:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBSPMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 10:12:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91044113D5;
        Sun, 19 Feb 2023 07:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=XCAPsSxot/7PZk2OWYXQElFYpGmjMum47DIy8TdJOfk=;
        t=1676819549; x=1678029149; b=RCUV8MVkSwGuGk6oK0YHZZQigsxdDAaIP+4bEA1MIOCub9M
        +69+rIhYvsaI2HPb/WugF/T7sKmC05Qc5qHOln3qtYzamRdcMaVRytPiHhxujJx8W2MOLt6gB6zhk
        wgomLiQzVbm9/95d9+OZwzJi6p1ODaDyB+B318f7iJXSXHnuMeqJrFfvCxYRsy5gGjVze9xQP5//j
        92iCvHpOeuHKuBfmKqa74dT4eb1Zq/TeEvZM6c86Lwg7c54Tk4GJ/rtt44fGYj1SX22ZBgTVoN/fb
        AhLBzGsEfjWG2IARIKaVenPfNtPkjJqMjYfp6wqaZ+lI3K0dmqjXCCCfchX0X7Zg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pTlME-00H1CV-1W;
        Sun, 19 Feb 2023 16:12:06 +0100
Message-ID: <3181a89b49e571883525172a7773b12f046e8b09.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: dvm: Add struct_group for struct
 iwl_keyinfo keys
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>,
        Gregory Greenman <gregory.greenman@intel.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Sun, 19 Feb 2023 16:12:05 +0100
In-Reply-To: <20230218191056.never.374-kees@kernel.org>
References: <20230218191056.never.374-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Sat, 2023-02-18 at 11:11 -0800, Kees Cook wrote:
>=20
>  	case WLAN_CIPHER_SUITE_CCMP:
>  		key_flags |=3D STA_KEY_FLG_CCMP;
> -		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
> +		memcpy(&sta_cmd.key.keys, keyconf->key, keyconf->keylen);

This should be fine though, only up to 16 bytes for CCMP.

>  	case WLAN_CIPHER_SUITE_TKIP:
>  		key_flags |=3D STA_KEY_FLG_TKIP;
>  		sta_cmd.key.tkip_rx_tsc_byte2 =3D tkip_iv32;
>  		for (i =3D 0; i < 5; i++)
>  			sta_cmd.key.tkip_rx_ttak[i] =3D cpu_to_le16(tkip_p1k[i]);
> -		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
> +		memcpy(&sta_cmd.key.keys, keyconf->key, keyconf->keylen);

And that's actually a bug, we should've copied only 16 bytes, I guess.
DVM didn't support MIC offload anyway (at least the way Linux uses the
firmware, though I thought it doesn't at all), so we don't need the MIC
RX/TX keys in there, but anyway the sequence counter values are not part
of the key material on the host.

I don't think I have a machine now to test this with (nor a TKIP AP, of
course, but that could be changed) - but I suspect that since we
actually calculate the TTAK above, we might not even need this memcpy()
at all?

johannes
