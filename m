Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CF61249AE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfLROam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:30:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727180AbfLROam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576679441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vM71TObiX5Umg40IilvmC9VxHoZ8ZkBlIJXCWOPb9E=;
        b=dveqazRRenuTU2uSMDuEHzbh8UpqHYSSWzCZd1Narj/xALQOuZ9bwV56W2wBJHURyDEBrm
        UHUw5kx2T7Zy1kVosXh7gVq9bisbYqIfjHrd1z6GVFbxkTAqY9x5AhHsMZCr6GZAJhpeHo
        0JGgdMmW61h83O0TLgFoyrAZA5bgCiE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-zNVbgacQOF6xx-kOJ2G6Vg-1; Wed, 18 Dec 2019 09:30:39 -0500
X-MC-Unique: zNVbgacQOF6xx-kOJ2G6Vg-1
Received: by mail-lf1-f72.google.com with SMTP id a11so233547lff.12
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:30:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2vM71TObiX5Umg40IilvmC9VxHoZ8ZkBlIJXCWOPb9E=;
        b=WQlicCzu6oXaGenGjUgvEFSYfMy3SaWYmwUXvcP8CW6CTU92zE+puzkHPnoXpPudLH
         PZboImJfjxYQgfFNYnS8mZTWzditWs3dNPUg53D5oXhtASlEVCgvPE8fUI4RniewjszT
         DIcvp3/9+OQ7GeTi/abkRt6A0letpFCxTWSkpJ5tVfrzlWY5Y3jsbl1kt1wXHa9iiLus
         mNoREPUgQTPrSGX0errtZyGtSblvCMs01MqWJGZC5RZnCl8X//smAD54QcXMC8JI+d/C
         Q1zinMSYaTUejbKAJZXMhcBDP5KSaNxQ52IuAMRp35DZsO2ZzkWWtVrV2edsODYEiY4f
         oS3w==
X-Gm-Message-State: APjAAAXENXGxtM0xCQBdOHQBVI60CHaE8Uvr9z/RTQmYwTlF4FsCqSWO
        J9Ias1vVjDNr3I5HRlddv8uHpKjO7k6M2hKeHXVsjPiD2EZaVG9xm33REzXA9iv/TUYY+QD8Jws
        BnoaLDJSUWPmNQnE+
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr1967397ljl.134.1576679437879;
        Wed, 18 Dec 2019 06:30:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxsqx3FDUFcFmrV2IId8ak3fKhBfcs9WmCVcKULQCtcOOEfmBDE8HTKjQl4MlusgfRtWkX1ww==
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr1967376ljl.134.1576679437560;
        Wed, 18 Dec 2019 06:30:37 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i5sm1316041ljj.29.2019.12.18.06.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:30:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C53ED180969; Wed, 18 Dec 2019 15:30:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable tin_quantum_prio
In-Reply-To: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 15:30:34 +0100
Message-ID: <87r2114sfp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> previous implementation of diffserv tins.  Since the variable isn't used
> in any calculations it can be eliminated.
>
> Drop variable and places where it was set.  Rename remaining variable
> and consolidate naming of intermediate variables that set it.
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

