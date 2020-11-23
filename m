Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2B02C0356
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgKWKbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:31:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727724AbgKWKbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606127494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UMgCW61zqAkB3c+w/CYSUdpW3LDqmoWBeyI4srFJ58c=;
        b=S6bW3ry0mdtCohErut4KUwVMRP7UVJ9hM41muCmKdtUERNF017UtIpNYULeg33DiWSylDS
        PPOnWI2quJgWsnBGuXK0xiQXmaO+PfSY/RP4LEtLfRfZunkMIC3iBf0Tfky6n9wN1MtFvh
        J2NMB2Cm8TkeQFYIzf+rthNyOh+FQzg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-5Lo__-P1MdmxOkCG7xhAqA-1; Mon, 23 Nov 2020 05:31:32 -0500
X-MC-Unique: 5Lo__-P1MdmxOkCG7xhAqA-1
Received: by mail-ej1-f70.google.com with SMTP id k15so2555585ejg.8
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:31:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UMgCW61zqAkB3c+w/CYSUdpW3LDqmoWBeyI4srFJ58c=;
        b=kByyxHQuq1zSfhwiGF7UXVmpyDwZqstc0cB+ptO1LMK2/ELrZ7wIoa2uR4vH5d7WyE
         qHzD5f/1uxv+mtp5IkaLMEliJoVt6FISs856ORlratK2r3KoSNk1MeFeveCfOGc4fS7D
         1z0G8f6DuncpbkR5WtPLoN6tXWExmmexvECs7LV6e5ugrhXv9EHKxEwcuZQYj7fwRRx8
         a+BN7aMZXrmKgJYH8g7YXog+8PtOtdqJKWEQYeVsoBsQLI9RJzNuZEFpMiyWYysJKytX
         FfHmU6kiOPSmq2WNJi6U0DFVyhdQmmSh1nIr2jjGtCrMaUzyQGyf/rxeheJTXG+aXhwI
         9V3g==
X-Gm-Message-State: AOAM5326pkQ96LvYGxIdhZjlBh7qqg8wL8VW6+SB9t4UWUNn29DzWWzU
        Nr8dkFr1s1AlZPdD21hCWlhk/1CCycH2HDuF3DlwG1WtyOncE7J9XeFQ9F/X9JGRKszBb05r83F
        ZYKemnYKxMaG1Gmjx
X-Received: by 2002:a17:906:512:: with SMTP id j18mr44485837eja.370.1606127490547;
        Mon, 23 Nov 2020 02:31:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQix3XASnb2R1wIlk0/OYWTa6sCSb/kGnCLCYE7l2XDHjsmpgtxsb/YepQiJp3/qHaW7kGYQ==
X-Received: by 2002:a17:906:512:: with SMTP id j18mr44485808eja.370.1606127490005;
        Mon, 23 Nov 2020 02:31:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k2sm4683215ejp.6.2020.11.23.02.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 02:31:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1B51D183064; Mon, 23 Nov 2020 11:31:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Is test_offload.py supposed to work?
In-Reply-To: <20201120084846.710549e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <87y2iwqbdg.fsf@toke.dk>
 <20201120084846.710549e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Nov 2020 11:31:27 +0100
Message-ID: <873610nz40.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 20 Nov 2020 16:46:51 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Hi Jakub and Jiri
>>=20
>> I am investigating an error with XDP offload mode, and figured I'd run
>> 'test_offload.py' from selftests. However, I'm unable to get it to run
>> successfully; am I missing some config options, or has it simply
>> bit-rotted to the point where it no longer works?
>
> Yeah it must have bit rotted, there are no config options to get
> wrong there AFAIK.
>
> It shouldn't be too hard to fix tho, it's just a python script...

Right, I'll take a stab at fixing it, just wanted to make sure I wasn't
missing something obvious; thanks!

-Toke

