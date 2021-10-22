Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F4436EDC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhJVAgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 20:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVAgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 20:36:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E68C061764;
        Thu, 21 Oct 2021 17:34:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v20so1560122plo.7;
        Thu, 21 Oct 2021 17:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqPz9UwGOL2oABwNBSlqj+l8EL/eOZPQBNaJklwRa/Y=;
        b=Zj0bq3XMN9csha0L+Lyafo/XEJ+3FzTLi3q+OsMfh7ovp6D6xpKprFvgJ6AhxAYB6V
         QzsJkBx1VcJlr0mlDLn1mrxYWJgSktoIDVmH4+6kd9Kz2RmZ4fAWozhOGT0Hvw+Bo7em
         OVOAJjObWPnhKZ1fDZSpKMKrbqBdBQRN584mwECQSGM/WoYcmCI6L+ESc/Db1HkQE2ct
         yVFai21IBH7g4MW3eNDC//ZQTCDHAjJEzBR6PQ+MdsxnyIyXJZhj5MmggOKnIQnRSKFD
         /KQq5KspfnS4XuUZZsCy9cTLp5JhfEfvTjOxtaGHVGXKLVZgeJIBYTnMhM5AoLZawNmP
         SKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqPz9UwGOL2oABwNBSlqj+l8EL/eOZPQBNaJklwRa/Y=;
        b=BnA5Qeq8POWQeqSqLDJP/+4PAKbJvy2k/Ir7INwQ72/Cq4X3Y8IFIqDGsjkNgA391b
         i/Yv7HbgpDNmIYWcOeNaBIFTnQnmzImLObxc2jxB8br5GbAC7TLl8i/gjV0oucX566VI
         IxFrjUlfsBn4NVPcCJoa5O3DmbA3cBnPO0mU0tVDvDjV5QmVhGi/7Lwogwd6rNUdPGNF
         bZvTh5smzlg6wQKsHLOJogVT7eIv67CsB3coDWAQcObdzLmBhrNkBhkrmvQC00RWlGe9
         jyOx1Ozrm6ncMwVwIaOXjJvz48Xp26K3viCCJLum+IHCwFUMq5C12wiNYXOVng/VNOE+
         D+sg==
X-Gm-Message-State: AOAM532FicRn1aB9TKj6XyUm9VJ1UNsvuZI6W4JGl7UShV9ehaSDkM65
        hB+2E8xeLBjRfoD+t2g57Q4mIlDl7rLALai7pyY=
X-Google-Smtp-Source: ABdhPJyF09dUixHxh34wDIUzRjS++Vw65D3ix9lvCpIigyHgvAy1i8yfNHIW2r9EiP+fEA0krl9HUx7aOUa8H1lASG0=
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr10296860pjb.62.1634862876489;
 Thu, 21 Oct 2021 17:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211021151528.116818-1-lmb@cloudflare.com> <20211021151528.116818-2-lmb@cloudflare.com>
In-Reply-To: <20211021151528.116818-2-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Oct 2021 17:34:25 -0700
Message-ID: <CAADnVQLuhuAHe1e0gBZQTDynys5pXwWbp0BOZ6o6+J7a8gun9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] libfs: support RENAME_EXCHANGE in simple_rename()
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 8:16 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
> This affects binderfs, ramfs, hubetlbfs and bpffs. There isn't much
> to do except update the various *time fields.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Al,

could you please Ack this patch so we can route the whole set through
bpf-next tree?
