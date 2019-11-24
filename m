Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F410859C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKXXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:37:24 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:34645 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfKXXhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 18:37:24 -0500
Received: by mail-pj1-f47.google.com with SMTP id bo14so5584950pjb.1
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 15:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6we/MzgfhyrkDi1CPOUTtTgeIKvvzsxgig47t8jJM8Y=;
        b=OEtVeEEsQDSTgHMJqp7VqvE8uzd0KsJDG/6U5B9xDGR+tD3BkP+zbNLwz1ZiWmA00Q
         yy4vDEjHrvDB4haPaWtrGoYi2e2c2JY4hbX4tS3m5zNc5les6QcVrWZNGuRs6PoNU1cQ
         1gZnTLtuN7c1lxQPrhM6iBLYPZ/Ka2ZkPmQY1fU7n1vpXsny1fTXFEd8ApPNT+HjGOu4
         jAdWLxV5D+rtihHjDK7irsel13mbrNwxnCF2N00XBgKXfpJPqSPhbWWLmlCxKPVxpBeK
         65sXZHduK21B32XKwpPGhgTLjiZAHHCrllwOzZ2Bp46wTa5IwugxdToCN4W6+kcZ2z4f
         d7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6we/MzgfhyrkDi1CPOUTtTgeIKvvzsxgig47t8jJM8Y=;
        b=dJfgwB6qpqwY1UfbHSdL7mKjW2+qkvKkx0V8ze/BPzRdyTZknDgLgRKWyVVVtmOswe
         z+SsW4ElJX5xDiGfHyurkEySdqeUu0CD9TG4D8Cf4ryDAP0houJJjBWtv8eQ0oB1nTqa
         CY1LEe7Alks5X4tQufEAtp/IOZoPz6cxQeqL5Y6UH+SjxCO+T8/oDa+YNEzAukDa7jUb
         W711PwvP6Yw2e2AIyE+Ug2hVbSBF50+muLlhqsm6bAumN21EcqE6iSvAY5z9dLSEpsWT
         PJS2BiqPC2OpQNdCQcM4HKog+ey0SsiRzKqrMPtM2+d55scm1VIZ4V9PYSfJ9chplSnc
         9Uiw==
X-Gm-Message-State: APjAAAXWc2TXv9kjCQ3YLiEY5GpMsDOt1pv472nKse9P1CkB++ZWYuFn
        6mMlKztCvKupmS828v214yEkeQ==
X-Google-Smtp-Source: APXvYqwrsOTKn/ZZp7dWj0yzsZ5TxKqoMOSF7LaZ9WDKFYyqpdHlEzTYHdnWDOaTFkZWffSFTohBdw==
X-Received: by 2002:a17:90a:a612:: with SMTP id c18mr35029024pjq.49.1574638643235;
        Sun, 24 Nov 2019 15:37:23 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id e7sm5525228pfi.29.2019.11.24.15.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 15:37:23 -0800 (PST)
Date:   Sun, 24 Nov 2019 15:37:17 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191124153717.6edefa85@cakuba.netronome.com>
In-Reply-To: <20191124182426-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
        <20191122052506-mutt-send-email-mst@kernel.org>
        <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
        <20191124100157-mutt-send-email-mst@kernel.org>
        <20191124164411-mutt-send-email-mst@kernel.org>
        <20191124150352.5cab3209@cakuba.netronome.com>
        <20191124182426-mutt-send-email-mst@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 18:29:49 -0500, Michael S. Tsirkin wrote:
> netdev: pass the stuck queue to the timeout handler
> 
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.

FWIW

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
