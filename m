Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4126CFDC9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjC3ILk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjC3ILU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:11:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA225B8E;
        Thu, 30 Mar 2023 01:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tD4NuRv6P3IlIn3t62Ce8vvu6A+eJzU9qbwGk92isMY=;
        t=1680163875; x=1681373475; b=bfgyAUHBjcQ+qIIvY/E1bvL3J+HoSB0YMhokZOCIIzgIIWK
        +E0gqDPV7xLQpqaXeNKo5EHlmCSl6Stm636ePyuDHA/4mcASYBiKHzH9R4AvTXVSRZYW0/fKhHbpO
        AnMtenJkv+79km9BKbECwqBLNRdCi/nVHwY1YE7N9g4ATyHCi704oinaaSz0dERFKPkAC/mIarI6A
        UzMuTrx1Jwyv5+8LQ/PxRGNm5lHLL7wXRWQeu1q33ugeHyZHiUB35Q8SNK7fIniDIkfjNx1j663xS
        lEc/nUQi9jFRNY1ws5b7oB1RDV/d3IymkkR2axespdzRK7FaZpIMEQ+0dVFhKfxw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phnNJ-000wU7-0z;
        Thu, 30 Mar 2023 10:11:13 +0200
Message-ID: <cb8ca010692920d909d0155aac9d66761bbf250c.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 1/2] net: extend drop reasons for multiple subsystems
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 30 Mar 2023 10:11:12 +0200
In-Reply-To: <20230329210524.651810e4@kernel.org>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
         <20230329210524.651810e4@kernel.org>
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

On Wed, 2023-03-29 at 21:05 -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 23:46:19 +0200 Johannes Berg wrote:
> > -	DEBUG_NET_WARN_ON_ONCE(reason <=3D 0 || reason >=3D SKB_DROP_REASON_M=
AX);
> > +	DEBUG_NET_WARN_ON_ONCE(reason =3D=3D SKB_NOT_DROPPED_YET);
>=20
> We can still validate that the top bits are within known range=20
> of subsystems?

Yeah, I was being a bit sneaky here ;)

We could, for sure. Given that the users should probably be defensively
coded anyway (as I did in drop_monitor), I wasn't sure if we _should_.

It seemed to me that for experimentation, especially if your driver is a
module, it might be easier to allow this?

That said, I don't have any strong feelings about it, and I have some
bugs here anyway so I can just add that.

We _could_ also keep a check for the core subsystem, but not sure that's
worth it?

johannes
