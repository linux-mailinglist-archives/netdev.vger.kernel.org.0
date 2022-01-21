Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036034967CA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 23:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiAUWVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 17:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiAUWVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 17:21:50 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1267C06173B;
        Fri, 21 Jan 2022 14:21:49 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i65so10078126pfc.9;
        Fri, 21 Jan 2022 14:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xw0b9CJGqcLR6a5SU4O5VDbRdOZ+LXt9/UsdNedJ0i8=;
        b=cuKdSuoaP65guxlKLN4z/RbGWLJ6qSsQYZBl3XRZSLtCwaQbal0RRI7oOcuT7Jg6s2
         gdrwOh+c11wz5EixODfV25pvPUCfdbSWuPQ7bohV/Mo+l/mt5F7WBAl3koAM75eU5JLY
         MSPqIC1jNbnB2N690By3kyHjW2x6BC6ImnwcYj/zejCBpP/STNInrTwswnPZD2lYCy1V
         KR8nsAlN+H/pz7xyfRQnOemqqOtQ/CVZcL/cgZLYrU/5rJZSl8dIRlD+C2Ycze4nBdVm
         5ThlWqKbLTjH66YO5sF24MTfF/O6sN3emXeBi4lSv0vyGy+piByxG+Ih3VuYmWrgP4Ma
         rYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xw0b9CJGqcLR6a5SU4O5VDbRdOZ+LXt9/UsdNedJ0i8=;
        b=DLCO8vUR7JDzhbBfydq2ak6cs3b7EpWzfJqmtBOn9caPo6Jte66wJ5twvHw+mDR7l1
         UkUkuwFMD2pYU5miweg5aDGqdMvTTdryCztGJAoxhebPzyk7Vt+PjSuJN2VkzHC2jePO
         Ghn4lYdOHKMmDb7tDrD8gnVcoBS/0+z3nM+eOkTWnG1I2urzsM3/loEnIfowQ5uq3u/C
         qo8ijMrLFmKK4qnKFzr7EWgDAzdmLjNOWXVnbwyZknR8g1LwUTIiMVqyvD+CzuobWgAj
         7fzvcw7+zHR5xHkRbqwR19nmVjLZPRvELBVMMyJ1le2ToPdb//4XroRIRsdMHEK5+1ty
         +Byw==
X-Gm-Message-State: AOAM531RN45WKP4UYZig6wTiLjTOn5Bm0bHozJ8G/wkY7NQDLSFJ8caV
        g9mZTnI49Conba1fNOnbplyFzt3pQiCz/+fA/Hs=
X-Google-Smtp-Source: ABdhPJxO3WrseUNQwdMdFTK3Xykdv53c//0J5Vmy9ZkWG7q2wCfvHg3q+2FmUCa+hxW6ajYuiNhAhtulIhwpKHqMcM0=
X-Received: by 2002:a63:8242:: with SMTP id w63mr3010780pgd.95.1642803709258;
 Fri, 21 Jan 2022 14:21:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1642758637.git.lorenzo@kernel.org>
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 14:21:38 -0800
Message-ID: <CAADnVQKoNag5tKRKm9oGR8j3qXv0nSW3eUXJtCtqxrCd9Q7Cew@mail.gmail.com>
Subject: Re: [PATCH v23 bpf-next 00/23] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 2:10 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> This series introduces XDP frags support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
...
> Changes since v22:
> - remove leftover CHECK macro usage
> - reintroduce SEC_XDP_FRAGS flag in sec_def_flags
> - rename xdp multi_frags in xdp frags
> - do not report xdp_frags support in fdinfo

Twenty third time's the charm.
Applied.
