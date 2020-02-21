Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC0168A14
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgBUWoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:44:34 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36630 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUWoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 17:44:34 -0500
Received: by mail-pf1-f193.google.com with SMTP id 185so2035099pfv.3;
        Fri, 21 Feb 2020 14:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cceSZ0xIZFt7SCWYZAxl6HnAJNJskJe6R45L26XdHHI=;
        b=DGdclY8PMu9ZY48vwOeL9Ml2QxiHkti6cZiLDRtZM/wfub/2HtAMzIQtAoR2GSgiLv
         rKjMNChLWqTh/sChQgR1n4wis8lVKY7FJt2gxrc9pREV9qYD7axGSoD36F8wH7hqNDPs
         zNIDmVrFwwBiQB5PRevrRve1l50OtDwl8mQpZpy4yFPpTL5JeTn3hBkfSNnBPsJyTUtl
         f8EZI05Apr62Q4k5dO0g9Ldfn/c+LkpwXgcXzgepYI1SxrM6uorSffXOHnZkE+dZAHbj
         karztfLtXOzh87cAFT8ZIXU33RBAAOv4j95AyFw848T6FposDdrpXR0BdItWJ34NsXqg
         GlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cceSZ0xIZFt7SCWYZAxl6HnAJNJskJe6R45L26XdHHI=;
        b=hUdK8Vy4/sZkziY7Y0rIB8gcOV1lb4HP+3iRz4wsWQBK2bHMLJ9YkNKFq25cJ3e4LG
         i9Gcc3614RUpuTVVQJPXZHX/Fowvx7kH40yZ3ne7T5Sad+G30J26H3sB0VLYn0d0fMgr
         FWPQLrkYSISjKv73ZsG2CRC5Bzs3KAFi8Fb59VDFBXGBkJvlpHFWSsgr+plIFyb09l3v
         9aPlT2vbtOsO5e08xNO6g4VJazYP9Xqou9VISTPjJ8ChHwvUpL1GcF5py/EK4hPR5aYT
         MLO0d8Vb8hytnydqu/GOdhPKh6+dRBcdgr+bONQQhJNIcYPtPovgT5O3Uyo2Ht3D7Zjb
         T7Sw==
X-Gm-Message-State: APjAAAV1ZC/1koNxoJlsIiXLv0MilgflJeRhtCDV9Z5MUyJ60h9o0qYx
        yIoIfzpObIFkvebhSG4OSXxy7tXS
X-Google-Smtp-Source: APXvYqywhe5FhZO4n/XaE0Tp4SIYAomGQLeICnq7qU6/uFXNx/HGcprxcWeNj5d3FYmq405bVP3F1w==
X-Received: by 2002:a63:3c1b:: with SMTP id j27mr40324813pga.152.1582325073170;
        Fri, 21 Feb 2020 14:44:33 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:d448])
        by smtp.gmail.com with ESMTPSA id t28sm3931342pfq.122.2020.02.21.14.44.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Feb 2020 14:44:32 -0800 (PST)
Date:   Fri, 21 Feb 2020 14:44:29 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/5] bpftool: Make probes which emit dmesg
 warnings optional
Message-ID: <20200221224428.plbxav3scv6og6kv@ast-mbp>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
 <20200221031702.25292-3-mrostecki@opensuse.org>
 <7ab56bb6-0ddb-2c3c-d116-fc01feddba5e@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ab56bb6-0ddb-2c3c-d116-fc01feddba5e@isovalent.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 11:28:05AM +0000, Quentin Monnet wrote:
> 
> "trace" sounds too generic. If filters are applied again to prog and map
> types in the future (as you had in v1), this would catch tracepoint and
> raw_tracepoint program types and stack_trace map type. Or if new helpers
> with "trace" in their name are added, we skip them too. Can we use something
> more specific, probably "trace_printk"?

+1

> Thanks for the patch! While I understand you want to keep the changes you
> have done to use regex, I do not really think they bring much in this
> version of the patch. As we only want to filter out two specific helpers, it
> seems to me that it would be much simpler to just compare helper names
> instead of introducing regular expressions that are not used otherwise. What
> do you think?

+1
I was thinking the same.
Or filter by specific integer id of the helper.
