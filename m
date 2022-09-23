Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB725E7D78
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiIWOoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIWOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:44:05 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E91612FF07;
        Fri, 23 Sep 2022 07:44:04 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l12so289906ljg.9;
        Fri, 23 Sep 2022 07:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=x2AC5aUErTXxDqqDWkhz2yZEaift/7Hb+tiOpgPFGpI=;
        b=bJVq2/d2V6xNKgToFVEl1MXmS+OhnqeeH0/MJFszIA/svGcpRhMeqpeceCOHGqp3Av
         h2v0FxgR9jUHDplHeig5OXY9RylJ9L/IEdUnGi2k6CKs/gmzLu8aCLWChPYMxO82C7Pb
         kHhJySrog3k290ohdzsjpZoVQLprgUMdxaVVGNRZJeJtezd/443kA/7+bXtx2cCwRy2w
         Cs+RHSaJXXqmko8AlK7v7zTVSFIWXOj4W8085jUUwbfr8K/EuQVlsB+w1x24E/nf53Wg
         8c8RFXwySopznxMHtpG8p4gMomF7LavoRaH1l1HcNFkbGuB8fcEEC0VmuG9fSYtS43lU
         B90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=x2AC5aUErTXxDqqDWkhz2yZEaift/7Hb+tiOpgPFGpI=;
        b=uVOSMCSkO++K+ZilZv8l9HeWQXMV1rUV31qVNoHtb8wRTCrkS/NVB2j54sLd9RqtuZ
         dXcvCvbb3ReMKt+2CTzUpVcVHYZZvUnWd/eoQPNLqIay53tZD5gomxph6DIGoD/8gTV/
         vLHBxu5+Ur/mBCOIfjkGyveVsRjm0siYfvxX+iXw9pfa8eRsvfB0XzouASKQfTxstKMs
         4cfn72kWQ7xH2PPbfnQ0dwaNl9xZTNXRcFN01bnwKIrQND6/bEaIqJe6wrFeI4iKijrU
         U5kVv0+oI82eMJI77ooSFzIRq2GYEhWdRY/4YLBTeKEXpDTczjfQ4e8d1I0sgzV4b8T0
         k0/w==
X-Gm-Message-State: ACrzQf2kdGBtTWHWeV6C6WV4XZzF8/B+IAQGVfmqGdM4v713G2L9jCqM
        ssh4bDMgDg2uDmTMpfHBD2I=
X-Google-Smtp-Source: AMsMyM5P2OfBHJhqLzZVNgi5H9ALef+5EkB8eCTv1HW6N5pfTwdZ3Xmn4cMPCZoPZXAWPPwnfOYxLA==
X-Received: by 2002:a2e:9e81:0:b0:268:894f:8118 with SMTP id f1-20020a2e9e81000000b00268894f8118mr3155396ljk.371.1663944242514;
        Fri, 23 Sep 2022 07:44:02 -0700 (PDT)
Received: from pc636 (host-95-193-99-240.mobileonline.telia.com. [95.193.99.240])
        by smtp.gmail.com with ESMTPSA id m4-20020a2e8704000000b0026bfadf87e3sm1420576lji.20.2022.09.23.07.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 07:44:01 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Fri, 23 Sep 2022 16:43:59 +0200
To:     Florian Westphal <fw@strlen.de>
Cc:     Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <Yy3GL12BOgp3wLjI@pc636>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923133512.GE22541@breakpoint.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 03:35:12PM +0200, Florian Westphal wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> > > Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
> > >  kernel BUG at mm/vmalloc.c:2437!
> > >  invalid opcode: 0000 [#1] SMP
> > >  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
> > >  [..]
> > >  RIP: 0010:__get_vm_area_node+0x120/0x130
> > >   __vmalloc_node_range+0x96/0x1e0
> > >   kvmalloc_node+0x92/0xb0
> > >   bucket_table_alloc.isra.0+0x47/0x140
> > >   rhashtable_try_insert+0x3a4/0x440
> > >   rhashtable_insert_slow+0x1b/0x30
> > >  [..]
> > > 
> > > bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> > > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > > 
> > > Revert the problematic change and stay with slab allocator.
> > 
> > Why don't you simply fix the caller?
> 
> Uh, not following?
> 
> kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?
>
<snip>
static struct vm_struct *__get_vm_area_node(unsigned long size,
		unsigned long align, unsigned long shift, unsigned long flags,
		unsigned long start, unsigned long end, int node,
		gfp_t gfp_mask, const void *caller)
{
	struct vmap_area *va;
	struct vm_struct *area;
	unsigned long requested_size = size;

	BUG_ON(in_interrupt());
...
<snip>

vmalloc is not supposed to be called from the IRQ context. If it is possible
it would be better to fix the bucket_table_alloc() by not calling it from the
IRQ context.  

--
Uladzislau Rezki
