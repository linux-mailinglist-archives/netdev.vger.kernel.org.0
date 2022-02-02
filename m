Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD664A6CCB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiBBIT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:19:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231628AbiBBITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 03:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643789962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wyReEkn4/Cn9YjwteiaH1K4UQsIlCcH3PhcqVdM9/k=;
        b=b/H3V5QAvyjps6abiUObI1VE7RjtSou9Y/ULdyMizxBue+NByh6+H3cjX9HO+sgCVvGL4d
        9O+sIh2lLmtsNiFB5ubKy9RnP8VSip4zSrl2nlAD8UgXhmCJfC9OuV3odT6+lSYjuOAn5U
        rIQRJrBBIbPQAf0kvwdIUwj6KN32B6Q=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-4lGgE_b0O0ms6EbLxnf6jg-1; Wed, 02 Feb 2022 03:19:20 -0500
X-MC-Unique: 4lGgE_b0O0ms6EbLxnf6jg-1
Received: by mail-ed1-f70.google.com with SMTP id c23-20020a056402159700b00406aa42973eso10015816edv.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 00:19:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+wyReEkn4/Cn9YjwteiaH1K4UQsIlCcH3PhcqVdM9/k=;
        b=zj5NsFwPjWunywtq9flZEio3mAeBmhUTvHJy3WJJzrzMF7Yd08MPLstvsP7+UigLQ3
         X4nOYTp4xueRKAvOMqAOw3CMHQH/uTFHmXU2Q9prJc61OyEEF78pAF40gG48NO28EjW2
         1fANNDxG469HbiH7n0WiLhVwpOhFRVDO0IZYl94KgvxhOY6C6bFYpNh0FV+fMCv/LUct
         jVP0PqBehdDIlWDPklslT3bNDwLktWK4ErtHv1GzU5syP4HolZTHWHeGB8j3ncOJaQKs
         L7hio4pZVETax9Pg8r5tMRwi2p5X2hBk3gqBlcxcOgCRp0lt8pC89DGo05z/O6i3Au1c
         /dug==
X-Gm-Message-State: AOAM531B7MyI1pkasn1lXLy5ModUuwBIMtT1StyY1XFBdLhRpoMXlTAy
        u4z2gEoEIcM+r4q67pERvDoalSHKlWh+nK4ChYttTlQwgXEYooJIRZ1cjP7E+PZ9cx1SWmCSlKg
        Zf9YFTpLD8KaufhF5pUgbzSEMuKX+CR6OtoQnOYTOx3vQzkq0fnss/YURReiLuS//02o2
X-Received: by 2002:a17:907:97cd:: with SMTP id js13mr24040069ejc.365.1643789959569;
        Wed, 02 Feb 2022 00:19:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWlPidqeGWSjLbqV6r7BsSahIDJSL1QXn1MChsAjaMmOfP+6XhzTND6XmbFDVjYb/cTiZjSA==
X-Received: by 2002:a17:907:97cd:: with SMTP id js13mr24040053ejc.365.1643789959200;
        Wed, 02 Feb 2022 00:19:19 -0800 (PST)
Received: from localhost (net-93-71-98-74.cust.vodafonedsl.it. [93.71.98.74])
        by smtp.gmail.com with ESMTPSA id lf16sm15302731ejc.25.2022.02.02.00.19.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 00:19:18 -0800 (PST)
Date:   Wed, 2 Feb 2022 09:19:17 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] selftests: tc-testing: Increase timeout in
 tdc config file
Message-ID: <Yfo+hfsmAhCpXhBK@dcaratti.users.ipa.redhat.com>
References: <20220201151920.13140-1-victor@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201151920.13140-1-victor@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 12:19:20PM -0300, Victor Nogueira wrote:
> Some tests, such as Test d052: Add 1M filters with the same action, may
> not work with a small timeout value.
> 
> Increase timeout to 24 seconds.
> 
> Signed-off-by: Victor Nogueira <victor@mojatatu.com> 

Acked-by: Davide Caratti <dcaratti@redhat.com>

thanks!
 

