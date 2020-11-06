Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F28E2A91D8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgKFI4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFI4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:56:44 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB2C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 00:56:44 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id 11so438328qkd.5
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 00:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hyDgFXvzO4wQxQS+1sMlxH8KPZIy4zS1LuG+ifiqDfg=;
        b=hPltVMfGylVPIB9OehIAj670JtMggFxFYwMIonwjXTdPXJg+ODMz0aVZQy+cLcL3CB
         WJLv/ST6SedVVjS3G6+I33V0JIaRbqcoLFXwkaaOxs/0HqehwrSuGPTgmR/chgViaO9P
         mxJmXHNxS3Hhj1x5x5jbO1ca3ROziLPvVdqOfCS/L/w+GLOElk+/It03PdbbaiQrJ/P3
         UrVbxCtsMbhWpj4hc9lqU+1sJ0h09Df3ll0rQmpbHxX2Bxe/4Zpw8NCH28WtreczgeY5
         TkkhfYp6WFy3xoZ0yqjAyj+0CcVesbZRr0IccPoLq6iaCay4CwNg1tvQO7JZqtE+lPZj
         Orxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hyDgFXvzO4wQxQS+1sMlxH8KPZIy4zS1LuG+ifiqDfg=;
        b=fqOMcnRn4Hn/nDVUMyWPAJ6as34opBWkNHHIZIFiuCa2+n+TKXw9BUIMwpxavTZiUc
         A9PO8ovXe7j1QbWbxd5bwSbpYu2dyz5wX5tLw6Krhtd4M1hBIbrDrFznrnexGnG//Kv7
         Pver4QhhFmd+CioOuvMw88y/lB2DlcxQUvxG9V7NiKnSNTBzDrZLvU6MXGk0GzzEJ2Wk
         q7eZlYjNrEJ627P0r82a4T1epzeCM/i8Kut/2TARzOuFqU2L6P/9AEmccvRIEipJvi9V
         aMCdVKgt7L1jAVaQ838eF3P+MruWFn5+DH608tlWJ41Cj7P7rNplOgMBNaXu9fj+sH0z
         SYCA==
X-Gm-Message-State: AOAM531a9S8yGuxbvW1kLJ6HtvOalbhiHgE48z8Wd99QyHxJAqtPUWE1
        ts9XGo3Yp+CJfGVkycV/w0k=
X-Google-Smtp-Source: ABdhPJw7U4GNLAMuf2K5ZWElNI/Xbnrudmz72L2DugC38r+JOhjvMkwyO2x7KvYtrbLisKZhDohwGA==
X-Received: by 2002:a37:2c03:: with SMTP id s3mr542859qkh.91.1604653003603;
        Fri, 06 Nov 2020 00:56:43 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:78d6:ae13:4668:2f4c:ca7a])
        by smtp.gmail.com with ESMTPSA id k4sm212989qkj.46.2020.11.06.00.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 00:56:42 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6DEA6C1B80; Fri,  6 Nov 2020 05:56:40 -0300 (-03)
Date:   Fri, 6 Nov 2020 05:56:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201106085640.GA3913@localhost.localdomain>
References: <1604572893-16156-1-git-send-email-wenxu@ucloud.cn>
 <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 06:41:33PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>

I see Davide's and Jakub's comments.  Other than those, I don't have
further comments. LGTM!
