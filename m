Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01045FDCD
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGDUmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:42:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35505 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfGDUmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:42:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so3540516plp.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JtQVAQz6NVyH2NItSA5pmHp1/PwtbtiVXqtTWIa5Jvg=;
        b=vHe0b/q666zEE3c2nrbReFiDm6+Zdp14v0xC5Z1hgqUaPIpDuevVWGaM2wD80Ct6UO
         BHnbptgVI9NWagXJ4QkkZp8zMCfFbiai/kJQHlDFjiSFD3wtlAcCRHc4AJaUXmwCBjui
         bTeAijyVOMy7Y8QMGa5OV1x2zh5k46YvTVdFAgxzazgPo+Mn+Prp+1wwHdciPILzZQMZ
         QIjP9ZISG6GxTJr4w6yQ0iqfxxqhPn4kVMvMXPr3QDQmpj8bgYMPNMyeFg+PHnR23LbC
         L1pngCZWB4+2fkvdHKyNRQehS56M6Moe4UB7a7YmHjcRU1UypYjU7XnRValIP9GnaY9h
         YpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JtQVAQz6NVyH2NItSA5pmHp1/PwtbtiVXqtTWIa5Jvg=;
        b=RkZYchuVCNw2+TwQ91t7WSlUMN+NecvmENV4cuZdVSD8N+sy6qDp5RL+Jp1gS45aAg
         rvURDi9y5ju+/7Rn94S3cDeS3atLvtUhDq4grGeIdV8t/JgY7dVzfd97HxK1GcnFcTXa
         2VmVCyt8E3A5yLheLa+aTq3lLbs2pVZYTmOUnhi4GkEPouAMn6LS0hzuQvprqSt+tnID
         qj4p5Q72z9m34GIP+EDnX9kh0HIATGaUyAaJH47JzFwC5xpYMyOvw+bFw/n6iDO6JYDT
         tyscZBNiP1/nm8BwuwkKeihn6UK74wQnSPfpsM8DBgt9DvC6lmg1+w3uo8ymKq4d+ENU
         wyjA==
X-Gm-Message-State: APjAAAWWNQgyYhDaKD2BzUlev21JvoMrp6w5oyLlsg3Ks0uFw8abTf7M
        K4eR5tcth1sPXrlGUOuH0xKilA==
X-Google-Smtp-Source: APXvYqzQ8AsnCq4ngmBo7O1aaeOK29eAo6/X+aRaJQgUmDdb1YMpWAJ987/eMo0Agxx6mFiFUrhkTQ==
X-Received: by 2002:a17:902:e211:: with SMTP id ce17mr181011plb.193.1562272938912;
        Thu, 04 Jul 2019 13:42:18 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id h26sm13468206pfq.64.2019.07.04.13.42.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 13:42:18 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:42:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] tools bpftool: Fix json dump crash on powerpc
Message-ID: <20190704134210.17b8407c@cakuba.netronome.com>
In-Reply-To: <20190704085856.17502-1-jolsa@kernel.org>
References: <20190704085856.17502-1-jolsa@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jul 2019 10:58:56 +0200, Jiri Olsa wrote:
> Michael reported crash with by bpf program in json mode on powerpc:
> 
>   # bpftool prog -p dump jited id 14
>   [{
>         "name": "0xd00000000a9aa760",
>         "insns": [{
>                 "pc": "0x0",
>                 "operation": "nop",
>                 "operands": [null
>                 ]
>             },{
>                 "pc": "0x4",
>                 "operation": "nop",
>                 "operands": [null
>                 ]
>             },{
>                 "pc": "0x8",
>                 "operation": "mflr",
>   Segmentation fault (core dumped)
> 
> The code is assuming char pointers in format, which is not always
> true at least for powerpc. Fixing this by dumping the whole string
> into buffer based on its format.
> 
> Please note that libopcodes code does not check return values from
> fprintf callback, so there's no point to return error in case of
> allocation failure.

Well, it doesn't check it today, it may perhaps do it in the future?
Let's flip the question - since it doesn't check it today, why not
propagate the error? :)  We should stay close to how fprintf would
behave, IMHO.

Fixes: 107f041212c1 ("tools: bpftool: add JSON output for `bpftool prog dump jited *` command")

> Reported-by: Michael Petlan <mpetlan@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
