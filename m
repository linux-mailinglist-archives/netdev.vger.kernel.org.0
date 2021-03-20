Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35433429FC
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCTCWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCTCV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 22:21:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C042FC061760;
        Fri, 19 Mar 2021 19:21:59 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so4893059pgl.6;
        Fri, 19 Mar 2021 19:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UeuAaIBGA8jKmjKUJQE3ziPleqbcVpxH0mTyWYs0tAY=;
        b=Gj2JbxMU9mRFxaIGfvAq4V92pJsEmg5IqMB+Fh5GAo69X6xNT5Dl935UIELeAmgad1
         hMVgB/4iS7nLtCtgf5fFb/T+M4/2QFyIg9PXbxsRuYbC+U20/aWkzgKTLMMisSgUxmfb
         hyJ1jozlBBxU8kV4fAbLpnY7OxqT30tHJdsJeUnVoVGYeZE9FXej/6/Sh1nXRibid+3U
         Up6/s7nQNok2MBYnSiix8kzpyA2sswfJ+VcYSPBlX2G3NaCbZk/mfSLSZMATTexImY8t
         nHBb3QRKRRZDCrg0mvsocAMjTlr211YcmhNxiusB9kM2wuapXLioEU+VNW/0rEQMfzWB
         p2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UeuAaIBGA8jKmjKUJQE3ziPleqbcVpxH0mTyWYs0tAY=;
        b=RqKZdmdWwTtCMTQrjCgf4NPc/BDqG2LBFsm6S1DwPT+oYvn21H8sLmHr37Cb42FPrl
         YcabgXPBBZ3U6Rmv7I0d2zcKcLEflqeOn5V2vcmx/flZsYniRFO2KqG/0SuwYLAX+Pqw
         6q++3Xv0TsVI6lY/Ykn0c45wl8OFYAXbZOJFHoC4PVNqDYfSHiXxpUOHk0pgZJve0k+s
         mF6f1kKN4EGUntRw0EGqx7PVeP7qnWndVB3m0wzOtDYosLtpcZOzEPJHoRJeB/AXkDQD
         /a/BUy575mCn3UxegtXZbP3QP8KFVYnVIEzyXV88GcSbEgzT5EVDZykdmkkb2DJ/yqbE
         V4ZQ==
X-Gm-Message-State: AOAM531BsjufTotfoeLwHr9JGF5Si/kGUP78f/Q3dO71gqPpy6/5OlAi
        YzeOpqgrdvIlcBV6qYKq34Q=
X-Google-Smtp-Source: ABdhPJyAVjJc6wUkwAqGly8OAp4vGDSLpmxtsuQpG66hL0WBOfJs2puTBpyjTOu8zpjN2Ajh47YZ2w==
X-Received: by 2002:a62:2b85:0:b029:1ee:e2a2:cbee with SMTP id r127-20020a622b850000b02901eee2a2cbeemr11602420pfr.78.1616206919226;
        Fri, 19 Mar 2021 19:21:59 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:343d])
        by smtp.gmail.com with ESMTPSA id w203sm6600647pfc.188.2021.03.19.19.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 19:21:58 -0700 (PDT)
Date:   Fri, 19 Mar 2021 19:21:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
Message-ID: <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
References: <20210319205909.1748642-1-andrii@kernel.org>
 <20210319205909.1748642-4-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319205909.1748642-4-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> Add ability to skip BTF generation for some BPF object files. This is done
> through using a convention of .nobtf.c file name suffix.
> 
> Also add third statically linked file to static_linked selftest. This file has
> no BTF, causing resulting object file to have only some of DATASEC BTF types.
> It also is using (from BPF code) global variables. This tests both libbpf's
> static linking logic and bpftool's skeleton generation logic.

I don't like the long term direction of patch 1 and 3.
BTF is mandatory for the most bpf kernel features added in the last couple years.
Making user space do quirks for object files without BTF is not something
we should support or maintain. If there is no BTF the linker and skeleton
generation shouldn't crash, of course, but they should reject such object.
