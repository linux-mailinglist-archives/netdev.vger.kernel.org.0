Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2DB5201E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbfFYArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:47:31 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43532 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfFYArb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:47:31 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so11246172qka.10
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=O/cyeGxuT/uJvjOEwDAxYIHSGXpegMm1RwjOliTXm7M=;
        b=1JE+1K6A7BCuZD7Y31S7lcsbAmf+o58unRYK7sQwIqNstD4VDlqJ/3Y1gfhVxXslBo
         8BbGQnYQ/G8yPEyFw/UCt6565az8g7jnrdfpMH4KXQUoddcPa5STq1ISS9Kskz2mFGcZ
         XLoj44PfsGyMDksJUlaPmJjhp07dRqvzeyKaeyxIU6HLCsR3Cd/5w9CqaR3hLgnziJwV
         qD2wpe1dMl0ndjPth8jlzMj/u1QbLO9FIb7ezK8R5ewmno1efHUiYqXcwz5kEbe5NMwk
         L/yOWzfpxgh/3M1Ao66U7Xz8e4VcDZcDz3tWliItgGr26vtJ1yQ1rrN62kYOJDSUeuym
         tLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=O/cyeGxuT/uJvjOEwDAxYIHSGXpegMm1RwjOliTXm7M=;
        b=FMXNIEvD/2Fv56DAJV/aNBx5UvzsBo0dJsCTBICsUuR5Fnl+WQXgy/gN/kQ1RVThOP
         OEvOdz+pXQxITaMsn19iIZkbQt+5f0T4p3a79rc+fhS2n6f8/oWJFQj/K0ODrPH+NV52
         dwDpgEkGyJiSnONpVi+jmgdIVNQnqxKnw+UXqbjwV7gAypYRnHBSZkLJWdTFcnDsrB1J
         AXnV/YM3vFPBKPejQnZ3hWy4QQxChNaKwPMh+G4XNk8j6PUqdV3UaNZnfsIoN5rHIjUV
         EHoxegSsl2AKGCTesZE8X0DcXkx9nGUJyiIkA+W52HxXT3eTjhhg0dWvWNjc+fsQK8xg
         N06Q==
X-Gm-Message-State: APjAAAU48exUQQSkecW1nwEp0O+b4a8X8rKOcLBZaUeLpE+VuBKR0rYz
        LvEUKWW5YWrTRfoCOg495QK3UA==
X-Google-Smtp-Source: APXvYqyYkcC1cavAV1xJxKriBpsKlC7i95iT+TVQEgem++bicGhu82aZ6k7JqZ8FSNdC0aq0/qCoyQ==
X-Received: by 2002:a37:6f82:: with SMTP id k124mr19616410qkc.463.1561423650398;
        Mon, 24 Jun 2019 17:47:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f26sm8893088qtf.44.2019.06.24.17.47.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 17:47:30 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:47:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624174726.2dda122b@cakuba.netronome.com>
In-Reply-To: <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
        <20190624145111.49176d8e@cakuba.netronome.com>
        <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
        <20190624154309.5ef3357b@cakuba.netronome.com>
        <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
        <20190624171641.73cd197d@cakuba.netronome.com>
        <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
        <20190624173005.06430163@cakuba.netronome.com>
        <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 00:40:09 +0000, Alexei Starovoitov wrote:
> On 6/24/19 5:30 PM, Jakub Kicinski wrote:
> > On Tue, 25 Jun 2019 00:21:57 +0000, Alexei Starovoitov wrote:  
> >> On 6/24/19 5:16 PM, Jakub Kicinski wrote:  
> >>> On Mon, 24 Jun 2019 23:38:11 +0000, Alexei Starovoitov wrote:  
> >>>> I don't think this patch should be penalized.
> >>>> I'd rather see we fix them all.  
> >>>
> >>> So we are going to add this broken option just to remove it?
> >>> I don't understand.
> >>> I'm happy to spend the 15 minutes rewriting this if you don't
> >>> want to penalize Takshak.  
> >>
> >> hmm. I don't understand the 'broken' part.
> >> The only issue I see that it could have been local vs global,
> >> but they all should have been local.  
> > 
> > I don't think all of them.  Only --mapcompat and --bpffs.  bpffs could
> > be argued.  On mapcompat I must have not read the patch fully, I was
> > under the impression its a global libbpf flag :(
> > 
> > --json, --pretty, --nomount, --debug are global because they affect
> > global behaviour of bpftool.  The difference here is that we basically
> > add a syscall parameter as a global option.  
> 
> sure. I only disagreed about not touching older flags.
> --effective should be local.
> If follow up patch means 90% rewrite then revert is better.
> If it's 10% fixup then it's different story.

I see.  The local flag would not an option in getopt_long() sense, what
I was thinking was about adding an "effective" keyword:

# bpftool -e cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/

becomes:

# bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/ effective

That's how we handle flags for update calls for instance..

So I think a revert :(

> Takshak,
> could you check which way is cleaner? Revert and new patch or follow up fix?
> But bpftool doesn't have a way to do local, no?
> so it's kinda new feature and other flags should become local too.
> hence it feels more like follow up. Just my .02

