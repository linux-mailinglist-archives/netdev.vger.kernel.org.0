Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67EA1B541B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDWFSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbgDWFSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:18:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928EEC03C1AB;
        Wed, 22 Apr 2020 22:18:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o15so2334590pgi.1;
        Wed, 22 Apr 2020 22:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qCBsa1pJlvt7zkIr/3FJFH5RgTV4mszszMc7Yftm9j8=;
        b=ZnsO8fVk0++VtXCgCcGrNVzqJZq0AoklIMWuOpbYiwXhATkktI9CbfqB4yRA0SItP7
         azBW1r6Jb5iyoAiziDIDLIuEYdQ4M97hJ/Sf/rfI92FjaZZ2S/q9tzL2QhP2j7J2egpf
         CbxWrli3xBhkp6H20ZA2qRN7J2jVYTeh4GVyoJ11H2yCZtvohehqoD1QwPvpFLH7Ka4J
         oqowfGJg4MNNxmHVCxWKhClqlf4InXXnWLzk4c3jbHm0H4RQyGW1999uONr1HVCP9F1M
         bnjQ02lVGrC2IUMkYYiiJebH93C7ygcXHo1kP3G/fFgNFcLyRgVNSB52JQ5Qq2oxpqX7
         4hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=qCBsa1pJlvt7zkIr/3FJFH5RgTV4mszszMc7Yftm9j8=;
        b=QF4pwUbLkNhVu+vKs2wqZr9JmqCAYpvfgzViUj5yNNONJtIDaTdP6WaHhgwy7Ixn+X
         T0vPLa5D4Wwz79atWE/WIgvLld4SYjgXTBYlh2h3TLFZteianxkF6DDGejYs5jg7ACSX
         qTXj2k+nQ5kLEDlFIDL3tstwpLLFZzLGZZVi2PJsPeIQyA1Jk8Ax21kHOGW4/kXwpmpJ
         WNCHuQmbrK2foG7R2JFD/oX+onGlQEJ4WIdSwOxop1QeFG80lpjCOR4J9b3L6Rg82D6S
         q4/cQ2twMP5UMclUbatr6uPnlpyjzaCOmYqs/7n1BJFmYFfA2S4thrzSCd375z0lV+Vv
         ntKQ==
X-Gm-Message-State: AGi0Pub1qdT7OAE3l/dwKVH47lXSALGTqpS/ZdVg8nTzSzK+wW5VMbHc
        UusTehVnzXPCeU0K0KkEbv8=
X-Google-Smtp-Source: APiQypLKYZo7sa83+KriCNF74gBjCVlbbw0qbHAGVoV3iMxICiijUV8rmcy6yRTFdCDjoeefv36pdQ==
X-Received: by 2002:a63:2166:: with SMTP id s38mr2306743pgm.369.1587619091150;
        Wed, 22 Apr 2020 22:18:11 -0700 (PDT)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id k10sm1300719pfa.163.2020.04.22.22.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:18:10 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 03N4AMGY001222;
        Thu, 23 Apr 2020 12:10:22 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 03N4AGAg001218;
        Thu, 23 Apr 2020 12:10:16 +0800
Date:   Thu, 23 Apr 2020 12:10:16 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf v2 2/2] bpf, x86_32: Fix clobbering of dst for
 BPF_JSET
Message-ID: <20200423041016.GA1153@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org,
        Brian Gerst <brgerst@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200422173630.8351-1-luke.r.nels@gmail.com>
 <20200422173630.8351-2-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422173630.8351-2-luke.r.nels@gmail.com>
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:36:30AM -0700, Luke Nelson wrote:
> The current JIT clobbers the destination register for BPF_JSET BPF_X
> and BPF_K by using "and" and "or" instructions. This is fine when the
> destination register is a temporary loaded from a register stored on
> the stack but not otherwise.
> 
> This patch fixes the problem (for both BPF_K and BPF_X) by always loading
> the destination register into temporaries since BPF_JSET should not
> modify the destination register.
> 
> This bug may not be currently triggerable as BPF_REG_AX is the only
> register not stored on the stack and the verifier uses it in a limited
> way.
> 
> Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Acked-by: Wang YanQing <udknight@gmail.com>
