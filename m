Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551E93820A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 02:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfFGAKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 20:10:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36924 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfFGAKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 20:10:13 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so358197qtk.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PQ2XAR6hZ/EY+FpEUrzo0/+MJOKvGMZ695YybUBi+EY=;
        b=HiRQ+yygcHxstdNjp+cQvLUkx6aaUQjCRl87yWceOUutMelt+FZe4TlciS1OFslzkH
         4IsoPgvB+a5fu/0YLTyQ0qtsknTDcLk9spS//TtVnP/HuD6nH2nraeDy0Lwg/V/LtRek
         RTVzoGcVkNSqSQVwRxjGATRP2ZWaRw+lrg8CZN5mfbpc0X0gG9d/JsV6QTI0Qxau8ihK
         Vkk9fzYHCSs/urbrNcThyQK7tPMqEbj0PnQPmfTG66kKwgkuJVrb/tYTnw7E4uVgOb06
         HO7FvlQMiyUi/OtPc1GtqJ7/VVEmPBrT1qQoGlUSMnpCelp6ZeEkhfLgkGjXih6ZRCOR
         eCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PQ2XAR6hZ/EY+FpEUrzo0/+MJOKvGMZ695YybUBi+EY=;
        b=Z6lip316co6OMN4pbprBEzG4l7nFqsiTZs3d+DVcGY3tTdU1L1rm7GAENMhd2H5P63
         J5EO4/SUVQxFzBWd/fxtWHPaAVA59HEp2d5mrNKIqwFXkbp7jaegsJ+2rrP7xsukTevD
         paKpTM2AdjalEQ1c37KsemS+IghIneSK4vSCZx0XLDnONJVwtzAepHW6Ci+OLC4BcYLA
         Ei9Rbf6jKBfG+jUfEdnL3ARSERr2g/iIFJt06Exla439jbG/PkuMsVXBTMOPCzZ/9VJv
         hdaL9U+MYSLwTvwJ/RHJt1QaJLVcVEIg9lLlHA63Hk4i+ptKjd5PY2cuTr8Y5JCHwlJp
         URoQ==
X-Gm-Message-State: APjAAAUWs4YWTddQ0sCbCsnjISYG0Y0uouijd3nltWRRYc2aWeqVUfb5
        clpuWaO3UEVSJZCyRmAcuP/Rqg==
X-Google-Smtp-Source: APXvYqxhjp2q6w6Oi0tn04YexkBWRXpa051ZGZGco961wfnrsM592DrMfmE58IV09hSO2jvFbsB2VA==
X-Received: by 2002:aed:3fc3:: with SMTP id w3mr16028620qth.168.1559866212082;
        Thu, 06 Jun 2019 17:10:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v17sm350623qtc.23.2019.06.06.17.10.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 17:10:11 -0700 (PDT)
Date:   Thu, 6 Jun 2019 17:10:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190606171007.1e1eb808@cakuba.netronome.com>
In-Reply-To: <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
        <20190531202132.379386-7-andriin@fb.com>
        <20190531212835.GA31612@mini-arch>
        <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
        <20190603163222.GA14556@mini-arch>
        <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
        <20190604010254.GB14556@mini-arch>
        <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
        <20190604042902.GA2014@mini-arch>
        <20190604134538.GB2014@mini-arch>
        <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
        <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
        <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
        <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 23:27:36 +0000, Alexei Starovoitov wrote:
> On 6/6/19 4:02 PM, Andrii Nakryiko wrote:
> >> struct {
> >>          int type;
> >>          int max_entries;
> >> } my_map __attribute__((map(int,struct my_value))) = {
> >>          .type = BPF_MAP_TYPE_ARRAY,
> >>          .max_entries = 16,
> >> };
> >>
> >> Of course this would need BPF backend support, but at least that approach
> >> would be more C like. Thus this would define types where we can automatically  
> > I guess it's technically possible (not a compiler guru, but I don't
> > see why it wouldn't be possible). But it will require at least two
> > things:
> > 1. Compiler support, obviously, as you mentioned.  
> 
> every time we're doing llvm common change it takes many months.
> Adding BTF took 6 month, though the common changes were trivial.
> Now we're already 1+ month into adding 4 intrinsics to support CO-RE.
> 
> In the past I was very much in favor of extending __attribute__
> with bpf specific stuff. Now not so much.
> __attribute__((map(int,struct my_value))) cannot be done as strings.
> clang has to process the types, create new objects inside debug info.
> It's not clear to me how this modified debug info will be associated
> with the variable my_map.
> So I suspect doing __attribute__ with actual C type inside (())
> will not be possible.
> I think in the future we might still add string based attributes,
> but it's not going to be easy.
> So... Unless somebody in the community who is doing full time llvm work
> will not step in right now and says "I will code the above attr stuff",
> we should not count on such clang+llvm feature.

If nobody has resources to commit to this, perhaps we can just stick 
to BPF_ANNOTATE_KV_PAIR()?

Apologies, but I think I missed the memo on why that's considered 
a hack.  Could someone point me to the relevant discussion?

We could conceivably add BTF-based map_def for other features, and
solve the K/V problem once a clean solution becomes apparent and
tractable?  BPF_ANNOTATE_KV_PAIR() is not great, but we kinda already
have it..

Perhaps I'm not thinking clearly about this and I should stay quiet :)
