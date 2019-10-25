Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42273E4F04
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409403AbfJYO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:27:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38578 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407806AbfJYO1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572013623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSGPuJMLYfDMnAmpDMOZktcz7mBfnLm8edFjjutXhg8=;
        b=geh6UgzoyclrkjTIbVBsAKhPceZCdzkU3Lc+e58fwJwayBsL3Kb07MXH8WUKml+heW/KAM
        Q2W+kmcDF7vrN+3+t0RzILDQ5g87p5eMwa3/bADzGy1rqcoPwXNrMLYSBM4cOn7/SAZZ9+
        AShInjnAbysRl4XfXG6JW6WLT5OdY9c=
Received: from mail-yw1-f72.google.com (mail-yw1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-13DMEAj3OISWXLSwMr-ggg-1; Fri, 25 Oct 2019 10:27:01 -0400
Received: by mail-yw1-f72.google.com with SMTP id c189so1810570ywe.18
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 07:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lSGPuJMLYfDMnAmpDMOZktcz7mBfnLm8edFjjutXhg8=;
        b=KfXCG9ZUKgi1N3pt8awUAFF5JycqGguzNh8RdiWblHW5ctaN4SuXYx1psEmSKmWu54
         GAtyOYFPw2TilwKc5LG8ipkijQKq0LfNgqmL4eWKhydBW2sLLDhOhpDq9dO4S7vd2RJx
         C8XJ/LOCqZfgsw1pHmEg5fwaBEa3W6ubsXQcd7Zk52FTrlPUrfH3DYM19UHWpwQRkRFv
         RHPRAQ8CmwW4AZNuAK81QeUOpJuVh/tMObeCT3Ht1qCehT2uSOk8fUoajL6UjFJIGO4k
         7B2NnrXl2M37A6eBb+owy6maDN8wFK1CvinaJkCmzPMU18BZ46M4LAjtG0uu10EOx/Pf
         Fe7g==
X-Gm-Message-State: APjAAAV8+fjbj7TfcOyDhvkvQT44kT7YBv3shMx24LG/QrC68Sk2mygc
        cu0756cNzWDHMHQ7Bxf8/ZWUeuVUpQX8Y+Hez1N940D7ymHMNq/4wWMW5CdTPC24CCth0tMS+9X
        +GlEuaVDlEwSyrhPG5ajqCWk1xYcA6VmE
X-Received: by 2002:a81:4784:: with SMTP id u126mr2442206ywa.349.1572013620404;
        Fri, 25 Oct 2019 07:27:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxeLjnpJ8r6rblunofS7P6SYHd9DzfXkk/G7kqmKj6vgbeu2w6G6vCf29CxNnFugrVbxQIIC4KgRjCNmMCaKyA=
X-Received: by 2002:a81:4784:: with SMTP id u126mr2442178ywa.349.1572013620104;
 Fri, 25 Oct 2019 07:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de> <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de> <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
 <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
In-Reply-To: <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
From:   Tom Rix <trix@redhat.com>
Date:   Fri, 25 Oct 2019 07:26:49 -0700
Message-ID: <CACVy4SVAsG37n7q6jrRPSr-WV2QxSympuNQC2j+GJzBXqfwvtQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Joerg Vehlow <lkml@jv-coder.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-MC-Unique: 13DMEAj3OISWXLSwMr-ggg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will work on refactoring the patch to v5.2-rt.
trix

On Fri, Oct 25, 2019 at 3:22 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2019-10-25 12:14:59 [+0200], Joerg Vehlow wrote:
> > Here is one of the oops logs I still have:
> >
> > [  139.717273] CPU: 2 PID: 11987 Comm: netstress Not tainted
> > 4.19.59-rt24-preemt-rt #1
>
> could you retry with the latest v5.2-RT, please? qemu should boot fine=E2=
=80=A6
>
> Sebastian

