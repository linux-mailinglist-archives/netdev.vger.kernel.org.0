Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA4D2D20E0
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgLHCe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:34:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgLHCe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607394783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qNCslX/aJdULLs2YcRnurqpiDn+uw7yYttpMGsTr7kY=;
        b=ZdT2FTcjDyaVJnpk0RNPIkk2embOblSg/DEpwfGTBy2sF5ehsZYP9+MO3Ob9Gd1t75cSSg
        08r59HREt+joX57SVt1pQtak9a7tS8zwYVCB8SOy9kUOnY9Yi9d84NaeCH2tDbD//UMT43
        cPQEY3QBr7lHRsaoFWH+qix6Nay84Ts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-yFZtmgQkOti-9eI7GR5opw-1; Mon, 07 Dec 2020 21:33:01 -0500
X-MC-Unique: yFZtmgQkOti-9eI7GR5opw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19A22AFA80;
        Tue,  8 Dec 2020 02:33:00 +0000 (UTC)
Received: from [10.72.12.91] (ovpn-12-91.pek2.redhat.com [10.72.12.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20E8B5C22A;
        Tue,  8 Dec 2020 02:32:52 +0000 (UTC)
Subject: Re: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
To:     wangyunjian <wangyunjian@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        xudingke <xudingke@huawei.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <094f1828-9a73-033e-b1ca-43b73588d22b@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB4E07B@dggemm513-mbx.china.huawei.com>
 <e972e42b-4344-31dc-eb4c-d963adb08a5c@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB5CD27@DGGEMM533-MBX.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b70d75f3-d717-4cd6-4966-299916a223c3@redhat.com>
Date:   Tue, 8 Dec 2020 10:32:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB5CD27@DGGEMM533-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/7 下午9:38, wangyunjian wrote:
> I think the newly added code is easy to miss this problem, so I want to
> copy ubuf_info until we're sure there's no errors.
>
> Thanks,
> Yunjian


But isn't this actually a disabling of zerocopy?

Thanks


