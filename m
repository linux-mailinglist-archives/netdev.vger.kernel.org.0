Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6867C5F8745
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 22:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJHUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 16:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJHUKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 16:10:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2B26125;
        Sat,  8 Oct 2022 13:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=sPqkQeKBsmSF5+T44K89btJNeNg2YCdMiWL1fgYqCFg=;
        t=1665259830; x=1666469430; b=QZKELon0vdxhWIYyEL2Z4A7otMX4W0QlnwQolsrTgnlpklE
        KJTllaE2g5C1q5VKPpm8S/zLm5aglLDCzzqkEb5bQ1OF6+mRRVRsdMh94L6G3MqvRPWKG1orSVpuJ
        iohr6oEgGKAfqLxYmXBhR1qC8syyS7CwD6hzEAJJFAc3cDghD121Mabc5bguN4JalF4okgkJF34Ds
        BDizdeoJc+yEn8mfEXN//TJL5VrUpz+CCv/PNE611Jps9D2Alv0AmGCUfmGzryB/Eo2kE8SK1SRzh
        3xaD2dw2HJanHiBty7xWrC9i7rJhjF4SXgSWc4OTE+nbJOphNlYjLKL7M+sD5ILA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ohG9K-001IoM-0Z;
        Sat, 08 Oct 2022 22:10:18 +0200
Message-ID: <3acec81e863aa5f184bc5a74916f1470b77552cb.camel@sipsolutions.net>
Subject: Re: [PATCH v4] ath9k: verify the expected usb_endpoints are present
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        Alan Stern <stern@rowland.harvard.edu>
Date:   Sat, 08 Oct 2022 22:10:16 +0200
In-Reply-To: <20221008120211.24764-1-pchelkin@ispras.ru>
References: <20221008120211.24764-1-pchelkin@ispras.ru>
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

On Sat, 2022-10-08 at 15:02 +0300, Fedor Pchelkin wrote:
> =20
> +	/* Verify the expected endpoints are present */
> +	alt =3D interface->cur_altsetting;
> +	if (usb_find_common_endpoints(alt, &bulk_in, &bulk_out, &int_in, &int_o=
ut) < 0 ||
> +			usb_endpoint_num(bulk_in) !=3D USB_WLAN_RX_PIPE ||
> +			usb_endpoint_num(bulk_out) !=3D USB_WLAN_TX_PIPE ||
> +			usb_endpoint_num(int_in) !=3D USB_REG_IN_PIPE ||
> +			usb_endpoint_num(int_out) !=3D USB_REG_OUT_PIPE) {
> +			dev_err(&udev->dev,
> +					"ath9k_htc: Device endpoint numbers are not the expected ones\n");
> +		return -ENODEV;
>=20

Indentation somehow got pretty messed up now ..

johannes
