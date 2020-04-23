Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64AE1B59DF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgDWLBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 07:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgDWLBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 07:01:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00759C035494
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 04:01:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g13so6313102wrb.8
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 04:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdAYJpgamiKkFDxMsOlJ4ClvDdOXRNcnn7G+BoWX0ec=;
        b=b2hVJG9Zf5j252DOwhbibdx7+8fvIHf/BvX05q39q+/FS6INrjwfwJlJx1HGS8mu17
         x+Jf/JjbZKXtdels/WfjceEFN3CDKcULe5W+tXVCvU04bEUpBAEpVGHwkjth+TVeBu3t
         miiMoQf2ux5ZjLH+8e4IfZyIK5YHpJfMaIEU19I99ZGlpuLuM/yoFiCFuugX/+Wc9SHJ
         Ey1Sgn32PGrhaWlB7+VRkQfr8JUmZGUCpjQCmq880XWJPHNmQ/LHg4Wa2CKcVF2CXts/
         Dod2B+eWH89/jtMFKb0gQwdC6xvX9ZB46gS5xTlZocl8esi/CKMpFICrhX5tHDLkaWsW
         Qw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdAYJpgamiKkFDxMsOlJ4ClvDdOXRNcnn7G+BoWX0ec=;
        b=qHzS6N0q4mGJjyVLgNKOyb2NyVoT+wZfTJveKAcek2iF/IvyY4cz0FxEDZpt95+dCd
         f3lWXMzljmf35G+kE/6atIbWeCZAuSymJhlg4QYyg/O6viKdvMP6rjHRDnzEce2cjqOR
         gqHsFQlUhpPXwaHnxSACF9Do++7Skaxspl4MWi/S1/Yri9fZWflhQBCfG56wshHMrj1j
         zf3hClH4lJ3D9uWNfaTMNXFcc9R9QMbcbOUiKUvpNZ1/EskOkiZHQJx4E+BMgEqlPoEv
         Ge8qIcr4EjXpligLAjwpOAS7mlXdLZo9Z+hOB4QUvJRlTfmxrjA4ZCUWuZWZLdswQrwT
         xEmg==
X-Gm-Message-State: AGi0PubSAcK8oJCtBOuJRw26TUXSlkPxCv2GmKcMi264om8c5H8lLxZ5
        oOQrf+2HS4TkQxY4ZaTSUAxyF7wLZptx0qPZgDc=
X-Google-Smtp-Source: APiQypJWsfKM1S3RcAMUx6jneP3olKArjpdMAtLAYPhivxB6BgcxXN5tgCN2KkGOiTDDyptsKiRKk1v+HkzYemf8n70=
X-Received: by 2002:adf:fc43:: with SMTP id e3mr4130322wrs.234.1587639675773;
 Thu, 23 Apr 2020 04:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan> <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com> <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com> <20200217130255.06644553@hermes.lan>
 <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
 <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com> <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com>
In-Reply-To: <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Apr 2020 19:06:11 +0800
Message-ID: <CADvbK_d-DR2GiptuC1tPqzw6zTDzcf340E_GN+DyhACMRQ_g=A@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Stephen,

any update?

This is your last reply:

"""
1. The parse and print functions should have the same formats.
I.e. if you take the output and do a little massaging of the ifindex
it should be accepted as an input set of parameters.

2. As much as possible, the JSON and non-JSON output should be similar.
If non-JSON prints in hex, then JSON should display hex and vice/versa.
"""

Do you still hope to change things like that (just note it won't be
consistent with:)

6217917a tc: m_tunnel_key: Add tunnel option support to act_tunnel_key
56155d4d tc: f_flower: add geneve option match support to flower

or go with the current set? I'm now okay to do either of them.

Thanks.

On Mon, Apr 20, 2020 at 6:28 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/19/20 2:39 AM, Xin Long wrote:
> > This patchset is in "deferred" status for a long time.
> > What should we do about this one?
> > should I improve something then repost or the lastest one will be fine.
>
> I am fine with this set as is; Stephen had some concerns.
