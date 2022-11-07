Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B619961FABF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiKGRDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiKGRDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:03:10 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377352250B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:03:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o4so17203975wrq.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 09:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UW/4hceSrlmEp1p10Cl0RLvNXRdnrXuOzSvrSworG9g=;
        b=7sejYrGHK/wXNDQmEfa07J11y7z9h4BYnNtrulsOCLKP6PjcSemMR0C/hwfVkJrpiG
         +dwnLd5qu8+HwCZMEgW/Z+yKGwUtSZTgh74j3iVyTpjP5+fAlfMXeGtDPnqVzZ00yb24
         0fA0qKPYDn1HjxHtLXZyyCuIHj4i9VVM90FKQrJWHUkwvOl0X0lDlXMu2pcpxCX61p5m
         WkPTnbo2pMZIkRzkiJYEn74O61QaQkMarTvg4Pyv6Ok3X3cFQtvqntFoz9Mf+ntGZFe4
         JzZr6bZ3k3x+iJEnIt9usnWgKfqSgEjKXC/CaIZcIoF9+vk/FOrqKMvspDG9ex1F4pct
         teNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UW/4hceSrlmEp1p10Cl0RLvNXRdnrXuOzSvrSworG9g=;
        b=BStk/O/2NCc2noz0Q55oYMVldmN6maFRVM5w6lajbPt94aH3O+kaT6BVk/asAQ/bYh
         dJJC/7Z7KjK1bav/WRp8fNZJveyA+79syZMZ+4A+yhO9IV7O53dYTj6pFFTC/WCvIlFs
         3tJBA8jQZD4k7OO7r//U0YY2//Sesy89jK9lhTx8ku71jBqzb3us1XPfAPXHNwWKW1EX
         UKrIExLZiDjsnS/mA5pSFp5bdS4n6e5dKZLqy7ZmT+lYFnX4idGXdcmPfbqoD+OQkgyn
         LD7kHN7wqBhyXIp8ld5Kg4jNq1EPjlihrfjOyhv4xnVT7u2bbNE0z4ttlDs763AgVsdU
         VBmg==
X-Gm-Message-State: ACrzQf27AOWb6EeRLMlhFv8kn5mBa4pArqddK66IPTORhD5G//ZlCds/
        SSqlT9tpEGVpVHYy0NQXQ/sXuA==
X-Google-Smtp-Source: AMsMyM5KeQVEXSu+Ngx574+1UsHA1+ii5sLnnQjOk6Hgd4TLBEZQayILY3fB9q46R8P5ce18nCHZZw==
X-Received: by 2002:a5d:68c5:0:b0:236:cd61:3bb2 with SMTP id p5-20020a5d68c5000000b00236cd613bb2mr28343544wrw.616.1667840587807;
        Mon, 07 Nov 2022 09:03:07 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k4-20020a05600c168400b003c6f1732f65sm11795117wmn.38.2022.11.07.09.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:03:07 -0800 (PST)
Date:   Mon, 7 Nov 2022 18:03:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <Y2k6SpW9Wu4Ctznm@nanopsycho>
References: <20221104152425.783701-1-jiri@resnulli.us>
 <20221104192510.32193898@kernel.org>
 <Y2YsSfcGgrxuuivW@nanopsycho>
 <20221107085218.490e79ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107085218.490e79ed@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 05:52:18PM CET, kuba@kernel.org wrote:
>On Sat, 5 Nov 2022 10:26:33 +0100 Jiri Pirko wrote:
>>> Didn't I complain that this makes no practical sense because
>>> user needs to know what file to flash, to which component?
>>> Or was that a different flag that I was complaining about?  
>> 
>> Different. That was about exposing a default component.
>
>Oh, my bad. But I think the same justification applies here.
>Overloading the API with information with no clear use seems
>counter-productive to me.

Well, it gives the user hint about what he can pass as a "component
name" on the cmdline. Otherwise, the user has no clue.
