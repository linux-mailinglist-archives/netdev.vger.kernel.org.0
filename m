Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6270114F91
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLFLD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:03:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44518 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726070AbfLFLD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:03:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575630237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HnhlcMTe5jtkct7liLHpcVyyPezFV9Qe6kqQPJE7h54=;
        b=W3tDdCccFTFU8uwnUycih5Ir+RchNbb5vI/u7njQu2GFTyDHevy0m4fV6+7bdDWUKpof5v
        kntJrLpJT8tmC+hRzuzpjXzlFJAtBbQkPCWFEgmV5qNf2TT/Ul21pUcY6IFwXBMZbmL8Wi
        tBE00SdJOon0ntV8zWWHBwcWoydNiXw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-wIndyX-HPGO4kEXDRf3TRw-1; Fri, 06 Dec 2019 06:03:53 -0500
Received: by mail-wr1-f69.google.com with SMTP id v17so2969927wrm.17
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wZp8OVSB/Wwr1IRdkrZ5KxsJ+ig6sV4lSNYS91y60nQ=;
        b=OD3t8dSZEbHxHBWSUzKsoBM1MtdUdtV1kUx7Jn4vUyzoIY2J4F5UGYq/Mif/q888Hg
         P0Sii3S8D6Obcgiqqhntkq5JSzRe78pv+uoYx2J4twVPiwWrtDnR9eetMU/1y2ESgj8A
         s7BvXi+a0ihcpezsb63v+LyW+R5mq3EKcZuiMIqJKpRfIVfaqtZOrByaVL30vAOQRIh7
         7jlO7YFbv/Hk7rsXMqDopGiYwblWMBxmCqjNhQObV5rs4voiDesSpfX6cW3HYIf/i1si
         Cfsy7nchJLsG3OxX+I5N1TmUsmgkq0Wdx9txDIsp+x9Ydikjr8A8Vtyq0fMG2ChYlNY7
         16eQ==
X-Gm-Message-State: APjAAAUDt0b8paBf4Foe7zfufNGdzxGxBdECs5XVRKZ+maXsQ/10k+ce
        wS7ooC7QLBnwh7Naky5BWeEOVXBvUdizR1bZmf82C04KmTnEGzrDl5hsDq3Ymq28/AN8yI2r77I
        wi1h4dyZHBENIyatW
X-Received: by 2002:adf:bc4f:: with SMTP id a15mr15244848wrh.160.1575630232877;
        Fri, 06 Dec 2019 03:03:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqyWqSHdi3gsEqnf/vmFDVUO7+TjpBNvnUjH9nJoOJEL1ssJn7SkUW3n+pcCXJZlPdO6UQTMNg==
X-Received: by 2002:adf:bc4f:: with SMTP id a15mr15244827wrh.160.1575630232723;
        Fri, 06 Dec 2019 03:03:52 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id b185sm3367539wme.36.2019.12.06.03.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:03:52 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:03:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net v3 1/3] tcp: fix rejected syncookies due to stale
 timestamps
Message-ID: <20191206110349.GA31416@linux.home>
References: <cover.1575595670.git.gnault@redhat.com>
 <3f38a305b3a07fe7b1c275d299f003f290009e13.1575595670.git.gnault@redhat.com>
 <db49bc30-9909-b15c-2b36-d805a4487e07@gmail.com>
MIME-Version: 1.0
In-Reply-To: <db49bc30-9909-b15c-2b36-d805a4487e07@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: wIndyX-HPGO4kEXDRf3TRw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 07:41:34PM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/5/19 5:49 PM, Guillaume Nault wrote:
> > +/**
> > + * time_before32 - check if a 32-bit timestamp is within a given time =
range
>=20
> Wrong name ? This should be time_between32
>=20
Ouch, yes. Will fix in v4.

