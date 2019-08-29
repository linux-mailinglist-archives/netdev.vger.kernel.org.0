Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615B0A2B03
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfH2XiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:38:02 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45943 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfH2XiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:38:02 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so5862163eda.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qLJe/bs/DrEJWr6l40Vco6An+qJa0H3EkGISSshZsUo=;
        b=uOasiiMSMsDuahQWplxwcV8tA2bsHMkjOVyT1IxlTeyBIBm3+4qYx+/tf1vUsbkNIC
         r6ZsVcnUWqUCHTBbTNYMnZd1z/8uk3ls9pJP6NnR13OGTRjfco3pv59JItxJMRLkQ8Kq
         xvR0AV/q9NgtmE6UzapYmuJIlgHkDx7K7JQJSmFstPfUVZ8nagQ98GhAofZD6yAwt32O
         LyVY8I60MvKJTuiw5Zx8+lH+UXuBcjzeYgcRClCJvTJNSzEhJ+sRQVqL0cnyFBUTs683
         IXJ/OnvZ60RYlva3bXGsFLOi6n8jvMVtkDNLgXzCaMJJgWMj1Y3XrDesH+w1VnWzXdOf
         DiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qLJe/bs/DrEJWr6l40Vco6An+qJa0H3EkGISSshZsUo=;
        b=XHw3B1/L6laPkhcAtPZJQHjHMk3KKE5Ohax2jddCAuLJ6a0bHpdy6tp+7uQ+66sx3Z
         O1Y8JFjyWi9V6iwBsSa53Eg1H0g4KRpCC7djeflbtxiuI5qBWt71KtF27jdRt/eTneQJ
         Y51CffjkpyszLsRolM/J7AjbpbQGu90xutVT0Z3MbWXgddYS4Ke0PsR4Tg3SegCXollz
         YRj1LhOD+Mn7oegDPVTYaHxM01xiT1HROxMzcRt0fCDfHzDycx4SATarOSanoyFjGuBy
         zoAX+Pls4lkEqTk6WXDFh/T4o6vdThup1IxeoJx57YTBtivq2oAaiv3JYbXuqgR3uSW0
         CKWQ==
X-Gm-Message-State: APjAAAUMFNl1+YKzcSgii1JZvuLRQxLEa+sQBrWN4dh7rqkKZ2hMP1d5
        sBply5Rkk3ISNDQ2XLrGsDVMAA==
X-Google-Smtp-Source: APXvYqy47ncgeDWUi6FpB1gk/htQt2h0HVt6F880FjfJ9CqmB1mNN6BoJBNyJVZmRaZvK0un1nLbmQ==
X-Received: by 2002:a50:aee9:: with SMTP id f38mr12704956edd.22.1567121880553;
        Thu, 29 Aug 2019 16:38:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id jx11sm324588ejb.19.2019.08.29.16.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:38:00 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:37:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 16/19] ionic: Add netdev-event handling
Message-ID: <20190829163738.64e7fe42@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-17-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-17-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:17 -0700, Shannon Nelson wrote:
> When the netdev gets a new name from userland, pass that name
> down to the NIC for internal tracking.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

There is a precedent in ACPI for telling the FW what OS is running but
how is the interface name useful for the firmware I can't really tell.
