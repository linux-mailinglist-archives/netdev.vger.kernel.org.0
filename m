Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB473407D6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCRO27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCRO2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:28:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AD3C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:28:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so4280047ejj.7
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/V2j8aoHdA2ho3+czUdK/IIMSPUK4L3XMusRe6tGZxU=;
        b=ts7EpVWFZzwVuxiJlGF6tzc/46zCP9dtcnh9fGMJ5IORIaOCyFTFW0pvwBr58mREDj
         YfBnJlTO64vb5q55s9TIRrWJT3+1UCf5nxKKF3u1olVMX9IydgE2CAwbEpjkpGiNtyS9
         B4Wv8V8Zq0Q/B4781F2GS5DfLk9XkZtKW31ipqFcNl+lIsVzReztU0AWOjAuCGv25Db3
         ENG7yUpGKABADPUd2WyCai0XyvWFsup3fn3LfIroCcb7DtuIXMZzl9ZdOy3Ea6FX7w7I
         SeepiFzu6Zp21L+nA740BbKyOxDd1e+JImaaj2NghrSMmVVuBd+ptWDS3/FyoBvNAyl6
         wjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/V2j8aoHdA2ho3+czUdK/IIMSPUK4L3XMusRe6tGZxU=;
        b=cqQfv4V+zFOgpxqyuaCP8T/qoiDHd8xbQ9iR9xVePJ8WS6JGsOgYop63pPHW3VI7Qt
         N4YJlfKmt8KrLz+gTibw+qK8lNltsdPj3TicMAUUOB92CyKXqs2JjzL3/6KnOvgxFPwr
         qm/KC+MZ1ahh4y6wsXRFm2SF8qlhl4NCkaNyricYQnCyV33H+Gf2ELNS4mqDfPmBLF/i
         2uUxsbY3FI7oY/32e4JxgU6g+VAaPGFmD0IxROid6a4zQ1Jjak8dvqc/opvucpZ7ICRT
         dEqC7t6zEkNsvTDfmMpwwIsPc8E8++5JxuRzyDnTRBUY9+jr3+Gnw0jA1wEjsGBkbLHL
         /0rg==
X-Gm-Message-State: AOAM530L8aVPoIfIC1T5CkeofThY+KGcwUe+GA6Rp/ACHz8JIyLnbxV8
        hzLn3wQ/eEE5e9bkUzy21lU=
X-Google-Smtp-Source: ABdhPJzY+M9sOC4Pwnx4Vi8fj5TF7pviGIuiNUdxc/JDbuCok1EuHck9amshFw/XL1HhoEUo9sTbrw==
X-Received: by 2002:a17:907:7683:: with SMTP id jv3mr41130149ejc.450.1616077720353;
        Thu, 18 Mar 2021 07:28:40 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g20sm2242372edb.7.2021.03.18.07.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:28:40 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:28:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/8] net: dsa: mv88e6xxx: Use standard helper
 for broadcast address
Message-ID: <20210318142838.t7zjfckehak6k5xo@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:47PM +0100, Tobias Waldekranz wrote:
> Use the conventional declaration style of a MAC address in the
> kernel (u8 addr[ETH_ALEN]) for the broadcast address, then set it
> using the existing helper.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
