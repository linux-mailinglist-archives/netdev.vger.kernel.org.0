Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0D13DD9
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfEEGXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:23:23 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35350 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfEEGXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:23:22 -0400
Received: by mail-lf1-f65.google.com with SMTP id j20so7008614lfh.2;
        Sat, 04 May 2019 23:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHPSmeiaEyI+fZI5jnTJrK4KWAfYaHxzzqx2Hh2oJWI=;
        b=gk+gb6/j94zsaoE97skuYE1/Pv9RcbdsI5m6pu5xXsPvE5LSPPl1dKNrzhSjw72k6G
         0oGu7aDUl4sB/2GaJp6Yxfm2XwBdd58mgiah9zFLDSKfHR/TLRPLtvPNoBSKYG/Gv+7x
         MZhOnqlM392DzjhsW2aj/q32LGcwAMOjLRkJgWiv6SOALv6H/EufvmwEK60Kc9OeAnL8
         ZLHi99S73hd3VUTSPCnHQTYqDlMCMlLnA8PSzmGnhUre+nPF/YwOnagmd2kZ1PgLkMPd
         soYIjBGfbsHeGVG1nYs+K87NDDv++1ajoped5vkVcCWNkzhV6T8b1vPXa/i0oWSRGlDn
         dtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VHPSmeiaEyI+fZI5jnTJrK4KWAfYaHxzzqx2Hh2oJWI=;
        b=Q9Yrg+6BgKE5ifDN3YphLoaUZeh7lUKNGe1/Kln+ZrZOy/Zo8y4ikX5s9rDqnnDp8Y
         TGUEiis+3DupCgy4wPdg6UC1l3iboexHVIcJchFBM502Qlh+2oXUugWJWEWc4gKhVL+V
         H+yZnsEv3oJOXd7XFSsCmw5IJlFZD0YrnKSRKGcxF1yqTgvvVQ+DQy9URjItwuK6PeN4
         LZYmDJsuh3/C+l5THD3/tLvl8WiqkdZ7kQKFswb8lh71sRZRr7OKIEQkMivuJY3MTek1
         /xqkbHPZtkSTR4XlCXqv4djmY4Ln2v8VkQ1f7yOQ76/TPnS64OeLVI62ZeKI7lLwd9LB
         xEew==
X-Gm-Message-State: APjAAAU4JxIkzfWJ2XiY6Givw4IDPVDRR7Kl3Sl34tuyV3PdFZjMyc2U
        z5uuTvy90uizwLOenYd0HF1rXbGjTTW34H7D+94=
X-Google-Smtp-Source: APXvYqxmzye1w9ywCiF5Mf9/PUrmPP1RRpHTVk/MlTGKqqXTbd/JZjNEtAN712PgpQ4fDy962zTQC9Ie8bZE5diZCa4=
X-Received: by 2002:a19:8:: with SMTP id 8mr9593361lfa.125.1557037400792; Sat,
 04 May 2019 23:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190429135611.72640-1-yuehaibing@huawei.com> <20190429154017.j5yotcmvtw4fcbuo@kafai-mbp.dhcp.thefacebook.com>
 <20190429154052.7qtxsqex5xure4a3@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190429154052.7qtxsqex5xure4a3@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 May 2019 23:23:08 -0700
Message-ID: <CAADnVQJ+GpPn7g=zv5KdZhdu5=uT4SWT6rGsMn_onFwO7oH=pA@mail.gmail.com>
Subject: Re: [PATCH net-next] bpf: Use PTR_ERR_OR_ZERO in bpf_fd_sk_storage_update_elem()
To:     Martin Lau <kafai@fb.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 8:42 AM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Apr 29, 2019 at 08:40:17AM -0700, Martin KaFai Lau wrote:
> > On Mon, Apr 29, 2019 at 01:56:11PM +0000, YueHaibing wrote:
> > > Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> btw, that should go to the bpf-next branch.

Applied to bpf-next. Thanks!
