Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69432B896C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgKSBRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgKSBRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:17:08 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD5C0613D4;
        Wed, 18 Nov 2020 17:17:07 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j23so4193895iog.6;
        Wed, 18 Nov 2020 17:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1jsKXTlpEi6e+N2Z73mAs09Ft2GKdpOV4PvphAMgkc4=;
        b=XQGahpz3rmWWtyrT9qZTkbriE3fA9MxDgw0SxZjCHeYzYQGJgwjtE+gY28a+HC0TjW
         kXlrpbqHe4J8Swb+rXg0YjhxRADqm+1CsFS78GemC8L9NHMNVvrj9tTFHaiw7ncceLwn
         GgfmudeVP5ha+wDXVq7oUcT2lrzpJT/8UO16d67KnxIGo8u6b3aomjEZw4ju824EXF5V
         SCpJFHFzRP+gjFk6kZlaBKCH2eVtU5XP5xcka4op95EMq68jOcIewgSObtN6k9n/d0sC
         eZjfsamqV4nlW5S84+2GTh6Trrfn607hRFOt4Aw8C2uadX5mbdf/Cz6hFdWSEpWIKUqW
         mehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1jsKXTlpEi6e+N2Z73mAs09Ft2GKdpOV4PvphAMgkc4=;
        b=CLDah+kxKhPGxVT7xPTTTPDexqvGKomGr96asbQxLQwUoKZ8Uasp0oD6PGpre04Vbp
         WE4MfKTUN1aCVjhEmmEs0SmiuB1msYvilsaZfD2oQ8lPdqOP46x0M2lWatssGUqARWL7
         MwwiljI3CT8IP81/Me3dpnMO4i1JXlpb+P2Gy2VnoYPUC5kYjpHRZbJMd/6EVr6fj0O5
         NoO4vIyXo5HjDMsRo0kpRrnRRDs1N82GJ/jHj3JFD1AqKezxD1sinoRUxF511eYw0SCJ
         VjtcEUq0UKxvJxW8mAfXgRsRMmBRtKtX9GEkSXsUSMcZqeZRlmDvGLMLlFf4GwGpTMwC
         7l4A==
X-Gm-Message-State: AOAM532QCqBPnBuM+u1IvBb0oPu9+YhX4+s1uIXhZ277SNy3pyfn4QzY
        hV6Y0zWP/FsD7Lvid5fqDGc=
X-Google-Smtp-Source: ABdhPJyJ30Y6BeNZZVkHxzudlvAmX1PcuYieFiiTEAQQQ0ujGfiFwlg67I33StCk67wFxdsblgjHnw==
X-Received: by 2002:a5e:a613:: with SMTP id q19mr17897903ioi.110.1605748626632;
        Wed, 18 Nov 2020 17:17:06 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id f18sm14681487ill.22.2020.11.18.17.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 17:17:05 -0800 (PST)
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Jacob Keller <jacob.e.keller@intel.com>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ddfcf07-2d3c-17ac-2db8-4f657506c2fd@gmail.com>
Date:   Wed, 18 Nov 2020 18:17:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <c409964b-3f07-cac9-937c-4062f879cb85@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 5:41 PM, Jacob Keller wrote:
> 
> 
> On 11/18/2020 11:22 AM, Parav Pandit wrote:
>>
>>
>>> From: David Ahern <dsahern@gmail.com>
>>> Sent: Wednesday, November 18, 2020 11:33 PM
>>>
>>>
>>> With Connectx-4 Lx for example the netdev can have at most 63 queues
>>> leaving 96 cpu servers a bit short - as an example of the limited number of
>>> queues that a nic can handle (or currently exposes to the OS not sure which).
>>> If I create a subfunction for ethernet traffic, how many queues are allocated
>>> to it by default, is it managed via ethtool like the pf and is there an impact to
>>> the resources used by / available to the primary device?
>>
>> Jason already answered it with details.
>> Thanks a lot Jason.
>>
>> Short answer to ethtool question, yes, ethtool can change num queues for subfunction like PF.
>> Default is same number of queues for subfunction as that of PF in this patchset.
>>
> 
> But what is the mechanism for partitioning the global resources of the
> device into each sub function?
> 
> Is it just evenly divided into the subfunctions? is there some maximum
> limit per sub function?
> 

I hope it is not just evenly divided; it should be user controllable. If
I create a subfunction for say a container's networking, I may want to
only assign 1 Rx and 1 Tx queue pair (or 1 channel depending on
terminology where channel includes Rx, Tx and CQ).
