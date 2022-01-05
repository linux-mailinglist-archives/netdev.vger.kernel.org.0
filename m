Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B306485A7B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 22:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbiAEVOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 16:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbiAEVOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 16:14:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E357BC061245;
        Wed,  5 Jan 2022 13:14:36 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id h1so500524pls.11;
        Wed, 05 Jan 2022 13:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w2Ob441irsuGRfis+qZ9FDkZbhuiwI42VIAZnjpup4E=;
        b=gK09uHZZvj/HgQmFeqm0Gse+PkmZC8zRdopa8+maLJae7si2F+E/Bh5SCTtr0Sz78F
         c5SY8GJ/J6xvONQI8Ec9/Ghtu2AELAcIy2+RqUFmV302tLIf3ZAaug5YQ39FynML/nij
         5tsPMka20Xjpw2Bb27wRvS+5LS3ACHxXVs0cAfMI9x8x2QEnNSU3PIrruy5mNLh7CMRE
         XG8HBQXm+/RIK3Y1teb+NcLuc0+GmJZPU2eFBw2BFmG6WxI3XHmhHozbwrm9ObraVJyJ
         EsSMfVo5p4IwoNGhyE3P3UghywzXAM3a3AinA7VQtzk96okZUKJLFPseoANPQLIuxwhC
         WGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w2Ob441irsuGRfis+qZ9FDkZbhuiwI42VIAZnjpup4E=;
        b=7IQdxAzWrbjQUaRsZNp6Oy7pwrwtyr46k+yl2/fJHclLQjkB2XkmYsGUnGoCPJL1ky
         3L8c1+n93fQJFoyYOMeYt5WBp9vBIdr5wY2+l8bGDPHYuggcUenKoWHMxV5V98E60v8p
         wlkiI8X3gzjN5MD40quvQyYyYpM9ZHFbah3QFRthaV0NWHThlVoZUo6XwSRsmYH9DH4n
         R6pM7IJhhjpKiruV4WuOQcd2o/n7vQMHsaS6wNxd0O5VK7IbdVTfxdgYjfz7kPSdcQmK
         U6izNMod7dMIjO01RCNLmtydxJtTJFI4v7o8WrAhWBSK44F2qFU3Kxbuf9L8zfh+B5+9
         vHcQ==
X-Gm-Message-State: AOAM530mLKBwEn2y/vlm8Bp0sLeE4y4mGsLBQOy0Wdm0bIVuMr4AT2cq
        poCEi+FahN0M5eScl8kVdGs=
X-Google-Smtp-Source: ABdhPJzbLx8hbiYhnxpsjhFyRKhAlqRqhFAFIEMGrXDpRNO4hy58ZvsB2DON0O0P8PXMhk2pOc1T0Q==
X-Received: by 2002:a17:902:a50a:b0:149:7aa8:37f6 with SMTP id s10-20020a170902a50a00b001497aa837f6mr44984764plq.91.1641417276422;
        Wed, 05 Jan 2022 13:14:36 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id l2sm51153pfc.42.2022.01.05.13.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 13:14:36 -0800 (PST)
Date:   Wed, 5 Jan 2022 13:14:32 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: more eBPF instruction set documentation improvements
Message-ID: <20220105211432.bdcl65mwxbfguttw@ast-mbp.dhcp.thefacebook.com>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 07:35:50PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds further improves the eBPF instruction set documentation.
> Mostly it adds descriptions to the various tables as requested by
> Alexei, but there are a few other minor tidyups as well.

Applied, Thanks
