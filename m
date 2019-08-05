Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9B68254C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 21:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHETHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 15:07:14 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34907 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHETHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 15:07:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so82088687qto.2
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 12:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7cjTnczGibTn5rawmn2M5/3asBx2IS8dQHs17OVk1sA=;
        b=nbeDjZAShpBCPI2LlGcw9MTzZkQY2ZZGBKnLu+AGbiQI+Gs1Kaz5u/KQBShQpTxIwh
         jEZxP6qrQUG701KX25F+bRs80Yh70EZL1gTbTY55rXHNUdwuhMtly/N6xnDUqvcEIRS9
         jPmQmkWCJoyJazZ/b13waoIuULfoiJsxwXbk3M9iffLp8pFSAfgq4J9WySPCdIEaHPbc
         Yh3krCIqR7oIipvxZKHzdO+F3TRWmvzXnaF3Q9R08aXyV60mScr3hBRuo6/P/CstrHql
         bEelg+9QXnmHzKdcYZcnMGoJoEmEtOh3cwEhMvsfXdI1VDe3Q/McC7RW+p1FWa0wYuMH
         z0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7cjTnczGibTn5rawmn2M5/3asBx2IS8dQHs17OVk1sA=;
        b=KDaD3yNuM+NPL2mCmn0pzwA2XInuIJou7415racv3Fry/n1K0s54Sx0a4nCwxlUprY
         QOtTH9QDhRHr4v117J8WEr8K5f0E9GAm29o79qf9DLOECXlwKVs5jtx5zve0TX8EGDFU
         itTyy9/i/g8rGCfg0mxteMn9JVd5j2FAsyJkL11GgB4EcnVlMJs3sEFd80aBXYj/Nn8s
         JVkgfgWKwavG3rUrnD4iqf61n7PWDHILlATXRKqPkiwwDMJ0nrNGm4/rghHWnI+seoQf
         VKEmRWZWdEbUQUJIHHTAoRj+kNfn5wrEP4Eok70gplIlPsUyh4sqGVsDa+3gFWv69Hx/
         IfdQ==
X-Gm-Message-State: APjAAAVgIJFeMh4rFKRALm02qhC2suXL0PhJl4IEnHmAz0FRa6a+Kvja
        f2e2E3T0h/a3GUqgLNkZuOymhA==
X-Google-Smtp-Source: APXvYqz5esywJ6Txu9kqdNG1tEVUBpHa4d5a3kw3izRb/woN6WLyN3veThRQEuiOzkceGBNgX+GgRw==
X-Received: by 2002:a0c:89b2:: with SMTP id 47mr110360311qvr.203.1565032033308;
        Mon, 05 Aug 2019 12:07:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c5sm38695126qkb.41.2019.08.05.12.07.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 12:07:13 -0700 (PDT)
Date:   Mon, 5 Aug 2019 12:06:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190805120649.421211da@cakuba.netronome.com>
In-Reply-To: <20190805152936.GE4544@mini-arch>
References: <20190805001541.8096-1-peter@lekensteyn.nl>
        <20190805152936.GE4544@mini-arch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Aug 2019 08:29:36 -0700, Stanislav Fomichev wrote:
> On 08/05, Peter Wu wrote:
> > /proc/config has never existed as far as I can see, but /proc/config.gz
> > is present on Arch Linux. Execute an external gunzip program to avoid
> > linking to zlib and rework the option scanning code since a pipe is not
> > seekable. This also fixes a file handle leak on some error paths.  
> Thanks for doing that! One question: why not link against -lz instead?
> With fork/execing gunzip you're just hiding this dependency.
> 
> You can add something like this to the Makefile:
> ifeq ($(feature-zlib),1)
> CLFAGS += -DHAVE_ZLIB
> endif
> 
> And then conditionally add support for config.gz. Thoughts?

+1
