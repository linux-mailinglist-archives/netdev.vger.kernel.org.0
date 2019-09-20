Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D7DB88F3
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394616AbfITBgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:36:46 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43925 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389293AbfITBgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 21:36:46 -0400
Received: by mail-qt1-f196.google.com with SMTP id c3so6760910qtv.10
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 18:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=j/rhLpOtkDAhLXJZ97r2J7YUt90sgxiB7jmg+WOCKY0=;
        b=a3n8Qnr7/+ZT3Ho1i8lxPS+kUBza93tUP8WKetuUBUquEBDk4lLKQfOknnOmFrGivM
         Yu4HKRTmqYEIuOp0tks7NQirtBlGgsP5mbqA89/Z8tBuAQndqUTWhWv1dEtGqI3jzsgX
         SkGxbmJYR2XbgvjvA6DKU+525GPtdHTal0DZeto1vUt/k+9omTvdY8si7KXLrjU9nD0o
         nw07BVJ9kez7JhVecF6BBH4sXyZG4rqthwCholEyn8Ad7jZJHzo9/FL9JeV+cQiCYZew
         2LTMjMyOVmdm5DV/JSLmjKPsZrPF1acPyxSMkRiG8W1dBLTKng6PcFmXrkql6TPxKnSJ
         qyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=j/rhLpOtkDAhLXJZ97r2J7YUt90sgxiB7jmg+WOCKY0=;
        b=ognAQSmFBmXtYKYYb4n14OpVUWybb02FYEO4E6NAKE6KxV4nX38sMqpUaFiDFc9/Si
         BcF7G3AV/TIPyIz9skm7vZE9t2wSYws3FoOPUyD1kRyk2BSItluLzGlq1xD2ii99molG
         An2FyeSoZcvZs6tUN16Us8FLvrGJW9z7r0vsMElybwX1YkbJbZ80ExAruLF+pPFFVrou
         bjpoULyAp3t5iVuGkTlpzFHH9RGH20E+PUKLsQmyerWXVPHuB7pBlnYSnP1GdzQJ/vbx
         QZCI8ykEgGXnJRFXY/6N7HAenrWYdyC9hTlBaIN5kKIGbru3mSkbE/z0iGdKXumjIe4T
         1MSw==
X-Gm-Message-State: APjAAAVO8/4/ebLETyn/nvkUUWV3ul/xWeW6CSq0U2Cmb3iFC2ovbwZp
        ZlEA0zbVGQBztD3WJk/5RwZr/Q==
X-Google-Smtp-Source: APXvYqxrTIXDWxEo4TVfbXg+DXG3kVwpCsIPeBrp1qFSxiJyfFfq33hVg0VXO/E+6HgLEYmt+ubcUg==
X-Received: by 2002:ac8:7646:: with SMTP id i6mr491288qtr.50.1568943404156;
        Thu, 19 Sep 2019 18:36:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y26sm219778qtk.22.2019.09.19.18.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 18:36:44 -0700 (PDT)
Date:   Thu, 19 Sep 2019 18:36:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH] selftests: Add test cases for `ip nexthop flush proto
 XX`
Message-ID: <20190919183641.6930fdac@cakuba.netronome.com>
In-Reply-To: <20190916122650.24124-1-sharpd@cumulusnetworks.com>
References: <20190916122650.24124-1-sharpd@cumulusnetworks.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 08:26:50 -0400, Donald Sharp wrote:
> Add some test cases to allow the fib_nexthops.sh test code
> to test the flushing of nexthops based upon the proto passed
> in upon creation of the nexthop group.
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>

Applied, thank you!
