Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F854D363
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 23:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348190AbiFOVMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 17:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347544AbiFOVMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 17:12:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075132AEB;
        Wed, 15 Jun 2022 14:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=TuYd7bPPv39NtXUsAgfJVAbOsOrZSsepyiGBkvfwiIY=;
        t=1655327549; x=1656537149; b=cTjTEsqTs1UNCY/xWnQ7IQS3WLEXnjKbrslRqb9NzM/vCM0
        gCI6HSvbolCF076VfT4kLTgTLDz48pBa/j4VAL8jyfYbUeQcDOo6W0nMqSUowbKvr+DYQgtW/8+2T
        Ps82/RWaF0OH5Xi2DdD7f5m0jKMpRw/nsn4q6tUernjSujxorIJHfKEj9lE56L43RiUOnHMbjR2EU
        wtDjlgAXx3Zqlk2wwTWRifie41M1aP84ejUn1MAx2teIUm9OA+dZ5cjWC2w4yZ4tZrMPbsGjFAjJg
        JsJmBzPscD165BvkYQrSM4hOhmObrVG60B23Yqb+lCdVlghRuXEwNaB8K9srQJUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1o1aJA-006eMg-28;
        Wed, 15 Jun 2022 23:12:12 +0200
Message-ID: <e38a63a26d893239d0f82021265fb16c3441786c.camel@sipsolutions.net>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Christian Lamparter <chunkeey@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Wed, 15 Jun 2022 23:12:11 +0200
In-Reply-To: <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
         <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
         <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
         <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-15 at 23:03 +0200, Christian Lamparter wrote:
>=20
> A driver usually loads the firmware in .probe(). It stays around because
> of .suspend()+.resume()
>=20

Does it, though? the firmware cache thing is a bit odd, it sometimes
seems to me that it only re-requests/loads the firmware when suspending,
and drops the cache when resumed, just in case it's requested inbetween.

johannes
