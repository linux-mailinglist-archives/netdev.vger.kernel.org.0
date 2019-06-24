Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204CE518DB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfFXQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:41:15 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44455 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:41:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so7193986plr.11
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j7Sawi1kc5gYRUKaynak0j6G71npq2/vXcGkbHXZK6Y=;
        b=eknxKsvzHLVYOwCz+WTWvjS+XNBbkze6faXyHR6VSCpTrVfDsPL8gvOjc/XAH0D3Hr
         /HNi1ojdteSLm9rnBAxTF2pBbDMA8mkmKDWwyAVyq7SYgzu4qfovp1Hlq7F9rB751/xT
         e152rIJ3bKtojKJg9v60zAhMv2r5QOGaAf/pb7VgV2mLkKoaNFMHtc85h/91Sp2m/YpW
         jZnczHVZds1q+0RQaAvW5Oe80ojn7cORzuVEb0IQyv/PxqS1QvLcXLbejsA6QQnfYtFo
         hdUHcyh1SlZYZ8sriLcrbElWBavodMsJX3v16SCG/P7rfWVmz0ng0NiswYnjiiksA1R7
         X7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j7Sawi1kc5gYRUKaynak0j6G71npq2/vXcGkbHXZK6Y=;
        b=SBtSl9qx9ea9IgQ8I5VrvIeqw5UNEHeA22TTMAsOsTb1vRJ8OrmSli56OAAPr9Z3wN
         2Q1BvoIgYf7JnERiktnGxXQADPiv/nN9Kg02k/h5rXj+rCtS53IvEzNJaGxdKtENwLJV
         STOuzXUvUpGiAWwtVbhEQ7MKe58ND3hIJQj5bORmHKHgf16S3eVRRXiWvmaUEp8/V7he
         3OSlqUiAhe4myo5slzPf8vyeuceOlbFWmJsvSHwoqXRDv09XOVLfjvHm8ulnwq61rDcz
         7PCM8lxNOaD94KNbSYGHJP8K4FEGzYNykyZEKLsgq/VM2oY8bBw8PvBcTI1IGJAbOm+R
         S5Yg==
X-Gm-Message-State: APjAAAUaz4IV3WVXAxa/e1sycYSC1tD+7eOQ3sS5Tf1pZgrFfa9fDFZx
        nXlCC4HtF7O/sstXDHiGARnQKHdW+f4=
X-Google-Smtp-Source: APXvYqwM0qXOi27rCK6uvtibxMEWgURR1JWHGO2Tbnf3R28+ax0wV3JE7QPfA0JcDxR9az3EWFCtSg==
X-Received: by 2002:a17:902:f089:: with SMTP id go9mr79658921plb.81.1561394474605;
        Mon, 24 Jun 2019 09:41:14 -0700 (PDT)
Received: from [172.20.181.193] ([2620:10d:c090:180::1:73aa])
        by smtp.gmail.com with ESMTPSA id l68sm25029pjb.8.2019.06.24.09.41.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:41:13 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     netdev@vger.kernel.org,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup
 in eBPF helper
Date:   Mon, 24 Jun 2019 09:41:12 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <B5115F94-B2CA-429A-BEA0-6A7EA1F6A522@gmail.com>
In-Reply-To: <156125626136.5209.14349225282974871197.stgit@alrua-x1>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626136.5209.14349225282974871197.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jun 2019, at 19:17, Toke Høiland-Jørgensen wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
>
> The bpf_redirect_map() helper used by XDP programs doesn't return any
> indication of whether it can successfully redirect to the map index it was
> given. Instead, BPF programs have to track this themselves, leading to
> programs using duplicate maps to track which entries are populated in the
> devmap.
>
> This patch fixes this by moving the map lookup into the bpf_redirect_map()
> helper, which makes it possible to return failure to the eBPF program. The
> lower bits of the flags argument is used as the return code, which means
> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>
> With this, a BPF program can check the return code from the helper call and
> react by, for instance, substituting a different redirect. This works for
> any type of map used for redirect.
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
