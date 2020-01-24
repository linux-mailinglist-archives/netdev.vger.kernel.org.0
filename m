Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4837148ADC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387698AbgAXPEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:04:23 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39035 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgAXPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:04:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so1127288wme.4
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ac5XeeF5CQJ175llXpm5zA5o9HI8m4Yi1eoP1oeR0kg=;
        b=RMcWF0Al5kI8HAI/CoFLCv4RBqXyGL8ACNDGEKJyVwDbXRGmH8FiZ3hLq9fwE3ZjmP
         +2MOSBXtXrSGLvuK01UQgJM8h7dZDMdGw8v6N/4l/oy4+17bzieDOq664wUCSAep8lpx
         uAyD2IGw3YH0DxzJnOZa7NXYr8aqfCsjM8AEJci2hq7AToNtG6mPywrfQ7MfC1/Z9kbG
         EqdSA0Y7AW3geI1LKdrHN1ryLr6N94NjDwRmnfPvGYpbx8Jfik7oTL227BM4hR7vW5ko
         VysK90LmORuBYoQTPKmHvgjCp3fYjeSGfRHNOBrMsaFKfMrXvWG3QfDwgH57oasBJVrL
         CG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ac5XeeF5CQJ175llXpm5zA5o9HI8m4Yi1eoP1oeR0kg=;
        b=Wc2xnYBHw1rBA32p2hvAJVnhDqPGSH5hoF5SC0K3gmp1QxCIOHn6upH0oZIaLU6f81
         P91CT96RqwRVnbG9ObUVAHgIb7bzxQ6tHlwROJyrxgCYH2YbjtAE8J9ofw59T83Cg5EC
         T2yP4ik7VCwwwLHPkYgGqblyhR5BLXReRsdmsG5h6oZHuXPg+oJTWyHTrB7mlLKhhcwV
         ZWQX6/X1Th8lTRQGHCGIRnKlgmTjRqycNXCN/Huk1djFYJES4FdqbLPqP5Wj1hg/fOA5
         H4lc4G+e2Za+Hgc5QCZieQUOWGRN44Z9nokYLX1+52NgorcjOg/uSn6k11HoegBaqw/N
         OKAw==
X-Gm-Message-State: APjAAAX48cCngEKE1NtUJqbLysII5yP6pesB167nu0Di51owM0StmiXq
        naa9MT93YY6EcApkTYE+VO94sw==
X-Google-Smtp-Source: APXvYqwIb7qa2UomjYxjtGnVFcNCqJ0laPRNs2vjQ5PCSXOyukybnKEjBwIGNpqPvpNijXdpaZ6Uqw==
X-Received: by 2002:a1c:2504:: with SMTP id l4mr3662656wml.134.1579878260400;
        Fri, 24 Jan 2020 07:04:20 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q3sm7774283wrn.33.2020.01.24.07.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:04:19 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:04:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 05/14] mlxsw: spectrum_qdisc: Extract a common
 leaf unoffload function
Message-ID: <20200124150419.GC2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-6-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:09PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>When the RED Qdisc is unoffloaded, it needs to reduce the reported backlog
>by the amount that is in the HW, so that only the SW backlog is contained
>in the counter. The same thing will need to be done by TBF, and likely any
>other leaf Qdisc as well.
>
>Extract a helper mlxsw_sp_qdisc_leaf_unoffload() and call it from
>mlxsw_sp_qdisc_red_unoffload().
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
