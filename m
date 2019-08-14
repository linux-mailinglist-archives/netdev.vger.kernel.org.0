Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C58DAF8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfHNRV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:21:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46664 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730290AbfHNRJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:09:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so50944042plz.13
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lPLXl6ahFajDI4RssiQDOHsleZtuIM2FB5N6VA3cEUo=;
        b=Djbnnd7vbghILih+I9mpcGyerXkfamBWR1T9XnV4I/U3+CRNHEQgWMIdwp1jji7lEm
         xAXzkJ6FXjN9+4EYiKHiKqZ9PrvnWYb6EwUtbu7ow7bJcsvUH4y8bDX4NqE37k6apDsP
         1gRb/JDaqRkVJHcR3zLukzmyAlKA5PCtPiTfOK7Q/sOgvZawPeeadc7Jbeb4lv3AVVkt
         yRQabXmdVuKpyD6i88Id0IBm2EagSlSx+uFlPqKGrwYeFCeDy6dk6OvePjZy7qkOciij
         gTWrcLqnecJKFsENbO6a7StLjwNDUXR9iw3x/FLOfRy4IsCjG2dZ5a/B2HIvkSWHYHKr
         s4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lPLXl6ahFajDI4RssiQDOHsleZtuIM2FB5N6VA3cEUo=;
        b=tuX//U0m6bJDCk18o5r/gIEK/5pe7gno2DwzH86ME4qQa/c4P88Xl+KSJ3/H25Hsi0
         gblTdj0SM/+p/cX9DhtdiuCPQA3phX7eo8PDChQD0mBWwKZYoMnu0djeZGRW0j1FEbvH
         oeK14KN17U8CyorQddbBIhExK7M8M31plKY+9fGpciEdUz7vUPbSZ1z/jTvZOMho2ixj
         t9+8xoJ8IhhcGUfjQ7f+CuIKCih96mlfTHOWjFlUqSQ/j8dKoukwpUD2mWKu71DM9HD/
         qVGOgb2HVOfqL/GUmgg+RvYZ9sh1SNoumbsY7cJWWvRPYXISe3Jh4vfoe2aj+plaiLZ6
         ATPA==
X-Gm-Message-State: APjAAAXLcTiARW+xNGLjn7qfqnZUzv/p6mPKuv8/x3QzRc1DdI5uC7UL
        8i9FQDzOgZxwXT1Vuug1EyFvDg==
X-Google-Smtp-Source: APXvYqz0N3TJhHHWF5BDDnnzVsMKuHFz6u1d69WgGCmwCCNSXQGc6c16Ba5wt8RDmWzR/oTGmcbbow==
X-Received: by 2002:a17:902:8302:: with SMTP id bd2mr416843plb.9.1565802550782;
        Wed, 14 Aug 2019 10:09:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id b24sm401115pfd.91.2019.08.14.10.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:09:10 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:08:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, ying.xue@windriver.com,
        netdev@vger.kernel.org, andreyknvl@google.com
Subject: Re: [net PATCH] net: tls, fix sk_write_space NULL write when tx
 disabled
Message-ID: <20190814100858.448b83d5@cakuba.netronome.com>
In-Reply-To: <156576071416.1402.5907777786031481705.stgit@ubuntu3-kvm1>
References: <156576071416.1402.5907777786031481705.stgit@ubuntu3-kvm1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 05:31:54 +0000, John Fastabend wrote:
> The ctx->sk_write_space pointer is only set when TLS tx mode is enabled.
> When running without TX mode its a null pointer but we still set the
> sk sk_write_space pointer on close().
> 
> Fix the close path to only overwrite sk->sk_write_space when the current
> pointer is to the tls_write_space function indicating the tls module should
> clean it up properly as well.
> 
> Reported-by: Hillf Danton <hdanton@sina.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Fixes: 57c722e932cfb ("net/tls: swap sk_write_space on close")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
