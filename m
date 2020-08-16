Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE32459F2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgHPWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgHPWsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:48:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCD9C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:48:50 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f10so6564411plj.8
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VM0H+i2XPK4MbOrtTltmOP8Bs+Atjze++mkZMKipU7g=;
        b=tHsurezvrPAhLHzJibR3lzC5sminKYWguVd4x9uBXKejD/JkMVMqwzrULatW4Mb2Tm
         RrLcga1/68JZmRy71Cqd7wm98F2qopQE3Nkvvb+eUkjHFdKdoCeHHWJx2M7qkG7MErPx
         /VeYha0sNvJIeOfYy6CKcBOY6g6WlU9ntC1RAiSgAwj5KYCJR+hdSMk1e5zzogsSb7m5
         dMyRnqYHrl4qANysJ6OpLvTvZzMatEy/Tn59Ft5vlIvQXWCpLvdDuCvAnQCUzAG36lfg
         dIsLcD5EPN7GBdq5QbgwUoks28746HB7y53nWfPfW/fcN5S4wGIqw2VMQLtuPoHVjPsu
         sS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VM0H+i2XPK4MbOrtTltmOP8Bs+Atjze++mkZMKipU7g=;
        b=HS6GJo7YRzareqV7YzNly2I+1tM1TnxTzxgZJT1JLgcttQ/J71EXe2hosj9eXXLDf/
         WroQQib5Ys6hJthwyg+DIR1pqj+oGz7HzhzzGNel/pAu1p0SmKv2nJRfZLqyXlk4PdDF
         ORVTnGjeH051ukFkV0FYSrvQJgAiddvhoNbFniixgGxEo36+iBcEwkbMZPZcZcwkWRDJ
         0sFR0jwMmsQ5LlllnxU4O5V3Qd0qFnSfu/rq4HErM/ZJuiyjXtF4npFXR3OEZtas3SOJ
         3BRLROXT1J/sMvYYgeIo06QwdcVBw/4pnIEPNe+3Z/wuFQfsMCAza7zp75CplTvjymbZ
         SjFA==
X-Gm-Message-State: AOAM531cnaqacmzJnvX/AlQM2nMoxR0xK2h2qARr79tsOKamHHSrZISr
        wW9yZrXuXLGhEyZRdsrf3mfGNw==
X-Google-Smtp-Source: ABdhPJxhWmxI1w1SrW6VWm5XsMpqlgCYk+pveH+UsRghTcv0V5qXw0PZuZ5NuerZyscUv8g678Kmbg==
X-Received: by 2002:a17:902:b18e:: with SMTP id s14mr2018521plr.160.1597618130038;
        Sun, 16 Aug 2020 15:48:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c2sm14397373pgb.52.2020.08.16.15.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 15:48:49 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:48:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc v1 2/2] rdma: Properly print device and link
 names in CLI output
Message-ID: <20200816154846.63ebf57c@hermes.lan>
In-Reply-To: <20200811073201.663398-3-leon@kernel.org>
References: <20200811073201.663398-1-leon@kernel.org>
        <20200811073201.663398-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Aug 2020 10:32:01 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> +	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "dev %s ", name);

Since this is an interface name, you might want to consider using COLOR_IFNAME?

I will go ahead and apply it as is but more work is needed here.
