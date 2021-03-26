Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5915349E0A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCZAgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCZAgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:36:01 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E85C06174A;
        Thu, 25 Mar 2021 17:36:00 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n21so3757673ioa.7;
        Thu, 25 Mar 2021 17:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MW5bc1IRD2u4VCza1XeO7tBGGQWzWdmkL/Cr6C6JDlc=;
        b=qrNsAfm7umny8JLtEEOjpwa14N6C0owtUy45wAbPq5yhHOT4zt4hzjZLwlUx0Z+Ow5
         6B9xN6WSqv49nLJDIahuqHZdItSZ91sSNZ+qeKxZC7T/LE1ze6jmMEXsz9T2iZo0IXJe
         en6JsrXalqvMRJKJcE1u86Aqf4lBRJJ4hCpm1HpHxvobe6kQgF6fD4zUPloWgsoZx4Qp
         6ZIoDphn98u+m1wc2iZtbAH0Nxhvc/BP0ryY5qAEAZT/eWozkWQA9u0fUPPV29BEREu6
         24VJVjbWb/cHOuvFw3syr0MWy92rerkAsDxwAkBDxS7R4sL6SUAU1FkPqvsv3RI7tVnu
         YBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MW5bc1IRD2u4VCza1XeO7tBGGQWzWdmkL/Cr6C6JDlc=;
        b=I0BvN9fRzZhkKNdDtlowFJUTj8/nWpJtW1mt38zDDMgRYAfq9Qhi07NEtXCx3WsB1w
         JvBwiKI34gCtjgmll2os0cBlOHF2Ij43lwScz2KVVIwZRwaBk/vW54YGyvcsW9ARo9FT
         dKR7rtvpKtOErXJqs4M9PRk/tTirn44vob6tQVxCioYKQzwbNtD2pD33TmbkWfOyYKjZ
         QYt/fthaP0cURD0yC+/LPPP8hBVF77jedlLqnk0jOgYj8xE+wZjS+bCSboUKb8sV3KlL
         VTHo0ySomWRbSO2eB/HNAYA14SmXMOGZsQbKjCiQrnnjjcfLwwNCCXeJIIRYE3yDa9Ed
         IlqA==
X-Gm-Message-State: AOAM532CH29Vj1V9hB3fynWYsOYUvRpv5ERCbuHvRHkU/cTcinS96114
        wONyBCOvDWR954+KmC5Tc5A=
X-Google-Smtp-Source: ABdhPJzn85h5iwB3uM39+Yt17X/wUPzre6CwUjLbC9lyLZ3kf2p2/w0bgbm3VL5EpdxvLmnUwYTW4Q==
X-Received: by 2002:a05:6638:685:: with SMTP id i5mr9893210jab.109.1616718960201;
        Thu, 25 Mar 2021 17:36:00 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id y13sm3449472ioc.36.2021.03.25.17.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:35:59 -0700 (PDT)
Date:   Thu, 25 Mar 2021 17:35:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com
Message-ID: <605d2c67381a9_8d47020875@john-XPS-13-9370.notmuch>
In-Reply-To: <013bbba5-ae52-f472-02ad-8530cc8b665a@iogearbox.net>
References: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
 <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
 <013bbba5-ae52-f472-02ad-8530cc8b665a@iogearbox.net>
Subject: Re: [bpf PATCH] bpf, selftests: test_maps generating unrecognized
 data section
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 3/24/21 10:07 PM, John Fastabend wrote:
> > With a relatively recent clang master branch test_map skips a section,
> > 
> >   libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> > 
> > the cause is some pointless strings from bpf_printks in the BPF program
> > loaded during testing. Remove them so we stop tripping our test bots.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    3 ---
> >   1 file changed, 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> > index fdb4bf4408fa..0f603253f4ed 100644
> > --- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> > +++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> > @@ -16,10 +16,7 @@ int bpf_prog1(struct sk_msg_md *msg)
> >   	if (data + 8 > data_end)
> >   		return SK_DROP;
> >   
> > -	bpf_printk("data length %i\n", (__u64)msg->data_end - (__u64)msg->data);
> >   	d = (char *)data;
> 
> Do we still need 'd' as well in that case, or the data + 8 > data_end test if we don't
> read any of the data? I'm not sure what was the original purpose of the prog, perhaps
> just to test that we can attach /something/ in general? Maybe in that case empty prog
> is sufficient if we don't do anything useful with the rest?

This program and test existed before test_sockmap was running and doing a
more complete test set. At that time it was the only thing verifying that
we could read the d[] and check lengths.

At this point these cases are covered there so it should be OK to just
make it an empty program. Then it is _just_ testing the map attach/detach
logic not that the programs themselves work correctly.

By the way without d marked violatile my compiler removes the load there
so its pointless as you note.

Because this is used for test maps I'll just make this an empty program.

> 
> > -	bpf_printk("hello sendmsg hook %i %i\n", d[0], d[1]);
> > -
> >   	return SK_PASS;
> >   }
> >   
> > 
> 


