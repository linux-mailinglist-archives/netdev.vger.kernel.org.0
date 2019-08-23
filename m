Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3379B4C4
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404078AbfHWQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:44:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43233 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbfHWQoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:44:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so6799812pfn.10;
        Fri, 23 Aug 2019 09:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlvSVyIr1tgVMhGcIYR91DxN0Bt71BnSTRdgs1u9xec=;
        b=onPpkDoziw7C9XMKlwo7WbgTRYFhYdzifAn5uX3vX9sSvFDPZUhIlWAVO0765v1l3V
         xsYubW7HYF9u1sh/AUHh7b5qLLKdLaY2RSNPbRfQHZoym3C5Jdphk5k/ev+WNrFnR4iF
         hR79AfBxvl81uUtLiqZm8/RAHzW0yMCZB85YHhTj1xz3CVtdyRpAbvzQnucGOVb/mHpj
         FaH8yiPlVARAlySIHOpGvoOlJ1drwf80ZQLx/eSOfaCgWKJjg3ZDvd8Gk08SCnEhPrQl
         fyHsrOVWn0ZT+5AqUd0jNgSE8hKrz6iVG7lLRgmjAg+T7UcpcsYfAtD34kGRDANdWLCW
         Gedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlvSVyIr1tgVMhGcIYR91DxN0Bt71BnSTRdgs1u9xec=;
        b=ONqhaptHFgcJtOjuXj3noE//wXNKB9cfp4hz2telw1S0eShuGnYsa7EpvQ+piFqla0
         m5bxNuS1id1E7T+WzV4hh68yZiPfR3ORDfPa4lPzlBRFL3OIakNoCYzf71+k3WjZXeKe
         KNHS1RHp7vsGLA02ONwPC687OHxvYDhYoCINLrAqCBAo+t++eoqbXmYlH9r5c+XQOso/
         +eo5xX8WKsOzqq+ZkWo+UugrwuIyBLrPWEqrvWQYsvPAgCkfbD5Tk/0IfR4XfoMCdz+E
         45Flg0h453/iYQV8i+j1yxIYRn7selOw2x8rY8qrEcOxOLDiwUanqOBvdTW7w3ntZkDs
         n2ig==
X-Gm-Message-State: APjAAAWrn827JG83kY3GJhIufvx5iytVbBZE5WFS4k93j3tpRsiYxSV8
        QajiCvPjr8nEJqMn+tI8MYE=
X-Google-Smtp-Source: APXvYqzh/SFe/hwZCCaTKuawKyFR1FHLm4nsdun5Bnr3InP4iZnskRMkRQHU8EWGH+4V4/aPstVFKw==
X-Received: by 2002:a63:de4f:: with SMTP id y15mr4931568pgi.239.1566578676742;
        Fri, 23 Aug 2019 09:44:36 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id bt18sm3017029pjb.1.2019.08.23.09.44.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:44:36 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next 4/4] xsk: lock the control mutex in sock_diag
 interface
Date:   Fri, 23 Aug 2019 09:44:35 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <97BA2A37-F69F-4D47-9CE4-8B327D619B84@gmail.com>
In-Reply-To: <20190822091306.20581-5-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
 <20190822091306.20581-5-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 2:13, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> When accessing the members of an XDP socket, the control mutex should
> be held. This commit fixes that.
>
> Fixes: a36b38aa2af6 ("xsk: add sock_diag interface for AF_XDP")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
