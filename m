Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5630D46CCC4
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhLHFGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhLHFGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:06:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4AAC061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:03:14 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gt5so1111538pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 21:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kCLAEL6kwfeKwN41NqOO8AEPYIdaucdm15Lf3Sx9vGs=;
        b=EmL1YzZJoM5WiBJHVcjdeIDGwc1JlQ1PdJiFDy98ILZTPhEUBxVnt4M5HX+U581wIv
         uqGuShQVj9Jl8+X40vY81ET7pJffG8xzdRFVAmuXdUcDq/Ma7YKYWXbbcGkoFOIiTO/g
         vveSftJZgGYoDS30XYcmKpOiW66zLf9ucvDU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kCLAEL6kwfeKwN41NqOO8AEPYIdaucdm15Lf3Sx9vGs=;
        b=0TT5ul8QAtJc+sW0OZzIHSQ7Hx7pkIOGHskAm/Nq/W0dqeFAXRVwphb+X0AL7KMUiP
         Ddd+nBy65n9WdPgO5xiWMNlZeBWDmSssB+tlQCVhqLugE6A33c9viH2NcSByE1KCDaRc
         EsbMlzDbpBHuYXu5hHg+42YwzhJja13SJZpkYNSvxCkM6kHRHGaCdCbnL6x17ltfysis
         TL5XnnV5IlAqYvekDOhwGsrZk7BZCrfAJaHZIbwL0VMrDb8bA0rqeiciL0uNbc56cdIs
         WUH+iv+BWdJ8l11tKWZJnKYJj4NsvbG1QvSDHFUuYoPhglf70PIs4wJizW0nA8XSKMd1
         69pg==
X-Gm-Message-State: AOAM533Z6JoIoWYRZedh+jgs6FSnC9p+KBPb8sfobf28tWQGS4xVA5/d
        VLZLiSjyfxeZgxrTrkLiYekhN1H6C5kBEQ==
X-Google-Smtp-Source: ABdhPJwqQ2aJIiM7EKW+gY82ckZLzZBXQcnNTkc7eHxf/nqb4I+6lr0SS/4d1jYIyyTj0+P5GK2Zwg==
X-Received: by 2002:a17:903:185:b0:141:f5f3:dae with SMTP id z5-20020a170903018500b00141f5f30daemr57078699plg.56.1638939794470;
        Tue, 07 Dec 2021 21:03:14 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h1sm1452743pfh.219.2021.12.07.21.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 21:03:14 -0800 (PST)
Date:   Tue, 7 Dec 2021 21:03:13 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: hinic: Use devm_kcalloc() instead of
 devm_kzalloc()
Message-ID: <202112072103.D37C42F69@keescook>
References: <20211208003527.GA75483@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208003527.GA75483@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 06:35:27PM -0600, Gustavo A. R. Silva wrote:
> Use 2-factor multiplication argument form devm_kcalloc() instead
> of devm_kzalloc().
> 
> Link: https://github.com/KSPP/linux/issues/162
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
