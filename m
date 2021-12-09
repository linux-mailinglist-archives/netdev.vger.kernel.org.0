Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7B46F4B5
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhLIUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLIUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:15:23 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE36C061746;
        Thu,  9 Dec 2021 12:11:50 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id m5so6436251ilh.11;
        Thu, 09 Dec 2021 12:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jhNbB4rDt46/vNR20BUcm1keb2g9oWDbx+OdCeHWbOo=;
        b=e9IUkhPYe5RAaEaUIWGaDfVh/4yAJ1rQCH4qEQdpgMtcwgUZRybbkKDp6UGUahxZEt
         KqfRUbwHHUdZOFWkS6sZsKRKZ/ouRKv3nSoPrX6Ndxar/OmffkYmBemhSjEOccaS7xlL
         sHxLtwp1+uCQ56WFtUspMt1mnzGubwasHNWm8TQh5UifzH2EDKLk2xk5zOLfHJNOcWZs
         5FcarRyQqcJoYN/GnMlUyer4Z3Q7oJkVg1WI2ACqItqqZvaAWuj1gatgy7x3VVk0hGJ9
         Ua1Ig6Md+D7pGr5RMN79YbVQ69xATw4GVVr7QWX/rDB3p1k9sjKwj5whJnlXSDcHdfq9
         kXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jhNbB4rDt46/vNR20BUcm1keb2g9oWDbx+OdCeHWbOo=;
        b=QXS6tSp7d39fVFbNoE+LlMCUnEybTjuNZMcXlS7tVtO7W3c9qQsL94JgdgN+BNbnO4
         fjNwWTnaVlmEOzq+E4jgBut/8CmhTSUmj+BFrpFq39Rh6pmpZlMDIFvqYa3LOwzHQ1Ob
         JZEQ3fftQA/KiIZ+kxKZ3Wct/C6I9H3M6vrzIyp7P4CcYWp1/QlMGo3aDjf7C6fV43Nt
         gGSF+iqXXx4o0T0ZyS0u/DQq3Qfj9Uin4QZjIxDAMS79RtnovYXtws2/3jrjj2fNqYlx
         lElO2Xi5004nx+CwEiwksJeXBJNGkPDNuyv2QJILF/bwY5PKJVbUAC7JUCL13KPi529H
         nfiQ==
X-Gm-Message-State: AOAM53236SEXJtWHaTq/2ikvDIYLqUKQHYVYuc3uSp6w4ByJlRJihbZo
        HTIXzhuIPZVwKCpYWT9L534=
X-Google-Smtp-Source: ABdhPJzX27xhz29yO+dD2yqhnLPwnYIfrew0szECcVJecGrRqCGTck3NPERGeDW2ZJWDO//VDUzijw==
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr17051496ilu.310.1639080709662;
        Thu, 09 Dec 2021 12:11:49 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id o22sm555979iow.52.2021.12.09.12.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 12:11:49 -0800 (PST)
Date:   Thu, 09 Dec 2021 12:11:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yihao Han <hanyihao@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Message-ID: <61b262ff77868_6bfb20865@john.notmuch>
In-Reply-To: <20211209092250.56430-1-hanyihao@vivo.com>
References: <20211209092250.56430-1-hanyihao@vivo.com>
Subject: RE: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yihao Han wrote:
> Fix following swap.cocci warning:
> ./samples/bpf/xdpsock_user.c:528:22-23:
> WARNING opportunity for swap()
> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
