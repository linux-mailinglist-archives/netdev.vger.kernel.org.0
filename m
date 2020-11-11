Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C007D2AF032
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgKKMAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgKKL77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:59:59 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F036CC0613D1;
        Wed, 11 Nov 2020 03:59:57 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j5so853548plk.7;
        Wed, 11 Nov 2020 03:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YG3k/Ch1Sdw+uavjdcAB/2hmEdU18S9da0aZgB1LC9w=;
        b=OJHd8YW0FpftupIEkMr5q2hWOjHUIUkUVjPdqzOsoK+gEcfwxjqDaR4opGRZUjlRBt
         mUB/rxV30Y1YPDGMceexC0nOjVEAil/uvZXc1UWLzAlOzQAep0gs/uFwryrBwGpPBkSW
         7pAyK6f3iIOTzngwDN/MVdFRVG6+nWzxwvxv3JpmYH6gvPiiYJJXSMaisCrqo7zY0eW8
         2iyUSQ1zWIsBlwhG3vATC1pfJchMidRYWHn441RGMOgWqDUcP1sT/zIxM4VPz+r7UoOE
         NghtPulrqN7RZW+knhUE6NtJpb5105TsH6Z43/ri6z5hUC4FcHU4qnQS0idP6xPh8W7q
         asnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YG3k/Ch1Sdw+uavjdcAB/2hmEdU18S9da0aZgB1LC9w=;
        b=MutPkmOj9pK+o4BZkL3h1ApPplkh5SyLTcI34RfRHhZ3sZr3uv6MFZFcBanq2qRnpV
         vcdUPvn2h1d1OLZt1q01zgFG747ifFLhfbFaV6ingov+a7sE8+KQP4Kh840q3KdGFTpC
         hUiIfeTemlWrnv62FHk3U83f9n2Y2MwL5axkYUUC+ktgEkF7NIJpvg+6h0daCh+DGeEN
         k+96CTLVX9rh2ZMaRgQwMOvqD1ZVzmQA6J9mjLqeBD8GfBcxhtKOI7yMdeuiTt/9t3m/
         xgMTr7MxfLBBT8Af+A3l/Co/VhpXI0qRZWzlYLSPmHLAGnG9WYxThH/oZzS2/9Bn8Dbn
         VgMg==
X-Gm-Message-State: AOAM530yM/4MiF9tjY+US/l9GfYPrxd8wZL1D+iWRYtjAPvX0YHEIpR+
        znPGEt1AaMqDidGYyxh76/qjRRjRBPA=
X-Google-Smtp-Source: ABdhPJwHCwzahRYlvg9leJNmM6crNS9xUmSKCNr3s+uaWuL7VduVqcThUl2x+1ljmLUErQAQhD16EQ==
X-Received: by 2002:a17:902:ec03:b029:d7:c7c2:145a with SMTP id l3-20020a170902ec03b02900d7c7c2145amr19964453pld.33.1605095997559;
        Wed, 11 Nov 2020 03:59:57 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:8a45:2db3:e80c:6ae8])
        by smtp.gmail.com with ESMTPSA id v18sm2365289pfn.35.2020.11.11.03.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 03:59:57 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, xiyuyang19@fudan.edu.cn,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xie He <xie.he.0141@gmail.com>
Subject: Re: [RESEND PATCH v2] net/x25: Fix null-ptr-deref in x25_connect
Date:   Wed, 11 Nov 2020 03:59:47 -0800
Message-Id: <20201111115947.3498-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201109065449.9014-1-ms@dev.tdt.de>
References: <20201109065449.9014-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -825,7 +825,7 @@  static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
>  	sock->state = SS_CONNECTED;
>  	rc = 0;
>  out_put_neigh:
> -	if (rc) {
> +	if (rc && x25->neighbour) {
>  		read_lock_bh(&x25_list_lock);
>  		x25_neigh_put(x25->neighbour);
>  		x25->neighbour = NULL;

Thanks! It's amazing to see we are trying to fix the same issue.

Reviewed-by: Xie He <xie.he.0141@gmail.com>

