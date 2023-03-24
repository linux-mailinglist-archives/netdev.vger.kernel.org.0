Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D076C8243
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCXQVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCXQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:21:23 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FF7AD06;
        Fri, 24 Mar 2023 09:21:21 -0700 (PDT)
Received: from [IPV6:2003:e9:d711:5f8f:7b5e:613a:60e4:7837] (p200300e9d7115f8f7b5e613a60e47837.dip0.t-ipconnect.de [IPv6:2003:e9:d711:5f8f:7b5e:613a:60e4:7837])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A7424C0871;
        Fri, 24 Mar 2023 17:21:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1679674879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NJHyznJr6ZLDpkCKs8DDjSRpVPxt7bDmUVXZBcNWzM=;
        b=nJjw0Z0z/+/A6rshU6Rn/YcALPnmGYvo5rRPjy2q+oQCh7PUYy/CxUDouczx0gQDVFEJq8
        KnsDRV9HBKQeSjner2oS5GJmBWevnZiz51G1jAsOCu28UrfcpUXtvCLNVhNEo2QKGE9lPP
        iY0phh32Fi0bKhJBAeGrfGBYRDEyHk/3CrmJAF00Q+iyiWHln9NSsqGwX/df+bBekTH/Sr
        SVzbeeYfbGWlD2SIFf8EFKmZo8sJbw5bkhpvrNZb0Hggyj4fAgXFFOgMPDDkCgKSbIaWuL
        g6moc0vbGcKIverbeWvB82iVbL6m68/fYcYaQ0mdcux6akuK8cEpnwPD9foF3A==
Message-ID: <2e4677aa-5262-189e-1ee6-ec333b7932b5@datenfreihafen.org>
Date:   Fri, 24 Mar 2023 17:21:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Handle imited devices
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20230324110558.90707-1-miquel.raynal@bootlin.com>
 <CAK-6q+gzwOFbpN4JfYdfUzmVfeF+YzNwamkEaF-gYeMY8bzNww@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+gzwOFbpN4JfYdfUzmVfeF+YzNwamkEaF-gYeMY8bzNww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 24.03.23 14:56, Alexander Aring wrote:
> Hi,
> 
> On Fri, Mar 24, 2023 at 7:07 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>
>> As rightly pointed out by Alexander a few months ago, ca8210 devices
>> will not support sending frames which are not pure datagrams (hardMAC
>> wired to the softMAC layer). In order to not confuse users and clarify
>> that scanning and beaconing is not supported on these devices, let's add
>> a flag to prevent them to be used with the new APIs.
>>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
