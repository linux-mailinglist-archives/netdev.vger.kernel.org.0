Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CB31D3ED
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 03:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBQCXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 21:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhBQCXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 21:23:43 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13906C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 18:23:03 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u8so12258929ior.13
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 18:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=coverfire.com; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8Tk6Lc5M6fxG2/59xM5tXWmV7yWj9hsPMxluvpH1XPc=;
        b=BHfMW29Fk9+hgceGBtimjIQ7b0lZCL4lnJ106M6MNfUn6NT4/sUFB+sioG5TwUXpv4
         beAyKUSVlzf1HvqbeXxELv1vf7UQAz+1oMVoBvWAlNtQgdP42YKrz7cWvow7wYDv9KTB
         4mwt54F2QVOeGWrw1KvcJ0wlZMGf6ZvaFXQcqi3AisG85GObBRXD2y2lRDIsAG968uye
         5uSDqsGy2XbJs5oWT6rTr5JyUEANPkvBPqQ3Qq6vd+iCuqXh5Fb1P4s/XHets8DwZ4VA
         LvM+UcGtnAkQZzISgOaZi6M414m5PBl8q+KyaKaGKa6LILjRjvfODqvqabmrhjEZqPHe
         FDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8Tk6Lc5M6fxG2/59xM5tXWmV7yWj9hsPMxluvpH1XPc=;
        b=pqOGy+3EzMsssSC9SbUXR9N27C8dt7bKpwPsm0lXj/BiFvpBNJ++9gsUke0rQgjD1x
         SsyKygTZoLb2nvLxnJ1GrNEHGVE2sEXXj4P9iAwo38RtEJMAQ8Ew13gL2lmlgxq5xT8W
         PMQhryWEU3KlvQ/TkfmfHNhW9BL4//HrE9y2tQgZGYkwcg3kuII7sVqRGL5LsFxJFCoa
         T0CwXehum14shSBbLMPtt0x8YO0z59XurXsmPWWSCGhT1M30n0nRzkYFWnzFUkFPH3Yr
         SS5hhrZ28Ir5uRONWr5i+2ShTFvOTzm2GImGBhms2xhl1vo82deZRyx82o7A9j/wqA3A
         TORw==
X-Gm-Message-State: AOAM532a1PiShAn38ZkIEtVqGb8VRKrrln6vCbl19srjparaubD0VmJK
        S8hgvh0kTR+59HNN2k7wvP5LeQ==
X-Google-Smtp-Source: ABdhPJyFIFyWff/4XKxieWV3eQ9EuPIOL89Y7/k21CNIHkqtlJb6hCFe8Xb9MpbZBVu68hltBO85ew==
X-Received: by 2002:a6b:f714:: with SMTP id k20mr18812501iog.70.1613528582328;
        Tue, 16 Feb 2021 18:23:02 -0800 (PST)
Received: from ?IPv6:2607:f2c0:e56e:28c:5524:727c:ba55:9558? ([2607:f2c0:e56e:28c:5524:727c:ba55:9558])
        by smtp.gmail.com with ESMTPSA id o5sm404700iob.45.2021.02.16.18.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 18:23:01 -0800 (PST)
Message-ID: <6e9842b289ff2c54e528eb89d69a9b4f678c65da.camel@coverfire.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
From:   Dan Siemon <dan@coverfire.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Cc:     andrii@kernel.org, ciara.loftus@intel.com
Date:   Tue, 16 Feb 2021 21:23:00 -0500
In-Reply-To: <8735xxc8pf.fsf@toke.dk>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
         <20210215154638.4627-2-maciej.fijalkowski@intel.com>
         <87eehhcl9x.fsf@toke.dk> <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
         <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
         <8735xxc8pf.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-15 at 22:38 +0100, Toke Høiland-Jørgensen wrote:
> The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff
> to
> libxdp (so the socket stuff in xsk.h). We're adding the existing code
> wholesale, and keeping API compatibility during the move, so all
> that's
> needed is adding -lxdp when compiling. And obviously the existing
> libbpf
> code isn't going anywhere until such a time as there's a general
> backwards compatibility-breaking deprecation in libbpf (which I
> believe
> Andrii is planning to do in an upcoming and as-of-yet unannounced
> v1.0
> release).

I maintain a Rust binding to the AF_XDP parts of libbpf [1][2]. On the
chance that more significant changes can be entertained in the switch
to libxdp... The fact that many required functions like the ring access
functions exist only in xsk.h makes building a binding more difficult
because we need to wrap it with an extra C function [3]. From that
perspective, it would be great if those could move to xsk.c.

[1] - https://github.com/aterlo/afxdp-rs
[2] - https://github.com/alexforster/libbpf-sys
[3] - https://github.com/alexforster/libbpf-sys/blob/master/bindings.c

