Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56A42F7A3
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhJOQGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241102AbhJOQGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634313838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsDEKtYCRzpfGHfWuRln3LBcuvT/rlU9WF50B32EWSQ=;
        b=fEkEbC7EaQA4Y8P0a4R5LElv+eCWnWlSBtCVDL9R25cAIjvGlGqpO6iSDwzy99OeppSCYE
        YlnFqngbvn5A0FH06fZ34Pz89Q7lVbvmhxAUtYGM/WY8/iiX68jVkRdq5PJEkIBr3OkKP1
        EG/BlEOdsvZ4e8shxRiPrEiFLIDQOdg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-eC6pzV6YOu2QFNkwZnOdAQ-1; Fri, 15 Oct 2021 12:03:54 -0400
X-MC-Unique: eC6pzV6YOu2QFNkwZnOdAQ-1
Received: by mail-ed1-f72.google.com with SMTP id l22-20020aa7c316000000b003dbbced0731so8669841edq.6
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 09:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dsDEKtYCRzpfGHfWuRln3LBcuvT/rlU9WF50B32EWSQ=;
        b=DMcOYiRhjwKv4cWqRMlJKuDfMVn8SS5SFHwNB2VObGKyvbZzK8fDnNEP05UwtOPDQp
         oKiKf6pRWO3ZWy1df7sTGAwX+dBNELwo0zKdIfn8ipq6C8Hx4GurOtNlGKV11b9ymklr
         Zio2VxT9gSvT1qZnknzYcsE/r4Smb4HWVPeElgGbSBHe/1IGOIHVQ+9GmwaycX5zeSM8
         qkbAqL09rUyQsIRMp8yxr/fIOqpCx04hFAk443wencxJ2xv8vOjtkVPrRtKjtR2rHwBX
         GDUuxbLiNjcwc9ORpPwQE3MpZNizLiOrOWnmuCmuMrG7O1Z/GnJnFFIT9WOG0fQ9iROl
         Zv/Q==
X-Gm-Message-State: AOAM532jV4OPSHw/Wns6bsf3oGx1iHLHfZ29rHub7MnWM5+/27CdhgCE
        i697NDjhDGgFE8HJCfsfPWiJVfR8jn3xobFplTq2IqMbponwfIwDaS4GUVwCkjlonKhgbr+IfRw
        quRUAmwm4ACVPv8H+
X-Received: by 2002:a17:906:a382:: with SMTP id k2mr7572517ejz.454.1634313831268;
        Fri, 15 Oct 2021 09:03:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVpl3COZZa10m9FGGCOulI/IilZO1BZ1AmzpG9vXvqWXM/Vr6tYrv3GMPd7axLellHTaPsIw==
X-Received: by 2002:a17:906:a382:: with SMTP id k2mr7572303ejz.454.1634313829001;
        Fri, 15 Oct 2021 09:03:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i21sm4370071eja.50.2021.10.15.09.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:03:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DDB3218025F; Fri, 15 Oct 2021 18:03:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v16 bpf-next 09/20] bpf: introduce BPF_F_XDP_MB flag in
 prog_flags loading the ebpf program
In-Reply-To: <YWmCLlLelmG2ElyV@lore-desk>
References: <cover.1634301224.git.lorenzo@kernel.org>
 <0a48666cfb23d1ceef8d529506e7ad2da90079de.1634301224.git.lorenzo@kernel.org>
 <87y26uzalk.fsf@toke.dk> <YWmCLlLelmG2ElyV@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Oct 2021 18:03:47 +0200
Message-ID: <87lf2uz34s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > Introduce BPF_F_XDP_MB and the related field in bpf_prog_aux in order to
>> > notify the driver the loaded program support xdp multi-buffer.
>> 
>> We should also add some restrictions in the BPF core. In particular,
>> tail call, cpumap and devmap maps should not be able to mix multi-buf
>> and non-multibuf programs.
>
> ack. How can we detect if a cpumap or a devmap is running in XDP multi-buff
> mode in order to reject loading the legacy XDP program?

I was hoping we could copy the same mechanism that tail call maps to
ensure that callers and callees are the same type. And amend that to
also consider the xdp_mb flag while we're at it :)

> Should we just discard the XDP multi-buff in this case?

If I'm right in the above, we won't have to because the verifier can
ensure that the program types match...

-Toke

