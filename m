Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6891BD2B3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgD2C4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbgD2C4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 22:56:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C9C03C1AC;
        Tue, 28 Apr 2020 19:56:09 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s10so311570plr.1;
        Tue, 28 Apr 2020 19:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yUiwzJZr0cQOFFpTut/k9ry8RWvB6rL7cVCdssQHt5Y=;
        b=JX/meWadGfs6BGkMFenso+v5dtWF5QyPXAQUeeIJGZ9viKbuGhWYe+L9D8vsSEYHA/
         Emjn48fpE43P7hI7wvzA/g5K17yfCkRoyLFv1qPaAYMlIwSyAjkOcmRnldIdJPcs5yLE
         R1Hc0XffFy4m0R1+9l8wrJ+4RNMO004wV9xcImFtj4MBH3vMA9VRxrVxyGcnCA4UYDoQ
         jUwHqyxyfNRA0NL/rQN71IGjySpsP2vjJSPXG2rkK9Rwz7jYMVPdg2SWCCfmW+0boUrG
         dps6Vm53m+e6/KJSXz+dPZHH6rvNQSIG9T9NgvAvcE7YSkGRBN/HQOwuupQm/Vr/lEtP
         N5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yUiwzJZr0cQOFFpTut/k9ry8RWvB6rL7cVCdssQHt5Y=;
        b=en/LQQrBZZejQdOFwWnO2EhS5HnBXFVjPqZK1dPaq8jwnu2GMsiTTKs1EU39gS1e0X
         R4XP0v2upMG3hiwrQpSfZ1EmLvMCtFIMcb83fPMy55JFHauWs3otuGkeaCtOp0Wz1iRh
         3hdfoXIIeUo11z/7KpnpEfueS8Qzn4+NbqC3+StqCOChCppfowK3CKbCbc82Go202enJ
         9Nd48lkEYEIOSO5CZgMt3DBhT+tKdwrwvziuJP17X60F9bIEzJSmDc70ZeR71E/wiUI7
         4AshWyJBXFIybvWSaLWvdWCYX6o3k34AKBAjDbJCGUWSKAGu4r3o43NEQYFizEhY2dBx
         0FQw==
X-Gm-Message-State: AGi0PuaNFSZnInAGGEA96qGvGhPHu/SZVT3phCtu39N9kWIfW18RFoIc
        5Bus0/5ZkgH/fm942jvMJQQ=
X-Google-Smtp-Source: APiQypLuU5EpYjP+Gv2FpUFk/va8+YQ0rrdUK1dH+pmuwl3HBHGaugtvQnZuUnCIElYa1bc6sTWkbA==
X-Received: by 2002:a17:90a:71c2:: with SMTP id m2mr585634pjs.21.1588128969314;
        Tue, 28 Apr 2020 19:56:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3700])
        by smtp.gmail.com with ESMTPSA id w2sm16363634pfc.194.2020.04.28.19.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 19:56:08 -0700 (PDT)
Date:   Tue, 28 Apr 2020 19:56:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 00/11] Fix libbpf and selftest issues
 detected by ASAN
Message-ID: <20200429025606.d3qi4sqjd53ajb2w@ast-mbp.dhcp.thefacebook.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 06:21:00PM -0700, Andrii Nakryiko wrote:
> Add necessary infra to build selftests with ASAN (or any other sanitizer). Fix
> a bunch of found memory leaks and other memory access issues.
> 
> v1->v2:
>   - don't add ASAN flavor, but allow extra flags for build (Alexei);
>   - fix few more found issues, which somehow were missed first time.

Applied, Thanks
