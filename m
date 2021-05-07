Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB5376472
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhEGL26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhEGL25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 07:28:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8243C061574;
        Fri,  7 May 2021 04:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h6CvEcH6lldBrL2qLaHVXZy3e+T1NuPGpyfPejetds0=; b=Qw4zqJpFLXiQznZE5OIje3iLqG
        CbDZq8d/AP6HJwb5i1uHSBYY4f2FopWSLv7vnxc3M8sKVrirNyrWLLRoIVUcOqsV4iQsCO9Jj9Rva
        p4eHXt3DK25broDK4Leypw5Au9ahUm28GiF8Q4kVaH5zREKLrpIEs/jQ1d6ucXey7hliD9B2shx83
        fMUVNtyPXpke6wjcNhi6bD3/+zIQnWvlLFHjHqwr7/L/vCXWLGK7sXEFzNUdxDXXeSPFj6sLoRC0l
        AlxeY2gTzTg56w8av0PKdjgnTeTPg4Pj3A4AWybav1cH7va74YPYqgr1ma2tLIZaep2xFvz8xauBq
        H+pzBdRA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1leycw-0037m0-6f; Fri, 07 May 2021 11:26:41 +0000
Date:   Fri, 7 May 2021 12:26:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] sysctl: Remove redundant assignment to first
Message-ID: <YJUj7glesit6HnF6@casper.infradead.org>
References: <1620382554-62511-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620382554-62511-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 06:15:54PM +0800, Jiapeng Chong wrote:
> Variable first is set to '0', but this value is never read as it is
> not used later on, hence it is a redundant assignment and can be
> removed.
> 
> Clean up the following clang-analyzer warning:
> 
> kernel/sysctl.c:1562:4: warning: Value stored to 'first' is never read
> [clang-analyzer-deadcode.DeadStores].

While this is true, it is incomplete.  The 'first' declaration should be
moved into the 'else' arm of the 'if (write)' conditional.
