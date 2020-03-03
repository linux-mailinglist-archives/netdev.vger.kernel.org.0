Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABC177E1D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbgCCRqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:46:42 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:36622 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731194AbgCCRql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:46:41 -0500
Received: by mail-pj1-f49.google.com with SMTP id d7so1668934pjw.1;
        Tue, 03 Mar 2020 09:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mKqq4Dq/2knBrrRTT38cYPAWcU0W4UDU4X0Ti778CSo=;
        b=LLXCx6/g+eu02nImuPysD0/43a++xJb/qqXbnH4ltGkuV2/ZzXvqa7H882z7/aNlrM
         WyVHZbFYtphK0s2/TTXqHCpKqqNxseOxXzG8Uwsz9ko9e5MA0aMFfUsx6+NPIlJejd8f
         YO/R/i6DJewDIMg3HDerZxvcIvvuOSRjSZ8Ci6LTEagnjy1rQwKy4nI7EFIxJ2P5lrrW
         v/pHX1BsSuuOWXlEAFYsrDUFA7I+UIe2hYdXI0mUE0HgAG/Y6KDHXhmPL5kfIK8MaQpz
         LTl8cemWezqdm3Y1H8zlz8ZZ0Twscp4lmLbQl/+fUVwdG9o0OA6yJ9llAxSsaTRwRPh1
         o1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mKqq4Dq/2knBrrRTT38cYPAWcU0W4UDU4X0Ti778CSo=;
        b=oIFpVTXRZlEeIWnmtxpY5XQXdlU9QkPpJFXcWuFWa56RsjcscbhI9TJb+NClubnIRz
         PNDruIIputelB/OSpjfLs2zVprnr4XZKKHweMAoKV2JPsZ+mF2/E1DPjlwdk8wfo09WK
         sWNysp8i8a30ERqcPYjMxm7dFVJHZCQfFDUgnd1CqyuVcQnVm3PJY40KmA58t13zxgKv
         69lA9swIUVBgnQaxXXikmt5wqC69Pb2Kb79gZSh8byMg1Fuy1WYB8WfDyYiC56LueQCf
         1zXtNjVGM1BIhhmSsjENbCrOZ5rdnlJeTA7UOoEaw1PO7pE37phGg8Z2DkHEGKd1wfDF
         LmeQ==
X-Gm-Message-State: ANhLgQ2fhd1jFLysb+nYOsgImAS9jDBx2iuhXe3ktOTRjVybKUdNbUF4
        8Wqej4xMTOYYNNvJDIBItRE=
X-Google-Smtp-Source: ADFU+vuj5cAPzI/h7WwN96+5oACwm8tdimiwivsVAllhxKyj+8PS/l5KfCLJhtIec7TEAPX3/VtiNQ==
X-Received: by 2002:a17:90a:be04:: with SMTP id a4mr5166108pjs.73.1583257600182;
        Tue, 03 Mar 2020 09:46:40 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d23sm25502795pfo.176.2020.03.03.09.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 09:46:39 -0800 (PST)
Date:   Tue, 03 Mar 2020 09:46:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e5e97f9676a3_60e72b06ba14c5bcbd@john-XPS-13-9370.notmuch>
In-Reply-To: <20200228115344.17742-3-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-3-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 2/9] bpf: tcp: guard declarations with
 CONFIG_NET_SOCK_MSG
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> tcp_bpf.c is only included in the build if CONFIG_NET_SOCK_MSG is
> selected. The declaration should therefore be guarded as such.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Seems OK, stream parser configs require sock msg now so that
dependency chain is already covered.

Acked-by: John Fastabend <john.fastabend@gmail.com>
