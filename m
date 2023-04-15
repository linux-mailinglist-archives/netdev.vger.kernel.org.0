Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73EC6E321B
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjDOPdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOPdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 11:33:22 -0400
X-Greylist: delayed 466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 Apr 2023 08:33:21 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840943AA6;
        Sat, 15 Apr 2023 08:33:21 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681572333; bh=BfOek8nN7LhjEp1cet6CGSgVhTOGPEErbMQXuVTRugQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OQf48gzTfd+3GrNYdZGz9eaNIPqmVKIaNkEWNmk/GxFhIiLWiQNi7fUwwzVYWF862
         ExSVUFwNHVf33xv75c32XDcK0ABt9JZKxMbl17pA+zXQsxdmOMMk/UdNiIttwN4iEZ
         RpToCVaoawe/5Pijar0X9/inGVLxv4ywWmdCssVq6MbdHksVU0sLBLAVrN5so/QLzP
         rA6uSxzf8s1n9xm1BJ/X8jacXPs9gAp72ty4OVbzVCIGaEvTcXDU+20BmIvKBt+2oV
         zWH18DOUY4Rues/uCRxRwpoEEI2sYR+W2BS+3M+vwVys69V63aOZ1JCUp0wLQGUL7H
         g5jlymimCWcjA==
To:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chunkeey@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>
Subject: Re: [PATCH] ath9k: fix calibration data endianness
In-Reply-To: <20230415150542.2368179-1-noltari@gmail.com>
References: <20230415150542.2368179-1-noltari@gmail.com>
Date:   Sat, 15 Apr 2023 17:25:31 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87leitxj4k.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com> writes:

> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
> partitions but it needs to be swapped in order to work, otherwise it fail=
s:
> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
> ath: phy0: Unable to initialize hardware; initialization status: -22
> ath9k 0000:00:01.0: Failed to initialize device
> ath9k: probe of 0000:00:01.0 failed with error -22

How does this affect other platforms? Why was the NO_EEP_SWAP flag set
in the first place? Christian, care to comment on this?

-Toke
