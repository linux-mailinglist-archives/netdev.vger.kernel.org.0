Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251397D12C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfGaWcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:32:09 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41306 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfGaWcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:32:09 -0400
Received: by mail-qk1-f196.google.com with SMTP id v22so50449813qkj.8
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hge73k4oZKuYPScmd5aYHU82prGHQKIJnS5yCT+PDa8=;
        b=gAcq3NJRZ7sdMa5wCXP06TK+lnz55q4X9YMbczTfSyNuXL2Zuup9790lK6fy35QwjT
         475oeAp+OpZWKt9bB1XQAa2P7szx7kmSDp8DN+nX/3+nBAxq1xJBz7ErQxwbvqIg1hAp
         BrlelGtwwndgXyJaGQ3wDIcGAYCDmvW97CUvv7UpgYAuO1oqUN6IuoXYaeULDFGjtbXy
         Kv4k0K9vA8L5pX5F1GAZ1Eeifoc4MJo5zkRt8ArY6V9PsESCRugUZ5IjiL18Qr9Zd5Hd
         COs9x3rawb2KinmsJ07DYAh4vTXNVEKGMT2OiCK1t/3Cmm2DxoaME6TDrMUUeLsJSDnG
         C5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hge73k4oZKuYPScmd5aYHU82prGHQKIJnS5yCT+PDa8=;
        b=TbZT0jI/p0TJ3gnTKVc7/CEsaGI2bIgdD+JcNLmHh0MkFyrDS434/XnnisTOBxM+G5
         MXyvhHl0Jz8zZAvOkbvytfMvHjGj6aJMGjcgQ2hdUhoC9zbj5P2cjg54vVkKbe9UQ40A
         td6aF6ST3/2vtWUUegvYnWUXru5nWZznBfblxuhuJ7vF48pHu8nyXCaPra6Ljsuu/FoZ
         Eqt2bUvWW30OPtLnCgSFcCwU009rM4f0x+ympDuoZOoyJYC+W62pEVkUztdi0kEpkJyM
         yWtCB50AYR9vYP7AOEO6OHLU4WMHYC/7E9uztNCBzhyBTEatThR1eEK9gQT40QqTasV0
         04Rw==
X-Gm-Message-State: APjAAAUEXvTUTj3yYFVKgg0a7f7mn9+VqcSQumeUQLwW6Nl/s+D65nvY
        e6+AyVyO4lz2UWdi9jrP+BwcId+c7v4=
X-Google-Smtp-Source: APXvYqzxa3CcVUiGaO3csF0HNNA0b9m7XQ5vIjQQepMJ8vtfjRgIdNKXf4qn6juQPGPAcbEbIfd02g==
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr79641940qka.138.1564612328328;
        Wed, 31 Jul 2019 15:32:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q56sm35338498qtq.64.2019.07.31.15.32.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:32:03 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:31:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <rdna@fb.com>, <kernel-team@fb.com>, <hechaol@fb.com>
Subject: Re: [PATCH bpf v2] libbpf : make libbpf_num_possible_cpus function
 thread safe
Message-ID: <20190731153148.2e8bc1a7@cakuba.netronome.com>
In-Reply-To: <20190731221055.1478201-1-ctakshak@fb.com>
References: <20190731221055.1478201-1-ctakshak@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 15:10:55 -0700, Takshak Chahande wrote:
> Having static variable `cpus` in libbpf_num_possible_cpus function
> without guarding it with mutex makes this function thread-unsafe.
> 
> If multiple threads accessing this function, in the current form; it
> leads to incrementing the static variable value `cpus` in the multiple
> of total available CPUs.
> 
> Used local stack variable to calculate the number of possible CPUs and
> then updated the static variable using WRITE_ONCE().
> 
> Changes since v1:
>  * added stack variable to calculate cpus
>  * serialized static variable update using WRITE_ONCE()
>  * fixed Fixes tag
> 
> Fixes: 6446b3155521 ("bpf: add a new API libbpf_num_possible_cpus()")
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>

Perhaps we would have a little less code churn if the static variable
was renamed (e.g. to saved_cpus), but functionally looks good, so:

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

(FWIW I think Andrey's comment does not apply to the networking and BPF
trees so if you respin please keep the changelog in the commit message.)
