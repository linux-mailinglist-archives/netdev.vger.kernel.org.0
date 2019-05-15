Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354CC1F75F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfEOPYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:24:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34752 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfEOPYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 11:24:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id w7so51418plz.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 08:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4qqaknbSjvcc23qYtL91dNigZBdodEK7te3Wjrbefv8=;
        b=ts5uGyRhli5IaC/4evqNljN43UQ7d7RBbXCOBQaXq3dfXd6xP16R7qUgNDgArFXLGA
         epyiME9tjiyDA06LSD6Wa9SvLH4HLzac5Xf7vcy38WGzxfWf+a41LzoG4KuDxNDSTM6t
         /BZ1l5FykpFOP/1s3eIYZ8ts/t/ZLqfaatfSwv7QeMh4EJqOO13aN5R1VblrLl77M2e9
         u9sHxqxd0lWW0lRbBj87lHBWPaGSkZRjoKXXdhTOY0XCHkfB7CoXeuNnS6TINr0Hmku2
         l8xCB5AP+iDHJ2tesXR25/TBPE5BHQnDeeATvEn4IM5r14pj4pekAxDcOEEh8HbQcrxV
         n/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4qqaknbSjvcc23qYtL91dNigZBdodEK7te3Wjrbefv8=;
        b=L9ljInJpXYDYxlq6N2A/ERJbIIkE9wGWCRWy0EnxqnoAG6mXbs+1vSpxlfTaRzAFTk
         O89W5d+I8Ll/1GGi7f/WWhGLlsaWbJn+4NSq/iOCpBqymREbyWVoAjIyAcAZaseHYpLo
         KieDtBRLqthaiZfCVwnz7rcbSWIooKJ/Usvtj5v9PtwD6Sy0i9xEA2gxULrGCrTLbxbw
         kN05dC+pgKj8OWcR8GP+9Q9PGhtj/W2VNMSTcw9lE37E7ekT1oR1X+yjsdKdTdOG4wnW
         S85LfSH8lSxMgcGgVa8ARjHvWuq6O1e78Wxja0g4iMu5UqxLodFsSUhhOQYgB5Infev5
         zKjw==
X-Gm-Message-State: APjAAAXoEjnpmDGpilnNqJHQy3Ifn9Fxh0JfWHqIcz7KDIDkkPTLVt9T
        sOjpC8WYy+5JoBnD5qkfM2vKGg==
X-Google-Smtp-Source: APXvYqxy1ejw7lv/FS9iMmmpYwEe3BFosOzOc5QtLdY9Bt57US/20K9ekOkLxCw2aT4co3xNBiLNEA==
X-Received: by 2002:a17:902:1126:: with SMTP id d35mr8549819pla.82.1557933839246;
        Wed, 15 May 2019 08:23:59 -0700 (PDT)
Received: from xps13.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s5sm5829038pgj.60.2019.05.15.08.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 08:23:58 -0700 (PDT)
Date:   Wed, 15 May 2019 08:23:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [RFC 1/2] netvsc: invoke xdp_generic from VF frame handler
Message-ID: <20190515082356.21a837b2@xps13.lan>
In-Reply-To: <096b0f82-707c-fd35-e3ce-3c266a606af5@redhat.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
        <20190515080319.15514-2-sthemmin@microsoft.com>
        <096b0f82-707c-fd35-e3ce-3c266a606af5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 May 2019 16:12:42 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/5/15 =E4=B8=8B=E5=8D=884:03, Stephen Hemminger wrote:
> > XDP generic does not work correctly with the Hyper-V/Azure netvsc
> > device because of packet processing order. Only packets on the
> > synthetic path get seen by the XDP program. The VF device packets
> > are not seen.
> >
> > By the time the packets that arrive on the VF are handled by
> > netvsc after the first pass of XDP generic (on the VF) has already
> > been done.
> >
> > A fix for the netvsc device is to do this in the VF packet handler.
> > by directly calling do_xdp_generic() if XDP program is present
> > on the parent device.
> >
> > A riskier but maybe better alternative would be to do this netdev core
> > code after the receive handler is invoked (if RX_HANDLER_ANOTHER
> > is returned). =20
>=20
>=20
> Something like what I propose at=20
> https://lore.kernel.org/patchwork/patch/973819/ ?
>=20
> It belongs to a series that try to make XDP (both native and generic)=20
> work for stacked device. But for some reason (probably performance), the=
=20
> maintainer seems not like the idea.
>=20
> Maybe it's time to reconsider that?
>=20
> Thanks


I like your generic solution but it introduces a change in semantics.
Netvsc always changes device when returning a ANOTHER but do all devices?
If some other stacked device did this then there a chance that using
XDP on that device would see same packet twice.
