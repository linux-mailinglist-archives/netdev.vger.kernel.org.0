Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6083418540F
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgCNCtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:49:00 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36559 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgCNCtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 22:49:00 -0400
Received: by mail-pj1-f65.google.com with SMTP id nu11so2103386pjb.1;
        Fri, 13 Mar 2020 19:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2x1u8R0S9Q2Y/S3tllWq88hBHPkmmrvNWRG50ipROPs=;
        b=RQCOnwK46M3BVCXuoxuYCcVZRh79o1320PV4Wp8Cgwwn4AFBeL3xc586LcRSOAPwJd
         rTwfZiz8YNiX8RWjfbMU84rEr1W/6W6UBvxKqXIQ3MRLv0XHUVYP32x8sbDnNqCWQGNF
         CxUg3JyZh39PBb7bDL0eMy251eTqaz9a9XptSquKxzsvUPYgjGPFkX0DClEqWAhi6WAH
         uMwXrSrYy4UVk6jWI3+f3Vb21rtZsPfdgbLcITcjCdPCP0VV00hCDQuTHj0eH0TI+k6I
         QKTkWw+kEPWQGah6JvIWCf+S5pHFWsN8wKiZriC7TF7iGogvH3nFcnNIOk0sBvji12Zb
         LE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2x1u8R0S9Q2Y/S3tllWq88hBHPkmmrvNWRG50ipROPs=;
        b=Tyl8xEcL/f2j4WcFNGO4GyRD9qGBmnnuEAr72gk3zfQ7iZaHSrPqKmtXR3bfe9KXso
         DTKBPm/nvgITrsJJM4/6cr9RHw70o/EE9TX5hNb3PYIhte0dloBqwVZRViQOjkGWeWt2
         HU6HWtne2waG7KylKGIWvcL5ZnMkcj7T6zTf9zYtClDLaGRsjFwhJdjTg0HiJbbVkWKK
         shjQWbrf6+mZPLATGbKjiEp+sHEeLNLRaQtxOcjKWslrLKj85Bv3KdZgdJIoVotf3R+F
         YWqDr1nlolBN94CZj7PE+vIKDPV8w+u0GeWjb+5LJS2zxQiYdCNW+fo4YTELDCKp7BIS
         Gogg==
X-Gm-Message-State: ANhLgQ12jfb4Bxu8DsN6OsPlfZv+BhkFmwkpLUfxXbnGtwuTMvlGjk2+
        eMZQtxXX23YbNH88RftAWeU=
X-Google-Smtp-Source: ADFU+vsGaeB5THlTMUIIIFIXL+6+ZKAO4fe9gViRLI5ISVeD+JE2Q7lVNQpMFIVcw8OCBvsXv26DMQ==
X-Received: by 2002:a17:902:8502:: with SMTP id bj2mr13673946plb.72.1584154138798;
        Fri, 13 Mar 2020 19:48:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1661])
        by smtp.gmail.com with ESMTPSA id 144sm6900886pfx.184.2020.03.13.19.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 19:48:57 -0700 (PDT)
Date:   Fri, 13 Mar 2020 19:48:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix spurious failures in accept
 due to EAGAIN
Message-ID: <20200314024855.ugbvrmqkfq7kao75@ast-mbp.dhcp.thefacebook.com>
References: <20200312171105.533690-1-jakub@cloudflare.com>
 <CAEf4BzbsDMbmury9Z-+j=egsfJf4uKxsu0Fsdr4YpP1FgvBiiQ@mail.gmail.com>
 <87o8t0xl37.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8t0xl37.fsf@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:42:36PM +0100, Jakub Sitnicki wrote:
> 
> What if we extended test_progs runner to support process-per-test
> execution model? Perhaps as an opt-in for selected tests.

I would love that.
Especially if fork-per-test can make majority of the tests to execute in
parallel. Running test_progs is the biggest time sync for me when I apply
patches. Running them in parallel will help me apply patches faster, so I can
dedicate more time to reviews :)
