Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1736CCE1E
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 05:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfJFD6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 23:58:25 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43448 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJFD6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 23:58:25 -0400
Received: by mail-io1-f68.google.com with SMTP id v2so21696935iob.10;
        Sat, 05 Oct 2019 20:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=g6CGhYPLHlKw2ei8uHS7gUKm9DoPrNeYbpBopoEfuPI=;
        b=l5WjTT5rosdP5GUt4FETaygO98SEkaEc0Ooj5OqoPJ6/gdOjN74QreHSyNa2i0vpmI
         EoU+wX9dHqVRp/78wHh/RxSdlxSKEwJIOMzpxfJnRlkK+EWTg/w+hN9WJL+opeIaIQ/o
         ZJKl6TZSI0lNR/qsFfDzXMvfLAUyrD/jgy0aFUA0+O+C85LRf81WAlXjxCuKolmFzthc
         Z3T2ZitTMacm/Ro1YJcoM2pdVJTOraZRgMF/PM2jY6wUE0IDc67k59FqiZTXAUoyFBTe
         cF2Bi11cV4fIlfkk+DCs0aCWQVKlMfuCOSd1yCsN+pJNqnLMWOT9SacYboYY8I4TIpZI
         zo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=g6CGhYPLHlKw2ei8uHS7gUKm9DoPrNeYbpBopoEfuPI=;
        b=louIN5KzciN5yS/1xvpnPrfffXpWTF+UIh2Fs531qAXpm2L8hMq2rZkFr/qQE5670G
         OWs1VdSvDa+f8fFrAUPCMsrkaIbbFNySMFNfvsrBCeUu/VAnmK8zEUvp13nGYhLVxH8r
         vusIvXalRxAkqr6U/zTSATps6gp2bAsZMAX3cNARoNiB5tF/7OFf5y1kuND4Zo8suKDH
         QvmeSEhXf6MvjwoxA0mVz+RY0sBL09mUlM0Cn30ptBPtlqn37sF1geD8TBURVmRN+GAp
         xdCNmQ7nrfDrB46Zv7yn8kqJF8dFJvUq0nYtSGQBFkwIz8GWowoC2ehwOulJ/X6Pyvuf
         vZ1Q==
X-Gm-Message-State: APjAAAVjB2m/JklDUZV6ltTjsmICgPMukIjFSEBO1KZGBakZVvsAy76S
        ZkH7CT5jF8z66weVI/2ROOafSBpyCpY=
X-Google-Smtp-Source: APXvYqxBf62pdkm5A6zJDyVOuGjMPLXTzwS6J2UyWCfXOoU38vB6AAStj41NR2N5r+GheV8Sl+WCDA==
X-Received: by 2002:a92:351b:: with SMTP id c27mr25265751ila.170.1570334304546;
        Sat, 05 Oct 2019 20:58:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n17sm3501926iog.11.2019.10.05.20.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 20:58:23 -0700 (PDT)
Date:   Sat, 05 Oct 2019 20:58:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5d99665856968_41932aacfa49e5b883@john-XPS-13-9370.notmuch>
In-Reply-To: <20191005050314.1114330-2-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-2-ast@kernel.org>
Subject: RE: [PATCH bpf-next 01/10] bpf: add typecast to raw_tracepoints to
 help BTF generation
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> When pahole converts dwarf to btf it emits only used types.
> Wrap existing __bpf_trace_##template() function into
> btf_trace_##template typedef and use it in type cast to
> make gcc emits this type into dwarf. Then pahole will convert it to btf.
> The "btf_trace_" prefix will be used to identify BTF enabled raw tracepoints.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

FWIW I also have some cases where pahole gets padding wrong when
converting dwarf to btf on older kernels. I'll try to get some
more details and fix or get useful bug reports out next week.
For now I work around them with some code on my side but can
confuse tracing programs.

Acked-by: John Fastabend <john.fastabend@gmail.com>
