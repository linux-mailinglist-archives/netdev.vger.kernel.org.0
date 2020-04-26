Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D40D1B8D25
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDZHDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 03:03:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbgDZHDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 03:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587884620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0+g/GeTH0GPDYkRAev7qPNvYtgSpKx3yr1KGRbtER4=;
        b=duEnkYC4Okvi9AI0bjKhdmK+tlkVXIopRbL+YQHi5W1kqnNVkKgzfh3e0u6oH+1VXkMRS5
        DAd9bb96iwUiQQ1tTfuOZZK/IKP7JnHsI/zb7AFx+UvfV5Ql8+9Sk8k+sQiqtszOPJ9FjL
        AWoOLO0LF3gDL0WpgJOQKjtBSaLQeDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-akSujXFqO_it7sC_Ec1N1g-1; Sun, 26 Apr 2020 03:03:37 -0400
X-MC-Unique: akSujXFqO_it7sC_Ec1N1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86FF6108BD10;
        Sun, 26 Apr 2020 07:03:36 +0000 (UTC)
Received: from [10.72.13.103] (ovpn-13-103.pek2.redhat.com [10.72.13.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C22375D714;
        Sun, 26 Apr 2020 07:03:30 +0000 (UTC)
Subject: Re: [PATCH V2 1/2] vdpa: Support config interrupt in vhost_vdpa
From:   Jason Wang <jasowang@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587881384-2133-1-git-send-email-lingshan.zhu@intel.com>
 <1587881384-2133-2-git-send-email-lingshan.zhu@intel.com>
 <055fb826-895d-881b-719c-228d0cc9a7bf@redhat.com>
Message-ID: <e345cc85-aa9d-1173-8308-f0a301fca2b2@redhat.com>
Date:   Sun, 26 Apr 2020 15:03:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <055fb826-895d-881b-719c-228d0cc9a7bf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=882:58, Jason Wang wrote:
>>
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index 1813821..8663139 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -18,6 +18,8 @@
>> =C2=A0 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>> =C2=A0 =C2=A0 #define VHOST_WORK_QUEUED 1
>> +#define VHOST_FILE_UNBIND -1
>
>
> I think it's better to document this in uapi.=20


I meant e.g in vhost_vring_file, we had a comment of unbinding:

struct vhost_vring_file {
 =C2=A0=C2=A0=C2=A0 unsigned int index;
 =C2=A0=C2=A0=C2=A0 int fd; /* Pass -1 to unbind from file. */

};

Thanks

