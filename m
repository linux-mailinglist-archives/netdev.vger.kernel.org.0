Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E74A407B
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfH3WVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:21:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36932 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfH3WVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:21:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so4205928pgp.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RdMBA0rMWtpafzUMj9JZZ/OpRJIlcfu5WerjmbjKdEY=;
        b=vPNhlBCWVdB6MjZ40DVLxsXiijZMXAMSexoU+UFpKSVJGa98AoRLMD6myr4vik4tHL
         KFIYMg9sdhZal1dz/Mf3zify0nL+5FYs9lBZ/pnnFZOTM1RxxPQ6h+gEMCAhho4uClv2
         g+MUvnV46AdgYqGZhRnkblPZrY2dDT5BeQejPbND6eTOQ335NmxTTHR65VFg+zUWfrC8
         QJOp2nrlnSP0qxp6bk+UKpJBQhyq4AV8LWMSwqxOtowD3iEF4EzZvyUCY2qt1jQWTZXk
         nP0VxDP/8b95v2EYAWvpss0/qq3TavQH682zEszD/HHtWqviBSCbW8aZSoYuu3Te8nlT
         lvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RdMBA0rMWtpafzUMj9JZZ/OpRJIlcfu5WerjmbjKdEY=;
        b=OpkzUjrYuUhweCb9kHtDaJPD2Xnfwao6z5VHBUaeMTxPlIxfhvxDiDE9mxEXa5AmIb
         Kz5bCj1MtvImRB8A+FzswS0KJwuEeQzaBAqctLlxf5xpnsZl3ubY04pfexi0Lwoo1DN2
         rchwtrA6HaLQ0sunbjFDKN6cmUYHzBscMqptYmQeBvx9Bz2dDqCdtcW8nUSh3wZZAl1w
         tgZGGRjtRm7x8VgcZeLC3RwP/hwncBbucwLIAyO9XSVFxcPcgHAFWS1zBkN2EhzYLPER
         dbea6tmcAhw4+jD8kt1OeaOcscAxQ1K85tGxD0VO/64TS6pX6YkTL+t/PmE00p7Es43F
         b/DQ==
X-Gm-Message-State: APjAAAXPQ2Moo4+SNe1r0SRZ7JuepnKOF8R1JaZdNj6rUiyUXIG/qZgj
        FPt6i7ltGcFPvvT8Jrl8ERBukhFTNLE=
X-Google-Smtp-Source: APXvYqwyxTow4LCYVqTTh2XIktZdIAW9ITjPC7zsK4s10AkJud0chA0HDiHpGqawhM5YnlMVE3GalA==
X-Received: by 2002:a62:e30d:: with SMTP id g13mr539784pfh.42.1567203707096;
        Fri, 30 Aug 2019 15:21:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e185sm8414300pfa.119.2019.08.30.15.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:21:46 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:21:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
Message-ID: <20190830152123.6307fee1@cakuba.netronome.com>
In-Reply-To: <31ea9c22-15e0-86db-a92d-76cee56fc738@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-16-snelson@pensando.io>
        <20190829163319.0f4e8707@cakuba.netronome.com>
        <31ea9c22-15e0-86db-a92d-76cee56fc738@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 14:44:24 -0700, Shannon Nelson wrote:
> On 8/29/19 4:33 PM, Jakub Kicinski wrote:
> > On Thu, 29 Aug 2019 11:27:16 -0700, Shannon Nelson wrote: =20
>  [...] =20
> > There's definitely a function for helping drivers which can't do full
> > TSO slice up the packet, but I can't find it now =F0=9F=98=AB=F0=9F=98=
=AB
> >
> > Eric would definitely know.
> >
> > Did you have a look? Would it be useful here? =20
>=20
> Yes, obviously this could use some work for clarity and supportability,=20
> and I think for performance as well.=C2=A0 But since it works, I've been=
=20
> concentrating on getting other parts of the driver working before coming=
=20
> back to this.=C2=A0 If there are some tools that can help clean this up, =
I=20
> would be interested to see them.

Ha! I think I found it, can you take a look at net/core/tso.c and see
if any of those help?

I'm not opposed to merging as is, but at the same time I'm not
volunteering to review that function..
