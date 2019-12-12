Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9FD11D612
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbfLLSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:43:39 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:46156 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730292AbfLLSni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:43:38 -0500
Received: by mail-pf1-f178.google.com with SMTP id y14so1225952pfm.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fEIPg/nQz4H3SkrhOeevoDfxx5kg6oJ1sVD3wkmZeI0=;
        b=ABRb/h4SFCN15IlJ59pRxlKmFUVBRkKSP6xEkKHRgMqwZqw8UpadE/n46IhjBKm0xI
         Hw1BTt6v5y/rIocXnccHBkGIZVICyVqoz7xSWV3uvQoQCugmlWIqMOnOZYzBrg5cUpmG
         0+5vBkHOKMxEjtmzhGa3uzOdCsXMc7nOlFLXDOzzplMSDchmHph+zrBYze+a5cBo+LX2
         ymnHRs8Jc2JLBOi7lFmdClxmXEtdYs8rvZ5Bap2HczqawwPjhm47w2r/96Lb/IiRn55+
         Vc8URDEpeNvnjiUsCGI37gERHaXpJDwJbNcy+GHI8WYirzeS+z/DZdl/KAJQzyYcmXDj
         q2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fEIPg/nQz4H3SkrhOeevoDfxx5kg6oJ1sVD3wkmZeI0=;
        b=FdIFiFUtSrGncjgAMXJuxhDOyfILxq2xhUOjPyDmqlvb/qDA8+CJ/S8HDAfG5LLsbz
         eI7jLtt89gquwtXQGKfAiGZz+cR9Embsgu1FOuSq2IrxV35RtqytTaQ1Ube2DTz+vLoS
         6K6XjJw+FU6LkcyAGJC1X8DnPyMAH3TZ+lkC8KaefF+hr1anVJs65lbp6AYeQDB88/hM
         XGguVWE1W7irTJizAiRN+eec6LfdCpHtnosONSUh1naQBkfmO4iDhmkbTiXH/lBM2089
         6nRa7Zh8Hl1dkRw6f9xGffjog9h/dBPZ5Qih7O7aQUlHPPZ6/oKQbcbONt4mOHa0HHkf
         S7NQ==
X-Gm-Message-State: APjAAAU1VWaEioDMbOQCKwjuF9bIVrQGj21CK+23QM2x4b06liyIKZtz
        CxIJp328aWshK6Mif8YlXx9p/g==
X-Google-Smtp-Source: APXvYqyVlBeifCyE3IO6vVv8sLrUbg/iyOye4wEh0A4o2JqPV+oWytkfEMTm0IaR5HFgRNwZljzrVg==
X-Received: by 2002:a62:1742:: with SMTP id 63mr11114346pfx.231.1576176217889;
        Thu, 12 Dec 2019 10:43:37 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j14sm7532044pgs.57.2019.12.12.10.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 10:43:37 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:43:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191212104334.222552a1@cakuba.netronome.com>
In-Reply-To: <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
References: <20191210225900.GB3105713@mini-arch>
        <CAEf4BzYtqywKn4yGQ+vq2sKod4XE03HYWWBfUiNvg=BXhgFdWg@mail.gmail.com>
        <20191211172432.GC3105713@mini-arch>
        <CAEf4Bzb+3b-ypP8YJVA=ogQgp1KXx2xPConOswA0EiGXsmfJow@mail.gmail.com>
        <20191211191518.GD3105713@mini-arch>
        <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
        <20191211200924.GE3105713@mini-arch>
        <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
        <20191212025735.GK3105713@mini-arch>
        <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
        <20191212162953.GM3105713@mini-arch>
        <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 08:53:22 -0800, Andrii Nakryiko wrote:
> > > > Btw, how hard it would be to do this generation with a new python
> > > > script instead of bpftool? Something along the lines of
> > > > scripts/bpf_helpers_doc.py that parses BTF and spits out this C header
> > > > (shouldn't be that hard to write custom BTF parser in python, right)?
> > > >  
> > >
> > > Not impossible, but harder than I'd care to deal with. I certainly
> > > don't want to re-implement a good chunk of ELF and BTF parsing (maps,
> > > progs, in addition to datasec stuff). But "it's hard to use bpftool in
> > > our build system" doesn't seem like good enough reason to do all that.  
> > You can replace "our build system" with some other project you care about,
> > like systemd. They'd have the same problem with vendoring in recent enough
> > bpftool or waiting for every distro to do it. And all this work is
> > because you think that doing:
> >
> >         my_obj->rodata->my_var = 123;
> >
> > Is easier / more type safe than doing:
> >         int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> >         *my_var = 123;  
> 
> Your arguments are confusing me. Did I say that we shouldn't add this
> type of "dynamic" interface to variables? Or did I say that every
> single BPF application has to adopt skeleton and bpftool? I made no
> such claims and it seems like discussion is just based around where I
> have to apply my time and efforts... You think it's not useful - don't
> integrate bpftool into your build system, simple as that. Skeleton is
> used for selftests, but it's up to maintainers to decide whether to
> keep this, similar to all the BTF decisions.

Since we have two people suggesting this functionality to be a separate
tool could you please reconsider my arguments from two days ago?

  There absolutely nothing this tool needs from [bpftool], no
  JSON needed, no bpffs etc. It can be a separate tool like
  libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
  That way you can actually soften the backward compat. In case people
  become dependent on it they can carry that little tool on their own.

I'd honestly leave the distro packaging problem for people who actually
work on that to complain about.
