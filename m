Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A04A1DD5CC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgEUSOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgEUSOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:14:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DDCC061A0E;
        Thu, 21 May 2020 11:14:40 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q2so9410403ljm.10;
        Thu, 21 May 2020 11:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vLy+sx+oAPc7Ja7vaMG7FVwptnedVW1W80n6Fglj54=;
        b=JbzOnF5MezQA32NFHdcvalEHBU6t6vFpbGEGNV+6pWn+CV/UNgU4Hrq5pWWRUvk9GE
         nsbC4VrCUIf5MDbeJ8rlVmC9l4ElCb8MxVNl3lDLoKdFtq0svtlpJzA6R9nl3H0w5gZ5
         31Rxs+ktfLPG+YVZAteE1B5dV436UEWEQ17hojebX7nzmvt+iQWVJcfekYNpToZovLEc
         oiKluEAySzWfSlqBxB20L3wFQWzeRvLCCK9xfxPmUrVW+FiIXOAo+DG6s+uxdDvF2T3a
         7xW7wTKD16Om5WWSqkV/lOlqvO+FhPbgGNBtoTqStlL2Td93CpncUhi06aSMY3TVK3Yx
         GbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vLy+sx+oAPc7Ja7vaMG7FVwptnedVW1W80n6Fglj54=;
        b=ae6bqrdXLW6Wl4gbMFmJgFdOIlK8LxecdCakuQCIQJZxqoXIk/5KVjCUcDx4F5mZ/+
         jBf0+jCDVTmjVXLL6P9qoQDGdq7WyDYmH428G4symUYZkvBcMzAOoDGgmFHdaUDVuyxu
         5LCM8IsCxWe43cVBCiRDwafcpAcisvSwuolbrtm/y9M6viO8btxYvgJRQyfEyCWUczXB
         ENbngIwX0LjfvlmNlYkQZUDWtXddVSEG+XHlBj+utTJPD3kLAxFEDYN+3tR+d2KIJad2
         jkzBaDx3ZsiR7BE1BE4a5SzaXGCUQxum1pkf5SKCNSFYbjmwxXEbyRV3quKjJ9iw+/PS
         2VPQ==
X-Gm-Message-State: AOAM530kJdowC7zfCa8vOnzsxzQ1pE1cwgv0SxBdsSMyy7nFPhMyV0zt
        mKoVWhCVlGzD/eLYQYWMOpt2DryjzT9szIxN88dkJg==
X-Google-Smtp-Source: ABdhPJw474zeMwSEONV3S9BYNqdgoywLW8609QV6HtK4Y7FMsNVrvX+9UD+b6YEZcX3E0+OahC4YrZ10ztRhwKiFo4I=
X-Received: by 2002:a2e:9549:: with SMTP id t9mr5857291ljh.283.1590084879084;
 Thu, 21 May 2020 11:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200521083435.560256-1-jakub@cloudflare.com> <20200521152111.GB49942@google.com>
In-Reply-To: <20200521152111.GB49942@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 May 2020 11:14:27 -0700
Message-ID: <CAADnVQ+QfQPZSH=tJ132vFUOC7uL805Q0FUonPgbuzm8oTwuPA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] flow_dissector: Drop BPF flow dissector prog ref
 on netns cleanup
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 8:21 AM <sdf@google.com> wrote:
>
> On 05/21, Jakub Sitnicki wrote:
> > When attaching a flow dissector program to a network namespace with
> > bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.
>
> > If netns gets destroyed while a flow dissector is still attached, and
> > there
> > are no other references to the prog, we leak the reference and the program
> > remains loaded.
>
> > Leak can be reproduced by running flow dissector tests from selftests/bpf:
>
> >    # bpftool prog list
> >    # ./test_flow_dissector.sh
> >    ...
> >    selftests: test_flow_dissector [PASS]
> >    # bpftool prog list
> >    4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
> >            loaded_at 2020-05-20T18:50:53+0200  uid 0
> >            xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
> >            btf_id 4
> >    #
>
> > Fix it by detaching the flow dissector program when netns is going away.
>
> > Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
