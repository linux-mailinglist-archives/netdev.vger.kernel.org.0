Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A345B6CF55F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjC2V1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC2V13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:27:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365AC2681;
        Wed, 29 Mar 2023 14:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vTEx1qGiRwHQqbRWZ0F0YVEXYMez6RiJLOH+5aThdgE=;
        t=1680125246; x=1681334846; b=spE3Mu/tZJZwbguWhNkhb04F/VyzKMs5S+EnC7HG/oatr8H
        Q1q+8HkkN1+FqeaVED8hlbN6/oYYLNep3P7v6UjYf0aQk6j34UzBQC2Ta6PF3PDP5Pj9y+rWUCsJH
        TxuD/FFgojsMo0V90ZL2wB5TIplvpE0rrKHEYW5HB9jnlShnNIGqxHMoIX74EhGwQPUb0Q5Bix4dR
        9KvWWFRQW8D8DcRU7JILoU62inBy57SWX+T6vyISIYskWAdKSxgpIrRc8y2HzgEEb6sJHO+PIe+qO
        ZfJkxJ9lyVP2HcNWY5JdtLw55pt1Yy19tWE5Qnf1LmXMmzRKUXCOvQySu29Qh0Yw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phdJz-000F4W-1q;
        Wed, 29 Mar 2023 23:27:07 +0200
Message-ID: <fbad112793615840745195e54eed98634233c415.camel@sipsolutions.net>
Subject: Re: [PATCH 3/5] net: rfkill-gpio: Add explicit include for of.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Date:   Wed, 29 Mar 2023 23:27:05 +0200
In-Reply-To: <20230329-acpi-header-cleanup-v1-3-8dc5cd3c610e@kernel.org>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
         <20230329-acpi-header-cleanup-v1-3-8dc5cd3c610e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-29 at 16:20 -0500, Rob Herring wrote:
> With linux/acpi.h no longer implicitly including of.h, add an explicit
> include of of.h to fix the following error:
>=20
> net/rfkill/rfkill-gpio.c:181:21: error: implicit declaration of function =
'of_match_ptr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>

Sounds good!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I'm happy with Rafael taking the entire series, there's nothing here
that I expect to conflict, and anyway it'd be trivial.

Thanks,
johannes
