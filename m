Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A61F6CA7BA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjC0OcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjC0Oby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:31:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C022D7D;
        Mon, 27 Mar 2023 07:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=NKTe9qRZHR1ull2EIJjDc+GJKF2gKHfkxgDvwszZVD4=;
        t=1679927513; x=1681137113; b=GBiLnv2hl7XwL5ZDqNi8claXLqhYhkokDV2KeFlOEe2ngtg
        zcBuHYMl4KyJjPbFDA8W2a1Lmz1YWZG70CK8O3d2Bfur7ygktItquj2O5nWRwIdh16n8/3Yrj0RHX
        7TTGu0qQws5GmY583mELLQmdtC26Nmllns12lLz3B2Fbj9RlQ43J+djXII2oiyaD6H/aarsU87tr+
        lk36zK6DxudpIbHTCpcDk29bnO+6toaQVU+i/I01c0ow7ZtMw87dnKAGjMnuUv0q+hKIEtVhGqiXM
        cTo3vR0rQX7cji2K0VwMeD8NTtnNyVtUfbztOnld1AyBcNkIDYYpmOntOkUs/xAg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pgnt2-00FjLI-07;
        Mon, 27 Mar 2023 16:31:52 +0200
Message-ID: <e3ca82aaf29f92303d5dec239d2177029e91c134.camel@sipsolutions.net>
Subject: Re: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 27 Mar 2023 16:31:51 +0200
In-Reply-To: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
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

On Mon, 2023-03-27 at 16:19 +0200, Johannes Berg wrote:
>=20
> 	SKB_DROP_REASON_MAC80211_DUP		(SKB_DROP_REASON_MAC80211_TYPE_UNUSABLE | =
1)
> 	SKB_DROP_REASON_MAC80211_BAD_BIP_KEYIDX	(SKB_DROP_REASON_MAC80211_TYPE_M=
ONITOR | 1)
>=20

Ah, this would lose the ability to immediately see monitor/unusable, so
we'd have to make the names even longer :(

Maybe some creative macro such as

DROP_UNUSABLE(DUP)
DROP_MONITOR(BAD_BIP_KEYIDX)

could be done, but that hurts ctags/elixir and the likes ...

johannes
