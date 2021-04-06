Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5CA354EDE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbhDFIo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:44:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41320 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244417AbhDFIo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:44:57 -0400
Received: from marcel-macbook.holtmann.net (p4ff9fed5.dip0.t-ipconnect.de [79.249.254.213])
        by mail.holtmann.org (Postfix) with ESMTPSA id D6E8ECED1D;
        Tue,  6 Apr 2021 10:52:30 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH 0/2] Bluetooth: Avoid centralized adv handle tracking for
 extended features
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210405233305.92431-1-danielwinkler@google.com>
Date:   Tue, 6 Apr 2021 10:44:48 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EAE9ED84-E693-4821-A44D-059FE3CE8665@holtmann.org>
References: <20210405233305.92431-1-danielwinkler@google.com>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> This series addresses a race condition where an advertisement
> registration can conflict with a software rotation advertisement
> refresh. I found that this issue was only occurring with the new
> extended MGMT advertising interface. A bad use of the
> hdev->cur_adv_instance caused every new instance to be immediately sent
> to the controller rather than queued for software rotation, opening a
> path for the race to occur.
> 
> This series improves the way new extended advertising hci callbacks
> track the relevant adv handle, removing the need for the
> cur_adv_instance use. In a separate patch, the incorrect usage of
> cur_adv_instance is removed, to align the extended MGMT commands to the
> original add_advertising usage. The series was tested on both extended
> and non-extended bluetooth controllers to confirm that the race
> condition is resolved, and that multi- and single-advertising automated
> test scenarios are still successful.
> 
> Thanks in advance,
> Daniel
> 
> 
> Daniel Winkler (2):
>  Bluetooth: Use ext adv handle from requests in CCs
>  Bluetooth: Do not set cur_adv_instance in adv param MGMT request
> 
> net/bluetooth/hci_event.c | 16 +++++++---------
> net/bluetooth/mgmt.c      |  1 -
> 2 files changed, 7 insertions(+), 10 deletions(-)

both patches have been applied to bluetooth-next tree.

Regards

Marcel

