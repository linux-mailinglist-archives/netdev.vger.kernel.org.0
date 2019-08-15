Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65AF8F54F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfHOUES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:04:18 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:58534 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbfHOUES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 16:04:18 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7FK4Glf077418
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:04:17 -0400
Received: by mail-lj1-f170.google.com with SMTP id t14so3303098lji.4;
        Thu, 15 Aug 2019 13:04:17 -0700 (PDT)
X-Gm-Message-State: APjAAAXsCRc9iH4LVC+LmNeSc+CyO58hdcx1hlsVZ96JP/9atBQtBYxQ
        P7Gc21e/vHTAy3nPDqKt76lTytzWBSiAU4+d4xo=
X-Google-Smtp-Source: APXvYqxchbILk3u6RoZ5V2DW/Lx4nxcDY/rbKmpM5NZY035vjh1iu3ANZK/4SOJ3fQaZHTPs5SNPwt+mEorkaNEOnGQ=
X-Received: by 2002:a2e:89da:: with SMTP id c26mr3015536ljk.214.1565899455773;
 Thu, 15 Aug 2019 13:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <1565746427-5366-1-git-send-email-wenwen@cs.uga.edu> <20190815.123430.831231953098536795.davem@davemloft.net>
In-Reply-To: <20190815.123430.831231953098536795.davem@davemloft.net>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Thu, 15 Aug 2019 16:03:39 -0400
X-Gmail-Original-Message-ID: <CAAa=b7ft-crBJm+H9U7Bn2dcgfjQsE8o53p2ryBWK3seQoF3Cg@mail.gmail.com>
Message-ID: <CAAa=b7ft-crBJm+H9U7Bn2dcgfjQsE8o53p2ryBWK3seQoF3Cg@mail.gmail.com>
Subject: Re: [PATCH] net: pch_gbe: Fix memory leaks
To:     David Miller <davem@davemloft.net>
Cc:     Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 3:34 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Date: Tue, 13 Aug 2019 20:33:45 -0500
>
> > In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
> > 'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
> > move the free statements after the if branch.
> >
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
>
> Why would they be "deallocated"?  They are still assigned to
> adapter->tx_ring and adapter->rx_ring.

'adapter->tx_ring' and 'adapter->rx_ring' has been covered by newly
allocated 'txdr' and 'rxdr' respectively before this if statement.

Wenwen
