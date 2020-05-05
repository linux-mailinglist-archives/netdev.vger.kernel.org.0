Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBED1C5D93
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgEEQ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbgEEQ2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:28:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F15C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:28:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id rh22so2168384ejb.12
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=mkrDmN8OaGRhN4F+5g25hkHuD5TIe3aLkVkjvXIirIE=;
        b=DvrJoJdwX4wojPg9gZ5ZtuLgqsbR+v4H0dBgFB4NenPU2I+MDGfYWrREcVQPUWBt26
         wAaibeFk2QE1CtTqHIulpQMDFT7/tECK62WZSwymDhROuP0eEaql4Ml8ntB1SZpreofM
         WbATICxrUIq2HA2RMdiljgB1GvBVUnrwErvbYbC13qfb5RVwR9hQLYAYayqk4dqSlCGQ
         qSbvqzzscML/D6fSZyalhZiNWe3SNu5fx3cOeFHgsnBMq+619s80zyF7IZR8bj27jW0y
         VTH2b63PKDzK/RSyxWeMoy2UiY+/qH21EXFoYZXzBz5BuzjT5sdvU1n2MudouaJDjg9L
         2NfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :thread-index:content-language;
        bh=mkrDmN8OaGRhN4F+5g25hkHuD5TIe3aLkVkjvXIirIE=;
        b=X67IZYDjQigDUS4RHp/3FC6EvHVJ9N/WBcQMNZV+llGqfErgW1gzEcCUp0hI4dJ7V0
         Wn6gMBKB1hHxwnAwU4pCbkpH+om+rm3rTORtgvipIwvjYEDoD31LBZBu6YAKCdl+pmu4
         pvQjxEhpsbS/6dSSYOFwcMh7JMQPfyPeiWSIFp/3Tsqcu3+DTP+QiFgmB/z3gyz7NYAw
         sCuES1RI1gp9gyqYwvG1Q+GJfnI+UUJwzYGn/06WWh8+XNqhkhlsZpHyvl4r5M5mDG//
         KSfRucUxEW9nNr6qvlrArSsrfohqXMb840y1TltO4oeImxSM/Cz0vqIRqclvJ/1jN8BY
         CAXA==
X-Gm-Message-State: AGi0PuZb1XVl7ztle1g5Xhz5JWtccyLiK0OSXgYinfurNX5/zJPYWerH
        CG1mTzeMEGyEOe8niYaV/Jc=
X-Google-Smtp-Source: APiQypL1OXlXrAGcooKtNcKuyn7ci++JEgkhWF+shL/fzi12q+rXB/e66g0Nf3qWwFdofuLAr+g/Jw==
X-Received: by 2002:a17:906:f159:: with SMTP id gw25mr3564756ejb.193.1588696082598;
        Tue, 05 May 2020 09:28:02 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.186])
        by smtp.gmail.com with ESMTPSA id n23sm330542ejz.20.2020.05.05.09.28.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 09:28:02 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>
Cc:     <netdev@vger.kernel.org>, <jgross@suse.com>, <wei.liu@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org> <1588581474-18345-2-git-send-email-kda@linux-powerpc.org> <004201d622e8$2fff5cf0$8ffe16d0$@xen.org> <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com>
In-Reply-To: <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com>
Subject: RE: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Tue, 5 May 2020 17:28:00 +0100
Message-ID: <005a01d622fa$25745e40$705d1ac0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE3/rdtCvsSNPb5s7Kxs8cJj/qIbwLQYVL2AY7IqSUBQOo04amo9b8A
Content-Language: en-gb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct =
xenbus_device
> >> *dev,
> >>  		set_backend_state(be, XenbusStateConnected);
> >>  		break;
> >>
> >> +	case XenbusStateReconfiguring:
> >> +		read_xenbus_frontend_xdp(be, dev);
> >
> > Is the frontend always expected to trigger a re-configure, or could
> > feature-xdp already be enabled prior to connection?
>=20
> Yes, feature-xdp is set by the frontend when  xdp code is loaded.
>=20

That's still ambiguous... what I'm getting at is whether you also need =
to read the xdp state when transitioning into Connected as well as =
Reconfiguring?

  Paul

