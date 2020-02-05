Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2580F152639
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 07:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgBEGSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 01:18:15 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:53476 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEGSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 01:18:15 -0500
Received: by mail-wm1-f48.google.com with SMTP id s10so1073718wmh.3
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 22:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=njLcsjhB++HDsqa75PrZ5CIG5guTKmLM3uwLDSIaf6o=;
        b=aHpXzvNP4YPIJ90EMFgIKL2dJcUmqFKijpBtxPOBF9BWLu9gwnffZXckqTrUC9a1m9
         57J/H6V6RHZXyH10gx/UGq1tsaikAw0TN+sXKnVKddfIPem6uN2vraPfUAF2c4pNhO5g
         4KndlzyJgiMXHrkUTb24t1xAXvPDqGxt8Bwtiq+rpq2Sj+paTO7dc1zIpSUJnGBcWexB
         rqNmgwmX1EMKD8Tgn0vjWiTyJ1vd8zN6IIYWRlk9S/eAnyVyHNovzr4cxn1u+K4VVB8X
         wlfNDgexosiCn7bivGFwSbCaKoPVN9dnFqxdD6I+tcru7Wu9LRpaC6gl1dFZi9sE9J/V
         l0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=njLcsjhB++HDsqa75PrZ5CIG5guTKmLM3uwLDSIaf6o=;
        b=PegHpJCyobnvxCvoqwaSBlflVFP1kmRxBayJIp5fturvc5jKAvfMNLPnekIl688FUD
         H38WLu0wOejhE+b+XTMFWGIVV69UfAiGC5yyWC9sX9aAWoqlE/C++t+xfQTfUphXoimc
         nYqGZmqSP1LVdFQiIm4ligg7NHoLKZrOpyCkLscx9U438Duw2XtTMeYeMepTlpZJGuIt
         QTkaYwpA7n1VR31jchn9fk+sIdkBf5QzUsX0wdNJmUsezOcuO6DqY5VfddqC/IqdEZee
         FwKPszJT08446cmqhPPTurC1LYRFUKt9cRGUIpJotXqEXi9lmoP2ED4dJCKPNyPbFggD
         FOCA==
X-Gm-Message-State: APjAAAWojTwYU0GJA1nbQN8V1W+HfQkX5RwKhNF14IAvDLtY+wMcbkUW
        EggfpwY1utqwOoJbMnQCnW+voQ==
X-Google-Smtp-Source: APXvYqxaTm8ue5PY+3Uacbw2ws2Z9IsOwpyJvesvFh2YZ8RWXSf7JqmUJPZb3/MNgFUFgThpQEI0/w==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr3751448wmi.25.1580883493121;
        Tue, 04 Feb 2020 22:18:13 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k16sm35563149wru.0.2020.02.04.22.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 22:18:12 -0800 (PST)
Date:   Wed, 5 Feb 2020 07:18:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, parav@mellanox.com
Subject: Re: [net] devlink: report 0 after hitting end in region read
Message-ID: <20200205061811.GA2159@nanopsycho>
References: <20200204235950.2209828-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204235950.2209828-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 05, 2020 at 12:59:50AM CET, jacob.e.keller@intel.com wrote:
>commit fdd41ec21e15 ("devlink: Return right error code in case of errors
>for region read") modified the region read code to report errors
>properly in unexpected cases.
>
>In the case where the start_offset and ret_offset match, it unilaterally
>converted this into an error. This causes an issue for the "dump"
>version of the command. In this case, the devlink region dump will
>always report an invalid argument:
>
>000000000000ffd0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>000000000000ffe0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>devlink answers: Invalid argument
>000000000000fff0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>
>This occurs because the expected flow for the dump is to return 0 after
>there is no further data.
>
>The simplest fix would be to stop converting the error code to -EINVAL
>if start_offset == ret_offset. However, avoid unnecessary work by
>checking for when start_offset is larger than the region size and
>returning 0 upfront.
>
>Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
