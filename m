Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB1217F66
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEHR4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:56:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38205 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfEHR4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:56:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id j26so10468017pgl.5;
        Wed, 08 May 2019 10:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nFxXslKvWpp3K6okNpeCRSwS8L+nir0+n1sfLqCOHSw=;
        b=oUaS2dxg+qoVY/RDq+Cz1xa6K4ladKQxRBz6jkVwn5y8XtQj4bAAlkLmKC4h9cDNx8
         UVzEwb1NZOj8GG3/UE2udg7pI7jvj/dksIr/8DoPg6HS8qFsgJFSQzosMEyhywY/GhLi
         BAaZqPkXuhMsFLWQBm1/ZNHKDsMitiWSxaxse9b+xK9GNNLbFKWvST24PXincaN5ZXxP
         7CknyJeBtHjgqXY6N7bJdcxWVOCQYM+SFi0GBJaBPNPMMwInjNX/LKhetbpW0qU8cOI6
         dw4qOimJfjm0iCNPJ2ms1I0ceeZKso7ls+qmRsrTO1y7l4Ap/QYvusXGR5jXIWNsFLbk
         VRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nFxXslKvWpp3K6okNpeCRSwS8L+nir0+n1sfLqCOHSw=;
        b=uIw0WrM9WO2Xr5sZAt0JBOUeZNQOlItVuUjp49j9huR4BRp8qwxw1WQw6gEuCM7L9h
         dnLYGOVo4LjrNNkJHsYEtEavDp7mtG/VeKhEBFxZLFvTLT3LcH+fNs15K76NBBLvTFaa
         Vx0UJfrhSsiSrO3B04j0zPAqmoHzSIVt5yrnUEYraM+UqwiowZ27bZdm8bvXU5hboTF/
         iWG9fhuS02MCnLztGzhbhqJfeBWj4EwjHe2ctdXsHNFOn0o+WHlyMu/8cvONFyLMrQFm
         13LngeH349OZn0hAIJ0Te3edAvaxJiOfPZ80MuthN85VzXsWzcmZRkwU/xwRDK+QWFi5
         sChA==
X-Gm-Message-State: APjAAAU6sBsO59MpieLcfGB7GHbCexDdgsGO1jZZ+73uLq/Sfgduzy+1
        hErT7Slhec0pmVMREKpnMdw=
X-Google-Smtp-Source: APXvYqxHRc3B8ZkMVFJvaVkHJB6JQHdynDU4WXGexRDZ7CIn5pJPz2gzS5TkE+5Po8gnLKawh53lVw==
X-Received: by 2002:a63:6b49:: with SMTP id g70mr48834304pgc.176.1557338207709;
        Wed, 08 May 2019 10:56:47 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::cecc])
        by smtp.gmail.com with ESMTPSA id p2sm41692428pfi.73.2019.05.08.10.56.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 10:56:46 -0700 (PDT)
Date:   Wed, 8 May 2019 10:56:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
References: <20190508171845.201303-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508171845.201303-1-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> Right now we are not using rcu api correctly: we pass __rcu pointers
> to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> Instead of sprinkling rcu_dereferences, let's just get rid of those
> __rcu annotations and move rcu handling to a higher level.
> 
> It looks like all those routines are called from the rcu update
> side and we can use simple rcu_dereference_protected to get a
> reference that is valid as long as we hold a mutex (i.e. no other
> updater can change the pointer, no need for rcu read section and
> there should not be a use-after-free problem).
> 
> To be fair, there is currently no issue with the existing approach
> since the calls are mutex-protected, pointer values don't change,
> __rcu annotations are ignored. But it's still nice to use proper api.
> 
> The series fixes the following sparse warnings:

Absolutely not.
please fix it properly.
Removing annotations is not a fix.
