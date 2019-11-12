Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA12F8ACE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKLIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:40:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:2928 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfKLIkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 03:40:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 00:40:23 -0800
X-IronPort-AV: E=Sophos;i="5.68,295,1569308400"; 
   d="scan'208";a="198005697"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Nov 2019 00:40:19 -0800
Subject: Re: [PATCH 2/2] IFC VDPA layer
To:     Mark D Rustad <mrustad@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
 <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
 <A48EFA5D-56C6-404B-96FF-75736FCFD11E@gmail.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <8df224df-f8f3-54f5-e8c3-ea3ad04f6eda@linux.intel.com>
Date:   Tue, 12 Nov 2019 16:40:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <A48EFA5D-56C6-404B-96FF-75736FCFD11E@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mark,

Thanks for your comments, I will change the lines in next patchset.

Thanks,
BR
Zhu Lingshan
On 11/10/2019 3:56 AM, Mark D Rustad wrote:
> On Nov 5, 2019, at 1:37 AM, Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
>> This commit introduced IFC operations for vdpa, which complys to
>> virtio_mdev and vhost_mdev interfaces, handles IFC VF
>> initialization, configuration and removal.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>  drivers/vhost/ifcvf/ifcvf_main.c | 605 
>> +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 605 insertions(+)
>>  create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>>
>> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c 
>> b/drivers/vhost/ifcvf/ifcvf_main.c
>> new file mode 100644
>> index 0000000..7165457
>> --- /dev/null
>> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
>> @@ -0,0 +1,605 @@
>
> <snip>
>
>> +    for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>> +        if (!vf->vring[i].ready) {
>> +            IFC_ERR(ifcvf->dev,
>> +                "Failed to start datapath, vring %d not ready.\n", i);
>> +            return -EINVAL;
>> +        }
>> +
>> +        if (!vf->vring[i].size) {
>> +            IFC_ERR(ifcvf->dev,
>> +                "Failed to start datapath, vring %d size is 
>> zero.\n", i);
>> +            return -EINVAL;
>> +        }
>> +
>> +        if (!vf->vring[i].desc || !vf->vring[i].avail ||
>> +            !vf->vring[i].used) {
>> +            IFC_ERR(ifcvf->dev,
>> +                "Failed to start datapath, "
>> +                "invaild value for vring %d desc,"
>> +                "avail_idx or usex_idx.\n", i);
>
> Please don't break up the format string. Start it on the second line 
> and let it run as long as it needs to. Also you will find that it is 
> improperly spaced as it is. It makes it easier to grep the source to 
> find the source of a message. The coding style has an explicit 
> exception for such long lines for this reason.
>
> Also, please don't put .'s on the end of log messages. It serves no 
> purpose and just adds to the log, the binary size and the source size. 
> There are quite a few of these.
>
> <snip>
>
> -- 
> Mark Rustad, MRustad@gmail.com
