Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FCB2CDDBE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgLCSd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731626AbgLCSd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:33:27 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420AFC061A4F;
        Thu,  3 Dec 2020 10:32:47 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b10so1871735pfo.4;
        Thu, 03 Dec 2020 10:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2TfCXyDchUz9TycwEcuS6cS7AaZIiVS2ius4r0dHDq8=;
        b=P35N3lCWaogrMVCaXzqMi5DKbjvhZI7qj+hyS6w/kuoXpbo4voiFZzaKiRhiaOh7iV
         Wig2NSjEhkPBzCYMuQ33rEnNs3wnhBWy+rCVf3b1NBWFRfg++yZXcLk56SMtySkjxEkS
         OcdfS07jdssMsB5BW2UYpZJ51lfjttAALPRoxbV24i/8BjsQCGhiMFelGXSgCqFjpuKK
         D64fMSo/k5M3TSBTPldqIQVNhvF2Xo3GEqqRmowyQbPYDZ0LG5LpKWbVFUp6knjp6aYf
         J+w2od0ugotnyr2b3tuiFyBHdPpBJ4Isw6M2RSideFVcKyWrsuQcTSqBe2cn9L7Z3GKM
         pwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2TfCXyDchUz9TycwEcuS6cS7AaZIiVS2ius4r0dHDq8=;
        b=suePgUO/rPAUxXzBRzxobE6EcWjKALsE3CHEGYcja7HIiLAcxwV865uYMuPU/3/FbG
         xbZUa7M+4VpSOnhIKkMhUhT//tDHxlwDDCZHwXMi5sp4FGNVfcn/EY8PfDN/L91qTMC8
         qEd6JppfZnX2tCI7L9UMNGNQCTUABhig6bwBJENMI/wJ742NoAEpJhR+r+SMBUB6U3FO
         fWz9/9bQ3qcdz7m5ZQu0MikWcveKxVqzw9jT11wndKgLI4+uNt8QAFxkKkVXAmectYZD
         hVMBNW8vTqM6sASS4LIooH2eYmFhDxhFSe9f4p7Ob7WoatZSR+vev/rpSsfXVbqhLWB/
         Ipmg==
X-Gm-Message-State: AOAM532c8YzzTFx3CPS4sKYYWK2FDJct5xZk6vHUIkwLTLsziZMQfwsn
        9d+qy8p2c8G+mFc3Ak5aRAw=
X-Google-Smtp-Source: ABdhPJw7wx5/+grSMsWIBs01kXAfJtJGNVjneeBfKb1YxePqGwDQK/yt5avOS6aJRMmrerbbjT+WRg==
X-Received: by 2002:a63:2026:: with SMTP id g38mr4131553pgg.30.1607020366874;
        Thu, 03 Dec 2020 10:32:46 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a629])
        by smtp.gmail.com with ESMTPSA id x16sm117362pjh.39.2020.12.03.10.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:32:45 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:32:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 0/3] bpf: expose bpf_{s,g}etsockopt helpers to
 bind{4,6} hooks
Message-ID: <20201203183244.5ws5dorn34q3gbtl@ast-mbp>
References: <20201202172516.3483656-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202172516.3483656-1-sdf@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 09:25:13AM -0800, Stanislav Fomichev wrote:
> This might be useful for the listener sockets to pre-populate
> some options. Since those helpers require locked sockets,
> I'm changing bind hooks to lock/unlock the sockets. This
> should not cause any performance overhead because at this
> point there shouldn't be any socket lock contention and the
> locking/unlocking should be cheap.
> 
> Also, as part of the series, I convert test_sock_addr bpf
> assembly into C (and preserve the narrow load tests) to
> make it easier to extend with th bpf_setsockopt later on.
> 
> v2:
> * remove version from bpf programs (Andrii Nakryiko)

Applied, Thanks
