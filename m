Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9AEE779C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbfJ1Rcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:32:41 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32778 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731917AbfJ1Rck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:32:40 -0400
Received: by mail-lj1-f195.google.com with SMTP id t5so4422035ljk.0;
        Mon, 28 Oct 2019 10:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5FilHHLZDaJVtvWFtCYcCAhZY22iViXiwl01pdpanDE=;
        b=kJOnL1zu00cU6AIB3ANGSLRnVAy0sEtzlfZwc5U5bbJVImX/jG+vkVbdUBSgYC0T4u
         VIJE/KSJV7tBBAafm/erazpEXjcN8b1pxnOg72jB6L8POffrf6lzZ8ZQ9km9+eIM33Y9
         ZohB9ytTFbR52U6tY87VLOreay5IEHgKrksAXUJ7K+7jywptv+eBu1lYqiuPJ/7vW7VS
         5d7kqZ6YmMlEw+xl6ufc8tpfSnPFqgOcc4O+w5bFpB84E8qgt5ansW9U9lSWf9cqBDtB
         UPT+NO01fCztOnpsOX+TMzSRee5jRKkUlu6xMRiE1mgTUe4dZDznhUBXoHOc9q946Hoh
         OBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5FilHHLZDaJVtvWFtCYcCAhZY22iViXiwl01pdpanDE=;
        b=TWnRIBaojtaZtqCG6GS41zr/bDRacnQbjyIl1PLtfCkC9TeVcS5jEvd6i0ONytbWIe
         fDXCGG2o+w5pnxFY8IdWhJlbIaYQCIYyqOS7ynZ4xqHsFcdwj+qFOBiZsamjxsuqCPct
         AHIBRnbzgaYyp1vpMJfJbqeM63xFDQ8bERKWB4V8LMq1pYxumc2E14BqJ+AQOD7u4Qfu
         tVCTJgV/4lLpFZoV3BAAH44c04OuiUSN87XnjjvnIkI4vnqd+iYp4pjqs7jjwxEoulBW
         etzrf1u7taHPaHGJctmLe02OaYWLnxK5N9odRYF+tZp0821GTKUYUrK5xwwMFgTbUHC8
         EsZw==
X-Gm-Message-State: APjAAAWjb44Rq48eDlSyGHDfon2URaQQhyXQGeAlW3Sp58fJ+PAzN4Z/
        zIORZp4YhnYVEq27Pku8ef+KGuusVOW8LBiKCaA=
X-Google-Smtp-Source: APXvYqye0j4NL6Qk0XEscCAsEQWDP5b99dNybQUMq6K1ce8WzT32YvRDIlRYXouK2KRYRbs0v+iwc/0+A6JrgpP4iv8=
X-Received: by 2002:a2e:82cd:: with SMTP id n13mr12472445ljh.2.1572283958241;
 Mon, 28 Oct 2019 10:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959980.48922.12100884213362040360.stgit@toke.dk> <20191028140624.584bcc1e@carbon>
 <87imo9roxf.fsf@toke.dk> <483546c6-14b9-e1f1-b4c1-424d6b8d4ace@fb.com> <20191028171303.3e7e4601@carbon>
In-Reply-To: <20191028171303.3e7e4601@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Oct 2019 10:32:25 -0700
Message-ID: <CAADnVQLoZ4YLNh+xPEvEYTmQjQppXUbTUNyYKxQ-fhn8_2QW8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map pinning
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Anton Protopopov <aspsk2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 9:13 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> LLVM 9.0.0 is still very new:
>  - 19 September 2019: LLVM 9.0.0 is now available
>
> For my XDP-tutorial[1], I cannot required people to have this new llvm
> version.

what's a concern?
It's a released version.
We recommend the latest kernel for new features. Same goes for compiler.
