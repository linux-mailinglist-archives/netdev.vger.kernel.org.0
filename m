Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D116810A742
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKZXwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:52:50 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:32819 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfKZXwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:52:49 -0500
Received: by mail-lj1-f170.google.com with SMTP id t5so22311594ljk.0
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KCDKvwlIGU7uB8p3D+dFVtLq5oKYjA5PnAgt3uQ6mbE=;
        b=THOUjfrN6LzT765GBQ5xIh14+wyrTtJUiYvZMkyix/jt7Esnm2tzZIiMa2ChCrGN4p
         vr+8MAYPcKKt2JuuOOzr7w1hTQnkTw25droMskEHfczzu+2Zz9HHWuPGynDtN5/ZANgp
         FXgvx1vgyXlnjspL/8mCN3x3J62gmTCSU+Oe0Ui/mX62E1iBo08OspNZ2QUTRV0e+ZUs
         SrxJ6+f1vhbK1MqP3+/vmNHXSM7J+A62NloGcaQWtFCNQGGEZ5rMimKCU7O3P7pU+ovm
         XB8r3pNa6oA5czRKVEWLxRzBUemF3aVvAVrE18kNYSyq94nWbdi7Q1xm/1B8GweqSoSr
         khyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KCDKvwlIGU7uB8p3D+dFVtLq5oKYjA5PnAgt3uQ6mbE=;
        b=dhhnD4caOOxXrNJOhY7ORhGzUl5053AnflQlNkOJ4M98G/lQgeFHz10sR9QD5owFZQ
         Xvbi2ArViZZqJY+BWfCDkPbFPt3dUsvBkb+L3KfTpGnvU7l4gTu/GeiKxArYHbKGn6Pc
         2h3hJIyHg+9x2NazVB3ke5uNHXMoYNooR8nK0S+VXHYOmThfwz8TZLgjNw/X8k/qdjrE
         dwc1g0pnHVJp1yAVbNcd5c+ZERmQ8xh8ojEmT304i3q17l5ULTVQV0Qm/IuYhvh0IJOi
         Fl0KrmIlpLTuy0PN72EEpPZAT4OX0z8n3b292UdzygqJLqgT1mP5ANxFaOYFC21nqFM6
         QzmA==
X-Gm-Message-State: APjAAAXYRsDQH5wZWleMwJLD3Ooy50gS1ox6+XszrlFHKveeJI4W4Eg3
        FR7+k8vAvzkgw0XvrwGgT2qt2Q==
X-Google-Smtp-Source: APXvYqwHWT5lOYRckrAzkgXVDZ5mCpeq9r+Y9BSVNvlu7iS/3DwURAaIoUaBcaA84E1utY0e4FCZ7A==
X-Received: by 2002:a2e:c42:: with SMTP id o2mr14747157ljd.222.1574812365483;
        Tue, 26 Nov 2019 15:52:45 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r1sm6211872ljk.83.2019.11.26.15.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 15:52:45 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:52:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126155228.0e6ed54c@cakuba.netronome.com>
In-Reply-To: <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191126151045.GB19483@kernel.org>
        <20191126154836.GC19483@kernel.org>
        <87imn6y4n9.fsf@toke.dk>
        <20191126183451.GC29071@kernel.org>
        <87d0dexyij.fsf@toke.dk>
        <20191126190450.GD29071@kernel.org>
        <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
        <20191126221018.GA22719@kernel.org>
        <20191126221733.GB22719@kernel.org>
        <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
        <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 15:10:30 -0800, Stanislav Fomichev wrote:
> We are using this script with python2.7, works just fine :-)
> So maybe doing s/python3/python/ is the way to go, whatever
> default python is installed, it should work with that.

That increases the risk someone will make a python2-only change 
and break Python 3.

Python 2 is dead, I'm honestly surprised this needs to be said :)
