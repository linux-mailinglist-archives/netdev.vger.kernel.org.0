Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C61249242
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHSBVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:21:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54112C061389;
        Tue, 18 Aug 2020 18:21:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r11so10825924pfl.11;
        Tue, 18 Aug 2020 18:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hOnLOGYOZw1L/Zs7Wk9HSyEEtRcxH8Pj0OI4BPHvc4E=;
        b=KB81QbuyIncm/RIkrN9jQDCY3p8F7gP5OAzdeRw4nVglGtyT/xGwsjZKnqIXNFrGnT
         VeAcz4Ab/0ddoKqd+Qb8iVjprZfPJpKTfiLaTgPEl/+4KIknNyRirDJ6A1kprA7QcWam
         2UvTUPqzmxtCQPEDidVMYHlWAnhhHSiDcubtYfwaCS1AvytjjeJT5ckIkv+auU0WzvgM
         GtHzBRuhP6onYGCc2Hi8AOanAx4F1Yc8YF/hkaQKTcES+8Xnr+gDVtw6E0ESBBPuoFD6
         VhMpLGrrc+HmKgFI4VL9qTHPLG1vK8IHPC6qEcvPCA3WeeYlaEU6a03tDwqnrORCQUEI
         ipOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOnLOGYOZw1L/Zs7Wk9HSyEEtRcxH8Pj0OI4BPHvc4E=;
        b=j6fRAOjvgR1zu2WXPhEl3aa/Zp+3FwGEXGjzq4G4IBLlLRM3Lm5ofS+5zwheCdSfri
         PZKdRPaidWLbMxYIEf5WVuipgDuCflToYBTHsFzy/AE38O499yEJmriZOp39s5SPZue1
         9MD8mwqWUtIEznl5vMh4rTWZyyOBm3aCLCb9cYV/UL8As3Tpsyewsn0uSQGO+V9Jmzvw
         ziTbMIuznP0s+x4FLkcduVjqma6RjEPcf4Z+KshQNyQ7zEI8wMqjR9rHLv1VkbnLzbTY
         FV6lAQnDTjqTK3c/r9m96dVts9nIjH/XkguRpVhS4idKgfveb2TCd62sPvEcKKfXjAe8
         cAUQ==
X-Gm-Message-State: AOAM533ztOJ4566qyWcpH3s3zBHHK/6KsAf63bLhl13H0lw+Ac32v+EW
        jrEa42q27RKdsvmukE42AJs=
X-Google-Smtp-Source: ABdhPJzoiwz3EYotI1mISiIEUcq8e1AjaGnsl9A26h9XJycUT+DFdZ/4bSNZsooxEk8Nduu3INTcIQ==
X-Received: by 2002:a63:1f11:: with SMTP id f17mr14650053pgf.217.1597800109843;
        Tue, 18 Aug 2020 18:21:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:20fd])
        by smtp.gmail.com with ESMTPSA id m4sm25381731pfh.129.2020.08.18.18.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 18:21:49 -0700 (PDT)
Date:   Tue, 18 Aug 2020 18:21:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/9] Add support for type-based and enum
 value-based CO-RE relocations
Message-ID: <20200819012146.okpmhcqcffoe43sw@ast-mbp.dhcp.thefacebook.com>
References: <20200818223921.2911963-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818223921.2911963-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:39:12PM -0700, Andrii Nakryiko wrote:
> This patch set adds libbpf support to two new classes of CO-RE relocations:
> type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
> value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
> 
> LLVM patches adding these relocation in Clang:
>   - __builtin_btf_type_id() ([0], [1], [2]);
>   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).

I've applied patches 1-4, since they're somewhat indepedent of new features in 5+.
What should be the process to land the rest?
Land llvm first and add to bpf/README.rst that certain llvm commmits are necessary
to build the tests?
But CI will start failing. We can wait for that to be fixed,
but I wonder is there way to detect new clang __builtins automatically in
selftests and skip them if clang is too old?
