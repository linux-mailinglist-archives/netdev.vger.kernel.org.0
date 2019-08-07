Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D859185188
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 18:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbfHGQ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 12:57:17 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37950 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388898AbfHGQ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 12:57:16 -0400
Received: by mail-ot1-f68.google.com with SMTP id d17so107147165oth.5
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 09:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPobVsICgDzlbyrPqS0myaeSkzuUxgvPwrQVZVdEXm4=;
        b=kdCaR9Rn/a42cbgN74Lg6l9Ge6z4iXuOlPEZZSOH5wjZPLyv7bgVgswGcVSXAtm4kW
         1rSZwhnMWYjCevNYeWg2a5esK/kgS2Rrm9Yx04qxU1UltDpQj1kfrAD6trVNjXs5srUF
         KGp40hPkKLfPG0nijBCU+u/nea/XpZ4qD8M2/rgiTNdVV5m43QKsoALv+QtOF/AXWGyd
         ImSYeKyknHZeuIB5YFM98dmO2TyGsx30x7saSkZ5Pn+Dkjzlf+vplnEDQdBC98SW910p
         nZnwuiSyd8rG5uUgiyh6sphLgrOPvd/onl7sRdHsn+6G7cttyZ+D0G6h0F5CR2Iz+LR0
         SCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPobVsICgDzlbyrPqS0myaeSkzuUxgvPwrQVZVdEXm4=;
        b=LV7N1FN2b/NJfdWpTT2Mt9E0zdFGa0tQE95HsfXGbXtJtPvUadmHAsFTbri4fo8CrN
         GRo0UPpdDx/BeDIn0HTYplla0Cr6yF5Qv8VPgwpmXEawzWU9MjD9sakQXPTxZDYvF+pg
         W+5tbhoQi4ehhl59Uku7+UcQ7RIwrsAw/LmsFYwKg01vX5SlIWAgkWQWYMXTaUB7BOiS
         ZkeYf9nr3SWIRYA3TTnEY/XpWfobJ0guPAtxHhC1ViEzmhuj/o8Zri/IONZMYrmQYfor
         F1Nyf1bhcy/wXPewSKenIMbf66d9kWA6MAAI1xxNUO7bWe5pJvNhsY6GO82XxNyAtnH3
         KbHg==
X-Gm-Message-State: APjAAAWsV+zOeAz711jxJf5rOJDalFfUKXqV0o9Y0ZGp4GI2WBh4yEWf
        xG+15E2s6fhJ9h0O4L8Eo11zgdrExN5fEoqN0lZQR+GcAFY=
X-Google-Smtp-Source: APXvYqxM0UrMVq4DrA1SX8UOKILo1sIS6b6udHL8totbA6d+Yhuvd9LeaYe5uZ5oxwH29wXChNwwdo5sNy2e2pZz+H4=
X-Received: by 2002:a5e:8704:: with SMTP id y4mr9769250ioj.135.1565197035875;
 Wed, 07 Aug 2019 09:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-2-danieltimlee@gmail.com>
In-Reply-To: <20190807022509.4214-2-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 7 Aug 2019 09:56:39 -0700
Message-ID: <CAH3MdRWkDrLP+GGRnWYNm3B6xFmaA-VEvuKgiO1xoDtoGKHVYw@mail.gmail.com>
Subject: Re: [v3,1/4] tools: bpftool: add net attach command to attach XDP on interface
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 7:25 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> By this commit, using `bpftool net attach`, user can attach XDP prog on
> interface. New type of enum 'net_attach_type' has been made, as stated at
> cover-letter, the meaning of 'attach' is, prog will be attached on interface.
>
> With 'overwrite' option at argument, attached XDP program could be replaced.
> Added new helper 'net_parse_dev' to parse the network device at argument.
>
> BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
