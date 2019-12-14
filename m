Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B311F1DB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 13:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfLNMu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 07:50:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51599 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725809AbfLNMu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 07:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576327827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SFJ+JVZh68kf5Bo3hbR3mNNs21dIVdglZ0+Q/a3JWrA=;
        b=fN2IqF29q0juCFx9GW1E/+noyuAryz2UpqE9b+RLFVFuTYDuzC+6XMU+nrDpAnNMjoaZZX
        cNTKzTx1xCazjSAz8Ge1dLcZQgZddjcxTXKm1/Yrt6CQnz8H6cO0bv+TDGvcMyic6fTFzp
        BF65Y2I/HORpz8U4U/z1N3+30ck7J68=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-wC0StmtyPMC2cJI5tdNpFw-1; Sat, 14 Dec 2019 07:50:22 -0500
X-MC-Unique: wC0StmtyPMC2cJI5tdNpFw-1
Received: by mail-lf1-f70.google.com with SMTP id t74so109548lff.8
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 04:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SFJ+JVZh68kf5Bo3hbR3mNNs21dIVdglZ0+Q/a3JWrA=;
        b=mPny3yq3ZM5MsVeTQBeTf0AgSQEk95h70HdcX/CarYPFG77/fCXO+aIS1ANQz+0w5T
         Vc/sxrMlPaLNq9/KV9s9IXBqdp6Ssu/NORGX2Jhsr1dAowBZqS+JsASCyfIsR+Mmvs7E
         /Gsj/rJ0y0JNkf/ZykM95pT6Srt4gc2pofmr+/Z26PsS6euEDNk/RHvogrYbXZcPjpTM
         Ua22aE1+rLUgJ7GLHE32WR9BU0ZDNqKFmNku5LftbyEOkWPjbUxdskg/oWsSljBiIwFY
         MXquiflLToBGuQFjtB/vsIbbtPolvWMfljQjOIQAPIMUdxDWBrsG8YCBwqSikhhsoVI/
         /ouQ==
X-Gm-Message-State: APjAAAXu20FhSU7wu/fo3bTQA0hQoACabKzWPmrZjVxajnOo8WvjuF/k
        oA/mZPvIrQljleFAWtJ6rpBE6p2YEwO/1x2jtWA7B61xFqCmGNPONUZ7tg5aHZ58IadaljRgpMK
        UeuIbvxy3XziUl1Gy
X-Received: by 2002:ac2:46c2:: with SMTP id p2mr10276413lfo.139.1576327820533;
        Sat, 14 Dec 2019 04:50:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvp0D/WOhsOaef++AzK+1abUCynFvfI+cueLmssQXL2aHLZSB34S5U/6RQhtGATfCbSDRr7Q==
X-Received: by 2002:ac2:46c2:: with SMTP id p2mr10276403lfo.139.1576327820372;
        Sat, 14 Dec 2019 04:50:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e12sm6644826ljj.17.2019.12.14.04.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 04:50:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A61C5181A44; Sat, 14 Dec 2019 13:50:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
In-Reply-To: <20191214014710.3449601-3-andriin@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com> <20191214014710.3449601-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 14 Dec 2019 13:50:18 +0100
Message-ID: <87a77vcbqt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]

> +static bool sym_is_extern(const GElf_Sym *sym)
> +{
> +	int bind = GELF_ST_BIND(sym->st_info);
> +	/* externs are symbols w/ type=NOTYPE, bind=GLOBAL|WEAK, section=UND */
> +	return sym->st_shndx == SHN_UNDEF &&
> +	       (bind == STB_GLOBAL || bind == STB_WEAK) &&
> +	       GELF_ST_TYPE(sym->st_info) == STT_NOTYPE;
> +}

Will this also match function declarations marked as extern? I've
started looking into how to handle this for the static/dynamic linking
use cases and am wondering whether it makes sense to pull in this series
and build on that?

-Toke

