Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A419AF3B2D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfKGWPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:15:43 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43233 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKGWPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:15:40 -0500
Received: by mail-lj1-f193.google.com with SMTP id y23so4003627ljh.10;
        Thu, 07 Nov 2019 14:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KY7Z+sOodr+2KOHKXYf+CwTpGGVKcuoYXDhk0O6CUkg=;
        b=gPj6oH49fNmAp7ZjJAQpCcXZM2cA09SNQfL1kwwv+1lHiZrT7/t+UsC6fhXONpDQP7
         f4pqtiNlnthGcwNjimsuE6SSBT2brFC4QAuZZKmmqiD5B2b58txfzaLzZIIHCTrg5iqR
         Ezduf2jw2Oh2y9+S7tzFH/w81AvIcMfoMPk7NK1hpQRYUlMeHhvU5kPc/Jxp7xZZakfE
         g3Zz3woS+iOi9pW8s0rS0HQC0ocvYPQw0lX6O7VI94YohRBny+rFXfK1mZja+BALD4RO
         VCG2XbISUa4O0u11LA04lvmF40KI9vhs64jv+Ry2oPmOHdvb+gR5BaknpTS+F1tDwJTq
         IC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KY7Z+sOodr+2KOHKXYf+CwTpGGVKcuoYXDhk0O6CUkg=;
        b=HKkaHgd065iNtzAeLYgKjfMtxSxRsCU6bUM14XNai7kKGaxRn2lSdm0rwaHagfZpUp
         v8nDaTIuhhqq/kezKzxYKsLTT2JsOQpZFZC9vWWnnNHfdNuuXFC4H6jY87DbsE0oUgTU
         6ZuVTVDpYLhtsD3fxpPA8xtJee1DftYkm1WM8r2GG0vXGA/xWv5wmGFpReccJpvNGzlr
         tamgJiyoH2X9hLUkvHMGZfxsQiQQEoKM3zCPWkEYbAZfobY+jPUrcpRdeFUEvDB+v8XY
         Cq/Qyu6ejgBOPuOPEXbfNCxaI0g4aC5nm8zT5HGLrTA/pDiaqNk4ZZJWjhrJGqmiVzVG
         ITHA==
X-Gm-Message-State: APjAAAWLwf48wbnXLuhz47ViyMPD5nutE/ukCNftwbQN6E/s+N1wfOb/
        q+ho1iwfOGi8mnIjFnZ0y/CQN7IV1s+Z0Er7Q7g=
X-Google-Smtp-Source: APXvYqzX3v325Q+srYy0kQuWYDjoduKbKL8e1hpTu7trNVi8tzAZ30sfbCrx8N3xEky5VV9KGsMfsW5azI0CidLMvKI=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr4312559lji.142.1573164937970;
 Thu, 07 Nov 2019 14:15:37 -0800 (PST)
MIME-Version: 1.0
References: <20191107180901.4097452-1-kafai@fb.com>
In-Reply-To: <20191107180901.4097452-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Nov 2019 14:15:26 -0800
Message-ID: <CAADnVQKYowv2Nynt98qBffnQca3Ro5AHyGCTP244kLP+m2sGOw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/2] Add array support to btf_struct_access
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:09 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series adds array support to btf_struct_access().
> Please see individual patch for details.
>
> v4:
> - Avoid removing a useful comment from btf_struct_access()
> - Add comments to clarify the "mtrue_end" naming and
>   how it may not always correspond to mtype/msize/moff.

Applied. Thanks
