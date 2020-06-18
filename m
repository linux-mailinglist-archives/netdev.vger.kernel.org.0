Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE981FFCFC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgFRU5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgFRU5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:57:30 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A10C06174E;
        Thu, 18 Jun 2020 13:57:29 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r77so8853941ior.3;
        Thu, 18 Jun 2020 13:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ekBA7MSnXf0K4EAceloISG4Tg8M4FuphXWh1VGKXWfk=;
        b=GyOLX9Mk7aYkcIhfAq0JTaZ4i8k+nu9eCjDZ/zVkfaNPSJmNqVno48WUOuvhdfrCIK
         l88F0gxHhG2y/xRhDhVhJdHTV/lmm5rPuX2IGl9c59/m96suidzswmehGSC5bNcfGKYP
         ViD91bi0a3qnyJvxzy2fhbe7Q+3wCNop6/YrijkQp6U3yxBFO2+8jBeLJADxm135qNX3
         CXi8VTOs2uMkmEyBBn4MvfdKDzGI8MKsGwG+EdP+uAuJLz9lLelysdfnlMDIT9Rwd6lV
         TqOmeMqLm1wv5QXQuOgpDXs+fTBDG59L1IZSJxpRN+EtidRUq0vrucj0Ppe932lsF5cl
         GdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ekBA7MSnXf0K4EAceloISG4Tg8M4FuphXWh1VGKXWfk=;
        b=RWhviHCInvqaiIkfR3GZaYl89MvaCNlKMmDf7R73zZ1UuSPaFaVSElrgUQWHLwrjJ6
         CdpKMOYw9Gxa5iJsPoEBc9B928c/x/BeDJVB+3Vcz/HxCGvOudOxG23qjPxh6kCF6sHU
         aztEOpuCyeaJk00/eJ2zj2t6pvKWafSixac8tCZLRyc0lzCSxJvNbA33Lzw9+9neva/h
         rtlxSh4ZfmURT2WEui+SxvPO4aALFvXB/6iem1zB/L38DeAYQgrfozkXhHrYadMm0RUK
         mKmvPz8Iv325/FYkAoV85a5c7CcusmPxQc3RIFrNob2UOJCblhnCuhV/Qe4nvq/elfFD
         ULbg==
X-Gm-Message-State: AOAM530LifX+uRocbSJrsuLaiskyHv53F6YQbq2pD+d0f+DrFa+nfyfX
        btJuzo7tzALBS7o3UWhfU8U=
X-Google-Smtp-Source: ABdhPJzriEUJ+9Czd8kBM9OIvPAToh2o3XpLV6JtCrSB7YlCV+yAzE7ZGJbq6U+AvtNp1ma04hBugA==
X-Received: by 2002:a02:942e:: with SMTP id a43mr459665jai.113.1592513848154;
        Thu, 18 Jun 2020 13:57:28 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p9sm2043716ile.87.2020.06.18.13.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 13:57:27 -0700 (PDT)
Date:   Thu, 18 Jun 2020 13:57:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <5eebd52fc68ee_6d292ad5e7a285b816@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
Subject: RE: [PATCHv3 0/9] bpf: Add d_path helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> hi,
> adding d_path helper to return full path for 'path' object.
> 
> I originally added and used 'file_path' helper, which did the same,
> but used 'struct file' object. Then realized that file_path is just
> a wrapper for d_path, so we'd cover more calling sites if we add
> d_path helper and allowed resolving BTF object within another object,
> so we could call d_path also with file pointer, like:
> 
>   bpf_d_path(&file->f_path, buf, size);
> 
> This feature is mainly to be able to add dpath (filepath originally)
> function to bpftrace:
> 
>   # bpftrace -e 'kfunc:vfs_open { printf("%s\n", dpath(args->path)); }'
> 
> v3 changes:
>   - changed tests to use seleton and vmlinux.h [Andrii]
>   - refactored to define ID lists in C object [Andrii]
>   - changed btf_struct_access for nested ID check,
>     instead of adding new function for that [Andrii]
>   - fail build with CONFIG_DEBUG_INFO_BTF if libelf is not detected [Andrii]
> 
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/d_path
> 
> thanks,
> jirka

Hi Jira, Apologize for waiting until v3 to look at this series, but a
couple general requests as I review this.

In the cover letter can we get some more details. The above is really
terse/cryptic in my opinion. The bpftrace example gives good motiviation,
but nothing above mentions a new .BTF_ids section and the flow to create
and use this section.

Also if we add a BTF_ids  section adding documentation in btf.rst should
happen as well. I would like to see something in the ELF File Format
Interface section and BTF Generation sections.

I'm not going to nitpick if its in this series or a stand-alone patch
but do want to see it. So far the Documentation on BTF is fairly
good and I want to avoid these kind of gaps.

Thanks!
John
