Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF4EA38C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfJ3Sme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:42:34 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:42055 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfJ3Sme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:42:34 -0400
Received: by mail-lj1-f173.google.com with SMTP id a21so3791095ljh.9;
        Wed, 30 Oct 2019 11:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rh+EtXEjOHDAU8+mtSAufN+j9EwhHIvWlAsCi0s66Vw=;
        b=lP3cwpxrKZw/y5ptkbFwA+KKesMo8bJn9sh/zQUd254lPS/qREYf/Su6LEDH3YzgXF
         Z1WKWlsMn1aiddfEf2hUS0F/UIG8imF79+lBUFB5WJx2rGcIx8DImBC37Bj/5hUY41Xr
         ru2oKJxYjZbw3e95ur5SJp7Rd7EvpF0z28kIcA4vJ+KR5rZEjaJdmzN+9l5bR8fD4EhO
         M3bvOt2XiQHCOR9Q1bV+S4d3pUEeFQHm+uueco0gFE/vuDWDOlM5PIvEhv8apOZwmunF
         oK0zNxeb83JMxsIoQ0o68reX+ZHAHtKPN9gmCZR22M09vI4QOePJUtXx4piGuKJ6LHf9
         QCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rh+EtXEjOHDAU8+mtSAufN+j9EwhHIvWlAsCi0s66Vw=;
        b=OfLYCukBqUBUcD3Gwsli7hwpnp0JU/8k4e4b1mswCP34PsCj7EUJV8eeBvSGgba2xN
         pMa4RoFkWyq3XOFCJ+CNLmhf1PnEPwG1zaU+0ofJGjs1K5ZfkAujW2tNNwjqHssjrR2N
         OsUHQ4+UbfSX00zp7YP2JXXcgn1PbQ1X/tarX9VioDHvEHNSLvoILONYFoNID9v3v3Eo
         +rtExEB760jLz1kKXCDmhgSzxDXmoIUxbiUnXUoAjx/QN0ltoigcSMxIv1O7BJ7elzkr
         S3lsyyXprEr11HZBlmHiB1CbQtMYhtJDuZoZUI4YGgeBxdot6IxusxNXDRvSqnCnjQ3A
         A+Gg==
X-Gm-Message-State: APjAAAVdqsrxF56lA/Lud0QToPAnJB7m03DR2toojwTAj5i5jQ4t1AtW
        B9SXygO9z67g6009XfhT6QylQOai7usYkbDIGy8=
X-Google-Smtp-Source: APXvYqwYjAMnMXB70e0ghikRFbh5fgB9EX2Ix++PdjkikKCdPQdSLnPr5wmsRbfbyTw5U0LFPAz42JLHZKhxhUXlgvY=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr825371ljn.188.1572460951802;
 Wed, 30 Oct 2019 11:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191030154323.GJ20826@krava> <CAADnVQKNJ9H9yxxuHn72ikfjii4vciVi8S6ztJ4oJCGk5A3FrA@mail.gmail.com>
 <20191030175735.GL20826@krava>
In-Reply-To: <20191030175735.GL20826@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Oct 2019 11:42:20 -0700
Message-ID: <CAADnVQKA_P2zXDQ=MDL_B14jBTJ6CfVcDomgY6WibZHrQOgoFg@mail.gmail.com>
Subject: Re: [BUG] bpf: oops in kfree_skb test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 10:57 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> it's jited and I'm just running test_progs
> the kerne is latest bpf-next, config is attached

Reproduced it.
I missed the case where jit is on, but bpf_jit_kallsyms is off.
Please use sysctl net.core.bpf_jit_kallsyms=1 as a workaround.
I'll send a fix shortly.
