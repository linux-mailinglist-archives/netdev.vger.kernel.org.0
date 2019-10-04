Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1734CC667
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbfJDXSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:18:51 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42129 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbfJDXSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:18:51 -0400
Received: by mail-qt1-f195.google.com with SMTP id w14so10818876qto.9
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1+eAwPd7FbcDM7p9NcQuldxH/whjSXNbTrEgndrkW+8=;
        b=mfQQR1HvxQplYK3NjqdnlZhOPW36X09DhYrSg0IFUK4TVl0W4e1i6D7gGSvAlAZ04n
         vlFGSzYWB0Mck7sq8a07nLeYnQj1iKkFI3gFtf8UcvuINWsIOaRzGIk5OBkHi0B43Nng
         qudCD328GB980aoUqZ0bveVqXwUwZZAwJpDQk+IdTkHBApirpRIhwhtx4lRXOWL5NxaE
         o7kPuGv2rpZJ73bYwjWaMj812+lc2CxxuyHIgFxqQRBiQJvaPSJPm4KVsGiYyk9oNmZN
         +uGWuzvjCiyG2nPs6176MCx1DzoU4bYXarqljj9kHXbze33bXAV5727loDiVAHTZnaXQ
         ZgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1+eAwPd7FbcDM7p9NcQuldxH/whjSXNbTrEgndrkW+8=;
        b=ubPd+oF98E+si1d/+VH5AqwaI1Lzgy3XUrDz+8BbvPu6y/yVneM1FR0jnKpo3tRPU3
         bEsepHLNZBXxmAEwE5sWQkMZyLKABqTgyEgi87FVQQZLtalecwLCEVIckWWpZGWJ8WtT
         6GFNAJ85ch2+Gg3pUBvdFpldXhqmVKP2Jqhw46jPlb0a0GDM9SYdU556OiSiunlUmCqv
         BgSuEGfuKspesu41KyUMPFKV0ON2qnpIa3gIhhDo+xSVClkPD58TmfmOICv6UbKYPXY/
         5dNJleExKQ3kZWKAhCOP5ah6IWiaKZ/FFydKv9EdEn/wSprvQYS4uFXyZ+Ffw/h0pMT5
         Gkcw==
X-Gm-Message-State: APjAAAVgwh9UzWpu+750wRb7tOuHYtOI4VP4vFFTbIiSfSuFQjf7ve9n
        qJ8MG1e4VWc/F9ZdTVy3Pk8NAg==
X-Google-Smtp-Source: APXvYqx3N3dR5GjGvLpnLM0HmSXF87zCtn+iZ3C6Vc3xXzCXllaR/Cq7cf/pAWqdiRXNdb+98Prz6g==
X-Received: by 2002:ac8:7a8d:: with SMTP id x13mr18680391qtr.155.1570231128895;
        Fri, 04 Oct 2019 16:18:48 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p53sm3843047qtk.23.2019.10.04.16.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:18:48 -0700 (PDT)
Date:   Fri, 4 Oct 2019 16:18:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/5] bpf: Add support for setting chain call
 sequence for programs
Message-ID: <20191004161842.617b8bd8@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <157020976257.1824887.7683650534515359703.stgit@alrua-x1>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
        <157020976257.1824887.7683650534515359703.stgit@alrua-x1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Oct 2019 19:22:42 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> From: Alan Maguire <alan.maguire@oracle.com>
>=20
> This adds support for setting and deleting bpf chain call programs through
> a couple of new commands in the bpf() syscall. The CHAIN_ADD and CHAIN_DEL
> commands take two eBPF program fds and a return code, and install the
> 'next' program to be chain called after the 'prev' program if that program
> returns 'retcode'. A retcode of -1 means "wildcard", so that the program
> will be executed regardless of the previous program's return code.
>=20
>=20
> The syscall command names are based on Alexei's prog_chain example[0],
> which Alan helpfully rebased on current bpf-next. However, the logic and
> program storage is obviously adapted to the execution logic in the previo=
us
> commit.
>=20
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=
=3Dprog_chain&id=3Df54f45d00f91e083f6aec2abe35b6f0be52ae85b&context=3D15
>=20
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

It'd be good to explain why not just allocate a full prog array (or=20
in fact get one from the user), instead of having a hidden one which
requires new command to interact with?
