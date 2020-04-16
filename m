Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE4A1AD1F9
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgDPVgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgDPVgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 17:36:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A65C061A0C;
        Thu, 16 Apr 2020 14:36:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kb16so123931pjb.1;
        Thu, 16 Apr 2020 14:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1o7BPb0GVWolvbnYGNa4anj2OLOJ9OUneM1dO5eCLAU=;
        b=mehCI6v6DtYopZC6FTPD5c94h9Nxmofof05DThsQ2PnH9SGy5FAgIXOwMDbN91rn0l
         qVfdtNG/VAoqHAQbOh0Mgn9jL7DdeSQEzPY8kMS0JLrOjgcaH6QZKSGhb7hyncVxQ/sY
         Rw7uyq6o4PC333Mhsur4F+wlqaeoQdpFvqkEOVNXfuFVyPKxyG0pDGao16Vuxu2WTNpO
         bpsxSFo+x1JOAo/FPu3TWSA4fzGxdqALCOA6uXUb/0e0zLV4WvN/C+Vg0zS0ckzt7x43
         PDYd8JaPISW3DkyKjG6yBPoXmgITSpvQ4YG4CxX0hV6vJqSrVGBzzfFJs4w+zcqGJ6J/
         QBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1o7BPb0GVWolvbnYGNa4anj2OLOJ9OUneM1dO5eCLAU=;
        b=NsF5Yrmpi/dM13kvxbV28SMKKpK79088LPyQnjBdwoeh4vJcW/MwWj/yJ+2Qs2pofN
         rARYuFkVnd3QqSfF8JAMLcc4hu0CHMMuVAdy3Lac3xK8UUuBpfEPvy66+ncdhqPSg8pH
         pSwhddtm84jVIDLl78BiO/56tXy7m43Sl85tCFOn/oxFbx2dVMN8U4GDuPq/DCS4bsqT
         j17Wkgr6tcDrvFbBfabix27mJBIQUqmbA1sSM+NLvz79nYBUSQPNcjnxHsBp9y3OAmTa
         vpJV0k85E+tx7VKnNFC2OAGGkD0by9U+MgBnjKhKltikB41ZATS+3AFQuWe7fElMRKDX
         3SFA==
X-Gm-Message-State: AGi0PubWESK5F9I8Br/Hzi3dxrQyw79bEJuLQvEmDp/HNn/2tjiv/UAR
        5RPiuKG9IEvi/Oapy/K2ZaM=
X-Google-Smtp-Source: APiQypKTPnpYGVyGYuolfnSB52zBeTX5UpSC599aDjLQV8GP9Qc4O86qmnfbZ8OKWGG8oL7yW3oXOQ==
X-Received: by 2002:a17:90a:ca8c:: with SMTP id y12mr386759pjt.195.1587073002361;
        Thu, 16 Apr 2020 14:36:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:fff8])
        by smtp.gmail.com with ESMTPSA id j32sm4915911pgb.55.2020.04.16.14.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 14:36:41 -0700 (PDT)
Date:   Thu, 16 Apr 2020 14:36:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: selftests/bpf: test_maps: libbpf: Error loading .BTF into
 kernel: -22. Failed to load SK_SKB verdict prog
Message-ID: <20200416213639.tyl27wr3z5tdecui@ast-mbp.dhcp.thefacebook.com>
References: <20200409084223.GA72109@harukaze>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409084223.GA72109@harukaze>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 10:42:23AM +0200, Paolo Pisati wrote:
> test_maps fails consistently on x86-64 5.4.y (5.4.31 and defconfig +
> tools/testing/selftests/bpf/config in this case) and dumps this output:
> 
> ~/linux/tools/testing/selftests/bpf$ sudo ./test_maps
> libbpf: Error loading BTF: Invalid argument(22)
> libbpf: magic: 0xeb9f
> libbpf: Error loading .BTF into kernel: -22.
> libbpf: Error loading BTF: Invalid argument(22)
> libbpf: magic: 0xeb9f
> 
> libbpf: Error loading .BTF into kernel: -22.
> Failed to load SK_SKB verdict prog

I've been trying to reproduce on the latest bpf tree and couldn't.
Does it reproduce for you on the latest?
