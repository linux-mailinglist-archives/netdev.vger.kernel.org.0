Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B509FD1FC2
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfJJEof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:44:35 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39659 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:44:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so4738335ljj.6;
        Wed, 09 Oct 2019 21:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYL/vhjaettocWfI6FgrAIp8NvvIMnfMgf12bL9nDCs=;
        b=ubEuBbUiIh6dvphiX1VfSCpeHxN5EjJ2fWKEbuGUkfnWNMPD7MBEYnGMccqq6R8CcO
         PcqWWllR3D5Y8RFXV3X2nShhIsN88v1Yult5/7GHvKR24EqUYlSM5btMaccwi7sp8QGj
         W6Rxu1ZF8aY6Qgb4mwW7TtTL/Os4AwizQ/ivP54hhvaA1bCq6Kh3vv+3GLI4fN/RVGB5
         asIn5BQ5WDjdS+j3m94EksbFTElkaftLge+B3NlGLU8w90OkUhglmD1gAYDbDQqHVH4Q
         3mhobPzSbfaU9TcCDZ08/aPbZHCkSOJ0FQr3+CLfnMs10DgQRu2jzcBi+Dlvp04Or0+n
         aGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYL/vhjaettocWfI6FgrAIp8NvvIMnfMgf12bL9nDCs=;
        b=Z2CTNRxyrO+brLI6GJL0/HcT2w6X0uRQTYxYimzk9RCPNQfy37hDZolnr8NhbD2Bq7
         6HiIcEk1mA2G/jKE07rEdq5j5d3RgkKOwIiMKV7bDzbkQs+7kot4M3OfqtXb/F0NBokY
         lVLLkueQylEtF7T8D/3x5J4HLvsMmWKTjxmFIDRcSMMTRe2AsFB/yHFv4wjCN+7bmDbZ
         vdYeD8BnrauZ46vfDaCLlha76cPKjJqZ3JHoUbwAra+LzsN08PnnvI1T7kwl0ZEboHI/
         8RhU3JxzCpkpe1ldSko/f9FiYra4HCmJq+hdNpZrI50uArXuoRAmXEYnJyJ8/L/z0IBh
         WC6g==
X-Gm-Message-State: APjAAAVLexI7pZ6YLJO+bgZdbSoZPKL7iwK7eqqPEN8huaDlgGnjMkOq
        w6mi0pibsGcLwUcsT0HkqGItVqyun/ftSYES5SA=
X-Google-Smtp-Source: APXvYqxeeLuDlOXPRc9Lqcn0TRRuTodxgOi8ejKTQmsDImpnKJXCUZhA15SGnwH7G6WA9LuYvJK4yQwy0I5Gx92g8xA=
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr4722720ljc.10.1570682672295;
 Wed, 09 Oct 2019 21:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191010042534.290562-1-andriin@fb.com>
In-Reply-To: <20191010042534.290562-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 21:44:20 -0700
Message-ID: <CAADnVQL3NLU1ba0jfwpT-Eshak0vKsnbYWA8EEnB-OToukbeCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] scripts/bpf: fix xdp_md forward declaration typo
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:25 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix typo in struct xpd_md, generated from bpf_helpers_doc.py, which is
> causing compilation warnings for programs using bpf_helpers.h
>
> Fixes: 7a387bed47f7 ("scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
