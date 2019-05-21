Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7B24BE9
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfEUJoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:44:17 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:52365 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfEUJoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:44:17 -0400
Received: by mail-wm1-f54.google.com with SMTP id y3so2242410wmm.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 02:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Lqi+2RvkejiwpJE56bqExuPUsrCsCJFu+oJsSyc1US0=;
        b=Yg+W+kejon17TuM2/dMhFsOLVfZrtDBLQA6l5VDoWBRdmGqp1kNut0MD4Zj6Yq/fuB
         6WqaWoqfVJ9dbnMRLaSd7TK73s2+Lq8lkzosFfhuZeEoDuwYkphQqc00WHWatL1cWfuQ
         fzhcrFv2Afgavh6p1dhPEjssrMpyw9QjQq3EeM812A+/vj2AVH62edTzvkybf5saBYLo
         Rp6l+zoegcFm7OOgcvEu2ZWj52WYgj3eiyI0yhw6WKxBVdJ+BAVL1ZYs9qrpCISwGybz
         aXzgPP+CLpdik3hsxVoaxJ/sFT4obYKoESzhfIFB4HLV8SShFxxd2c+l7L83xBBiNmq+
         1h6g==
X-Gm-Message-State: APjAAAX4tmLN6AJltoNdTagLALouAzB1uoCy3QY+jKcyYlHx4XvhNv1J
        asbJFTxDnAOsShskARk6vw74QHgH3I0=
X-Google-Smtp-Source: APXvYqxRTx7pbc0N4W+f+4WVPBKijSEiV9kZbxmb6bUbb2npL0uTJc+Rj5GvWpH8QWPmGo6+PTnLWw==
X-Received: by 2002:a1c:a002:: with SMTP id j2mr2615808wme.131.1558431855141;
        Tue, 21 May 2019 02:44:15 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id g3sm2443854wmf.9.2019.05.21.02.44.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 02:44:14 -0700 (PDT)
Date:   Tue, 21 May 2019 11:44:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Michael Tsirkin <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Subject: Question about IRQs during the .remove() of virtio-vsock driver
Message-ID: <20190521094407.ltij4ggbd7xw25ge@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Micheal, Jason,
as suggested by Stefan, I'm checking if we have some races in the
virtio-vsock driver. We found some races in the .probe() and .remove()
with the upper layer (socket) and I'll fix it.

Now my attention is on the bottom layer (virtio device) and my question is:
during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
executed, queueing new works?

I tried to follow the code in both cases (device unplugged or module removed)
and maybe it couldn't happen because we remove it from bus's knowledge,
but I'm not sure and your advice would be very helpful.

Thanks in advance,
Stefano
