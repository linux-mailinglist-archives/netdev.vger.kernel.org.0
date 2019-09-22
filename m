Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC48BABEB
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfIVWVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:21:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44043 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfIVWVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:21:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so7840934pfn.11
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JkBG0lnRJhYxN5b15xepmMcnLSnX0kbhjVFtTo3NUI8=;
        b=TfJljGiBTAQjaIC/nSCkNjKdRK92vEHgqQJUUQML+WANnYAMVCO6QHUWX4o/ebp+23
         AtHUxEHxkvLBe9Jb+9g3RIF/HbCx6NN2cXFlKHRDYmiAU/3N4Mj+l61scALpGg9aDtn6
         VPpfaufJOiKXp0YSR03bt01omIw+RZ4TlVj+vcgpLqYQ5siXHCbtzfMgbEfm80O7Pmrv
         0CV6ygqI4kV+P+5zorTOUUVZU08WMJfimE8SX9TO4yKxn9hmhW9bT8YAlXuPQeQgvcr2
         JGpOLLr9vQV4i2TWJ9aU5TIdxZf5dasHVW378azHL5dAf234C5L4oBxh6CUIzcjL/oyQ
         5oeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JkBG0lnRJhYxN5b15xepmMcnLSnX0kbhjVFtTo3NUI8=;
        b=JfgxZdXCxYT/pH/44cJthajJFBtgSeDll83ZcZLgel2UILfwo6whf2YwLt1in+f0uP
         cE7Uxtf23YOhuOD1XfHi3pk8rssyT8QoEYD+MirIgF9N+URk4cl5RQIH0QqDwYCi3eyB
         vdexayQ5LFEVFu4wS1VkYBy1tFGcwrRx2qork49d2q9OgbL0Upt0D5e49v2hARUp48Np
         7ZtfDuwynsElqvF1DGGn9Is9TKs9XhCDuTQipCJtVAYhUwQWgHdA5EeKr332M0iR+rzu
         +Y+O9AyRIK1xFjup2KlzHt1me9LTI4/UzT43EsE4ZLJ2NlI/VSYiJ/cHzE4LzD9WdWoY
         9f4Q==
X-Gm-Message-State: APjAAAWMXk0xXEA9sO1iqnezlr4jpvm5Hg8olgR94noxDNttq9AO3HqL
        d2BMrGEu8+ZNQATsmIys/cpGcA==
X-Google-Smtp-Source: APXvYqwYRfqAqTw0Nr50+a3lRJ5iXH0vgT60IUXGrn7hfGNuHrBdakDWZYhJNwV8Ei6FUqWshM3IvQ==
X-Received: by 2002:a63:4e02:: with SMTP id c2mr10176784pgb.339.1569190881303;
        Sun, 22 Sep 2019 15:21:21 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f18sm8700866pgf.58.2019.09.22.15.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 15:21:21 -0700 (PDT)
Date:   Sun, 22 Sep 2019 15:21:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/core/dev: print rtnl kind as driver name for
 virtual devices
Message-ID: <20190922152118.56e8bf49@cakuba.netronome.com>
In-Reply-To: <156898175525.7362.16591901912362742168.stgit@buzz>
References: <156898175525.7362.16591901912362742168.stgit@buzz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 15:15:55 +0300, Konstantin Khlebnikov wrote:
> Device kind gives more information than only arbitrary device name.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Hi Konstantin!

These look like nice improvements, unfortunately the net-next tree is
now closed [1], and will reopen some time after the merge window is
over. Hopefully you can gather feedback now, but I'm dropping the patch
from patchwork, and you'll have to resubmit once Dave opens net-next
again.

[1] https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Same goes for:
ipv6/addrconf: use netdev_info()/netdev_warn()/netdev_dbg() for logging
