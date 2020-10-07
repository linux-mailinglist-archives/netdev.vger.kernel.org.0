Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3928565B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgJGBft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJGBft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 21:35:49 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB03C061755;
        Tue,  6 Oct 2020 18:35:49 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z19so420922lfr.4;
        Tue, 06 Oct 2020 18:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Qmd0ACLwjYf1D9mSjxFoa3PMW5yURO/aGtEzK9O/FE=;
        b=f1IcoXCiwKnZMEBhgBXdSeGnxYTIbgWM6cTphd6i4LiKLNZS10oUGQ8n9BUKEwyy7Y
         3sRHs6weCsFRRQ38DRi+y49oRAg4TjEOdp9PkANaCy33gYXEYXWL4ArgGF9dzqUZ2L5b
         rVP2Bq2Vlpr7r7MNmxjP5NLDaMmd9pXh0Q8elrFCgJ70Ej0XrcqP34ffPNTFTfLdU1JS
         ondtUiaLKkNFhVuTdnty+vjlgYrexNZlapQTBGo6FYlKOrjqEhIQSac2uPSjVw7/3J/D
         O26/3UBSvAKLKQ3VmHIoXFSMKulv613XBg/N9gueKPHjpQE24ayNY3sVy2XnouXKyBdO
         urWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Qmd0ACLwjYf1D9mSjxFoa3PMW5yURO/aGtEzK9O/FE=;
        b=LgC3gXp2j6eH0UR9moHOd7jlxIRe9fGMMFoDsbUtgxCQ7Efq9kR6rEuelFwEFJHP6f
         PtXS51Tp8QUaIsvbRKKghvSLbmLyradaM0FOsKxfPU2J6czn/JjUKLSon3MVYnjgmGyI
         uCzVPm0DplJYYZreRwr1uVi5kWH0X8CDl4doRM8BcA1xIdPW3wcVhI4mLwu6t3DkT/RX
         emBDYIUD4AxnohOvE5GWw2Avkgu/5hRX/TphpU+dblaU0S8RE4hzKSlTgJYUexJ/ECIY
         4zwl8bzP+uKqC+/bwzXTYx79ViP5kfwIHR0amgrfVEoBEGSfHXe6nldcj/LZqRNP/aUV
         v8mw==
X-Gm-Message-State: AOAM532jb71Y1i4rjws6VSRp8QeYbcWswJAZSF+Oi4rrzToanux+YOSG
        XBHNXVTrJrSDgBGUGfIMpQGwlnjq2K5REkiOp00=
X-Google-Smtp-Source: ABdhPJy+WqL4bYN7u35iLAB9ZFIg9lqqxddymROPslFTlxpwPIxbWCfxFMRv3QoPifzCqJEjm1ODfiMDP+SKvrcVwqA=
X-Received: by 2002:a19:df53:: with SMTP id q19mr146495lfj.119.1602034547470;
 Tue, 06 Oct 2020 18:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-4-alexei.starovoitov@gmail.com> <20201006182205.78f436bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006182205.78f436bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Oct 2020 18:35:36 -0700
Message-ID: <CAADnVQKfnr7dtEGN7SnoCt2zZL-4i9ux6ENhpbx-B+-3TMEE9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add profiler test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 6:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  6 Oct 2020 13:09:55 -0700 Alexei Starovoitov wrote:
> > +static ino_t get_inode_from_kernfs(struct kernfs_node* node)
>
> nit: my bot suggests this may be missing an "INLINE" since it's a
>      static function in a header

false positive. it's not a header.
