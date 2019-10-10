Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B95D2522
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390085AbfJJIyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:54:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37591 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389549AbfJJIyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:54:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so5847730wmc.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wHYikf0fF/apSGlr8gHGbX/of/oo0NlzWMca/OOzrzo=;
        b=vF0B1wWRPKzxgGNg6RbYUEZObWKkMG83e+UcvJfWAal/+sjtAanrqW5+UzHCeKmGCw
         hVvZ0mUSjN9KDiyMA9gqa2O9zhkL+lt2TBBUhz5zaYZNyHO+G76heidW2gj1K0Ss88/g
         9yXF1SSSsDLn2LxvaETJHruER4jjP8wpo/Kfwy3G6/OCiBSG1TEfn397fPZLwkWK2Fth
         M1x010smVrzQ95YYzV1SfvBTfwo1TUSKqaYJBSp0OjWyr7ufw35WwEadotZxUbrFwSHA
         4pvBpdySrtBujn8pIk8iA70B2oyfqaVuREcybVif5iWa/TjxRHS3j35Bntf6P6jXe4Ct
         /DKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wHYikf0fF/apSGlr8gHGbX/of/oo0NlzWMca/OOzrzo=;
        b=NNxrFgeYn8nUkZ12W3RCCn3hjfQ/vWm4+hxb+8Q9bT7wbv7Dh21AaomyZg9FO3q+9V
         qNrg7Ppg2buFK5+VEB4THgnhzy2LgHAMWFUjqB9sYMq44ue5isflLLvPglj/PP2WtOfP
         PgI3q0mv5Rp3jnX+BcJOco6HXuKA9CfAaUpVht+TO/gHZxhdAoyJzmZEHj5E2BYVKQT+
         XE4BOBFMnKzb4SDreOuuvplZV+VJNlT0Tu07sAcG2zuhLbAsRWJJrak+7nNTTpT+mX9l
         udR0NByQAqGwpzkjS+WEQT4mtjIJqV5ejepzKXqwt5KHx2hRqUEt38LOBLugIYH4jhHY
         bohg==
X-Gm-Message-State: APjAAAXn2NZfRBk34a26KX3GWwy9N5AWziakgTeFWBvrB7dYNzw6nOx3
        qFKaRfnP+ALj4wlIIXnZAJuwNr0T3OY=
X-Google-Smtp-Source: APXvYqxqp0mHDJbn8N/yVfcTmcl9ySOGieoc/jzI8/zmm39GEpEazrQmaX8wUxwsZtu9P0H+S6PMZA==
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr6924163wmb.125.1570697654779;
        Thu, 10 Oct 2019 01:54:14 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q66sm7434557wme.39.2019.10.10.01.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:54:14 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:54:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, ayal@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2c] devlink: fix json binary printout of arrays
Message-ID: <20191010085412.GE2223@nanopsycho>
References: <20191009083232.21147-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009083232.21147-1-jiri@resnulli.us>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:32:32AM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@mellanox.com>
>
>The binary is printed out into json as an array of byte values.
>Add missing (removed) start and end array json calls.
>
>Fixes: f359942a25d3 ("devlink: Remove enclosing array brackets binary print with json format")
>Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Please scratch this patch.
