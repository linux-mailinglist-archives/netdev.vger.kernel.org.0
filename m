Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C553CB047
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 03:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhGPBMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 21:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhGPBMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 21:12:30 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD55C06175F;
        Thu, 15 Jul 2021 18:09:35 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 22so13134837lfy.12;
        Thu, 15 Jul 2021 18:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qiA9K9BYRFMFkVh2lL/ZFnaKnZXyUJHoqOoWo5044P0=;
        b=OuMOZJUBn4vRQgsMmtX7iWcpnJ4tWPKc0O7D2kJv2srLFh6hzNdd/uvL/2+j85+Aot
         07Kg8wkC4LDOsLRoPAS5Wgk4XBmQFZmRNjDugT7SrsYidYIWbzdWQaXXucQG+0uZqgZ2
         Rmf6oGRE0GFMcsBjP6B+5xxB7NXVf5XHEfw513b8TrdRenDkPRUKF4fR4Lf+K1pUs1Gu
         SwzpFaqbMNlSvJVHoNX6kUHFtp/pqZYuOAeKYL8QsIl7IE0idKPEVL+h9ePJEjq2vn+x
         0kF1UHJwztb7XQvaT0AoRMDGc8jfUlGR333rwhgrugXNhy2Iit34zAfaqtdAGFKA75ev
         JsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qiA9K9BYRFMFkVh2lL/ZFnaKnZXyUJHoqOoWo5044P0=;
        b=UEeQ72zNMsynMw/+9nFqysOnEhxiIHVDVzbr80vz2rHhqRYMbzdBtcpTTsiPcCptPK
         94zPMtsDd8LHmfuzSkiu2U8DwNeKdDqvV+zOgX4/GzZpvDBg1jktlZf2tFJwl3AAyoSQ
         kFwCgeaBmuikBc9x+Gnc672yjLQH9zyxTKgIx6pCzwqIAuq7CdbgjxduxVDV42d61YX6
         zGxiYlUipHczspCUSiysPv0I4Nr0l4OmH5LR+088voFBuVOqIwZE4rQujCaCy2CDL1j4
         HBxMkkXkcS6iLxyWfZXtLnPDGNuJHvDNdjax7KncMWAfbYDBKH/Q14/+Kkjs27VIdpId
         mGhQ==
X-Gm-Message-State: AOAM531x7in+P6HV7ZU4n/RM/Qhr2N3Q4DK0BlZRjir02MTjFmm1s9GE
        n4tkE/1/Yy2M4WoAzLDyBisjzYA2q1PGRqLufHQ=
X-Google-Smtp-Source: ABdhPJyVrGdWbVe7lpVmptSCC9An0HdpUhpk1wOzy4NnrYyptsuZQn+XYGcKlVDhPHVhhKk4J9eN+OXi5ZLmyhkRWNk=
X-Received: by 2002:ac2:5ddb:: with SMTP id x27mr5555891lfq.539.1626397773996;
 Thu, 15 Jul 2021 18:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210714094400.396467-1-jolsa@kernel.org> <20210714094400.396467-4-jolsa@kernel.org>
In-Reply-To: <20210714094400.396467-4-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Jul 2021 18:09:22 -0700
Message-ID: <CAADnVQLjrdv4Vbo+dQJXffMBwuYFCAqc6zxTys3vk4BoyrDHTQ@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 3/8] bpf: Add bpf_get_func_ip helper for
 tracing programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 2:44 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding bpf_get_func_ip helper for BPF_PROG_TYPE_TRACING programs,
> specifically for all trampoline attach types.
>
> The trampoline's caller IP address is stored in (ctx - 8) address.
> so there's no reason to actually call the helper, but rather fixup
> the call instruction and return [ctx - 8] value directly (suggested
> by Alexei).
>
> [fixed has_get_func_ip wrong return type]
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

I removed these tags, since they don't correspond to any real commit in the git.
Otherwise all patches would have been full of such things when patch series
go through iterations. Also fixed a few typos here and there,
manually rebased and applied.
Thanks!
