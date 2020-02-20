Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D7316571A
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 06:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgBTFl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 00:41:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22875 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgBTFl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 00:41:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582177317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dk7nO3eus3Qsrx672fVvPd5BCNrZvdvTd4N3N3NS2ik=;
        b=Zr5ZpqkRRPlCOTbWehuol8bVKlpfMKVIai9PaafJuJGECJ9cIqfhzOXbuQx0hpzmP7ZjFu
        OrwsGDZIJlVu+Qp2U0vClkobtWCF+vIuf//jJiX0HENc1VrRXtwlqE02PTNLTxsQFjBBzc
        9VNzOo5CkFlQu8L/VLl5vJBbaQcAsuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-j24KzrmjOpmMROsYrT9cjA-1; Thu, 20 Feb 2020 00:41:55 -0500
X-MC-Unique: j24KzrmjOpmMROsYrT9cjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAF7E18A6EC1;
        Thu, 20 Feb 2020 05:41:52 +0000 (UTC)
Received: from [10.72.12.159] (ovpn-12-159.pek2.redhat.com [10.72.12.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3789D1001B28;
        Thu, 20 Feb 2020 05:41:30 +0000 (UTC)
Subject: Re: [PATCH V3 5/5] vdpasim: vDPA device simulator
To:     Randy Dunlap <rdunlap@infradead.org>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200220035650.7986-1-jasowang@redhat.com>
 <20200220035650.7986-6-jasowang@redhat.com>
 <ee917060-da84-e94d-df99-208100345b14@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c1d82c5c-11f8-1bfc-ecc9-71093d0bec91@redhat.com>
Date:   Thu, 20 Feb 2020 13:41:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ee917060-da84-e94d-df99-208100345b14@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8812:09, Randy Dunlap wrote:
> On 2/19/20 7:56 PM, Jason Wang wrote:
>> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
>> index 7a99170e6c30..e3656b722654 100644
>> --- a/drivers/virtio/vdpa/Kconfig
>> +++ b/drivers/virtio/vdpa/Kconfig
>> @@ -7,3 +7,21 @@ config VDPA
>>             datapath which complies with virtio specifications with
>>             vendor specific control path.
>>  =20
>> +menuconfig VDPA_MENU
>> +	bool "VDPA drivers"
>> +	default n
>> +
>> +if VDPA_MENU
>> +
>> +config VDPA_SIM
>> +	tristate "vDPA device simulator"
>> +        select VDPA
>> +        depends on RUNTIME_TESTING_MENU
>> +        default n
>> +        help
>> +          vDPA networking device simulator which loop TX traffic back
>> +          to RX. This device is used for testing, prototyping and
>> +          development of vDPA.
>> +
>> +endif # VDPA_MENU
>> +
> Use 1 tab for indentation for tristate/select/depends/default/help,
> and then 1 tab + 2 spaces for help text.


Yes.

Thanks


>

