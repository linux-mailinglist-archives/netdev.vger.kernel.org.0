Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C125997
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfEUU62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:58:28 -0400
Received: from narfation.org ([79.140.41.39]:39134 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfEUU61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 16:58:27 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 16:58:26 EDT
Received: from sven-edge.localnet (unknown [IPv6:2a00:1ca0:1480:f1fc::4065])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 25B4C1100E8;
        Tue, 21 May 2019 22:48:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558471729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UVjpMJ6OkIOCk7vUC6sEB0fz2hLckovRDJkS1E2b+/A=;
        b=UJ9DAuq/q+o1mSacSCncFMnj2FvxlbWfMxE9WmlVkjPsn1K++pl+8mNyIhVD8ckTk49Evq
        YhEErOtX3vyTrsG9iCaxjriLRWPN9W796ef/jZYAh/B+XIiUmc91z2Reo9NffFX174YS2N
        HWn6FmUKelz3m0VxrjgR0Z6E2uw1irE=
From:   Sven Eckelmann <sven@narfation.org>
To:     b.a.t.m.a.n@lists.open-mesh.org
Cc:     Jeremy Sowden <jeremy@azazel.net>, netdev@vger.kernel.org,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Subject: Re: [PATCH net] batadv: fix for leaked TVLV handler.
Date:   Tue, 21 May 2019 22:48:32 +0200
Message-ID: <2234850.c0QxkmldC6@sven-edge>
In-Reply-To: <20190521195857.14639-1-jeremy@azazel.net>
References: <00000000000017d64c058965f966@google.com> <20190521195857.14639-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4379812.Jl03XZO3XG"; micalg="pgp-sha512"; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1558471729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UVjpMJ6OkIOCk7vUC6sEB0fz2hLckovRDJkS1E2b+/A=;
        b=jI/bDYkcPLGlclDz7wUmoq9trl6+ag2XRO/DA+gHgg1kmYxiX0eUy/CnPMtKZvVaYPtYai
        D0SNdupG/4vUpW2/xUIFGDykl5Yzy9rZxztQRKxu6D5n3pHm7paTzMevsmtAjNVF8iMTiv
        PBLJ6DZDH/sXVWmS2SUlsO4bcbwOOTE=
ARC-Seal: i=1; s=20121; d=narfation.org; t=1558471729; a=rsa-sha256;
        cv=none;
        b=GzpNQ9FNCyBfzu+UTeW06/J4VB0lGXJRSwcnG7sMepFk2yAOWPh6xpe7qpETFVKvBcfM88
        wL1PXFPU/PVDaZ3C1GBl85O25tPtmwRFQdG45nO/VmMRngGfK27DYckvWM2Osg6UMGJSRt
        vJJixZOSlqlrFu8CPnHekeHj+21VG6w=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=sven smtp.mailfrom=sven@narfation.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4379812.Jl03XZO3XG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, 21 May 2019 21:58:57 CEST Jeremy Sowden wrote:
> A handler for BATADV_TVLV_ROAM was being registered when the
> translation-table was initialized, but not unregistered when the
> translation-table was freed.  Unregister it.
> 
> Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Fixes: 122edaa05940 ("batman-adv: tvlv - convert roaming adv packet to use tvlv unicast packets")

@Marek, @Antonio, please check whether this looks good to you.

Kind regards,
	Sven
--nextPart4379812.Jl03XZO3XG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlzkZCAACgkQXYcKB8Em
e0YN9Q//T6t3yD6cU1SOuMWlrF1Aj0/L4eC2I5c2jxK0R07b4lSuJPCF6xxduI5W
g0Plqr9g5N7CzYW7CADCc5oMJq2ksUwi77rvTxpJXnS2CJXW0SwnNBrHrVCbhbFZ
akOOp1bXMzUNH9Uag4iRw0CwL6dO6hu9cOo6a/gYTeQvVe/Dkx42+pFSZ4/Y9Hph
3Qvq2wXcOQWxj3IkeHPxOwUdBjZwUPBL60aH41pZEUX6L72x4YnNkGbfWCsFoKOX
8Tgm+RzQeR4+vFqyT775L9BeBV2Mvdu2ey5dyP0PAXlc+rIMAYmmfzJY109MaF9b
f3qd0xnUYBJE9LYPZbuEWlvlgmvNjkfzVa2cL/zXNc03r3tYUIUB+SAr2oGtZQKc
YKfFUf4IVj/ew6x2UnhRelp/uAraIUEfShyM/K5a25bV9QLNqGWMy+BEBAyfXut+
9GyijuZ/+b3S27pREsGC+iAVZK1zrtLPnUOnJIWTGvN7br3DklNbbsQgHkxD9//q
XYKPAN31ksk7TKBl+ul5v5JYjZAeukKELq4vef/uDYEfeRAJzsARAytO5qDCHPTE
3x3cGkOr7apLMuDgfVG/2M5DLX4rB5KuKKDs0C4GjX4xtmxnzhatk8bHUQ3yvOYP
SA6a4fbC/nu7P+9feH0S1olQkhptoyAwL3WS0E3aAYn/QhjTFVQ=
=sJEP
-----END PGP SIGNATURE-----

--nextPart4379812.Jl03XZO3XG--



