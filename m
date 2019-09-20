Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4882B8B61
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 09:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394955AbfITHFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 03:05:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:34825 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394945AbfITHFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 03:05:02 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 03:05:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1568963100;
        s=strato-dkim-0002; d=pixelbox.red;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=HPMb6ataDu9MwOHJX7JxT3UqxfE6RZMRznHxEGci/QU=;
        b=DzUbFbp+tYYrh5NGjmFlYOfFQbey5+C4AO8Wuzni1A5l72DIzm9KqyOApV/xNJi/Wh
        NepgGJNHmJN9uW/GRtPud9lRDAZCT0q0Lcc1xoF17xiccPMEnJdkJ93+mqNNy+uHCsYm
        991Ng1h8hj48FtiUSn+wb0OjlnwWdFGPXXVsHXbiFmPEuYBK8xUAXCMprjD37DsoIEPN
        ov+0ala5o4guw8kh8EK9I90UwV682uHFNf/eh9If7l3/szcKqOwuEANMSRqx/7UDK8Ef
        LToxHjvyb2ut0LB7buGJXcnqEvWOwzOlnWgD3OJKIl6DVKesJivp+3NSzPgGvkFzg8e7
        8LVw==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPmzDT881S1Jv9Y40I0vUpkEK3poY1KyL7e8vwUVd6rhLT+3nQPD/JTWrS4IlCVOSV0M8="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.27.0 AUTH)
        with ESMTPSA id w0149ev8K6x06mT
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 20 Sep 2019 08:59:00 +0200 (CEST)
From:   Peter Fink <pedro@pixelbox.red>
To:     netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net, linux@christ-es.de
Subject: net: usb: ax88179_178a: allow passing MAC via DTB
Date:   Fri, 20 Sep 2019 08:58:29 +0200
Message-Id: <1568962710-14845-1-git-send-email-pedro@pixelbox.red>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From: Peter Fink <pfink@christ-es.de>

I adopted the feature to pass the MAC address through device tree
from asix_devices.c (introduced in 03fc5d4) to ax88179-based devices.
Please have a look if this patch can be accepted.

I introduced a new function to avoid code duplication, but I'm not perfectly
satisfied with the function name. Suggestions welcome.

I'm not totally sure if the use of net->dev_addr and net->perm_addr
was correct in the first place or if my understanding is lacking some bits.
But I kept the existing behavior as it is working as expected.

Patch tested with 4.19, but applies cleanly on net-next.

Best regards,
Peter

--

 drivers/net/usb/ax88179_178a.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

-- 
2.7.4
