Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F212B610C1D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJ1IXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ1IW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:22:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4744B1A20A6;
        Fri, 28 Oct 2022 01:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=awrmdL6Drv/Ct65LQwals/2KrYxC2xB9ldKz7KnqNFM=;
        t=1666945378; x=1668154978; b=Yb8jlFZHwyg5u4daTfTHZPEQAxqTXj85CG1Q2fA9HURdYLp
        zz9ncZdQ9qoDfw+BNKQyIC//IiGSgE8WsPQdPExFDD/nqRhBdt6cwy3oDI0om57ydsoBNQT164lzJ
        ovOqqqvQrHQ0ibZTolvJa0ONcvRTAkI6nyU0P1cOKLwnunIiewinhvG8lAV0JBr+8bSIZWpn7JFyT
        SLyAebS/Lg96YwBxL6icEBfahe0z211TknYbI4GgNrwV35xMjPeE0MxSrgX83/SP/nFJ9vcYSWrYn
        NpmS1KWDZ2VAFGvCbrubdsbG4+FuMA4XqwhDbuSiilvIlYX3yzywNA2QDr/9CZlw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ooKdc-001HRW-1H;
        Fri, 28 Oct 2022 10:22:48 +0200
Message-ID: <a92ffa8db8228b5cb41939dc37d6ee677aef0619.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/6] cfg80211: Avoid clashing function prototypes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Date:   Fri, 28 Oct 2022 10:22:47 +0200
In-Reply-To: <c8239f5813dec6e5cfb554ca92b1783a18ac5537.1666894751.git.gustavoars@kernel.org>
References: <cover.1666894751.git.gustavoars@kernel.org>
         <c8239f5813dec6e5cfb554ca92b1783a18ac5537.1666894751.git.gustavoars@kernel.org>
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

Hm.

If you're splitting out per driver,

> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -9870,7 +9870,7 @@ static int ipw_wx_sw_reset(struct net_device *dev,
> =20
>  /* Rebase the WE IOCTLs to zero for the handler array */
>  static iw_handler ipw_wx_handlers[] =3D {
> -	IW_HANDLER(SIOCGIWNAME, (iw_handler)cfg80211_wext_giwname),
> +	IW_HANDLER(SIOCGIWNAME, cfg80211_wext_giwname),

I can see how this (and similar) still belongs into this patch since
it's related to the cfg80211 change, but

> +++ b/drivers/net/wireless/intersil/orinoco/wext.c
> @@ -154,9 +154,10 @@ static struct iw_statistics *orinoco_get_wireless_st=
ats(struct net_device *dev)
> =20
>  static int orinoco_ioctl_setwap(struct net_device *dev,
>  				struct iw_request_info *info,
> -				struct sockaddr *ap_addr,
> +				union iwreq_data *wrqu,
>  				char *extra)
>  {
> +	struct sockaddr *ap_addr =3D &wrqu->ap_addr;

why this (and similar) too?

The same changes in hostap, zd1201 and airo you did split out?

johannes


