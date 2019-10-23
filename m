Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4CE206E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407212AbfJWQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:21:55 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:42467 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404929AbfJWQVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:21:55 -0400
Received: by mail-pg1-f173.google.com with SMTP id f14so12420047pgi.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2gNzSLRsY5MYmv6sI0DTqc9fcflHPmtBoEdKyl6UdxU=;
        b=c9Zs2Hc1ltHNK/pXgRc4OOCrVR/lIdNxlYpwX9WqbTQdl/XIbkCtGpGZc43QsNj/ZU
         GPly3EBB8+mSlJVQqtuAFhjgUf4ya3yav2+G5bOYrMWFU2GEvGHUwNQggQS3Z91CNwzW
         tcYbQSg4Z3FjbGLZ+R3f9n9k8Koc23eEG+GRDyr9SpZWrrgwSyKRzNwbUx5gVRiN29Le
         Dmz/nPJlUUj/PVE36hWm3UD80lfgsyUWkHzgKTsPTcj2DoFstCrZBcQwukY3Wyg/th79
         fA8HiA9L//cOGbx5PLPc3EkUzGdy05SJ+HmS8D53pAOo6b3fFPFdqs4/Sdd3gsxuoayN
         TJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2gNzSLRsY5MYmv6sI0DTqc9fcflHPmtBoEdKyl6UdxU=;
        b=Fq+fU0/di4JJ6H2bQ920mKEmypA9g9i+FdAD/jV14ccR981wzb7m4JP12FuBJ633+S
         zhKMW5AVMn/SUYyIjJYoIe/KYXyAmAjWeHs2BihXAUdyZ/ACErHFG9oPJkYTPAL5zgIH
         JL61PntLXpogBaGNZcSBcANAfNU3r9wl+/q0Jm3PCbABVlrvfDW/YNkUb+u/fOiW4wET
         gxMp9HpmhdpHFrhbJ2JtEleX+/AnEd4OfJaSgcNbzji780zjt50FgaMaQBxCFaXm/WHJ
         pxCuCTCWNUwqvZT/++N7w6igasO0+jcw2lsXK/0HpTrQVdMUml1VdWMijyQvfBaNRxHO
         Q9yQ==
X-Gm-Message-State: APjAAAUCAzVp1WCWhJPW2Z5CGOBGatJz9lDO+SMZxCb7o8Bvhy6TK1T+
        qDKa2eXb4du2ThrSxCMAT/ry8U+3wkqRbQ==
X-Google-Smtp-Source: APXvYqy6YNOS+lxMiHj8eiY3//IUs/N/eveMF2ZVVC5vF6YMSvqq0O9rKh1sBEPQAlXyzE2Ag2BTvg==
X-Received: by 2002:a63:4622:: with SMTP id t34mr11302936pga.0.1571847714253;
        Wed, 23 Oct 2019 09:21:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 74sm15558573pgb.62.2019.10.23.09.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:21:53 -0700 (PDT)
Date:   Wed, 23 Oct 2019 09:21:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?TWljaGHFgiDFgXlzemN6ZWs=?= <michal.lyszczek@bofc.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ipnetns: do not check netns NAME when -all is
 specified
Message-ID: <20191023092145.0daebf54@hermes.lan>
In-Reply-To: <20191022200923.17366-1-michal.lyszczek@bofc.pl>
References: <20191022200923.17366-1-michal.lyszczek@bofc.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 22:09:23 +0200
Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl> wrote:

> When `-all' argument is specified netns runs cmd on all namespaces
> and NAME is not used, but netns nevertheless checks if argv[1] is a
> valid namespace name ignoring the fact that argv[1] contains cmd
> and not NAME. This results in bug where user cannot specify
> absolute path to command.
>=20
>     # ip -all netns exec /usr/bin/whoami
>     Invalid netns name "/usr/bin/whoami"
>=20
> This forces user to have his command in PATH.
>=20
> Solution is simply to not validate argv[1] when `-all' argument is
> specified.
>=20
> Signed-off-by: Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl>

Looks good, applied thanks

