Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8052B89E8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgKSB4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:56:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:41563 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbgKSB4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:56:08 -0500
IronPort-SDR: 5jYj6f6GEeU7UA4MKGr/qqcATx9tM7lhzFVUXjzWYorY9ZfdbbxBOoxhKhl0U4S97LYWz0BXbi
 bF3jLsURtPwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="158988146"
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="158988146"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 17:56:07 -0800
IronPort-SDR: 4AnvtfinjYtRhDqiBhXalGkKWDJ1Pyl5hrE/PDn7aeiwwGKivuuTq+Y10v482k9l03gkt5YMd0
 djz3gXcwTaFA==
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="534568164"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.213.162.22]) ([10.213.162.22])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 17:56:06 -0800
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     David Ahern <dsahern@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
 <BY5PR12MB4322863EA236F30C9E542F00DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c409964b-3f07-cac9-937c-4062f879cb85@intel.com>
 <5ddfcf07-2d3c-17ac-2db8-4f657506c2fd@gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <adb929da-44f9-5011-590c-17108ab44bcb@intel.com>
Date:   Wed, 18 Nov 2020 17:56:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <5ddfcf07-2d3c-17ac-2db8-4f657506c2fd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 5:17 PM, David Ahern wrote:
> On 11/18/20 5:41 PM, Jacob Keller wrote:
>>
>>
>> On 11/18/2020 11:22 AM, Parav Pandit wrote:
>>>
>>>
>>>> From: David Ahern <dsahern@gmail.com>
>>>> Sent: Wednesday, November 18, 2020 11:33 PM
>>>>
>>>>
>>>> With Connectx-4 Lx for example the netdev can have at most 63 queues
>>>> leaving 96 cpu servers a bit short - as an example of the limited number of
>>>> queues that a nic can handle (or currently exposes to the OS not sure which).
>>>> If I create a subfunction for ethernet traffic, how many queues are allocated
>>>> to it by default, is it managed via ethtool like the pf and is there an impact to
>>>> the resources used by / available to the primary device?
>>>
>>> Jason already answered it with details.
>>> Thanks a lot Jason.
>>>
>>> Short answer to ethtool question, yes, ethtool can change num queues for subfunction like PF.
>>> Default is same number of queues for subfunction as that of PF in this patchset.
>>>
>>
>> But what is the mechanism for partitioning the global resources of the
>> device into each sub function?
>>
>> Is it just evenly divided into the subfunctions? is there some maximum
>> limit per sub function?
>>
> 
> I hope it is not just evenly divided; it should be user controllable. If
> I create a subfunction for say a container's networking, I may want to
> only assign 1 Rx and 1 Tx queue pair (or 1 channel depending on
> terminology where channel includes Rx, Tx and CQ).

I think we need a way to expose and configure policy for resources 
associated with each type of auxiliary device.
   For ex: default, min and max queues and interrupt vectors.

Once an auxiliary device is created, the user should be able to 
configure the resources within the allowed min-max values.


