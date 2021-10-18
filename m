Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB8430E2A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhJRDbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhJRDbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:31:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E53AC06161C;
        Sun, 17 Oct 2021 20:29:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 75so14630279pga.3;
        Sun, 17 Oct 2021 20:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z/ylY5vvx5KqxKz+xNvwJdpdJw5+5FU5nhFhUTLsP6U=;
        b=bPiB52YVZ6xugdYoVwwX6zElVM0xfH8uUNDVLmt0JTZO+DMgHIWyiq8BLzjouivfE6
         LVZi2EhDN8L/5oGT9I94I28lwQm4hLOp3deU1/Kx/BKBkdHSiRJpuma96PZuHqNU1S9w
         a4juYMSyfdjjt28KCNDynG5NjjB7h7t0jZw6LdIBNUT8JMay1jvMCupR+8lNmVBqS3st
         1+wIrEq9yoACbi3I93ZEU4hihhzkaVuaB/8j5kLdJIOLdRLgeQZfXMuP7azVTgC/Bjl8
         yXhOyMbiggUnrRUvHckIXCnTEvDCOzqnAhWKhIhqFjin+MZb+vLFQgBlmBQ2zaheBO+0
         HjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z/ylY5vvx5KqxKz+xNvwJdpdJw5+5FU5nhFhUTLsP6U=;
        b=ZCtsXmJ/wwtzgFckQukPXHYFAqXtsAX80FRI5B8pMLBokPm/jyEQgNxaU0sTvy+bP1
         nnMCHy+ySLyTex+DCNn44gemswtzWb1zLv81fe5XADZgCcjuv8qKLCoBU4te0h6pssth
         ODi3bgDh6RA+wG9Nai16Sy5DkRiKnTMhR9EKLoEf7lZPHhubb7PfS71tF6hEhy44BEia
         Ld0piE+qpqvn4VzH9LxzP5SzDwOLuDrHowU1+S6KFKh6g0m56Ihcur8ed+IGpZWmhHUb
         PE9UH2q/H5w8uFVJiHjoSEx59sqe+bD5T3xrbjBHK8JlXxEld2O/M2YmjgdwmdwNTpjZ
         CEGQ==
X-Gm-Message-State: AOAM531qbJc7dmGZzEJU8RGZ9B1xQvpYw1gfc94CInOMR+dYMsKCzhJm
        zHJoWySYTQdgbOdZooDpJdE=
X-Google-Smtp-Source: ABdhPJwPr0ojYey2tmRElAZma0tOh6ohytOGftBSpRh4js5ajCQuqz83wLVGyNL9Jws7TkqvXDd1LA==
X-Received: by 2002:a63:5544:: with SMTP id f4mr21400410pgm.431.1634527749814;
        Sun, 17 Oct 2021 20:29:09 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c9sm10682612pgq.58.2021.10.17.20.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 20:29:09 -0700 (PDT)
Date:   Mon, 18 Oct 2021 11:29:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: add SM4 GCM/CCM to tls selftests
Message-ID: <YWzp/5ClVG0nigMY@Laptop-X1>
References: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
 <YWk9ruGFxRA/1On6@Laptop-X1>
 <cf53cf98-354f-f993-4b55-ff22dcc0d92d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf53cf98-354f-f993-4b55-ff22dcc0d92d@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 05:59:29PM +0800, Tianjia Zhang wrote:
> This patch needs to enable the SM4 algorithm, and the config file you
> provided does not enable this algorithm.
> 
Thanks Tianjia, I will ask CKI team if it's easy to enable the new config.

Cheers
Hangbin
